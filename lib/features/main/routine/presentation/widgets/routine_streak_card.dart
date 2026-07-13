import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 스트릭 통계 카드 (현재 연속 일수 하이라이트 + 보조 통계 + 이번 주 진행)
class RoutineStreakCard extends StatelessWidget {
  const RoutineStreakCard({super.key, required this.streak});

  final RoutineStreak streak;

  Widget _subStatTile(BuildContext context, String label, int value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '$value',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppSizes.spaceXS),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final progress = streak.thisWeekProgress;
    final ratio = progress.target > 0
        ? (progress.checked / progress.target).clamp(0.0, 1.0)
        : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 현재 연속 일수 하이라이트
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: AppSizes.spaceL,
                horizontal: AppSizes.spaceM,
              ),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
              child: Column(
                children: [
                  Text(
                    '🔥 ${streak.currentStreakDays}',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.warning,
                        ),
                  ),
                  const SizedBox(height: AppSizes.spaceXS),
                  Text(
                    l10n.routine_streak_current_days,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.spaceM),
            // 보조 통계 (최장 일수 / 현재 주 / 최장 주)
            Row(
              children: [
                _subStatTile(
                  context,
                  l10n.routine_streak_longest_days,
                  streak.longestStreakDays,
                ),
                _subStatTile(
                  context,
                  l10n.routine_streak_current_weeks,
                  streak.currentStreakWeeks,
                ),
                _subStatTile(
                  context,
                  l10n.routine_streak_longest_weeks,
                  streak.longestStreakWeeks,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceL),
            Text(
              l10n.routine_this_week_progress,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: AppSizes.spaceS),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: AppSizes.spaceXS),
            Text(
              '${progress.checked} / ${progress.target}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
