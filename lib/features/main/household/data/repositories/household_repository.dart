import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/core/services/analytics_service.dart';
import 'package:family_planner/features/main/household/data/models/budget_model.dart';
import 'package:family_planner/features/main/household/data/models/expense_model.dart';
import 'package:family_planner/features/main/household/data/models/merchant_model.dart';
import 'package:family_planner/features/main/household/data/models/recurring_expense_model.dart';
import 'package:family_planner/features/main/household/data/models/statistics_model.dart';

final householdRepositoryProvider = Provider<HouseholdRepository>((ref) {
  return HouseholdRepository();
});

class HouseholdRepository {
  final Dio _dio = ApiClient.instance.dio;

  /// 지출 목록 조회
  Future<List<ExpenseModel>> getExpenses({
    String? groupId, // null이면 개인 모드
    String? month, // YYYY-MM
    ExpenseCategory? category,
    bool? filterNullCategory, // true이면 category=NONE으로 조회
    PaymentMethod? paymentMethod,
    TransactionType? type,
  }) async {
    try {
      final response = await _dio.get('/household/expenses', queryParameters: {
        if (groupId != null) 'groupId': groupId,
        if (month != null) 'month': month,
        if (filterNullCategory == true) 'category': 'NONE'
        else if (category != null) 'category': SetBudgetDto.categoryToString(category),
        if (paymentMethod != null) 'paymentMethod': _paymentMethodToString(paymentMethod),
        if (type != null) 'type': type == TransactionType.income ? 'INCOME' : 'EXPENSE',
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

  /// 고정지출 목록 조회
  Future<List<RecurringExpenseModel>> getRecurringExpenses({
    String? groupId,
    bool includeInactive = false,
  }) async {
    try {
      final response = await _dio.get('/household/recurring-expenses', queryParameters: {
        if (groupId != null) 'groupId': groupId,
        if (includeInactive) 'includeInactive': true,
      });
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => RecurringExpenseModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [HouseholdRepository] 고정지출 조회 실패: ${e.message}');
      throw Exception('고정지출 조회 실패: ${e.message}');
    }
  }

  /// 고정지출 상세 조회
  Future<RecurringExpenseModel> getRecurringExpenseById(String id) async {
    try {
      final response = await _dio.get('/household/recurring-expenses/$id');
      return RecurringExpenseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('고정지출을 찾을 수 없습니다');
      if (e.response?.statusCode == 403) throw Exception('접근 권한이 없습니다');
      throw Exception('고정지출 조회 실패: ${e.message}');
    }
  }

  /// 고정지출 등록
  Future<RecurringExpenseModel> createRecurringExpense(CreateRecurringExpenseDto dto) async {
    try {
      final response = await _dio.post('/household/recurring-expenses', data: dto.toJson());
      return RecurringExpenseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [HouseholdRepository] 고정지출 등록 실패: ${e.message}');
      throw Exception('고정지출 등록 실패: ${e.message}');
    }
  }

  /// 고정지출 수정
  Future<RecurringExpenseModel> updateRecurringExpense(
      String id, UpdateRecurringExpenseDto dto) async {
    try {
      final response =
          await _dio.patch('/household/recurring-expenses/$id', data: dto.toJson());
      return RecurringExpenseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('고정지출을 찾을 수 없습니다');
      if (e.response?.statusCode == 403) throw Exception('본인이 등록한 고정지출만 수정할 수 있습니다');
      throw Exception('고정지출 수정 실패: ${e.message}');
    }
  }

  /// 고정지출 삭제
  Future<void> deleteRecurringExpense(String id) async {
    try {
      await _dio.delete('/household/recurring-expenses/$id');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('고정지출을 찾을 수 없습니다');
      if (e.response?.statusCode == 403) throw Exception('본인이 등록한 고정지출만 삭제할 수 있습니다');
      throw Exception('고정지출 삭제 실패: ${e.message}');
    }
  }

  /// 고정지출 적용 내역 조회 (가변이면 통계 포함)
  Future<RecurringExpenseHistoryModel> getRecurringExpenseHistory(String id) async {
    try {
      final response = await _dio.get('/household/recurring-expenses/$id/history');
      return RecurringExpenseHistoryModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('고정지출을 찾을 수 없습니다');
      if (e.response?.statusCode == 403) throw Exception('접근 권한이 없습니다');
      throw Exception('적용 내역 조회 실패: ${e.message}');
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
      final expense = ExpenseModel.fromJson(response.data as Map<String, dynamic>);
      final type = dto.toJson()['type'] as String? ?? 'EXPENSE';
      await AnalyticsService.instance.logHouseholdEntryCreate(type.toLowerCase());
      return expense;
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
    String? groupId, // null이면 개인 모드
    required String month, // YYYY-MM
    bool excludeRefunds = false,
    bool excludeCarryover = false,
  }) async {
    try {
      final response = await _dio.get('/household/statistics', queryParameters: {
        if (groupId != null) 'groupId': groupId,
        'month': month,
        if (excludeRefunds) 'excludeRefunds': true,
        if (excludeCarryover) 'excludeCarryover': true,
      });
      return MonthlyStatisticsModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [HouseholdRepository] 월간 통계 조회 실패: ${e.message}');
      throw Exception('통계 조회 실패: ${e.message}');
    }
  }

  /// 연간 통계 조회
  Future<YearlyStatisticsModel> getYearlyStatistics({
    String? groupId, // null이면 개인 모드
    required String year, // YYYY
    bool excludeRefunds = false,
    bool excludeCarryover = false,
  }) async {
    try {
      final response = await _dio.get('/household/statistics/yearly', queryParameters: {
        if (groupId != null) 'groupId': groupId,
        'year': year,
        if (excludeRefunds) 'excludeRefunds': true,
        if (excludeCarryover) 'excludeCarryover': true,
      });
      return YearlyStatisticsModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [HouseholdRepository] 연간 통계 조회 실패: ${e.message}');
      throw Exception('연간 통계 조회 실패: ${e.message}');
    }
  }

  /// 예산 목록 조회
  Future<List<BudgetModel>> getBudgets({
    String? groupId, // null이면 개인 모드
    required String month, // YYYY-MM
  }) async {
    try {
      final response = await _dio.get('/household/budgets', queryParameters: {
        if (groupId != null) 'groupId': groupId,
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
    String? groupId, // null이면 개인 모드
  }) async {
    try {
      final response = await _dio.get('/household/budget-templates', queryParameters: {
        if (groupId != null) 'groupId': groupId,
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
    String? groupId, // null이면 개인 모드
    required ExpenseCategory category,
  }) async {
    try {
      await _dio.delete(
        '/household/budget-templates/${SetBudgetDto.categoryToString(category)}',
        queryParameters: {
          if (groupId != null) 'groupId': groupId,
        },
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
    String? groupId, // null이면 개인 모드
    required String month,
  }) async {
    try {
      final response = await _dio.get('/household/group-budgets', queryParameters: {
        if (groupId != null) 'groupId': groupId,
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
    String? groupId, // null이면 개인 모드
  }) async {
    try {
      final response = await _dio.get('/household/group-budget-templates', queryParameters: {
        if (groupId != null) 'groupId': groupId,
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
  Future<void> deleteGroupBudgetTemplate({String? groupId}) async {
    try {
      await _dio.delete('/household/group-budget-templates', queryParameters: {
        if (groupId != null) 'groupId': groupId,
      });
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('전체 예산 템플릿을 찾을 수 없습니다');
      if (e.response?.statusCode == 403) throw Exception('접근 권한이 없습니다');
      throw Exception('전체 예산 템플릿 삭제 실패: ${e.message}');
    }
  }

  /// 소비처 목록 조회
  Future<List<MerchantModel>> getMerchants({String? groupId}) async {
    try {
      final response = await _dio.get('/household/merchants', queryParameters: {
        if (groupId != null) 'groupId': groupId,
      });
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => MerchantModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [HouseholdRepository] 소비처 목록 조회 실패: ${e.message}');
      throw Exception('소비처 목록 조회 실패: ${e.message}');
    }
  }

  /// 소비처 등록
  Future<MerchantModel> createMerchant(CreateMerchantDto dto) async {
    try {
      final response = await _dio.post('/household/merchants', data: dto.toJson());
      return MerchantModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [HouseholdRepository] 소비처 등록 실패: ${e.message}');
      throw Exception('소비처 등록 실패: ${e.message}');
    }
  }

  /// 소비처 수정
  Future<MerchantModel> updateMerchant(String id, UpdateMerchantDto dto) async {
    try {
      final response = await _dio.patch('/household/merchants/$id', data: dto.toJson());
      return MerchantModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('소비처를 찾을 수 없습니다');
      if (e.response?.statusCode == 403) throw Exception('본인이 등록한 소비처만 수정할 수 있습니다');
      throw Exception('소비처 수정 실패: ${e.message}');
    }
  }

  /// 소비처 삭제
  Future<void> deleteMerchant(String id) async {
    try {
      await _dio.delete('/household/merchants/$id');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('소비처를 찾을 수 없습니다');
      if (e.response?.statusCode == 403) throw Exception('본인이 등록한 소비처만 삭제할 수 있습니다');
      throw Exception('소비처 삭제 실패: ${e.message}');
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
