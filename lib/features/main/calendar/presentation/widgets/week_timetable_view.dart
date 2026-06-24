import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
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
const double _kMinBlockHeight = 22.0;   // 최소 일정 블록 높이
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
    super.dispose();
  }

  bool _isMultiDay(TaskModel task) {
    if (task.scheduledAt == null || task.dueAt == null) return false;
    final s = DateTime(
        task.scheduledAt!.year, task.scheduledAt!.month, task.scheduledAt!.day);
    final e = DateTime(task.dueAt!.year, task.dueAt!.month, task.dueAt!.day);
    return s != e;
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(weekTasksProvider);
    final weekDays = _weekDays;

    final allDayTasks = tasks.where(_isMultiDay).toList();
    final timedTasks = tasks.where((t) => !_isMultiDay(t)).toList();

    return Column(
      children: [
        // ── 요일 헤더 (CalendarView와 같이 쓸 때는 숨김) ──────────
        if (widget.showDayHeader) ...[
          _WeekDayHeader(
            weekDays: weekDays,
            selectedDate: widget.selectedDate,
            onDaySelected: widget.onDaySelected,
          ),
          const Divider(height: 1),
        ],

        // ── 종일 이벤트 행 ─────────────────────────────────────────
        if (allDayTasks.isNotEmpty) ...[
          _AllDayRow(weekDays: weekDays, tasks: allDayTasks),
          const Divider(height: 1),
        ],

        // ── 시간 그리드 ────────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: _TimeGrid(
              weekDays: weekDays,
              tasks: timedTasks,
              selectedDate: widget.selectedDate,
              onTaskTap: (task) {
                context.push('/calendar/detail', extra: {
                  'taskId': task.id,
                  'task': task,
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 요일 헤더
// ──────────────────────────────────────────────────────────────────────────────

class _WeekDayHeader extends StatelessWidget {
  final List<DateTime> weekDays;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDaySelected;

  const _WeekDayHeader({
    required this.weekDays,
    required this.selectedDate,
    required this.onDaySelected,
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
          // 왼쪽 레이블 열과 폭 맞추기
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

            return Expanded(
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
// 종일 이벤트 행
// ──────────────────────────────────────────────────────────────────────────────

class _AllDayRow extends ConsumerWidget {
  final List<DateTime> weekDays;
  final List<TaskModel> tasks;

  const _AllDayRow({required this.weekDays, required this.tasks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Group> groups =
        ref.watch(myGroupsProvider).valueOrNull ?? [];
    final personalHex =
        ref.watch(authProvider).user?['personalColor'] as String?;

    return SizedBox(
      height: _kAllDayRowHeight + 8,
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
          ...weekDays.map((day) {
            final dayKey =
                DateTime(day.year, day.month, day.day);
            final dayTasks = tasks.where((t) {
              if (t.scheduledAt == null || t.dueAt == null) return false;
              final s = DateTime(t.scheduledAt!.year, t.scheduledAt!.month,
                  t.scheduledAt!.day);
              final e = DateTime(
                  t.dueAt!.year, t.dueAt!.month, t.dueAt!.day);
              return !dayKey.isBefore(s) && !dayKey.isAfter(e);
            }).toList();

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 1, vertical: 4),
                child: Column(
                  children: dayTasks.take(2).map((task) {
                    final color = ColorUtils.taskColor(
                      groupId: task.groupId,
                      groups: groups,
                      personalColorHex: personalHex,
                    );
                    return Container(
                      height: _kAllDayRowHeight,
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 2),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusSmall),
                        border: Border.all(
                            color: color.withValues(alpha: 0.4)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Text(
                          task.title,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: color,
                                    fontWeight: FontWeight.w600,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  }).toList(),
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
// 시간 그리드
// ──────────────────────────────────────────────────────────────────────────────

class _TimeGrid extends ConsumerWidget {
  final List<DateTime> weekDays;
  final List<TaskModel> tasks;
  final DateTime selectedDate;
  final ValueChanged<TaskModel> onTaskTap;

  const _TimeGrid({
    required this.weekDays,
    required this.tasks,
    required this.selectedDate,
    required this.onTaskTap,
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

    return LayoutBuilder(builder: (context, constraints) {
      final availableWidth = constraints.maxWidth - _kTimeLabelWidth;
      final dayWidth = availableWidth / 7;

      return SizedBox(
        height: totalHeight,
        child: Stack(
          children: [
            // ── 시간 레이블 + 가로 구분선 ────────────────────────
            ..._buildHourRows(context, totalHeight, constraints.maxWidth),

            // ── 세로 구분선 (날짜 사이) ───────────────────────────
            ..._buildVerticalLines(dayWidth),

            // ── 현재 시간 표시선 ───────────────────────────────────
            ..._buildCurrentTimeLine(now, todayKey, dayWidth),

            // ── 각 날짜별 일정 블록 ───────────────────────────────
            ...weekDays.asMap().entries.expand((entry) {
              final dayIndex = entry.key;
              final day = entry.value;
              final dayKey =
                  DateTime(day.year, day.month, day.day);

              final dayTasks = tasks.where((t) {
                if (t.scheduledAt == null) return false;
                final tDay = DateTime(t.scheduledAt!.year,
                    t.scheduledAt!.month, t.scheduledAt!.day);
                return tDay == dayKey;
              }).toList();

              return _buildDayTaskBlocks(
                context,
                dayTasks: dayTasks,
                dayIndex: dayIndex,
                dayWidth: dayWidth,
                groups: groups,
                personalHex: personalHex,
                onTap: onTaskTap,
              );
            }),
          ],
        ),
      );
    });
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
    required double dayWidth,
    required List<Group> groups,
    required String? personalHex,
    required ValueChanged<TaskModel> onTap,
  }) {
    if (dayTasks.isEmpty) return [];

    // 겹침 계산
    final overlap = _computeOverlap(dayTasks);
    final dayLeft = _kTimeLabelWidth + dayWidth * dayIndex;
    const horizontalPadding = 2.0;

    return dayTasks.map((task) {
      final start = task.scheduledAt!;
      final topOffset =
          start.hour * _kHourHeight + start.minute * _kHourHeight / 60;

      // 지속 시간 계산 (동일 날짜 dueAt만 사용)
      double durationMinutes = 60; // 기본 1시간
      if (task.dueAt != null) {
        final dueDay = DateTime(
            task.dueAt!.year, task.dueAt!.month, task.dueAt!.day);
        final startDay = DateTime(start.year, start.month, start.day);
        if (dueDay == startDay) {
          durationMinutes =
              task.dueAt!.difference(start).inMinutes.toDouble();
          if (durationMinutes <= 0) durationMinutes = 60;
        }
      }

      final blockHeight =
          max(durationMinutes / 60 * _kHourHeight, _kMinBlockHeight);

      final info = overlap[task.id] ?? (col: 0, total: 1);
      final colWidth = (dayWidth - horizontalPadding * 2) / info.total;
      final blockLeft = dayLeft + horizontalPadding + info.col * colWidth;

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
          onTap: () => onTap(task),
          child: Container(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              border: Border(
                left: BorderSide(color: color, width: 3),
              ),
            ),
            padding:
                const EdgeInsets.only(left: 5, top: 2, right: 2, bottom: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                  maxLines: blockHeight > _kMinBlockHeight + 12 ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (blockHeight > _kMinBlockHeight + 10)
                  Text(
                    '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: color.withValues(alpha: 0.7),
                          fontSize: 10,
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
