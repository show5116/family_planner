import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/home/providers/dashboard_provider.dart';
import 'package:family_planner/features/main/household/data/models/budget_model.dart';
import 'package:family_planner/features/main/household/data/models/expense_model.dart';
import 'package:family_planner/features/main/household/data/models/recurring_expense_model.dart';
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

/// 통계/일별 합산에서 환불 항목 제외 여부
final householdExcludeRefundsProvider = StateProvider<bool>((ref) => false);

/// 가계부 뷰 모드 (list / calendar)
enum HouseholdViewMode { list, calendar }

final householdViewModeProvider =
    StateProvider<HouseholdViewMode>((ref) => HouseholdViewMode.list);

/// 통계/일별 합산에서 이월 항목 제외 여부
final householdExcludeCarryoverProvider = StateProvider<bool>((ref) => false);

/// 지출 목록 Provider
@riverpod
class HouseholdExpenses extends _$HouseholdExpenses {
  @override
  Future<List<ExpenseModel>> build() async {
    final groupId = ref.watch(householdSelectedGroupIdProvider);
    final month = ref.watch(householdSelectedMonthProvider);

    final repository = ref.watch(householdRepositoryProvider);
    return repository.getExpenses(groupId: groupId, month: month);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final groupId = ref.read(householdSelectedGroupIdProvider);
      final month = ref.read(householdSelectedMonthProvider);
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
  final excludeRefunds = ref.watch(householdExcludeRefundsProvider);
  final excludeCarryover = ref.watch(householdExcludeCarryoverProvider);

  final repository = ref.watch(householdRepositoryProvider);
  return repository.getMonthlyStatistics(
    groupId: groupId,
    month: month,
    excludeRefunds: excludeRefunds,
    excludeCarryover: excludeCarryover,
  );
}

/// 특정 월 통계 Provider (통계 화면 전용 - 환불/이월 항상 제외)
@riverpod
Future<MonthlyStatisticsModel> householdMonthlyStatisticsByMonth(
    Ref ref, String month) async {
  final groupId = ref.watch(householdSelectedGroupIdProvider);

  final repository = ref.watch(householdRepositoryProvider);
  return repository.getMonthlyStatistics(
    groupId: groupId,
    month: month,
    excludeRefunds: true,
    excludeCarryover: true,
  );
}

/// 연간 통계 Provider (통계 화면 전용 - 환불/이월 항상 제외)
@riverpod
Future<YearlyStatisticsModel> householdYearlyStatistics(Ref ref, String year) async {
  final groupId = ref.watch(householdSelectedGroupIdProvider);

  final repository = ref.watch(householdRepositoryProvider);
  return repository.getYearlyStatistics(
    groupId: groupId,
    year: year,
    excludeRefunds: true,
    excludeCarryover: true,
  );
}

/// 특정 월 지출 목록 Provider (통계 화면 소비처/필터 탭용)
final householdExpensesByMonthProvider =
    FutureProvider.family<List<ExpenseModel>, String>((ref, month) {
  final groupId = ref.watch(householdSelectedGroupIdProvider);
  return ref
      .watch(householdRepositoryProvider)
      .getExpenses(groupId: groupId, month: month);
});

/// 고정지출 목록 Provider
@riverpod
class HouseholdRecurringExpenses extends _$HouseholdRecurringExpenses {
  @override
  Future<List<RecurringExpenseModel>> build() async {
    final groupId = ref.watch(householdSelectedGroupIdProvider);
    final repository = ref.watch(householdRepositoryProvider);
    return repository.getRecurringExpenses(groupId: groupId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final groupId = ref.read(householdSelectedGroupIdProvider);
      return ref
          .read(householdRepositoryProvider)
          .getRecurringExpenses(groupId: groupId);
    });
  }

  void addRecurring(RecurringExpenseModel item) {
    if (!state.hasValue) return;
    state = AsyncValue.data([item, ...state.value!]);
  }

