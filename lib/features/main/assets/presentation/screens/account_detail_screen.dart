import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/main/assets/data/models/account_model.dart';
import 'package:family_planner/features/main/assets/data/models/asset_record_model.dart';
import 'package:family_planner/features/main/assets/data/repositories/asset_repository.dart';
import 'package:family_planner/features/main/assets/presentation/widgets/withdrawal_list_item.dart';
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
  final _portfolioKey = GlobalKey();
  final _demoScrollController = ScrollController();
  static const _recordsInitialCount = 5;
  bool _recordsExpanded = false;

  @override
  void initState() {
    super.initState();
    if (widget.isDemo) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showDemoCoachMark());
    }
  }

  @override
  void dispose() {
    _demoScrollController.dispose();
    super.dispose();
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
    // 포트폴리오 좌표는 스크롤 후에 잡아야 정확함 — 먼저 끝까지 스크롤
    await _demoScrollController.animateTo(
      _demoScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    await Future.delayed(const Duration(milliseconds: 100));
    if (!mounted) return;
    // 포트폴리오 좌표 계산 후 다시 맨 위로
    final portfolioPos = _keyToPosition(_portfolioKey);
    _demoScrollController.jumpTo(0);
    await Future.delayed(const Duration(milliseconds: 50));
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
              description: '최신 잔액과 수익률을 확인하고,\n아래로 스크롤하면 자산 변화 차트와\n원금·수익금 통계를 볼 수 있어요.',
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
              title: '잔액 기록 추가',
              description: '잔액을 주기적으로 기록하면\n자산 변화 추이를 차트로 확인할 수 있어요.\n출금 기록도 함께 관리할 수 있습니다.',
              icon: Icons.add_chart,
              color: Colors.teal,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'asset_portfolio',
        targetPosition: portfolioPos,
        keyTarget: portfolioPos == null ? _portfolioKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '포트폴리오',
              description: '날짜별로 보유 종목과 금액을 기록해\n자산 구성을 파이차트로 확인하세요.\n두 날짜를 비교해 변화도 볼 수 있어요.',
              icon: Icons.pie_chart_outline,
              color: Colors.deepPurple,
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
      beforeFocus: (target) async {
        if (target.identify == 'asset_portfolio') {
          await _demoScrollController.animateTo(
            _demoScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
          );
        } else {
          _demoScrollController.jumpTo(0);
        }
      },
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
          controller: _demoScrollController,
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
              child: _DemoPortfolioSection(portfolioKey: _portfolioKey),
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
              final visibleRecords = _recordsExpanded
                  ? records
                  : records.take(_recordsInitialCount).toList();
              final hasMore = records.length > _recordsInitialCount;

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index < visibleRecords.length) {
                      final item = visibleRecords[index];
                      return item.isWithdrawal
                          ? WithdrawalListItem(record: item, accountId: account.id)
                          : AssetRecordListItem(record: item);
                    }
                    // 더보기 / 접기 버튼
                    return TextButton.icon(
                      onPressed: () => setState(() => _recordsExpanded = !_recordsExpanded),
                      icon: Icon(_recordsExpanded ? Icons.expand_less : Icons.expand_more),
                      label: Text(
                        _recordsExpanded
                            ? '접기'
                            : '전체 ${records.length}건 보기',
                      ),
                    );
                  },
                  childCount: hasMore ? visibleRecords.length + 1 : visibleRecords.length,
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

// ─── 데모용 포트폴리오 섹션 ────────────────────────────────────────────────────
class _DemoPortfolioSection extends StatelessWidget {
  final GlobalKey portfolioKey;

  const _DemoPortfolioSection({required this.portfolioKey});

  static const _items = [
    (label: '나스닥 ETF', ratio: 0.60, color: Color(0xFF6366F1)),
    (label: '삼성전자', ratio: 0.25, color: Color(0xFF22C55E)),
    (label: '현금', ratio: 0.15, color: Color(0xFFF59E0B)),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: portfolioKey,
      padding: const EdgeInsets.all(AppSizes.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '포트폴리오',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppSizes.spaceM),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  height: 160,
                  child: PieChart(
                    PieChartData(
                      sections: _items
                          .map((item) => PieChartSectionData(
                                value: item.ratio * 100,
                                color: item.color,
                                radius: 56,
                                showTitle: true,
                                title: '${(item.ratio * 100).toInt()}%',
                                titleStyle: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                titlePositionPercentageOffset: 0.6,
                              ))
                          .toList(),
                      centerSpaceRadius: 36,
                      sectionsSpace: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.spaceL),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _items
                    .map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: item.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${item.label}  ${(item.ratio * 100).toInt()}%',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
