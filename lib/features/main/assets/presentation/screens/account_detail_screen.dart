import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/main/assets/data/models/account_model.dart';
import 'package:family_planner/features/main/assets/data/models/asset_record_model.dart';
import 'package:family_planner/features/main/assets/data/models/withdrawal_model.dart';
import 'package:family_planner/features/main/assets/data/repositories/asset_repository.dart';
import 'package:family_planner/features/main/assets/utils/asset_utils.dart';
import 'package:family_planner/features/main/assets/providers/asset_provider.dart';
import 'package:family_planner/features/main/assets/presentation/widgets/account_info_card.dart';
import 'package:family_planner/features/main/assets/presentation/widgets/add_asset_record_sheet.dart';
import 'package:family_planner/features/main/assets/presentation/widgets/asset_record_list_item.dart';
import 'package:family_planner/features/main/assets/presentation/widgets/asset_trend_chart.dart';
import 'package:family_planner/features/main/assets/presentation/widgets/add_withdrawal_sheet.dart';
import 'package:family_planner/features/main/assets/presentation/widgets/holding_records_section.dart';
import 'package:family_planner/features/onboarding/presentation/widgets/feature_coach_mark.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 알림 등 ID만 있을 때 계좌를 조회 후 상세 화면으로 진입하는 래퍼
class AccountDetailByIdScreen extends ConsumerWidget {
  final String accountId;

  const AccountDetailByIdScreen({super.key, required this.accountId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final repo = ref.read(assetRepositoryProvider);

    return FutureBuilder<AccountModel>(
      future: repo.getAccountById(accountId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(l10n.common_error)),
          );
        }
        return AccountDetailScreen(account: snapshot.data!);
      },
    );
  }
}

// 온보딩용 가짜 잔액 기록
final _demoRecords = [
  AssetRecordModel(
    entryType: AssetRecordEntryType.snapshot,
    date: DateTime(2025, 3, 1),
    id: '__demo_r1__',
    accountId: '__demo_asset__',
    recordDate: DateTime(2025, 3, 1),
    balance: 3000000,
    principal: 3000000,
    profit: 0,
    createdAt: DateTime(2025, 3, 1),
  ),
  AssetRecordModel(
    entryType: AssetRecordEntryType.snapshot,
    date: DateTime(2025, 4, 1),
    id: '__demo_r2__',
    accountId: '__demo_asset__',
    recordDate: DateTime(2025, 4, 1),
    balance: 3250000,
    principal: 3200000,
    profit: 50000,
    note: '이자 입금',
    createdAt: DateTime(2025, 4, 1),
  ),
  AssetRecordModel(
    entryType: AssetRecordEntryType.snapshot,
    date: DateTime(2025, 5, 1),
    id: '__demo_r3__',
    accountId: '__demo_asset__',
    recordDate: DateTime(2025, 5, 1),
    balance: 3500000,
    principal: 3400000,
    profit: 100000,
    note: '이자 입금',
    createdAt: DateTime(2025, 5, 1),
  ),
];

class AccountDetailScreen extends ConsumerStatefulWidget {
  final AccountModel account;
  final bool isDemo;

  const AccountDetailScreen({super.key, required this.account, this.isDemo = false});

