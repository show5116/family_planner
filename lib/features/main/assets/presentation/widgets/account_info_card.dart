import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/assets/data/models/account_model.dart';
import 'package:family_planner/features/main/assets/utils/asset_utils.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 계좌 상세 상단 정보 카드 (잔액, 수익률, 기관명)
class AccountInfoCard extends StatelessWidget {
  final AccountModel account;

  const AccountInfoCard({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.all(AppSizes.spaceM),
      padding: const EdgeInsets.all(AppSizes.spaceM),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                account.institution,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
              ),
              if (account.accountNumber != null) ...[
                const SizedBox(width: AppSizes.spaceS),
                Text(
                  account.accountNumber!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimaryContainer
                            .withValues(alpha: 0.7),
                      ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSizes.spaceS),
          if (account.latestBalance != null)
            Text(
              '₩${formatAssetAmount(account.latestBalance!)}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
          if (account.profitRate != null)
            Row(
              children: [
                Icon(
                  account.profitRate! >= 0
                      ? Icons.trending_up
                      : Icons.trending_down,
                  size: 16,
                  color: profitColor(context, account.profitRate!),
                ),
                const SizedBox(width: 4),
                Text(
                  '${account.profitRate! >= 0 ? '+' : ''}${account.profitRate!.toStringAsFixed(2)}% ${l10n.asset_profit_rate}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: profitColor(context, account.profitRate!),
                      ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
