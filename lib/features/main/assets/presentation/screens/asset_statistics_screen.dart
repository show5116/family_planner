import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/assets/providers/asset_provider.dart';
import 'package:family_planner/features/main/assets/presentation/widgets/asset_stat_summary_card.dart';
import 'package:family_planner/features/main/assets/presentation/widgets/asset_type_stat_card.dart';
import 'package:family_planner/l10n/app_localizations.dart';

class AssetStatisticsScreen extends ConsumerWidget {
  const AssetStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final statsAsync = ref.watch(assetStatisticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.asset_statistics_title),
      ),
      body: statsAsync.when(
        data: (stats) => ListView(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          children: [
            AssetStatSummaryCard(stats: stats),
            const SizedBox(height: AppSizes.spaceM),
            if (stats.byType.isNotEmpty) ...[
              Text(
                l10n.asset_by_type,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppSizes.spaceS),
              ...stats.byType.map(
                (typeStat) => AssetTypeStatCard(typeStat: typeStat),
              ),
            ],
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.common_error),
              const SizedBox(height: AppSizes.spaceS),
              ElevatedButton(
                onPressed: () => ref.invalidate(assetStatisticsProvider),
                child: Text(l10n.common_retry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
