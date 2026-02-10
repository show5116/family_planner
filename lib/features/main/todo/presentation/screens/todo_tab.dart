import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/features/main/todo/presentation/widgets/todo_kanban_column.dart';
import 'package:family_planner/features/main/todo/presentation/widgets/todo_list_item.dart';
import 'package:family_planner/features/main/todo/presentation/widgets/todo_week_bar.dart';
import 'package:family_planner/features/main/calendar/presentation/widgets/calendar_group_selector.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 뷰 타입 (칸반/리스트)
enum TodoViewType { kanban, list }

/// 현재 뷰 타입 Provider
final todoViewTypeProvider = StateProvider<TodoViewType>((ref) => TodoViewType.kanban);

/// 모아 보기 섹션 타입
enum _OverviewSection { overdue, today, tomorrow, thisWeek, nextWeek, later, noDueDate }

/// 할일 관리 탭
class TodoTab extends ConsumerStatefulWidget {
  const TodoTab({super.key});

  @override
  ConsumerState<TodoTab> createState() => _TodoTabState();
}

class _TodoTabState extends ConsumerState<TodoTab> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final viewType = ref.watch(todoViewTypeProvider);
    final viewMode = ref.watch(todoViewModeProvider);
    final selectedDate = ref.watch(todoSelectedDateProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    // 모바일에서는 항상 리스트 뷰 사용
    final effectiveViewType = isMobile ? TodoViewType.list : viewType;
    final isOverview = viewMode == TodoViewMode.overview;

    return Scaffold(
      appBar: AppBar(
        title: const CalendarGroupSelector(),
        actions: [
          // 뷰 전환 버튼 (모바일에서는 숨김, 모아보기에서는 숨김)
          if (!isMobile && !isOverview)
            IconButton(
              icon: Icon(
                viewType == TodoViewType.kanban
                    ? Icons.view_list
                    : Icons.view_kanban,
              ),
              tooltip: viewType == TodoViewType.kanban
                  ? l10n.todo_viewList
                  : l10n.todo_viewKanban,
              onPressed: () {
                ref.read(todoViewTypeProvider.notifier).state =
                    viewType == TodoViewType.kanban
                        ? TodoViewType.list
                        : TodoViewType.kanban;
              },
            ),
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: l10n.common_search,
            onPressed: () {
              // TODO: 할일 검색 기능
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
          // 뷰 모드 전환 (날짜별 보기 / 모아 보기)
          _ViewModeToggle(viewMode: viewMode, l10n: l10n),
          const Divider(height: 1),

          // 날짜별 보기 모드일 때만 주간 바 + 날짜 헤더 표시
          if (!isOverview) ...[
            const TodoWeekBar(),
            const Divider(height: 1),
            _SelectedDateHeader(selectedDate: selectedDate, l10n: l10n),
          ],

          // 모아 보기일 때 완료 포함 헤더
          if (isOverview)
            _OverviewHeader(l10n: l10n),

          // 할일 목록
          Expanded(
            child: isOverview
                ? const _OverviewListView()
                : _DateViewContent(
                    effectiveViewType: effectiveViewType,
                    l10n: l10n,
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'todo_fab',
        onPressed: () {
          context.push('/todo/add');
        },
        tooltip: l10n.todo_add,
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// 뷰 모드 전환 토글
class _ViewModeToggle extends ConsumerWidget {
  final TodoViewMode viewMode;
  final AppLocalizations l10n;

  const _ViewModeToggle({
    required this.viewMode,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceS,
      ),
      child: Row(
        children: [
          Expanded(
            child: SegmentedButton<TodoViewMode>(
              segments: [
                ButtonSegment(
                  value: TodoViewMode.byDate,
                  label: Text(l10n.todo_viewByDate),
                  icon: const Icon(Icons.calendar_today, size: 16),
                ),
                ButtonSegment(
                  value: TodoViewMode.overview,
                  label: Text(l10n.todo_viewOverview),
                  icon: const Icon(Icons.list_alt, size: 16),
                ),
              ],
              selected: {viewMode},
              onSelectionChanged: (selected) {
                ref.read(todoViewModeProvider.notifier).state = selected.first;
              },
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 날짜별 보기 컨텐츠
class _DateViewContent extends ConsumerWidget {
  final TodoViewType effectiveViewType;
  final AppLocalizations l10n;

  const _DateViewContent({
    required this.effectiveViewType,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDateTasksAsync = ref.watch(todoSelectedDateTasksProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(todoTasksProvider(page: 1));
      },
      child: selectedDateTasksAsync.when(
        data: (tasks) {
          if (tasks.isEmpty) {
            return _EmptyState(l10n: l10n);
          }

          return effectiveViewType == TodoViewType.kanban
              ? _KanbanView(tasks: tasks)
              : _ListView(tasks: tasks);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _ErrorState(
          error: error.toString(),
          onRetry: () {
            ref.invalidate(todoTasksProvider(page: 1));
          },
          l10n: l10n,
        ),
      ),
    );
  }
}

/// 모아 보기 헤더 (완료 포함 체크박스)
class _OverviewHeader extends ConsumerWidget {
  final AppLocalizations l10n;

  const _OverviewHeader({required this.l10n});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showCompleted = ref.watch(showCompletedTodosProvider);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceS,
      ),
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      child: Row(
        children: [
          Text(
            l10n.todo_viewOverview,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              ref.read(showCompletedTodosProvider.notifier).state = !showCompleted;
            },
            borderRadius: BorderRadius.circular(4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    value: showCompleted,
                    onChanged: (value) {
                      ref.read(showCompletedTodosProvider.notifier).state = value ?? false;
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  l10n.todo_showCompleted,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 모아 보기 리스트 뷰
class _OverviewListView extends ConsumerWidget {
  const _OverviewListView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final overviewTasksAsync = ref.watch(todoOverviewTasksProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(todoOverviewTasksProvider);
      },
      child: overviewTasksAsync.when(
        data: (response) {
          final tasks = response.data;
          if (tasks.isEmpty) {
            return _EmptyState(l10n: l10n);
          }

          // 날짜 기준으로 섹션 분류
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final tomorrow = today.add(const Duration(days: 1));
          final thisWeekEnd = today.add(Duration(days: 7 - today.weekday));
          final nextWeekEnd = thisWeekEnd.add(const Duration(days: 7));

          final Map<_OverviewSection, List<TaskModel>> sections = {
            _OverviewSection.overdue: [],
            _OverviewSection.today: [],
            _OverviewSection.tomorrow: [],
            _OverviewSection.thisWeek: [],
            _OverviewSection.nextWeek: [],
            _OverviewSection.later: [],
            _OverviewSection.noDueDate: [],
          };

          for (final task in tasks) {
            final dueDate = task.dueAt ?? task.scheduledAt;
            if (dueDate == null) {
              sections[_OverviewSection.noDueDate]!.add(task);
              continue;
            }

            final normalizedDue = DateTime(dueDate.year, dueDate.month, dueDate.day);

            if (normalizedDue.isBefore(today)) {
              sections[_OverviewSection.overdue]!.add(task);
            } else if (normalizedDue == today) {
              sections[_OverviewSection.today]!.add(task);
            } else if (normalizedDue == tomorrow) {
              sections[_OverviewSection.tomorrow]!.add(task);
            } else if (!normalizedDue.isAfter(thisWeekEnd)) {
              sections[_OverviewSection.thisWeek]!.add(task);
            } else if (!normalizedDue.isAfter(nextWeekEnd)) {
              sections[_OverviewSection.nextWeek]!.add(task);
            } else {
              sections[_OverviewSection.later]!.add(task);
            }
          }

          // 비어있지 않은 섹션만 표시
          final activeSections = sections.entries
              .where((e) => e.value.isNotEmpty)
              .toList();

          return ListView.builder(
            padding: const EdgeInsets.all(AppSizes.spaceM),
            itemCount: activeSections.fold<int>(0, (sum, e) => sum + 1 + e.value.length),
            itemBuilder: (context, index) {
              // 섹션과 아이템 인덱스 계산
              int currentIndex = 0;
              for (final entry in activeSections) {
                // 섹션 헤더
                if (currentIndex == index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      top: currentIndex > 0 ? AppSizes.spaceL : 0,
                      bottom: AppSizes.spaceS,
                    ),
                    child: _OverviewSectionHeader(
                      section: entry.key,
                      count: entry.value.length,
                      l10n: l10n,
                    ),
                  );
                }
                currentIndex++;

                // 섹션 아이템들
                if (index < currentIndex + entry.value.length) {
                  final taskIndex = index - currentIndex;
                  final task = entry.value[taskIndex];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
                    child: TodoListItem(
                      task: task,
                      onTap: () {
                        context.push('/todo/detail', extra: {
                          'taskId': task.id,
                          'task': task,
                        });
                      },
                      onStatusChange: (newStatus) {
                        ref.read(taskManagementProvider.notifier).updateStatus(
                          task.id,
                          newStatus,
                          task.scheduledAt ?? task.dueAt ?? DateTime.now(),
                        );
                        ref.invalidate(todoOverviewTasksProvider);
                      },
                    ),
                  );
                }
                currentIndex += entry.value.length;
              }
              return const SizedBox.shrink();
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _ErrorState(
          error: error.toString(),
          onRetry: () {
            ref.invalidate(todoOverviewTasksProvider);
          },
          l10n: l10n,
        ),
      ),
    );
  }
}

/// 모아 보기 섹션 헤더
class _OverviewSectionHeader extends StatelessWidget {
  final _OverviewSection section;
  final int count;
  final AppLocalizations l10n;

  const _OverviewSectionHeader({
    required this.section,
    required this.count,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final (title, icon, color) = _getSectionInfo();

    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: AppSizes.spaceS),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(width: AppSizes.spaceS),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  (String, IconData, Color) _getSectionInfo() {
    switch (section) {
      case _OverviewSection.overdue:
        return (l10n.todo_overviewOverdue, Icons.warning_amber, AppColors.error);
      case _OverviewSection.today:
        return (l10n.todo_overviewToday, Icons.today, AppColors.primary);
      case _OverviewSection.tomorrow:
        return (l10n.todo_overviewTomorrow, Icons.event, AppColors.secondary);
      case _OverviewSection.thisWeek:
        return (l10n.todo_overviewThisWeek, Icons.date_range, AppColors.primary);
      case _OverviewSection.nextWeek:
        return (l10n.todo_overviewNextWeek, Icons.calendar_month, AppColors.textSecondary);
      case _OverviewSection.later:
        return (l10n.todo_overviewLater, Icons.schedule, AppColors.textSecondary);
      case _OverviewSection.noDueDate:
        return (l10n.todo_overviewNoDueDate, Icons.event_busy, AppColors.textSecondary);
    }
  }
}

/// 선택된 날짜 헤더
class _SelectedDateHeader extends ConsumerWidget {
  final DateTime selectedDate;
  final AppLocalizations l10n;

  const _SelectedDateHeader({
    required this.selectedDate,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isToday = selectedDate == today;
    final showCompleted = ref.watch(showCompletedTodosProvider);

    final dayNames = [
      l10n.schedule_daySun,
      l10n.schedule_dayMon,
      l10n.schedule_dayTue,
      l10n.schedule_dayWed,
      l10n.schedule_dayThu,
      l10n.schedule_dayFri,
      l10n.schedule_daySat,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceS,
      ),
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      child: Row(
        children: [
          Text(
            '${selectedDate.month}월 ${selectedDate.day}일 (${dayNames[selectedDate.weekday % 7]})',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isToday) ...[
            const SizedBox(width: AppSizes.spaceS),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                l10n.schedule_today,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          const Spacer(),
          // 완료된 항목 보기 체크박스
          InkWell(
            onTap: () {
              ref.read(showCompletedTodosProvider.notifier).state = !showCompleted;
            },
            borderRadius: BorderRadius.circular(4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    value: showCompleted,
                    onChanged: (value) {
                      ref.read(showCompletedTodosProvider.notifier).state = value ?? false;
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  l10n.todo_showCompleted,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 칸반 뷰 (태블릿/데스크톱 전용 - 가로 스크롤)
class _KanbanView extends ConsumerWidget {
  final List<TaskModel> tasks;

  const _KanbanView({required this.tasks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    // 상태별로 분류
    final pendingTasks = tasks.where((t) => t.isPending).toList();
    final inProgressTasks = tasks.where((t) => t.isInProgress).toList();
    final completedTasks = tasks.where((t) => t.isCompleted).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(AppSizes.spaceM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TodoKanbanColumn(
            title: l10n.todo_statusPending,
            icon: Icons.pending_outlined,
            color: AppColors.textSecondary,
            tasks: pendingTasks,
            onTaskTap: (task) {
              context.push('/todo/detail', extra: {
                'taskId': task.id,
                'task': task,
              });
            },
            onStatusChange: (task, status) {
              _updateStatus(ref, task, status);
            },
            onAcceptDrop: (task) {
              if (!task.isPending) {
                _updateStatus(ref, task, TaskStatus.pending);
              }
            },
          ),
          const SizedBox(width: AppSizes.spaceM),
          TodoKanbanColumn(
            title: l10n.todo_statusInProgress,
            icon: Icons.play_circle_outline,
            color: AppColors.primary,
            tasks: inProgressTasks,
            onTaskTap: (task) {
              context.push('/todo/detail', extra: {
                'taskId': task.id,
                'task': task,
              });
            },
            onStatusChange: (task, status) {
              _updateStatus(ref, task, status);
            },
            onAcceptDrop: (task) {
              if (!task.isInProgress) {
                _updateStatus(ref, task, TaskStatus.inProgress);
              }
            },
          ),
          const SizedBox(width: AppSizes.spaceM),
          TodoKanbanColumn(
            title: l10n.todo_statusCompleted,
            icon: Icons.check_circle_outline,
            color: AppColors.success,
            tasks: completedTasks,
            onTaskTap: (task) {
              context.push('/todo/detail', extra: {
                'taskId': task.id,
                'task': task,
              });
            },
            onStatusChange: (task, status) {
              _updateStatus(ref, task, status);
            },
            onAcceptDrop: (task) {
              if (!task.isCompleted) {
                _updateStatus(ref, task, TaskStatus.completed);
              }
            },
          ),
        ],
      ),
    );
  }

  void _updateStatus(WidgetRef ref, TaskModel task, TaskStatus status) {
    ref.read(taskManagementProvider.notifier).updateStatus(
      task.id,
      status,
      task.scheduledAt ?? task.dueAt ?? DateTime.now(),
    );
    ref.invalidate(todoTasksProvider(page: 1));
  }
}

/// 리스트 뷰
class _ListView extends ConsumerWidget {
  final List<TaskModel> tasks;

  const _ListView({required this.tasks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    // 상태 순서: 대기중 -> 진행중 -> 완료, 우선순위 높은 것 먼저
    final sortedTasks = List<TaskModel>.from(tasks)
      ..sort((a, b) {
        // 상태별 정렬 (대기중 -> 진행중 -> 완료)
        if (a.status != b.status) {
          return a.status.index.compareTo(b.status.index);
        }
        // 우선순위 높은 것 먼저
        final priorityA = a.priority?.index ?? 0;
        final priorityB = b.priority?.index ?? 0;
        return priorityB.compareTo(priorityA);
      });

    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      itemCount: sortedTasks.length,
      itemBuilder: (context, index) {
        final task = sortedTasks[index];

        // 섹션 헤더 표시 (상태별)
        final showHeader = index == 0 ||
            sortedTasks[index - 1].status != task.status;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeader) ...[
              if (index > 0) const SizedBox(height: AppSizes.spaceL),
              _SectionHeader(
                title: _getStatusTitle(l10n, task.status),
                icon: _getStatusIcon(task.status),
                color: _getStatusColor(task.status),
                count: tasks.where((t) => t.status == task.status).length,
              ),
              const SizedBox(height: AppSizes.spaceS),
            ],
            Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
              child: TodoListItem(
                task: task,
                onTap: () {
                  context.push('/todo/detail', extra: {
                    'taskId': task.id,
                    'task': task,
                  });
                },
                onStatusChange: (newStatus) {
                  ref.read(taskManagementProvider.notifier).updateStatus(
                    task.id,
                    newStatus,
                    task.scheduledAt ?? task.dueAt ?? DateTime.now(),
                  );
                  ref.invalidate(todoTasksProvider(page: 1));
                },
              ),
            ),
          ],
        );
      },
    );
  }

  String _getStatusTitle(AppLocalizations l10n, TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return l10n.todo_statusPending;
      case TaskStatus.inProgress:
        return l10n.todo_statusInProgress;
      case TaskStatus.completed:
        return l10n.todo_statusCompleted;
      case TaskStatus.hold:
        return l10n.todo_statusHold;
      case TaskStatus.drop:
        return l10n.todo_statusDrop;
      case TaskStatus.failed:
        return l10n.todo_statusFailed;
    }
  }

  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Icons.pending_outlined;
      case TaskStatus.inProgress:
        return Icons.play_circle_outline;
      case TaskStatus.completed:
        return Icons.check_circle_outline;
      case TaskStatus.hold:
        return Icons.pause_circle_outline;
      case TaskStatus.drop:
        return Icons.remove_circle_outline;
      case TaskStatus.failed:
        return Icons.error_outline;
    }
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return AppColors.textSecondary;
      case TaskStatus.inProgress:
        return AppColors.primary;
      case TaskStatus.completed:
        return AppColors.success;
      case TaskStatus.hold:
        return AppColors.warning;
      case TaskStatus.drop:
        return AppColors.textSecondary;
      case TaskStatus.failed:
        return AppColors.error;
    }
  }
}

/// 섹션 헤더
class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final int count;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.color,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: AppSizes.spaceS),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(width: AppSizes.spaceS),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

/// 빈 상태
class _EmptyState extends StatelessWidget {
  final AppLocalizations l10n;

  const _EmptyState({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: AppSizes.iconXLarge,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            l10n.todo_noTodos,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// 에러 상태
class _ErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  final AppLocalizations l10n;

  const _ErrorState({
    required this.error,
    required this.onRetry,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
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
            l10n.todo_loadError,
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
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.common_retry),
          ),
        ],
      ),
    );
  }
}
