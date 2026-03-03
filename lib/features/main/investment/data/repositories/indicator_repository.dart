import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/main/investment/data/models/indicator_model.dart';

final indicatorRepositoryProvider = Provider<IndicatorRepository>((ref) {
  return IndicatorRepository();
});

class IndicatorRepository {
  final Dio _dio = ApiClient.instance.dio;

  /// 전체 지표 목록 + 최신 시세
  Future<List<IndicatorModel>> getIndicators() async {
    try {
      final response = await _dio.get('/indicators');
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => IndicatorModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [IndicatorRepository] 지표 목록 조회 실패: ${e.message}');
      throw Exception('지표 목록 조회 실패: ${e.message}');
    }
  }

  /// 즐겨찾기 목록 + 최신 시세
  Future<List<IndicatorModel>> getBookmarkedIndicators() async {
    try {
      final response = await _dio.get('/indicators/bookmarks');
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => IndicatorModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [IndicatorRepository] 즐겨찾기 목록 조회 실패: ${e.message}');
      throw Exception('즐겨찾기 목록 조회 실패: ${e.message}');
    }
  }

  /// 지표 상세 + 최신 시세
  Future<IndicatorModel> getIndicator(String symbol) async {
    try {
      final response = await _dio.get('/indicators/$symbol');
      return IndicatorModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('지표를 찾을 수 없습니다');
      throw Exception('지표 조회 실패: ${e.message}');
    }
  }

  /// 지표 시세 히스토리 (시계열)
  Future<IndicatorHistoryModel> getIndicatorHistory(
    String symbol, {
    int? days,
  }) async {
    try {
      final response = await _dio.get(
        '/indicators/$symbol/history',
        queryParameters: {
          if (days != null) 'days': days,
        },
      );
      return IndicatorHistoryModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('지표를 찾을 수 없습니다');
      throw Exception('히스토리 조회 실패: ${e.message}');
    }
  }

  /// 즐겨찾기 등록
  Future<IndicatorModel> addBookmark(String symbol) async {
    try {
      final response = await _dio.post('/indicators/$symbol/bookmark');
      return IndicatorModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('지표를 찾을 수 없습니다');
      throw Exception('즐겨찾기 등록 실패: ${e.message}');
    }
  }

  /// 즐겨찾기 해제
  Future<IndicatorModel> removeBookmark(String symbol) async {
    try {
      final response = await _dio.delete('/indicators/$symbol/bookmark');
      return IndicatorModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('지표를 찾을 수 없습니다');
      throw Exception('즐겨찾기 해제 실패: ${e.message}');
    }
  }

  /// 즐겨찾기 순서 변경
  Future<void> reorderBookmarks(List<String> symbols) async {
    try {
      await _dio.patch(
        '/indicators/bookmarks/reorder',
        data: {'symbols': symbols},
      );
    } on DioException catch (e) {
      throw Exception('즐겨찾기 순서 변경 실패: ${e.message}');
    }
  }
}
