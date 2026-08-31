part of 'routine_together_screen.dart';

/// "함께하기" 화면 온보딩.
///
/// 그룹 기능은 목록 화면 온보딩에서 존재만 알리고, 실제 설명은 여기서
/// 한다 — 목록 온보딩에 다 넣으면 단계가 길어져 읽히지 않고, 그룹을 쓰지
/// 않는 사용자에게는 불필요한 설명이 된다.
extension _RoutineTogetherOnboarding on _RoutineTogetherScreenState {
  TargetPosition? _keyToPosition(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final offset = box.localToGlobal(Offset.zero);
    return TargetPosition(box.size, offset);
  }

  Future<void> _maybeShowOnboarding() async {
    final completed = await OnboardingService.isCoachMarkCompleted(
      CoachMarkKeys.routineTogether,
    );
    if (!mounted || completed) return;

    // 그룹 목록이 로드돼야 탭과 본문이 그려진다. 그 전에 코치마크를 띄우면
    // 가리킬 대상이 없어 빈 화면에 설명만 뜬다.
    try {
      await ref.read(myGroupsProvider.future);
    } catch (_) {
      return;
    }
    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _showCoachMark();
    });
  }

  Future<void> _showCoachMark() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    final bodyPos = _keyToPosition(_bodyKey);
    final tabBarPos = _keyToPosition(_tabBarKey);
    final settingsPos = _keyToPosition(_settingsKey);

    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'together_status',
        targetPosition: bodyPos,
        keyTarget: bodyPos == null ? _bodyKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: l10n.routine_together_coach_status_title,
              description: l10n.routine_together_coach_status_desc,
              icon: Icons.groups_outlined,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'together_tabs',
        targetPosition: tabBarPos,
        keyTarget: tabBarPos == null ? _tabBarKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: l10n.routine_together_coach_tabs_title,
              description: l10n.routine_together_coach_tabs_desc,
              icon: Icons.emoji_events_outlined,
              color: AppColors.warning,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'together_settings',
        targetPosition: settingsPos,
        keyTarget: settingsPos == null ? _settingsKey : null,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: l10n.routine_together_coach_settings_title,
              description: l10n.routine_together_coach_settings_desc,
              icon: Icons.settings_outlined,
              color: AppColors.success,
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
      textSkip: l10n.routine_coach_skip,
      alignSkip: Alignment.topRight,
      skipWidget: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceM,
          vertical: AppSizes.spaceS,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppSizes.radiusXLarge),
          border: Border.all(color: Colors.white30),
        ),
        child: Text(
          l10n.routine_coach_skip,
          style: const TextStyle(
            color: Colors.white,
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
    OnboardingService.completeCoachMark(CoachMarkKeys.routineTogether);
  }
}
