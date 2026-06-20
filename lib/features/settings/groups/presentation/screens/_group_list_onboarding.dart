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
                title: '그룹 만들기',
                description: '가족, 연인, 친구, 팀 등\n원하는 그룹을 직접 만들어 보세요.',
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
                title: '그룹 참여하기',
                description: '초대 코드를 입력해 기존 그룹에 합류하세요.\n그룹원이 공유한 코드를 사용하면 돼요.',
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
                title: '신청 내역',
                description: '내가 참여 신청한 그룹 목록을 확인하고\n수락 여부를 여기서 확인할 수 있어요.',
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
