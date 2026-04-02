import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/assets/data/models/asset_statistics_model.dart';
import 'package:family_planner/features/main/assets/utils/asset_utils.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 자산 통계 - 전체 요약 카드
class AssetStatSummaryCard extends StatelessWidget {
  final AssetStatisticsModel stats;

  const AssetStatSummaryCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = profitColor(context, stats.totalProfit);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.asset_total_balance,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  l10n.asset_account_count(stats.accountCount),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceXS),
            Text(
              '₩${formatAssetAmount(stats.totalBalance)}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(height: AppSizes.spaceL),
            Row(
              children: [
                Expanded(
                  child: AssetStatRow(
                    label: l10n.asset_total_principal,
                    value: '₩${formatAssetAmount(stats.totalPrincipal)}',
                    valueColor: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Expanded(
                  child: AssetStatRow(
                    label: l10n.asset_total_profit,
                    value:
                        '${stats.totalProfit >= 0 ? '+' : ''}₩${formatAssetAmount(stats.totalProfit)}',
                    valueColor: color,
                  ),
                ),
                Expanded(
                  child: AssetStatRow(
                    label: l10n.asset_profit_rate,
                    value:
                        '${stats.profitRate >= 0 ? '+' : ''}${stats.profitRate.toStringAsFixed(2)}%',
                    valueColor: color,
                  ),
                ),
              ],
            ),
            if (stats.savingsTotal > 0) ...[
              const Divider(height: AppSizes.spaceL),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.asset_savings_total,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    '₩${formatAssetAmount(stats.savingsTotal)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              if (stats.savingsGoals.isNotEmpty) ...[
                const SizedBox(height: AppSizes.spaceXS),
                ...stats.savingsGoals.map(
                  (goal) => Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          goal.name,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                        ),
                        Text(
                          '₩${formatAssetAmount(goal.currentAmount)}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

/// 통계 카드 내 개별 행 (라벨 + 값)
class AssetStatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const AssetStatRow({
    super.key,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
        ),
      ],
    );
  }
}
