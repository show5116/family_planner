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

// ── 온보딩용 샘플 데이터 ─────────────────────────────────────────────────────

final _demoNow = DateTime(2025, 5, 1);

final _demoAccount = ChildcareAccount(
  id: '__demo_account__',
  groupId: '__demo_group__',
  childId: '__demo_child__',
  parentUserId: '__demo_parent__',
  balance: 1250,
  savingsBalance: 3000,
  createdAt: _demoNow,
  updatedAt: _demoNow,
);

final _demoPlan = AllowancePlan(
  id: '__demo_plan__',
  childId: '__demo_child__',
  monthlyPoints: 500,
  payDay: 1,
  pointToMoneyRatio: 10,
  createdAt: _demoNow,
  updatedAt: _demoNow,
);

final _demoSavingsPlan = ChildcareSavingsPlan(
  id: '__demo_savings__',
  accountId: '__demo_account__',
  monthlyAmount: 200,
  interestRate: 3.5,
  interestType: SavingsInterestType.compound,
  startDate: DateTime(2025, 1, 1),
  endDate: DateTime(2026, 1, 1),
  status: SavingsPlanStatus.active,
  createdAt: _demoNow,
  updatedAt: _demoNow,
);

final _demoShopItems = [
  ChildcareShopItem(
    id: '__demo_shop1__',
    accountId: '__demo_account__',
    name: 'TV 30분 더보기',
    description: '저녁 식사 후 TV 30분 추가',
    points: 10,
    isActive: true,
    createdAt: _demoNow,
    updatedAt: _demoNow,
  ),
  ChildcareShopItem(
    id: '__demo_shop2__',
    accountId: '__demo_account__',
    name: '게임 1시간 하기',
    description: '주말에 게임 1시간',
    points: 20,
    isActive: true,
    createdAt: _demoNow,
    updatedAt: _demoNow,
  ),
  ChildcareShopItem(
    id: '__demo_shop3__',
    accountId: '__demo_account__',
    name: '원하는 간식 고르기',
    points: 15,
    isActive: false,
    createdAt: _demoNow,
    updatedAt: _demoNow,
  ),
];

