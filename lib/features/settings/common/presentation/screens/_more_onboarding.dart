part of 'more_tab.dart';

extension _MoreOnboarding on _MoreTabState {
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

  TargetPosition? _keyToPosition(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final offset = box.localToGlobal(Offset.zero);
    return TargetPosition(box.size, offset);
  }

  void _replayOnboarding() => _showCoachMark(force: true);

  Future<void> _showCoachMark({bool force = false}) async {
    final groupPos = _keyToPosition(_groupManagementKey);
    final l10n = AppLocalizations.of(context)!;

    await FeatureCoachMark.show(
      context: context,
      featureKey: CoachMarkKeys.more,
      forceShow: force,
      targets: [
        TargetFocus(
          identify: 'more_group',
          targetPosition: groupPos,
          keyTarget: groupPos == null ? _groupManagementKey : null,
          shape: ShapeLightFocus.RRect,
          radius: 8,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (_, _) => FeatureCoachMark.buildContent(
                title: l10n.settings_groupManagementTitle,
                description: l10n.more_coach_groupDesc,
                icon: Icons.group_outlined,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: 'more_settings',
          targetPosition: null,
          keyTarget: _settingsKey,
          shape: ShapeLightFocus.RRect,
          radius: 8,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (_, _) => FeatureCoachMark.buildContent(
                title: l10n.settings_title,
                description: l10n.more_coach_settingsDesc,
                icon: Icons.settings,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
      beforeFocus: (target) async {
        if (target.identify == 'more_settings') {
          final ctx = _settingsKey.currentContext;
          if (ctx != null) {
            await Scrollable.ensureVisible(
              ctx,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              alignment: 0.5,
            );
            await Future.delayed(const Duration(milliseconds: 100));
          }
        }
      },
    );
  }
}
