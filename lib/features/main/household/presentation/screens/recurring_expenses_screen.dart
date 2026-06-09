import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/main/household/data/models/expense_model.dart';
import 'package:family_planner/features/main/household/data/models/recurring_expense_model.dart';
import 'package:family_planner/features/main/household/presentation/widgets/expense_list_item.dart';
import 'package:family_planner/features/main/household/providers/household_provider.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

class _RecurringSummary {
  final double totalExpense;
  final double totalIncome;
  final int count;
  final List<MapEntry<ExpenseCategory, double>> categoryAmounts;

  const _RecurringSummary({
    required this.totalExpense,
    required this.totalIncome,
    required this.count,
    required this.categoryAmounts,
  });

  factory _RecurringSummary.from(List<RecurringExpenseModel> items) {
    final expenseOnly =
        items.where((e) => e.type == TransactionType.expense).toList();
    final incomeOnly =
        items.where((e) => e.type == TransactionType.income).toList();

    final totalExpense = expenseOnly.fold(0.0, (sum, e) => sum + e.amount);
    final totalIncome = incomeOnly.fold(0.0, (sum, e) => sum + e.amount);

    final categorySum = <ExpenseCategory, double>{};
    for (final e in expenseOnly) {
      final key = e.category ?? ExpenseCategory.other;
      categorySum[key] = (categorySum[key] ?? 0) + e.amount;
    }
    final sorted = categorySum.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return _RecurringSummary(
      totalExpense: totalExpense,
      totalIncome: totalIncome,
      count: items.length,
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
            Text(l10n.household_recurring_title),
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
        data: (items) => _RecurringList(
          items: items,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(
          AppRoutes.householdRecurringAdd,
          extra: {'groupId': selectedGroupId},
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _RecurringList extends ConsumerWidget {
  final List<RecurringExpenseModel> items;
  final String? selectedGroupId;

  const _RecurringList({required this.items, required this.selectedGroupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.repeat, size: 64,
                color: Theme.of(context).colorScheme.outline),
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

    final incomeItems = [...items.where((e) => e.type == TransactionType.income)]
      ..sort((a, b) => a.dayOfMonth.compareTo(b.dayOfMonth));
    final expenseItems = [...items.where((e) => e.type != TransactionType.income)]
      ..sort((a, b) => a.dayOfMonth.compareTo(b.dayOfMonth));
    final summary = _RecurringSummary.from(items);

    // 섹션 구조: [summary, incomeHeader?, ...income, expenseHeader?, ...expense]
    final listItems = <Object>[
      summary,
      if (incomeItems.isNotEmpty) _SectionType.income,
      ...incomeItems,
      if (expenseItems.isNotEmpty) _SectionType.expense,
      ...expenseItems,
    ];

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(householdRecurringExpensesProvider.notifier).refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: listItems.length,
        itemBuilder: (context, index) {
          final entry = listItems[index];
          if (entry is _RecurringSummary) {
            return _RecurringSummaryCard(summary: entry);
          }
          if (entry is _SectionType) {
            return _SectionHeader(type: entry, l10n: l10n);
          }
          final item = entry as RecurringExpenseModel;
          return Dismissible(
            key: ValueKey(item.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: AppSizes.spaceL),
              color: Theme.of(context).colorScheme.error,
              child: const Icon(Icons.delete_outline,
                  color: Colors.white, size: 24),
            ),
            confirmDismiss: (_) => _confirmDelete(context, ref, l10n, item),
            onDismissed: (_) {},
            child: _RecurringListItem(
              item: item,
              onTap: () => context.push(
                AppRoutes.householdRecurringEdit,
                extra: {'item': item, 'groupId': selectedGroupId},
              ),
            ),
          );
        },
      ),
    );
  }

  Future<bool?> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    RecurringExpenseModel item,
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
            child: Text(l10n.common_delete,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return false;

    final success = await ref
        .read(householdManagementProvider.notifier)
        .deleteRecurringExpense(item.id);

    if (!context.mounted) return false;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            success ? l10n.household_delete_success : l10n.common_error),
      ),
    );
    return success;
  }
}

