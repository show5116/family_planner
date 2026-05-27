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
          const _MonthlySummaryCard(),
          Expanded(
            child: _ExpenseList(selectedGroupId: selectedGroupId),
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

    return statsAsync.when(
      data: (stats) => Container(
        margin: const EdgeInsets.all(AppSizes.spaceM),
        padding: const EdgeInsets.all(AppSizes.spaceM),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        child: stats.hasIncome
            ? Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryItem(
                          label: l10n.household_total_income,
                          amount: stats.totalIncome,
                          color: Colors.green,
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
                              ? Colors.green
                              : Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
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
      ),
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSizes.spaceM),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => const SizedBox.shrink(),
    );
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

// 지출 목록
class _ExpenseList extends ConsumerWidget {
  final String? selectedGroupId;

  const _ExpenseList({required this.selectedGroupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final expensesAsync = ref.watch(householdExpensesProvider);

    return expensesAsync.when(
      data: (expenses) {
        if (expenses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long,
                  size: 64,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: AppSizes.spaceM),
                Text(
                  l10n.household_no_expenses,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
              ],
            ),
          );
        }

        // 날짜 내림차순 정렬 후 일 단위 그룹핑
        final sorted = [...expenses]..sort((a, b) => b.date.compareTo(a.date));
        final grouped = <String, List<ExpenseModel>>{};
        for (final e in sorted) {
          final key =
              '${e.date.year}-${e.date.month.toString().padLeft(2, '0')}-${e.date.day.toString().padLeft(2, '0')}';
          grouped.putIfAbsent(key, () => []).add(e);
        }
        final dateKeys = grouped.keys.toList();

        return RefreshIndicator(
          onRefresh: () => ref.read(householdExpensesProvider.notifier).refresh(),
          child: ListView.builder(
            itemCount: dateKeys.length,
            padding: const EdgeInsets.only(bottom: 80),
            itemBuilder: (context, index) {
              final dateKey = dateKeys[index];
              final dayExpenses = grouped[dateKey]!;
              return _DayGroup(
                dateKey: dateKey,
                expenses: dayExpenses,
                onTap: (e) => context.push(AppRoutes.householdDetail, extra: e),
                onDelete: (e) => _confirmDelete(context, ref, l10n, e),
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
            Text(
              l10n.common_error,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSizes.spaceS),
            ElevatedButton(
              onPressed: () => ref.read(householdExpensesProvider.notifier).refresh(),
              child: Text(l10n.common_retry),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    ExpenseModel expense,
  ) async {
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
            child: Text(
              l10n.common_delete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
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

// 일 단위 그룹 헤더 + 거래 목록
class _DayGroup extends StatelessWidget {
  final String dateKey; // 'YYYY-MM-DD'
  final List<ExpenseModel> expenses;
  final void Function(ExpenseModel) onTap;
  final void Function(ExpenseModel) onDelete;

  const _DayGroup({
    required this.dateKey,
    required this.expenses,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final parts = dateKey.split('-');
    final month = int.parse(parts[1]);
    final day = int.parse(parts[2]);

    double totalIncome = 0;
    double totalExpense = 0;
    for (final e in expenses) {
      if (e.type == TransactionType.income) {
        totalIncome += e.amount;
      } else {
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
            AppSizes.spaceXS,
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
                        color: Colors.green,
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
