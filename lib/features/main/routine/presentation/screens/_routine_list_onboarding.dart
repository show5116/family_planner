part of 'routine_list_screen.dart';

extension _RoutineListOnboarding on _RoutineListScreenState {
  TargetPosition? _keyToPosition(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final offset = box.localToGlobal(Offset.zero);
    return TargetPosition(box.size, offset);
  }

  Future<void> _maybeShowOnboarding() async {
    final completed =
        await OnboardingService.isCoachMarkCompleted(CoachMarkKeys.routines);
    if (!mounted || completed) return;
    _showCoachMark();
  }

  Future<void> _showCoachMark() async {
    if (!mounted) return;
    final addButtonPos = _keyToPosition(_addButtonKey);
    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'routine_add_button',
        targetPosition: addButtonPos,
        keyTarget: addButtonPos == null ? _addButtonKey : null,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '습관/루틴 만들기',
              description:
                  '매일 반복하고 싶은 습관을 등록해보세요.\n여러 습관을 묶어 루틴으로 만들 수도 있어요.\n체크할 때마다 스트릭이 쌓이고\n배지도 획득할 수 있어요.',
              icon: Icons.add_circle_outline,
              color: AppColors.warning,
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
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
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
    OnboardingService.completeCoachMark(CoachMarkKeys.routines);
  }
}
