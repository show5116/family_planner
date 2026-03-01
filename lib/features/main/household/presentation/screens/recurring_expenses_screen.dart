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

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(householdRecurringExpensesProvider.notifier).refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: sorted.length,
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
