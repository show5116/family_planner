import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/main/calendar/providers/task_provider.dart';
import 'package:family_planner/features/main/calendar/data/models/task_model.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 일정 관리 탭 (월간 캘린더 뷰)
class CalendarTab extends ConsumerStatefulWidget {
  const CalendarTab({super.key});

  @override
  ConsumerState<CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends ConsumerState<CalendarTab> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedDate = ref.watch(selectedDateProvider);
    final focusedMonth = ref.watch(focusedMonthProvider);
    final selectedGroupId = ref.watch(selectedGroupIdProvider);
    final groupsAsync = ref.watch(myGroupsProvider);

    // 현재 보고 있는 월의 Task 데이터
    final tasksAsync = ref.watch(
      monthlyTasksProvider(focusedMonth.year, focusedMonth.month),
    );

    return Scaffold(
      appBar: AppBar(
        title: _buildGroupSelector(l10n, selectedGroupId, groupsAsync),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            tooltip: l10n.schedule_today,
            onPressed: _goToToday,
          ),
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: l10n.common_search,
            onPressed: () {
              // TODO: 일정 검색 기능
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'categories') {
                context.push('/calendar/categories');
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'categories',
                child: Row(
                  children: [
                    const Icon(Icons.category_outlined, size: 20),
                    const SizedBox(width: AppSizes.spaceS),
                    Text(l10n.category_management),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // 월간 캘린더
          _buildCalendar(tasksAsync),

          const Divider(height: 1),

          // 선택된 날짜 일정 목록
          Expanded(
            child: _buildSelectedDateTasks(selectedDate),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'calendar_fab',
        onPressed: () {
          context.push('/calendar/add', extra: selectedDate);
        },
        tooltip: l10n.schedule_add,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// 오늘 날짜로 이동
  void _goToToday() {
    final today = DateTime.now();
    setState(() {
      _focusedDay = today;
      _selectedDay = today;
    });
    ref.read(selectedDateProvider.notifier).state = today;
    ref.read(focusedMonthProvider.notifier).state = today;
  }

  /// 그룹 선택 드롭다운
  Widget _buildGroupSelector(
    AppLocalizations l10n,
    String? selectedGroupId,
    AsyncValue<List<Group>> groupsAsync,
  ) {
    return groupsAsync.when(
      data: (groups) {
        // 개인 + 그룹 목록
        final items = <DropdownMenuItem<String?>>[];

        // 개인 일정 옵션
        items.add(
          DropdownMenuItem<String?>(
            value: null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person, size: 20),
                const SizedBox(width: AppSizes.spaceS),
                Text(l10n.schedule_personal),
              ],
            ),
          ),
        );

        // 그룹 옵션들
        for (final group in groups) {
          items.add(
            DropdownMenuItem<String?>(
              value: group.id,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.group,
                    size: 20,
                    color: group.defaultColor != null
                        ? Color(int.parse('FF${group.defaultColor!.replaceFirst('#', '')}', radix: 16))
                        : null,
                  ),
                  const SizedBox(width: AppSizes.spaceS),
                  Text(
                    group.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        }

        return DropdownButtonHideUnderline(
          child: DropdownButton<String?>(
            value: selectedGroupId,
            items: items,
            onChanged: (value) {
              ref.read(selectedGroupIdProvider.notifier).state = value;
            },
            icon: const Icon(Icons.arrow_drop_down),
            isDense: true,
          ),
        );
      },
      loading: () => Text(l10n.nav_calendar),
      error: (error, stack) => Text(l10n.nav_calendar),
    );
  }

  /// 월간 캘린더 위젯
  Widget _buildCalendar(AsyncValue<List<TaskModel>> tasksAsync) {
    return TableCalendar<TaskModel>(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      locale: Localizations.localeOf(context).toString(),

      // 선택된 날짜
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),

      // 날짜 선택 시
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          ref.read(selectedDateProvider.notifier).state = selectedDay;
        }
      },

      // 페이지(월) 변경 시
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
        ref.read(focusedMonthProvider.notifier).state = focusedDay;
      },

      // 캘린더 포맷 변경 시
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },

      // 일정 데이터 로드 (해당 날짜의 Task 목록)
      eventLoader: (day) {
        return tasksAsync.maybeWhen(
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
                return !targetDay.isBefore(taskDate) &&
                    !targetDay.isAfter(dueDate);
              }

              final targetDay = DateTime(day.year, day.month, day.day);
              return taskDate == targetDay;
            }).toList();
          },
          orElse: () => <TaskModel>[],
        );
      },

      // 캘린더 스타일
      calendarStyle: CalendarStyle(
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
      ),

      // 헤더 스타일
      headerStyle: HeaderStyle(
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
        leftChevronIcon:
            const Icon(Icons.chevron_left, color: AppColors.primary),
        rightChevronIcon:
            const Icon(Icons.chevron_right, color: AppColors.primary),
      ),

      // 요일 스타일 (dowBuilder에서 커스텀 처리하므로 기본값 사용)
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.w600,
            ),
        weekendStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),

      // 캘린더 빌더 (커스텀 마커 + 토/일 색상 분리)
      calendarBuilders: CalendarBuilders(
        // 요일 헤더 빌더 (토요일 파란색, 일요일 빨간색)
        dowBuilder: (context, day) {
          final text = DateFormat.E(Localizations.localeOf(context).toString())
              .format(day);
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
          return _buildDayCell(date, isSelected: false, isToday: false);
        },
        // 선택된 날짜는 기본 스타일 사용 (selectedDecoration)
        // 오늘 날짜도 기본 스타일 사용 (todayDecoration)
        outsideBuilder: (context, date, focusedDay) {
          return _buildDayCell(date, isSelected: false, isToday: false, isOutside: true);
        },
        markerBuilder: (context, date, events) {
          if (events.isEmpty) return null;

          return Positioned(
            bottom: 1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                events.length > 3 ? 3 : events.length,
                (index) {
                  final task = events[index];
                  return Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 0.5),
                    decoration: BoxDecoration(
                      color: Color(task.colorValue),
                      shape: BoxShape.circle,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),

      // 제스처 및 애니메이션
      availableGestures: AvailableGestures.all,
      pageAnimationEnabled: true,
    );
  }

  /// 선택된 날짜의 Task 목록
  Widget _buildSelectedDateTasks(DateTime selectedDate) {
    final tasksAsync = ref.watch(selectedDateTasksProvider);
    final dateFormat =
        DateFormat.yMMMMd(Localizations.localeOf(context).toString());
    final timeFormat =
        DateFormat.jm(Localizations.localeOf(context).toString());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 선택된 날짜 헤더
        Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Row(
            children: [
              Icon(
                Icons.event_note,
                size: AppSizes.iconMedium,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSizes.spaceS),
              Text(
                dateFormat.format(selectedDate),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),

        // Task 목록
        Expanded(
          child: tasksAsync.when(
            data: (tasks) {
              if (tasks.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSizes.spaceM),
                itemCount: tasks.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSizes.spaceS),
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return _TaskListItem(
                    task: task,
                    timeFormat: timeFormat,
                    onTap: () {
                      context.push('/calendar/detail', extra: {
                        'taskId': task.id,
                        'task': task,
                      });
                    },
                    onToggleComplete: () {
                      ref.read(taskManagementProvider.notifier).toggleComplete(
                            task.id,
                            !task.isCompleted,
                            task.scheduledAt ?? DateTime.now(),
                          );
                    },
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => _buildErrorState(error.toString()),
          ),
        ),
      ],
    );
  }

  /// 일정 없음 상태
  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available,
            size: AppSizes.iconXLarge,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            l10n.home_noSchedule,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  /// 날짜 셀 빌더 (토요일 파란색, 일요일 빨간색)
  Widget _buildDayCell(
    DateTime date, {
    required bool isSelected,
    required bool isToday,
    bool isOutside = false,
  }) {
    Color textColor;

    if (isOutside) {
      textColor = AppColors.textSecondary.withValues(alpha: 0.5);
    } else if (date.weekday == DateTime.sunday) {
      // 일요일: 빨간색
      textColor = AppColors.error.withValues(alpha: 0.8);
    } else if (date.weekday == DateTime.saturday) {
      // 토요일: 파란색
      textColor = AppColors.primary;
    } else {
      // 평일: 기본 색상
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

  /// 에러 상태
  Widget _buildErrorState(String error) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: AppSizes.iconXLarge,
            color: AppColors.error,
          ),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            l10n.schedule_loadError,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            error,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spaceM),
          ElevatedButton.icon(
            onPressed: () {
              final focusedMonth = ref.read(focusedMonthProvider);
              ref.invalidate(
                monthlyTasksProvider(focusedMonth.year, focusedMonth.month),
              );
            },
            icon: const Icon(Icons.refresh),
            label: Text(l10n.common_retry),
          ),
        ],
      ),
    );
  }
}

