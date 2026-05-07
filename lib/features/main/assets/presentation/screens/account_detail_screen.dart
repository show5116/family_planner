import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/main/assets/data/models/account_model.dart';
import 'package:family_planner/features/main/assets/data/repositories/asset_repository.dart';
import 'package:family_planner/features/main/assets/providers/asset_provider.dart';
import 'package:family_planner/features/main/assets/presentation/widgets/account_info_card.dart';
import 'package:family_planner/features/main/assets/presentation/widgets/add_asset_record_sheet.dart';
import 'package:family_planner/features/main/assets/presentation/widgets/asset_record_list_item.dart';
import 'package:family_planner/features/main/assets/presentation/widgets/asset_trend_chart.dart';
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

  Future<void> _showDemoCoachMark() async {
    if (!mounted) return;
    TutorialCoachMark(
      targets: [
        TargetFocus(
          identify: 'asset_info_card',
          keyTarget: _infoCardKey,
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
          keyTarget: _addRecordKey,
          shape: ShapeLightFocus.RRect,
          radius: 12,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (_, _) => FeatureCoachMark.buildContent(
                title: '잔액 기록',
                description: '잔액을 주기적으로 기록하면\n자산 변화 추이를 차트로 확인할 수 있어요.',
                icon: Icons.add_chart,
                color: Colors.teal,
              ),
            ),
          ],
        ),
      ],
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
                  key: _addRecordKey,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.asset_records,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    TextButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(l10n.asset_add_record),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
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
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
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
      builder: (ctx) => AddAssetRecordSheet(accountId: widget.account.id),
    );
  }
}
