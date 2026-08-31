part of 'routine_list_screen.dart';

// ── 온보딩용 샘플 데이터 ─────────────────────────────────────────────────────
//
// 신규 사용자는 습관이 하나도 없어서 코치마크가 가리킬 대상이 없다. 온보딩
// 동안만 가짜 습관과 진행 바를 띄워, 실제로 쓰게 될 화면 위에서 설명한다.

DateTime _demoDate() => DateTime(2026, 1, 1);

/// 온보딩 예시 습관. 실제 [RoutineListItem]에 그대로 넣어 렌더링하므로
/// 진짜 화면과 생김새가 같다.
Routine _demoRoutine({
  required String id,
  required String title,
  required String emoji,
  required bool checkedToday,
  required bool includeInDailyGoal,
}) {
  final now = _demoDate();
  return Routine(
    id: id,
    title: title,
    emoji: emoji,
    importance: RoutineImportance.medium,
    recordType: RoutineRecordType.boolean_,
    status: RoutineStatus.active,
    frequencyType: RoutineFrequencyType.daily,
    startDate: now,
    sortOrder: 0,
    checkedToday: checkedToday,
    includeInDailyGoal: includeInDailyGoal,
    createdAt: now,
    updatedAt: now,
  );
}

/// 예시 진행 바 데이터. 습관 3개 중 2개가 목표에 포함되고 그중 1개를
/// 체크한 상태 — "전부 안 해도 된다"는 개념이 한눈에 보이는 구성.
RoutineDailyStreak _demoStreak() => const RoutineDailyStreak(
  currentStreakDays: 3,
  longestStreakDays: 12,
  todayAchieved: false,
  todayCheckedCount: 1,
  todayTargetCount: 2,
  recent14Days: RoutineRecent14Days(
    achievedDays: 0,
    exceededDays: 0,
    totalDays: 0,
    averageCheckedCount: 0,
  ),
);

// ── 온보딩 로직 ──────────────────────────────────────────────────────────────

extension _RoutineListOnboarding on _RoutineListScreenState {
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
      CoachMarkKeys.routines,
    );
    if (!mounted || completed) return;
    _startDemo();
  }

  /// 데모 화면을 띄운 뒤 코치마크를 시작한다. 화면 전환 애니메이션이
  /// 끝나야 위젯 위치가 확정되므로 그때까지 기다린다.
  void _startDemo() {
    if (!mounted) return;
    _showOnboardingDemo.value = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final animation = ModalRoute.of(context)?.animation;
      if (animation == null || animation.isCompleted) {
        _showCoachMark();
        return;
      }
      void listener(AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          animation.removeStatusListener(listener);
          if (mounted) _showCoachMark();
        }
      }

      animation.addStatusListener(listener);
    });
  }

  Future<void> _showCoachMark() async {
    if (!mounted) return;
    // 다시보기로 진입했을 때도 데모가 떠 있어야 가리킬 대상이 생긴다.
    if (!_showOnboardingDemo.value) {
      _startDemo();
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final addPos = _keyToPosition(_addButtonKey);
    final goalBarPos = _keyToPosition(_goalBarKey);
    final flagPos = _keyToPosition(_demoFlagKey);
    final checkPos = _keyToPosition(_demoCheckKey);
    final moreMenuPos = _keyToPosition(_moreMenuKey);

    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'routine_add_button',
        targetPosition: addPos,
        keyTarget: addPos == null ? _addButtonKey : null,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: l10n.routine_coach_add_title,
              description: l10n.routine_coach_add_desc,
              icon: Icons.add_circle_outline,
              color: AppColors.warning,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'routine_goal_bar',
        targetPosition: goalBarPos,
        keyTarget: goalBarPos == null ? _goalBarKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: l10n.routine_coach_goal_title,
              description: l10n.routine_coach_goal_desc,
              icon: Icons.flag_outlined,
              color: AppColors.success,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'routine_goal_flag',
        targetPosition: flagPos,
        keyTarget: flagPos == null ? _demoFlagKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: l10n.routine_coach_flag_title,
              description: l10n.routine_coach_flag_desc,
              icon: Icons.flag,
              color: AppColors.success,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'routine_check',
        targetPosition: checkPos,
        keyTarget: checkPos == null ? _demoCheckKey : null,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: l10n.routine_coach_check_title,
              description: l10n.routine_coach_check_desc,
              icon: Icons.check_circle_outline,
              color: AppColors.warning,
            ),
          ),
        ],
      ),
      // 그룹 기능이 있다는 것만 알리고, 자세한 설명은 "함께하기" 화면에
      // 들어갔을 때 그 자리에서 한다(여기서 다 설명하면 단계가 길어져
      // 아무도 읽지 않는다).
      TargetFocus(
        identify: 'routine_together_menu',
        targetPosition: moreMenuPos,
        keyTarget: moreMenuPos == null ? _moreMenuKey : null,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: l10n.routine_coach_together_title,
              description: l10n.routine_coach_together_desc,
              icon: Icons.groups_outlined,
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
    OnboardingService.completeCoachMark(CoachMarkKeys.routines);
    _showOnboardingDemo.value = false;
  }
}

