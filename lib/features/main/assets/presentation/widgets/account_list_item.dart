import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/assets/data/models/account_model.dart';
import 'package:family_planner/features/main/assets/utils/asset_utils.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 계좌 목록 아이템
class AccountListItem extends StatelessWidget {
  final AccountModel account;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const AccountListItem({
    super.key,
    required this.account,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceXS,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          child: Icon(
            accountTypeIcon(account.type),
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
        title: Text(account.name),
        subtitle: Text(account.institution),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (account.latestBalance != null)
                  Text(
                    '₩${formatAssetAmount(account.latestBalance!)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                if (account.profitRate != null)
                  Text(
                    '${account.profitRate! >= 0 ? '+' : ''}${account.profitRate!.toStringAsFixed(2)}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: account.profitRate! >= 0
                              ? Colors.green.shade700
                              : Theme.of(context).colorScheme.error,
                        ),
                  ),
              ],
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') onDelete();
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline,
                          color: Theme.of(context).colorScheme.error, size: 18),
                      const SizedBox(width: AppSizes.spaceS),
                      Text(
                        l10n.common_delete,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
