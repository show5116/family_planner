import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/core/widgets/reorderable_widgets.dart';
import 'package:family_planner/features/main/assets/providers/asset_provider.dart';
import 'package:family_planner/features/main/assets/presentation/screens/account_detail_screen.dart';
import 'package:family_planner/features/main/assets/presentation/widgets/account_list_item.dart';

import 'package:family_planner/features/main/assets/presentation/widgets/asset_group_bar.dart';
import 'package:family_planner/features/main/assets/presentation/widgets/asset_summary_card.dart';
import 'package:family_planner/features/main/assets/data/models/account_model.dart';
import 'package:family_planner/features/main/assets/utils/asset_utils.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/onboarding/presentation/widgets/feature_coach_mark.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';
import 'package:family_planner/shared/widgets/app_bar_more_menu.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

// 온보딩용 가짜 계좌 데이터
final _demoAccount = AccountModel(
  id: '__demo_asset__',
  groupId: '__demo__',
  userId: '__demo__',
  name: '국민은행 적금',
  accountNumber: '****-****-1234',
  institution: '국민은행',
  type: AccountType.savings,
  createdAt: DateTime(2025, 1, 1),
  updatedAt: DateTime(2025, 5, 1),
  latestBalance: 3500000,
  profitRate: 3.2,
);

class AssetScreen extends ConsumerStatefulWidget {
  const AssetScreen({super.key});

  @override
  ConsumerState<AssetScreen> createState() => _AssetScreenState();
}

class _AssetScreenState extends ConsumerState<AssetScreen> {
  final _fabKey = GlobalKey();
  final _groupBarKey = GlobalKey();
  final _demoCardKey = GlobalKey();
  // ValueNotifier: setState 없이 온보딩 on/off — 코치마크 콜백 내 build 충돌 방지
  final _showDemo = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initGroupSelection();
      await _maybeStartOnboarding();
    });
  }

  @override
  void dispose() {
    _showDemo.dispose();
    super.dispose();
  }

  Future<void> _initGroupSelection() async {
    final groupId = ref.read(assetSelectedGroupIdProvider);
    if (groupId != null) return;
    final groups = await ref.read(myGroupsProvider.future).catchError((_) => <Group>[]);
    if (groups.isNotEmpty && mounted) {
      ref.read(assetSelectedGroupIdProvider.notifier).state = groups.first.id;
    }
  }

  Future<void> _maybeStartOnboarding() async {
    final completed = await OnboardingService.isCoachMarkCompleted(CoachMarkKeys.assets);
    if (completed || !mounted) return;
    _startDemo();
  }

  void _replayOnboarding() {
    OnboardingService.resetCoachMark(CoachMarkKeys.assets).then((_) {
      if (mounted) _startDemo();
    });
  }

  void _startDemo() {
    _showDemo.value = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _showCoachMark());
  }

  void _goToDemo() {
    if (!mounted) return;
    _showDemo.value = false;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AccountDetailScreen(
          account: _demoAccount,
          isDemo: true,
        ),
      ),
    );
  }

  TargetPosition? _keyToPosition(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final offset = box.localToGlobal(Offset.zero);
    return TargetPosition(box.size, offset);
  }

  Future<void> _showCoachMark() async {
    if (!mounted) return;
    final cardPos = _keyToPosition(_demoCardKey);
    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'asset_card',
        targetPosition: cardPos,
        keyTarget: cardPos == null ? _demoCardKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '계좌 카드',
              description: '계좌명, 금융기관, 최신 잔액과\n수익률을 한눈에 확인할 수 있어요.',
              icon: Icons.account_balance_outlined,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    ];
    await FeatureCoachMark.waitForTargets(targets, context);
    if (!mounted) return;
    TutorialCoachMark(
      targets: targets,
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
      onClickTarget: (_) => _goToDemo(),
      onFinish: () {
        // onClickTarget 으로 이미 이동했으므로 중복 실행 방지
      },
      onSkip: () {
        OnboardingService.completeCoachMark(CoachMarkKeys.assets);
        _showDemo.value = false;
        return true;
      },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final groupsAsync = ref.watch(myGroupsProvider);
    final selectedGroupId = ref.watch(assetSelectedGroupIdProvider);

    return ValueListenableBuilder<bool>(
      valueListenable: _showDemo,
      builder: (context, isDemo, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.asset_title),
            actions: [
              if (!isDemo)
                IconButton(
                  icon: const Icon(Icons.bar_chart),
                  tooltip: l10n.asset_statistics,
                  onPressed: () => context.push(AppRoutes.assetStatistics),
                ),
              if (!isDemo)
                AppBarMoreMenu(onReplayOnboarding: _replayOnboarding),
            ],
          ),
          body: Column(
            children: [
              if (!isDemo)
                AssetGroupBar(
                  key: _groupBarKey,
                  groupsAsync: groupsAsync,
                  selectedGroupId: selectedGroupId,
                ),
              if (!isDemo) const AssetSummaryCard(),
              if (isDemo)
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(AppSizes.spaceM),
                    children: [
                      AccountListItem(
                        key: _demoCardKey,
                        account: _demoAccount,
                        showDragHandle: false,
                        dragIndex: 0,
                        onTap: _goToDemo,
                        onDelete: () {},
                      ),
                    ],
                  ),
                )
              else
                Expanded(
                  child: _AssetList(selectedGroupId: selectedGroupId),
                ),
            ],
          ),
          floatingActionButton: (!isDemo && selectedGroupId != null)
              ? FloatingActionButton(
                  key: _fabKey,
                  onPressed: () => context.push(
                    AppRoutes.assetAccountAdd,
                    extra: {'groupId': selectedGroupId},
                  ),
                  child: const Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }
}

