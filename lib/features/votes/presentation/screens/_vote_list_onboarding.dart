part of 'vote_list_screen.dart';

// ─── 샘플 데이터 ───────────────────────────────────────────────────────────────

final _demoNow = DateTime.now();

// 온보딩용 가짜 데이터. 번역이 필요해 최상위 상수로 둘 수 없다.
List<VoteModel> _demoVotes(AppLocalizations l10n) => [
  VoteModel(
    id: '__demo_1__',
    groupId: '__demo__',
    title: l10n.demo_vote_outing,
    description: l10n.demo_vote_outing_desc,
    isMultiple: false,
    isAnonymous: false,
    endsAt: _demoNow.add(const Duration(days: 2)),
    isOngoing: true,
    totalVoters: 3,
    hasVoted: true,
    creatorName: l10n.demo_member_mom,
    createdAt: _demoNow.subtract(const Duration(hours: 5)),
    options: [
      VoteOptionModel(
        id: 'o1',
        label: l10n.demo_place_hangang,
        count: 2,
        isSelected: true,
        voters: [l10n.demo_member_mom, l10n.demo_member_dad],
      ),
      VoteOptionModel(
        id: 'o2',
        label: l10n.demo_place_amusement,
        count: 1,
        isSelected: false,
        voters: [l10n.demo_member_child],
      ),
      VoteOptionModel(
        id: 'o3',
        label: l10n.demo_place_zoo,
        count: 0,
        isSelected: false,
        voters: [],
      ),
    ],
  ),
  VoteModel(
    id: '__demo_2__',
    groupId: '__demo__',
    title: l10n.demo_vote_dinner,
    description: null,
    isMultiple: true,
    isAnonymous: true,
    endsAt: _demoNow.subtract(const Duration(hours: 1)),
    isOngoing: false,
    totalVoters: 4,
    hasVoted: true,
    creatorName: l10n.demo_member_dad,
    createdAt: _demoNow.subtract(const Duration(days: 1)),
    options: [
      VoteOptionModel(
        id: 'o4',
        label: l10n.demo_food_chicken,
        count: 3,
        isSelected: false,
        voters: [],
      ),
      VoteOptionModel(
        id: 'o5',
        label: l10n.demo_food_pizza,
        count: 2,
        isSelected: false,
        voters: [],
      ),
      VoteOptionModel(
        id: 'o6',
        label: l10n.demo_food_pork,
        count: 1,
        isSelected: false,
        voters: [],
      ),
    ],
  ),
];

extension _VoteListOnboarding on _VoteListScreenState {
  Future<void> _maybeStartOnboarding() async {
    final completed = await OnboardingService.isCoachMarkCompleted(
      CoachMarkKeys.votes,
    );
    if (!mounted || completed) return;
    setState(() => _isDemo = true); // ignore: invalid_use_of_protected_member
    _scheduleCoachMark();
  }

  Future<void> _replayOnboarding() async {
    await OnboardingService.resetCoachMark(CoachMarkKeys.votes);
    if (!mounted) return;
    setState(() => _isDemo = true); // ignore: invalid_use_of_protected_member
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
    final l10n = AppLocalizations.of(context)!;
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
              title: l10n.coach_vote_group,
              description:
                  l10n.coach_vote_group_desc,
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
              title: l10n.coach_vote_filter,
              description: l10n.coach_vote_filter_desc,
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
              title: l10n.coach_vote_card,
              description:
                  l10n.coach_vote_card_desc,
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
              title: l10n.coach_vote_create,
              description:
                  l10n.coach_vote_create_desc,
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
      textSkip: l10n.common_skip,
      alignSkip: Alignment.topRight,
      skipWidget: _skipWidget,
      onFinish: () {
        OnboardingService.completeCoachMark(CoachMarkKeys.votes);
        if (mounted) {
          // ignore: invalid_use_of_protected_member
          setState(() => _isDemo = false);
        }
      },
      onSkip: () {
        OnboardingService.completeCoachMark(CoachMarkKeys.votes);
        if (mounted) {
          // ignore: invalid_use_of_protected_member
          setState(() => _isDemo = false);
        }
        return true;
      },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
  }

  Widget get _skipWidget {
    final l10n = AppLocalizations.of(context)!;
    return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white30),
    ),
    child: Text(
      l10n.common_skip,
      style: TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
  }
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
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        // 그룹 선택 바 더미
        AbsorbPointer(
          child: Padding(
            key: groupBarKey,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceM,
              vertical: AppSizes.spaceS,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.group_outlined,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSizes.spaceS),
                Text(l10n.demo_group_family, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_drop_down,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
        // 상태 필터 탭
        AbsorbPointer(
          child: Padding(
            key: filterKey,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceM,
              vertical: AppSizes.spaceS,
            ),
            child: SegmentedButton<int>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(value: 0, label: Text(l10n.qna_statusAll)),
                ButtonSegment(value: 1, label: Text(l10n.vote_status_ongoing)),
                ButtonSegment(value: 2, label: Text(l10n.vote_filter_closed)),
              ],
              selected: const {0},
              onSelectionChanged: (_) {},
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
            ),
          ),
        ),
        // 샘플 투표 카드 목록
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSizes.spaceM),
            itemCount: _demoVotes(l10n).length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSizes.spaceM),
            itemBuilder: (_, index) => _VoteCard(
              key: index == 0 ? firstCardKey : null,
              vote: _demoVotes(l10n)[index],
              isDemo: true,
            ),
          ),
        ),
      ],
    );
  }
}
