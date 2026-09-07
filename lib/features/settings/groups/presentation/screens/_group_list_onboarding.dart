part of 'group_list_screen.dart';

extension _GroupListOnboarding on _GroupListScreenState {
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
    final l10n = AppLocalizations.of(context)!;
    final createFabPos = _keyToPosition(_createFabKey);
    final joinFabPos = _keyToPosition(_joinFabKey);
    final myRequestsPos = _keyToPosition(_myRequestsKey);

    await FeatureCoachMark.show(
      context: context,
      featureKey: CoachMarkKeys.groupManagement,
      forceShow: force,
      alignSkip: Alignment.bottomLeft,
      targets: [
        TargetFocus(
          identify: 'group_create_fab',
          targetPosition: createFabPos,
          keyTarget: createFabPos == null ? _createFabKey : null,
          shape: ShapeLightFocus.RRect,
          radius: 28,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (_, _) => FeatureCoachMark.buildContent(
                title: l10n.coach_group_create,
                description: l10n.coach_group_create_desc,
                icon: Icons.group_add,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: 'group_join_fab',
          targetPosition: joinFabPos,
          keyTarget: joinFabPos == null ? _joinFabKey : null,
          shape: ShapeLightFocus.RRect,
          radius: 28,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (_, _) => FeatureCoachMark.buildContent(
                title: l10n.coach_group_join,
                description: l10n.coach_group_join_desc,
                icon: Icons.login,
                color: Colors.green,
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: 'group_my_requests',
          targetPosition: myRequestsPos,
          keyTarget: myRequestsPos == null ? _myRequestsKey : null,
          shape: ShapeLightFocus.Circle,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (_, _) => FeatureCoachMark.buildContent(
                title: l10n.coach_group_requests,
                description: l10n.coach_group_requests_desc,
                icon: Icons.assignment_outlined,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
