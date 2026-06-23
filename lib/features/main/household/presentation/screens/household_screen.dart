import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/shared/widgets/app_bar_more_menu.dart';
import 'package:family_planner/features/main/assets/data/models/account_model.dart';
import 'package:family_planner/features/main/assets/data/repositories/asset_repository.dart';
import 'package:family_planner/features/main/household/data/models/expense_model.dart';
import 'package:family_planner/features/main/household/data/models/statistics_model.dart';
import 'package:family_planner/features/main/savings/data/models/savings_model.dart';
import 'package:family_planner/features/main/savings/data/repositories/savings_repository.dart';
import 'package:family_planner/features/main/household/presentation/widgets/budget_setting_sheet.dart';
import 'package:family_planner/features/main/household/presentation/widgets/expense_list_item.dart';
import 'package:family_planner/features/main/household/providers/household_provider.dart';
import 'package:family_planner/features/onboarding/presentation/widgets/feature_coach_mark.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/features/settings/groups/providers/default_group_provider.dart';
import 'package:family_planner/shared/widgets/group_filter_bar.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

part '_household_onboarding.dart';

class HouseholdScreen extends ConsumerStatefulWidget {
  const HouseholdScreen({super.key});

  @override
  ConsumerState<HouseholdScreen> createState() => _HouseholdScreenState();
}

class _HouseholdScreenState extends ConsumerState<HouseholdScreen> {
  final _fabKey = GlobalKey();
  final _budgetKey = GlobalKey();
  final _recurringKey = GlobalKey();
  final _statisticsKey = GlobalKey();
  final _moreMenuKey = GlobalKey();
  final _scrollController = ScrollController();
  bool _isDemo = false;
  final _itemKeys = <String, GlobalKey>{};
  String? _selectedCalendarDate;

