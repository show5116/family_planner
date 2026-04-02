import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/main/assets/providers/asset_provider.dart';
import 'package:family_planner/features/main/assets/presentation/widgets/account_list_item.dart';
import 'package:family_planner/features/main/assets/presentation/widgets/asset_group_bar.dart';
import 'package:family_planner/features/main/assets/presentation/widgets/asset_summary_card.dart';
import 'package:family_planner/features/main/assets/data/models/account_model.dart';
import 'package:family_planner/features/main/assets/utils/asset_utils.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/core/constants/app_sizes.dart';

class AssetScreen extends ConsumerStatefulWidget {
  const AssetScreen({super.key});

  @override
  ConsumerState<AssetScreen> createState() => _AssetScreenState();
}

class _AssetScreenState extends ConsumerState<AssetScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initGroupSelection();
    });
  }

  Future<void> _initGroupSelection() async {
    final groupId = ref.read(assetSelectedGroupIdProvider);
    if (groupId != null) return;

    final groups = await ref.read(myGroupsProvider.future).catchError((_) => <Group>[]);
    if (groups.isNotEmpty && mounted) {
      ref.read(assetSelectedGroupIdProvider.notifier).state = groups.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final groupsAsync = ref.watch(myGroupsProvider);
    final selectedGroupId = ref.watch(assetSelectedGroupIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.asset_title),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: l10n.asset_statistics,
            onPressed: () => context.push(AppRoutes.assetStatistics),
          ),
        ],
      ),
      body: Column(
        children: [
          AssetGroupBar(
            groupsAsync: groupsAsync,
            selectedGroupId: selectedGroupId,
          ),
          const AssetSummaryCard(),
          Expanded(
            child: _AssetList(selectedGroupId: selectedGroupId),
          ),
        ],
      ),
      floatingActionButton: selectedGroupId == null
          ? null
          : FloatingActionButton(
              onPressed: () => context.push(
                AppRoutes.assetAccountAdd,
                extra: {'groupId': selectedGroupId},
              ),
              child: const Icon(Icons.add),
            ),
    );
  }
}

class _AssetList extends ConsumerWidget {
  final String? selectedGroupId;

  const _AssetList({required this.selectedGroupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    if (selectedGroupId == null) {
      return Center(
        child: Text(
          l10n.asset_no_group_selected,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    final accountsAsync = ref.watch(assetAccountsProvider);
    final statsAsync = ref.watch(assetStatisticsProvider);
    final savingsGoals = statsAsync.valueOrNull?.savingsGoals ?? [];

    return accountsAsync.when(
      data: (accounts) {
        final hasAccounts = accounts.isNotEmpty;
        final hasSavings = savingsGoals.isNotEmpty;

        if (!hasAccounts && !hasSavings) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_balance_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: AppSizes.spaceM),
                Text(
                  l10n.asset_no_accounts,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => ref.read(assetAccountsProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 80),
            children: [
              if (hasAccounts) ...[
                ...accounts.map(
                  (account) => AccountListItem(
                    account: account,
                    onTap: () => context.push(
                      AppRoutes.assetAccountDetail,
                      extra: account,
                    ),
                    onDelete: () =>
                        _confirmDelete(context, ref, l10n, account),
                  ),
                ),
              ],
              if (hasSavings) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.spaceM,
                    AppSizes.spaceM,
                    AppSizes.spaceM,
                    AppSizes.spaceXS,
                  ),
                  child: Text(
                    l10n.asset_savings_goals,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ),
                ...savingsGoals.map(
                  (goal) => Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spaceM,
                      vertical: AppSizes.spaceXS,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.tertiaryContainer,
                        child: Icon(
                          Icons.savings_outlined,
                          color: Theme.of(context)
                              .colorScheme
                              .onTertiaryContainer,
                        ),
                      ),
                      title: Text(goal.name),
                      trailing: Text(
                        '₩${formatAssetAmount(goal.currentAmount)}',
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      onTap: () => context.push(
                        '/savings/${goal.id}',
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.common_error,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSizes.spaceS),
            ElevatedButton(
              onPressed: () =>
                  ref.read(assetAccountsProvider.notifier).refresh(),
              child: Text(l10n.common_retry),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    AccountModel account,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.asset_delete_account),
        content: Text(l10n.asset_delete_account_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              l10n.common_delete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final success = await ref
        .read(assetManagementProvider.notifier)
        .deleteAccount(account.id);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? l10n.asset_delete_success : l10n.common_error),
      ),
    );
  }
}
