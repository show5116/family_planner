import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';

/// 멀티데이 이벤트의 위치
enum MultiDayPosition {
  single, // 단일 일정 (마커)
  start, // 시작일 (왼쪽 둥근 바)
  middle, // 중간 (직선 바)
  end, // 종료일 (오른쪽 둥근 바)
}

/// 월간 캘린더 뷰 위젯
class CalendarView extends ConsumerStatefulWidget {
  final AsyncValue<List<TaskModel>> tasksAsync;
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final CalendarFormat calendarFormat;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<DateTime> onPageChanged;
  final ValueChanged<CalendarFormat> onFormatChanged;

  const CalendarView({
    super.key,
    required this.tasksAsync,
    required this.focusedDay,
    required this.selectedDay,
    required this.calendarFormat,
    required this.onDaySelected,
    required this.onPageChanged,
    required this.onFormatChanged,
  });

  @override
  ConsumerState<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends ConsumerState<CalendarView> {
  /// 멀티데이 이벤트의 위치를 반환 (start, middle, end, single)
  MultiDayPosition _getMultiDayPosition(TaskModel task, DateTime date) {
    if (task.scheduledAt == null) return MultiDayPosition.single;

    final startDate = DateTime(
      task.scheduledAt!.year,
      task.scheduledAt!.month,
      task.scheduledAt!.day,
    );
    final targetDate = DateTime(date.year, date.month, date.day);

    // 마감일이 없으면 단일 일정
    if (task.dueAt == null) return MultiDayPosition.single;

    final endDate = DateTime(
      task.dueAt!.year,
      task.dueAt!.month,
      task.dueAt!.day,
    );

    // 시작일과 종료일이 같으면 단일 일정
    if (startDate == endDate) return MultiDayPosition.single;

    if (targetDate == startDate) return MultiDayPosition.start;
    if (targetDate == endDate) return MultiDayPosition.end;
    return MultiDayPosition.middle;
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar<TaskModel>(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: widget.focusedDay,
      calendarFormat: widget.calendarFormat,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      locale: Localizations.localeOf(context).toString(),

      // 선택된 날짜
      selectedDayPredicate: (day) => isSameDay(widget.selectedDay, day),

      // 날짜 선택 시
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(widget.selectedDay, selectedDay)) {
          widget.onDaySelected(selectedDay);
        }
      },

      // 페이지(월) 변경 시
      onPageChanged: widget.onPageChanged,

      // 캘린더 포맷 변경 시
      onFormatChanged: widget.onFormatChanged,

      // 일정 데이터 로드 (해당 날짜의 Task 목록)
      eventLoader: (day) => _getEventsForDay(day),

      // 캘린더 스타일
      calendarStyle: _buildCalendarStyle(),

      // 헤더 스타일
      headerStyle: _buildHeaderStyle(),

      // 요일 스타일
      daysOfWeekStyle: _buildDaysOfWeekStyle(),

      // 캘린더 빌더
      calendarBuilders: _buildCalendarBuilders(),

      // 제스처 및 애니메이션
      availableGestures: AvailableGestures.all,
      pageAnimationEnabled: true,
    );
  }

  /// 특정 날짜의 이벤트 목록
  List<TaskModel> _getEventsForDay(DateTime day) {
    return widget.tasksAsync.maybeWhen(
      data: (tasks) {
        return tasks.where((task) {
          if (task.scheduledAt == null) return false;

          final taskDate = DateTime(
            task.scheduledAt!.year,
            task.scheduledAt!.month,
            task.scheduledAt!.day,
          );

          // dueAt이 있으면 기간 일정
          if (task.dueAt != null) {
            final dueDate = DateTime(
              task.dueAt!.year,
              task.dueAt!.month,
              task.dueAt!.day,
            );
            final targetDay = DateTime(day.year, day.month, day.day);
            return !targetDay.isBefore(taskDate) && !targetDay.isAfter(dueDate);
          }

          final targetDay = DateTime(day.year, day.month, day.day);
          return taskDate == targetDay;
        }).toList();
      },
      orElse: () => <TaskModel>[],
    );
  }

  /// 캘린더 스타일
  CalendarStyle _buildCalendarStyle() {
    return CalendarStyle(
      // 오늘 날짜 스타일
      todayDecoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
      todayTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontWeight: FontWeight.bold,
      ),

      // 선택된 날짜 스타일
      selectedDecoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      selectedTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),

      // 주말 스타일
      weekendTextStyle: TextStyle(
        color: AppColors.error.withValues(alpha: 0.8),
      ),

      // 마커 스타일 (일정 표시)
      markerDecoration: const BoxDecoration(
        color: AppColors.secondary,
        shape: BoxShape.circle,
      ),
      markersMaxCount: 3,
      markerSize: 6,
      markerMargin: const EdgeInsets.symmetric(horizontal: 0.5),
    );
  }

  /// 헤더 스타일
  HeaderStyle _buildHeaderStyle() {
    return HeaderStyle(
      formatButtonVisible: true,
      titleCentered: true,
      formatButtonShowsNext: false,
      formatButtonDecoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      formatButtonTextStyle: Theme.of(context).textTheme.bodySmall!,
      titleTextFormatter: (date, locale) {
        return DateFormat.yMMMM(locale).format(date);
      },
      titleTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
      leftChevronIcon: const Icon(Icons.chevron_left, color: AppColors.primary),
      rightChevronIcon:
          const Icon(Icons.chevron_right, color: AppColors.primary),
    );
  }

  /// 요일 스타일
  DaysOfWeekStyle _buildDaysOfWeekStyle() {
    return DaysOfWeekStyle(
      weekdayStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.w600,
          ),
      weekendStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }

  /// 캘린더 빌더
  CalendarBuilders<TaskModel> _buildCalendarBuilders() {
    return CalendarBuilders(
      // 요일 헤더 빌더 (토요일 파란색, 일요일 빨간색)
      dowBuilder: (context, day) {
        final text =
            DateFormat.E(Localizations.localeOf(context).toString()).format(day);
        Color textColor;
        if (day.weekday == DateTime.sunday) {
          textColor = AppColors.error.withValues(alpha: 0.8);
        } else if (day.weekday == DateTime.saturday) {
          textColor = AppColors.primary;
        } else {
          textColor = Theme.of(context).colorScheme.onSurface;
        }
        return Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
          ),
        );
      },
      // 기본 날짜 빌더 (토요일 파란색, 일요일 빨간색)
      defaultBuilder: (context, date, focusedDay) {
        return _buildDayCell(date, isOutside: false);
      },
      outsideBuilder: (context, date, focusedDay) {
        return _buildDayCell(date, isOutside: true);
      },
      markerBuilder: (context, date, events) {
        if (events.isEmpty) return null;

        // 멀티데이 이벤트와 단일 이벤트 분리
        final multiDayEvents = <TaskModel>[];
        final singleDayEvents = <TaskModel>[];

        for (final task in events) {
          final position = _getMultiDayPosition(task, date);
          if (position == MultiDayPosition.single) {
            singleDayEvents.add(task);
          } else {
            multiDayEvents.add(task);
          }
        }

        return Positioned(
          left: 0,
          right: 0,
          bottom: 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 멀티데이 이벤트 바
              ...multiDayEvents.take(2).map((task) {
                final position = _getMultiDayPosition(task, date);
                final color = Color(task.colorValue);
                return _buildMultiDayBar(position, color);
              }),
              // 단일 이벤트 마커
              if (singleDayEvents.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: singleDayEvents.take(3).map((task) {
                    return Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 0.5),
                      decoration: BoxDecoration(
                        color: Color(task.colorValue),
                        shape: BoxShape.circle,
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        );
      },
    );
  }

  /// 날짜 셀 빌더 (토요일 파란색, 일요일 빨간색)
  Widget _buildDayCell(DateTime date, {required bool isOutside}) {
    Color textColor;

    if (isOutside) {
      textColor = AppColors.textSecondary.withValues(alpha: 0.5);
    } else if (date.weekday == DateTime.sunday) {
      textColor = AppColors.error.withValues(alpha: 0.8);
    } else if (date.weekday == DateTime.saturday) {
      textColor = AppColors.primary;
    } else {
      textColor = Theme.of(context).colorScheme.onSurface;
    }

    return Center(
      child: Text(
        '${date.day}',
        style: TextStyle(
          color: textColor,
          fontSize: 14,
        ),
      ),
    );
  }

  /// 멀티데이 이벤트 바 빌더
  Widget _buildMultiDayBar(MultiDayPosition position, Color color) {
    const barHeight = 4.0;
    const verticalMargin = 1.0;

    BorderRadius borderRadius;
    EdgeInsets margin;

    switch (position) {
      case MultiDayPosition.start:
        borderRadius = const BorderRadius.only(
          topLeft: Radius.circular(barHeight / 2),
          bottomLeft: Radius.circular(barHeight / 2),
        );
        margin = const EdgeInsets.only(
            left: 4, right: 0, top: verticalMargin, bottom: verticalMargin);
        break;
      case MultiDayPosition.middle:
        borderRadius = BorderRadius.zero;
        margin = const EdgeInsets.only(
            left: 0, right: 0, top: verticalMargin, bottom: verticalMargin);
        break;
      case MultiDayPosition.end:
        borderRadius = const BorderRadius.only(
          topRight: Radius.circular(barHeight / 2),
          bottomRight: Radius.circular(barHeight / 2),
        );
        margin = const EdgeInsets.only(
            left: 0, right: 4, top: verticalMargin, bottom: verticalMargin);
        break;
      case MultiDayPosition.single:
        borderRadius = BorderRadius.circular(barHeight / 2);
        margin = const EdgeInsets.symmetric(
            horizontal: 4, vertical: verticalMargin);
        break;
    }

    return Container(
      height: barHeight,
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
      ),
    );
  }
}
