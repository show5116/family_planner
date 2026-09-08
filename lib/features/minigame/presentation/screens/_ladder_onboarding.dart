part of 'ladder_game_screen.dart';

extension _LadderGameOnboarding on _LadderGameScreenState {
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
        CoachMarkKeys.miniGamesLadder);
    if (!mounted || completed) return;
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
  }

  Future<void> _showCoachMark() async {
    final l10n = AppLocalizations.of(context)!;
    if (!mounted) return;
    final participantsPos = _keyToPosition(_participantsKey);
    final optionsPos = _keyToPosition(_optionsKey);
    final startPos = _keyToPosition(_startButtonKey);

    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'ladder_participants',
        targetPosition: participantsPos,
        keyTarget: participantsPos == null ? _participantsKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: l10n.coach_ladder_participants,
              description: l10n.coach_ladder_participants_desc,
              icon: Icons.people_outline,
              color: Colors.indigo,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'ladder_options',
        targetPosition: optionsPos,
        keyTarget: optionsPos == null ? _optionsKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: l10n.coach_ladder_results,
              description: l10n.coach_ladder_results_desc,
              icon: Icons.list_alt_outlined,
              color: Colors.teal,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'ladder_start',
        targetPosition: startPos,
        keyTarget: startPos == null ? _startButtonKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: l10n.coach_ladder_create,
              description: l10n.coach_ladder_create_desc,
              icon: Icons.play_arrow,
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
      alignSkip: Alignment.topRight,
      skipWidget: _skipWidget,
      onFinish: () =>
          OnboardingService.completeCoachMark(CoachMarkKeys.miniGamesLadder),
      onSkip: () {
        OnboardingService.completeCoachMark(CoachMarkKeys.miniGamesLadder);
        return true;
      },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
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
          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      );
  }
}
