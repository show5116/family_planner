import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/providers/routine_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

const int _kWeeksToShow = 8;

/// 최근 N주(기본 8주)의 "주간 목표 달성 여부"를 사각형 스트립으로 표시.
/// 일별 체크는 이진(있음/없음)이라 강도 표현 대신, 주 단위 달성 여부만 색상으로 구분.
///
/// 주간 목표는 반복 주기에서 계산한다([weeklyTargetOf]). 매일 하는 습관은
/// targetCount가 비어 있어 그 값을 그대로 쓰면 8칸이 영영 채워지지 않는다.
class RoutineWeeklyStrip extends ConsumerWidget {
  const RoutineWeeklyStrip({
    super.key,
    required this.routine,
    this.accentColor,
  });

  final Routine routine;
  final Color? accentColor;

  /// 한 주에 몇 번 해야 달성인지. 월 단위 습관은 주 단위로 환산할 수 없어 null.
  static int? weeklyTargetOf(Routine routine) {
    switch (routine.frequencyType) {
      case RoutineFrequencyType.daily:
        return 7;
      case RoutineFrequencyType.weekly:
        if (routine.weeklyMode == RoutineWeeklyMode.fixedDays) {
          final days = routine.targetDays;
          return (days == null || days.isEmpty) ? null : days.length;
        }
        return routine.targetCount;
      case RoutineFrequencyType.monthly:
        return null;
    }
  }

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

    final target = weeklyTargetOf(routine);
    // 주 단위 목표가 없는 습관(월 N회)은 스트립 자체가 의미 없다.
    if (target == null) return const SizedBox.shrink();

    final thisMonday = _mondayOf(DateTime.now());
    final rangeStart = thisMonday.subtract(Duration(days: 7 * (_kWeeksToShow - 1)));
    final rangeEnd = thisMonday.add(const Duration(days: 6));

    final heatmapAsync = ref.watch(
      routineHeatmapProvider(
        routine.id,
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
          return checkedCount >= target;
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
