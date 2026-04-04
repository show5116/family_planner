import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/main/household/data/models/budget_model.dart';
import 'package:family_planner/features/main/household/data/models/expense_model.dart';
import 'package:family_planner/features/main/household/data/models/statistics_model.dart';
import 'package:family_planner/features/main/household/data/repositories/household_repository.dart';

part 'household_provider.g.dart';

/// 현재 선택된 그룹 ID (가계부용)
final householdSelectedGroupIdProvider = StateProvider<String?>((ref) => null);

/// 가계부 현재 조회 월 Provider (YYYY-MM)
final householdSelectedMonthProvider = StateProvider<String>((ref) {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}';
});

/// 지출 목록 Provider
@riverpod
class HouseholdExpenses extends _$HouseholdExpenses {
  @override
  Future<List<ExpenseModel>> build() async {
    final groupId = ref.watch(householdSelectedGroupIdProvider);
    final month = ref.watch(householdSelectedMonthProvider);

    if (groupId == null) return [];

    final repository = ref.watch(householdRepositoryProvider);
    return repository.getExpenses(groupId: groupId, month: month);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final groupId = ref.read(householdSelectedGroupIdProvider);
      final month = ref.read(householdSelectedMonthProvider);
      if (groupId == null) return <ExpenseModel>[];
      return ref.read(householdRepositoryProvider).getExpenses(
            groupId: groupId,
            month: month,
          );
    });
  }

  void addExpense(ExpenseModel expense) {
    if (!state.hasValue) return;
    state = AsyncValue.data([expense, ...state.value!]);
  }

  void updateExpense(ExpenseModel expense) {
    if (!state.hasValue) return;
    state = AsyncValue.data(
      state.value!.map((e) => e.id == expense.id ? expense : e).toList(),
    );
  }

  void removeExpense(String id) {
    if (!state.hasValue) return;
    state = AsyncValue.data(
      state.value!.where((e) => e.id != id).toList(),
    );
  }
}

/// 월간 통계 Provider
@riverpod
Future<MonthlyStatisticsModel> householdMonthlyStatistics(Ref ref) async {
  final groupId = ref.watch(householdSelectedGroupIdProvider);
  final month = ref.watch(householdSelectedMonthProvider);

  if (groupId == null) {
    return MonthlyStatisticsModel(
      month: month,
      totalExpense: 0,
      totalBudget: 0,
      categories: [],
    );
  }

  final repository = ref.watch(householdRepositoryProvider);
  return repository.getMonthlyStatistics(groupId: groupId, month: month);
}

/// 연간 통계 Provider
@riverpod
Future<YearlyStatisticsModel> householdYearlyStatistics(Ref ref, String year) async {
  final groupId = ref.watch(householdSelectedGroupIdProvider);

  if (groupId == null) {
    return YearlyStatisticsModel(year: year, totalExpense: 0, months: []);
  }

  final repository = ref.watch(householdRepositoryProvider);
  return repository.getYearlyStatistics(groupId: groupId, year: year);
}

/// 고정 지출 목록 Provider (isRecurring=true)
@riverpod
class HouseholdRecurringExpenses extends _$HouseholdRecurringExpenses {
  @override
  Future<List<ExpenseModel>> build() async {
    final groupId = ref.watch(householdSelectedGroupIdProvider);
    if (groupId == null) return [];

    final repository = ref.watch(householdRepositoryProvider);
    final all = await repository.getExpenses(groupId: groupId);
    return all.where((e) => e.isRecurring).toList();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final groupId = ref.read(householdSelectedGroupIdProvider);
      if (groupId == null) return <ExpenseModel>[];
      final all = await ref
          .read(householdRepositoryProvider)
          .getExpenses(groupId: groupId);
      return all.where((e) => e.isRecurring).toList();
    });
  }

  void addExpense(ExpenseModel expense) {
    if (!state.hasValue) return;
    state = AsyncValue.data([expense, ...state.value!]);
  }

  void removeExpense(String id) {
    if (!state.hasValue) return;
    state = AsyncValue.data(
      state.value!.where((e) => e.id != id).toList(),
    );
  }
}

/// 예산 템플릿 목록 Provider
@riverpod
Future<List<BudgetTemplateModel>> householdBudgetTemplates(Ref ref) async {
  final groupId = ref.watch(householdSelectedGroupIdProvider);
  if (groupId == null) return [];

  final repository = ref.watch(householdRepositoryProvider);
  return repository.getBudgetTemplates(groupId: groupId);
}

/// 카테고리별 예산 목록 Provider
@riverpod
Future<List<BudgetModel>> householdBudgets(Ref ref) async {
  final groupId = ref.watch(householdSelectedGroupIdProvider);
  final month = ref.watch(householdSelectedMonthProvider);

  if (groupId == null) return [];

  final repository = ref.watch(householdRepositoryProvider);
  return repository.getBudgets(groupId: groupId, month: month);
}

