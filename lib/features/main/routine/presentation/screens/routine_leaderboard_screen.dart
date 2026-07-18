import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/providers/routine_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/app_empty_state.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';

/// 그룹 랭킹보드 화면 (공유된 루틴 기준 체크 횟수/달성률 순위)
class RoutineLeaderboardScreen extends ConsumerStatefulWidget {
  const RoutineLeaderboardScreen({super.key, required this.groupId});

  final String groupId;

  @override
  ConsumerState<RoutineLeaderboardScreen> createState() =>
      _RoutineLeaderboardScreenState();
}

class _RoutineLeaderboardScreenState
    extends ConsumerState<RoutineLeaderboardScreen> {
  LeaderboardPeriod _period = LeaderboardPeriod.week;
  LeaderboardMetric _metric = LeaderboardMetric.checkCount;

  static const _medalColors = {
    1: Color(0xFFFFD700),
    2: Color(0xFFC0C0C0),
    3: Color(0xFFCD7F32),
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final leaderboardProviderArg = routineLeaderboardProvider(
      widget.groupId,
      period: _period,
      metric: _metric,
    );
    final leaderboardAsync = ref.watch(leaderboardProviderArg);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.routine_leaderboard_title)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.spaceM),
            child: Column(
              children: [
                SegmentedButton<LeaderboardPeriod>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(
                      value: LeaderboardPeriod.week,
                      label: Text(l10n.routine_rate_period_week),
                    ),
                    ButtonSegment(
                      value: LeaderboardPeriod.month,
                      label: Text(l10n.routine_rate_period_month),
                    ),
                  ],
                  selected: {_period},
                  onSelectionChanged: (selected) =>
                      setState(() => _period = selected.first),
                ),
                const SizedBox(height: AppSizes.spaceS),
                SegmentedButton<LeaderboardMetric>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(
                      value: LeaderboardMetric.checkCount,
                      label: Text(l10n.routine_leaderboard_metric_checkCount),
                    ),
                    ButtonSegment(
                      value: LeaderboardMetric.achievementRate,
                      label: Text(
                        l10n.routine_leaderboard_metric_achievementRate,
                      ),
                    ),
                  ],
                  selected: {_metric},
                  onSelectionChanged: (selected) =>
                      setState(() => _metric = selected.first),
                ),
              ],
            ),
          ),
          Expanded(
            child: leaderboardAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => AppErrorState(
                error: error,
                title: l10n.routine_error_generic,
                onRetry: () => ref.invalidate(leaderboardProviderArg),
              ),
              data: (leaderboard) {
                if (leaderboard.rankings.isEmpty) {
                  return AppEmptyState(
                    icon: Icons.leaderboard_outlined,
                    message: l10n.routine_leaderboard_empty,
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                    AppSizes.spaceM,
                    0,
                    AppSizes.spaceM,
                    AppSizes.spaceM + MediaQuery.paddingOf(context).bottom,
                  ),
                  itemCount: leaderboard.rankings.length,
                  itemBuilder: (context, index) {
                    final entry = leaderboard.rankings[index];
                    final medalColor = _medalColors[entry.rank];
                    return Card(
                      margin: const EdgeInsets.only(bottom: AppSizes.spaceS),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              medalColor ??
                              Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                          child: Text(
                            '${entry.rank}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: medalColor != null
                                  ? Colors.white
                                  : Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        title: Text(entry.userName),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${entry.checkCount}${l10n.routine_leaderboard_check_count_suffix}',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Text(
                              '${entry.achievementRate}%',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(color: AppColors.success),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
