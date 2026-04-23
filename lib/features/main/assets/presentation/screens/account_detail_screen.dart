import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/main/assets/data/models/account_model.dart';
import 'package:family_planner/features/main/assets/providers/asset_provider.dart';
import 'package:family_planner/features/main/assets/presentation/widgets/account_info_card.dart';
import 'package:family_planner/features/main/assets/presentation/widgets/add_asset_record_sheet.dart';
import 'package:family_planner/features/main/assets/presentation/widgets/asset_record_list_item.dart';
import 'package:family_planner/features/main/assets/presentation/widgets/asset_trend_chart.dart';
import 'package:family_planner/l10n/app_localizations.dart';

class AccountDetailScreen extends ConsumerWidget {
  final AccountModel account;

  const AccountDetailScreen({super.key, required this.account});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // 기록 추가/삭제 후 latestBalance, profitRate 즉시 반영
    final accountsAsync = ref.watch(assetAccountsProvider);
    final currentAccount = accountsAsync.valueOrNull
            ?.where((a) => a.id == account.id)
            .firstOrNull ??
        account;
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
      body: CustomScrollView(
        slivers: [
          // 계좌 정보 카드
          SliverToBoxAdapter(
            child: AccountInfoCard(account: currentAccount),
          ),

          // 추이 차트
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.spaceM,
                AppSizes.spaceS,
                AppSizes.spaceM,
                AppSizes.spaceM,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.asset_trend,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppSizes.spaceS),
                  AssetTrendChart(
                    trendBuilder: (period, year) => ref.watch(
                      accountAssetTrendProvider(
                        account.id,
                        period: period,
                        year: year,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 기록 헤더
          SliverToBoxAdapter(
            child: Padding(
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
          ),

          // 기록 목록
          recordsAsync.when(
            data: (records) {
              if (records.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceXL),
                    child: Column(
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
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => AssetRecordListItem(record: records[index]),
                  childCount: records.length,
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => SliverToBoxAdapter(
              child: Center(child: Text(l10n.common_error)),
            ),
          ),

          // 하단 여백 (FAB 가리지 않도록)
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
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
      useSafeArea: true,
      builder: (ctx) => AddAssetRecordSheet(accountId: account.id),
    );
  }
}
