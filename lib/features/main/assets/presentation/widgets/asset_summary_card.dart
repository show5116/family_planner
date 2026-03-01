import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/assets/providers/asset_provider.dart';
import 'package:family_planner/features/main/assets/utils/asset_utils.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 자산 요약 카드 (총 잔액 / 수익금 / 수익률)
class AssetSummaryCard extends ConsumerWidget {
  const AssetSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final statsAsync = ref.watch(assetStatisticsProvider);

    return statsAsync.when(
      data: (stats) => Container(
        margin: const EdgeInsets.all(AppSizes.spaceM),
        padding: const EdgeInsets.all(AppSizes.spaceM),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        child: Row(
          children: [
            Expanded(
              child: AssetSummaryItem(
                label: l10n.asset_total_balance,
                value: '₩${formatAssetAmount(stats.totalBalance)}',
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: Theme.of(context)
                  .colorScheme
                  .onPrimaryContainer
                  .withValues(alpha: 0.2),
            ),
            Expanded(
              child: AssetSummaryItem(
                label: l10n.asset_total_profit,
                value: '₩${formatAssetAmount(stats.totalProfit)}',
                color: profitColor(context, stats.totalProfit),
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: Theme.of(context)
                  .colorScheme
                  .onPrimaryContainer
                  .withValues(alpha: 0.2),
            ),
            Expanded(
              child: AssetSummaryItem(
                label: l10n.asset_profit_rate,
                value: '${stats.profitRate.toStringAsFixed(2)}%',
                color: profitColor(context, stats.profitRate),
              ),
            ),
          ],
        ),
      ),
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSizes.spaceM),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

/// 자산 요약 카드 내 개별 항목
class AssetSummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const AssetSummaryItem({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
        ),
        const SizedBox(height: AppSizes.spaceXS),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
      ],
    );
  }
}
