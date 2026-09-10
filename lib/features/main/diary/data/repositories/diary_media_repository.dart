import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/main/diary/data/models/diary_media_models.dart';

final diaryMediaRepositoryProvider = Provider<DiaryMediaRepository>((ref) {
  return DiaryMediaRepository();
});

/// 한도 초과로 업로드가 거부됨 (서버 402)
///
/// 남은 용량을 함께 담아, 화면이 "이번 달 남은 용량 N MB"를 그 자리에서
/// 안내할 수 있게 한다.
class QuotaExceededException implements Exception {
  final MediaQuota? quota;
  final String message;

  const QuotaExceededException({this.quota, required this.message});

  @override
  String toString() => message;
}

/// 파일 1개 최대 크기 초과 (413)
class FileTooLargeException implements Exception {
  final String message;
  const FileTooLargeException(this.message);

  @override
  String toString() => message;
}

/// 상위 등급에서만 가능한 첨부 (403)
class MediaNotAllowedException implements Exception {
  final String message;
  const MediaNotAllowedException(this.message);

  @override
  String toString() => message;
}

/// 서버가 받지 않는 형식 (400)
class UnsupportedMediaException implements Exception {
  final String message;
  const UnsupportedMediaException(this.message);

  @override
  String toString() => message;
}

/// 영상이 너무 길다 (400)
///
/// 서버가 등급별 최대 길이를 함께 주므로, 화면에서 "최대 60초까지"처럼
/// 구체적으로 안내할 수 있다.
class VideoTooLongException implements Exception {
  final int? maxDurationMs;
  final String message;

  const VideoTooLongException({this.maxDurationMs, required this.message});

  @override
  String toString() => message;
}

class DiaryMediaRepository {
  final Dio _dio = ApiClient.instance.dio;

  /// R2 직접 업로드용 Dio
  ///
  /// 앱의 공용 Dio에는 인증 헤더 인터셉터와 baseUrl이 붙어 있다. presigned URL은
  /// 서명 자체가 인증이므로 **Authorization 헤더를 R2로 보내면 안 된다**
  /// (토큰 유출이자, 서명 검증이 깨질 수 있다). 그래서 별도 인스턴스를 쓴다.
  final Dio _uploadDio = Dio();

  static const String _base = '/diaries/media';

  /// 현재 한도 상태 조회
  Future<MediaQuota> getQuota() async {
    try {
      final response = await _dio.get('$_base/quota');
      return MediaQuota.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [DiaryMediaRepository] 한도 조회 실패: ${e.message}');
      throw Exception('한도 조회 실패: ${e.message}');
    }
  }

  /// 업로드 자리 예약 + presigned URL 발급
  Future<MediaReservation> reserve(ReserveMediaDto dto) async {
    try {
      final response = await _dio.post('$_base/reserve', data: dto.toJson());
      return MediaReservation.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapUploadError(e);
    }
  }

