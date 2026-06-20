part of 'todo_tab.dart';

// ── 온보딩용 샘플 할일 데이터 ────────────────────────────────────────────────────

final _todoOnboardingTasks = [
  TaskModel(
    id: '__demo_todo_1__',
    userId: '__demo__',
    title: '장보기 목록 작성',
    description: '이번 주 필요한 식재료 정리',
    status: TaskStatus.pending,
    priority: TaskPriority.medium,
    scheduledAt: DateTime.now(),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  TaskModel(
    id: '__demo_todo_2__',
    userId: '__demo__',
    title: '가족 여행 계획',
    description: '여름 휴가 일정 및 숙소 예약',
    status: TaskStatus.inProgress,
    priority: TaskPriority.high,
    scheduledAt: DateTime.now(),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  TaskModel(
    id: '__demo_todo_3__',
    userId: '__demo__',
    title: '월간 가계부 정리',
    description: '지난달 수입·지출 확인',
    status: TaskStatus.completed,
    priority: TaskPriority.low,
    scheduledAt: DateTime.now(),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
];

// ── 온보딩 로직 ────────────────────────────────────────────────────────────────

extension _TodoOnboarding on _TodoTabState {
  Future<void> _maybeStartOnboarding() async {
    final completed = await OnboardingService.isCoachMarkCompleted(CoachMarkKeys.todo);
    if (completed || !mounted) return;
    _startDemo();
  }

  void _replayOnboarding() {
    OnboardingService.resetCoachMark(CoachMarkKeys.todo).then((_) {
      if (mounted) _startDemo();
    });
  }

  void _startDemo() {
    _onboardingTasks.value = _todoOnboardingTasks;
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

  void _endDemo() {
    _onboardingTasks.value = null;
  }

  TargetPosition? _keyToPosition(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final offset = box.localToGlobal(Offset.zero);
    return TargetPosition(box.size, offset);
  }

  Future<void> _showCoachMark() async {
    if (!mounted) return;
    final weekBarPos = _keyToPosition(_weekBarKey);
    final demoItemPos = _keyToPosition(_demoItemKey);
    final fabPos = _keyToPosition(_fabKey);

    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'todo_week_bar',
        targetPosition: weekBarPos,
        keyTarget: weekBarPos == null ? _weekBarKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '날짜별 할 일',
              description: '날짜를 탭해 해당 날의 할 일을 확인하고\n그룹원과 역할을 나눠 보세요.',
              icon: Icons.date_range,
              color: Colors.green,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'todo_demo_item',
        targetPosition: demoItemPos,
        keyTarget: demoItemPos == null ? _demoItemKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '상태 변경',
              description: '왼쪽 아이콘을 탭하면 할 일의 상태를\n대기 · 진행 중 · 완료 등으로 바꿀 수 있어요.',
              icon: Icons.swap_horiz,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'todo_fab',
        targetPosition: fabPos,
        keyTarget: fabPos == null ? _fabKey : null,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '할 일 추가',
              description: '새로운 할 일을 추가하고\n담당자와 마감일을 지정해보세요.',
              icon: Icons.add_task,
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
      colorShadow: const Color(0xFF212121),
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
      onFinish: () {
        OnboardingService.completeCoachMark(CoachMarkKeys.todo);
        _endDemo();
      },
      onSkip: () {
        OnboardingService.completeCoachMark(CoachMarkKeys.todo);
        _endDemo();
        return true;
      },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
  }
}

// ── 온보딩 전용 리스트 뷰 ────────────────────────────────────────────────────────

class _DemoListView extends StatelessWidget {
  final List<TaskModel> tasks;
  final GlobalKey firstItemKey;
  const _DemoListView({required this.tasks, required this.firstItemKey});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      itemCount: tasks.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSizes.spaceS),
      itemBuilder: (context, index) {
        return TodoListItem(
          key: index == 0 ? firstItemKey : null,
          task: tasks[index],
          onTap: () {},
          onStatusChange: (_) {},
        );
      },
    );
  }
}
