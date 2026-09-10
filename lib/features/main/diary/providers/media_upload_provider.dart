import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/features/main/diary/data/models/diary_media_models.dart';
import 'package:family_planner/features/main/diary/data/repositories/diary_media_repository.dart';
import 'package:family_planner/features/main/diary/data/utils/media_compressor.dart';
import 'package:family_planner/features/main/diary/providers/diary_provider.dart';
import 'package:family_planner/features/main/diary/providers/media_quota_provider.dart';

/// 압축 선택까지 끝나 업로드 준비가 된 항목
///
/// 압축 선택 시트가 두 가지 결과(압축본·원본)를 실제로 만들어보고 사용자가 고른
/// 쪽을 이 형태로 넘긴다. 큐에 넣을 때 다시 압축하지 않기 위한 것이다 —
/// 사진 여러 장을 두 번 압축하면 시트가 눈에 띄게 느려진다.
class PreparedMedia {
  final Uint8List bytes;
  final String fileName;
  final String mimeType;
  final MediaType type;

  /// 압축 전 크기 (압축하지 않았으면 [bytes].length와 같다)
  final int originalSize;
  final bool isOriginal;
  final int? width;
  final int? height;
  final int? durationMs;

  const PreparedMedia({
    required this.bytes,
    required this.fileName,
    required this.mimeType,
    required this.type,
    required this.originalSize,
    required this.isOriginal,
    this.width,
    this.height,
    this.durationMs,
  });

  int get size => bytes.length;
}

/// 업로드 대기/진행 항목
///
/// 압축까지 마친 상태로 만들어진다 — 압축 후 크기를 알아야 한도 예약이 가능하고,
/// 사용자에게도 "압축하면 얼마가 되는지"를 실제 값으로 보여줄 수 있다.
class PendingUpload {
  /// 화면에서 항목을 구분하기 위한 로컬 id (서버 mediaId와 별개)
  final String localId;
  final Uint8List bytes;
  final String fileName;
  final String mimeType;
  final MediaType type;
  final int originalSize;
  final bool isOriginal;
  final int? width;
  final int? height;
  final int? durationMs;

  /// 0.0 ~ 1.0
  final double progress;
  final bool isUploading;

  /// 실패 원인 (예외 객체 그대로)
  ///
  /// 문자열이 아니라 객체로 들고 있는다 — 사유마다 안내 문구가 다른데,
  /// 레포지토리에서 문장을 만들면 다국어 처리를 할 수 없다.
  final Object? error;

  /// 업로드 확정 후 채워진다
  final DiaryMedia? uploaded;

  const PendingUpload({
    required this.localId,
    required this.bytes,
    required this.fileName,
    required this.mimeType,
    required this.type,
    required this.originalSize,
    this.isOriginal = false,
    this.width,
    this.height,
    this.durationMs,
    this.progress = 0,
    this.isUploading = false,
    this.error,
    this.uploaded,
  });

  int get size => bytes.length;
  bool get isDone => uploaded != null;
  bool get hasError => error != null;

  PendingUpload copyWith({
    double? progress,
    bool? isUploading,
    Object? error,
    bool clearError = false,
    DiaryMedia? uploaded,
  }) {
    return PendingUpload(
      localId: localId,
      bytes: bytes,
      fileName: fileName,
      mimeType: mimeType,
      type: type,
      originalSize: originalSize,
      isOriginal: isOriginal,
      width: width,
      height: height,
      durationMs: durationMs,
      progress: progress ?? this.progress,
      isUploading: isUploading ?? this.isUploading,
      error: clearError ? null : (error ?? this.error),
      uploaded: uploaded ?? this.uploaded,
    );
  }
}

/// 업로드 큐 상태
class MediaUploadState {
  final List<PendingUpload> items;

  const MediaUploadState({this.items = const []});

  bool get isUploading => items.any((i) => i.isUploading);
  bool get hasErrors => items.any((i) => i.hasError);

  /// 가장 먼저 실패한 항목의 원인 (없으면 null)
  Object? get firstError =>
      items.where((i) => i.hasError).firstOrNull?.error;

  /// 아직 서버에 확정되지 않은 항목의 합 (게이지 예상치 표시용)
  int get pendingBytes =>
      items.where((i) => !i.isDone).fold(0, (sum, i) => sum + i.size);

  MediaUploadState copyWith({List<PendingUpload>? items}) =>
      MediaUploadState(items: items ?? this.items);
}

