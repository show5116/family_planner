import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/household/data/models/expense_model.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 카테고리별 아이콘
IconData categoryIcon(ExpenseCategory? category) {
  switch (category) {
    case ExpenseCategory.transportation:
      return Icons.directions_bus;
    case ExpenseCategory.food:
      return Icons.restaurant;
    case ExpenseCategory.leisure:
      return Icons.sports_esports;
    case ExpenseCategory.living:
      return Icons.home;
    case ExpenseCategory.medical:
      return Icons.local_hospital;
    case ExpenseCategory.education:
      return Icons.school;
    case ExpenseCategory.other:
    case null:
      return Icons.category;
  }
}

/// 카테고리별 색상
Color categoryColor(ExpenseCategory? category) {
  switch (category) {
    case ExpenseCategory.transportation:
      return Colors.blue;
    case ExpenseCategory.food:
      return Colors.orange;
    case ExpenseCategory.leisure:
      return Colors.purple;
    case ExpenseCategory.living:
      return Colors.green;
    case ExpenseCategory.medical:
      return Colors.red;
    case ExpenseCategory.education:
      return Colors.indigo;
    case ExpenseCategory.other:
    case null:
      return Colors.grey;
  }
}

/// 카테고리 이름 반환
String categoryName(AppLocalizations l10n, ExpenseCategory? category) {
  switch (category) {
    case ExpenseCategory.transportation:
      return l10n.household_category_transport;
    case ExpenseCategory.food:
      return l10n.household_category_food;
    case ExpenseCategory.leisure:
      return l10n.household_category_leisure;
    case ExpenseCategory.living:
      return l10n.household_category_living;
    case ExpenseCategory.medical:
      return l10n.household_category_health;
    case ExpenseCategory.education:
      return l10n.household_category_education;
    case ExpenseCategory.other:
    case null:
      return l10n.household_category_other;
  }
}

/// 결제 수단 이름 반환
String paymentMethodName(AppLocalizations l10n, PaymentMethod? method) {
  switch (method) {
    case PaymentMethod.cash:
      return l10n.household_payment_cash;
    case PaymentMethod.card:
      return l10n.household_payment_card;
    case PaymentMethod.transfer:
      return l10n.household_payment_transfer;
    case null:
      return l10n.household_payment_other;
  }
}

/// 지출 목록 아이템 위젯
class ExpenseListItem extends StatelessWidget {
  final ExpenseModel expense;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ExpenseListItem({
    super.key,
    required this.expense,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = categoryColor(expense.category);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceXS,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 0.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceM,
            vertical: AppSizes.spaceS,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                ),
                child: Icon(
                  categoryIcon(expense.category),
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSizes.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.description?.isNotEmpty == true
                          ? expense.description!
                          : categoryName(l10n, expense.category),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          categoryName(l10n, expense.category),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: color,
                              ),
                        ),
                        if (expense.paymentMethod != null) ...[
                          Text(
                            ' · ',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            paymentMethodName(l10n, expense.paymentMethod),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                        if (expense.isRecurring) ...[
                          const SizedBox(width: AppSizes.spaceXS),
                          Icon(
                            Icons.repeat,
                            size: 12,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₩${_formatAmount(expense.amount)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.error,
                        ),
                  ),
                  Text(
                    _formatDate(expense.date),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ],
              ),
              const SizedBox(width: AppSizes.spaceXS),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
                iconSize: 18,
                color: Theme.of(context).colorScheme.outline,
                visualDensity: VisualDensity.compact,
              ),
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

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}';
  }
}
