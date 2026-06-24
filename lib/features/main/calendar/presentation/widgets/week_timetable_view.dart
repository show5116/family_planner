import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/calendar/presentation/widgets/quick_task_sheet.dart';
import 'package:family_planner/core/utils/color_utils.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';

// ──────────────────────────────────────────────────────────────────────────────
// 상수
// ──────────────────────────────────────────────────────────────────────────────
const double _kHourHeight = 64.0;       // 1시간 행 높이 (픽셀)
const double _kTimeLabelWidth = 44.0;   // 왼쪽 시간 레이블 너비
const double _kMinBlockHeight = 28.0;   // 최소 일정 블록 높이
const double _kAllDayRowHeight = 28.0;  // 종일 이벤트 행 높이
const double _kDayHeaderHeight = 40.0;  // 요일 헤더 높이
const double _kMinDayWidth = 72.0;      // 날짜 열 최소 너비 (가로 스크롤 기준)

// ──────────────────────────────────────────────────────────────────────────────
// 메인 위젯
// ──────────────────────────────────────────────────────────────────────────────

/// 주간 타임테이블 뷰 (일~토 × 24시간 그리드)
class WeekTimetableView extends ConsumerStatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDaySelected;
  /// false면 요일/날짜 헤더 행을 생략 (CalendarView와 함께 사용 시)
  final bool showDayHeader;

  const WeekTimetableView({
    super.key,
    required this.selectedDate,
    required this.onDaySelected,
    this.showDayHeader = true,
  });

  @override
  ConsumerState<WeekTimetableView> createState() => _WeekTimetableViewState();
}

class _WeekTimetableViewState extends ConsumerState<WeekTimetableView> {
  final _scrollController = ScrollController();
  final _horizontalScrollController = ScrollController();
  bool _scrolledInitially = false;

