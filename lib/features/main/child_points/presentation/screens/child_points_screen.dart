import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/main/child_points/data/models/childcare_model.dart';
import 'package:family_planner/features/main/child_points/presentation/screens/history_tab.dart';
import 'package:family_planner/features/main/child_points/presentation/screens/points_tab.dart';
import 'package:family_planner/features/main/child_points/presentation/screens/rules_tab.dart';
import 'package:family_planner/features/main/child_points/presentation/screens/shop_tab.dart';
import 'package:family_planner/features/main/child_points/presentation/widgets/group_and_child_bar.dart';
import 'package:family_planner/features/main/child_points/presentation/widgets/management_loading_overlay.dart';
import 'package:family_planner/features/main/child_points/providers/childcare_provider.dart';
import 'package:family_planner/features/onboarding/presentation/widgets/feature_coach_mark.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/features/settings/groups/providers/default_group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/app_bar_more_menu.dart';

part '_child_points_onboarding.dart';

/// 육아포인트 메인 화면
class ChildPointsScreen extends ConsumerStatefulWidget {
  const ChildPointsScreen({super.key});

  @override
  ConsumerState<ChildPointsScreen> createState() => _ChildPointsScreenState();
}

class _ChildPointsScreenState extends ConsumerState<ChildPointsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // 온보딩 데모 상태
  bool _isDemo = false;
  final _addChildKey = GlobalKey();
  final _accountCardKey = GlobalKey();
  final _savingsPlanKey = GlobalKey();
  final _shopListKey = GlobalKey();
  final _rulePlusKey = GlobalKey();
  final _ruleMinusKey = GlobalKey();
  final _ruleInfoKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initGroupSelection();
      _maybeStartOnboarding();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initGroupSelection() async {
    final defaultId = ref.read(defaultGroupProvider);
    final groups =
        await ref.read(myGroupsProvider.future).catchError((_) => <Group>[]);
    if (groups.isEmpty || !mounted) return;
    final resolved = (defaultId != null && groups.any((g) => g.id == defaultId))
        ? defaultId
        : groups.first.id;
    ref.read(childcareSelectedGroupIdProvider.notifier).state = resolved;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final groupsAsync = ref.watch(myGroupsProvider);
    final selectedGroupId = ref.watch(childcareSelectedGroupIdProvider);
    final selectedChildId = ref.watch(childcareSelectedChildIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.childcare_title),
        leading: context.canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              )
            : null,
        automaticallyImplyLeading: false,
        actions: [
          if (selectedGroupId != null || _isDemo)
            IconButton(
              key: _addChildKey,
              icon: const Icon(Icons.person_add_outlined),
              tooltip: '자녀 등록',
              onPressed: _isDemo
                  ? null
                  : () => context.push(
                        AppRoutes.childPointsChildProfileForm,
                        extra: {'groupId': selectedGroupId},
                      ),
            ),
          AppBarMoreMenu(
            onReplayOnboarding: _replayOnboarding,
            extraItems: [
              if (selectedChildId != null && !_isDemo) ...[
                MoreMenuItem(
                  id: 'allowance',
                  icon: Icons.monetization_on_outlined,
                  label: '용돈 플랜 설정',
                  onTap: (ctx) => ctx.push(
                    AppRoutes.childPointsAllowancePlan,
                    extra: {'childId': selectedChildId},
                  ),
                ),
                MoreMenuItem(
                  id: 'link',
                  icon: Icons.link,
                  label: '앱 계정 연동',
                  onTap: (ctx) => ctx.push(
                    AppRoutes.childPointsLinkUser,
                    extra: {'childId': selectedChildId},
                  ),
                ),
              ],
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: l10n.childcare_tab_points),
            Tab(text: l10n.childcare_tab_rewards),
            Tab(text: l10n.childcare_tab_rules),
            Tab(text: l10n.childcare_tab_history),
          ],
        ),
      ),
      body: ManagementLoadingOverlay(
        child: Column(
          children: [
            if (!_isDemo)
              GroupAndChildBar(
                groupsAsync: groupsAsync,
                selectedGroupId: selectedGroupId,
              ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  PointsTab(
                    selectedChildId: _isDemo ? '__demo_child__' : selectedChildId,
                    demoAccount: _isDemo ? _demoAccount : null,
                    demoPlan: _isDemo ? _demoPlan : null,
                    demoSavingsPlan: _isDemo ? _demoSavingsPlan : null,
                    demoAccountCardKey: _isDemo ? _accountCardKey : null,
                    demoSavingsPlanKey: _isDemo ? _savingsPlanKey : null,
                  ),
                  ShopTab(
                    demoItems: _isDemo ? _demoShopItems : null,
                    demoShopKey: _isDemo ? _shopListKey : null,
                  ),
                  RulesTab(
                    demoRules: _isDemo ? _demoRules : null,
                    demoPlusKey: _isDemo ? _rulePlusKey : null,
                    demoMinusKey: _isDemo ? _ruleMinusKey : null,
                    demoInfoKey: _isDemo ? _ruleInfoKey : null,
                  ),
                  const HistoryTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
