import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/household/data/models/expense_model.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 입금 카테고리 아이콘
IconData incomeCategoryIcon(IncomeCategory? category) {
  switch (category) {
    case IncomeCategory.salary:
      return Icons.account_balance_wallet;
    case IncomeCategory.allowance:
      return Icons.redeem;
    case IncomeCategory.carryover:
      return Icons.arrow_forward;
    case IncomeCategory.bonus:
      return Icons.star;
    case IncomeCategory.interest:
      return Icons.trending_up;
    case IncomeCategory.rental:
      return Icons.home_work;
    case IncomeCategory.sideIncome:
      return Icons.work_outline;
    case IncomeCategory.transferIn:
      return Icons.swap_horiz;
    case IncomeCategory.otherIncome:
    case null:
      return Icons.attach_money;
  }
}

/// 입금 카테고리 색상
Color incomeCategoryColor(IncomeCategory? category) {
  switch (category) {
    case IncomeCategory.salary:
      return Colors.green;
    case IncomeCategory.allowance:
      return Colors.teal;
    case IncomeCategory.carryover:
      return Colors.blueGrey;
    case IncomeCategory.bonus:
      return Colors.amber;
    case IncomeCategory.interest:
      return Colors.lightGreen;
    case IncomeCategory.rental:
      return Colors.cyan;
    case IncomeCategory.sideIncome:
      return Colors.indigo;
    case IncomeCategory.transferIn:
      return Colors.blue;
    case IncomeCategory.otherIncome:
    case null:
      return Colors.green;
  }
}

/// 입금 카테고리 이름
String incomeCategoryName(AppLocalizations l10n, IncomeCategory? category) {
  switch (category) {
    case IncomeCategory.salary:
      return l10n.household_income_category_salary;
    case IncomeCategory.allowance:
      return l10n.household_income_category_allowance;
    case IncomeCategory.carryover:
      return l10n.household_income_category_carryover;
    case IncomeCategory.bonus:
      return l10n.household_income_category_bonus;
    case IncomeCategory.interest:
      return l10n.household_income_category_interest;
    case IncomeCategory.rental:
      return l10n.household_income_category_rental;
    case IncomeCategory.sideIncome:
      return l10n.household_income_category_side_income;
    case IncomeCategory.transferIn:
      return l10n.household_income_category_transfer_in;
    case IncomeCategory.otherIncome:
    case null:
      return l10n.household_income_category_other;
  }
}

