import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/main/household/data/models/budget_model.dart';
import 'package:family_planner/features/main/household/data/models/expense_model.dart';
import 'package:family_planner/features/main/household/data/models/statistics_model.dart';

final householdRepositoryProvider = Provider<HouseholdRepository>((ref) {
  return HouseholdRepository();
});

class HouseholdRepository {
  final Dio _dio = ApiClient.instance.dio;

  /// 지출 목록 조회
  Future<List<ExpenseModel>> getExpenses({
    required String groupId,
    String? month, // YYYY-MM
    ExpenseCategory? category,
    PaymentMethod? paymentMethod,
  }) async {
    try {
      final response = await _dio.get('/household/expenses', queryParameters: {
        'groupId': groupId,
        if (month != null) 'month': month,
        if (category != null) 'category': _categoryToString(category),
        if (paymentMethod != null) 'paymentMethod': _paymentMethodToString(paymentMethod),
      });

      final data = response.data;
      if (data is List) {
        return data
            .map((e) => ExpenseModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [HouseholdRepository] 지출 목록 조회 실패: ${e.message}');
      throw Exception('지출 목록 조회 실패: ${e.message}');
    }
  }

  /// 지출 상세 조회
  Future<ExpenseModel> getExpenseById(String id) async {
    try {
      final response = await _dio.get('/household/expenses/$id');
      return ExpenseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('지출 내역을 찾을 수 없습니다');
      if (e.response?.statusCode == 403) throw Exception('접근 권한이 없습니다');
      throw Exception('지출 조회 실패: ${e.message}');
    }
  }

  /// 지출 등록
  Future<ExpenseModel> createExpense(CreateExpenseDto dto) async {
    try {
      final response = await _dio.post('/household/expenses', data: dto.toJson());
      return ExpenseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [HouseholdRepository] 지출 등록 실패: ${e.message}');
      throw Exception('지출 등록 실패: ${e.message}');
    }
  }

  /// 지출 수정
  Future<ExpenseModel> updateExpense(String id, UpdateExpenseDto dto) async {
    try {
      final response = await _dio.patch('/household/expenses/$id', data: dto.toJson());
      return ExpenseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('지출 내역을 찾을 수 없습니다');
      if (e.response?.statusCode == 403) throw Exception('본인이 등록한 지출만 수정할 수 있습니다');
      throw Exception('지출 수정 실패: ${e.message}');
    }
  }

  /// 지출 삭제
  Future<void> deleteExpense(String id) async {
    try {
      await _dio.delete('/household/expenses/$id');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('지출 내역을 찾을 수 없습니다');
      if (e.response?.statusCode == 403) throw Exception('본인이 등록한 지출만 삭제할 수 있습니다');
      throw Exception('지출 삭제 실패: ${e.message}');
    }
  }

  /// 월간 통계 조회
  Future<MonthlyStatisticsModel> getMonthlyStatistics({
    required String groupId,
    required String month, // YYYY-MM
  }) async {
    try {
      final response = await _dio.get('/household/statistics', queryParameters: {
        'groupId': groupId,
        'month': month,
      });
      return MonthlyStatisticsModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [HouseholdRepository] 월간 통계 조회 실패: ${e.message}');
      throw Exception('통계 조회 실패: ${e.message}');
    }
  }

  /// 연간 통계 조회
  Future<YearlyStatisticsModel> getYearlyStatistics({
    required String groupId,
    required String year, // YYYY
  }) async {
    try {
      final response = await _dio.get('/household/statistics/yearly', queryParameters: {
        'groupId': groupId,
        'year': year,
      });
      return YearlyStatisticsModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [HouseholdRepository] 연간 통계 조회 실패: ${e.message}');
      throw Exception('연간 통계 조회 실패: ${e.message}');
    }
  }

  /// 예산 목록 조회
  Future<List<BudgetModel>> getBudgets({
    required String groupId,
    required String month, // YYYY-MM
  }) async {
    try {
      final response = await _dio.get('/household/budgets', queryParameters: {
        'groupId': groupId,
        'month': month,
      });
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => BudgetModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [HouseholdRepository] 예산 조회 실패: ${e.message}');
      throw Exception('예산 조회 실패: ${e.message}');
    }
  }

  /// 예산 설정
  Future<BudgetModel> setBudget(SetBudgetDto dto) async {
    try {
      final response = await _dio.post('/household/budgets', data: dto.toJson());
      return BudgetModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [HouseholdRepository] 예산 설정 실패: ${e.message}');
      throw Exception('예산 설정 실패: ${e.message}');
    }
  }

  String _categoryToString(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return 'FOOD';
      case ExpenseCategory.transport:
        return 'TRANSPORT';
      case ExpenseCategory.leisure:
        return 'LEISURE';
      case ExpenseCategory.living:
        return 'LIVING';
      case ExpenseCategory.health:
        return 'HEALTH';
      case ExpenseCategory.education:
        return 'EDUCATION';
      case ExpenseCategory.clothing:
        return 'CLOTHING';
      case ExpenseCategory.other:
        return 'OTHER';
    }
  }

  String _paymentMethodToString(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'CASH';
      case PaymentMethod.card:
        return 'CARD';
      case PaymentMethod.transfer:
        return 'TRANSFER';
      case PaymentMethod.other:
        return 'OTHER';
    }
  }
}
