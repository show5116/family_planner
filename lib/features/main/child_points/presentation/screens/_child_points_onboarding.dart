part of 'child_points_screen.dart';

// ── 온보딩용 샘플 데이터 ─────────────────────────────────────────────────────────

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

// 온보딩용 가짜 데이터. 번역이 필요해 최상위 상수로 둘 수 없다.
List<ChildcareShopItem> _demoShopItems(AppLocalizations l10n) => [
  ChildcareShopItem(
    id: '__demo_shop1__',
    accountId: '__demo_account__',
    name: l10n.childcare_shop_example1,
    description: l10n.demo_shop_tv_desc,
    points: 10,
    isActive: true,
    createdAt: _demoNow,
    updatedAt: _demoNow,
  ),
  ChildcareShopItem(
    id: '__demo_shop2__',
    accountId: '__demo_account__',
    name: l10n.childcare_shop_example2,
    description: l10n.demo_shop_game_desc,
    points: 20,
    isActive: true,
    createdAt: _demoNow,
    updatedAt: _demoNow,
  ),
  ChildcareShopItem(
    id: '__demo_shop3__',
    accountId: '__demo_account__',
    name: l10n.childcare_shop_example3,
    points: 15,
    isActive: false,
    createdAt: _demoNow,
    updatedAt: _demoNow,
  ),
];

List<ChildcareRule> _demoRules(AppLocalizations l10n) => [
  ChildcareRule(
    id: '__demo_rule1__',
    accountId: '__demo_account__',
    name: l10n.demo_rule_homework,
    points: 10,
    type: ChildcareRuleType.plus,
    isActive: true,
    createdAt: _demoNow,
    updatedAt: _demoNow,
  ),
  ChildcareRule(
    id: '__demo_rule2__',
    accountId: '__demo_account__',
    name: l10n.demo_rule_phone,
    points: 10,
    type: ChildcareRuleType.minus,
    isActive: true,
    createdAt: _demoNow,
    updatedAt: _demoNow,
  ),
  ChildcareRule(
    id: '__demo_rule3__',
    accountId: '__demo_account__',
    name: l10n.demo_rule_cashout,
    points: 0,
    type: ChildcareRuleType.info,
    isActive: true,
    createdAt: _demoNow,
    updatedAt: _demoNow,
  ),
];

// ── 온보딩 로직 ────────────────────────────────────────────────────────────────

extension _ChildPointsOnboarding on _ChildPointsScreenState {
  TargetPosition? _keyToPosition(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final offset = box.localToGlobal(Offset.zero);
    return TargetPosition(box.size, offset);
  }

  Future<void> _maybeStartOnboarding() async {
    final completed =
        await OnboardingService.isCoachMarkCompleted(CoachMarkKeys.childPoints);
    if (!mounted || completed) return;
    _startDemo();
  }

  void _startDemo() {
    setState(() => _isDemo = true); // ignore: invalid_use_of_protected_member
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final animation = ModalRoute.of(context)?.animation;
      if (animation == null || animation.isCompleted) {
        _showPhase1();
      } else {
        void listener(AnimationStatus status) {
          if (status == AnimationStatus.completed) {
            animation.removeStatusListener(listener);
            if (mounted) _showPhase1();
          }
        }
        animation.addStatusListener(listener);
      }
    });
  }

  void _endDemo() {
    if (mounted) setState(() => _isDemo = false); // ignore: invalid_use_of_protected_member
  }

  void _replayOnboarding() {
    OnboardingService.resetCoachMark(CoachMarkKeys.childPoints);
    _startDemo();
  }

  Future<void> _showPhase1() async {
    final l10n = AppLocalizations.of(context)!;
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
              title: l10n.coach_child_register,
              description: l10n.coach_child_register_desc,
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
      textSkip: l10n.common_skip,
      alignSkip: Alignment.bottomRight,
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

  Future<void> _showPhase2() async {
    final l10n = AppLocalizations.of(context)!;
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
              title: l10n.coach_child_points,
              description:
                  l10n.coach_child_points_desc,
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
              title: l10n.coach_child_savings,
              description:
                  l10n.coach_child_savings_desc,
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
      textSkip: l10n.common_skip,
      alignSkip: Alignment.bottomRight,
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

  Future<void> _showPhase3Shop() async {
    final l10n = AppLocalizations.of(context)!;
    if (!mounted) return;
    _tabController.animateTo(1);
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    final shopPos = _keyToPosition(_shopListKey);
    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'shop_tab_info',
        targetPosition: shopPos,
        keyTarget: shopPos == null ? _shopListKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 16,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: l10n.coach_child_shop,
              description:
                  l10n.coach_child_shop_desc,
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
      textSkip: l10n.common_skip,
      alignSkip: Alignment.bottomRight,
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

  Future<void> _showPhase3Rules() async {
    final l10n = AppLocalizations.of(context)!;
    if (!mounted) return;
    _tabController.animateTo(2);
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    final plusPos = _keyToPosition(_rulePlusKey);
    final minusPos = _keyToPosition(_ruleMinusKey);
    final infoPos = _keyToPosition(_ruleInfoKey);

    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'rules_plus',
        targetPosition: plusPos,
        keyTarget: plusPos == null ? _rulePlusKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: l10n.childcare_rule_type_plus,
              description: l10n.coach_child_rule_plus_desc,
              icon: Icons.add_circle_outline,
              color: Colors.green.shade700,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'rules_minus',
        targetPosition: minusPos,
        keyTarget: minusPos == null ? _ruleMinusKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: l10n.childcare_rule_type_minus,
              description: l10n.coach_child_rule_minus_desc,
              icon: Icons.remove_circle_outline,
              color: Colors.red,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'rules_info',
        targetPosition: infoPos,
        keyTarget: infoPos == null ? _ruleInfoKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: l10n.childcare_rule_type_info,
              description: l10n.coach_child_rule_info_desc,
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
      textSkip: l10n.common_skip,
      alignSkip: Alignment.bottomRight,
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

  Widget get _skipWidget {
    final l10n = AppLocalizations.of(context)!;
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white30),
        ),
        child: Text(
          l10n.common_skip,
          style: TextStyle(
              color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      );
  }
}
