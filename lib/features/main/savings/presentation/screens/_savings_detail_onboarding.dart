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
    final l10n = AppLocalizations.of(context)!;
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
              title: l10n.coach_savings_status,
              description: l10n.coach_savings_status_desc,
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
              title: l10n.coach_savings_deposit,
              description: l10n.coach_savings_deposit_desc,
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
