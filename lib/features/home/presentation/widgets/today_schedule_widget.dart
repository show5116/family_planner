import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/home/providers/dashboard_provider.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/shared/widgets/dashboard_card.dart';

/// 오늘의 일정 위젯
class TodayScheduleWidget extends ConsumerWidget {
  const TodayScheduleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(dashboardTodayTasksProvider);

    return DashboardCard(
      title: '오늘의 일정',
      icon: Icons.calendar_today,
      action: TextButton(
        onPressed: () => context.push(AppRoutes.calendar),
        child: const Text('전체보기'),
      ),
      onTap: () => context.push(AppRoutes.calendar),
      child: tasksAsync.when(
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.spaceM),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (_, _) => const _EmptyState(),
        data: (tasks) {
          if (tasks.isEmpty) return const _EmptyState();
          return Column(
            children: tasks
                .take(5)
                .map((task) => _ScheduleItem(task: task))
                .toList(),
          );
        },
      ),
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  const _ScheduleItem({required this.task});

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    final color = Color(task.colorValue);
    final timeText = task.isAllDay
        ? '종일'
        : '${task.scheduledAt!.hour.toString().padLeft(2, '0')}:${task.scheduledAt!.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
            child: task.category?.emoji != null
                ? Center(
                    child: Text(
                      task.category!.emoji!,
                      style: const TextStyle(fontSize: 20),
                    ),
                  )
                : Icon(
                    Icons.event,
                    color: color,
                    size: AppSizes.iconMedium,
                  ),
          ),
          const SizedBox(width: AppSizes.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isCompleted
                            ? Theme.of(context).colorScheme.onSurfaceVariant
                            : null,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  timeText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
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
            Icons.event_available,
            size: 48,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            '오늘 일정이 없습니다',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
