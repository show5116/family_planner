import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

/// 루틴 체크 히트맵 캘린더 (table_calendar 기반, GitHub 잔디 스타일)
class RoutineHeatmapCalendar extends StatefulWidget {
  const RoutineHeatmapCalendar({
    super.key,
    required this.checkedDates,
    required this.onMonthChanged,
    this.accentColor,
  });

  final Set<DateTime> checkedDates;
  final ValueChanged<DateTime> onMonthChanged;
  final Color? accentColor;

  @override
  State<RoutineHeatmapCalendar> createState() =>
      _RoutineHeatmapCalendarState();
}

class _RoutineHeatmapCalendarState extends State<RoutineHeatmapCalendar> {
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
  }

  bool _isChecked(DateTime day) {
    return widget.checkedDates.any((d) =>
        d.year == day.year && d.month == day.month && d.day == day.day);
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.accentColor ?? Theme.of(context).colorScheme.primary;

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
      onPageChanged: (focusedDay) {
        setState(() => _focusedDay = focusedDay);
        widget.onMonthChanged(focusedDay);
      },
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          final checked = _isChecked(day);
          return Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: checked ? accent : accent.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${day.day}',
              style: TextStyle(
                color: checked
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: checked ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
        todayBuilder: (context, day, focusedDay) {
          final checked = _isChecked(day);
          return Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: checked ? accent : accent.withValues(alpha: 0.08),
              shape: BoxShape.circle,
              border: Border.all(color: accent, width: 2),
            ),
            alignment: Alignment.center,
            child: Text(
              '${day.day}',
              style: TextStyle(
                color: checked
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}
