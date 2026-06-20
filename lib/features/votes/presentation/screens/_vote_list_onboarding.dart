part of 'vote_list_screen.dart';

// ─── 샘플 데이터 ───────────────────────────────────────────────────────────────

final _demoNow = DateTime.now();

final _demoVotes = [
  VoteModel(
    id: '__demo_1__',
    groupId: '__demo__',
    title: '이번 주말 가족 나들이 장소',
    description: '다수결로 결정해요! 의견을 남겨주세요.',
    isMultiple: false,
    isAnonymous: false,
    endsAt: _demoNow.add(const Duration(days: 2)),
    isOngoing: true,
    totalVoters: 3,
    hasVoted: true,
    creatorName: '엄마',
    createdAt: _demoNow.subtract(const Duration(hours: 5)),
    options: [
      const VoteOptionModel(id: 'o1', label: '한강공원', count: 2, isSelected: true, voters: ['엄마', '아빠']),
      const VoteOptionModel(id: 'o2', label: '놀이동산', count: 1, isSelected: false, voters: ['민준']),
      const VoteOptionModel(id: 'o3', label: '동물원', count: 0, isSelected: false, voters: []),
    ],
  ),
  VoteModel(
    id: '__demo_2__',
    groupId: '__demo__',
    title: '저녁 메뉴 결정',
    description: null,
    isMultiple: true,
    isAnonymous: true,
    endsAt: _demoNow.subtract(const Duration(hours: 1)),
    isOngoing: false,
    totalVoters: 4,
    hasVoted: true,
    creatorName: '아빠',
    createdAt: _demoNow.subtract(const Duration(days: 1)),
    options: [
      const VoteOptionModel(id: 'o4', label: '치킨', count: 3, isSelected: false, voters: []),
      const VoteOptionModel(id: 'o5', label: '피자', count: 2, isSelected: false, voters: []),
      const VoteOptionModel(id: 'o6', label: '삼겹살', count: 1, isSelected: false, voters: []),
    ],
  ),
];

extension _VoteListOnboarding on _VoteListScreenState {
  Future<void> _maybeStartOnboarding() async {
    final completed =
        await OnboardingService.isCoachMarkCompleted(CoachMarkKeys.votes);
    if (!mounted || completed) return;
    setState(() => _isDemo = true);
    _scheduleCoachMark();
  }

  Future<void> _replayOnboarding() async {
    await OnboardingService.resetCoachMark(CoachMarkKeys.votes);
    if (!mounted) return;
    setState(() => _isDemo = true);
    _scheduleCoachMark();
  }

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

  Future<void> _showCoachMark() async {
    if (!mounted) return;

    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'vote_group',
        keyTarget: _groupDropdownKey,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '그룹 선택',
              description: '투표는 그룹 단위로 진행돼요.\n그룹을 선택하면 해당 그룹의\n투표 목록을 확인할 수 있어요.',
              icon: Icons.group_outlined,
              color: Colors.teal,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'vote_filter',
        keyTarget: _filterKey,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '상태 필터',
              description: '전체, 진행중, 종료된 투표를\n탭으로 쉽게 구분해서 볼 수 있어요.',
              icon: Icons.filter_list,
              color: Colors.indigo,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'vote_card',
        keyTarget: _firstCardKey,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '투표 카드',
              description: '카드를 탭하면 선택지에 투표할 수 있어요.\n그룹 멤버 모두가 참여할 수 있고\n결과는 실시간으로 확인할 수 있어요.',
              icon: Icons.how_to_vote_outlined,
              color: Colors.orange,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'vote_fab',
        keyTarget: _fabKey,
        shape: ShapeLightFocus.RRect,
        radius: 16,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '새 투표 만들기',
              description: '+ 버튼을 눌러 새 투표를 만들어보세요.\n단일/복수 선택, 익명 투표,\n마감 시각 설정도 지원해요.',
              icon: Icons.add_circle_outline,
              color: Colors.purple,
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
      skipWidget: _skipWidget,
      onFinish: () {
        OnboardingService.completeCoachMark(CoachMarkKeys.votes);
        if (mounted) setState(() => _isDemo = false);
      },
      onSkip: () {
        OnboardingService.completeCoachMark(CoachMarkKeys.votes);
        if (mounted) setState(() => _isDemo = false);
        return true;
      },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
  }

  Widget get _skipWidget => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white30),
        ),
        child: const Text(
          '건너뛰기',
          style: TextStyle(
              color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      );
}

// ─── 온보딩 전용 뷰 ───────────────────────────────────────────────────────────

class _DemoVoteBody extends StatelessWidget {
  final GlobalKey groupBarKey;
  final GlobalKey filterKey;
  final GlobalKey firstCardKey;

  const _DemoVoteBody({
    required this.groupBarKey,
    required this.filterKey,
    required this.firstCardKey,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        // 그룹 선택 바 더미
        AbsorbPointer(
          child: Padding(
            key: groupBarKey,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceM, vertical: AppSizes.spaceS),
            child: Row(
              children: [
                Icon(Icons.group_outlined,
                    size: 18, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: AppSizes.spaceS),
                Text('우리 가족',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(width: 4),
                Icon(Icons.arrow_drop_down,
                    color: colorScheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
        // 상태 필터 탭
        AbsorbPointer(
          child: Padding(
            key: filterKey,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceM, vertical: AppSizes.spaceS),
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('전체')),
                ButtonSegment(value: 1, label: Text('진행중')),
                ButtonSegment(value: 2, label: Text('종료됨')),
              ],
              selected: const {0},
              onSelectionChanged: (_) {},
              style: const ButtonStyle(
                  visualDensity: VisualDensity.compact),
            ),
          ),
        ),
        // 샘플 투표 카드 목록
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSizes.spaceM),
            itemCount: _demoVotes.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppSizes.spaceM),
            itemBuilder: (_, index) => _VoteCard(
              key: index == 0 ? firstCardKey : null,
              vote: _demoVotes[index],
              isDemo: true,
            ),
          ),
        ),
      ],
    );
  }
}
