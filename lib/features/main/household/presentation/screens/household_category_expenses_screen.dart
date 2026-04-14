import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/main/household/data/models/expense_model.dart';
import 'package:family_planner/features/main/household/data/repositories/household_repository.dart';
import 'package:family_planner/features/main/household/presentation/widgets/expense_list_item.dart';
import 'package:family_planner/features/main/household/providers/household_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 카테고리 + 월 기준 지출 목록 Provider
final _categoryExpensesProvider = FutureProvider.family<
    List<ExpenseModel>,
    ({String? groupId, String month, ExpenseCategory? category})>((ref, args) {
  final repository = ref.watch(householdRepositoryProvider);
  return repository.getExpenses(
    groupId: args.groupId,
    month: args.month,
    category: args.category,
    filterNullCategory: args.category == null,
  );
});

class HouseholdCategoryExpensesScreen extends ConsumerWidget {
  final ExpenseCategory? category;
  final String month;

  const HouseholdCategoryExpensesScreen({
    super.key,
    required this.category,
    required this.month,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final groupId = ref.watch(householdSelectedGroupIdProvider);
    final color = categoryColor(category);
    final icon = categoryIcon(category);
    final label = categoryName(l10n, category);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(width: AppSizes.spaceS),
            Text(label),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(24),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _formatMonth(month),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
              ),
            ),
          ),
        ),
      ),
      body: _ExpenseList(
        groupId: groupId,
        month: month,
        category: category,
      ),
    );
  }

  String _formatMonth(String month) {
    final parts = month.split('-');
    return '${parts[0]}년 ${int.parse(parts[1])}월';
  }
}

class _ExpenseList extends ConsumerWidget {
  final String? groupId;
  final String month;
  final ExpenseCategory? category;

  const _ExpenseList({
    required this.groupId,
    required this.month,
    required this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final args = (groupId: groupId, month: month, category: category);
    final expensesAsync = ref.watch(_categoryExpensesProvider(args));

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

        final sorted = [...expenses]..sort((a, b) => b.date.compareTo(a.date));
        final total = sorted.fold<double>(0, (sum, e) => sum + e.amount);

        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceM,
                vertical: AppSizes.spaceS,
              ),
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              child: Text(
                '총 ${sorted.length}건 · ₩${_fmt(total)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Expanded(
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
                    onDelete: () {},
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.common_error),
            const SizedBox(height: AppSizes.spaceS),
            ElevatedButton(
              onPressed: () =>
                  ref.invalidate(_categoryExpensesProvider(args)),
              child: Text(l10n.common_retry),
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(double amount) {
    final i = amount.toInt();
    final s = i.toString();
    final buf = StringBuffer();
    for (var j = 0; j < s.length; j++) {
      if (j > 0 && (s.length - j) % 3 == 0) buf.write(',');
      buf.write(s[j]);
    }
    return buf.toString();
  }
}
