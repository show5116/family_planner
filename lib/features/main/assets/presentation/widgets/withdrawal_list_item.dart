import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/assets/data/models/asset_record_model.dart';
import 'package:family_planner/features/main/assets/data/models/withdrawal_model.dart';
import 'package:family_planner/features/main/assets/providers/asset_provider.dart';
import 'package:family_planner/features/main/assets/utils/asset_utils.dart';
import 'package:family_planner/features/main/assets/presentation/widgets/asset_record_list_item.dart';

class WithdrawalListItem extends ConsumerWidget {
  final AssetRecordModel record;
  final String accountId;

  const WithdrawalListItem({
    super.key,
    required this.record,
    required this.accountId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateStr =
        '${record.date.year}.${record.date.month.toString().padLeft(2, '0')}.${record.date.day.toString().padLeft(2, '0')}';
    final typeColor = record.withdrawalType == WithdrawalType.profit
        ? Colors.orange.shade700
        : Theme.of(context).colorScheme.primary;

    return Card(
      margin: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceM, vertical: AppSizes.spaceXS),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      dateStr,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                    const SizedBox(width: AppSizes.spaceS),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: typeColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        withdrawalTypeLabel(record.withdrawalType),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: typeColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '-₩${formatAssetAmount(record.amount ?? 0)}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                        ),
                        if (record.balanceAfter != null)
                          Text(
                            '₩${formatAssetAmount(record.balanceAfter!)}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                    const SizedBox(width: AppSizes.spaceXS),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 18),
                      color: Theme.of(context).colorScheme.error,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      onPressed: () => _confirmDelete(context, ref),
                    ),
                  ],
                ),
              ],
            ),
            if (record.principalAfter != null ||
                record.profitAfter != null) ...[
              const SizedBox(height: AppSizes.spaceXS),
              Row(
                children: [
                  if (record.principalAfter != null)
                    AssetAmountChip(
                      label: '원금',
                      amount: record.principalAfter!,
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      textColor:
                          Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  if (record.principalAfter != null &&
                      record.profitAfter != null)
                    const SizedBox(width: AppSizes.spaceS),
                  if (record.profitAfter != null)
                    AssetAmountChip(
                      label: '수익금',
                      amount: record.profitAfter!,
                      color: record.profitAfter! >= 0
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                      textColor: record.profitAfter! >= 0
                          ? Colors.green.shade800
                          : Colors.red.shade800,
                    ),
                ],
              ),
            ],
            if (record.note != null && record.note!.isNotEmpty) ...[
              const SizedBox(height: 2),
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

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('출금 기록 삭제'),
        content: const Text('삭제하면 출금일 이후 원금/수익이 원복됩니다. 계속하시겠어요?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('취소')),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('삭제',
                style: TextStyle(color: Theme.of(ctx).colorScheme.error)),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await ref
          .read(assetManagementProvider.notifier)
          .deleteWithdrawal(accountId, record.id);
    }
  }
}
