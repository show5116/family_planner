part of 'asset_screen.dart';

// 온보딩용 가짜 계좌 데이터. 번역이 필요해 최상위 상수로 둘 수 없다.
AccountModel _demoAccount(AppLocalizations l10n) => AccountModel(
  id: '__demo_asset__',
  groupId: '__demo__',
  userId: '__demo__',
  name: l10n.demo_bank_savings,
  accountNumber: '****-****-1234',
  institution: l10n.demo_bank_kb,
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
    setState(() => _isDemo = true); // ignore: invalid_use_of_protected_member
    _scheduleCoachMark();
  }

  Future<void> _replayOnboarding() async {
    await OnboardingService.resetCoachMark(CoachMarkKeys.assets);
    if (!mounted) return;
    setState(() => _isDemo = true); // ignore: invalid_use_of_protected_member
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
    final l10n = AppLocalizations.of(context)!;
    if (!mounted) return;
    setState(() => _isDemo = false); // ignore: invalid_use_of_protected_member
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AccountDetailScreen(
          account: _demoAccount(l10n),
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
    final l10n = AppLocalizations.of(context)!;
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
              title: l10n.coach_asset_card,
              description: l10n.coach_asset_card_desc,
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
                title: l10n.coach_asset_stats,
                description: l10n.coach_asset_stats_desc,
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
      textSkip: l10n.common_skip,
      alignSkip: Alignment.topRight,
      skipWidget: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white30),
        ),
        child: Text(
          l10n.common_skip,
          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
      onClickTarget: (target) {
        if (target.identify == 'asset_card') _goToDemo();
      },
      onFinish: () {
        OnboardingService.completeCoachMark(CoachMarkKeys.assets);
        if (mounted) setState(() => _isDemo = false); // ignore: invalid_use_of_protected_member
      },
      onSkip: () {
        OnboardingService.completeCoachMark(CoachMarkKeys.assets);
        if (mounted) setState(() => _isDemo = false); // ignore: invalid_use_of_protected_member
        return true;
      },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
  }
}
