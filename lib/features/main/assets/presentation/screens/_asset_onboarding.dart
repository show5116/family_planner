part of 'asset_screen.dart';

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

extension _AssetOnboarding on _AssetScreenState {
  Future<void> _maybeStartOnboarding() async {
    final completed = await OnboardingService.isCoachMarkCompleted(CoachMarkKeys.assets);
    if (completed || !mounted) return;
    setState(() => _isDemo = true);
    _scheduleCoachMark();
  }

  Future<void> _replayOnboarding() async {
    await OnboardingService.resetCoachMark(CoachMarkKeys.assets);
    if (!mounted) return;
    setState(() => _isDemo = true);
    _scheduleCoachMark();
  }

  void _scheduleCoachMark() {
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
    setState(() => _isDemo = false);
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
    debugPrint('🎯 [Coach] _showCoachMark 시작, mounted=$mounted');
    if (!mounted) return;
    final cardPos = _keyToPosition(_demoCardKey);
    final statsPos = _keyToPosition(_statsButtonKey);
    debugPrint('🎯 [Coach] cardPos=$cardPos, statsPos=$statsPos');
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
              description: '계좌명, 금융기관, 최신 잔액과 수익률을\n한눈에 확인할 수 있어요.\n탭하면 잔액 기록과 포트폴리오를 관리할 수 있습니다.',
              icon: Icons.account_balance_outlined,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      if (statsPos != null)
        TargetFocus(
          identify: 'asset_statistics',
          targetPosition: statsPos,
          shape: ShapeLightFocus.Circle,
          radius: 28,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (_, _) => FeatureCoachMark.buildContent(
                title: '자산 통계',
                description: '전체 자산의 합계, 수익률, 유형별 분포를\n차트로 한눈에 확인할 수 있어요.\nKOSPI·S&P500 등 지수와 비교도 가능합니다.',
                icon: Icons.bar_chart,
                color: Colors.indigo,
              ),
            ),
          ],
        ),
    ];
    final activeTargets = targets;
    await FeatureCoachMark.waitForTargets(activeTargets, context);
    if (!mounted) return;

    TutorialCoachMark(
      targets: FeatureCoachMark.refreshPositions(activeTargets),
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
      onClickTarget: (target) {
        if (target.identify == 'asset_card') _goToDemo();
      },
      onFinish: () {
        OnboardingService.completeCoachMark(CoachMarkKeys.assets);
        if (mounted) setState(() => _isDemo = false);
      },
      onSkip: () {
        OnboardingService.completeCoachMark(CoachMarkKeys.assets);
        if (mounted) setState(() => _isDemo = false);
        return true;
      },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
  }
}
