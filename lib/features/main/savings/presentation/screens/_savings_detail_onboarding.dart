part of 'savings_detail_screen.dart';

extension _SavingsDetailOnboarding on _SavingsDetailScreenState {
  TargetPosition? _keyToPosition(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final offset = box.localToGlobal(Offset.zero);
    return TargetPosition(box.size, offset);
  }

  Future<void> _showDemoCoachMark() async {
    if (!mounted) return;
    final headerPos = _keyToPosition(_headerCardKey);
    final depositPos = _keyToPosition(_depositButtonKey);
    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'detail_header',
        targetPosition: headerPos,
        keyTarget: headerPos == null ? _headerCardKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '적립 현황',
              description: '현재 적립금과 목표 금액,\n달성률을 상세하게 확인할 수 있어요.\n자동 적립 중일 때는 적립 상태도 표시돼요.',
              icon: Icons.savings_outlined,
              color: AppColors.investment,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'detail_deposit',
        targetPosition: depositPos,
        keyTarget: depositPos == null ? _depositButtonKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '입금 / 출금',
              description: '언제든지 직접 입금하거나 출금할 수 있어요.\n자동 적립과 함께 활용하면 더욱 편리해요.',
              icon: Icons.swap_vert,
              color: Colors.green,
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
          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
      onFinish: _completeDemoOnboarding,
      onSkip: () {
        _completeDemoOnboarding();
        return true;
      },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
  }

  void _completeDemoOnboarding() {
    OnboardingService.completeCoachMark(CoachMarkKeys.savings);
    if (mounted) Navigator.pop(context);
  }
}
