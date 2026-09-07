import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/main/diary/data/models/diary_models.dart';

final diaryRepositoryProvider = Provider<DiaryRepository>((ref) {
  return DiaryRepository();
});

class DiaryRepository {
  final Dio _dio = ApiClient.instance.dio;

  static const String _base = '/diaries';

  /// 일기 목록 조회 (페이지네이션)
  Future<DiaryListResult> getDiaries({
    int page = 1,
    int limit = 20,
    String? from,
    String? to,
    DiaryVisibility? visibility,
    String? groupId,
    String? search,
  }) async {
    try {
      final response = await _dio.get(_base, queryParameters: {
        'page': page,
        'limit': limit,
        if (from != null) 'from': from,
        if (to != null) 'to': to,
        if (visibility != null) 'visibility': visibility.toJson(),
        if (groupId != null) 'groupId': groupId,
        if (search != null && search.isNotEmpty) 'search': search,
      });
      return DiaryListResult.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [DiaryRepository] 일기 목록 조회 실패: ${e.message}');
      throw Exception('일기 목록 조회 실패: ${e.message}');
    }
  }

  /// 일기 상세 조회
  Future<DiaryModel> getDiary(String id) async {
    try {
      final response = await _dio.get('$_base/$id');
      return DiaryModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [DiaryRepository] 일기 상세 조회 실패: ${e.message}');
      throw Exception('일기 상세 조회 실패: ${e.message}');
    }
  }

  /// 특정 날짜의 내 일기 조회
  ///
  /// 해당 날짜에 일기가 없으면 **null**을 반환한다 (404는 정상 흐름).
  Future<DiaryModel?> getDiaryByDate(String date) async {
    try {
      final response = await _dio.get('$_base/by-date/$date');
      return DiaryModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      debugPrint('❌ [DiaryRepository] 날짜별 일기 조회 실패: ${e.message}');
      throw Exception('일기 조회 실패: ${e.message}');
    }
  }

  /// 월별 작성 현황 조회 (캘린더뷰용)
  Future<List<DiaryCalendarDay>> getCalendar({
    required int year,
    required int month,
    String? groupId,
  }) async {
    try {
      final response = await _dio.get('$_base/calendar', queryParameters: {
        'year': year,
        'month': month,
        if (groupId != null) 'groupId': groupId,
      });
      final days = (response.data as Map<String, dynamic>)['days'] as List?;
      return (days ?? [])
          .map((e) => DiaryCalendarDay.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      debugPrint('❌ [DiaryRepository] 캘린더 조회 실패: ${e.message}');
      throw Exception('캘린더 조회 실패: ${e.message}');
    }
  }

  /// 연속 작성일수 조회
  Future<DiaryStreak> getStreak() async {
    try {
      final response = await _dio.get('$_base/streak');
      return DiaryStreak.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [DiaryRepository] 연속 작성일수 조회 실패: ${e.message}');
      throw Exception('연속 작성일수 조회 실패: ${e.message}');
    }
  }

  /// 회고 조회 ("n개월 전 오늘")
  ///
  /// 회고는 부가 정보이므로, 실패해도 화면을 막지 않도록 **빈 목록**을 반환한다.
  Future<List<DiaryFlashbackItem>> getFlashback() async {
    try {
      final response = await _dio.get('$_base/flashback');
      final items = (response.data as Map<String, dynamic>)['items'] as List?;
      return (items ?? [])
          .map((e) => DiaryFlashbackItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      debugPrint('⚠️ [DiaryRepository] 회고 조회 실패(무시): ${e.message}');
      return [];
    }
  }

  /// 일기 생성
  Future<DiaryModel> createDiary(CreateDiaryDto dto) async {
    try {
      final response = await _dio.post(_base, data: dto.toJson());
      return DiaryModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [DiaryRepository] 일기 생성 실패: ${e.message}');
      throw Exception('일기 생성 실패: ${e.message}');
    }
  }

  /// 빠른 기록 — 그날 일기에 조각 추가 (없으면 생성)
  Future<AppendResult> append(AppendDiaryDto dto) async {
    try {
      final response = await _dio.post('$_base/append', data: dto.toJson());
      return AppendResult.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [DiaryRepository] 빠른 기록 실패: ${e.message}');
      throw Exception('기록에 실패했습니다: ${e.message}');
    }
  }

  /// 일기 수정
  Future<DiaryModel> updateDiary(String id, UpdateDiaryDto dto) async {
    try {
      final response = await _dio.patch('$_base/$id', data: dto.toJson());
      return DiaryModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [DiaryRepository] 일기 수정 실패: ${e.message}');
      throw Exception('일기 수정 실패: ${e.message}');
    }
  }

  /// 일기 삭제 (soft delete, 30일 내 복구 가능)
  Future<void> deleteDiary(String id) async {
    try {
      await _dio.delete('$_base/$id');
    } on DioException catch (e) {
      debugPrint('❌ [DiaryRepository] 일기 삭제 실패: ${e.message}');
      throw Exception('일기 삭제 실패: ${e.message}');
    }
  }

  /// 삭제한 일기 복구 (30일 이내)
  Future<DiaryModel> restoreDiary(String id) async {
    try {
      final response = await _dio.post('$_base/$id/restore');
      return DiaryModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [DiaryRepository] 일기 복구 실패: ${e.message}');
      throw Exception('일기 복구 실패: ${e.message}');
    }
  }
}
