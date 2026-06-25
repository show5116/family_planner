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

const double _kHourHeight = 64.0;
const double _kTimeLabelWidth = 52.0;
const double _kMinBlockHeight = 28.0;
const double _kAllDayRowHeight = 28.0;
const double _kDayHeaderHeight = 72.0;

/// 일간 타임테이블 뷰 (하루 × 24시간 그리드)
class DayView extends ConsumerStatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDayChanged;
  final VoidCallback? onViewModeTap;
  final String? viewModeLabel;

  const DayView({
    super.key,
    required this.selectedDate,
    required this.onDayChanged,
    this.onViewModeTap,
    this.viewModeLabel,
  });

  @override
  ConsumerState<DayView> createState() => _DayViewState();
}

class _DayViewState extends ConsumerState<DayView> {
  final _scrollController = ScrollController();
  bool _scrolledInitially = false;

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

  @override
  Widget build(BuildContext context) {
    final selectedDay = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
    );

    // 해당 월의 일정 가져오기
    final tasksAsync = ref.watch(
      monthlyTasksProvider(selectedDay.year, selectedDay.month),
    );
    final allTasks = tasksAsync.valueOrNull ?? [];

    // 오늘 날짜에 속하는 일정 필터링
    final dayTasks = allTasks.where((task) {
      if (task.type == TaskType.todoOnly) return false;
      if (task.scheduledAt == null) return false;
      final tStart = DateTime(
          task.scheduledAt!.year, task.scheduledAt!.month, task.scheduledAt!.day);
      final tEnd = task.dueAt != null
          ? DateTime(task.dueAt!.year, task.dueAt!.month, task.dueAt!.day)
          : tStart;
      return !selectedDay.isBefore(tStart) && !selectedDay.isAfter(tEnd);
    }).toList();

    final allDayTasks = dayTasks.where((t) => t.allDay).toList();
    final timedTasks = dayTasks.where((t) => !t.allDay).toList();

