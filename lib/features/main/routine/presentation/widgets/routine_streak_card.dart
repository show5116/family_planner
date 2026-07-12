import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 스트릭 통계 카드 (현재/최장, 일/주 단위)
class RoutineStreakCard extends StatelessWidget {
  const RoutineStreakCard({super.key, required this.streak});

  final RoutineStreak streak;

  Widget _statTile(BuildContext context, String label, int value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '$value',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
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
            Row(
              children: [
                _statTile(
                  context,
                  l10n.routine_streak_current_days,
                  streak.currentStreakDays,
                ),
                _statTile(
                  context,
                  l10n.routine_streak_longest_days,
                  streak.longestStreakDays,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceM),
            const Divider(height: 1),
            const SizedBox(height: AppSizes.spaceM),
            Row(
              children: [
                _statTile(
                  context,
                  l10n.routine_streak_current_weeks,
                  streak.currentStreakWeeks,
                ),
                _statTile(
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
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