  @override
  ConsumerState<AccountDetailScreen> createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends ConsumerState<AccountDetailScreen> {
  final _infoCardKey = GlobalKey();
  final _addRecordKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.isDemo) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showDemoCoachMark());
    }
  }

  TargetPosition? _keyToPosition(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final offset = box.localToGlobal(Offset.zero);
    return TargetPosition(box.size, offset);
  }

  Future<void> _showDemoCoachMark() async {
    if (!mounted) return;
    final infoPos = _keyToPosition(_infoCardKey);
    final recordPos = _keyToPosition(_addRecordKey);
    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'asset_info_card',
        targetPosition: infoPos,
        keyTarget: infoPos == null ? _infoCardKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '계좌 상세 정보',
              description: '최신 잔액, 수익률, 금융기관 정보를\n한눈에 확인할 수 있어요.',
              icon: Icons.account_balance_outlined,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'asset_add_record',
        targetPosition: recordPos,
        keyTarget: recordPos == null ? _addRecordKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '잔액 기록',
              description: '잔액을 주기적으로 기록하면\n자산 변화 추이를 차트로 확인할 수 있어요.',
              icon: Icons.add_chart,
              color: Colors.teal,
            ),
          ),
        ],
      ),
    ];
    await FeatureCoachMark.waitForTargets(targets, context);
    if (!mounted) return;
    TutorialCoachMark(
      targets: FeatureCoachMark.refreshPositions(targets),
      colorShadow: const Color(0xFF212121),
      opacityShadow: 0.85,
      textSkip: '건너뛰기',
      alignSkip: Alignment.topRight,
      skipWidget: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white30),
        ),
        child: const Text(
          '건너뛰기',
          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
      onFinish: _completeDemoOnboarding,
      onSkip: () {
        _completeDemoOnboarding();
        return true;
      },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
  }

  void _completeDemoOnboarding() {
    OnboardingService.completeCoachMark(CoachMarkKeys.assets);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final account = widget.account;

    // demo 모드: API 호출 없이 가짜 데이터만 렌더링
    if (widget.isDemo) {
      return Scaffold(
        appBar: AppBar(title: Text(account.name)),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: AccountInfoCard(key: _infoCardKey, account: account),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.spaceM, AppSizes.spaceS, AppSizes.spaceM, AppSizes.spaceM,
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
                      key: _addRecordKey,
                      onPressed: null,
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(l10n.asset_add_record),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => AssetRecordListItem(
                  record: _demoRecords[index],
                  isDemo: true,
                ),
                childCount: _demoRecords.length,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 80 + MediaQuery.of(context).padding.bottom),
            ),
          ],
        ),
      );
    }

    // 일반 모드: API 조회
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
          SliverToBoxAdapter(
            child: AccountInfoCard(account: currentAccount),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.spaceM, AppSizes.spaceS, AppSizes.spaceM, AppSizes.spaceM,
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
                      accountAssetTrendProvider(account.id, period: period, year: year),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: HoldingRecordsSection(
              accountId: account.id,
              assetRecords: recordsAsync.valueOrNull ?? [],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceM,
                vertical: AppSizes.spaceS,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        l10n.asset_records,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (account.type == AccountType.gold) ...[
                        const SizedBox(width: 2),
                        IconButton(
                          icon: const Icon(Icons.help_outline, size: 18),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          tooltip: l10n.asset_gold_record_info_title,
                          onPressed: () => _showGoldInfoDialog(context, l10n),
                        ),
                      ],
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () => _showAddSheet(context),
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(l10n.asset_add_record),
                  ),
                ],
              ),
            ),
          ),
          // 자산 기록 목록 (SNAPSHOT + WITHDRAWAL 통합, 서버에서 날짜 내림차순 정렬)
          recordsAsync.when(
            data: (records) {
              if (records.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceXL),
                    child: Column(
                      children: [
                        Icon(Icons.receipt_long_outlined, size: 48,
                            color: Theme.of(context).colorScheme.outline),
                        const SizedBox(height: AppSizes.spaceS),
                        Text(l10n.asset_no_records,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.outline)),
                      ],
                    ),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = records[index];
                    return item.isWithdrawal
                        ? _WithdrawalListItem(record: item, accountId: account.id)
                        : AssetRecordListItem(record: item);
                  },
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
          SliverToBoxAdapter(
            child: SizedBox(height: 80 + MediaQuery.of(context).padding.bottom),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showGoldInfoDialog(BuildContext context, AppLocalizations l10n) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.diamond_outlined),
        title: Text(l10n.asset_gold_record_info_title),
        content: SingleChildScrollView(
          child: Text(l10n.asset_gold_record_info_body),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.common_ok),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      builder: (ctx) => _AddActionSheet(
        onSelectRecord: () {
          Navigator.of(ctx).pop();
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (_) => AddAssetRecordSheet(account: widget.account),
          );
        },
        onSelectWithdrawal: () {
          Navigator.of(ctx).pop();
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (_) => AddWithdrawalSheet(accountId: widget.account.id),
          );
        },
      ),
    );
  }
}

// ─── 출금 기록 목록 아이템 (AssetRecordModel.entryType == withdrawal) ──────────
class _WithdrawalListItem extends ConsumerWidget {
  final AssetRecordModel record;
  final String accountId;

  const _WithdrawalListItem({required this.record, required this.accountId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateStr =
        '${record.date.year}.${record.date.month.toString().padLeft(2, '0')}.${record.date.day.toString().padLeft(2, '0')}';
    final typeColor = record.withdrawalType == WithdrawalType.profit
        ? Colors.orange.shade700
        : Theme.of(context).colorScheme.primary;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM, vertical: AppSizes.spaceXS),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Row(
          children: [
            Icon(
              record.withdrawalType == WithdrawalType.profit
                  ? Icons.trending_up
                  : Icons.savings_outlined,
              size: 20,
              color: typeColor,
            ),
            const SizedBox(width: AppSizes.spaceS),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
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
            Text(
              '-₩${formatAssetAmount(record.amount ?? 0)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18),
              color: Theme.of(context).colorScheme.error,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              onPressed: () => _confirmDelete(context, ref),
            ),
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
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('취소')),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('삭제', style: TextStyle(color: Theme.of(ctx).colorScheme.error)),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await ref.read(assetManagementProvider.notifier).deleteWithdrawal(accountId, record.id);
    }
  }
}

// ─── 기록 추가 선택 시트 ──────────────────────────────────────────────────────
class _AddActionSheet extends StatelessWidget {
  final VoidCallback onSelectRecord;
  final VoidCallback onSelectWithdrawal;

  const _AddActionSheet({
    required this.onSelectRecord,
    required this.onSelectWithdrawal,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceS),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add_chart_outlined),
              title: const Text('잔액 기록'),
              subtitle: const Text('잔액·원금·수익을 기록합니다'),
              onTap: onSelectRecord,
            ),
            ListTile(
              leading: const Icon(Icons.remove_circle_outline),
              title: const Text('출금'),
              subtitle: const Text('원금 인출 또는 수익 실현을 기록합니다'),
              onTap: onSelectWithdrawal,
            ),
          ],
        ),
      ),
    );
  }
}
