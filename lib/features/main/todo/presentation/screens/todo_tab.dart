import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/features/main/todo/presentation/widgets/todo_kanban_column.dart';
import 'package:family_planner/features/main/todo/presentation/widgets/todo_list_item.dart';
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

    // 완료 포함해서 모든 할일 가져오기 (칸반에서 필요)
    final todosAsync = ref.watch(todoTasksProvider(page: 1));

    return Scaffold(
      appBar: AppBar(
        title: const CalendarGroupSelector(),
        actions: [
          // 뷰 전환 버튼
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
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(todoTasksProvider(page: 1));
        },
        child: todosAsync.when(
          data: (response) {
            if (response.data.isEmpty) {
              return _EmptyState(l10n: l10n);
            }

            return viewType == TodoViewType.kanban
                ? _KanbanView(tasks: response.data)
                : _ListView(tasks: response.data);
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

/// 칸반 뷰
class _KanbanView extends ConsumerWidget {
  final List<TaskModel> tasks;

  const _KanbanView({required this.tasks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    // 완료 여부로 분류
    final inProgressTasks = tasks.where((t) => !t.isCompleted).toList();
    final completedTasks = tasks.where((t) => t.isCompleted).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(AppSizes.spaceM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 진행중 컬럼
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
            onTaskComplete: (task) {
              _toggleComplete(ref, task);
            },
            onAcceptDrop: (task) {
              if (task.isCompleted) {
                _toggleComplete(ref, task);
              }
            },
          ),
          const SizedBox(width: AppSizes.spaceM),

          // 완료 컬럼
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
            onTaskComplete: (task) {
              _toggleComplete(ref, task);
            },
            onAcceptDrop: (task) {
              if (!task.isCompleted) {
                _toggleComplete(ref, task);
              }
            },
          ),
        ],
      ),
    );
  }

  void _toggleComplete(WidgetRef ref, TaskModel task) {
    ref.read(taskManagementProvider.notifier).toggleComplete(
      task.id,
      !task.isCompleted,
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

    // 완료되지 않은 것 먼저, 우선순위 높은 것 먼저
    final sortedTasks = List<TaskModel>.from(tasks)
      ..sort((a, b) {
        // 완료되지 않은 것 먼저
        if (a.isCompleted != b.isCompleted) {
          return a.isCompleted ? 1 : -1;
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

        // 섹션 헤더 표시 (진행중/완료)
        final showHeader = index == 0 ||
            sortedTasks[index - 1].isCompleted != task.isCompleted;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeader) ...[
              if (index > 0) const SizedBox(height: AppSizes.spaceL),
              _SectionHeader(
                title: task.isCompleted
                    ? l10n.todo_statusCompleted
                    : l10n.todo_statusInProgress,
                icon: task.isCompleted
                    ? Icons.check_circle_outline
                    : Icons.play_circle_outline,
                color: task.isCompleted ? AppColors.success : AppColors.primary,
                count: task.isCompleted
                    ? tasks.where((t) => t.isCompleted).length
                    : tasks.where((t) => !t.isCompleted).length,
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
                onToggleComplete: () {
                  ref.read(taskManagementProvider.notifier).toggleComplete(
                    task.id,
                    !task.isCompleted,
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