class _AssetList extends ConsumerStatefulWidget {
  final String? selectedGroupId;

  const _AssetList({required this.selectedGroupId});

  @override
  ConsumerState<_AssetList> createState() => _AssetListState();
}

class _AssetListState extends ConsumerState<_AssetList> {
  List<AccountModel>? _reorderedAccounts;
  bool _hasChanges = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (widget.selectedGroupId == null) {
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

    // 서버에서 새 목록이 오면 로컬 reorder 상태 초기화
    ref.listen(assetAccountsProvider, (previous, next) {
      final prevIds = previous?.valueOrNull?.map((a) => a.id).toList() ?? [];
      final nextIds = next.valueOrNull?.map((a) => a.id).toList() ?? [];
      if (prevIds.length != nextIds.length ||
          !prevIds.every((id) => nextIds.contains(id))) {
        setState(() {
          _reorderedAccounts = null;
          _hasChanges = false;
        });
      }
    });

    return accountsAsync.when(
      data: (accounts) {
        final displayAccounts = _reorderedAccounts ?? accounts;
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

        return Column(
          children: [
            if (_hasChanges)
              ReorderChangesBar(
                onSave: _saveReorder,
                onCancel: _cancelReorder,
              ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () =>
                    ref.read(assetAccountsProvider.notifier).refresh(),
                child: CustomScrollView(
                  slivers: [
                    if (hasAccounts)
                      SliverReorderableList(
                        itemCount: displayAccounts.length,
                        proxyDecorator: buildReorderableProxyDecorator,
                        onReorder: (oldIndex, newIndex) {
                          if (newIndex > oldIndex) newIndex -= 1;
                          setState(() {
                            _reorderedAccounts ??= List.from(displayAccounts);
                            final item =
                                _reorderedAccounts!.removeAt(oldIndex);
                            _reorderedAccounts!.insert(newIndex, item);
                            _hasChanges = true;
                          });
                        },
                        itemBuilder: (context, index) {
                          final account = displayAccounts[index];
                          return AccountListItem(
                            key: ValueKey(account.id),
                            account: account,
                            showDragHandle: true,
                            dragIndex: index,
                            onTap: () => context.push(
                              AppRoutes.assetAccountDetail,
                              extra: account,
                            ),
                            onDelete: () => _confirmDelete(
                                context, ref, l10n, account),
                          );
                        },
                      ),
                    if (hasSavings) ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSizes.spaceM,
                            AppSizes.spaceM,
                            AppSizes.spaceM,
                            AppSizes.spaceXS,
                          ),
                          child: Text(
                            l10n.asset_savings_goals,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.outline,
                                ),
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final goal = savingsGoals[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: AppSizes.spaceM,
                                vertical: AppSizes.spaceXS,
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .tertiaryContainer,
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                onTap: () =>
                                    context.push('/savings/${goal.id}'),
                              ),
                            );
                          },
                          childCount: savingsGoals.length,
                        ),
                      ),
                    ],
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 80),
                    ),
                  ],
                ),
              ),
            ),
          ],
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

  Future<void> _cancelReorder() async {
    final confirmed = await showReorderCancelDialog(context);
    if (confirmed && mounted) {
      setState(() {
        _reorderedAccounts = null;
        _hasChanges = false;
      });
    }
  }

  Future<void> _saveReorder() async {
    if (_reorderedAccounts == null) return;
    final groupId = widget.selectedGroupId;
    if (groupId == null) return;

    final confirm = await showReorderSaveDialog(context);
    if (!confirm || !mounted) return;

    final success = await ref
        .read(assetManagementProvider.notifier)
        .reorderAccounts(groupId: groupId, reordered: _reorderedAccounts!);

    if (!mounted) return;
    if (success) {
      setState(() {
        _reorderedAccounts = null;
        _hasChanges = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('계좌 순서가 저장되었습니다')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(AppLocalizations.of(context)!.common_error)),
      );
    }
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
