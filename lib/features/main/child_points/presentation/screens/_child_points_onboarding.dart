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
    setState(() => _isDemo = true);
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
    if (mounted) setState(() => _isDemo = false);
  }

  void _replayOnboarding() {
    OnboardingService.resetCoachMark(CoachMarkKeys.childPoints);
    _startDemo();
  }

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
              title: '+ 포인트 규칙',
              description: '좋은 행동을 했을 때 포인트를 지급해요.\n예: 숙제를 스스로 끝냈을 때 +10P',
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
              title: '- 포인트 규칙',
              description: '약속을 어겼을 때 포인트를 차감해요.\n예: 스마트폰을 1시간 이상 사용하면 -10P',
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
              title: '일반 규칙',
              description: '포인트 없이 약속만 기록해요.\n예: 이달 현금 출금은 최대 50P까지만 가능',
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
}
