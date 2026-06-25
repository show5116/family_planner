import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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

// ──────────────────────────────────────────────────────────────────────────────
// 메인 위젯
// ──────────────────────────────────────────────────────────────────────────────

/// 주간 타임테이블 뷰 (일~토 × 24시간 그리드)
class WeekTimetableView extends ConsumerStatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDaySelected;
  /// false면 요일/날짜 헤더 행을 생략 (CalendarView와 함께 사용 시)
  final bool showDayHeader;
  /// showDayHeader가 true일 때 이전/다음 주 이동 콜백
  final ValueChanged<DateTime>? onWeekChanged;
  /// 뷰 모드 버튼 탭 콜백
  final VoidCallback? onViewModeTap;
  /// 뷰 모드 레이블
  final String? viewModeLabel;

  const WeekTimetableView({
    super.key,
    required this.selectedDate,
    required this.onDaySelected,
    this.showDayHeader = true,
    this.onWeekChanged,
    this.onViewModeTap,
    this.viewModeLabel,
  });

  @override
  ConsumerState<WeekTimetableView> createState() => _WeekTimetableViewState();
}

class _WeekTimetableViewState extends ConsumerState<WeekTimetableView> {
  final _scrollController = ScrollController();
  bool _scrolledInitially = false;

  List<DateTime> get _weekDays {
    final date = widget.selectedDate;
    final dayOfWeek = date.weekday % 7; // 0=일, 6=토
    final sunday = DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: dayOfWeek));
    return List.generate(7, (i) => sunday.add(Duration(days: i)));
  }

  void _goToPrevWeek() {
    final firstDay = _weekDays.first;
    widget.onWeekChanged?.call(firstDay.subtract(const Duration(days: 1)));
  }

  void _goToNextWeek() {
    final lastDay = _weekDays.last;
    widget.onWeekChanged?.call(lastDay.add(const Duration(days: 1)));
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
    super.dispose();
  }

  // allDay=true → 종일 영역 표시
  bool _isAllDayZone(TaskModel task) => task.allDay;

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(weekTasksProvider);
    final groups = ref.watch(myGroupsProvider).valueOrNull ?? <Group>[];
    final personalHex = ref.watch(authProvider).user?['personalColor'] as String?;
    final weekDays = _weekDays;
    final allDayTasks = tasks.where(_isAllDayZone).toList();
    final timedTasks = tasks.where((t) => !_isAllDayZone(t)).toList();

    return LayoutBuilder(builder: (context, constraints) {
      final theme = Theme.of(context);
      final divColor = theme.dividerColor.withValues(alpha: 0.5);
      final double timeW = _kTimeLabelWidth;
      final double dayW = (constraints.maxWidth - timeW) / 7;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.showDayHeader)
            _WeekNavHeader(
              weekDays: weekDays,
              onPrevWeek: _goToPrevWeek,
              onNextWeek: _goToNextWeek,
              onViewModeTap: widget.onViewModeTap,
              viewModeLabel: widget.viewModeLabel,
            ),

          // 헤더 행: [빈칸] | [일] | [월] | [화] | [수] | [목] | [금] | [토]
          if (widget.showDayHeader)
            _buildDayHeaderRow(weekDays, timeW, dayW, divColor, theme),

          if (allDayTasks.isNotEmpty) ...[
            _AllDayRow(
              weekDays: weekDays,
              tasks: allDayTasks,
              dayWidth: dayW,
              onTaskTap: (task) => context.push('/calendar/detail', extra: {
                'taskId': task.id,
                'task': task,
              }),
            ),
            const Divider(height: 1),
          ],

          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragEnd: (details) {
                final v = details.primaryVelocity;
                if (v != null && v < -300) _goToNextWeek();
                if (v != null && v > 300) _goToPrevWeek();
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                child: _buildTimeGrid(
                  context,
                  weekDays: weekDays,
                  timedTasks: timedTasks,
                  timeW: timeW,
                  dayW: dayW,
                  divColor: divColor,
                  theme: theme,
                  groups: groups,
                  personalHex: personalHex,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  // ── 헤더 행 빌더 ────────────────────────────────────────────────────────────
  // 8칸 Row: [빈칸(border.right)] + [요일 셀(Expanded) × 7]
  // border.right으로 시간열/일요일 경계를 실제 셀 경계로 표현
  Widget _buildDayHeaderRow(
    List<DateTime> weekDays,
    double timeW,
    double dayW,
    Color divColor,
    ThemeData theme,
  ) {
    const dayNames = ['일', '월', '화', '수', '목', '금', '토'];
    final today = DateTime.now();
    final todayKey = DateTime(today.year, today.month, today.day);
    final selKey = DateTime(
        widget.selectedDate.year, widget.selectedDate.month, widget.selectedDate.day);

    return SizedBox(
      height: _kDayHeaderHeight,
      child: Row(
        children: [
          // 열 0: 빈 칸 — border.right이 시간열/일요일 경계선
          Container(
            width: timeW,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                right: BorderSide(color: divColor, width: 0.5),
                bottom: BorderSide(color: divColor, width: 0.5),
              ),
            ),
          ),
          // 열 1~7: 요일/날짜 셀
          ...weekDays.asMap().entries.map((e) {
            final i = e.key;
            final day = e.value;
            final dayKey = DateTime(day.year, day.month, day.day);
            final isToday = dayKey == todayKey;
            final isSelected = dayKey == selKey;
            final textColor = i == 0
                ? AppColors.error
                : i == 6
                    ? AppColors.primary
                    : theme.colorScheme.onSurface;

            return Expanded(
              child: GestureDetector(
                onTap: () => widget.onDaySelected(day),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    border: Border(
                      right: i < 6
                          ? BorderSide(color: divColor, width: 0.5)
                          : BorderSide.none,
                      bottom: BorderSide(color: divColor, width: 0.5),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayNames[i],
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
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── 시간 그리드 빌더 ─────────────────────────────────────────────────────────
  // Column(Row × 24): 각 Row = [시간칸(border.right)] + [날짜칸(Expanded) × 7]
  // Positioned 수직선 제거 — 셀 border.right으로 열 경계 표현
  Widget _buildTimeGrid(
    BuildContext context, {
    required List<DateTime> weekDays,
    required List<TaskModel> timedTasks,
    required double timeW,
    required double dayW,
    required Color divColor,
    required ThemeData theme,
    required List<Group> groups,
    required String? personalHex,
  }) {
    final now = DateTime.now();
    final todayKey = DateTime(now.year, now.month, now.day);

    return SizedBox(
      height: 24 * _kHourHeight,
      child: Stack(
        children: [
          // 그리드 배경: Column(Row × 24)
          Column(
            children: List.generate(24, (hour) => SizedBox(
              height: _kHourHeight,
              child: Row(
                children: [
                  // 시간 레이블 칸 (border.right = 시간열/일요일 실제 경계)
                  Container(
                    width: timeW,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: divColor, width: 0.5),
                        right: BorderSide(color: divColor, width: 0.5),
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 2, right: 4),
                    alignment: Alignment.topRight,
                    child: Text(
                      '${hour.toString().padLeft(2, '0')}:00',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  // 날짜 칸 7개 (border.right = 각 요일 경계)
                  ...List.generate(7, (i) => Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: divColor, width: 0.5),
                          right: i < 6
                              ? BorderSide(color: divColor, width: 0.5)
                              : BorderSide.none,
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            )),
          ),

          // 현재 시간 표시선
          ..._buildCurrentTimeLine(now, todayKey, weekDays, timeW, dayW),

          // 빈 영역 탭 → 간편 일정 생성
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTapUp: (details) {
                final x = details.localPosition.dx - timeW;
                if (x < 0) return;
                final dayIndex = (x / dayW).floor().clamp(0, 6);
                final day = weekDays[dayIndex];
                final tappedHour = details.localPosition.dy / _kHourHeight;
                final hour = tappedHour.floor().clamp(0, 23);
                final minute = ((tappedHour - hour) * 60).floor();
                final roundedMinute = (minute ~/ 15) * 15;
                showQuickTaskSheet(
                  context,
                  DateTime(day.year, day.month, day.day, hour, roundedMinute),
                );
              },
            ),
          ),

          // 일정 블록 오버레이
          ...weekDays.asMap().entries.expand((entry) {
            final dayIndex = entry.key;
            final day = entry.value;
            final dayKey = DateTime(day.year, day.month, day.day);
            final dayTasks = timedTasks.where((t) {
              if (t.scheduledAt == null) return false;
              final tStart = DateTime(
                  t.scheduledAt!.year, t.scheduledAt!.month, t.scheduledAt!.day);
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
              timeW: timeW,
              dayW: dayW,
              groups: groups,
              personalHex: personalHex,
              scrollController: _scrollController,
            );
          }),
        ],
      ),
    );
  }

  List<Widget> _buildCurrentTimeLine(
    DateTime now,
    DateTime todayKey,
    List<DateTime> weekDays,
    double timeW,
    double dayW,
  ) {
    final todayIndex =
        weekDays.indexWhere((d) => DateTime(d.year, d.month, d.day) == todayKey);
    if (todayIndex < 0) return [];
    final top = now.hour * _kHourHeight + now.minute * _kHourHeight / 60;
    return [
      Positioned(
        left: timeW + dayW * todayIndex,
        width: dayW,
        top: top - 1,
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration:
                  const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
            ),
            Expanded(child: Container(height: 2, color: AppColors.error)),
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
    required double timeW,
    required double dayW,
    required List<Group> groups,
    required String? personalHex,
    required ScrollController scrollController,
  }) {
    if (dayTasks.isEmpty) return [];

    final overlap = _computeOverlap(dayTasks);
    final dayLeft = timeW + dayW * dayIndex;
    const horizontalPadding = 2.0;

    return dayTasks.map((task) {
      final scheduledAt = task.scheduledAt!;
      final taskStartDay =
          DateTime(scheduledAt.year, scheduledAt.month, scheduledAt.day);
      final isStartDay = taskStartDay == dayKey;

      final blockStartHour =
          isStartDay ? scheduledAt.hour + scheduledAt.minute / 60.0 : 0.0;
      final topOffset = blockStartHour * _kHourHeight;

      double blockEndHour;
      if (task.dueAt != null) {
        final dueDay =
            DateTime(task.dueAt!.year, task.dueAt!.month, task.dueAt!.day);
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
      final colWidth = (dayW - horizontalPadding * 2) / info.total;
      final blockLeft = dayLeft + horizontalPadding + info.col * colWidth;

      final color = ColorUtils.taskColor(
        groupId: task.groupId,
        groups: groups,
        personalColorHex: personalHex,
      );

      final isEndDay = task.dueAt != null &&
          DateTime(task.dueAt!.year, task.dueAt!.month, task.dueAt!.day) == dayKey;
      final isMultiDay = task.dueAt != null &&
          taskStartDay !=
              DateTime(task.dueAt!.year, task.dueAt!.month, task.dueAt!.day);
      final roundTop = isStartDay || !isMultiDay;
      final roundBottom = !isMultiDay || isEndDay;

      final titleMaxLines = blockHeight > _kMinBlockHeight + 16 ? 2 : 1;
      final isNarrow = colWidth < 42;
      final canRotate = isNarrow && (blockHeight - 2) >= 52;

      return Positioned(
        left: blockLeft,
        top: topOffset + 1,
        width: colWidth - 2,
        height: blockHeight - 2,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => context.push('/calendar/detail',
              extra: {'taskId': task.id, 'task': task}),
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.82),
              borderRadius: BorderRadius.vertical(
                top: roundTop
                    ? const Radius.circular(AppSizes.radiusSmall)
                    : Radius.zero,
                bottom: roundBottom
                    ? const Radius.circular(AppSizes.radiusSmall)
                    : Radius.zero,
              ),
              border: roundTop
                  ? null
                  : Border(
                      top: BorderSide(
                          color: color.withValues(alpha: 0.4), width: 0.5)),
            ),
            padding: EdgeInsets.zero,
            child: ListenableBuilder(
              listenable: scrollController,
              builder: (context, _) {
                if (!isStartDay) return const SizedBox.shrink();

                final scrollOffset =
                    scrollController.hasClients ? scrollController.offset : 0.0;
                final stickyOffset =
                    (scrollOffset - topOffset).clamp(0.0, blockHeight - 20);

                final textWidget = canRotate
                    ? RotatedBox(
                        quarterTurns: 1,
                        child: Text(
                          task.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            height: 1.0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    : isNarrow
                        ? null
                        : Text(
                            task.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                              height: 1.25,
                            ),
                            maxLines: titleMaxLines,
                            overflow: TextOverflow.ellipsis,
                          );

                if (textWidget == null) return const SizedBox.shrink();

                return Stack(
                  children: [
                    Positioned(
                      top: stickyOffset + 2,
                      left: isNarrow ? 1 : 4,
                      right: isNarrow ? 1 : 3,
                      child: textWidget,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    }).toList();
  }

  Map<String, ({int col, int total})> _computeOverlap(List<TaskModel> tasks) {
    final sorted = [...tasks]
      ..sort((a, b) => a.scheduledAt!.compareTo(b.scheduledAt!));
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
      for (final task in sorted) task.id: (col: taskCol[task.id]!, total: total),
    };
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 주 내비게이션 헤더 (월/년 표시 + 이전/다음 주 버튼)
// ──────────────────────────────────────────────────────────────────────────────

class _WeekNavHeader extends StatelessWidget {
  final List<DateTime> weekDays;
  final VoidCallback onPrevWeek;
  final VoidCallback onNextWeek;
  final VoidCallback? onViewModeTap;
  final String? viewModeLabel;

  const _WeekNavHeader({
    required this.weekDays,
    required this.onPrevWeek,
    required this.onNextWeek,
    this.onViewModeTap,
    this.viewModeLabel,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final first = weekDays.first;
    final last = weekDays.last;
    final String monthLabel;
    if (first.month == last.month) {
      monthLabel = DateFormat('yyyy년 M월', locale).format(first);
    } else if (first.year == last.year) {
      monthLabel = '${DateFormat('M월', locale).format(first)} - ${DateFormat('M월', locale).format(last)}';
    } else {
      monthLabel = '${DateFormat('yyyy년 M월', locale).format(first)} - ${DateFormat('yyyy년 M월', locale).format(last)}';
    }

    return SizedBox(
      height: _kDayHeaderHeight,
      child: Row(
        children: [
          // 시간 레이블 너비만큼 공백 → 요일 헤더와 정렬
          const SizedBox(width: _kTimeLabelWidth),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onPrevWeek,
          ),
          Expanded(
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    monthLabel,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (onViewModeTap != null) ...[
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: onViewModeTap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).colorScheme.outlineVariant),
                          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              viewModeLabel ?? '주',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const Icon(Icons.arrow_drop_down, size: 14),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onNextWeek,
          ),
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
          SizedBox(
            width: _kTimeLabelWidth,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
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

