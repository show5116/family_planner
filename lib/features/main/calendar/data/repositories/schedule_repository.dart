import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/main/calendar/data/models/schedule_model.dart';

/// 일정 Repository Provider
final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  return ScheduleRepository();
});

/// 일정 Repository
class ScheduleRepository {
  final Dio _dio = ApiClient.instance.dio;

  ScheduleRepository();

  /// 월간 일정 조회
  /// [year]: 연도
  /// [month]: 월 (1-12)
  /// [memberId]: 특정 멤버 일정만 필터링 (선택)
  Future<List<ScheduleModel>> getMonthlySchedules({
    required int year,
    required int month,
    String? memberId,
  }) async {
    try {
      final response = await _dio.get('/schedules', queryParameters: {
        'year': year,
        'month': month,
        if (memberId != null) 'memberId': memberId,
      });

      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return (data['data'] as List<dynamic>)
            .map((e) => ScheduleModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      return (data as List<dynamic>)
          .map((e) => ScheduleModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      debugPrint('❌ [ScheduleRepository] 월간 일정 조회 실패: ${e.message}');
      throw Exception('일정 조회 실패: ${e.message}');
    }
  }

  /// 기간별 일정 조회
  Future<List<ScheduleModel>> getSchedulesByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    String? memberId,
  }) async {
    try {
      final response = await _dio.get('/schedules', queryParameters: {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        if (memberId != null) 'memberId': memberId,
      });

      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return (data['data'] as List<dynamic>)
            .map((e) => ScheduleModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      return (data as List<dynamic>)
          .map((e) => ScheduleModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      debugPrint('❌ [ScheduleRepository] 기간별 일정 조회 실패: ${e.message}');
      throw Exception('일정 조회 실패: ${e.message}');
    }
  }

  /// 일정 상세 조회
  Future<ScheduleModel> getScheduleById(String id) async {
    try {
      final response = await _dio.get('/schedules/$id');
      return ScheduleModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('일정을 찾을 수 없습니다');
      }
      throw Exception('일정 조회 실패: ${e.message}');
    }
  }

  /// 일정 생성
  Future<ScheduleModel> createSchedule(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/schedules', data: data);
      return ScheduleModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('❌ [ScheduleRepository] 일정 생성 실패: ${e.message}');
      throw Exception('일정 생성 실패: ${e.message}');
    }
  }

  /// 일정 수정
  Future<ScheduleModel> updateSchedule(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.put('/schedules/$id', data: data);
      return ScheduleModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('일정을 찾을 수 없습니다');
      }
      throw Exception('일정 수정 실패: ${e.message}');
    }
  }

  /// 일정 삭제
  Future<void> deleteSchedule(String id) async {
    try {
      await _dio.delete('/schedules/$id');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('일정을 찾을 수 없습니다');
      }
      throw Exception('일정 삭제 실패: ${e.message}');
    }
  }

  /// 반복 일정 삭제 옵션
  /// [deleteType]: 'this' (이 일정만), 'thisAndFuture' (이후 모든 일정), 'all' (전체)
  Future<void> deleteRecurringSchedule(
    String id, {
    required String deleteType,
    DateTime? fromDate,
  }) async {
    try {
      await _dio.delete('/schedules/$id/recurring', queryParameters: {
        'deleteType': deleteType,
        if (fromDate != null) 'fromDate': fromDate.toIso8601String(),
      });
    } on DioException catch (e) {
      throw Exception('반복 일정 삭제 실패: ${e.message}');
    }
  }
}
