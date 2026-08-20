import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';

/// 전체 루틴 통합 히트맵 캘린더. [RoutineHeatmapCalendar]와 달리 하루
/// 체크 여부(이진값)가 아니라 그날의 전체 완료율(0~100%)을 색상 농도로
/// 표시한다(완료율이 높을수록 진하게).
class RoutineOverviewHeatmapCalendar extends StatefulWidget {
  const RoutineOverviewHeatmapCalendar({
    super.key,
    required this.days,
    this.accentColor,
  });

  final List<RoutineOverviewHeatmapDay> days;
  final Color? accentColor;

  @override
  State<RoutineOverviewHeatmapCalendar> createState() =>
      _RoutineOverviewHeatmapCalendarState();
}

class _RoutineOverviewHeatmapCalendarState
    extends State<RoutineOverviewHeatmapCalendar> {
  late DateTime _focusedDay;
  late Map<String, RoutineOverviewHeatmapDay> _dayByDate;

  static String _key(DateTime day) =>
      '${day.year.toString().padLeft(4, '0')}-'
      '${day.month.toString().padLeft(2, '0')}-'
      '${day.day.toString().padLeft(2, '0')}';

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _dayByDate = {for (final d in widget.days) d.date: d};
  }

  @override
  void didUpdateWidget(covariant RoutineOverviewHeatmapCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.days != oldWidget.days) {
      _dayByDate = {for (final d in widget.days) d.date: d};
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.accentColor ?? Theme.of(context).colorScheme.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    Widget dayCell(DateTime day, {required bool isToday}) {
      final data = _dayByDate[_key(day)];
      final ratio = data?.ratio ?? 0.0;
      final hasData = data != null && data.totalCount > 0;
      // 목표를 달성한 날은 농도와 무관하게 한눈에 구분되도록 테두리를 준다.
      // 비율제 목표에서는 "전부 채우지 않아도 성공한 날"이 생기는데, 농도만
      // 보면 그날이 성공이었는지 알 수 없다.
      final goalAchieved = data?.goalAchieved ?? false;
      return Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: hasData
              ? accent.withValues(alpha: 0.15 + ratio * 0.85)
              : onSurface.withValues(alpha: 0.03),
          shape: BoxShape.circle,
          border: isToday
              ? Border.all(color: accent, width: 2)
              : goalAchieved
              ? Border.all(color: AppColors.success, width: 2)
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          '${day.day}',
          style: TextStyle(
            color: hasData && ratio > 0.5 ? Colors.white : onSurface,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      );
    }

    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2100, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: CalendarFormat.month,
      locale: Localizations.localeOf(context).toString(),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      onPageChanged: (focusedDay) => setState(() => _focusedDay = focusedDay),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) =>
            dayCell(day, isToday: false),
        todayBuilder: (context, day, focusedDay) => dayCell(day, isToday: true),
      ),
    );
  }
}
