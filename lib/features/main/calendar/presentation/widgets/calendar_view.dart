import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/features/main/task/providers/holiday_provider.dart';
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
  /// 헤더의 뷰 모드 버튼 탭 시 호출 (null이면 기본 table_calendar 포맷 버튼 사용)
  final VoidCallback? onViewModeTap;
  /// 헤더에 표시할 현재 뷰 모드 레이블 (null이면 기본 포맷 버튼 사용)
  final String? viewModeLabel;

  const CalendarView({
    super.key,
    required this.tasksAsync,
    required this.focusedDay,
    required this.selectedDay,
    required this.calendarFormat,
    required this.onDaySelected,
    required this.onPageChanged,
    required this.onFormatChanged,
    this.onViewModeTap,
    this.viewModeLabel,
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

      // 뷰 모드 버튼이 있으면 포맷 버튼 숨김
      availableCalendarFormats: widget.onViewModeTap != null
          ? const {CalendarFormat.month: '', CalendarFormat.week: ''}
          : const {CalendarFormat.month: '월', CalendarFormat.week: '주'},

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

      // 셀 높이: 날짜 숫자(30px) + 칩 3줄(각 15px) + 여백
      rowHeight: 82.0,

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
      formatButtonVisible: widget.onViewModeTap == null,
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
      // 커스텀 헤더 타이틀 (뷰 모드 버튼 포함)
      headerTitleBuilder: widget.onViewModeTap != null
          ? (context, day) {
              final locale = Localizations.localeOf(context).toString();
              final title = DateFormat.yMMMM(locale).format(day);
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: widget.onViewModeTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.divider),
                        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.viewModeLabel ?? '월',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(width: 2),
                          const Icon(Icons.arrow_drop_down, size: 14),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          : null,

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
      // 기본 날짜 빌더
      defaultBuilder: (context, date, focusedDay) {
        return _buildDayCell(date, isOutside: false);
      },
      outsideBuilder: (context, date, focusedDay) {
        return _buildDayCell(date, isOutside: true);
      },
      todayBuilder: (context, date, focusedDay) {
        return _buildDayCell(date, isOutside: false, isToday: true);
      },
      selectedBuilder: (context, date, focusedDay) {
        return _buildDayCell(date, isOutside: false, isSelected: true);
      },
      markerBuilder: (context, date, events) {
        if (events.isEmpty) return null;

        final dateKey = DateTime(date.year, date.month, date.day);
        final slotMap = _multiDaySlotMap[dateKey] ?? {};

        // 멀티데이/단일 분리
        final multiDayEvents = <TaskModel>[];
        final singleDayEvents = <TaskModel>[];
        for (final task in events) {
          final pos = _getMultiDayPosition(task, date);
          (pos == MultiDayPosition.single ? singleDayEvents : multiDayEvents)
              .add(task);
        }

        // ── 슬롯 할당 ──────────────────────────────────────────────
        const kMaxSlots = 3;
        const kBarH = 13.0;
        const kSlotH = kBarH + 2.0; // 위아래 1px 여백

        final totalEvents = multiDayEvents.length + singleDayEvents.length;
        // 이벤트가 슬롯 수 초과 시 마지막 슬롯을 "+N 더" 칩으로 예약
        final kFillSlots = totalEvents > kMaxSlots ? kMaxSlots - 1 : kMaxSlots;

        final slotTask = <int, TaskModel>{};
        for (final task in multiDayEvents) {
          final s = slotMap[task.id];
          if (s != null && s < kFillSlots) slotTask[s] = task;
        }
        int singleIdx = 0;
        for (int s = 0; s < kFillSlots && singleIdx < singleDayEvents.length; s++) {
          if (!slotTask.containsKey(s)) slotTask[s] = singleDayEvents[singleIdx++];
        }

        final hiddenCount = totalEvents - slotTask.length;

        // ── 렌더링 ─────────────────────────────────────────────────
        // 셀 너비: 화면 너비 / 7 (table_calendar 기본 레이아웃 기준)
        final cellW = MediaQuery.of(context).size.width / 7;

        final chips = <Widget>[];
        for (int slot = 0; slot < kMaxSlots; slot++) {
          if (!slotTask.containsKey(slot)) continue;
          final task = slotTask[slot]!;
          final pos = _getMultiDayPosition(task, date);
          final bottom = 2.0 + (kMaxSlots - 1 - slot) * kSlotH;

          if (pos == MultiDayPosition.single) {
            // 단일 이벤트 칩
            final c = _taskColor(task);
            chips.add(Positioned(
              left: 0, right: 0, bottom: bottom,
              child: Container(
                height: kBarH,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: c.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(kBarH / 2),
                  border: Border.all(color: c.withValues(alpha: 0.6), width: 0.5),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                alignment: Alignment.centerLeft,
                child: Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 9.5, fontWeight: FontWeight.w600,
                    color: c, height: 1.1,
                  ),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
              ),
            ));
          } else {
            // 멀티데이 바
            // colIndex: 0=일, 1=월 … 6=토 (startingDayOfWeek.sunday 기준)
            final colIndex = date.weekday % 7;
            final isBarStart =
                pos == MultiDayPosition.start || colIndex == 0;

            if (!isBarStart) {
              // middle/end이고 행의 첫 셀이 아닌 경우:
              // start 셀의 overflow가 이 영역을 덮으므로 투명 플레이스홀더만 둠
              chips.add(Positioned(
                left: 0, right: 0, bottom: bottom,
                child: const SizedBox(height: kBarH),
              ));
              continue;
            }

            // 이 셀부터 이벤트가 몇 칸 남았는지 계산
            final daysLeftInRow = 7 - colIndex;
            final today = DateTime(date.year, date.month, date.day);
            final eventEnd = DateTime(
                task.dueAt!.year, task.dueAt!.month, task.dueAt!.day);
            final daysToEnd = eventEnd.difference(today).inDays + 1;
            final span = daysToEnd < daysLeftInRow ? daysToEnd : daysLeftInRow;
            final endsThisRow = daysToEnd <= daysLeftInRow;

            final leftM = pos == MultiDayPosition.start ? 2.0 : 0.0;
            final rightM = endsThisRow ? 2.0 : 0.0;
            final barW = span * cellW - leftM - rightM;

            final lr = pos == MultiDayPosition.start ? kBarH / 2 : 0.0;
            final rr = endsThisRow ? kBarH / 2 : 0.0;
            final c = _taskColor(task);

            chips.add(Positioned(
              left: leftM, width: barW, bottom: bottom,
              child: Container(
                height: kBarH,
                decoration: BoxDecoration(
                  color: c,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(lr),
                    bottomLeft: Radius.circular(lr),
                    topRight: Radius.circular(rr),
                    bottomRight: Radius.circular(rr),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                alignment: Alignment.centerLeft,
                child: Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 9.5, fontWeight: FontWeight.w600,
                    color: Colors.white, height: 1.1,
                  ),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
              ),
            ));
          }
        }

        // +N 더 칩: 슬롯 kMaxSlots-1 위치에 정식 칩으로 표시 (겹침 없음)
        if (hiddenCount > 0) {
          const overflowSlot = kMaxSlots - 1;
          chips.add(Positioned(
            left: 0,
            right: 0,
            bottom: 2.0 + (kMaxSlots - 1 - overflowSlot) * kSlotH, // = 2
            child: Container(
              height: kBarH,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(kBarH / 2),
                border: Border.all(
                  color: AppColors.textSecondary.withValues(alpha: 0.25),
                  width: 0.5,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '+$hiddenCount개',
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ));
        }

        if (chips.isEmpty) return null;

        return Positioned.fill(
          child: Stack(
            clipBehavior: Clip.none,
            children: chips,
          ),
        );
      },
    );
  }

  String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  bool _isHoliday(DateTime date) {
    final holidayMap = ref
        .watch(holidayMapForMonthProvider(date.year, date.month))
        .valueOrNull;
    if (holidayMap == null) return false;
    return holidayMap.containsKey(_dateKey(date));
  }

  bool _isSpecialDay(DateTime date) {
    final specialDayMap = ref
        .watch(specialDayMapForMonthProvider(date.year, date.month))
        .valueOrNull;
    if (specialDayMap == null) return false;
    return specialDayMap.containsKey(_dateKey(date));
  }

  /// 날짜 셀 빌더 (토요일 파란색, 일요일/공휴일 빨간색, 특별한 날 주황색)
  Widget _buildDayCell(
    DateTime date, {
    required bool isOutside,
    bool isSelected = false,
    bool isToday = false,
  }) {
    final holiday = _isHoliday(date);
    final specialDay = !holiday && _isSpecialDay(date);

    Color textColor;
    if (isSelected) {
      textColor = Colors.white;
    } else if (isOutside) {
      if (holiday || date.weekday == DateTime.sunday) {
        textColor = AppColors.error.withValues(alpha: 0.3);
      } else if (specialDay) {
        textColor = const Color(0xFF4CAF50).withValues(alpha: 0.3);
      } else if (date.weekday == DateTime.saturday) {
        textColor = AppColors.primary.withValues(alpha: 0.3);
      } else {
        textColor = AppColors.textSecondary.withValues(alpha: 0.5);
      }
    } else if (holiday || date.weekday == DateTime.sunday) {
      textColor = AppColors.error.withValues(alpha: 0.8);
    } else if (specialDay) {
      textColor = const Color(0xFF4CAF50).withValues(alpha: 0.9);
    } else if (date.weekday == DateTime.saturday) {
      textColor = AppColors.primary;
    } else {
      textColor = Theme.of(context).colorScheme.onSurface;
    }

    final dayNumColor = isToday && !isSelected ? AppColors.primary : textColor;

    Widget dayContent = Text(
      '${date.day}',
      style: TextStyle(
        color: dayNumColor,
        fontSize: 13,
        fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
      ),
    );

    if (isSelected) {
      return Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: dayContent,
          ),
        ),
      );
    }

    if (isToday) {
      return Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: dayContent,
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: dayContent,
      ),
    );
  }

}
