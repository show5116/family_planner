import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/shared/widgets/app_bar_more_menu.dart';
import 'package:family_planner/features/main/household/data/models/expense_model.dart';
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
  final _scrollController = ScrollController();
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
      _showCoachMark();
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

  TargetPosition? _keyToPosition(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final offset = box.localToGlobal(Offset.zero);
    return TargetPosition(box.size, offset);
  }

  void _replayOnboarding() => _showCoachMark(force: true);

  Future<void> _showCoachMark({bool force = false}) async {
    if (!force) {
      final completed =
          await OnboardingService.isCoachMarkCompleted(CoachMarkKeys.household);
      if (completed || !mounted) return;
    }
    if (!mounted) return;

    final budgetPos = _keyToPosition(_budgetKey);
    final recurringPos = _keyToPosition(_recurringKey);
    final statisticsPos = _keyToPosition(_statisticsKey);
    final fabPos = _keyToPosition(_fabKey);

    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'household_budget',
        targetPosition: budgetPos,
        keyTarget: budgetPos == null ? _budgetKey : null,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '예산 설정',
              description: '월별 예산을 설정하면 지출 현황과\n남은 예산을 한눈에 확인할 수 있어요.',
              icon: Icons.account_balance_wallet_outlined,
              color: Colors.teal,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'household_recurring',
        targetPosition: recurringPos,
        keyTarget: recurringPos == null ? _recurringKey : null,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '고정 지출',
              description: '월세, 구독료 등 매달 반복되는 지출을\n등록하면 자동으로 기록해 드려요.',
              icon: Icons.repeat,
              color: Colors.indigo,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'household_statistics',
        targetPosition: statisticsPos,
        keyTarget: statisticsPos == null ? _statisticsKey : null,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '통계',
              description: '카테고리별 지출 비율과 월별 추이를\n차트로 확인할 수 있어요.',
              icon: Icons.bar_chart,
              color: Colors.purple,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'household_fab',
        targetPosition: fabPos,
        keyTarget: fabPos == null ? _fabKey : null,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '지출/수입 추가',
              description: '새 지출이나 수입을 기록하세요.\n그룹별로 나눠서 관리할 수 있어요.',
              icon: Icons.add,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    ];
    await FeatureCoachMark.waitForTargets(targets, context);
    if (!mounted) return;
    TutorialCoachMark(
      targets: FeatureCoachMark.refreshPositions(targets),
      colorShadow: const Color(0xFF212121),
      opacityShadow: 0.85,
      textSkip: '건너뛰기',
      alignSkip: Alignment.bottomLeft,
      skipWidget: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white30),
        ),
        child: const Text(
          '건너뛰기',
          style: TextStyle(
              color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
      onFinish: () => OnboardingService.completeCoachMark(CoachMarkKeys.household),
      onSkip: () {
        OnboardingService.completeCoachMark(CoachMarkKeys.household);
        return true;
      },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
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
            key: _budgetKey,
            icon: const Icon(Icons.account_balance_wallet_outlined),
            tooltip: l10n.household_budget_set,
            onPressed: () => showBudgetSettingSheet(context),
          ),
          IconButton(
            icon: const Icon(Icons.storefront_outlined),
            tooltip: l10n.household_merchants,
            onPressed: () => context.push(AppRoutes.householdMerchants),
          ),
          IconButton(
            key: _recurringKey,
            icon: const Icon(Icons.repeat),
            tooltip: l10n.household_recurring_expenses,
            onPressed: () => context.push(AppRoutes.householdRecurring),
          ),
          IconButton(
            key: _statisticsKey,
            icon: const Icon(Icons.bar_chart),
            tooltip: l10n.household_statistics,
            onPressed: () => context.push(AppRoutes.householdStatistics),
          ),
          // TODO: 결제 알림 자동 등록 기능 — 앱 심사 통과 후 주석 해제
          // if (!kIsWeb && Platform.isAndroid)
          //   IconButton(
          //     icon: const Icon(Icons.receipt_long_outlined),
          //     tooltip: l10n.household_settings_title,
          //     onPressed: () => context.push(AppRoutes.householdSettings),
          //   ),
          AppBarMoreMenu(onReplayOnboarding: _replayOnboarding),
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
          Consumer(builder: (context, ref, _) {
            final viewMode = ref.watch(householdViewModeProvider);
            if (viewMode == HouseholdViewMode.calendar) {
              return _CalendarSummary(
                selectedDateKey: _selectedCalendarDate,
                onDateTap: (dateKey) => scrollToDate(dateKey),
              );
            }
            return const _MonthlySummaryCard();
          }),
          const _UnpaidRecurringBanner(),
          Expanded(
            child: _ExpenseBody(
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
  const _MonthlySummaryCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final statsAsync = ref.watch(householdMonthlyStatisticsProvider);
    final selectedMonth = ref.watch(householdSelectedMonthProvider);
    final selectedGroupId = ref.watch(householdSelectedGroupIdProvider);

    // 이번 달일 때만 이월 버튼 표시
    final now = DateTime.now();
    final currentMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    final isCurrentMonth = selectedMonth == currentMonth;

    return statsAsync.when(
      data: (stats) => Container(
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
            // 잔금이 있고 이번 달일 때 이월 버튼
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
                  onPressed: () => _showCarryOverDialog(
                    context, ref, l10n,
                    balance: stats.balance,
                    groupId: selectedGroupId,
                    currentMonth: selectedMonth,
                  ),
                  icon: Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  label: Text(
                    l10n.household_carry_over,
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
      ),
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSizes.spaceM),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Future<void> _showCarryOverDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n, {
    required double balance,
    required String? groupId,
    required String currentMonth,
  }) async {
    final amountStr = _fmtAmount(balance);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.household_carry_over_title),
        content: Text(l10n.household_carry_over_desc(amountStr)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.common_cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.household_carry_over),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final success = await ref
        .read(householdManagementProvider.notifier)
        .carryOverBalance(
          groupId: groupId,
          balance: balance,
          currentMonth: currentMonth,
        );

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? l10n.household_carry_over_success : l10n.common_error,
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
          (e) => ExpenseListItem(
            expense: e,
            onTap: () => onTap(e),
            onDelete: () => onDelete(e),
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

    // 예상 합계: 가변은 estimatedAmount, 고정은 amount
    final total = unpaid.fold(0.0, (sum, e) {
      final amt = (e.isVariableRecurring && e.estimatedAmount != null)
          ? e.estimatedAmount!
          : e.amount;
      return sum + amt;
    });

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
            color: colorScheme.errorContainer.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            border: Border.all(
              color: colorScheme.error.withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.repeat_outlined,
                size: 18,
                color: colorScheme.error,
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
                            color: colorScheme.onErrorContainer,
                          ),
                    ),
                    Text(
                      l10n.household_unpaid_recurring_subtitle(
                        unpaid.length,
                        _fmtAmount(total),
                      ),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onErrorContainer
                                .withValues(alpha: 0.8),
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 18,
                color: colorScheme.onErrorContainer.withValues(alpha: 0.6),
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
