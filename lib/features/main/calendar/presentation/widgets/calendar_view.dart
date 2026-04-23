import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/core/utils/color_utils.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';

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
  /// 멀티데이 이벤트 슬롯 맵: 날짜별로 각 이벤트가 몇 번째 row에 그려질지 사전 계산
  /// key: 날짜(날짜만), value: {taskId: rowIndex}
  Map<DateTime, Map<String, int>> _multiDaySlotMap = {};

  @override
  void didUpdateWidget(CalendarView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 데이터가 바뀌거나 로딩 완료 시 슬롯 맵 재계산
    if (oldWidget.tasksAsync != widget.tasksAsync) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _buildSlotMap());
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _buildSlotMap());
  }

  void _buildSlotMap() {
    final tasks = widget.tasksAsync.valueOrNull ?? [];
    final multiDay = tasks.where((t) {
      if (t.scheduledAt == null || t.dueAt == null) return false;
      final s = DateTime(t.scheduledAt!.year, t.scheduledAt!.month, t.scheduledAt!.day);
      final e = DateTime(t.dueAt!.year, t.dueAt!.month, t.dueAt!.day);
      return s != e;
    }).toList()
      ..sort((a, b) => a.scheduledAt!.compareTo(b.scheduledAt!));

    // 날짜 범위별로 슬롯 할당 (greedy interval scheduling)
    // slots[rowIndex] = 해당 row의 마지막 end 날짜
    final slotEnds = <DateTime>[];
    final taskSlot = <String, int>{};

    for (final task in multiDay) {
      final start = DateTime(task.scheduledAt!.year, task.scheduledAt!.month, task.scheduledAt!.day);
      final end = DateTime(task.dueAt!.year, task.dueAt!.month, task.dueAt!.day);
      int slot = -1;
      for (int i = 0; i < slotEnds.length; i++) {
        if (!start.isBefore(slotEnds[i].add(const Duration(days: 1)))) {
          slot = i;
          slotEnds[i] = end;
          break;
        }
      }
      if (slot == -1) {
        slot = slotEnds.length;
        slotEnds.add(end);
      }
      taskSlot[task.id] = slot;
    }

    // 날짜별 슬롯 맵 구성
    final map = <DateTime, Map<String, int>>{};
    for (final task in multiDay) {
      final start = DateTime(task.scheduledAt!.year, task.scheduledAt!.month, task.scheduledAt!.day);
      final end = DateTime(task.dueAt!.year, task.dueAt!.month, task.dueAt!.day);
      final slot = taskSlot[task.id]!;
      for (var d = start; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
        final key = DateTime(d.year, d.month, d.day);
        map.putIfAbsent(key, () => {})[task.id] = slot;
      }
    }

    setState(() => _multiDaySlotMap = map);
  }

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

  String? get _personalColorHex {
    final user = ref.watch(authProvider).user;
    return (user?['personalColor'] ?? user?['user']?['personalColor']) as String?;
  }

  Color _taskColor(TaskModel task) {
    final groups = ref.watch(myGroupsProvider).valueOrNull ?? [];
    return ColorUtils.taskColor(
      groupId: task.groupId,
      groups: groups,
      personalColorHex: _personalColorHex,
    );
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
      // 멀티데이 바가 셀 경계를 넘어 인접 셀과 이어질 수 있도록 클리핑 해제
      canMarkersOverflow: true,
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

        final dateKey = DateTime(date.year, date.month, date.day);
        final slotMap = _multiDaySlotMap[dateKey] ?? {};

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

        // 슬롯 번호 → task 맵 구성 (최대 2슬롯)
        final slotToTask = <int, TaskModel>{};
        for (final task in multiDayEvents) {
          final slot = slotMap[task.id];
          if (slot != null && slot < 2) {
            slotToTask[slot] = task;
          }
        }
        // 각 슬롯을 개별 Positioned로 배치 — 절대 위치 고정으로 날짜 간 높이 일치
        const barHeight = 4.0;
        const barVerticalMargin = 1.0;
        const barSlotHeight = barHeight + barVerticalMargin * 2;

        final bars = <Widget>[
          for (int slot = 0; slot < 2; slot++)
            if (slotToTask.containsKey(slot))
              Positioned(
                left: 0,
                right: 0,
                // slot 0은 bottom 기준 위쪽, slot 1은 바로 아래
                bottom: 1 + (1 - slot) * barSlotHeight,
                child: _buildMultiDayBar(
                  _getMultiDayPosition(slotToTask[slot]!, date),
                  _taskColor(slotToTask[slot]!),
                ),
              ),
        ];

        // 멀티데이 바가 없으면 단일 마커만
        if (bars.isEmpty && singleDayEvents.isEmpty) return null;

        return Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          top: 0,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ...bars,
              if (singleDayEvents.isNotEmpty)
                Positioned(
                  bottom: 1,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: singleDayEvents.take(3).map((task) {
                      return Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 0.5),
                        decoration: BoxDecoration(
                          color: _taskColor(task),
                          shape: BoxShape.circle,
                        ),
                      );
                    }).toList(),
                  ),
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

    switch (position) {
      case MultiDayPosition.start:
        return Container(
          height: barHeight,
          margin: const EdgeInsets.only(
              left: 4, right: 0, top: verticalMargin, bottom: verticalMargin),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(barHeight / 2),
              bottomLeft: Radius.circular(barHeight / 2),
            ),
          ),
        );
      case MultiDayPosition.middle:
        return Container(
          height: barHeight,
          margin: const EdgeInsets.only(
              left: 0, right: 0, top: verticalMargin, bottom: verticalMargin),
          decoration: BoxDecoration(color: color),
        );
      case MultiDayPosition.end:
        return Container(
          height: barHeight,
          margin: const EdgeInsets.only(
              left: 0, right: 4, top: verticalMargin, bottom: verticalMargin),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(barHeight / 2),
              bottomRight: Radius.circular(barHeight / 2),
            ),
          ),
        );
      case MultiDayPosition.single:
        return Container(
          height: barHeight,
          margin: const EdgeInsets.symmetric(
              horizontal: 4, vertical: verticalMargin),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(barHeight / 2),
          ),
        );
    }
  }
}
