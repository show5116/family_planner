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
        if (category != null) 'category': SetBudgetDto.categoryToString(category),
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

  /// 예산 템플릿 목록 조회
  Future<List<BudgetTemplateModel>> getBudgetTemplates({
    required String groupId,
  }) async {
    try {
      final response = await _dio.get('/household/budget-templates', queryParameters: {
        'groupId': groupId,
      });
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => BudgetTemplateModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [HouseholdRepository] 예산 템플릿 조회 실패: ${e.message}');
      throw Exception('예산 템플릿 조회 실패: ${e.message}');
    }
  }

  /// 예산 템플릿 설정 (없으면 생성, 있으면 수정)
  Future<BudgetTemplateModel> setBudgetTemplate(SetBudgetTemplateDto dto) async {
    try {
      final response = await _dio.post('/household/budget-templates', data: dto.toJson());
      return BudgetTemplateModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [HouseholdRepository] 예산 템플릿 설정 실패: ${e.message}');
      throw Exception('예산 템플릿 설정 실패: ${e.message}');
    }
  }

  /// 카테고리별 예산 템플릿 삭제
  Future<void> deleteBudgetTemplate({
    required String groupId,
    required ExpenseCategory category,
  }) async {
    try {
      await _dio.delete(
        '/household/budget-templates/${SetBudgetDto.categoryToString(category)}',
        queryParameters: {'groupId': groupId},
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('예산 템플릿을 찾을 수 없습니다');
      if (e.response?.statusCode == 403) throw Exception('접근 권한이 없습니다');
      throw Exception('예산 템플릿 삭제 실패: ${e.message}');
    }
  }

  /// 예산 일괄 설정 (전체 + 카테고리별)
  Future<BulkBudgetResult> setBudgetBulk(BulkSetBudgetDto dto) async {
    try {
      final response = await _dio.post('/household/budgets/bulk', data: dto.toJson());
      return BulkBudgetResult.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [HouseholdRepository] 예산 일괄 설정 실패: ${e.message}');
      throw Exception('예산 일괄 설정 실패: ${e.message}');
    }
  }

  /// 예산 템플릿 일괄 설정 (전체 + 카테고리별)
  Future<BulkBudgetTemplateResult> setBudgetTemplateBulk(BulkSetBudgetTemplateDto dto) async {
    try {
      final response =
          await _dio.post('/household/budget-templates/bulk', data: dto.toJson());
      return BulkBudgetTemplateResult.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [HouseholdRepository] 예산 템플릿 일괄 설정 실패: ${e.message}');
      throw Exception('예산 템플릿 일괄 설정 실패: ${e.message}');
    }
  }

  /// 카테고리별 예산 설정
  Future<BudgetModel> setBudget(SetBudgetDto dto) async {
    try {
      final response = await _dio.post('/household/budgets', data: dto.toJson());
      return BudgetModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [HouseholdRepository] 예산 설정 실패: ${e.message}');
      throw Exception('예산 설정 실패: ${e.message}');
    }
  }

  // ── 그룹 전체 예산 ──

  /// 그룹 전체 예산 조회
  Future<GroupBudgetModel?> getGroupBudget({
    required String groupId,
    required String month,
  }) async {
    try {
      final response = await _dio.get('/household/group-budgets', queryParameters: {
        'groupId': groupId,
        'month': month,
      });
      final data = response.data;
      if (data == null || data is! Map<String, dynamic>) return null;
      return GroupBudgetModel.fromJson(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      debugPrint('❌ [HouseholdRepository] 전체 예산 조회 실패: ${e.message}');
      throw Exception('전체 예산 조회 실패: ${e.message}');
    }
  }

  /// 그룹 전체 예산 설정
  Future<GroupBudgetModel> setGroupBudget(SetGroupBudgetDto dto) async {
    try {
      final response = await _dio.post('/household/group-budgets', data: dto.toJson());
      return GroupBudgetModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [HouseholdRepository] 전체 예산 설정 실패: ${e.message}');
      throw Exception('전체 예산 설정 실패: ${e.message}');
    }
  }

  // ── 그룹 전체 예산 템플릿 ──

  /// 그룹 전체 예산 템플릿 조회
  Future<GroupBudgetTemplateModel?> getGroupBudgetTemplate({
    required String groupId,
  }) async {
    try {
      final response = await _dio.get('/household/group-budget-templates', queryParameters: {
        'groupId': groupId,
      });
      final data = response.data;
      if (data == null || data is! Map<String, dynamic>) return null;
      return GroupBudgetTemplateModel.fromJson(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      debugPrint('❌ [HouseholdRepository] 전체 예산 템플릿 조회 실패: ${e.message}');
      throw Exception('전체 예산 템플릿 조회 실패: ${e.message}');
    }
  }

  /// 그룹 전체 예산 템플릿 설정
  Future<GroupBudgetTemplateModel> setGroupBudgetTemplate(SetGroupBudgetTemplateDto dto) async {
    try {
      final response =
          await _dio.post('/household/group-budget-templates', data: dto.toJson());
      return GroupBudgetTemplateModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [HouseholdRepository] 전체 예산 템플릿 설정 실패: ${e.message}');
      throw Exception('전체 예산 템플릿 설정 실패: ${e.message}');
    }
  }

  /// 그룹 전체 예산 템플릿 삭제
  Future<void> deleteGroupBudgetTemplate({required String groupId}) async {
    try {
      await _dio.delete('/household/group-budget-templates', queryParameters: {
        'groupId': groupId,
      });
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('전체 예산 템플릿을 찾을 수 없습니다');
      if (e.response?.statusCode == 403) throw Exception('접근 권한이 없습니다');
      throw Exception('전체 예산 템플릿 삭제 실패: ${e.message}');
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
    }
  }
}