final mediaUploadProvider =
    NotifierProvider<MediaUploadNotifier, MediaUploadState>(
        MediaUploadNotifier.new);

/// 미디어 업로드 오케스트레이션
///
/// reserve → R2 직접 PUT → confirm 3단계를 관리한다. 각 단계가 따로 실패할 수
/// 있으므로 항목별로 상태와 에러를 들고 간다.
class MediaUploadNotifier extends Notifier<MediaUploadState> {
  final Map<String, CancelToken> _cancelTokens = {};
  int _localIdSeq = 0;

  @override
  MediaUploadState build() {
    ref.onDispose(() {
      for (final token in _cancelTokens.values) {
        if (!token.isCancelled) token.cancel('provider disposed');
      }
      _cancelTokens.clear();
    });
    return const MediaUploadState();
  }

  /// 고른 파일을 압축해 큐에 넣는다 (업로드는 아직 시작하지 않는다)
  ///
  /// [keepOriginal]이 true면 압축을 건너뛴다. 한도가 억제 장치이므로
  /// 원본 업로드를 막지 않는다.
  Future<PendingUpload> enqueue({
    required Uint8List bytes,
    required String fileName,
    required String mimeType,
    required MediaType type,
    bool keepOriginal = false,
    int? width,
    int? height,
    int? durationMs,
  }) async {
    final CompressionResult result;
    if (keepOriginal || type.isVideo) {
      // 영상 압축은 Phase 3(video_compress 도입) 이후에 붙인다
      result = CompressionResult.original(bytes);
    } else {
      result = await MediaCompressor.compressImage(bytes);
    }

    final item = PendingUpload(
      localId: 'local_${_localIdSeq++}',
      bytes: result.bytes,
      fileName: fileName,
      mimeType: result.mimeType,
      type: type,
      originalSize: result.originalSize,
      isOriginal: !result.compressed,
      width: width,
      height: height,
      durationMs: durationMs,
    );

    state = state.copyWith(items: [...state.items, item]);
    return item;
  }

  /// 압축 선택이 끝난 항목을 큐에 넣는다 (다시 압축하지 않는다)
  PendingUpload enqueuePrepared(PreparedMedia prepared) {
    final item = PendingUpload(
      localId: 'local_${_localIdSeq++}',
      bytes: prepared.bytes,
      fileName: prepared.fileName,
      mimeType: prepared.mimeType,
      type: prepared.type,
      originalSize: prepared.originalSize,
      isOriginal: prepared.isOriginal,
      width: prepared.width,
      height: prepared.height,
      durationMs: prepared.durationMs,
    );

    state = state.copyWith(items: [...state.items, item]);
    return item;
  }

  /// 큐에 있는 항목을 서버로 올린다
  ///
  /// 실패해도 큐에서 빼지 않는다 — 사용자가 재시도할 수 있어야 한다.
  Future<bool> upload(
    String localId, {
    String? diaryId,
    String? date,
  }) async {
    final index = state.items.indexWhere((i) => i.localId == localId);
    if (index < 0) return false;

    final item = state.items[index];
    if (item.isDone || item.isUploading) return item.isDone;

    _update(localId, (i) => i.copyWith(
          isUploading: true,
          progress: 0,
          clearError: true,
        ));

    final repo = ref.read(diaryMediaRepositoryProvider);
    final cancelToken = CancelToken();
    _cancelTokens[localId] = cancelToken;

    try {
      // 1. 한도 검증 + presigned URL 예약
      final reservation = await repo.reserve(
        ReserveMediaDto(
          diaryId: diaryId,
          date: date,
          type: item.type,
          fileName: item.fileName,
          mimeType: item.mimeType,
          declaredSize: item.size,
          originalSize:
              item.originalSize == item.size ? null : item.originalSize,
          isOriginal: item.isOriginal,
          width: item.width,
          height: item.height,
          durationMs: item.durationMs,
        ),
      );

      // 2. R2에 직접 업로드 — 본체와 썸네일을 나란히 올린다
      //
      // 썸네일은 서버가 만들 수 없어(바이트를 보지 않는 설계) 클라이언트 몫이다.
      // 본체 뒤에 순차로 붙이면 업로드 시간이 그만큼 늘어나므로 함께 보낸다.
      final thumbnailBytes = reservation.thumbnailUploadUrl == null
          ? null
          : await MediaCompressor.makeThumbnail(item.bytes);

      await Future.wait([
        repo.uploadToStorage(
          uploadUrl: reservation.uploadUrl,
          bytes: item.bytes,
          mimeType: item.mimeType,
          cancelToken: cancelToken,
          // 진행률은 본체만 센다 — 수십 KB짜리 썸네일이 섞이면 게이지가 튄다
          onProgress: (sent, total) {
            if (total <= 0) return;
            _update(localId, (i) => i.copyWith(progress: sent / total));
          },
        ),
        if (thumbnailBytes != null)
          repo.uploadThumbnail(
            uploadUrl: reservation.thumbnailUploadUrl!,
            bytes: thumbnailBytes,
            cancelToken: cancelToken,
          ),
      ]);

      // 3. 완료 확정 (서버가 실측으로 재검증 + 썸네일 존재 확인)
      final confirmed = await repo.confirm(reservation.mediaId);

      _update(localId, (i) => i.copyWith(
            isUploading: false,
            progress: 1,
            uploaded: confirmed.media,
          ));

      _invalidateQuota();
      return true;
    } catch (e) {
      if (e is DioException && CancelToken.isCancel(e)) {
        // 취소는 에러가 아니다 — 큐에서 조용히 뺀다
        remove(localId);
        return false;
      }
      debugPrint('❌ [MediaUpload] 업로드 실패: $e');
      _update(localId, (i) => i.copyWith(isUploading: false, error: e));
      // 예약만 되고 실패했을 수 있으므로 한도를 다시 읽는다
      _invalidateQuota();
      return false;
    } finally {
      _cancelTokens.remove(localId);
    }
  }

