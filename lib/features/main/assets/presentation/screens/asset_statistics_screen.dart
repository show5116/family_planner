import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/assets/data/models/account_model.dart';
import 'package:family_planner/features/main/assets/providers/asset_provider.dart';
import 'package:family_planner/features/main/assets/presentation/widgets/asset_account_filter_sheet.dart';
import 'package:family_planner/features/main/assets/presentation/widgets/asset_stat_summary_card.dart';
import 'package:family_planner/features/main/assets/presentation/widgets/asset_trend_chart.dart';
import 'package:family_planner/features/main/assets/presentation/widgets/asset_type_stat_card.dart';
import 'package:family_planner/l10n/app_localizations.dart';

class AssetStatisticsScreen extends ConsumerWidget {
  const AssetStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final statsAsync = ref.watch(assetStatisticsProvider);
    final accountsAsync = ref.watch(assetAccountsProvider);
    final selectedIds = ref.watch(assetStatSelectedAccountIdsProvider);

    final accounts = accountsAsync.valueOrNull ?? [];
    final accountIdsJoined = selectedIds.isEmpty ? null : selectedIds.join(',');
    final isFiltered = selectedIds.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.asset_statistics_title),
        actions: [
          if (accounts.isNotEmpty)
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  tooltip: l10n.asset_stat_account_filter,
                  onPressed: () => _showFilterSheet(context, ref, accounts, selectedIds),
                ),
                if (isFiltered)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        children: [
          // 활성 필터 요약 (필터 중일 때만 표시)
          if (isFiltered) ...[
            _ActiveFilterBar(
              accounts: accounts,
              selectedIds: selectedIds,
              onClear: () => ref
                  .read(assetStatSelectedAccountIdsProvider.notifier)
                  .state = {},
            ),
            const SizedBox(height: AppSizes.spaceM),
          ],

          // 요약 카드
          statsAsync.when(
            data: (stats) => AssetStatSummaryCard(stats: stats),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => _ErrorCard(
              onRetry: () => ref.invalidate(assetStatisticsProvider),
              l10n: l10n,
            ),
          ),
          const SizedBox(height: AppSizes.spaceM),

          // 유형별 현황
          statsAsync.when(
            data: (stats) {
              if (stats.byType.isEmpty) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.asset_by_type,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppSizes.spaceS),
                  ...stats.byType.map((t) => AssetTypeStatCard(typeStat: t)),
                  const SizedBox(height: AppSizes.spaceM),
                ],
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),

          // 자산 추이 차트
          Text(
            l10n.asset_trend,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppSizes.spaceS),
          AssetTrendChart(
            trendBuilder: (period, year) => ref.watch(
              groupAssetTrendProvider(
                period: period,
                year: year,
                accountIdsJoined: accountIdsJoined,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(
    BuildContext context,
    WidgetRef ref,
    List<AccountModel> accounts,
    Set<String> selectedIds,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusMedium),
        ),
      ),
      builder: (_) => AssetAccountFilterSheet(
        accounts: accounts,
        selectedIds: selectedIds,
        onApply: (next) {
          ref.read(assetStatSelectedAccountIdsProvider.notifier).state = next;
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

/// AppBar 아래 활성 필터 요약 바
class _ActiveFilterBar extends StatelessWidget {
  final List<AccountModel> accounts;
  final Set<String> selectedIds;
  final VoidCallback onClear;

  const _ActiveFilterBar({
    required this.accounts,
    required this.selectedIds,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final names = accounts
        .where((a) => selectedIds.contains(a.id))
        .map((a) => a.name)
        .join(', ');

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceXS,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
      child: Row(
        children: [
          Icon(
            Icons.filter_list,
            size: 16,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: AppSizes.spaceXS),
          Expanded(
            child: Text(
              names,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: onClear,
            child: Icon(
              Icons.close,
              size: 16,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final VoidCallback onRetry;
  final AppLocalizations l10n;

  const _ErrorCard({required this.onRetry, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(l10n.common_error),
          const SizedBox(height: AppSizes.spaceS),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(l10n.common_retry),
          ),
        ],
      ),
    );
  }
}
