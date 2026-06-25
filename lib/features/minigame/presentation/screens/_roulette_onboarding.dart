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
              title: '항목 입력',
              description: '룰렛에 올릴 항목을 입력해요.\n비율을 조정하면 당첨 확률을\n다르게 설정할 수 있어요.',
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
              title: '룰렛 원판',
              description: '항목을 2개 이상 입력하면\n룰렛 원판이 나타나요.\n가운데 버튼을 눌러도 돌릴 수 있어요.',
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
              title: '돌리기',
              description: '버튼을 누르면 룰렛이 회전해요.\n결과는 자동으로 그룹 이력에\n저장되어 모두가 확인할 수 있어요.',
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
      textSkip: '건너뛰기',
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

  Widget get _skipWidget => Container(
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
      );
}
