part of 'roulette_game_screen.dart';

extension _RouletteGameOnboarding on _RouletteGameScreenState {
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
        CoachMarkKeys.miniGamesRoulette);
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
    final itemsPos = _keyToPosition(_itemsEditorKey);
    final wheelPos = _keyToPosition(_wheelKey);
    final spinPos = _keyToPosition(_spinButtonKey);

    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'roulette_items',
        targetPosition: itemsPos,
        keyTarget: itemsPos == null ? _itemsEditorKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: l10n.coach_roulette_items,
              description: l10n.coach_roulette_items_desc,
              icon: Icons.list_alt_outlined,
              color: Colors.indigo,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'roulette_wheel',
        targetPosition: wheelPos,
        keyTarget: wheelPos == null ? _wheelKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: l10n.coach_roulette_wheel,
              description: l10n.coach_roulette_wheel_desc,
              icon: Icons.circle_outlined,
              color: Colors.orange,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'roulette_spin',
        targetPosition: spinPos,
        keyTarget: spinPos == null ? _spinButtonKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: l10n.coach_roulette_spin,
              description: l10n.coach_roulette_spin_desc,
              icon: Icons.refresh,
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
      alignSkip: Alignment.topRight,
      skipWidget: _skipWidget,
      onFinish: () =>
          OnboardingService.completeCoachMark(CoachMarkKeys.miniGamesRoulette),
      onSkip: () {
        OnboardingService.completeCoachMark(CoachMarkKeys.miniGamesRoulette);
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
