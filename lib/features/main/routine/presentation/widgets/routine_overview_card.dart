import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 전체 루틴 통합 달성률 카드 (기간 선택 + 원형 게이지). [RoutineRateCard]와
/// 같은 형태지만 전체 루틴 합산 데이터([RoutineOverview])를 사용한다.
class RoutineOverviewCard extends StatelessWidget {
  const RoutineOverviewCard({
    super.key,
    required this.overview,
    required this.period,
    required this.onPeriodChanged,
  });

  final RoutineOverview overview;
  final RoutineOverviewPeriod period;
  final ValueChanged<RoutineOverviewPeriod> onPeriodChanged;

  Color _gaugeColor(num achievementRate) {
    if (achievementRate >= 80) return AppColors.success;
    if (achievementRate >= 50) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final ratio = (overview.achievementRate / 100).clamp(0.0, 1.0);
    final gaugeColor = _gaugeColor(overview.achievementRate);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SegmentedButton<RoutineOverviewPeriod>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: RoutineOverviewPeriod.week,
                  label: Text(l10n.routine_rate_period_week),
                ),
                ButtonSegment(
                  value: RoutineOverviewPeriod.month,
                  label: Text(l10n.routine_rate_period_month),
                ),
              ],
              selected: {period},
              onSelectionChanged: (selected) => onPeriodChanged(selected.first),
            ),
            const SizedBox(height: AppSizes.spaceL),
            Center(
              child: SizedBox(
                width: 160,
                height: 160,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        startDegreeOffset: -90,
                        sectionsSpace: 0,
                        centerSpaceRadius: 56,
                        sections: [
                          PieChartSectionData(
                            value: ratio,
                            color: gaugeColor,
                            radius: 22,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            value: 1 - ratio,
                            color: colorScheme.surfaceContainerHighest,
                            radius: 22,
                            showTitle: false,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${overview.achievementRate}%',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: gaugeColor,
                              ),
                        ),
                        Text(
                          l10n.routine_rate_achievement,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spaceM),
            Center(
              child: Text(
                '${overview.totalChecked} / ${overview.totalExpected}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: AppSizes.spaceXS),
            Center(
              child: Text(
                l10n.routine_overview_total_routines(overview.totalRoutines),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spaceXS),
            Center(
              child: Text(
                '${overview.from} ~ ${overview.to}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