// ── 섹션 타입 ──────────────────────────────────────────────────────────────
enum _SectionType { income, expense }

// ── 섹션 헤더 ──────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final _SectionType type;
  final AppLocalizations l10n;

  const _SectionHeader({required this.type, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isIncome = type == _SectionType.income;
    final color = isIncome ? Colors.teal : colorScheme.error;
    final icon = isIncome ? Icons.savings_outlined : Icons.receipt_long_outlined;
    final label = isIncome ? l10n.household_income : l10n.household_expense;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSizes.spaceM, AppSizes.spaceM, AppSizes.spaceM, AppSizes.spaceXS),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
          ),
        ],
      ),
    );
  }
}

// ── 고정지출 목록 아이템 ────────────────────────────────────────────────────
class _RecurringListItem extends StatelessWidget {
  final RecurringExpenseModel item;
  final VoidCallback onTap;

  const _RecurringListItem({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isIncome = item.type == TransactionType.income;
    final color = isIncome ? Colors.teal : colorScheme.error;

    // 아이콘: 카테고리 있으면 카테고리 아이콘, 없으면 수입=savings / 지출=payments
    final IconData iconData;
    final Color iconColor;
    if (item.category != null) {
      iconData = categoryIcon(item.category!);
      iconColor = categoryColor(item.category!);
    } else if (isIncome) {
      iconData = Icons.savings_outlined;
      iconColor = Colors.teal;
    } else {
      iconData = Icons.payments_outlined;
      iconColor = colorScheme.error;
    }

    // subtitle: 카테고리명 또는 수입/지출 레이블
    final String subtitle = item.category != null
        ? categoryName(l10n, item.category!)
        : (isIncome ? l10n.household_income : l10n.household_expense);

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceM, vertical: 2),
      leading: CircleAvatar(
        backgroundColor: iconColor.withValues(alpha: 0.1),
        child: Icon(iconData, size: 20, color: iconColor),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              item.description?.isNotEmpty == true
                  ? item.description!
                  : subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: item.isActive ? null : colorScheme.outline,
              ),
            ),
          ),
          if (!item.isActive)
            Container(
              margin: const EdgeInsets.only(left: AppSizes.spaceS),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              ),
              child: Text(
                l10n.household_recurring_inactive,
                style: textTheme.bodySmall
                    ?.copyWith(color: colorScheme.outline, fontSize: 10),
              ),
            ),
          if (item.isVariable)
            Container(
              margin: const EdgeInsets.only(left: AppSizes.spaceS),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              ),
              child: Text(
                l10n.household_recurring_variable,
                style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onTertiaryContainer, fontSize: 10),
              ),
            ),
        ],
      ),
      subtitle: Text(
        // description이 있을 때만 카테고리명을 subtitle로
        item.description?.isNotEmpty == true ? subtitle : '',
        style: textTheme.bodySmall
            ?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${isIncome ? '+' : '-'}₩${_fmt(item.amount)}',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
              fontStyle: item.isVariable ? FontStyle.italic : FontStyle.normal,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            l10n.household_recurring_day_of_month_value(item.dayOfMonth),
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
        ],
      ),
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

// ── 요약 카드 ──────────────────────────────────────────────────────────────
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
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.household_recurring_expense_total,
                                style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.error),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '₩${_fmt(summary.totalExpense)}',
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.household_recurring_income_total,
                                style: textTheme.bodySmall?.copyWith(
                                    color: Colors.teal),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '₩${_fmt(summary.totalIncome)}',
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                            ],
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
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusMedium),
                    ),
                    child: Column(
                      children: [
                        Text(
                          l10n.household_recurring_count,
                          style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSecondaryContainer),
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
              if (summary.categoryAmounts.isNotEmpty) ...[
                const SizedBox(height: AppSizes.spaceM),
                Divider(color: colorScheme.outlineVariant, height: 1),
                const SizedBox(height: AppSizes.spaceM),
                Text(
                  l10n.household_recurring_top_category,
                  style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant),
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
              style:
                  textTheme.bodySmall?.copyWith(color: colorScheme.onSurface),
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
            '₩${_fmt(amount)}',
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
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