/// Task 목록 아이템 위젯
class _TaskListItem extends StatelessWidget {
  final TaskModel task;
  final DateFormat timeFormat;
  final VoidCallback onTap;
  final VoidCallback onToggleComplete;

  const _TaskListItem({
    required this.task,
    required this.timeFormat,
    required this.onTap,
    required this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = Color(task.colorValue);

    return Card(
      elevation: AppSizes.elevation1,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Row(
            children: [
              // 완료 체크박스
              GestureDetector(
                onTap: onToggleComplete,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: task.isCompleted ? color : Colors.transparent,
                    border: Border.all(
                      color: color,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: task.isCompleted
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: AppSizes.spaceM),

              // 색상 표시 바
              Container(
                width: 4,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: AppSizes.spaceM),

              // Task 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 제목
                    Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: task.isCompleted
                                ? AppColors.textSecondary
                                : null,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSizes.spaceXS),

                    // 시간 / 종일 표시
                    Row(
                      children: [
                        Icon(
                          task.isAllDay
                              ? Icons.wb_sunny_outlined
                              : Icons.access_time,
                          size: AppSizes.iconSmall,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppSizes.spaceXS),
                        Text(
                          task.isAllDay
                              ? l10n.schedule_allDay
                              : task.scheduledAt != null
                                  ? timeFormat.format(task.scheduledAt!)
                                  : '-',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                        ),
                        // D-Day 표시
                        if (task.daysUntilDue != null) ...[
                          const SizedBox(width: AppSizes.spaceS),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getDdayColor(task.daysUntilDue!)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _formatDday(task.daysUntilDue!),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: _getDdayColor(task.daysUntilDue!),
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    // 장소 (있는 경우)
                    if (task.location != null && task.location!.isNotEmpty) ...[
                      const SizedBox(height: AppSizes.spaceXS),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: AppSizes.iconSmall,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: AppSizes.spaceXS),
                          Expanded(
                            child: Text(
                              task.location!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // 카테고리 이모지
              if (task.category?.emoji != null) ...[
                const SizedBox(width: AppSizes.spaceS),
                Text(
                  task.category!.emoji!,
                  style: const TextStyle(fontSize: 20),
                ),
              ],

              // 반복 아이콘
              if (task.recurring != null) ...[
                const SizedBox(width: AppSizes.spaceS),
                Icon(
                  Icons.repeat,
                  size: AppSizes.iconSmall,
                  color: AppColors.textSecondary,
                ),
              ],

              // 우선순위 아이콘
              if (task.priority != null &&
                  task.priority != TaskPriority.low) ...[
                const SizedBox(width: AppSizes.spaceS),
                Icon(
                  _getPriorityIcon(task.priority!),
                  size: AppSizes.iconSmall,
                  color: _getPriorityColor(task.priority!),
                ),
              ],

              const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// D-Day 포맷
  String _formatDday(int days) {
    if (days == 0) return 'D-Day';
    if (days > 0) return 'D-$days';
    return 'D+${days.abs()}';
  }

  /// D-Day 색상
  Color _getDdayColor(int days) {
    if (days < 0) return AppColors.error; // 지남
    if (days == 0) return AppColors.warning; // 오늘
    if (days <= 3) return AppColors.secondary; // 임박
    return AppColors.textSecondary;
  }

  /// 우선순위 아이콘
  IconData _getPriorityIcon(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.urgent:
        return Icons.priority_high;
      case TaskPriority.high:
        return Icons.arrow_upward;
      case TaskPriority.medium:
        return Icons.remove;
      case TaskPriority.low:
        return Icons.arrow_downward;
    }
  }

  /// 우선순위 색상
  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.urgent:
        return AppColors.error;
      case TaskPriority.high:
        return AppColors.secondary;
      case TaskPriority.medium:
        return AppColors.primary;
      case TaskPriority.low:
        return AppColors.textSecondary;
    }
  }
}