    return Column(
      children: [
        // ── 날짜 헤더 ─────────────────────────────────────────────
        _DayHeader(
          date: widget.selectedDate,
          onPrevDay: () => widget.onDayChanged(
              widget.selectedDate.subtract(const Duration(days: 1))),
          onNextDay: () =>
              widget.onDayChanged(widget.selectedDate.add(const Duration(days: 1))),
          onViewModeTap: widget.onViewModeTap,
          viewModeLabel: widget.viewModeLabel,
        ),
        const Divider(height: 1),

        // ── 종일 이벤트 행 ─────────────────────────────────────────
        if (allDayTasks.isNotEmpty) ...[
          _AllDaySection(
            tasks: allDayTasks,
            onTaskTap: (task) => context.push('/calendar/detail', extra: {
              'taskId': task.id,
              'task': task,
            }),
          ),
          const Divider(height: 1),
        ],

        // ── 시간 그리드 ────────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: _DayTimeGrid(
              date: selectedDay,
              tasks: timedTasks,
              scrollController: _scrollController,
              onTaskTap: (task) => context.push('/calendar/detail', extra: {
                'taskId': task.id,
                'task': task,
              }),
              onEmptyTap: (dateTime) =>
                  showQuickTaskSheet(context, dateTime),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 날짜 헤더
// ─────────────────────────────────────────────────────────────────────────────

class _DayHeader extends StatelessWidget {
  final DateTime date;
  final VoidCallback onPrevDay;
  final VoidCallback onNextDay;
  final VoidCallback? onViewModeTap;
  final String? viewModeLabel;

  const _DayHeader({
    required this.date,
    required this.onPrevDay,
    required this.onNextDay,
    this.onViewModeTap,
    this.viewModeLabel,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final now = DateTime.now();
    final isToday = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;

    final weekday = date.weekday;
    final isSunday = weekday == DateTime.sunday;
    final isSaturday = weekday == DateTime.saturday;

    Color dayColor;
    if (isSunday) {
      dayColor = AppColors.error;
    } else if (isSaturday) {
      dayColor = AppColors.primary;
    } else {
      dayColor = Theme.of(context).colorScheme.onSurface;
    }

    final dateStr = DateFormat('M월 d일 (E)', locale).format(date);

    return SizedBox(
      height: _kDayHeaderHeight,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onPrevDay,
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity != null) {
                  if (details.primaryVelocity! < -300) onNextDay();
                  if (details.primaryVelocity! > 300) onPrevDay();
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dateStr,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: dayColor,
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
                                  viewModeLabel ?? '일',
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
                  if (isToday)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '오늘',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onNextDay,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 종일 섹션
// ─────────────────────────────────────────────────────────────────────────────

class _AllDaySection extends ConsumerWidget {
  final List<TaskModel> tasks;
  final ValueChanged<TaskModel> onTaskTap;

  const _AllDaySection({
    required this.tasks,
    required this.onTaskTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Group> groups = ref.watch(myGroupsProvider).valueOrNull ?? [];
    final personalHex = ref.watch(authProvider).user?['personalColor'] as String?;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: _kTimeLabelWidth,
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                '종일',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: tasks.map((task) {
                final color = ColorUtils.taskColor(
                  groupId: task.groupId,
                  groups: groups,
                  personalColorHex: personalHex,
                );
                return GestureDetector(
                  onTap: () => onTaskTap(task),
                  child: Container(
                    height: _kAllDayRowHeight,
                    margin: const EdgeInsets.only(bottom: 2),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          width: 3,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(AppSizes.radiusSmall),
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 4),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                task.title,
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

// ─────────────────────────────────────────────────────────────────────────────
// 시간 그리드
// ─────────────────────────────────────────────────────────────────────────────

class _DayTimeGrid extends ConsumerWidget {
  final DateTime date;
  final List<TaskModel> tasks;
  final ValueChanged<TaskModel> onTaskTap;
  final void Function(DateTime dateTime)? onEmptyTap;
  final ScrollController scrollController;

  const _DayTimeGrid({
    required this.date,
    required this.tasks,
    required this.onTaskTap,
    required this.scrollController,
    this.onEmptyTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Group> groups = ref.watch(myGroupsProvider).valueOrNull ?? [];
    final personalHex = ref.watch(authProvider).user?['personalColor'] as String?;
    final now = DateTime.now();
    final isToday = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
    final totalHeight = 24 * _kHourHeight;

    return LayoutBuilder(builder: (context, constraints) {
      final gridWidth = constraints.maxWidth - _kTimeLabelWidth;

      return SizedBox(
        height: totalHeight,
        child: Stack(
          children: [
            // ── 시간 레이블 + 구분선 ───────────────────────────────
            ..._buildHourRows(context, gridWidth),

            // ── 현재 시간 표시선 ───────────────────────────────────
            if (isToday) ..._buildCurrentTimeLine(now, gridWidth),

            // ── 빈 영역 탭 핸들러 (일정 블록 아래 — 빈 곳만 반응) ──
            if (onEmptyTap != null)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTapUp: (details) {
                    final tappedHour =
                        details.localPosition.dy / _kHourHeight;
                    final hour = tappedHour.floor().clamp(0, 23);
                    final minute = ((tappedHour - hour) * 60).floor();
                    final roundedMinute = (minute ~/ 15) * 15;
                    final dateTime = DateTime(
                      date.year, date.month, date.day, hour, roundedMinute,
                    );
                    onEmptyTap!(dateTime);
                  },
                ),
              ),

            // ── 일정 블록 (오버레이 위 — 일정 영역 탭을 흡수) ───────
            ..._buildTaskBlocks(context, gridWidth, groups, personalHex, scrollController),
          ],
        ),
      );
    });
  }

  List<Widget> _buildHourRows(BuildContext context, double gridWidth) {
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
            SizedBox(
              width: _kTimeLabelWidth,
              child: Padding(
                padding: const EdgeInsets.only(top: 2, right: 8),
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
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color:
                          Theme.of(context).dividerColor.withValues(alpha: 0.5),
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

  List<Widget> _buildCurrentTimeLine(DateTime now, double gridWidth) {
    final top = now.hour * _kHourHeight + now.minute * _kHourHeight / 60;
    return [
      Positioned(
        left: _kTimeLabelWidth,
        right: 0,
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
              child: Container(height: 2, color: AppColors.error),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildTaskBlocks(
    BuildContext context,
    double gridWidth,
    List<Group> groups,
    String? personalHex,
    ScrollController scrollController,
  ) {
    if (tasks.isEmpty) return [];

    final overlap = _computeOverlap(tasks);
    const horizontalPadding = 2.0;

    return tasks.map((task) {
      final scheduledAt = task.scheduledAt!;
      final taskStartDay =
          DateTime(scheduledAt.year, scheduledAt.month, scheduledAt.day);
      final isStartDay = taskStartDay == date;

      final blockStartHour =
          isStartDay ? scheduledAt.hour + scheduledAt.minute / 60.0 : 0.0;
      final topOffset = blockStartHour * _kHourHeight;

      double blockEndHour;
      if (task.dueAt != null) {
        final dueDay = DateTime(
            task.dueAt!.year, task.dueAt!.month, task.dueAt!.day);
        if (dueDay == date) {
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
      final colWidth = (gridWidth - horizontalPadding * 2) / info.total;
      final blockLeft = _kTimeLabelWidth + horizontalPadding + info.col * colWidth;

      final isEndDay = task.dueAt != null &&
          DateTime(task.dueAt!.year, task.dueAt!.month, task.dueAt!.day) ==
              date;
      final isMultiDay = task.dueAt != null &&
          taskStartDay !=
              DateTime(task.dueAt!.year, task.dueAt!.month, task.dueAt!.day);
      final roundTop = isStartDay || !isMultiDay;
      final roundBottom = !isMultiDay || isEndDay;

      final titleMaxLines = blockHeight > _kMinBlockHeight + 16 ? 2 : 1;

      final color = ColorUtils.taskColor(
        groupId: task.groupId,
        groups: groups,
        personalColorHex: personalHex,
      );

      return Positioned(
        left: blockLeft,
        top: topOffset + 1,
        width: colWidth - 2,
        height: blockHeight - 2,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onTaskTap(task),
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
                  : Border(top: BorderSide(color: color.withValues(alpha: 0.4), width: 0.5)),
            ),
            padding: EdgeInsets.zero,
            child: ListenableBuilder(
              listenable: scrollController,
              builder: (context, _) {
                if (!isStartDay) return const SizedBox.shrink();
                final scrollOffset = scrollController.hasClients
                    ? scrollController.offset
                    : 0.0;
                final stickyOffset =
                    (scrollOffset - topOffset).clamp(0.0, blockHeight - 20);
                return Stack(
                  children: [
                    Positioned(
                      top: stickyOffset + 2,
                      left: 4,
                      right: 3,
                      child: Text(
                        task.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                          height: 1.25,
                        ),
                        maxLines: titleMaxLines,
                        overflow: TextOverflow.ellipsis,
                      ),
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
