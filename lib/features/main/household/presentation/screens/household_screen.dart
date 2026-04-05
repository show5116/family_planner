import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/ai_chat/presentation/widgets/ai_chat_icon_button.dart';
import 'package:family_planner/features/main/household/data/models/expense_model.dart';
import 'package:family_planner/features/main/household/presentation/widgets/budget_setting_sheet.dart';
import 'package:family_planner/features/main/household/presentation/widgets/expense_list_item.dart';
import 'package:family_planner/features/main/household/providers/household_provider.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

class HouseholdScreen extends ConsumerStatefulWidget {
  const HouseholdScreen({super.key});

  @override
  ConsumerState<HouseholdScreen> createState() => _HouseholdScreenState();
}

class _HouseholdScreenState extends ConsumerState<HouseholdScreen> {
  @override
  void initState() {
    super.initState();
    // 그룹 목록 로드 후 첫 번째 그룹 자동 선택
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initGroupSelection();
    });
  }

  Future<void> _initGroupSelection() async {
    // 이미 선택된 상태(그룹 또는 개인)이면 유지
    // 처음 진입 시에만 첫 그룹을 자동 선택 (개인 모드는 null)
    // 별도 초기화 없이 null(개인 모드) 유지
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final groupsAsync = ref.watch(myGroupsProvider);
    final selectedGroupId = ref.watch(householdSelectedGroupIdProvider);
    final selectedMonth = ref.watch(householdSelectedMonthProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.household_title),
        actions: [
          const AiChatIconButton(),
          IconButton(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            tooltip: l10n.household_budget_set,
            onPressed: () => showBudgetSettingSheet(context),
          ),
          IconButton(
            icon: const Icon(Icons.repeat),
            tooltip: l10n.household_recurring_expenses,
            onPressed: () => context.push(AppRoutes.householdRecurring),
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: l10n.household_statistics,
            onPressed: () => context.push(AppRoutes.householdStatistics),
          ),
        ],
      ),
      body: Column(
        children: [
          _GroupAndMonthBar(
            groupsAsync: groupsAsync,
            selectedGroupId: selectedGroupId,
            selectedMonth: selectedMonth,
          ),
          const _MonthlySummaryCard(),
          Expanded(
            child: _ExpenseList(selectedGroupId: selectedGroupId),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(
          AppRoutes.householdAdd,
          extra: {'groupId': selectedGroupId},
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// 그룹 선택 + 월 이동 바
class _GroupAndMonthBar extends ConsumerWidget {
  final AsyncValue<List<Group>> groupsAsync;
  final String? selectedGroupId;
  final String selectedMonth;

  const _GroupAndMonthBar({
    required this.groupsAsync,
    required this.selectedGroupId,
    required this.selectedMonth,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceS,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // 그룹 드롭다운 (개인 모드 포함)
          Expanded(
            child: groupsAsync.when(
              data: (groups) {
                // 개인 항목 + 그룹 목록
                const personalValue = '__personal__';
                final currentValue = selectedGroupId ?? personalValue;
                final items = <DropdownMenuItem<String>>[
                  DropdownMenuItem<String>(
                    value: personalValue,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.person, size: 16),
                        const SizedBox(width: AppSizes.spaceXS),
                        Text(l10n.household_personal_mode),
                      ],
                    ),
                  ),
                  ...groups.map<DropdownMenuItem<String>>(
                    (g) => DropdownMenuItem<String>(
                      value: g.id,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.group, size: 16),
                          const SizedBox(width: AppSizes.spaceXS),
                          Text(g.name),
                        ],
                      ),
                    ),
                  ),
                ];
                return DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: currentValue,
                    isDense: true,
                    items: items,
                    onChanged: (value) {
                      ref.read(householdSelectedGroupIdProvider.notifier).state =
                          value == personalValue ? null : value;
                    },
                  ),
                );
              },
              loading: () => const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (_, _) => Text(l10n.household_no_group_selected),
            ),
          ),
          // 월 이동
          Row(
            children: [
              IconButton(
                onPressed: () => _changeMonth(ref, selectedMonth, -1),
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
                onPressed: () => _changeMonth(ref, selectedMonth, 1),
                icon: const Icon(Icons.chevron_right),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _changeMonth(WidgetRef ref, String currentMonth, int delta) {
    final parts = currentMonth.split('-');
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
        child: Row(
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

    if (selectedGroupId == null) {
      return Center(
        child: Text(
          l10n.household_no_group_selected,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

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

        // 날짜 내림차순 정렬
        final sorted = [...expenses]..sort((a, b) => b.date.compareTo(a.date));

        return RefreshIndicator(
          onRefresh: () => ref.read(householdExpensesProvider.notifier).refresh(),
          child: ListView.builder(
            itemCount: sorted.length,
            padding: const EdgeInsets.only(bottom: 80),
            itemBuilder: (context, index) {
              final expense = sorted[index];
              return ExpenseListItem(
                expense: expense,
                onTap: () => context.push(
                  AppRoutes.householdDetail,
                  extra: expense,
                ),
                onDelete: () => _confirmDelete(context, ref, l10n, expense),
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
