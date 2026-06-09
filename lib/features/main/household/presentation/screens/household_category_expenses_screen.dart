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

/// 카테고리 + 월 + 거래유형 기준 목록 Provider
/// autoDispose: 화면을 벗어나면 캐시 파기 → 재진입 시 항상 최신 데이터 조회
final _categoryExpensesProvider = FutureProvider.autoDispose.family<
    List<ExpenseModel>,
    ({String? groupId, String month, ExpenseCategory? category, TransactionType? type})>((ref, args) {
  final repository = ref.watch(householdRepositoryProvider);
  return repository.getExpenses(
    groupId: args.groupId,
    month: args.month,
    category: args.category,
    filterNullCategory: args.category == null && args.type != TransactionType.income,
    type: args.type,
  );
});

class HouseholdCategoryExpensesScreen extends ConsumerWidget {
  final ExpenseCategory? category;
  final String month;
  final TransactionType? type;
  /// non-null이면 해당 입금 카테고리만 필터링
  final IncomeCategory? incomeCategory;
  /// non-null이면 소비처별 필터링 ('' = 소비처 없음)
  final String? merchantId;
  final String? merchantName;

  const HouseholdCategoryExpensesScreen({
    super.key,
    required this.category,
    required this.month,
    this.type,
    this.incomeCategory,
    this.merchantId,
    this.merchantName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final groupId = ref.watch(householdSelectedGroupIdProvider);
    final isMerchantMode = merchantId != null;
    final isIncome = type == TransactionType.income;

    final Color color;
    final IconData icon;
    final String label;
    if (isMerchantMode) {
      color = Theme.of(context).colorScheme.primary;
      icon = merchantId!.isEmpty ? Icons.storefront_outlined : Icons.storefront;
      label = merchantName ?? '소비처';
    } else if (isIncome) {
      color = incomeCategory != null
          ? incomeCategoryColor(incomeCategory)
          : Colors.green;
      icon = incomeCategory != null
          ? incomeCategoryIcon(incomeCategory)
          : Icons.arrow_downward;
      label = incomeCategory != null
          ? incomeCategoryName(l10n, incomeCategory)
          : l10n.household_income;
    } else {
      color = categoryColor(category);
      icon = categoryIcon(category);
      label = categoryName(l10n, category);
    }

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
      body: isMerchantMode
          ? _MerchantExpenseList(
              groupId: groupId,
              month: month,
              merchantId: merchantId!,
            )
          : _ExpenseList(
              groupId: groupId,
              month: month,
              category: category,
              type: type,
              isIncome: isIncome,
              incomeCategory: incomeCategory,
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
  final TransactionType? type;
  final bool isIncome;
  final IncomeCategory? incomeCategory;

  const _ExpenseList({
    required this.groupId,
    required this.month,
    required this.category,
    required this.type,
    required this.isIncome,
    this.incomeCategory,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final args = (groupId: groupId, month: month, category: category, type: type);
    final expensesAsync = ref.watch(_categoryExpensesProvider(args));

    return expensesAsync.when(
      data: (expenses) {
        // 입금 카테고리가 지정된 경우 프론트에서 추가 필터링
        // otherIncome은 null(미설정) 항목도 함께 포함
        final filtered = incomeCategory != null
            ? expenses.where((e) {
                if (incomeCategory == IncomeCategory.otherIncome) {
                  return e.incomeCategory == IncomeCategory.otherIncome ||
                      e.incomeCategory == null;
                }
                return e.incomeCategory == incomeCategory;
              }).toList()
            : expenses;

        if (filtered.isEmpty) {
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

        final sorted = [...filtered]..sort((a, b) => b.date.compareTo(a.date));
        final total = sorted.fold<double>(0, (sum, e) => sum + e.amount);
        final prefix = '₩';
        final totalColor = isIncome
            ? Colors.green.shade700
            : Theme.of(context).colorScheme.error;

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
                '총 ${sorted.length}건 · $prefix${_fmt(total)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: totalColor,
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

final _merchantExpensesProvider = FutureProvider.autoDispose.family<
    List<ExpenseModel>,
    ({String? groupId, String month})>((ref, args) {
  final repository = ref.watch(householdRepositoryProvider);
  return repository.getExpenses(
    groupId: args.groupId,
    month: args.month,
    type: TransactionType.expense,
  );
});

class _MerchantExpenseList extends ConsumerWidget {
  final String? groupId;
  final String month;
  /// 소비처 id — 빈 문자열이면 소비처 없음 항목만 표시
  final String merchantId;

  const _MerchantExpenseList({
    required this.groupId,
    required this.month,
    required this.merchantId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final args = (groupId: groupId, month: month);
    final expensesAsync = ref.watch(_merchantExpensesProvider(args));

    return expensesAsync.when(
      data: (expenses) {
        final filtered = merchantId.isEmpty
            ? expenses.where((e) => e.merchant == null).toList()
            : expenses.where((e) => e.merchant?.id == merchantId).toList();

        if (filtered.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long, size: 64, color: Theme.of(context).colorScheme.outline),
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

        final sorted = [...filtered]..sort((a, b) => b.date.compareTo(a.date));
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
                      color: Theme.of(context).colorScheme.error,
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
                    onTap: () => context.push(AppRoutes.householdDetail, extra: expense),
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
              onPressed: () => ref.invalidate(_merchantExpensesProvider(args)),
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
