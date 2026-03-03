import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/child_points/data/models/childcare_model.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 자녀 포인트 계정 요약 카드
class AccountSummaryCard extends StatelessWidget {
  const AccountSummaryCard({
    super.key,
    required this.account,
    this.onDepositSavings,
    this.onWithdrawSavings,
    this.onAddTransaction,
  });

  final ChildcareAccount account;
  final VoidCallback? onDepositSavings;
  final VoidCallback? onWithdrawSavings;
  final VoidCallback? onAddTransaction;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 포인트 잔액
            _buildBalanceRow(
              context,
              icon: Icons.star_rounded,
              color: colorScheme.primary,
              label: l10n.childcare_balance,
              value: account.balance.toInt().toString(),
              unit: 'P',
            ),
            const SizedBox(height: AppSizes.spaceS),
            const Divider(),
            const SizedBox(height: AppSizes.spaceS),
            // 월 용돈
            _buildBalanceRow(
              context,
              icon: Icons.calendar_month,
              color: Colors.green,
              label: l10n.childcare_monthly_allowance,
              value: account.monthlyAllowance.toInt().toString(),
              unit: 'P/월',
            ),
            const SizedBox(height: AppSizes.spaceS),
            // 적금 잔액
            _buildBalanceRow(
              context,
              icon: Icons.savings_rounded,
              color: Colors.orange,
              label: l10n.childcare_savings_balance,
              value: account.savingsBalance.toInt().toString(),
              unit: 'P',
              subtitle: '이자율 ${account.savingsInterestRate}%',
            ),
            const SizedBox(height: AppSizes.spaceM),
            // 액션 버튼들
            Row(
              children: [
                if (onAddTransaction != null)
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onAddTransaction,
                      icon: const Icon(Icons.add, size: AppSizes.iconSmall),
                      label: Text(l10n.childcare_add_transaction),
                    ),
                  ),
                if (onDepositSavings != null) ...[
                  const SizedBox(width: AppSizes.spaceS),
                  OutlinedButton(
                    onPressed: onDepositSavings,
                    child: Text(l10n.childcare_savings_deposit),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceRow(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String label,
    required String value,
    required String unit,
    String? subtitle,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: AppSizes.iconSmall, color: color),
        ),
        const SizedBox(width: AppSizes.spaceS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: textTheme.bodySmall),
              if (subtitle != null)
                Text(subtitle,
                    style: textTheme.bodySmall?.copyWith(color: color)),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              TextSpan(
                text: ' $unit',
                style: textTheme.bodySmall?.copyWith(color: color),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
