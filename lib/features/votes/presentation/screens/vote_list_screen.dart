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

part '_vote_list_onboarding.dart';

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
        actions: [AppBarMoreMenu(onReplayOnboarding: _replayOnboarding)],
      ),
      floatingActionButton: FloatingActionButton(
        key: _fabKey,
        onPressed: _isDemo ? null : () => context.push(AppRoutes.voteCreate),
        child: const Icon(Icons.add),
      ),
      body: _isDemo
          ? _DemoVoteBody(
              groupBarKey: _groupDropdownKey,
              filterKey: _filterKey,
              firstCardKey: _firstCardKey,
            )
          : Column(
              children: [
                GroupFilterBar(
                  key: _groupDropdownKey,
                  selectedGroupId: selectedGroupId,
                  onChanged: (value) {
                    ref.read(voteSelectedGroupIdProvider.notifier).state =
                        value;
                  },
                ),
                if (selectedGroupId != null)
                  Padding(
                    key: _filterKey,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spaceM,
                      vertical: AppSizes.spaceS,
                    ),
                    child: SegmentedButton<VoteStatusFilter>(
                      showSelectedIcon: false,
                      segments: const [
                        ButtonSegment(
                          value: VoteStatusFilter.all,
                          label: Text('전체'),
                        ),
                        ButtonSegment(
                          value: VoteStatusFilter.ongoing,
                          label: Text('진행중'),
                        ),
                        ButtonSegment(
                          value: VoteStatusFilter.closed,
                          label: Text('종료됨'),
                        ),
                      ],
                      selected: {statusFilter},
                      onSelectionChanged: (val) {
                        ref.read(voteStatusFilterProvider.notifier).state =
                            val.first;
                      },
                      style: const ButtonStyle(
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ),
                Expanded(
                  child: selectedGroupId == null
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
                                padding: const EdgeInsets.all(AppSizes.spaceM),
                                itemCount: votes.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: AppSizes.spaceM),
                                itemBuilder: (_, index) =>
                                    _VoteCard(vote: votes[index]),
                              );
                            },
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
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
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
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
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: AppSizes.spaceS),
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    vote.creatorName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: AppSizes.spaceM),
                  Icon(
                    Icons.how_to_vote_outlined,
                    size: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${vote.totalVoters}명 참여',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (vote.hasVoted) ...[
                    const SizedBox(width: AppSizes.spaceM),
                    Icon(
                      Icons.check_circle_outline,
                      size: 14,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '참여함',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ],
              ),
              if (vote.endsAt != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 14,
                      color: colorScheme.onSurfaceVariant,
                    ),
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
