import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/child_points/data/models/childcare_model.dart';

/// 포인트 거래 내역 아이템
class TransactionListItem extends StatelessWidget {
  const TransactionListItem({
    super.key,
    required this.transaction,
  });

  final ChildcareTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final isPositive = _isPositiveTransaction(transaction.type);
    final color = isPositive ? Colors.green : Colors.red;
    final sign = isPositive ? '+' : '-';

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.1),
        child: Icon(
          _getTransactionIcon(transaction.type),
          color: color,
          size: AppSizes.iconMedium,
        ),
      ),
      title: Text(transaction.description),
      subtitle: Text(
        DateFormat('MM.dd HH:mm').format(transaction.createdAt),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: Text(
        '$sign${transaction.amount.toInt()} P',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
      ),
    );
  }

  bool _isPositiveTransaction(ChildcareTransactionType? type) {
    switch (type) {
      case ChildcareTransactionType.reward:
      case ChildcareTransactionType.bonus:
      case ChildcareTransactionType.allowance:
      case ChildcareTransactionType.interest:
      case ChildcareTransactionType.savingsWithdraw:
        return true;
      case ChildcareTransactionType.penalty:
      case ChildcareTransactionType.purchase:
      case ChildcareTransactionType.cashout:
      case ChildcareTransactionType.savingsDeposit:
        return false;
      default:
        return true;
    }
  }

  IconData _getTransactionIcon(ChildcareTransactionType? type) {
    switch (type) {
      case ChildcareTransactionType.reward:
        return Icons.add_circle_outline;
      case ChildcareTransactionType.bonus:
        return Icons.card_giftcard_outlined;
      case ChildcareTransactionType.allowance:
        return Icons.calendar_month;
      case ChildcareTransactionType.penalty:
        return Icons.warning_amber_rounded;
      case ChildcareTransactionType.purchase:
        return Icons.storefront_outlined;
      case ChildcareTransactionType.cashout:
        return Icons.payments_outlined;
      case ChildcareTransactionType.savingsDeposit:
        return Icons.savings_outlined;
      case ChildcareTransactionType.savingsWithdraw:
        return Icons.account_balance_wallet_outlined;
      case ChildcareTransactionType.interest:
        return Icons.trending_up;
      default:
        return Icons.swap_horiz;
    }
  }
}
