import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/child_points/data/models/childcare_model.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 자녀 포인트 계정 요약 카드
class AccountSummaryCard extends StatelessWidget {
  const AccountSummaryCard({
    super.key,
    required this.account,
    this.plan,
    this.onDepositSavings,
    this.onWithdrawSavings,
    this.onAddTransaction,
    this.onCashout,
  });

  final ChildcareAccount account;
  final AllowancePlan? plan;
  final VoidCallback? onDepositSavings;
  final VoidCallback? onWithdrawSavings;
  final VoidCallback? onAddTransaction;
  final VoidCallback? onCashout;

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
              subtitle: plan != null
                  ? '≈ ${(account.balance * plan!.pointToMoneyRatio).toInt()}원'
                  : null,
            ),
            const SizedBox(height: AppSizes.spaceS),
            const Divider(),
            const SizedBox(height: AppSizes.spaceS),
            // 월 용돈 (용돈 플랜에서)
            if (plan != null) ...[
              _buildBalanceRow(
                context,
                icon: Icons.calendar_month,
                color: Colors.green,
                label: l10n.childcare_monthly_allowance,
                value: plan!.monthlyPoints.toString(),
                unit: 'P/월',
                subtitle: '매월 ${plan!.payDay}일 · 1P=${plan!.pointToMoneyRatio}원',
              ),
              const SizedBox(height: AppSizes.spaceS),
            ],
            // 적금 잔액
            _buildBalanceRow(
              context,
              icon: Icons.savings_rounded,
              color: Colors.orange,
              label: l10n.childcare_savings_balance,
              value: account.savingsBalance.toInt().toString(),
              unit: 'P',
            ),
            const SizedBox(height: AppSizes.spaceM),
            // 액션 버튼들
            Row(
              children: [
                if (onAddTransaction != null)
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onAddTransaction,
                      icon: const Icon(Icons.card_giftcard_outlined, size: AppSizes.iconSmall),
                      label: const Text('보너스 지급'),
                    ),
                  ),
                if (onCashout != null) ...[
                  const SizedBox(width: AppSizes.spaceS),
                  OutlinedButton.icon(
                    onPressed: onCashout,
                    icon: const Icon(Icons.payments_outlined, size: AppSizes.iconSmall),
                    label: const Text('현금화'),
                  ),
                ],
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
