part of 'todo_tab.dart';

// ── 온보딩용 샘플 할일 데이터 ────────────────────────────────────────────────────

// 온보딩용 가짜 데이터. 번역이 필요해 최상위 상수로 둘 수 없다.
List<TaskModel> _todoOnboardingTasks(AppLocalizations l10n) => [
  TaskModel(
    id: '__demo_todo_1__',
    userId: '__demo__',
    title: l10n.demo_todo_shopping,
    description: l10n.demo_todo_shopping_desc,
    status: TaskStatus.pending,
    priority: TaskPriority.medium,
    scheduledAt: DateTime.now(),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  TaskModel(
    id: '__demo_todo_2__',
    userId: '__demo__',
    title: l10n.demo_todo_trip,
    description: l10n.demo_todo_trip_desc,
    status: TaskStatus.inProgress,
    priority: TaskPriority.high,
    scheduledAt: DateTime.now(),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  TaskModel(
    id: '__demo_todo_3__',
    userId: '__demo__',
    title: l10n.demo_todo_budget,
    description: l10n.demo_todo_budget_desc,
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
    _onboardingTasks.value =
        _todoOnboardingTasks(AppLocalizations.of(context)!);
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
    final l10n = AppLocalizations.of(context)!;
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
              title: l10n.coach_todo_byDate,
              description: l10n.coach_todo_byDate_desc,
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
              title: l10n.coach_todo_status,
              description: l10n.coach_todo_status_desc,
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
              title: l10n.coach_todo_add,
              description: l10n.coach_todo_add_desc,
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
