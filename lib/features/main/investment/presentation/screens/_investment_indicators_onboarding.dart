part of 'investment_indicators_screen.dart';

extension _InvestmentIndicatorsOnboarding on _InvestmentIndicatorsScreenState {
  TargetPosition? _keyToPosition(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final offset = box.localToGlobal(Offset.zero);
    return TargetPosition(box.size, offset);
  }

  Future<void> _maybeShowCoachMark() async {
    final completed = await OnboardingService.isCoachMarkCompleted(
        CoachMarkKeys.investmentIndicators);
    if (!mounted || completed) return;
    _coachMarkScheduled = true;
  }

  void _tryStartCoachMarkAfterLoad({required bool briefingReady}) {
    if (!_coachMarkScheduled || _coachMarkStarted || !briefingReady) return;
    _coachMarkScheduled = false;
    _coachMarkStarted = true;
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

  Future<void> _showCoachMark() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    final tilePos = _keyToPosition(_firstTileKey);
    final bookmarkPos = _keyToPosition(_bookmarkKey);

    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'indicator_list',
        targetPosition: tilePos,
        keyTarget: tilePos == null ? _firstTileKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: l10n.investment_coachIndicatorTitle,
              description: l10n.investment_coachIndicatorDesc,
              icon: Icons.show_chart,
              color: AppColors.investment,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'indicator_bookmark',
        targetPosition: bookmarkPos,
        keyTarget: bookmarkPos == null ? _bookmarkKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: l10n.investment_coachBookmarkTitle,
              description: l10n.investment_coachBookmarkDesc,
              icon: Icons.star_outline,
              color: Colors.amber,
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
      textSkip: l10n.fridge_frequent_coach_skip,
      alignSkip: Alignment.topRight,
      skipWidget: _buildSkipWidget(l10n),
      onFinish: () => OnboardingService.completeCoachMark(
          CoachMarkKeys.investmentIndicators),
      onSkip: () {
        OnboardingService.completeCoachMark(CoachMarkKeys.investmentIndicators);
        return true;
      },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
  }

  Widget _buildSkipWidget(AppLocalizations l10n) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white30),
        ),
        child: Text(
          l10n.fridge_frequent_coach_skip,
          style: const TextStyle(
              color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      );
}