  void scrollToDate(String dateKey) {
    setState(() => _selectedCalendarDate = dateKey);

    final key = _itemKeys[dateKey];
    if (key == null) return;
    final ctx = key.currentContext;
    if (ctx == null) return;

    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      alignment: 0.0,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initGroupFilter();
      await _maybeStartOnboarding();
    });
  }

  Future<void> _initGroupFilter() async {
    final defaultId = ref.read(defaultGroupProvider);
    final groups = await ref
        .read(myGroupsProvider.future)
        .catchError((_) => <Group>[]);
    if (groups.isEmpty || !mounted) return;
    final resolved = (defaultId != null && groups.any((g) => g.id == defaultId))
        ? defaultId
        : groups.first.id;
    ref.read(householdSelectedGroupIdProvider.notifier).state = resolved;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedGroupId = ref.watch(householdSelectedGroupIdProvider);
    final selectedMonth = ref.watch(householdSelectedMonthProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.household_title),
        actions: [
          IconButton(
            key: _recurringKey,
            icon: const Icon(Icons.repeat),
            tooltip: l10n.household_recurring_title,
            onPressed: () => context.push(AppRoutes.householdRecurring),
          ),
          IconButton(
            key: _statisticsKey,
            icon: const Icon(Icons.bar_chart),
            tooltip: l10n.household_statistics,
            onPressed: () => context.push(AppRoutes.householdStatistics),
          ),
          AppBarMoreMenu(
            key: _moreMenuKey,
            onReplayOnboarding: _replayOnboarding,
            extraItems: [
              MoreMenuItem(
                id: 'budget',
                icon: Icons.account_balance_wallet_outlined,
                label: l10n.household_budget_set,
                onTap: (_) => showBudgetSettingSheet(context),
              ),
              MoreMenuItem(
                id: 'merchants',
                icon: Icons.storefront_outlined,
                label: l10n.household_merchants,
                onTap: (ctx) => ctx.push(AppRoutes.householdMerchants),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          GroupFilterBar(
            selectedGroupId: selectedGroupId,
            showPersonal: true,
            personalLabel: l10n.household_personal_mode,
            onChanged: (value) {
              ref.read(householdSelectedGroupIdProvider.notifier).state = value;
            },
            trailing: _MonthNavigator(selectedMonth: selectedMonth),
          ),
          const _ExcludeFilterBar(),
          // 뷰모드에 따라 요약카드 or 캘린더 표시
          if (_isDemo)
            KeyedSubtree(
              key: _budgetKey,
              child: _MonthlySummaryCard(demoStats: _demoStats),
            )
          else
            Consumer(builder: (context, ref, _) {
              final viewMode = ref.watch(householdViewModeProvider);
              if (viewMode == HouseholdViewMode.calendar) {
                return _CalendarSummary(
                  selectedDateKey: _selectedCalendarDate,
                  onDateTap: (dateKey) => scrollToDate(dateKey),
                );
              }
              return KeyedSubtree(key: _budgetKey, child: const _MonthlySummaryCard());
            }),
          if (!_isDemo)
            Consumer(builder: (context, ref, _) {
              final viewMode = ref.watch(householdViewModeProvider);
              if (viewMode == HouseholdViewMode.calendar) {
                return const SizedBox.shrink();
              }
              return const _UnpaidRecurringBanner();
            }),
          Expanded(
            child: _isDemo
                ? _DemoExpenseList(expenses: _demoExpenses)
                : _ExpenseBody(
                    selectedGroupId: selectedGroupId,
                    scrollController: _scrollController,
                    itemKeys: _itemKeys,
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: _fabKey,
        onPressed: () => context.push(
          AppRoutes.householdAdd,
          extra: {'groupId': selectedGroupId},
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// 월 이동 버튼 (GroupFilterBar trailing으로 사용)
class _MonthNavigator extends ConsumerWidget {
  final String selectedMonth;

  const _MonthNavigator({required this.selectedMonth});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = ref.watch(householdViewModeProvider);
    return Row(
      children: [
        IconButton(
          onPressed: () => _changeMonth(ref, -1),
          icon: const Icon(Icons.chevron_left),
          visualDensity: VisualDensity.compact,
        ),
        Text(
          _formatMonth(selectedMonth),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        IconButton(
          onPressed: () => _changeMonth(ref, 1),
          icon: const Icon(Icons.chevron_right),
          visualDensity: VisualDensity.compact,
        ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: () {
            ref.read(householdViewModeProvider.notifier).state =
                viewMode == HouseholdViewMode.list
                    ? HouseholdViewMode.calendar
                    : HouseholdViewMode.list;
          },
          icon: Icon(
            viewMode == HouseholdViewMode.list
                ? Icons.calendar_month_outlined
                : Icons.view_list_outlined,
          ),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }

  void _changeMonth(WidgetRef ref, int delta) {
    final parts = selectedMonth.split('-');
    var year = int.parse(parts[0]);
    var month = int.parse(parts[1]) + delta;
    if (month > 12) {
      month = 1;
      year++;
    } else if (month < 1) {
      month = 12;
      year--;
    }
    ref.read(householdSelectedMonthProvider.notifier).state =
        '$year-${month.toString().padLeft(2, '0')}';
  }

  String _formatMonth(String month) {
    final parts = month.split('-');
    return '${parts[0]}.${parts[1]}';
  }
}

// 월간 요약 카드
class _MonthlySummaryCard extends ConsumerWidget {
  final MonthlyStatisticsModel? demoStats;

  const _MonthlySummaryCard({this.demoStats});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    if (demoStats != null) {
      return _buildCard(context, ref, l10n, demoStats!, null, false);
    }

    final statsAsync = ref.watch(householdMonthlyStatisticsProvider);
    final selectedMonth = ref.watch(householdSelectedMonthProvider);
    final selectedGroupId = ref.watch(householdSelectedGroupIdProvider);

    final now = DateTime.now();
    final currentMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    final prevMonth = now.month == 1
        ? '${now.year - 1}-12'
        : '${now.year}-${(now.month - 1).toString().padLeft(2, '0')}';
    final isCurrentMonth = selectedMonth == currentMonth || selectedMonth == prevMonth;

    return statsAsync.when(
      data: (stats) => _buildCard(context, ref, l10n, stats, selectedGroupId, isCurrentMonth),
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSizes.spaceM),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Widget _buildCard(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    MonthlyStatisticsModel stats,
    String? selectedGroupId,
    bool isCurrentMonth,
  ) {
    return Container(
        margin: const EdgeInsets.all(AppSizes.spaceM),
        padding: const EdgeInsets.all(AppSizes.spaceM),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        child: Column(
          children: [
            stats.hasIncome
                ? Row(
                    children: [
                      Expanded(
                        child: _SummaryItem(
                          label: l10n.household_total_income,
                          amount: stats.totalIncome,
                          color: Colors.green.shade700,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.2),
                      ),
                      Expanded(
                        child: _SummaryItem(
                          label: l10n.household_total_expense,
                          amount: stats.totalExpense,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.2),
                      ),
                      Expanded(
                        child: _SummaryItem(
                          label: l10n.household_balance,
                          amount: stats.balance,
                          color: stats.balance >= 0
                              ? Colors.green.shade700
                              : Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: _SummaryItem(
                          label: l10n.household_total_expense,
                          amount: stats.totalExpense,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.2),
                      ),
                      Expanded(
                        child: _SummaryItem(
                          label: l10n.household_total_budget,
                          amount: stats.totalBudget,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
            // 예산 진척도 바 (예산이 설정된 경우)
            if (stats.totalBudget > 0) ...[
              const SizedBox(height: AppSizes.spaceS),
              _BudgetProgressBar(
                spent: stats.totalExpense,
                budget: stats.totalBudget,
              ),
            ],
            // 잔금이 있고 이번 달 또는 지난달일 때 이월 버튼
            if (isCurrentMonth && stats.hasIncome && stats.balance > 0) ...[
              const SizedBox(height: AppSizes.spaceS),
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.15),
              ),
              const SizedBox(height: AppSizes.spaceXS),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () => _showCarryOverBottomSheet(
                    context,
                    balance: stats.balance,
                    groupId: selectedGroupId,
                    currentMonth: stats.month,
                  ),
                  icon: Icon(
                    Icons.swap_horiz,
                    size: 16,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  label: Text(
                    l10n.household_balance_transfer,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
  }

  Future<void> _showCarryOverBottomSheet(
    BuildContext context, {
    required double balance,
    required String? groupId,
    required String currentMonth,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _CarryOverBottomSheet(
        balance: balance,
        groupId: groupId,
        currentMonth: currentMonth,
      ),
    );
  }
}

class _BudgetProgressBar extends StatelessWidget {
  final double spent;
  final double budget;

  const _BudgetProgressBar({required this.spent, required this.budget});

  @override
  Widget build(BuildContext context) {
    final rawRatio = spent / budget;
    final ratio = rawRatio.clamp(0.0, 1.0);
    final percent = (rawRatio * 100).toStringAsFixed(1);
    final isOver = spent > budget;
    final colorScheme = Theme.of(context).colorScheme;
    final Color barColor;
    if (isOver) {
      barColor = colorScheme.error;
    } else if (rawRatio >= 0.8) {
      barColor = const Color(0xFFF59E0B); // amber-500
    } else {
      barColor = colorScheme.primary;
    }
    final textColor = colorScheme.onPrimaryContainer.withValues(alpha: 0.8);

    final spentStr = _fmt(spent);
    final budgetStr = _fmt(budget);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '예산 ₩$budgetStr 중 ₩$spentStr ($percent%) 사용',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: textColor,
                    fontSize: 11,
                  ),
            ),
            if (isOver)
              Text(
                '초과',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colorScheme.error,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 4,
            backgroundColor:
                colorScheme.onPrimaryContainer.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
      ],
    );
  }

  String _fmt(double v) {
    final s = v.toInt().toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;

  const _SummaryItem({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
        ),
        const SizedBox(height: AppSizes.spaceXS),
        Text(
          '₩${_formatAmount(amount)}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
      ],
    );
  }

  String _formatAmount(double amount) {
    final intAmount = amount.toInt();
    final str = intAmount.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write(',');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }
}

// 뷰 모드에 따라 리스트/캘린더를 전환하는 컨테이너
class _ExpenseBody extends ConsumerWidget {
  final String? selectedGroupId;
  final ScrollController scrollController;
  final Map<String, GlobalKey> itemKeys;

  const _ExpenseBody({
    required this.selectedGroupId,
    required this.scrollController,
    required this.itemKeys,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(householdExpensesProvider);

    return expensesAsync.when(
      data: (expenses) {
        final sorted = [...expenses]..sort((a, b) => b.date.compareTo(a.date));
        final grouped = <String, List<ExpenseModel>>{};
        for (final e in sorted) {
          final key =
              '${e.date.year}-${e.date.month.toString().padLeft(2, '0')}-${e.date.day.toString().padLeft(2, '0')}';
          grouped.putIfAbsent(key, () => []).add(e);
        }
        final dateKeys = grouped.keys.toList();

        for (final k in dateKeys) {
          itemKeys.putIfAbsent(k, () => GlobalKey());
        }

        // 리스트 뷰
        if (expenses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long, size: 64,
                    color: Theme.of(context).colorScheme.outline),
                const SizedBox(height: AppSizes.spaceM),
                Text(
                  AppLocalizations.of(context)!.household_no_expenses,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => ref.read(householdExpensesProvider.notifier).refresh(),
          child: ListView.builder(
            controller: scrollController,
            itemCount: dateKeys.length,
            padding: const EdgeInsets.only(bottom: 80),
            // 월 전체 아이템을 미리 렌더링해두어 캘린더 탭 스크롤이 정확히 동작
            cacheExtent: 8000,
            itemBuilder: (context, index) {
              final dateKey = dateKeys[index];
              final dayExpenses = grouped[dateKey]!;
              return _DayGroup(
                key: itemKeys[dateKey],
                dateKey: dateKey,
                expenses: dayExpenses,
                onTap: (e) => context.push(AppRoutes.householdDetail, extra: e),
                onDelete: (e) => _confirmDelete(context, ref, dayExpenses, e),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.common_error,
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: AppSizes.spaceS),
            ElevatedButton(
              onPressed: () => ref.read(householdExpensesProvider.notifier).refresh(),
              child: Text(AppLocalizations.of(context)!.common_retry),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    List<ExpenseModel> dayExpenses,
    ExpenseModel expense,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.household_delete_expense),
        content: Text(l10n.household_delete_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.common_delete,
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final success = await ref
        .read(householdManagementProvider.notifier)
        .deleteExpense(expense.id);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? l10n.household_delete_success : l10n.common_error),
      ),
    );
  }
}

// 상단 캘린더 요약 (요약카드 자리를 대체)
class _CalendarSummary extends ConsumerWidget {
  final String? selectedDateKey;
  final void Function(String dateKey) onDateTap;

  const _CalendarSummary({
    required this.onDateTap,
    this.selectedDateKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(householdExpensesProvider);
    final selectedMonth = ref.watch(householdSelectedMonthProvider);
    final excludeRefunds = ref.watch(householdExcludeRefundsProvider);
    final excludeCarryover = ref.watch(householdExcludeCarryoverProvider);

    return expensesAsync.when(
      data: (expenses) {
        final grouped = <String, List<ExpenseModel>>{};
        for (final e in expenses) {
          final key =
              '${e.date.year}-${e.date.month.toString().padLeft(2, '0')}-${e.date.day.toString().padLeft(2, '0')}';
          grouped.putIfAbsent(key, () => []).add(e);
        }
        final parts = selectedMonth.split('-');
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        return _CalendarView(
          year: year,
          month: month,
          grouped: grouped,
          selectedDateKey: selectedDateKey,
          excludeRefunds: excludeRefunds,
          excludeCarryover: excludeCarryover,
          onDateTap: onDateTap,
        );
      },
      loading: () => const SizedBox(
        height: 240,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

// 캘린더 뷰
class _CalendarView extends StatelessWidget {
  final int year;
  final int month;
  final Map<String, List<ExpenseModel>> grouped;
  final String? selectedDateKey;
  final bool excludeRefunds;
  final bool excludeCarryover;
  final void Function(String dateKey) onDateTap;

  const _CalendarView({
    required this.year,
    required this.month,
    required this.grouped,
    required this.onDateTap,
    this.selectedDateKey,
    this.excludeRefunds = false,
    this.excludeCarryover = false,
  });

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    // 월요일 시작 기준 (0=월 ... 6=일)
    final startWeekday = (firstDayOfMonth.weekday - 1) % 7;

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSizes.spaceM, 0, AppSizes.spaceM, AppSizes.spaceS),
      child: Column(
        children: [
          // 요일 헤더
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: ['월', '화', '수', '목', '금', '토', '일']
                  .map((d) => Expanded(
                        child: Center(
                          child: Text(d,
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                      ))
                  .toList(),
            ),
          ),
          // 날짜 그리드
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.95,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
            ),
            itemCount: startWeekday + daysInMonth,
            itemBuilder: (context, index) {
              if (index < startWeekday) return const SizedBox.shrink();
              final day = index - startWeekday + 1;
              final dateKey =
                  '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
              final dayExpenses = grouped[dateKey];
              final hasData = dayExpenses != null && dayExpenses.isNotEmpty;

              double incomeTotal = 0;
              double expenseTotal = 0;
              if (hasData) {
                for (final e in dayExpenses) {
                  if (e.type == TransactionType.income) {
                    if (excludeRefunds && e.refundedExpenseId != null) continue;
                    if (excludeCarryover && e.incomeCategory == IncomeCategory.carryover) continue;
                    incomeTotal += e.amount;
                  } else {
                    if (excludeRefunds && e.refunds.isNotEmpty) continue;
                    if (excludeCarryover && e.category == ExpenseCategory.carryover) continue;
                    expenseTotal += e.amount;
                  }
                }
              }

              final isToday = DateTime.now().year == year &&
                  DateTime.now().month == month &&
                  DateTime.now().day == day;
              final isSelected = dateKey == selectedDateKey;

              return GestureDetector(
                onTap: hasData ? () => onDateTap(dateKey) : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary.withValues(alpha: 0.15)
                        : isToday
                            ? colorScheme.primaryContainer.withValues(alpha: 0.5)
                            : null,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    border: isSelected
                        ? Border.all(color: colorScheme.primary, width: 1.5)
                        : isToday
                            ? Border.all(
                                color: colorScheme.primary.withValues(alpha: 0.4),
                                width: 1)
                            : null,
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 1, vertical: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 날짜 숫자
                      Text(
                        '$day',
                        style: textTheme.labelSmall?.copyWith(
                          fontSize: 10,
                          fontWeight: (isToday || isSelected)
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? colorScheme.primary
                              : isToday
                                  ? colorScheme.primary
                                  : colorScheme.onSurface,
                        ),
                      ),
                      if (hasData) ...[
                        if (expenseTotal > 0)
                          Text(
                            '-${_compact(expenseTotal)}',
                            style: textTheme.labelSmall?.copyWith(
                              fontSize: 8,
                              color: colorScheme.error,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (incomeTotal > 0)
                          Text(
                            '+${_compact(incomeTotal)}',
                            style: textTheme.labelSmall?.copyWith(
                              fontSize: 8,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // 금액을 짧게 표시: 10000 → 1만, 150000 → 15만, 1500000 → 150만
  String _compact(double amount) {
    final v = amount.toInt();
    if (v >= 10000000) return '${(v / 10000000).toStringAsFixed(0)}천만';
    if (v >= 1000000) return '${(v / 10000).toStringAsFixed(0)}만';
    if (v >= 10000) {
      final man = v ~/ 10000;
      final rem = (v % 10000) ~/ 1000;
      return rem > 0 ? '$man.$rem만' : '$man만';
    }
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}천';
    return '$v';
  }
}

// 일 단위 그룹 헤더 + 거래 목록
class _DayGroup extends ConsumerWidget {
  final String dateKey; // 'YYYY-MM-DD'
  final List<ExpenseModel> expenses;
  final void Function(ExpenseModel) onTap;
  final void Function(ExpenseModel) onDelete;

  const _DayGroup({
    super.key,
    required this.dateKey,
    required this.expenses,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final excludeRefunds = ref.watch(householdExcludeRefundsProvider);
    final excludeCarryover = ref.watch(householdExcludeCarryoverProvider);

    final parts = dateKey.split('-');
    final month = int.parse(parts[1]);
    final day = int.parse(parts[2]);

    double totalIncome = 0;
    double totalExpense = 0;
    for (final e in expenses) {
      if (e.type == TransactionType.income) {
        if (excludeRefunds && e.refundedExpenseId != null) continue;
        if (excludeCarryover && e.incomeCategory == IncomeCategory.carryover) continue;
        totalIncome += e.amount;
      } else {
        if (excludeRefunds && e.refunds.isNotEmpty) continue;
        if (excludeCarryover && e.category == ExpenseCategory.carryover) continue;
        totalExpense += e.amount;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 날짜 헤더 + 일별 요약
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.spaceM,
            AppSizes.spaceM,
            AppSizes.spaceM,
            AppSizes.spaceS,
          ),
          child: Row(
            children: [
              Text(
                '$month월 $day일',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              if (totalIncome > 0)
                Text(
                  '₩${_fmt(totalIncome)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              if (totalIncome > 0 && totalExpense > 0)
                Text(
                  '  ',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              if (totalExpense > 0)
                Text(
                  '-₩${_fmt(totalExpense)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                ),
            ],
          ),
        ),
        Divider(
          height: 1,
          thickness: 0.5,
          indent: AppSizes.spaceM,
          endIndent: AppSizes.spaceM,
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        const SizedBox(height: AppSizes.spaceXS),
        ...expenses.map(
          (e) => Dismissible(
            key: ValueKey(e.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: AppSizes.spaceL),
              margin: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceM,
                vertical: AppSizes.spaceXS,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
              child: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.onErrorContainer,
                size: 22,
              ),
            ),
            confirmDismiss: (_) async {
              onDelete(e);
              return false;
            },
            child: ExpenseListItem(
              expense: e,
              onTap: () => onTap(e),
            ),
          ),
        ),
      ],
    );
  }

  String _fmt(double amount) {
    final str = amount.toInt().toString();
    final buf = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write(',');
      buf.write(str[i]);
    }
    return buf.toString();
  }
}

// 이번 달 미치뤄진 고정 지출 배너
class _UnpaidRecurringBanner extends ConsumerWidget {
  const _UnpaidRecurringBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unpaid = ref.watch(householdUnpaidRecurringProvider);
    final selectedMonth = ref.watch(householdSelectedMonthProvider);

    // 이번 달이 아닌 달을 보고 있으면 표시 안 함
    final now = DateTime.now();
    final currentMonth =
        '${now.year}-${now.month.toString().padLeft(2, '0')}';
    if (unpaid.isEmpty || selectedMonth != currentMonth) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final expenseItems =
        unpaid.where((e) => e.type == TransactionType.expense).toList();
    final incomeItems =
        unpaid.where((e) => e.type == TransactionType.income).toList();
    final totalExpense =
        expenseItems.fold(0.0, (sum, e) => sum + e.amount);
    final totalIncome =
        incomeItems.fold(0.0, (sum, e) => sum + e.amount);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.spaceM,
        0,
        AppSizes.spaceM,
        AppSizes.spaceS,
      ),
      child: InkWell(
        onTap: () => context.push(AppRoutes.householdRecurring),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceM,
            vertical: AppSizes.spaceS,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            border: Border.all(
              color: colorScheme.outlineVariant,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.repeat_outlined,
                size: 18,
                color: colorScheme.primary,
              ),
              const SizedBox(width: AppSizes.spaceS),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.household_unpaid_recurring_title,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        if (expenseItems.isNotEmpty)
                          Text(
                            l10n.household_unpaid_recurring_expense(
                              expenseItems.length,
                              _fmtAmount(totalExpense),
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: colorScheme.error,
                                ),
                          ),
                        if (expenseItems.isNotEmpty && incomeItems.isNotEmpty)
                          Text(
                            '  ',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: colorScheme.onErrorContainer
                                      .withValues(alpha: 0.5),
                                ),
                          ),
                        if (incomeItems.isNotEmpty)
                          Text(
                            l10n.household_unpaid_recurring_income(
                              incomeItems.length,
                              _fmtAmount(totalIncome),
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Colors.teal,
                                ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _fmtAmount(double amount) {
    final str = amount.toInt().toString();
    final buf = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write(',');
      buf.write(str[i]);
    }
    return buf.toString();
  }
}

// 환불/이월 제외 체크 필터 바
class _ExcludeFilterBar extends ConsumerWidget {
  const _ExcludeFilterBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final excludeRefunds = ref.watch(householdExcludeRefundsProvider);
    final excludeCarryover = ref.watch(householdExcludeCarryoverProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceXS,
      ),
      child: Row(
        children: [
          Icon(
            Icons.filter_alt_outlined,
            size: 15,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: AppSizes.spaceS),
          _FilterChip(
            label: l10n.household_exclude_refunds,
            selected: excludeRefunds,
            onTap: () => ref
                .read(householdExcludeRefundsProvider.notifier)
                .state = !excludeRefunds,
          ),
          const SizedBox(width: AppSizes.spaceS),
          _FilterChip(
            label: l10n.household_exclude_carryover,
            selected: excludeCarryover,
            onTap: () => ref
                .read(householdExcludeCarryoverProvider.notifier)
                .state = !excludeCarryover,
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? colorScheme.onSurface
                : colorScheme.outlineVariant,
            width: selected ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(Icons.check,
                    size: 12, color: colorScheme.onSurface),
              ),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: selected
                        ? colorScheme.onSurface
                        : colorScheme.onSurfaceVariant,
                    fontWeight:
                        selected ? FontWeight.w600 : FontWeight.normal,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 잔금 이동 바텀시트 ──────────────────────────────────────────────────────────

enum _CarryOverMode { nextMonth, asset, savings }

class _CarryOverBottomSheet extends ConsumerStatefulWidget {
  const _CarryOverBottomSheet({
    required this.balance,
    required this.groupId,
    required this.currentMonth,
  });

  final double balance;
  final String? groupId;
  final String currentMonth;

  @override
  ConsumerState<_CarryOverBottomSheet> createState() =>
      _CarryOverBottomSheetState();
}

class _CarryOverBottomSheetState extends ConsumerState<_CarryOverBottomSheet> {
  late final TextEditingController _amountController;
  _CarryOverMode _mode = _CarryOverMode.nextMonth;
  AccountModel? _selectedAccount;
  SavingsGoalModel? _selectedSavings;
  bool _isSubmitting = false;
  List<AccountModel> _accounts = [];
  List<SavingsGoalModel> _savingsGoals = [];

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.balance.toInt().toString(),
    );
    _loadOptions();
  }

  Future<void> _loadOptions() async {
    if (widget.groupId == null) return;
    try {
      final results = await Future.wait([
        ref.read(assetRepositoryProvider).getAccounts(groupId: widget.groupId!),
        ref.read(savingsRepositoryProvider).getGoals(widget.groupId!),
      ]);
      if (!mounted) return;
      setState(() {
        _accounts = results[0] as List<AccountModel>;
        _savingsGoals = (results[1] as List<SavingsGoalModel>)
            .where((g) => g.status == SavingsGoalStatus.active)
            .toList();
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double get _parsedAmount =>
      double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0;

  bool get _isValid {
    final a = _parsedAmount;
    if (a <= 0 || a > widget.balance) return false;
    if (_mode == _CarryOverMode.asset && _selectedAccount == null) return false;
    if (_mode == _CarryOverMode.savings && _selectedSavings == null) return false;
    return true;
  }

  Future<void> _onConfirm() async {
    setState(() => _isSubmitting = true);
    final amount = _parsedAmount;
    final notifier = ref.read(householdManagementProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    bool success;
    String successMsg;

    switch (_mode) {
      case _CarryOverMode.nextMonth:
        success = await notifier.carryOverBalance(
          groupId: widget.groupId,
          balance: amount,
          currentMonth: widget.currentMonth,
        );
        successMsg = l10n.household_carry_over_success;
      case _CarryOverMode.asset:
        success = await notifier.transferToAsset(
          groupId: widget.groupId,
          amount: amount,
          accountId: _selectedAccount!.id,
          accountName: _selectedAccount!.name,
          currentBalance: _selectedAccount!.latestBalance,
          currentMonth: widget.currentMonth,
        );
        successMsg = l10n.household_transfer_success;
      case _CarryOverMode.savings:
        success = await notifier.transferToSavings(
          groupId: widget.groupId,
          amount: amount,
          savingsId: _selectedSavings!.id,
          savingsName: _selectedSavings!.name,
          currentMonth: widget.currentMonth,
        );
        successMsg = l10n.household_transfer_success;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? successMsg : l10n.common_error)),
    );
    if (success) Navigator.pop(context);
    setState(() => _isSubmitting = false);
  }

  String _fmt(int value) {
    final str = value.toString();
    final buf = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write(',');
      buf.write(str[i]);
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final amountError = _parsedAmount > widget.balance
        ? l10n.household_carry_over_amount_exceeded
        : null;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSizes.spaceL,
        right: AppSizes.spaceL,
        top: AppSizes.spaceM,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSizes.spaceL,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            l10n.household_balance_transfer,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSizes.spaceXS),
          Text(
            '${l10n.household_balance}: ₩${_fmt(widget.balance.toInt())}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: AppSizes.spaceM),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.household_carry_over_amount_label,
              suffix: Text('원',
                  style: Theme.of(context).textTheme.bodyMedium),
              errorText: amountError,
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSizes.spaceM),
          SegmentedButton<_CarryOverMode>(
            segments: [
              ButtonSegment(
                value: _CarryOverMode.nextMonth,
                label: Text(l10n.household_carry_over_mode_next_month,
                    overflow: TextOverflow.ellipsis),
              ),
              ButtonSegment(
                value: _CarryOverMode.asset,
                label: Text(l10n.household_carry_over_mode_asset,
                    overflow: TextOverflow.ellipsis),
              ),
              ButtonSegment(
                value: _CarryOverMode.savings,
                label: Text(l10n.household_carry_over_mode_savings,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
            selected: {_mode},
            onSelectionChanged: (s) => setState(() {
              _mode = s.first;
              _selectedAccount = null;
              _selectedSavings = null;
            }),
            showSelectedIcon: false,
            style: const ButtonStyle(
              visualDensity: VisualDensity.compact,
            ),
          ),
          if (_mode == _CarryOverMode.asset) ...[
            const SizedBox(height: AppSizes.spaceS),
            _CarryOverTargetList<AccountModel>(
              items: _accounts,
              emptyText: l10n.household_carry_over_no_accounts,
              selectedId: _selectedAccount?.id,
              getId: (a) => a.id,
              getTitle: (a) => a.name,
              getSubtitle: (a) => a.latestBalance != null
                  ? '₩${_fmt(a.latestBalance!.toInt())}'
                  : null,
              onSelect: (a) => setState(() => _selectedAccount = a),
            ),
          ],
          if (_mode == _CarryOverMode.savings) ...[
            const SizedBox(height: AppSizes.spaceS),
            _CarryOverTargetList<SavingsGoalModel>(
              items: _savingsGoals,
              emptyText: l10n.household_carry_over_no_savings,
              selectedId: _selectedSavings?.id,
              getId: (g) => g.id,
              getTitle: (g) => g.name,
              getSubtitle: (g) =>
                  '₩${_fmt(g.currentAmount.toInt())} / '
                  '${g.targetAmount != null ? '₩${_fmt(g.targetAmount!.toInt())}' : '∞'}',
              onSelect: (g) => setState(() => _selectedSavings = g),
            ),
          ],
          const SizedBox(height: AppSizes.spaceM),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed:
                      _isSubmitting ? null : () => Navigator.pop(context),
                  child: Text(l10n.common_cancel),
                ),
              ),
              const SizedBox(width: AppSizes.spaceS),
              Expanded(
                child: FilledButton(
                  onPressed: (_isValid && !_isSubmitting) ? _onConfirm : null,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.household_balance_transfer),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CarryOverTargetList<T> extends StatelessWidget {
  const _CarryOverTargetList({
    required this.items,
    required this.emptyText,
    required this.selectedId,
    required this.getId,
    required this.getTitle,
    required this.getSubtitle,
    required this.onSelect,
  });

  final List<T> items;
  final String emptyText;
  final String? selectedId;
  final String Function(T) getId;
  final String Function(T) getTitle;
  final String? Function(T) getSubtitle;
  final void Function(T) onSelect;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceXS),
        child: Text(
          emptyText,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      );
    }
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (_, i) {
          final item = items[i];
          final sub = getSubtitle(item);
          return RadioListTile<String>(
            value: getId(item),
            groupValue: selectedId,
            onChanged: (_) => onSelect(item),
            title: Text(getTitle(item),
                style: Theme.of(context).textTheme.bodyMedium),
            subtitle: sub != null
                ? Text(sub,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ))
                : null,
            dense: true,
            contentPadding: EdgeInsets.zero,
          );
        },
      ),
    );
  }
}
