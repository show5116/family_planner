import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/announcements/data/models/announcement_model.dart';
import 'package:family_planner/features/announcements/data/dto/announcement_dto.dart';

/// 공지사항 Repository Provider
final announcementRepositoryProvider = Provider<AnnouncementRepository>((ref) {
  return AnnouncementRepository();
});

/// 공지사항 Repository
class AnnouncementRepository {
  final Dio _dio = ApiClient.instance.dio;

  AnnouncementRepository();

  /// 공지사항 목록 조회
  /// [page]: 페이지 번호 (기본값: 1)
  /// [limit]: 페이지당 개수 (기본값: 20)
  /// [pinnedOnly]: 고정 공지만 조회 (기본값: false)
  Future<AnnouncementListResponse> getAnnouncements({
    int page = 1,
    int limit = 20,
    bool pinnedOnly = false,
  }) async {
    try {
      debugPrint('🔵 [AnnouncementRepository] 공지사항 목록 조회 API 호출');
      debugPrint('  - Page: $page, Limit: $limit, PinnedOnly: $pinnedOnly');

      final response = await _dio.get('/announcements', queryParameters: {
        'page': page,
        'limit': limit,
        if (pinnedOnly) 'pinnedOnly': true,
      });

      debugPrint('✅ [AnnouncementRepository] 공지사항 목록 조회 성공');
      return AnnouncementListResponse.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('❌ [AnnouncementRepository] 공지사항 목록 조회 실패: ${e.message}');
      throw Exception('공지사항 목록 조회 실패: ${e.message}');
    }
  }

  /// 공지사항 상세 조회 (조회 시 자동 읽음 처리)
  Future<AnnouncementModel> getAnnouncementById(String id) async {
    try {
      debugPrint('🔵 [AnnouncementRepository] 공지사항 상세 조회 API 호출: $id');

      final response = await _dio.get('/announcements/$id');

      debugPrint('✅ [AnnouncementRepository] 공지사항 상세 조회 성공');
      return AnnouncementModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('❌ [AnnouncementRepository] 공지사항 상세 조회 실패: ${e.message}');
      if (e.response?.statusCode == 404) {
        throw Exception('공지사항을 찾을 수 없습니다');
      }
      throw Exception('공지사항 조회 실패: ${e.message}');
    }
  }

  /// 공지사항 작성 (ADMIN 전용)
  Future<AnnouncementModel> createAnnouncement(
      CreateAnnouncementDto dto) async {
    try {
      debugPrint('🔵 [AnnouncementRepository] 공지사항 작성 API 호출');
      debugPrint('  - Title: ${dto.title}');
      debugPrint('  - IsPinned: ${dto.isPinned}');

      final response = await _dio.post('/announcements', data: dto.toJson());

      debugPrint('✅ [AnnouncementRepository] 공지사항 작성 성공');
      return AnnouncementModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('❌ [AnnouncementRepository] 공지사항 작성 실패: ${e.message}');
      throw Exception('공지사항 작성 실패: ${e.message}');
    }
  }

  /// 공지사항 수정 (ADMIN 전용)
  Future<AnnouncementModel> updateAnnouncement(
    String id,
    CreateAnnouncementDto dto,
  ) async {
    try {
      debugPrint('🔵 [AnnouncementRepository] 공지사항 수정 API 호출: $id');

      final response = await _dio.put('/announcements/$id', data: dto.toJson());

      debugPrint('✅ [AnnouncementRepository] 공지사항 수정 성공');
      return AnnouncementModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('❌ [AnnouncementRepository] 공지사항 수정 실패: ${e.message}');
      if (e.response?.statusCode == 404) {
        throw Exception('공지사항을 찾을 수 없습니다');
      }
      throw Exception('공지사항 수정 실패: ${e.message}');
    }
  }

  /// 공지사항 삭제 (ADMIN 전용)
  Future<void> deleteAnnouncement(String id) async {
    try {
      debugPrint('🔵 [AnnouncementRepository] 공지사항 삭제 API 호출: $id');

      await _dio.delete('/announcements/$id');

      debugPrint('✅ [AnnouncementRepository] 공지사항 삭제 성공');
    } on DioException catch (e) {
      debugPrint('❌ [AnnouncementRepository] 공지사항 삭제 실패: ${e.message}');
      if (e.response?.statusCode == 404) {
        throw Exception('공지사항을 찾을 수 없습니다');
      }
      throw Exception('공지사항 삭제 실패: ${e.message}');
    }
  }

  /// 공지사항 고정/해제 (ADMIN 전용)
  Future<AnnouncementModel> togglePin(String id, bool isPinned) async {
    try {
      debugPrint(
          '🔵 [AnnouncementRepository] 공지사항 고정/해제 API 호출: $id, isPinned: $isPinned');

      final response = await _dio.patch(
        '/announcements/$id/pin',
        data: TogglePinDto(isPinned: isPinned).toJson(),
      );

      debugPrint('✅ [AnnouncementRepository] 공지사항 고정/해제 성공');
      return AnnouncementModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('❌ [AnnouncementRepository] 공지사항 고정/해제 실패: ${e.message}');
      if (e.response?.statusCode == 404) {
        throw Exception('공지사항을 찾을 수 없습니다');
      }
      throw Exception('공지사항 고정/해제 실패: ${e.message}');
    }
  }
}
