import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 통계 화면의 일일 목표 달성 현황 카드.
///
/// 기존 달성률(전체 체크 수 / 기대 체크 수)과 달리 "목표를 달성한 날이
/// 며칠인가"를 보여준다. 습관을 많이 등록한 사용자에게는 이쪽이 훨씬
/// 현실적인 성취 지표다.
///
/// [overview]의 목표 값은 조회 기간 기준으로 서버가 판정한 것이라,
/// 과거 기간을 볼 때 현재 설정과 다를 수 있다. 그래서 설정 provider가
/// 아니라 반드시 overview의 값을 표시한다.
class RoutineGoalSummaryCard extends StatelessWidget {
  const RoutineGoalSummaryCard({
    super.key,
    required this.overview,
    this.dailyStreak,
  });

  final RoutineOverview overview;

  /// 현재 기간(이번 주/이번 달)을 보고 있을 때만 전달한다. 과거 기간에는
  /// 오늘 기준 스트릭을 함께 보여주면 맥락이 어긋난다.
  final RoutineDailyStreak? dailyStreak;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    // 집계 대상 일수가 0이면(모두 쉬는 날이었거나 데이터 없음) 표시할
    // 내용이 없다.
    if (overview.goalTotalDays <= 0) return const SizedBox.shrink();

    final rate = overview.goalAchievementRate;
    final rateColor = rate >= 80
        ? AppColors.success
        : rate >= 50
        ? AppColors.warning
        : AppColors.error;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.flag_outlined,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSizes.spaceXS),
                Text(
                  l10n.routine_daily_goal_rate,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const Spacer(),
                if (overview.dailyGoalMode == RoutineDailyGoalMode.count &&
                    overview.dailyGoalCount != null)
                  Text(
                    l10n.routine_daily_goal_encourage(overview.dailyGoalCount!),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceM),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$rate%',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: rateColor,
                  ),
                ),
                const SizedBox(width: AppSizes.spaceS),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    l10n.routine_daily_goal_achieved_days(
                      overview.goalAchievedDays,
                      overview.goalTotalDays,
                    ),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceS),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (rate / 100).clamp(0.0, 1.0).toDouble(),
                minHeight: 8,
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation(rateColor),
              ),
            ),
            if (dailyStreak != null && dailyStreak!.currentStreakDays > 0) ...[
              const SizedBox(height: AppSizes.spaceM),
              Row(
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: AppSizes.spaceXS),
                  Text(
                    l10n.routine_daily_goal_streak(
                      dailyStreak!.currentStreakDays,
                    ),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    l10n.routine_daily_goal_streak_longest(
                      dailyStreak!.longestStreakDays,
                    ),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
