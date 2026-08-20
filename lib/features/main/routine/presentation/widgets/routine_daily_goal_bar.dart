import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 오늘의 목표 진행 바.
///
/// 목표까지의 진행을 채우고, 목표를 넘어선 추가 체크는 "보너스" 색으로
/// 이어 붙인다. 목표를 채운 뒤에도 더 하고 싶게 만드는 것이 목적이라,
/// 달성 즉시 바가 가득 차서 끝나버리지 않도록 초과분을 따로 보여준다.
class RoutineDailyGoalBar extends StatelessWidget {
  const RoutineDailyGoalBar({super.key, required this.streak, this.onTap});

  final RoutineDailyStreak streak;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final target = streak.todayTargetCount;
    final checked = streak.todayCheckedCount;
    // 오늘 대상 습관이 아예 없으면 보여줄 진행이 없다.
    if (target <= 0) return const SizedBox.shrink();

    final achieved = streak.todayAchieved;
    final bonus = checked > target ? checked - target : 0;
    final baseRatio = (checked / target).clamp(0.0, 1.0);

    return Card(
      margin: const EdgeInsets.fromLTRB(
        AppSizes.spaceM,
        AppSizes.spaceS,
        AppSizes.spaceM,
        0,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    achieved ? Icons.emoji_events : Icons.flag_outlined,
                    size: 18,
                    color: achieved
                        ? AppColors.warning
                        : colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSizes.spaceXS),
                  Expanded(
                    child: Text(
                      achieved
                          ? l10n.routine_daily_goal_achieved_today
                          : l10n.routine_daily_goal_today_progress(
                              checked,
                              target,
                            ),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: achieved ? AppColors.success : null,
                      ),
                    ),
                  ),
                  if (streak.currentStreakDays > 0)
                    Text(
                      '🔥 ${l10n.routine_daily_goal_streak(streak.currentStreakDays)}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceS),
              _GoalProgressTrack(
                baseRatio: baseRatio,
                achieved: achieved,
                hasBonus: bonus > 0,
              ),
              if (bonus > 0) ...[
                const SizedBox(height: AppSizes.spaceXS),
                Text(
                  l10n.routine_daily_goal_bonus(bonus),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.warning,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// 진행 바 본체. 목표 달성 전까지는 primary 색으로 차오르고, 달성하면
/// success 색으로 바뀐다. 초과 달성분이 있으면 바 끝에 금색 구간을 덧댄다.
class _GoalProgressTrack extends StatelessWidget {
  const _GoalProgressTrack({
    required this.baseRatio,
    required this.achieved,
    required this.hasBonus,
  });

  final double baseRatio;
  final bool achieved;
  final bool hasBonus;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const height = 10.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            Container(color: colorScheme.surfaceContainerHighest),
            FractionallySizedBox(
              widthFactor: baseRatio,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                color: achieved ? AppColors.success : colorScheme.primary,
              ),
            ),
            // 초과 달성 표시. 바가 이미 가득 찬 상태라 별도 구간을 그릴
            // 자리가 없으므로, 금색 스트라이프를 덧대 "더 했다"는 신호만 준다.
            if (hasBonus)
              Align(
                alignment: Alignment.centerRight,
                child: FractionallySizedBox(
                  widthFactor: 0.18,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.success, AppColors.warning],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