/// 그룹 전체 예산 Provider
@riverpod
Future<GroupBudgetModel?> householdGroupBudget(Ref ref) async {
  final groupId = ref.watch(householdSelectedGroupIdProvider);
  final month = ref.watch(householdSelectedMonthProvider);

  if (groupId == null) return null;

  final repository = ref.watch(householdRepositoryProvider);
  return repository.getGroupBudget(groupId: groupId, month: month);
}

/// 그룹 전체 예산 템플릿 Provider
@riverpod
Future<GroupBudgetTemplateModel?> householdGroupBudgetTemplate(Ref ref) async {
  final groupId = ref.watch(householdSelectedGroupIdProvider);
  if (groupId == null) return null;

  final repository = ref.watch(householdRepositoryProvider);
  return repository.getGroupBudgetTemplate(groupId: groupId);
}

/// 지출 관리 Notifier (생성/수정/삭제)
class HouseholdManagementNotifier extends StateNotifier<AsyncValue<void>> {
  final HouseholdRepository _repository;
  final Ref _ref;

  HouseholdManagementNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<ExpenseModel?> createExpense(CreateExpenseDto dto) async {
    state = const AsyncValue.loading();
    try {
      final expense = await _repository.createExpense(dto);
      _ref.read(householdExpensesProvider.notifier).addExpense(expense);
      _ref.invalidate(householdMonthlyStatisticsProvider);
      state = const AsyncValue.data(null);
      return expense;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<ExpenseModel?> updateExpense(String id, UpdateExpenseDto dto) async {
    state = const AsyncValue.loading();
    try {
      final expense = await _repository.updateExpense(id, dto);
      _ref.read(householdExpensesProvider.notifier).updateExpense(expense);
      _ref.invalidate(householdMonthlyStatisticsProvider);
      state = const AsyncValue.data(null);
      return expense;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<bool> deleteExpense(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteExpense(id);
      _ref.read(householdExpensesProvider.notifier).removeExpense(id);
      _ref.invalidate(householdMonthlyStatisticsProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<BulkBudgetResult?> setBudgetBulk(BulkSetBudgetDto dto) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.setBudgetBulk(dto);
      _ref.invalidate(householdBudgetsProvider);
      _ref.invalidate(householdGroupBudgetProvider);
      _ref.invalidate(householdMonthlyStatisticsProvider);
      state = const AsyncValue.data(null);
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<BulkBudgetTemplateResult?> setBudgetTemplateBulk(BulkSetBudgetTemplateDto dto) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.setBudgetTemplateBulk(dto);
      _ref.invalidate(householdBudgetTemplatesProvider);
      _ref.invalidate(householdGroupBudgetTemplateProvider);
      // 이번 달 예산이 없을 경우 템플릿 기반으로 자동 생성될 수 있으므로 함께 갱신
      _ref.invalidate(householdBudgetsProvider);
      _ref.invalidate(householdGroupBudgetProvider);
      _ref.invalidate(householdMonthlyStatisticsProvider);
      state = const AsyncValue.data(null);
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<BudgetModel?> setBudget(SetBudgetDto dto) async {
    state = const AsyncValue.loading();
    try {
      final budget = await _repository.setBudget(dto);
      _ref.invalidate(householdBudgetsProvider);
      _ref.invalidate(householdMonthlyStatisticsProvider);
      state = const AsyncValue.data(null);
      return budget;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<BudgetTemplateModel?> setBudgetTemplate(SetBudgetTemplateDto dto) async {
    state = const AsyncValue.loading();
    try {
      final template = await _repository.setBudgetTemplate(dto);
      _ref.invalidate(householdBudgetTemplatesProvider);
      state = const AsyncValue.data(null);
      return template;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<bool> deleteBudgetTemplate({
    required String groupId,
    required ExpenseCategory category,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteBudgetTemplate(groupId: groupId, category: category);
      _ref.invalidate(householdBudgetTemplatesProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<GroupBudgetModel?> setGroupBudget(SetGroupBudgetDto dto) async {
    state = const AsyncValue.loading();
    try {
      final budget = await _repository.setGroupBudget(dto);
      _ref.invalidate(householdGroupBudgetProvider);
      _ref.invalidate(householdMonthlyStatisticsProvider);
      state = const AsyncValue.data(null);
      return budget;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<GroupBudgetTemplateModel?> setGroupBudgetTemplate(SetGroupBudgetTemplateDto dto) async {
    state = const AsyncValue.loading();
    try {
      final template = await _repository.setGroupBudgetTemplate(dto);
      _ref.invalidate(householdGroupBudgetTemplateProvider);
      state = const AsyncValue.data(null);
      return template;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<bool> deleteGroupBudgetTemplate({required String groupId}) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteGroupBudgetTemplate(groupId: groupId);
      _ref.invalidate(householdGroupBudgetTemplateProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final householdManagementProvider =
    StateNotifierProvider<HouseholdManagementNotifier, AsyncValue<void>>((ref) {
  return HouseholdManagementNotifier(
    ref.watch(householdRepositoryProvider),
    ref,
  );
});
