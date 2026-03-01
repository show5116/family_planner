import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/main/assets/data/models/account_model.dart';
import 'package:family_planner/features/main/assets/providers/asset_provider.dart';
import 'package:family_planner/features/main/assets/presentation/widgets/account_info_card.dart';
import 'package:family_planner/features/main/assets/presentation/widgets/asset_record_list_item.dart';
import 'package:family_planner/features/main/assets/presentation/widgets/add_asset_record_sheet.dart';
import 'package:family_planner/l10n/app_localizations.dart';

class AccountDetailScreen extends ConsumerWidget {
  final AccountModel account;

  const AccountDetailScreen({super.key, required this.account});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final recordsAsync = ref.watch(assetRecordsProvider(account.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(account.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: l10n.asset_edit_account,
            onPressed: () => context.push(
              AppRoutes.assetAccountAdd,
              extra: {'account': account},
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          AccountInfoCard(account: account),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceM,
              vertical: AppSizes.spaceS,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.asset_records,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton.icon(
                  onPressed: () => _showAddRecordSheet(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(l10n.asset_add_record),
                ),
              ],
            ),
          ),
          Expanded(
            child: recordsAsync.when(
              data: (records) {
                if (records.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 48,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: AppSizes.spaceS),
                        Text(
                          l10n.asset_no_records,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: records.length,
                  itemBuilder: (context, index) =>
                      AssetRecordListItem(record: records[index]),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(l10n.common_error)),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddRecordSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddRecordSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => AddAssetRecordSheet(accountId: account.id),
    );
  }
}
