import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/assets/data/models/asset_record_model.dart';
import 'package:family_planner/features/main/assets/utils/asset_utils.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 자산 기록 목록 아이템
class AssetRecordListItem extends StatelessWidget {
  final AssetRecordModel record;

  const AssetRecordListItem({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateStr =
        '${record.recordDate.year}.${record.recordDate.month.toString().padLeft(2, '0')}.${record.recordDate.day.toString().padLeft(2, '0')}';

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceXS,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateStr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
                Text(
                  '₩${formatAssetAmount(record.balance)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceXS),
            Row(
              children: [
                AssetAmountChip(
                  label: l10n.asset_principal,
                  amount: record.principal,
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  textColor:
                      Theme.of(context).colorScheme.onSecondaryContainer,
                ),
                const SizedBox(width: AppSizes.spaceS),
                AssetAmountChip(
                  label: l10n.asset_profit,
                  amount: record.profit,
                  color: record.profit >= 0
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                  textColor: record.profit >= 0
                      ? Colors.green.shade800
                      : Colors.red.shade800,
                ),
              ],
            ),
            if (record.note != null && record.note!.isNotEmpty) ...[
              const SizedBox(height: AppSizes.spaceXS),
              Text(
                record.note!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 원금/수익 표시용 칩 위젯
class AssetAmountChip extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final Color textColor;

  const AssetAmountChip({
    super.key,
    required this.label,
    required this.amount,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceS,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
      child: Text(
        '$label ₩${formatAssetAmount(amount)}',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: textColor),
      ),
    );
  }
}
