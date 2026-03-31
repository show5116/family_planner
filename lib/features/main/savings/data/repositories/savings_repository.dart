import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/main/savings/data/models/savings_model.dart';

/// 적립금 Repository Provider
final savingsRepositoryProvider = Provider<SavingsRepository>((ref) {
  return SavingsRepository();
});

/// 적립금 Repository
class SavingsRepository {
  final Dio _dio = ApiClient.instance.dio;

  SavingsRepository();

  // ── 적립 목표 ─────────────────────────────────────────────────────────────

  /// 적립 목표 목록 조회
  Future<List<SavingsGoalModel>> getGoals(String groupId) async {
    try {
      final response = await _dio.get(
        '/savings',
        queryParameters: {'groupId': groupId},
      );
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => SavingsGoalModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [SavingsRepository] 적립 목표 목록 조회 실패: ${e.message}');
      throw Exception('적립 목표 목록 조회 실패: ${e.message}');
    }
  }

  /// 적립 목표 상세 조회 (transactions 10건 포함)
  Future<SavingsGoalModel> getGoal(String id) async {
    try {
      final response = await _dio.get('/savings/$id');
      return SavingsGoalModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('적립 목표를 찾을 수 없습니다');
      }
      debugPrint('❌ [SavingsRepository] 적립 목표 상세 조회 실패: ${e.message}');
      throw Exception('적립 목표 상세 조회 실패: ${e.message}');
    }
  }

  /// 적립 목표 생성
  Future<SavingsGoalModel> createGoal({
    required String groupId,
    required String name,
    String? description,
    double? targetAmount,
    bool autoDeposit = false,
    double? monthlyAmount,
  }) async {
    try {
      final response = await _dio.post('/savings', data: {
        'groupId': groupId,
        'name': name,
        if (description != null) 'description': description,
        if (targetAmount != null) 'targetAmount': targetAmount,
        'autoDeposit': autoDeposit,
        if (monthlyAmount != null) 'monthlyAmount': monthlyAmount,
      });
      return SavingsGoalModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [SavingsRepository] 적립 목표 생성 실패: ${e.message}');
      throw Exception('적립 목표 생성 실패: ${e.message}');
    }
  }

  /// 적립 목표 수정
  Future<SavingsGoalModel> updateGoal(
    String id, {
    String? name,
    String? description,
    double? targetAmount,
    bool? autoDeposit,
    double? monthlyAmount,
  }) async {
    try {
      final response = await _dio.patch('/savings/$id', data: {
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (targetAmount != null) 'targetAmount': targetAmount,
        if (autoDeposit != null) 'autoDeposit': autoDeposit,
        if (monthlyAmount != null) 'monthlyAmount': monthlyAmount,
      });
      return SavingsGoalModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('적립 목표를 찾을 수 없습니다');
      }
      debugPrint('❌ [SavingsRepository] 적립 목표 수정 실패: ${e.message}');
      throw Exception('적립 목표 수정 실패: ${e.message}');
    }
  }

  /// 적립 목표 삭제
  Future<void> deleteGoal(String id) async {
    try {
      await _dio.delete('/savings/$id');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('적립 목표를 찾을 수 없습니다');
      }
      debugPrint('❌ [SavingsRepository] 적립 목표 삭제 실패: ${e.message}');
      throw Exception('적립 목표 삭제 실패: ${e.message}');
    }
  }

  /// 적립 목표 수동 완료 처리
  Future<void> completeGoal(String id) async {
    try {
      await _dio.post('/savings/$id/complete');
    } on DioException catch (e) {
      debugPrint('❌ [SavingsRepository] 적립 목표 완료 처리 실패: ${e.message}');
      throw Exception('완료 처리 실패: ${e.message}');
    }
  }

  /// 자동 적립 일시 중지
  Future<void> pauseGoal(String id) async {
    try {
      await _dio.post('/savings/$id/pause');
    } on DioException catch (e) {
      debugPrint('❌ [SavingsRepository] 자동 적립 일시 중지 실패: ${e.message}');
      throw Exception('일시 중지 실패: ${e.message}');
    }
  }

  /// 자동 적립 재개
  Future<void> resumeGoal(String id) async {
    try {
      await _dio.post('/savings/$id/resume');
    } on DioException catch (e) {
      debugPrint('❌ [SavingsRepository] 자동 적립 재개 실패: ${e.message}');
      throw Exception('재개 실패: ${e.message}');
    }
  }

  // ── 입금 / 출금 ───────────────────────────────────────────────────────────

  /// 수동 입금
  Future<SavingsTransactionModel> deposit(
    String id, {
    required double amount,
    String? description,
  }) async {
    try {
      final response = await _dio.post('/savings/$id/deposit', data: {
        'amount': amount,
        if (description != null) 'description': description,
      });
      return SavingsTransactionModel.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [SavingsRepository] 입금 실패: ${e.message}');
      throw Exception('입금 실패: ${e.message}');
    }
  }

  /// 출금
  Future<SavingsTransactionModel> withdraw(
    String id, {
    required double amount,
    required String description,
  }) async {
    try {
      final response = await _dio.post('/savings/$id/withdraw', data: {
        'amount': amount,
        'description': description,
      });
      return SavingsTransactionModel.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [SavingsRepository] 출금 실패: ${e.message}');
      throw Exception('출금 실패: ${e.message}');
    }
  }

  // ── 거래 내역 ─────────────────────────────────────────────────────────────

  /// 거래 내역 조회 (페이지네이션)
  Future<SavingsTransactionListResult> getTransactions(
    String id, {
    String? type,
    String? month,
    String? year,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/savings/$id/transactions',
        queryParameters: {
          if (type != null) 'type': type,
          if (month != null) 'month': month,
          if (year != null) 'year': year,
          'page': page,
          'limit': limit,
        },
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return SavingsTransactionListResult.fromJson(data);
      }
      return const SavingsTransactionListResult(
          items: [], total: 0, page: 1, limit: 20);
    } on DioException catch (e) {
      debugPrint('❌ [SavingsRepository] 거래 내역 조회 실패: ${e.message}');
      throw Exception('거래 내역 조회 실패: ${e.message}');
    }
  }
}
