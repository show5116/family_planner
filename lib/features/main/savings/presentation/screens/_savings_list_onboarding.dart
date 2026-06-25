part of 'savings_list_screen.dart';

// 온보딩용 가짜 저금통 데이터
final _demoGoals = [
  SavingsGoalModel(
    id: '__demo_1__',
    groupId: '__demo__',
    name: '제주도 여행',
    description: '올해 여름 가족 여행 목표',
    targetAmount: 1500000,
    currentAmount: 870000,
    autoDeposit: true,
    monthlyAmount: 150000,
    depositDay: 25,
    includeInAssets: false,
    status: SavingsGoalStatus.active,
    achievementRate: 58.0,
    createdAt: DateTime(2025, 1, 1),
    updatedAt: DateTime(2025, 5, 1),
  ),
  SavingsGoalModel(
    id: '__demo_2__',
    groupId: '__demo__',
    name: '비상금',
    description: null,
    targetAmount: 3000000,
    currentAmount: 1200000,
    autoDeposit: false,
    monthlyAmount: null,
    depositDay: 1,
    includeInAssets: false,
    status: SavingsGoalStatus.active,
    achievementRate: 40.0,
    createdAt: DateTime(2025, 1, 1),
    updatedAt: DateTime(2025, 5, 1),
  ),
];

extension _SavingsListOnboarding on _SavingsListScreenState {
  Future<void> _maybeStartOnboarding() async {
    final completed =
        await OnboardingService.isCoachMarkCompleted(CoachMarkKeys.savings);
    if (completed || !mounted) return;
    _startDemo();
  }

  void _replayOnboarding() {
    OnboardingService.resetCoachMark(CoachMarkKeys.savings).then((_) {
      if (mounted) _startDemo();
    });
  }

  TargetPosition? _keyToPosition(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final offset = box.localToGlobal(Offset.zero);
    return TargetPosition(box.size, offset);
  }

  void _startDemo() {
    _onboardingGoals.value = _demoGoals;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final animation = ModalRoute.of(context)?.animation;
      if (animation == null || animation.isCompleted) {
        _showCoachMark();
      } else {
        void listener(AnimationStatus status) {
          if (status == AnimationStatus.completed) {
            animation.removeStatusListener(listener);
            if (mounted) _showCoachMark();
          }
        }
        animation.addStatusListener(listener);
      }
    });
  }

  void _goToDemo() {
    if (!mounted) return;
    _onboardingGoals.value = null;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SavingsDetailScreen.demo(demoGoal: _demoGoals.first),
      ),
    );
  }

  Future<void> _showCoachMark() async {
    if (!mounted) return;
    final firstCardPos = _keyToPosition(_firstCardKey);
    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'savings_card_info',
        targetPosition: firstCardPos,
        keyTarget: firstCardPos == null ? _firstCardKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '저금통',
              description: '목표 이름, 현재 적립금, 달성률을 한눈에 확인할 수 있어요.\n자동 적립을 켜두면 매달 자동으로 입금돼요.',
              icon: Icons.savings_outlined,
              color: AppColors.investment,
            ),
          ),
        ],
      ),
    ];
    await FeatureCoachMark.waitForTargets(targets, context);
    if (!mounted) return;
    TutorialCoachMark(
      targets: FeatureCoachMark.refreshPositions(targets),
      colorShadow: AppColors.textPrimary,
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
          style: TextStyle(
              color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
      onClickTarget: (_) => _goToDemo(),
      onFinish: () {},
      onSkip: () {
        OnboardingService.completeCoachMark(CoachMarkKeys.savings);
        _onboardingGoals.value = null;
        return true;
      },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
  }
}

// 온보딩 전용 목록 (가짜 데이터, 탭 불가)
class _OnboardingGoalsList extends StatelessWidget {
  const _OnboardingGoalsList({
    required this.goals,
    required this.firstCardKey,
  });

  final List<SavingsGoalModel> goals;
  final GlobalKey firstCardKey;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      itemCount: goals.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSizes.spaceS),
      itemBuilder: (context, index) {
        return _GoalCard(
          key: index == 0 ? firstCardKey : null,
          goal: goals[index],
          onTap: () {},
        );
      },
    );
  }
}
