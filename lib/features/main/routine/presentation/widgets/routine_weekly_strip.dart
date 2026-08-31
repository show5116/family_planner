import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/routine/providers/routine_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

const int _kWeeksToShow = 8;

/// 최근 N주(기본 8주)의 "주간 목표 달성 여부"를 사각형 스트립으로 표시.
/// 일별 체크는 이진(있음/없음)이라 강도 표현 대신, 주 단위 달성 여부만 색상으로 구분.
class RoutineWeeklyStrip extends ConsumerWidget {
  const RoutineWeeklyStrip({
    super.key,
    required this.routineId,
    required this.targetCount,
    this.accentColor,
  });

  final String routineId;
  final int? targetCount;
  final Color? accentColor;

  /// ISO 주 시작일(월요일)로 스냅
  DateTime _mondayOf(DateTime d) {
    final date = DateTime(d.year, d.month, d.day);
    return date.subtract(Duration(days: date.weekday - 1));
  }

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final accent = accentColor ?? colorScheme.primary;

    final thisMonday = _mondayOf(DateTime.now());
    final rangeStart = thisMonday.subtract(Duration(days: 7 * (_kWeeksToShow - 1)));
    final rangeEnd = thisMonday.add(const Duration(days: 6));

    final heatmapAsync = ref.watch(
      routineHeatmapProvider(
        routineId,
        fromDate: _fmt(rangeStart),
        toDate: _fmt(rangeEnd),
      ),
    );

    return heatmapAsync.when(
      loading: () => const SizedBox(
        height: 40,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (heatmap) {
        final checkedDates =
            heatmap.checkedDates.map((s) => DateTime.parse(s)).toSet();

        final target = targetCount ?? 0;
        final weeks = List.generate(_kWeeksToShow, (i) {
          final weekStart = rangeStart.add(Duration(days: 7 * i));
          final weekDates = List.generate(
            7,
            (d) => weekStart.add(Duration(days: d)),
          );
          final checkedCount = weekDates
              .where((d) => checkedDates.any((c) =>
                  c.year == d.year && c.month == d.month && c.day == d.day))
              .length;
          final achieved = target > 0 && checkedCount >= target;
          return achieved;
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.routine_weekly_strip_title,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: AppSizes.spaceS),
            Row(
              children: weeks.map((achieved) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spaceXS / 2,
                    ),
                    height: 24,
                    decoration: BoxDecoration(
                      color: achieved
                          ? accent
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