/// 카테고리별 아이콘
IconData categoryIcon(ExpenseCategory? category) {
  switch (category) {
    case ExpenseCategory.transportation:
      return Icons.directions_bus;
    case ExpenseCategory.food:
      return Icons.restaurant;
    case ExpenseCategory.groceries:
      return Icons.shopping_cart;
    case ExpenseCategory.leisure:
      return Icons.sports_esports;
    case ExpenseCategory.living:
      return Icons.home;
    case ExpenseCategory.medical:
      return Icons.local_hospital;
    case ExpenseCategory.education:
      return Icons.school;
    case ExpenseCategory.allowance:
      return Icons.wallet;
    case ExpenseCategory.celebration:
      return Icons.celebration;
    case ExpenseCategory.assetTransfer:
      return Icons.swap_horiz;
    case ExpenseCategory.childcare:
      return Icons.child_care;
    case ExpenseCategory.communication:
      return Icons.phone_android;
    case ExpenseCategory.carryover:
      return Icons.arrow_forward;
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
    case ExpenseCategory.groceries:
      return Colors.green;
    case ExpenseCategory.leisure:
      return Colors.purple;
    case ExpenseCategory.living:
      return Colors.green;
    case ExpenseCategory.medical:
      return Colors.red;
    case ExpenseCategory.education:
      return Colors.indigo;
    case ExpenseCategory.allowance:
      return Colors.teal;
    case ExpenseCategory.celebration:
      return Colors.pink;
    case ExpenseCategory.assetTransfer:
      return Colors.blueGrey;
    case ExpenseCategory.childcare:
      return Colors.lightBlue;
    case ExpenseCategory.communication:
      return Colors.cyan;
    case ExpenseCategory.carryover:
      return Colors.blueGrey;
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
    case ExpenseCategory.groceries:
      return l10n.household_category_groceries;
    case ExpenseCategory.leisure:
      return l10n.household_category_leisure;
    case ExpenseCategory.living:
      return l10n.household_category_living;
    case ExpenseCategory.medical:
      return l10n.household_category_health;
    case ExpenseCategory.education:
      return l10n.household_category_education;
    case ExpenseCategory.allowance:
      return l10n.household_category_allowance;
    case ExpenseCategory.celebration:
      return l10n.household_category_celebration;
    case ExpenseCategory.assetTransfer:
      return l10n.household_category_asset_transfer;
    case ExpenseCategory.childcare:
      return l10n.household_category_childcare;
    case ExpenseCategory.communication:
      return l10n.household_category_communication;
    case ExpenseCategory.carryover:
      return l10n.household_category_carryover;
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
    final isIncome = expense.type == TransactionType.income;
    final color = isIncome
        ? incomeCategoryColor(expense.incomeCategory)
        : categoryColor(expense.category);
    final icon = isIncome
        ? incomeCategoryIcon(expense.incomeCategory)
        : categoryIcon(expense.category);
    final label = isIncome
        ? incomeCategoryName(l10n, expense.incomeCategory)
        : categoryName(l10n, expense.category);
    final amountPrefix = isIncome ? '+₩' : '₩';
    final amountColor = isIncome ? Colors.green : Theme.of(context).colorScheme.error;

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
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: AppSizes.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.description?.isNotEmpty == true
                          ? expense.description!
                          : label,
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
                          label,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: color,
                              ),
                        ),
                        if (!isIncome && expense.paymentMethod != null) ...[
                          Text(' · ', style: Theme.of(context).textTheme.bodySmall),
                          Text(
                            paymentMethodName(l10n, expense.paymentMethod),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                        if (!isIncome && expense.isRecurring) ...[
                          const SizedBox(width: AppSizes.spaceXS),
                          Icon(
                            Icons.repeat,
                            size: 12,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ],
                        if (!isIncome && expense.isVariableRecurring) ...[
                          const SizedBox(width: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .tertiaryContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.household_variable_badge,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiaryContainer,
                                    fontSize: 10,
                                  ),
                            ),
                          ),
                        ],
                        if (!isIncome && expense.isRecurring && !expense.isConfirmed) ...[
                          const SizedBox(width: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .errorContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.household_unconfirmed_badge,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer,
                                    fontSize: 10,
                                  ),
                            ),
                          ),
                        ],
                        // 지출 항목이 환불된 경우 "환불됨" 배지
                        if (!isIncome && expense.refunds.isNotEmpty) ...[
                          const SizedBox(width: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.household_refund_badge,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Theme.of(context).colorScheme.outline,
                                    fontSize: 10,
                                  ),
                            ),
                          ),
                        ],
                        // 환불 입금 항목 "환불" 배지
                        if (isIncome && expense.refundedExpenseId != null) ...[
                          const SizedBox(width: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.teal.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.household_refund_origin_badge,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Colors.teal,
                                    fontSize: 10,
                                  ),
                            ),
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
                  if (expense.isVariableRecurring && !expense.isConfirmed &&
                      expense.estimatedAmount != null)
                    Text(
                      '~₩${_formatAmount(expense.estimatedAmount!)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: amountColor.withValues(alpha: 0.6),
                            fontStyle: FontStyle.italic,
                          ),
                    )
                  else
                    Text(
                      '$amountPrefix${_formatAmount(expense.amount)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: expense.refunds.isNotEmpty
                                ? Theme.of(context).colorScheme.outline
                                : amountColor,
                            decoration: expense.refunds.isNotEmpty
                                ? TextDecoration.lineThrough
                                : null,
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
              GestureDetector(
                onTap: onDelete,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    Icons.delete_outline,
                    size: 17,
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.45),
                  ),
                ),
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
