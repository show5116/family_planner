part of 'calendar_tab.dart';

extension _CalendarOnboarding on _CalendarTabState {
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

  void _replayOnboarding() => _showCoachMark(force: true);

  TargetPosition? _keyToPosition(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final offset = box.localToGlobal(Offset.zero);
    return TargetPosition(box.size, offset);
  }

  Future<void> _showCoachMark({bool force = false}) async {
    final calendarPos = _keyToPosition(_calendarKey);
    final fabPos = _keyToPosition(_fabKey);

    await FeatureCoachMark.show(
      context: context,
      featureKey: CoachMarkKeys.calendar,
      forceShow: force,
      onClickTarget: (target) {
        if (!mounted) return;
        if (target.identify == 'calendar_fab') {
          final selectedDate = ref.read(selectedDateProvider);
          context.push('/calendar/add', extra: {'date': selectedDate, 'isOnboarding': true});
        }
      },
      targets: [
        TargetFocus(
          identify: 'calendar_view',
          targetPosition: calendarPos,
          keyTarget: calendarPos == null ? _calendarKey : null,
          shape: ShapeLightFocus.RRect,
          radius: 8,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (_, _) => FeatureCoachMark.buildContent(
                title: '공유 캘린더',
                description: '그룹 구성원의 일정을 한눈에 볼 수 있어요.\n날짜를 탭해 해당 날의 일정을 확인하세요.',
                icon: Icons.calendar_month,
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: 'calendar_fab',
          targetPosition: fabPos,
          keyTarget: fabPos == null ? _fabKey : null,
          shape: ShapeLightFocus.Circle,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (_, _) => FeatureCoachMark.buildContent(
                title: '일정 추가',
                description: '버튼을 눌러 새 일정을 만드세요.\n눌러서 생성 화면을 살펴보세요.',
                icon: Icons.add,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