  /// presigned URL로 R2에 직접 업로드
  ///
  /// 백엔드를 경유하지 않는다 — 200MB 영상을 서버로 릴레이하면 타임아웃과
  /// 메모리가 그대로 한계가 된다.
  Future<void> uploadToStorage({
    required String uploadUrl,
    required Uint8List bytes,
    required String mimeType,
    void Function(int sent, int total)? onProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      await _uploadDio.put(
        uploadUrl,
        data: _bodyFor(bytes),
        options: Options(headers: _uploadHeaders(mimeType, bytes.length)),
        onSendProgress: onProgress,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      debugPrint('❌ [DiaryMediaRepository] R2 업로드 실패: ${e.message}');
      throw Exception('업로드에 실패했습니다: ${e.message}');
    }
  }

  /// 썸네일을 R2에 올린다 (실패해도 예외를 던지지 않는다)
  ///
  /// 썸네일이 없어도 서버는 확정을 성공시킨다. 본체가 올라갔는데 썸네일 때문에
  /// 업로드 전체가 날아가는 쪽이 훨씬 나쁘므로, 여기서 조용히 삼킨다.
  Future<void> uploadThumbnail({
    required String uploadUrl,
    required Uint8List bytes,
    CancelToken? cancelToken,
  }) async {
    try {
      await _uploadDio.put(
        uploadUrl,
        data: _bodyFor(bytes),
        // 서버와 합의한 규격 — JPEG 고정
        options: Options(headers: _uploadHeaders('image/jpeg', bytes.length)),
        cancelToken: cancelToken,
      );
    } catch (e) {
      debugPrint('⚠️ [DiaryMediaRepository] 썸네일 업로드 실패(무시): $e');
    }
  }

  /// 업로드 완료 확정
  ///
  /// 서버가 HeadObject로 실제 크기를 재고, 신고값보다 크면 여기서 402가 난다.
  Future<MediaConfirmResult> confirm(String mediaId) async {
    try {
      final response = await _dio.post('$_base/$mediaId/confirm');
      return MediaConfirmResult.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapUploadError(e);
    }
  }

  /// 미디어 삭제 (R2에서 즉시·영구 삭제)
  Future<void> delete(String mediaId) async {
    try {
      await _dio.delete('$_base/$mediaId');
    } on DioException catch (e) {
      debugPrint('❌ [DiaryMediaRepository] 미디어 삭제 실패: ${e.message}');
      throw Exception('첨부 삭제에 실패했습니다: ${e.message}');
    }
  }

  /// 첨부 순서 변경
  ///
  /// [mediaIds]는 **한 일기의 전체 첨부**를 표시할 순서대로 나열한 것이다.
  /// 서버가 소유 일기를 미디어에서 역추적하므로 diaryId는 보내지 않는다.
  Future<void> reorder(List<String> mediaIds) async {
    try {
      await _dio.patch('$_base/reorder', data: {'mediaIds': mediaIds});
    } on DioException catch (e) {
      debugPrint('❌ [DiaryMediaRepository] 순서 변경 실패: ${e.message}');
      throw Exception('순서 변경에 실패했습니다: ${e.message}');
    }
  }

  /// 용량 큰 미디어 목록 (저장공간 관리 화면)
  Future<List<LargeMediaItem>> getLargeMedia({
    int limit = 20,
    bool onlyOriginal = false,
  }) async {
    try {
      final response = await _dio.get('$_base/large', queryParameters: {
        'limit': limit,
        if (onlyOriginal) 'onlyOriginal': true,
      });
      final items = (response.data as Map<String, dynamic>)['items'] as List?;
      return (items ?? [])
          .map((e) => LargeMediaItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      debugPrint('❌ [DiaryMediaRepository] 큰 파일 조회 실패: ${e.message}');
      throw Exception('저장 공간 조회에 실패했습니다: ${e.message}');
    }
  }

  /// R2로 보낼 요청 바디
  ///
  /// 브라우저 어댑터는 스트림 바디를 다루지 못하므로 웹에서는 바이트를 그대로
  /// 넘긴다. 모바일에서 스트림을 쓰는 이유는 큰 파일을 한 번에 메모리에
  /// 올리지 않기 위해서다.
  Object _bodyFor(Uint8List bytes) =>
      kIsWeb ? bytes : Stream.fromIterable([bytes]);

  /// presigned PUT 헤더
  ///
  /// **웹에서는 Content-Length를 직접 붙이면 안 된다.** 브라우저가 금지된
  /// 헤더로 보고 요청을 거부한다 — 길이는 브라우저가 알아서 채운다.
  Map<String, dynamic> _uploadHeaders(String mimeType, int length) => {
        'Content-Type': mimeType,
        if (!kIsWeb) Headers.contentLengthHeader: length,
      };

  /// 업로드 계열 에러를 화면이 분기할 수 있는 타입으로 바꾼다
  ///
  /// 사유마다 제시할 대안이 다르다 — 한도 초과는 "정리하기", 파일이 크면
  /// "압축하기", 영상 불가는 "업그레이드". 결제만 있는 막다른 안내를 피하려면
  /// 여기서 구분해둬야 한다.
  Exception _mapUploadError(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;

    debugPrint('❌ [DiaryMediaRepository] 업로드 오류($status): ${e.message}');

    switch (status) {
      case 402:
        MediaQuota? quota;
        if (data is Map<String, dynamic> && data['quota'] != null) {
          try {
            quota = MediaQuota.fromJson(data['quota'] as Map<String, dynamic>);
          } catch (_) {
            // 한도 파싱이 실패해도 402라는 사실은 전달해야 한다
          }
        }
        return QuotaExceededException(
          quota: quota,
          message: '이번 달 업로드 용량을 모두 사용했어요',
        );
      case 413:
        return const FileTooLargeException('파일 크기가 너무 큽니다');
      case 403:
        return const MediaNotAllowedException(
          '이 첨부는 상위 요금제에서 이용할 수 있어요',
        );
      case 400:
        // 영상 길이 초과일 때만 maxVideoDurationMs가 함께 온다.
        // 그 값으로 형식 오류와 길이 초과를 가른다.
        final maxDurationMs = data is Map<String, dynamic>
            ? data['maxVideoDurationMs'] as int?
            : null;
        if (maxDurationMs != null) {
          return VideoTooLongException(
            maxDurationMs: maxDurationMs,
            message: '영상이 너무 깁니다',
          );
        }
        return const UnsupportedMediaException('지원하지 않는 형식입니다');
      default:
        return Exception('업로드에 실패했습니다: ${e.message}');
    }
  }
}