  void updateRecurring(RecurringExpenseModel item) {
    if (!state.hasValue) return;
    state = AsyncValue.data(
      state.value!.map((e) => e.id == item.id ? item : e).toList(),
    );
  }

  void removeRecurring(String id) {
    if (!state.hasValue) return;
    state = AsyncValue.data(
      state.value!.where((e) => e.id != id).toList(),
    );
  }
}

/// 선택된 달의 아직 치뤄지지 않은 고정지출 목록 Provider
///
/// dayOfMonth를 선택된 달 날짜로 환산했을 때 오늘 이후인 항목만 반환.
/// 미래 달이면 해당 달 전체 고정지출이 모두 포함됨.
final householdUnpaidRecurringProvider = Provider<List<RecurringExpenseModel>>((ref) {
  final recurring = ref.watch(householdRecurringExpensesProvider).valueOrNull ?? [];
  final selectedMonth = ref.watch(householdSelectedMonthProvider);
  final now = DateTime.now();

  final parts = selectedMonth.split('-');
  final targetYear = int.parse(parts[0]);
  final targetMonth = int.parse(parts[1]);
  final today = DateTime(now.year, now.month, now.day);

  return recurring
      .where((e) {
        if (!e.isActive) return false;
        final lastDay = DateTime(targetYear, targetMonth + 1, 0).day;
        final effectiveDay = e.dayOfMonth > lastDay ? lastDay : e.dayOfMonth;
        final dueDate = DateTime(targetYear, targetMonth, effectiveDay);
        return !dueDate.isBefore(today);
      })
      .toList()
    ..sort((a, b) => a.dayOfMonth.compareTo(b.dayOfMonth));
});

/// 지출 단건 조회 Provider (장보기 이력 → 가계부 이동 등에 사용)
final expenseByIdProvider =
    FutureProvider.family<ExpenseModel, String>((ref, id) {
  return ref.read(householdRepositoryProvider).getExpenseById(id);
});

/// 예산 템플릿 목록 Provider
@riverpod
Future<List<BudgetTemplateModel>> householdBudgetTemplates(Ref ref) async {
  final groupId = ref.watch(householdSelectedGroupIdProvider);

  final repository = ref.watch(householdRepositoryProvider);
  return repository.getBudgetTemplates(groupId: groupId);
}

/// 카테고리별 예산 목록 Provider
@riverpod
Future<List<BudgetModel>> householdBudgets(Ref ref) async {
  final groupId = ref.watch(householdSelectedGroupIdProvider);
  final month = ref.watch(householdSelectedMonthProvider);

  final repository = ref.watch(householdRepositoryProvider);
  return repository.getBudgets(groupId: groupId, month: month);
}

/// 그룹 전체 예산 Provider
@riverpod
Future<GroupBudgetModel?> householdGroupBudget(Ref ref) async {
  final groupId = ref.watch(householdSelectedGroupIdProvider);
  final month = ref.watch(householdSelectedMonthProvider);

  final repository = ref.watch(householdRepositoryProvider);
  return repository.getGroupBudget(groupId: groupId, month: month);
}

