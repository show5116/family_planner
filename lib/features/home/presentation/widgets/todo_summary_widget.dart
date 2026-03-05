import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/home/providers/dashboard_provider.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/shared/widgets/dashboard_card.dart';

/// 할일 요약 위젯
class TodoSummaryWidget extends ConsumerWidget {
  const TodoSummaryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(dashboardTodoTasksProvider);

    return todosAsync.when(
      loading: () => DashboardCard(
        title: '오늘의 할일',
        icon: Icons.check_box,
        onTap: () {},
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.spaceM),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (_, _) => _buildCard(context, ref, []),
      data: (todos) => _buildCard(context, ref, todos),
    );
  }

  Widget _buildCard(BuildContext context, WidgetRef ref, List<TaskModel> todos) {
    final completedCount = todos.where((t) => t.isCompleted).length;
    final totalCount = todos.length;

    return DashboardCard(
      title: '오늘의 할일',
      icon: Icons.check_box,
      action: totalCount > 0
          ? Chip(
              label: Text(
                '$completedCount/$totalCount',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              backgroundColor: AppColors.primaryLight,
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            )
          : null,
      onTap: () => context.push(AppRoutes.todo),
      child: todos.isEmpty
          ? const _EmptyState()
          : Column(
              children: todos
                  .take(5)
                  .map((todo) => _TodoItem(todo: todo, ref: ref))
                  .toList(),
            ),
    );
  }
}

class _TodoItem extends StatelessWidget {
  const _TodoItem({required this.todo, required this.ref});

  final TaskModel todo;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final priorityColor = _getPriorityColor(todo.priority);
    final priorityLabel = _getPriorityLabel(todo.priority);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
      child: Row(
        children: [
          Checkbox(
            value: todo.isCompleted,
            onChanged: (value) {
              if (todo.scheduledAt == null) return;
              ref.read(taskManagementProvider.notifier).toggleComplete(
                    todo.id,
                    value ?? false,
                    todo.scheduledAt!,
                  );
              ref.invalidate(dashboardTodoTasksProvider);
            },
            visualDensity: VisualDensity.compact,
          ),
          Expanded(
            child: Text(
              todo.title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    decoration: todo.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: todo.isCompleted
                        ? Theme.of(context).colorScheme.onSurfaceVariant
                        : null,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (priorityLabel != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceS,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: priorityColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              ),
              child: Text(
                priorityLabel,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: priorityColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getPriorityColor(TaskPriority? priority) {
    switch (priority) {
      case TaskPriority.urgent:
      case TaskPriority.high:
        return AppColors.error;
      case TaskPriority.medium:
        return AppColors.warning;
      case TaskPriority.low:
        return AppColors.success;
      default:
        return Colors.grey;
    }
  }

  String? _getPriorityLabel(TaskPriority? priority) {
    switch (priority) {
      case TaskPriority.urgent:
        return '긴급';
      case TaskPriority.high:
        return '높음';
      case TaskPriority.medium:
        return '중간';
      case TaskPriority.low:
        return '낮음';
      default:
        return null;
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 48,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            '오늘 할일이 없습니다',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
