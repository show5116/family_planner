import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/home/providers/dashboard_provider.dart';
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

/// 특정 월 통계 Provider (통계 화면 전용 - 독립 월 파라미터)
@riverpod
Future<MonthlyStatisticsModel> householdMonthlyStatisticsByMonth(
    Ref ref, String month) async {
  final groupId = ref.watch(householdSelectedGroupIdProvider);
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

/// 연간 통계 Provider
@riverpod
Future<YearlyStatisticsModel> householdYearlyStatistics(Ref ref, String year) async {
  final groupId = ref.watch(householdSelectedGroupIdProvider);
  final excludeRefunds = ref.watch(householdExcludeRefundsProvider);
  final excludeCarryover = ref.watch(householdExcludeCarryoverProvider);

  final repository = ref.watch(householdRepositoryProvider);
  return repository.getYearlyStatistics(
    groupId: groupId,
    year: year,
    excludeRefunds: excludeRefunds,
    excludeCarryover: excludeCarryover,
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

/// 고정 지출 목록 Provider (isRecurring=true)
@riverpod
class HouseholdRecurringExpenses extends _$HouseholdRecurringExpenses {
  @override
  Future<List<ExpenseModel>> build() async {
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

/// 이번 달 아직 치뤄지지 않은 고정 지출 목록 Provider
///
/// 고정지출 원본 목록의 날짜(day)를 이번 달로 환산했을 때
/// 오늘 이후에 해당하는 항목 = 아직 발생하지 않은 고정지출.
/// (백엔드 복사는 해당 날짜에 일어나므로, 오늘 이후 항목은 아직 지출 목록에 없음)
final householdUnpaidRecurringProvider = Provider<List<ExpenseModel>>((ref) {
  final recurring = ref.watch(householdRecurringExpensesProvider).valueOrNull ?? [];
  final now = DateTime.now();
  return recurring
      .where((e) {
        if (e.type != TransactionType.expense) return false;
        // 원본 등록일(day)을 이번 달 날짜로 환산
        final dueDay = e.date.day;
        final lastDay = DateTime(now.year, now.month + 1, 0).day;
        final effectiveDay = dueDay > lastDay ? lastDay : dueDay;
        final dueDate = DateTime(now.year, now.month, effectiveDay);
        // 오늘보다 미래인 항목만 (오늘 당일 포함)
        return !dueDate.isBefore(DateTime(now.year, now.month, now.day));
      })
      .toList()
    ..sort((a, b) => a.date.day.compareTo(b.date.day));
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
      _ref.read(householdExpensesProvider.notifier).addExpense(expense);
      _ref.invalidate(householdMonthlyStatisticsProvider);
      _ref.invalidate(dashboardHouseholdStatisticsProvider);
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
      _ref.invalidate(dashboardHouseholdStatisticsProvider);
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
      _ref.invalidate(dashboardHouseholdStatisticsProvider);
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

      // 1) 이번 달 마지막 날: ASSET_TRANSFER 지출로 잔금만큼 차감
      await _repository.createExpense(CreateExpenseDto(
        groupId: groupId,
        type: TransactionType.expense,
        amount: balance,
        category: ExpenseCategory.assetTransfer,
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