  /// 큐의 모든 미완료 항목을 순차 업로드
  ///
  /// 동시에 올리지 않는 이유: 서버가 사용자별 Redis 락으로 직렬화하므로
  /// 병렬로 보내봐야 대기만 길어지고, 진행률도 읽기 어려워진다.
  Future<void> uploadAll({String? diaryId, String? date}) async {
    final pending =
        state.items.where((i) => !i.isDone && !i.isUploading).toList();
    for (final item in pending) {
      await upload(item.localId, diaryId: diaryId, date: date);
    }
  }

  /// 진행 중인 업로드 취소
  void cancel(String localId) {
    final token = _cancelTokens[localId];
    if (token != null && !token.isCancelled) {
      token.cancel('사용자 취소');
    }
  }

  /// 큐에서 항목 제거
  ///
  /// 이미 서버에 확정된 항목이면 서버에서도 지운다.
  Future<void> remove(String localId) async {
    final index = state.items.indexWhere((i) => i.localId == localId);
    if (index < 0) return;
    final uploadedId = state.items[index].uploaded?.id;

    cancel(localId);
    state = state.copyWith(
      items: state.items.where((i) => i.localId != localId).toList(),
    );

    if (uploadedId != null) {
      try {
        await ref.read(diaryMediaRepositoryProvider).delete(uploadedId);
        _invalidateQuota();
      } catch (e) {
        debugPrint('⚠️ [MediaUpload] 서버 삭제 실패(무시): $e');
      }
    }
  }

  /// 확정된 항목만 큐에서 뺀다
  ///
  /// 첨부 흐름이 끝나면 화면이 일기 쪽 목록으로 첨부를 그리므로, 큐에 남겨두면
  /// 같은 사진이 두 번 보인다. 실패·진행 중인 항목은 재시도해야 하니 남긴다.
  void clearCompleted() {
    state = state.copyWith(
      items: state.items.where((i) => !i.isDone).toList(),
    );
  }

  /// 큐 비우기 (화면을 벗어날 때)
  ///
  /// 확정된 항목은 서버에 남는다 — 일기에 연결되지 않으면 24시간 뒤
  /// 고아 정리 스케줄러가 지운다.
  void clear() {
    for (final token in _cancelTokens.values) {
      if (!token.isCancelled) token.cancel('큐 비우기');
    }
    _cancelTokens.clear();
    state = const MediaUploadState();
  }

  /// 확정된 미디어 id 목록 (일기 저장 시 함께 보낸다)
  List<String> get confirmedMediaIds => state.items
      .where((i) => i.isDone)
      .map((i) => i.uploaded!.id)
      .toList();

  void _update(String localId, PendingUpload Function(PendingUpload) fn) {
    state = state.copyWith(
      items: state.items
          .map((i) => i.localId == localId ? fn(i) : i)
          .toList(),
    );
  }

  void _invalidateQuota() {
    ref.invalidate(mediaQuotaProvider);
    ref.invalidate(largeMediaProvider);
    ref.invalidate(todayDiaryProvider);
  }
}