/// 온보딩 동안만 보여주는 예시 목록. 실제 화면과 같은 위젯을 쓰되
/// 데이터만 가짜이고, 모든 조작은 막혀 있다.
class _OnboardingRoutineDemo extends StatelessWidget {
  const _OnboardingRoutineDemo({
    required this.goalBarKey,
    required this.flagKey,
    required this.checkKey,
  });

  final GlobalKey goalBarKey;
  final GlobalKey flagKey;
  final GlobalKey checkKey;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final demoRoutines = [
      _demoRoutine(
        id: '__demo_1__',
        title: l10n.routine_coach_demo_habit_1,
        emoji: '🏃',
        checkedToday: true,
        includeInDailyGoal: true,
      ),
      _demoRoutine(
        id: '__demo_2__',
        title: l10n.routine_coach_demo_habit_2,
        emoji: '💧',
        checkedToday: false,
        includeInDailyGoal: true,
      ),
      _demoRoutine(
        id: '__demo_3__',
        title: l10n.routine_coach_demo_habit_3,
        emoji: '📖',
        checkedToday: false,
        includeInDailyGoal: false,
      ),
    ];

    return Column(
      children: [
        // 코치마크가 가리킬 수 있도록 진행 바에 키를 붙인다.
        KeyedSubtree(
          key: goalBarKey,
          child: RoutineDailyGoalBar(streak: _demoStreak()),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: AppSizes.spaceXXL),
            children: [
              buildRoutineTableHeader(context),
              for (var i = 0; i < demoRoutines.length; i++)
                // 두 번째 습관(미체크 + 목표 포함)에 깃발/체크 키를 붙인다.
                // 첫 습관은 이미 체크된 상태라 체크 버튼 설명에 맞지 않는다.
                _DemoRoutineRow(
                  routine: demoRoutines[i],
                  rowNumber: i + 1,
                  flagKey: i == 1 ? flagKey : null,
                  checkKey: i == 1 ? checkKey : null,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 예시 습관 한 행. 실제 [RoutineListItem]을 쓰되 조작은 무시한다.
class _DemoRoutineRow extends StatelessWidget {
  const _DemoRoutineRow({
    required this.routine,
    required this.rowNumber,
    this.flagKey,
    this.checkKey,
  });

  final Routine routine;
  final int rowNumber;
  final GlobalKey? flagKey;
  final GlobalKey? checkKey;

  @override
  Widget build(BuildContext context) {
    final item = RoutineListItem(
      routine: routine,
      rowNumber: rowNumber,
      onTap: () {},
      onToggleCheck: ({textValue, numericValue, timeValue}) async {},
    );

    // 코치마크는 행 전체를 비추되, 설명에서 깃발/체크를 짚어준다.
    // 개별 아이콘에 키를 심으려면 RoutineListItem을 온보딩 전용으로
    // 열어야 해서, 실제 위젯을 그대로 쓰는 이점을 잃는다.
    if (flagKey != null) {
      return KeyedSubtree(
        key: flagKey,
        child: checkKey != null
            ? KeyedSubtree(key: checkKey, child: item)
            : item,
      );
    }
    return item;
  }
}
