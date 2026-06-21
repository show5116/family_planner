import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/main/task/data/models/anniversary_model.dart';

final anniversaryRepositoryProvider = Provider<AnniversaryRepository>((ref) {
  return AnniversaryRepository();
});

class AnniversaryRepository {
  final Dio _dio = ApiClient.instance.dio;

  /// 그룹 기념일 목록 조회
  Future<List<AnniversaryModel>> getAnniversaries(String groupId) async {
    try {
      final response = await _dio.get(
        '/tasks/anniversaries',
        queryParameters: {'groupId': groupId},
      );
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => AnniversaryModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [AnniversaryRepository] 기념일 목록 조회 실패: ${e.message}');
      throw Exception('기념일 조회 실패: ${e.message}');
    }
  }

  /// 기념일 단건 조회
  Future<AnniversaryModel> getAnniversaryById(String id) async {
    try {
      final response = await _dio.get('/tasks/anniversaries/$id');
      return AnniversaryModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('기념일을 찾을 수 없습니다');
      if (e.response?.statusCode == 403) throw Exception('접근 권한이 없습니다');
      throw Exception('기념일 조회 실패: ${e.message}');
    }
  }

  /// 기념일 생성
  Future<AnniversaryModel> createAnniversary({
    required String groupId,
    required String title,
    required DateTime date,
    String? emoji,
    MilestoneConfig? milestoneConfig,
  }) async {
    try {
      final response = await _dio.post('/tasks/anniversaries', data: {
        'groupId': groupId,
        'title': title,
        'date': '${date.year.toString().padLeft(4, '0')}-'
            '${date.month.toString().padLeft(2, '0')}-'
            '${date.day.toString().padLeft(2, '0')}',
        if (emoji != null) 'emoji': emoji,
        if (milestoneConfig != null) 'milestoneConfig': milestoneConfig.toJson(),
      });
      return AnniversaryModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) throw Exception('그룹 멤버만 생성할 수 있습니다');
      throw Exception('기념일 생성 실패: ${e.message}');
    }
  }

  /// 기념일 수정
  Future<AnniversaryModel> updateAnniversary(
    String id, {
    String? title,
    DateTime? date,
    String? emoji,
    MilestoneConfig? milestoneConfig,
  }) async {
    try {
      final response = await _dio.put('/tasks/anniversaries/$id', data: {
        if (title != null) 'title': title,
        if (date != null)
          'date': '${date.year.toString().padLeft(4, '0')}-'
              '${date.month.toString().padLeft(2, '0')}-'
              '${date.day.toString().padLeft(2, '0')}',
        if (emoji != null) 'emoji': emoji,
        if (milestoneConfig != null) 'milestoneConfig': milestoneConfig.toJson(),
      });
      return AnniversaryModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('기념일을 찾을 수 없습니다');
      if (e.response?.statusCode == 403) throw Exception('수정 권한이 없습니다');
      throw Exception('기념일 수정 실패: ${e.message}');
    }
  }

  /// 기념일 삭제
  ///
  /// [deleteWithTasks] true면 연동된 milestone Task까지 cascade 삭제,
  /// false(기본)면 Task는 유지하고 anniversaryId만 null 처리
  Future<void> deleteAnniversary(String id, {bool deleteWithTasks = false}) async {
    try {
      await _dio.delete(
        '/tasks/anniversaries/$id',
        queryParameters: {'deleteWithTasks': deleteWithTasks},
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('기념일을 찾을 수 없습니다');
      if (e.response?.statusCode == 403) throw Exception('삭제 권한이 없습니다');
      throw Exception('기념일 삭제 실패: ${e.message}');
    }
  }
}