/// 그룹 전체 예산 템플릿 Provider
@riverpod
Future<GroupBudgetTemplateModel?> householdGroupBudgetTemplate(Ref ref) async {
  final groupId = ref.watch(householdSelectedGroupIdProvider);

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
      _invalidateAll(expense: expense, isNew: true);
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
      _invalidateAll(expense: expense);
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
      _invalidateAll();
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// 지출 생성/수정/삭제 후 관련 provider 일괄 갱신
  void _invalidateAll({ExpenseModel? expense, bool isNew = false}) {
    // 메인 지출 목록 (낙관적 업데이트)
    if (expense != null && isNew) {
      _ref.read(householdExpensesProvider.notifier).addExpense(expense);
    } else if (expense != null) {
      _ref.read(householdExpensesProvider.notifier).updateExpense(expense);
    }

    // 월간/연간 통계 (양쪽 provider 모두)
    _ref.invalidate(householdMonthlyStatisticsProvider);
    _ref.invalidate(householdMonthlyStatisticsByMonthProvider);
    _ref.invalidate(householdYearlyStatisticsProvider);
    _ref.invalidate(dashboardHouseholdStatisticsProvider);

    // 통계 화면 월별 지출 목록 (카테고리 드릴다운용)
    _ref.invalidate(householdExpensesByMonthProvider);
  }

  /// 고정지출 등록
  Future<RecurringExpenseModel?> createRecurringExpense(
      CreateRecurringExpenseDto dto) async {
    state = const AsyncValue.loading();
    try {
      final item = await _repository.createRecurringExpense(dto);
      _ref.read(householdRecurringExpensesProvider.notifier).addRecurring(item);
      state = const AsyncValue.data(null);
      return item;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// 고정지출 수정
  Future<RecurringExpenseModel?> updateRecurringExpense(
      String id, UpdateRecurringExpenseDto dto) async {
    state = const AsyncValue.loading();
    try {
      final item = await _repository.updateRecurringExpense(id, dto);
      _ref.read(householdRecurringExpensesProvider.notifier).updateRecurring(item);
      state = const AsyncValue.data(null);
      return item;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// 고정지출 삭제
  Future<bool> deleteRecurringExpense(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteRecurringExpense(id);
      _ref.read(householdRecurringExpensesProvider.notifier).removeRecurring(id);
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
      _ref.invalidate(dashboardHouseholdStatisticsProvider);
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
      _ref.invalidate(dashboardHouseholdStatisticsProvider);
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
      _ref.invalidate(dashboardHouseholdStatisticsProvider);
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
    String? groupId,
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
      _ref.invalidate(dashboardHouseholdStatisticsProvider);
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

  /// 잔금 이월: 이번 달 마지막 날 ASSET_TRANSFER 지출 + 다음 달 1일 INCOME 입금
  Future<bool> carryOverBalance({
    required String? groupId,
    required double balance,
    required String currentMonth, // YYYY-MM
  }) async {
    if (balance <= 0) return false;

    state = const AsyncValue.loading();
    try {
      final parts = currentMonth.split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);

      // 이번 달 마지막 날 계산
      final lastDayOfMonth = DateTime(year, month + 1, 0);
      final lastDayStr =
          '${lastDayOfMonth.year}-${lastDayOfMonth.month.toString().padLeft(2, '0')}-${lastDayOfMonth.day.toString().padLeft(2, '0')}';

      // 다음 달 1일 계산
      final nextMonth = month == 12 ? 1 : month + 1;
      final nextYear = month == 12 ? year + 1 : year;
      final nextMonthFirstStr =
          '$nextYear-${nextMonth.toString().padLeft(2, '0')}-01';

      // 1) 이번 달 마지막 날: CARRYOVER 지출로 잔금만큼 차감
      await _repository.createExpense(CreateExpenseDto(
        groupId: groupId,
        type: TransactionType.expense,
        amount: balance,
        category: ExpenseCategory.carryover,
        date: lastDayStr,
        description: '잔금 이월',
      ));

      // 2) 다음 달 1일: INCOME + CARRYOVER 카테고리로 이월
      await _repository.createExpense(CreateExpenseDto(
        groupId: groupId,
        type: TransactionType.income,
        amount: balance,
        date: nextMonthFirstStr,
        description: '전월 이월',
        incomeCategory: IncomeCategory.carryover,
      ));

      _ref.invalidate(householdMonthlyStatisticsProvider);
      _ref.invalidate(dashboardHouseholdStatisticsProvider);
      // 현재 보고 있는 월이 이번 달이면 지출 목록도 갱신
      _ref.read(householdExpensesProvider.notifier).refresh();

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> deleteGroupBudgetTemplate({String? groupId}) async {
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
