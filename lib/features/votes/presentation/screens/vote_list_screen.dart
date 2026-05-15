import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/onboarding/presentation/widgets/feature_coach_mark.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/features/settings/groups/providers/default_group_provider.dart';
import 'package:family_planner/shared/widgets/group_filter_bar.dart';
import 'package:family_planner/features/votes/data/models/vote_model.dart';
import 'package:family_planner/features/votes/providers/vote_list_provider.dart';
import 'package:family_planner/shared/widgets/app_bar_more_menu.dart';
import 'package:family_planner/shared/widgets/app_empty_state.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';

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

// ─── 화면 ──────────────────────────────────────────────────────────────────────

class VoteListScreen extends ConsumerStatefulWidget {
  const VoteListScreen({super.key});

  @override
  ConsumerState<VoteListScreen> createState() => _VoteListScreenState();
}

class _VoteListScreenState extends ConsumerState<VoteListScreen> {
  bool _isDemo = false;

  final _groupDropdownKey = GlobalKey();
  final _filterKey = GlobalKey();
  final _firstCardKey = GlobalKey();
  final _fabKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initGroupSelection();
      _maybeStartOnboarding();
    });
  }

  Future<void> _initGroupSelection() async {
    if (ref.read(voteSelectedGroupIdProvider) != null) return;
    final defaultId = ref.read(defaultGroupProvider);
    final groups = ref.read(myGroupsProvider).valueOrNull ?? [];
    if (groups.isEmpty || !mounted) return;
    final resolved = (defaultId != null && groups.any((g) => g.id == defaultId))
        ? defaultId
        : groups.first.id;
    ref.read(voteSelectedGroupIdProvider.notifier).state = resolved;
  }

  // ── 튜토리얼 ────────────────────────────────────────────────────────────────

  TargetPosition? _keyToPosition(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final offset = box.localToGlobal(Offset.zero);
    return TargetPosition(box.size, offset);
  }

  Future<void> _maybeStartOnboarding() async {
    final completed =
        await OnboardingService.isCoachMarkCompleted(CoachMarkKeys.votes);
    if (!mounted || completed) return;
    setState(() => _isDemo = true);
    WidgetsBinding.instance.addPostFrameCallback((_) => _showCoachMark());
  }

  Future<void> _replayOnboarding() async {
    await OnboardingService.resetCoachMark(CoachMarkKeys.votes);
    if (!mounted) return;
    setState(() => _isDemo = true);
    WidgetsBinding.instance.addPostFrameCallback((_) => _showCoachMark());
  }

  Future<void> _showCoachMark() async {
    if (!mounted) return;

    final groupPos = _keyToPosition(_groupDropdownKey);
    final filterPos = _keyToPosition(_filterKey);
    final cardPos = _keyToPosition(_firstCardKey);
    final fabPos = _keyToPosition(_fabKey);

    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'vote_group',
        targetPosition: groupPos,
        keyTarget: groupPos == null ? _groupDropdownKey : null,
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
        targetPosition: filterPos,
        keyTarget: filterPos == null ? _filterKey : null,
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
        targetPosition: cardPos,
        keyTarget: cardPos == null ? _firstCardKey : null,
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
        targetPosition: fabPos,
        keyTarget: fabPos == null ? _fabKey : null,
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
      targets: targets,
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

  // ── 빌드 ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final selectedGroupId = ref.watch(voteSelectedGroupIdProvider);
    final statusFilter = ref.watch(voteStatusFilterProvider);
    final votesAsync = ref.watch(voteListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('투표'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          AppBarMoreMenu(
            onReplayOnboarding: _replayOnboarding,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: _fabKey,
        onPressed: _isDemo ? null : () => context.push(AppRoutes.voteCreate),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // 그룹 선택
          if (!_isDemo)
            GroupFilterBar(
              key: _groupDropdownKey,
              selectedGroupId: selectedGroupId,
              onChanged: (value) {
                ref.read(voteSelectedGroupIdProvider.notifier).state = value;
              },
            ),
          // 상태 필터 탭
          if (selectedGroupId != null || _isDemo)
            Padding(
              key: _filterKey,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceM, vertical: AppSizes.spaceS),
              child: SegmentedButton<VoteStatusFilter>(
                segments: const [
                  ButtonSegment(
                      value: VoteStatusFilter.all, label: Text('전체')),
                  ButtonSegment(
                      value: VoteStatusFilter.ongoing, label: Text('진행중')),
                  ButtonSegment(
                      value: VoteStatusFilter.closed, label: Text('종료됨')),
                ],
                selected: {statusFilter},
                onSelectionChanged: _isDemo
                    ? null
                    : (val) {
                        ref.read(voteStatusFilterProvider.notifier).state =
                            val.first;
                      },
                style: const ButtonStyle(
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
          // 목록
          Expanded(
            child: _isDemo
                ? _buildDemoList()
                : selectedGroupId == null
                    ? const AppEmptyState(
                        icon: Icons.group_outlined,
                        message: '그룹을 선택하면 투표 목록이 표시됩니다',
                      )
                    : RefreshIndicator(
                        onRefresh: () =>
                            ref.read(voteListProvider.notifier).refresh(),
                        child: votesAsync.when(
                          data: (votes) {
                            if (votes.isEmpty) {
                              return const AppEmptyState(
                                icon: Icons.how_to_vote_outlined,
                                message: '아직 투표가 없습니다\n+ 버튼으로 새 투표를 만들어보세요',
                              );
                            }
                            return ListView.separated(
                              padding:
                                  const EdgeInsets.all(AppSizes.spaceM),
                              itemCount: votes.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: AppSizes.spaceM),
                              itemBuilder: (_, index) =>
                                  _VoteCard(vote: votes[index]),
                            );
                          },
                          loading: () => const Center(
                              child: CircularProgressIndicator()),
                          error: (e, _) => AppErrorState(
                            error: e,
                            title: '투표 목록을 불러오지 못했습니다',
                            onRetry: () =>
                                ref.read(voteListProvider.notifier).refresh(),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoList() {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      itemCount: _demoVotes.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSizes.spaceM),
      itemBuilder: (_, index) => _VoteCard(
        key: index == 0 ? _firstCardKey : null,
        vote: _demoVotes[index],
        isDemo: true,
      ),
    );
  }
}

// ─── 투표 카드 ────────────────────────────────────────────────────────────────

class _VoteCard extends StatelessWidget {
  final VoteModel vote;
  final bool isDemo;

  const _VoteCard({super.key, required this.vote, this.isDemo = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: isDemo
            ? null
            : () => context.push(
                  AppRoutes.voteDetail
                      .replaceFirst(':groupId', vote.groupId)
                      .replaceFirst(':voteId', vote.id),
                ),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      vote.title,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSizes.spaceS),
                  _StatusBadge(isOngoing: vote.isOngoing),
                ],
              ),
              if (vote.description != null && vote.description!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  vote.description!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: AppSizes.spaceS),
              Row(
                children: [
                  Icon(Icons.person_outline,
                      size: 14, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    vote.creatorName,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(width: AppSizes.spaceM),
                  Icon(Icons.how_to_vote_outlined,
                      size: 14, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    '${vote.totalVoters}명 참여',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                  if (vote.hasVoted) ...[
                    const SizedBox(width: AppSizes.spaceM),
                    Icon(Icons.check_circle_outline,
                        size: 14, color: colorScheme.primary),
                    const SizedBox(width: 4),
                    Text(
                      '참여함',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: colorScheme.primary),
                    ),
                  ],
                ],
              ),
              if (vote.endsAt != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.schedule,
                        size: 14, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      _formatDeadline(vote.endsAt!),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: vote.isOngoing
                            ? colorScheme.onSurfaceVariant
                            : colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDeadline(DateTime endsAt) {
    final now = DateTime.now();
    final diff = endsAt.difference(now);
    if (diff.isNegative) return '마감됨';
    if (diff.inDays > 0) return '${diff.inDays}일 후 마감';
    if (diff.inHours > 0) return '${diff.inHours}시간 후 마감';
    return '${diff.inMinutes}분 후 마감';
  }
}

// ─── 상태 뱃지 ────────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final bool isOngoing;

  const _StatusBadge({required this.isOngoing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isOngoing
            ? Colors.green.withValues(alpha: 0.15)
            : Colors.grey.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isOngoing ? '진행중' : '종료',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isOngoing ? Colors.green[700] : Colors.grey[600],
        ),
      ),
    );
  }
}