  List<DateTime> get _weekDays {
    final date = widget.selectedDate;
    final dayOfWeek = date.weekday % 7; // 0=일, 6=토
    final sunday = DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: dayOfWeek));
    return List.generate(7, (i) => sunday.add(Duration(days: i)));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToNow());
  }

  void _scrollToNow() {
    if (!_scrollController.hasClients || _scrolledInitially) return;
    _scrolledInitially = true;
    final now = DateTime.now();
    final targetHour = max(0, now.hour - 1).toDouble();
    _scrollController.animateTo(
      targetHour * _kHourHeight,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  // allDay=true → 종일 영역 표시
  bool _isAllDayZone(TaskModel task) => task.allDay;

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(weekTasksProvider);
    final weekDays = _weekDays;

    final allDayTasks = tasks.where(_isAllDayZone).toList();
    // 시간이 있는 일정은 멀티데이 여부 관계없이 시간 그리드에서 처리
    final timedTasks = tasks.where((t) => !_isAllDayZone(t)).toList();

    return LayoutBuilder(builder: (context, constraints) {
      // 화면 너비에서 시간 레이블 너비를 뺀 공간이 최소 너비보다 작으면 가로 스크롤
      final availableWidth = constraints.maxWidth - _kTimeLabelWidth;
      final gridWidth = max(availableWidth, _kMinDayWidth * 7);

      return Column(
        children: [
          // ── 요일 헤더 (CalendarView와 같이 쓸 때는 숨김) ──────────
          if (widget.showDayHeader) ...[
            SingleChildScrollView(
              controller: _horizontalScrollController,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: SizedBox(
                width: gridWidth + _kTimeLabelWidth,
                child: _WeekDayHeader(
                  weekDays: weekDays,
                  selectedDate: widget.selectedDate,
                  onDaySelected: widget.onDaySelected,
                  dayWidth: gridWidth / 7,
                ),
              ),
            ),
            const Divider(height: 1),
          ],

          // ── 종일 이벤트 행 ─────────────────────────────────────────
          if (allDayTasks.isNotEmpty) ...[
            SingleChildScrollView(
              controller: _horizontalScrollController,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: SizedBox(
                width: gridWidth + _kTimeLabelWidth,
                child: _AllDayRow(
                  weekDays: weekDays,
                  tasks: allDayTasks,
                  dayWidth: gridWidth / 7,
                  onTaskTap: (task) => context.push('/calendar/detail', extra: {
                    'taskId': task.id,
                    'task': task,
                  }),
                ),
              ),
            ),
            const Divider(height: 1),
          ],

          // ── 시간 그리드 ────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _horizontalScrollController,
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                child: SizedBox(
                  width: gridWidth + _kTimeLabelWidth,
                  child: _TimeGrid(
                    weekDays: weekDays,
                    tasks: timedTasks,
                    selectedDate: widget.selectedDate,
                    gridWidth: gridWidth,
                    onTaskTap: (task) {
                      context.push('/calendar/detail', extra: {
                        'taskId': task.id,
                        'task': task,
                      });
                    },
                    onEmptyTap: (dateTime) {
                      showQuickTaskSheet(context, dateTime);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 요일 헤더
// ──────────────────────────────────────────────────────────────────────────────

class _WeekDayHeader extends StatelessWidget {
  final List<DateTime> weekDays;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDaySelected;
  final double dayWidth;

  const _WeekDayHeader({
    required this.weekDays,
    required this.selectedDate,
    required this.onDaySelected,
    required this.dayWidth,
  });

  static const _dayNames = ['일', '월', '화', '수', '목', '금', '토'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateTime.now();
    final todayKey = DateTime(today.year, today.month, today.day);
    final selKey = DateTime(
        selectedDate.year, selectedDate.month, selectedDate.day);

    return SizedBox(
      height: _kDayHeaderHeight,
      child: Row(
        children: [
          SizedBox(width: _kTimeLabelWidth),
          ...weekDays.asMap().entries.map((entry) {
            final i = entry.key;
            final day = entry.value;
            final dayKey = DateTime(day.year, day.month, day.day);
            final isToday = dayKey == todayKey;
            final isSelected = dayKey == selKey;

            Color textColor;
            if (i == 0) {
              textColor = AppColors.error;
            } else if (i == 6) {
              textColor = AppColors.primary;
            } else {
              textColor = theme.colorScheme.onSurface;
            }

            return SizedBox(
              width: dayWidth,
              child: GestureDetector(
                onTap: () => onDaySelected(day),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _dayNames[i],
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: textColor.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : isToday
                                ? AppColors.primary.withValues(alpha: 0.15)
                                : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${day.day}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : isToday
                                  ? AppColors.primary
                                  : textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 종일 이벤트 행 (span 바 방식)
// ──────────────────────────────────────────────────────────────────────────────

class _AllDayRow extends ConsumerWidget {
  final List<DateTime> weekDays;
  final List<TaskModel> tasks;
  final double dayWidth;
  final ValueChanged<TaskModel> onTaskTap;

  const _AllDayRow({
    required this.weekDays,
    required this.tasks,
    required this.dayWidth,
    required this.onTaskTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Group> groups = ref.watch(myGroupsProvider).valueOrNull ?? [];
    final personalHex = ref.watch(authProvider).user?['personalColor'] as String?;

    final weekStart = DateTime(weekDays.first.year, weekDays.first.month, weekDays.first.day);
    final weekEnd = DateTime(weekDays.last.year, weekDays.last.month, weekDays.last.day);

    // 각 task의 이번 주 내 startCol, endCol 계산
    final positioned = <_SpanTask>[];
    for (final task in tasks) {
      final taskStart = task.scheduledAt != null
          ? DateTime(task.scheduledAt!.year, task.scheduledAt!.month, task.scheduledAt!.day)
          : weekStart;
      final taskEnd = task.dueAt != null
          ? DateTime(task.dueAt!.year, task.dueAt!.month, task.dueAt!.day)
          : taskStart;

      // 이번 주와 교차하는 범위만 클리핑
      final clippedStart = taskStart.isBefore(weekStart) ? weekStart : taskStart;
      final clippedEnd = taskEnd.isAfter(weekEnd) ? weekEnd : taskEnd;

      final startCol = clippedStart.difference(weekStart).inDays;
      final endCol = clippedEnd.difference(weekStart).inDays;

      positioned.add(_SpanTask(task: task, startCol: startCol, endCol: endCol));
    }

    // 행(row) 배치: 겹치지 않도록 greedy로 row 할당
    final rowAssign = <String, int>{};
    final rowEnds = <int>[];  // row별 마지막 점유 endCol
    for (final sp in positioned) {
      int row = rowEnds.indexWhere((end) => sp.startCol > end);
      if (row == -1) {
        row = rowEnds.length;
        rowEnds.add(sp.endCol);
      } else {
        rowEnds[row] = sp.endCol;
      }
      rowAssign[sp.task.id] = row;
    }

    final rowCount = rowEnds.isEmpty ? 1 : rowEnds.length;
    const rowHeight = _kAllDayRowHeight;
    const rowGap = 2.0;
    const vertPad = 4.0;
    final totalHeight = rowCount * rowHeight + (rowCount - 1) * rowGap + vertPad * 2;

    return SizedBox(
      height: totalHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 왼쪽 '종일' 레이블
          SizedBox(
            width: _kTimeLabelWidth,
            child: Padding(
              padding: const EdgeInsets.only(top: vertPad + 6),
              child: Text(
                '종일',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ),
          ),
          // span 바 영역
          SizedBox(
            width: dayWidth * 7,
            height: totalHeight,
            child: Stack(
              children: positioned.map((sp) {
                final row = rowAssign[sp.task.id] ?? 0;
                final color = ColorUtils.taskColor(
                  groupId: sp.task.groupId,
                  groups: groups,
                  personalColorHex: personalHex,
                );
                final spanCols = sp.endCol - sp.startCol + 1;
                final barWidth = dayWidth * spanCols - 3;
                final left = dayWidth * sp.startCol + 1.5;
                final top = vertPad + row * (rowHeight + rowGap);

                // 시작/종료가 이번 주 경계에 clipping됐는지 여부
                final taskStart = sp.task.scheduledAt != null
                    ? DateTime(sp.task.scheduledAt!.year, sp.task.scheduledAt!.month, sp.task.scheduledAt!.day)
                    : weekStart;
                final taskEnd = sp.task.dueAt != null
                    ? DateTime(sp.task.dueAt!.year, sp.task.dueAt!.month, sp.task.dueAt!.day)
                    : taskStart;
                final clippedLeft = taskStart.isBefore(weekStart);
                final clippedRight = taskEnd.isAfter(weekEnd);

                final radius = BorderRadius.horizontal(
                  left: clippedLeft ? Radius.zero : const Radius.circular(4),
                  right: clippedRight ? Radius.zero : const Radius.circular(4),
                );

                return Positioned(
                  left: left,
                  top: top,
                  width: barWidth,
                  height: rowHeight,
                  child: GestureDetector(
                    onTap: () => onTaskTap(sp.task),
                    child: Stack(
                      children: [
                        // 배경 + 모서리
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.18),
                              borderRadius: radius,
                            ),
                          ),
                        ),
                        // 왼쪽 강조 바 (클리핑 안 된 경우만)
                        if (!clippedLeft)
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            width: 3,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        // 텍스트
                        Positioned.fill(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: clippedLeft ? 5 : 8,
                              right: 4,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                sp.task.title,
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: color,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// 종일 영역에 배치할 task의 주 내 컬럼 범위
class _SpanTask {
  final TaskModel task;
  final int startCol; // 0=일 ~ 6=토
  final int endCol;

  const _SpanTask({required this.task, required this.startCol, required this.endCol});
}

// ──────────────────────────────────────────────────────────────────────────────
// 시간 그리드
// ──────────────────────────────────────────────────────────────────────────────

class _TimeGrid extends ConsumerWidget {
  final List<DateTime> weekDays;
  final List<TaskModel> tasks;
  final DateTime selectedDate;
  final double gridWidth;
  final ValueChanged<TaskModel> onTaskTap;
  final void Function(DateTime dateTime)? onEmptyTap;

  const _TimeGrid({
    required this.weekDays,
    required this.tasks,
    required this.selectedDate,
    required this.gridWidth,
    required this.onTaskTap,
    this.onEmptyTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Group> groups =
        ref.watch(myGroupsProvider).valueOrNull ?? [];
    final personalHex =
        ref.watch(authProvider).user?['personalColor'] as String?;
    final now = DateTime.now();
    final todayKey = DateTime(now.year, now.month, now.day);
    final totalHeight = 24 * _kHourHeight;
    final dayWidth = gridWidth / 7;

    return SizedBox(
      height: totalHeight,
      width: gridWidth + _kTimeLabelWidth,
      child: Stack(
          children: [
            // ── 시간 레이블 + 가로 구분선 ────────────────────────
            ..._buildHourRows(context, totalHeight, gridWidth + _kTimeLabelWidth),

            // ── 세로 구분선 (날짜 사이) ───────────────────────────
            ..._buildVerticalLines(dayWidth),

            // ── 현재 시간 표시선 ───────────────────────────────────
            ..._buildCurrentTimeLine(now, todayKey, dayWidth),

            // ── 각 날짜별 일정 블록 ───────────────────────────────
            ...weekDays.asMap().entries.expand((entry) {
              final dayIndex = entry.key;
              final day = entry.value;
              final dayKey = DateTime(day.year, day.month, day.day);

              // 해당 날이 일정 기간(scheduledAt~dueAt)에 포함되는 모든 일정
              final dayTasks = tasks.where((t) {
                if (t.scheduledAt == null) return false;
                final tStart = DateTime(t.scheduledAt!.year,
                    t.scheduledAt!.month, t.scheduledAt!.day);
                final tEnd = t.dueAt != null
                    ? DateTime(t.dueAt!.year, t.dueAt!.month, t.dueAt!.day)
                    : tStart;
                return !dayKey.isBefore(tStart) && !dayKey.isAfter(tEnd);
              }).toList();

              return _buildDayTaskBlocks(
                context,
                dayTasks: dayTasks,
                dayIndex: dayIndex,
                dayKey: dayKey,
                dayWidth: dayWidth,
                groups: groups,
                personalHex: personalHex,
                onTap: onTaskTap,
              );
            }),

            // ── 빈 영역 탭 핸들러 (일정 블록 위에 translucent로 덮어 빈 곳만 반응) ──
            if (onEmptyTap != null)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTapUp: (details) {
                    final x = details.localPosition.dx - _kTimeLabelWidth;
                    if (x < 0) return;
                    final dayIndex = (x / dayWidth).floor().clamp(0, 6);
                    final day = weekDays[dayIndex];
                    final tappedHour = details.localPosition.dy / _kHourHeight;
                    final hour = tappedHour.floor().clamp(0, 23);
                    final minute = ((tappedHour - hour) * 60).floor();
                    final roundedMinute = (minute ~/ 15) * 15;
                    final dateTime = DateTime(
                      day.year, day.month, day.day, hour, roundedMinute,
                    );
                    onEmptyTap!(dateTime);
                  },
                ),
              ),
          ],
        ),
      );
  }

  List<Widget> _buildHourRows(
      BuildContext context, double totalHeight, double totalWidth) {
    return List.generate(24, (hour) {
      final top = hour * _kHourHeight;
      return Positioned(
        left: 0,
        right: 0,
        top: top,
        height: _kHourHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 시간 레이블
            SizedBox(
              width: _kTimeLabelWidth,
              child: Padding(
                padding: const EdgeInsets.only(top: 2, right: 6),
                child: Text(
                  '${hour.toString().padLeft(2, '0')}:00',
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                ),
              ),
            ),
            // 가로 구분선
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context)
                          .dividerColor
                          .withValues(alpha: 0.5),
                      width: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  List<Widget> _buildVerticalLines(double dayWidth) {
    return List.generate(6, (i) {
      return Positioned(
        left: _kTimeLabelWidth + dayWidth * (i + 1),
        top: 0,
        bottom: 0,
        width: 0.5,
        child: Container(
          color: AppColors.divider.withValues(alpha: 0.3),
        ),
      );
    });
  }

  List<Widget> _buildCurrentTimeLine(
      DateTime now, DateTime todayKey, double dayWidth) {
    // 오늘이 이 주에 포함되는지 확인
    final todayIndex = weekDays.indexWhere((d) =>
        DateTime(d.year, d.month, d.day) == todayKey);
    if (todayIndex < 0) return [];

    final top = now.hour * _kHourHeight +
        now.minute * _kHourHeight / 60;

    return [
      Positioned(
        left: _kTimeLabelWidth + dayWidth * todayIndex,
        width: dayWidth,
        top: top - 1,
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Container(
                height: 2,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildDayTaskBlocks(
    BuildContext context, {
    required List<TaskModel> dayTasks,
    required int dayIndex,
    required DateTime dayKey,
    required double dayWidth,
    required List<Group> groups,
    required String? personalHex,
    required ValueChanged<TaskModel> onTap,
  }) {
    if (dayTasks.isEmpty) return [];

    // 겹침 계산 (scheduledAt 기준 — 시작일이 같은 일정끼리만 겹침 처리)
    final overlap = _computeOverlap(dayTasks);
    final dayLeft = _kTimeLabelWidth + dayWidth * dayIndex;
    const horizontalPadding = 2.0;

    return dayTasks.map((task) {
      final scheduledAt = task.scheduledAt!;
      final taskStartDay = DateTime(scheduledAt.year, scheduledAt.month, scheduledAt.day);
      final isStartDay = taskStartDay == dayKey;

      // 이 날의 블록 시작 시각
      // - 시작일: scheduledAt 시각
      // - 중간/종료일: 00:00 (하루 전체)
      final blockStartHour = isStartDay ? scheduledAt.hour + scheduledAt.minute / 60.0 : 0.0;
      final topOffset = blockStartHour * _kHourHeight;

      // 이 날의 블록 종료 시각
      // - dueAt이 이 날인 경우: dueAt 시각
      // - dueAt이 이 날 이후인 경우(중간일 or 시작일로 다음 날까지 이어짐): 24:00 (하루 끝)
      // - dueAt 없음: 시작일 기준 1시간
      double blockEndHour;
      if (task.dueAt != null) {
        final dueDay = DateTime(task.dueAt!.year, task.dueAt!.month, task.dueAt!.day);
        if (dueDay == dayKey) {
          blockEndHour = task.dueAt!.hour + task.dueAt!.minute / 60.0;
          if (blockEndHour <= blockStartHour) blockEndHour = blockStartHour + 1;
        } else {
          blockEndHour = 24.0;
        }
      } else {
        blockEndHour = blockStartHour + 1;
      }

      final durationHours = blockEndHour - blockStartHour;
      final blockHeight = max(durationHours * _kHourHeight, _kMinBlockHeight);

      final info = overlap[task.id] ?? (col: 0, total: 1);
      final colWidth = (dayWidth - horizontalPadding * 2) / info.total;
      final blockLeft = dayLeft + horizontalPadding + info.col * colWidth;

      final color = ColorUtils.taskColor(
        groupId: task.groupId,
        groups: groups,
        personalColorHex: personalHex,
      );

      // 멀티데이일 때 이 날의 위치에 따라 모서리/border 결정
      final isEndDay = task.dueAt != null &&
          DateTime(task.dueAt!.year, task.dueAt!.month, task.dueAt!.day) == dayKey;
      final isMultiDay = task.dueAt != null && taskStartDay != DateTime(task.dueAt!.year, task.dueAt!.month, task.dueAt!.day);
      final roundTop = isStartDay || !isMultiDay;
      final roundBottom = !isMultiDay || isEndDay;

      final showTime = isStartDay && blockHeight > _kMinBlockHeight + 14;
      final titleMaxLines = isStartDay && blockHeight > _kMinBlockHeight + 24 ? 2 : 1;
      // 시작일에만 제목 표시
      final showTitle = isStartDay;

      return Positioned(
        left: blockLeft,
        top: topOffset + 1,
        width: colWidth - 2,
        height: blockHeight - 2,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onTap(task),
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.vertical(
                top: roundTop ? const Radius.circular(AppSizes.radiusSmall) : Radius.zero,
                bottom: roundBottom ? const Radius.circular(AppSizes.radiusSmall) : Radius.zero,
              ),
              border: Border(
                left: BorderSide(color: color, width: 3),
                top: roundTop ? BorderSide.none : BorderSide(color: color.withValues(alpha: 0.2), width: 0.5),
              ),
            ),
            padding:
                const EdgeInsets.only(left: 5, top: 2, right: 3, bottom: 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showTitle) Text(
                  task.title,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        height: 1.2,
                      ),
                  maxLines: titleMaxLines,
                  overflow: TextOverflow.ellipsis,
                ),
                if (showTime)
                  Text(
                    '${scheduledAt.hour.toString().padLeft(2, '0')}:${scheduledAt.minute.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: color.withValues(alpha: 0.7),
                          fontSize: 10,
                          height: 1.2,
                        ),
                  ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  /// 일정 겹침 계산 → 각 task의 column index와 total columns 반환
  Map<String, ({int col, int total})> _computeOverlap(
      List<TaskModel> tasks) {
    final sorted = [...tasks]
      ..sort((a, b) => a.scheduledAt!.compareTo(b.scheduledAt!));

    // columns[i] = i번 열의 마지막 종료 시각
    final columnEnds = <DateTime>[];
    final taskCol = <String, int>{};

    for (final task in sorted) {
      final start = task.scheduledAt!;
      final end = task.dueAt ?? start.add(const Duration(hours: 1));

      int col = -1;
      for (int i = 0; i < columnEnds.length; i++) {
        if (!start.isBefore(columnEnds[i])) {
          col = i;
          columnEnds[i] = end;
          break;
        }
      }
      if (col == -1) {
        col = columnEnds.length;
        columnEnds.add(end);
      }
      taskCol[task.id] = col;
    }

    final total = columnEnds.length;
    return {
      for (final task in sorted)
        task.id: (col: taskCol[task.id]!, total: total),
    };
  }
}
