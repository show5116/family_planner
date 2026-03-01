import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/assets/data/models/asset_statistics_model.dart';
import 'package:family_planner/features/main/assets/utils/asset_utils.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 자산 유형별 통계 카드
class AssetTypeStatCard extends StatelessWidget {
  final AccountTypeStatModel typeStat;

  const AssetTypeStatCard({super.key, required this.typeStat});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceS),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          child: Icon(
            accountTypeIcon(typeStat.type),
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            size: 20,
          ),
        ),
        title: Text(accountTypeLabel(l10n, typeStat.type)),
        subtitle: Text(l10n.assetAccountCount(typeStat.count)),
        trailing: Text(
          '₩${formatAssetAmount(typeStat.balance)}',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
