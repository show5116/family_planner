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
    final selectedDate = ref.watch(todoSelectedDateProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    // 선택된 날짜에 해당하는 할일만 가져오기
    final selectedDateTasksAsync = ref.watch(todoSelectedDateTasksProvider);

    // 모바일에서는 항상 리스트 뷰 사용
    final effectiveViewType = isMobile ? TodoViewType.list : viewType;

    return Scaffold(
      appBar: AppBar(
        title: const CalendarGroupSelector(),
        actions: [
          // 뷰 전환 버튼 (모바일에서는 숨김 - 칸반 뷰가 모바일에서 사용하기 어려움)
          if (!isMobile)
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
          // 주간 날짜 선택 바
          const TodoWeekBar(),
          const Divider(height: 1),

          // 선택된 날짜 표시
          _SelectedDateHeader(selectedDate: selectedDate, l10n: l10n),

          // 할일 목록
          Expanded(
            child: RefreshIndicator(
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

/// 칸반 뷰 (모바일: 세로 스크롤, 태블릿/데스크톱: 가로 스크롤)
class _KanbanView extends ConsumerWidget {
  final List<TaskModel> tasks;

  const _KanbanView({required this.tasks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    // 상태별로 분류
    final pendingTasks = tasks.where((t) => t.isPending).toList();
    final inProgressTasks = tasks.where((t) => t.isInProgress).toList();
    final completedTasks = tasks.where((t) => t.isCompleted).toList();

    final columns = [
      _KanbanColumnData(
        title: l10n.todo_statusPending,
        icon: Icons.pending_outlined,
        color: AppColors.textSecondary,
        tasks: pendingTasks,
        targetStatus: TaskStatus.pending,
      ),
      _KanbanColumnData(
        title: l10n.todo_statusInProgress,
        icon: Icons.play_circle_outline,
        color: AppColors.primary,
        tasks: inProgressTasks,
        targetStatus: TaskStatus.inProgress,
      ),
      _KanbanColumnData(
        title: l10n.todo_statusCompleted,
        icon: Icons.check_circle_outline,
        color: AppColors.success,
        tasks: completedTasks,
        targetStatus: TaskStatus.completed,
      ),
    ];

    if (isMobile) {
      // 모바일: 세로 스크롤, 접을 수 있는 섹션
      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          children: columns.map((col) {
            return _MobileKanbanSection(
              title: col.title,
              icon: col.icon,
              color: col.color,
              tasks: col.tasks,
              targetStatus: col.targetStatus,
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
                if (task.status != col.targetStatus) {
                  _updateStatus(ref, task, col.targetStatus);
                }
              },
            );
          }).toList(),
        ),
      );
    }

    // 태블릿/데스크톱: 가로 스크롤
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(AppSizes.spaceM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: columns.map((col) {
          return Padding(
            padding: const EdgeInsets.only(right: AppSizes.spaceM),
            child: TodoKanbanColumn(
              title: col.title,
              icon: col.icon,
              color: col.color,
              tasks: col.tasks,
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
                if (task.status != col.targetStatus) {
                  _updateStatus(ref, task, col.targetStatus);
                }
              },
            ),
          );
        }).toList(),
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

/// 칸반 컬럼 데이터
class _KanbanColumnData {
  final String title;
  final IconData icon;
  final Color color;
  final List<TaskModel> tasks;
  final TaskStatus targetStatus;

  const _KanbanColumnData({
    required this.title,
    required this.icon,
    required this.color,
    required this.tasks,
    required this.targetStatus,
  });
}

/// 모바일용 칸반 섹션 (접을 수 있는 ExpansionTile)
class _MobileKanbanSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<TaskModel> tasks;
  final TaskStatus targetStatus;
  final Function(TaskModel) onTaskTap;
  final Function(TaskModel, TaskStatus) onStatusChange;
  final Function(TaskModel) onAcceptDrop;

  const _MobileKanbanSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.tasks,
    required this.targetStatus,
    required this.onTaskTap,
    required this.onStatusChange,
    required this.onAcceptDrop,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<TaskModel>(
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) {
        onAcceptDrop(details.data);
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
          decoration: BoxDecoration(
            color: isHovering
                ? color.withValues(alpha: 0.1)
                : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
            border: isHovering
                ? Border.all(color: color, width: 2)
                : null,
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: tasks.isNotEmpty,
              leading: Icon(icon, color: color, size: 20),
              title: Row(
                children: [
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
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${tasks.length}',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              children: [
                if (tasks.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(AppSizes.spaceL),
                    child: Text(
                      '항목이 없습니다',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.spaceM,
                      0,
                      AppSizes.spaceM,
                      AppSizes.spaceM,
                    ),
                    itemCount: tasks.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSizes.spaceS),
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return LongPressDraggable<TaskModel>(
                        data: task,
                        feedback: Material(
                          elevation: 8,
                          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 64,
                            child: Opacity(
                              opacity: 0.9,
                              child: TodoListItem(
                                task: task,
                                onTap: () {},
                                onStatusChange: (_) {},
                              ),
                            ),
                          ),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.4,
                          child: TodoListItem(
                            task: task,
                            onTap: () {},
                            onStatusChange: (_) {},
                          ),
                        ),
                        child: TodoListItem(
                          task: task,
                          onTap: () => onTaskTap(task),
                          onStatusChange: (status) => onStatusChange(task, status),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
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
      case TaskStatus.cancelled:
        return l10n.todo_statusCancelled;
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
      case TaskStatus.cancelled:
        return Icons.cancel_outlined;
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
      case TaskStatus.cancelled:
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
