import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 달성률 카드 (기간 선택 + 진행바)
class RoutineRateCard extends StatelessWidget {
  const RoutineRateCard({
    super.key,
    required this.rate,
    required this.period,
    required this.onPeriodChanged,
  });

  final RoutineRate rate;
  final RoutineRatePeriod period;
  final ValueChanged<RoutineRatePeriod> onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ratio = (rate.achievementRate / 100).clamp(0.0, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SegmentedButton<RoutineRatePeriod>(
              segments: [
                ButtonSegment(
                  value: RoutineRatePeriod.week,
                  label: Text(l10n.routine_rate_period_week),
                ),
                ButtonSegment(
                  value: RoutineRatePeriod.month,
                  label: Text(l10n.routine_rate_period_month),
                ),
              ],
              selected: {period},
              onSelectionChanged: (selected) => onPeriodChanged(selected.first),
            ),
            const SizedBox(height: AppSizes.spaceL),
            Center(
              child: Text(
                '${rate.achievementRate}%',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
            Center(
              child: Text(
                l10n.routine_rate_achievement,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
            const SizedBox(height: AppSizes.spaceM),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              child: LinearProgressIndicator(value: ratio, minHeight: 8),
            ),
            const SizedBox(height: AppSizes.spaceM),
            Text(
              '${rate.totalChecked} / ${rate.expectedCount}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
