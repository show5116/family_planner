import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 통계 화면 주간 모드 전용 뷰. 습관별로 최근 7일(overview.from~to) 수행
/// 여부를 요일 그리드로 보여주고, 그 아래 전체 달성/미달성 습관 수를
/// 표시한다. 월간 목표 개념이 없는 MONTHLY 습관은 그리드는 보여주되
/// 달성/미달성 집계에서는 제외한다.
class RoutineOverviewWeeklyBreakdown extends StatelessWidget {
  const RoutineOverviewWeeklyBreakdown({super.key, required this.overview});

  final RoutineOverview overview;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final breakdown = overview.routineBreakdown ?? const [];
    final weekDates = _weekDates(overview.from);

    final achieved = breakdown.where((r) => r.achievedThisWeek == true).length;
    final notAchieved = breakdown
        .where((r) => r.achievedThisWeek == false)
        .length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.routine_overview_weekly_title,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: AppSizes.spaceM),
            if (breakdown.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceL),
                child: Center(
                  child: Text(
                    l10n.routine_list_empty,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              )
            else ...[
              _WeekdayHeaderRow(weekDates: weekDates),
              const Divider(height: AppSizes.spaceM),
              for (final routine in breakdown)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSizes.spaceXS,
                  ),
                  child: _RoutineWeekRow(
                    routine: routine,
                    weekDates: weekDates,
                  ),
                ),
              const SizedBox(height: AppSizes.spaceS),
              const Divider(),
              const SizedBox(height: AppSizes.spaceS),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _CountTile(
                    label: l10n.routine_overview_achieved,
                    count: achieved,
                    color: AppColors.success,
                  ),
                  _CountTile(
                    label: l10n.routine_overview_not_achieved,
                    count: notAchieved,
                    color: AppColors.error,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  static List<DateTime> _weekDates(String fromDate) {
    final from = DateTime.parse(fromDate);
    return List.generate(7, (i) => from.add(Duration(days: i)));
  }
}

class _WeekdayHeaderRow extends StatelessWidget {
  const _WeekdayHeaderRow({required this.weekDates});

  final List<DateTime> weekDates;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        const Expanded(flex: 3, child: SizedBox.shrink()),
        for (final date in weekDates)
          Expanded(
            child: Text(
              DateFormat.E(locale).format(date),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        const SizedBox(width: AppSizes.spaceL),
      ],
    );
  }
}

class _RoutineWeekRow extends StatelessWidget {
  const _RoutineWeekRow({required this.routine, required this.weekDates});

  final RoutineOverviewRoutineBreakdown routine;
  final List<DateTime> weekDates;

  static String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final checkedSet = routine.checkedDates.toSet();

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              if (routine.emoji != null && routine.emoji!.isNotEmpty) ...[
                Text(routine.emoji!, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: AppSizes.spaceXS),
              ],
              Expanded(
                child: Text(
                  routine.title,
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        for (final date in weekDates)
          Expanded(
            child: Center(
              child: Icon(
                checkedSet.contains(_dateKey(date))
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                size: 16,
                color: checkedSet.contains(_dateKey(date))
                    ? AppColors.success
                    : colorScheme.outlineVariant,
              ),
            ),
          ),
        SizedBox(
          width: AppSizes.spaceL,
          child: _AchievementBadge(achieved: routine.achievedThisWeek),
        ),
      ],
    );
  }
}

/// 습관 행 맨 끝에 붙는 이번 주 달성 여부 배지. [achieved]가 null이면
/// (MONTHLY 등 주간 목표가 없는 습관) 아무것도 표시하지 않는다.
class _AchievementBadge extends StatelessWidget {
  const _AchievementBadge({required this.achieved});

  final bool? achieved;

  @override
  Widget build(BuildContext context) {
    if (achieved == null) return const SizedBox.shrink();
    return Icon(
      achieved! ? Icons.emoji_events : Icons.close,
      size: 16,
      color: achieved! ? AppColors.warning : AppColors.error,
    );
  }
}

class _CountTile extends StatelessWidget {
  const _CountTile({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$count',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
        ),
      ],
    );
  }
}
