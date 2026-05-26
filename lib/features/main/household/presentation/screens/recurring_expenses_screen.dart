import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/main/household/data/models/expense_model.dart';
import 'package:family_planner/features/main/household/presentation/widgets/expense_list_item.dart';
import 'package:family_planner/features/main/household/providers/household_provider.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

class _RecurringSummary {
  final double totalExpense;
  final int count;
  final List<MapEntry<ExpenseCategory, double>> categoryAmounts;

  const _RecurringSummary({
    required this.totalExpense,
    required this.count,
    required this.categoryAmounts,
  });

  factory _RecurringSummary.from(List<ExpenseModel> expenses) {
    final expenseOnly = expenses.where((e) => e.type == TransactionType.expense).toList();
    final total = expenseOnly.fold(0.0, (sum, e) => sum + e.amount);

    final categorySum = <ExpenseCategory, double>{};
    for (final e in expenseOnly) {
      final key = e.category ?? ExpenseCategory.other;
      categorySum[key] = (categorySum[key] ?? 0) + e.amount;
    }
    final sorted = categorySum.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return _RecurringSummary(
      totalExpense: total,
      count: expenses.length,
      categoryAmounts: sorted,
    );
  }
}

class RecurringExpensesScreen extends ConsumerWidget {
  const RecurringExpensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedGroupId = ref.watch(householdSelectedGroupIdProvider);
    final recurringAsync = ref.watch(householdRecurringExpensesProvider);
    final groupsAsync = ref.watch(myGroupsProvider);
    final groupName = groupsAsync.whenOrNull(
      data: (groups) => groups
          .where((g) => g.id == selectedGroupId)
          .map((g) => g.name)
          .firstOrNull,
    );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.household_recurring_expenses),
            if (groupName != null)
              Text(
                groupName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
              ),
          ],
        ),
      ),
      body: recurringAsync.when(
        data: (expenses) => _RecurringExpensesList(
          expenses: expenses,
          selectedGroupId: selectedGroupId,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.common_error),
              const SizedBox(height: AppSizes.spaceS),
              ElevatedButton(
                onPressed: () =>
                    ref.invalidate(householdRecurringExpensesProvider),
                child: Text(l10n.common_retry),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: selectedGroupId == null
          ? null
          : FloatingActionButton(
              onPressed: () => context.push(
                AppRoutes.householdAdd,
                extra: {
                  'groupId': selectedGroupId,
                  'initialIsRecurring': true,
                },
              ),
              child: const Icon(Icons.add),
            ),
    );
  }
}

class _RecurringExpensesList extends ConsumerWidget {
  final List<ExpenseModel> expenses;
  final String? selectedGroupId;

  const _RecurringExpensesList({
    required this.expenses,
    required this.selectedGroupId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    if (expenses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.repeat,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: AppSizes.spaceM),
            Text(
              l10n.household_recurring_no_expenses,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      );
    }

    final sorted = [...expenses]..sort((a, b) => b.date.compareTo(a.date));
    final summary = _RecurringSummary.from(expenses);

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(householdRecurringExpensesProvider.notifier).refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: sorted.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _RecurringSummaryCard(summary: summary);
          }
          final expense = sorted[index - 1];
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

    if (success) {
      ref
          .read(householdRecurringExpensesProvider.notifier)
          .removeExpense(expense.id);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? l10n.household_delete_success : l10n.common_error),
      ),
    );
  }
}

class _RecurringSummaryCard extends StatelessWidget {
  final _RecurringSummary summary;

  const _RecurringSummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.spaceM,
        AppSizes.spaceM,
        AppSizes.spaceM,
        AppSizes.spaceS,
      ),
      child: Card(
        elevation: 0,
        color: colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          side: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 월 합계 + 항목 수
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.household_recurring_total,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '₩${_formatAmount(summary.totalExpense)}',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spaceM,
                      vertical: AppSizes.spaceS,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    ),
                    child: Column(
                      children: [
                        Text(
                          l10n.household_recurring_count,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSecondaryContainer,
                          ),
                        ),
                        Text(
                          l10n.household_recurring_count_unit(summary.count),
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // 카테고리별 분포
              if (summary.categoryAmounts.isNotEmpty) ...[
                const SizedBox(height: AppSizes.spaceM),
                Divider(color: colorScheme.outlineVariant, height: 1),
                const SizedBox(height: AppSizes.spaceM),
                Text(
                  l10n.household_recurring_top_category,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSizes.spaceS),
                ...summary.categoryAmounts.map(
                  (entry) => _CategoryBar(
                    category: entry.key,
                    amount: entry.value,
                    total: summary.totalExpense,
                    l10n: l10n,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
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

class _CategoryBar extends StatelessWidget {
  final ExpenseCategory category;
  final double amount;
  final double total;
  final AppLocalizations l10n;

  const _CategoryBar({
    required this.category,
    required this.amount,
    required this.total,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final ratio = total > 0 ? (amount / total).clamp(0.0, 1.0) : 0.0;
    final color = categoryColor(category);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
      child: Row(
        children: [
          Icon(categoryIcon(category), size: 14, color: color),
          const SizedBox(width: AppSizes.spaceS),
          SizedBox(
            width: 72,
            child: Text(
              categoryName(l10n, category),
              style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurface),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSizes.spaceS),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 6,
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
          const SizedBox(width: AppSizes.spaceS),
          Text(
            '₩${_formatAmount(amount)}',
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
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
