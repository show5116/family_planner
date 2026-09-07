part of 'diary_timeline_screen.dart';

/// 다이어리 첫 진입 코치마크
///
/// 이 기능은 "빠른 기록"을 모르면 그냥 흔한 일기 앱으로 보인다.
/// 그래서 입력창 → 카드 → 회고 순서로, **왜 이렇게 생겼는지**를 먼저 설명한다.
extension _DiaryOnboarding on _DiaryTimelineScreenState {
  Future<void> _maybeStartOnboarding() async {
    final completed =
        await OnboardingService.isCoachMarkCompleted(CoachMarkKeys.diary);
    if (!mounted || completed) return;
    _showCoachMark();
  }

  Future<void> _showCoachMark({bool forceShow = false}) async {
    if (!mounted) return;

    // 화면 전환 애니메이션이 끝난 뒤에 좌표를 잡아야 타겟 위치가 어긋나지 않는다
    final animation = ModalRoute.of(context)?.animation;
    if (animation != null && !animation.isCompleted) {
      final completer = Completer<void>();
      void listener(AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          animation.removeStatusListener(listener);
          if (!completer.isCompleted) completer.complete();
        }
      }

      animation.addStatusListener(listener);
      await completer.future;
      if (!mounted) return;
    }

    final l10n = AppLocalizations.of(context)!;

    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'diary_capture',
        keyTarget: _captureBarKey,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: l10n.diary_onboarding_capture_title,
              description: l10n.diary_onboarding_capture_desc,
              icon: Icons.edit_outlined,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      // 카드가 아직 없을 수도 있다(첫 사용자). 그 경우 이 단계는 건너뛴다.
      if (_firstCardKey.currentContext != null)
        TargetFocus(
          identify: 'diary_card',
          keyTarget: _firstCardKey,
          shape: ShapeLightFocus.RRect,
          radius: 12,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (_, _) => FeatureCoachMark.buildContent(
                title: l10n.diary_onboarding_card_title,
                description: l10n.diary_onboarding_card_desc,
                icon: Icons.auto_stories_outlined,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      if (_flashbackKey.currentContext != null)
        TargetFocus(
          identify: 'diary_flashback',
          keyTarget: _flashbackKey,
          shape: ShapeLightFocus.RRect,
          radius: 12,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (_, _) => FeatureCoachMark.buildContent(
                title: l10n.diary_onboarding_flashback_title,
                description: l10n.diary_onboarding_flashback_desc,
                icon: Icons.history,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
    ];

    await FeatureCoachMark.show(
      context: context,
      featureKey: CoachMarkKeys.diary,
      targets: targets,
      forceShow: forceShow,
    );
  }
}