final _demoRules = [
  ChildcareRule(
    id: '__demo_rule1__',
    accountId: '__demo_account__',
    name: '숙제를 스스로 끝냈을 때',
    points: 10,
    type: ChildcareRuleType.plus,
    isActive: true,
    createdAt: _demoNow,
    updatedAt: _demoNow,
  ),
  ChildcareRule(
    id: '__demo_rule2__',
    accountId: '__demo_account__',
    name: '스마트폰 1시간 이상 사용',
    points: 10,
    type: ChildcareRuleType.minus,
    isActive: true,
    createdAt: _demoNow,
    updatedAt: _demoNow,
  ),
  ChildcareRule(
    id: '__demo_rule3__',
    accountId: '__demo_account__',
    name: '이달 현금 출금은 최대 50P',
    points: 0,
    type: ChildcareRuleType.info,
    isActive: true,
    createdAt: _demoNow,
    updatedAt: _demoNow,
  ),
];

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

  TargetPosition? _keyToPosition(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final offset = box.localToGlobal(Offset.zero);
    return TargetPosition(box.size, offset);
  }

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

  Future<void> _maybeStartOnboarding() async {
    final completed =
        await OnboardingService.isCoachMarkCompleted(CoachMarkKeys.childPoints);
    if (!mounted || completed) return;
    _startDemo();
  }

  void _startDemo() {
    setState(() => _isDemo = true);
    WidgetsBinding.instance.addPostFrameCallback((_) => _showPhase1());
  }

  void _endDemo() {
    if (mounted) setState(() => _isDemo = false);
  }

  void _replayOnboarding() {
    OnboardingService.resetCoachMark(CoachMarkKeys.childPoints);
    _startDemo();
  }

  // ── 1단계: 자녀 등록 안내 ─────────────────────────────────────────────────

  Future<void> _showPhase1() async {
    if (!mounted) return;
    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'add_child',
        keyTarget: _addChildKey,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '자녀 등록',
              description: '먼저 자녀를 등록해요.\n이름과 생년월일을 입력하면\n포인트 계정이 자동으로 만들어져요.',
              icon: Icons.person_add_outlined,
              color: AppColors.primary,
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
      skipWidget: _skipWidget,
      onFinish: _showPhase2,
      onSkip: () {
        _completeOnboarding();
        return true;
      },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
  }

  // ── 2단계: 포인트 탭 샘플 데이터 설명 ────────────────────────────────────

  Future<void> _showPhase2() async {
    if (!mounted) return;
    _tabController.animateTo(0);
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    final accountPos = _keyToPosition(_accountCardKey);
    final savingsPos = _keyToPosition(_savingsPlanKey);
    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'points_tab_info',
        targetPosition: accountPos,
        keyTarget: accountPos == null ? _accountCardKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 16,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '포인트 현황',
              description:
                  '자녀의 현재 포인트 잔액과\n월 용돈 플랜을 한눈에 확인할 수 있어요.\n매월 설정한 날짜에 자동으로 포인트가 지급돼요.',
              icon: Icons.star_rounded,
              color: Colors.amber.shade700,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'savings_plan_info',
        targetPosition: savingsPos,
        keyTarget: savingsPos == null ? _savingsPlanKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 16,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '적금 플랜',
              description:
                  '포인트 적금을 설정하면\n매월 자동으로 포인트가 적립되고\n이자도 받을 수 있어요.',
              icon: Icons.savings_rounded,
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
      skipWidget: _skipWidget,
      onFinish: _showPhase3Shop,
      onSkip: () {
        _completeOnboarding();
        return true;
      },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
  }

  // ── 3단계: 상점 탭 설명 ───────────────────────────────────────────────────

  Future<void> _showPhase3Shop() async {
    if (!mounted) return;
    _tabController.animateTo(1);
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'shop_tab_info',
        targetPosition: TargetPosition(
          Size(w - 32, 220),
          Offset(16, h * 0.28),
        ),
        shape: ShapeLightFocus.RRect,
        radius: 16,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '포인트 상점',
              description:
                  '아이가 모은 포인트로 구매할 수 있는\n보상 목록이에요.\n원하는 것을 얻기 위해 스스로 포인트를\n모으는 동기부여가 됩니다.',
              icon: Icons.storefront_outlined,
              color: Colors.orange,
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
      skipWidget: _skipWidget,
      onFinish: _showPhase3Rules,
      onSkip: () {
        _completeOnboarding();
        return true;
      },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
  }

  // ── 4단계: 규칙 탭 설명 ───────────────────────────────────────────────────

  Future<void> _showPhase3Rules() async {
    if (!mounted) return;
    _tabController.animateTo(2);
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'rules_plus',
        targetPosition: TargetPosition(
          Size(w - 32, 60),
          Offset(16, h * 0.28),
        ),
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '+ 포인트 규칙',
              description:
                  '좋은 행동을 했을 때 포인트를 지급해요.\n예: 숙제를 스스로 끝냈을 때 +10P',
              icon: Icons.add_circle_outline,
              color: Colors.green.shade700,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'rules_minus',
        targetPosition: TargetPosition(
          Size(w - 32, 60),
          Offset(16, h * 0.42),
        ),
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '- 포인트 규칙',
              description:
                  '약속을 어겼을 때 포인트를 차감해요.\n예: 스마트폰을 1시간 이상 사용하면 -10P',
              icon: Icons.remove_circle_outline,
              color: Colors.red,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'rules_info',
        targetPosition: TargetPosition(
          Size(w - 32, 60),
          Offset(16, h * 0.55),
        ),
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '일반 규칙',
              description:
                  '포인트 없이 약속만 기록해요.\n예: 이달 현금 출금은 최대 50P까지만 가능',
              icon: Icons.info_outline,
              color: AppColors.primary,
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
      skipWidget: _skipWidget,
      onFinish: _completeOnboarding,
      onSkip: () {
        _completeOnboarding();
        return true;
      },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
  }

  void _completeOnboarding() {
    OnboardingService.completeCoachMark(CoachMarkKeys.childPoints);
    _endDemo();
  }

  Widget get _skipWidget => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white30),
        ),
        child: const Text(
          '건너뛰기',
          style: TextStyle(
              color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      );

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
                  ),
                  RulesTab(
                    demoRules: _isDemo ? _demoRules : null,
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
