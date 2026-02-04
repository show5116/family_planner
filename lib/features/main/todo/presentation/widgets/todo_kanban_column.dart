import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/features/main/todo/presentation/widgets/todo_card.dart';

/// 칸반 보드 컬럼 위젯 (드래그 앤 드롭 지원)
class TodoKanbanColumn extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<TaskModel> tasks;
  final Function(TaskModel) onTaskTap;
  final Function(TaskModel) onTaskComplete;
  final Function(TaskModel) onAcceptDrop;

  const TodoKanbanColumn({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.tasks,
    required this.onTaskTap,
    required this.onTaskComplete,
    required this.onAcceptDrop,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // 화면 너비에 따라 컬럼 너비 조정 (최소 280, 최대 350)
    final columnWidth = (screenWidth * 0.8).clamp(280.0, 350.0);

    return DragTarget<TaskModel>(
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) {
        onAcceptDrop(details.data);
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: columnWidth,
          decoration: BoxDecoration(
            color: isHovering
                ? color.withValues(alpha: 0.1)
                : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
            border: isHovering
                ? Border.all(color: color, width: 2)
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 컬럼 헤더
              _ColumnHeader(
                title: title,
                icon: icon,
                color: color,
                count: tasks.length,
              ),

              // Task 목록
              Flexible(
                child: tasks.isEmpty
                    ? _EmptyColumn(color: color)
                    : ListView.separated(
                        shrinkWrap: true,
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
                          return _DraggableTodoCard(
                            task: task,
                            onTap: () => onTaskTap(task),
                            onToggleComplete: () => onTaskComplete(task),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 컬럼 헤더
class _ColumnHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final int count;

  const _ColumnHeader({
    required this.title,
    required this.icon,
    required this.color,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: AppSizes.spaceS),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
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
      ),
    );
  }
}

/// 빈 컬럼 플레이스홀더
class _EmptyColumn extends StatelessWidget {
  final Color color;

  const _EmptyColumn({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSizes.spaceM),
      padding: const EdgeInsets.all(AppSizes.spaceL),
      decoration: BoxDecoration(
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 32,
            color: color.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            '드래그하여 이동',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// 드래그 가능한 Todo 카드
class _DraggableTodoCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onTap;
  final VoidCallback onToggleComplete;

  const _DraggableTodoCard({
    required this.task,
    required this.onTap,
    required this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<TaskModel>(
      data: task,
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: SizedBox(
          width: 280,
          child: Opacity(
            opacity: 0.9,
            child: TodoCard(
              task: task,
              onTap: () {},
              onToggleComplete: () {},
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.4,
        child: TodoCard(
          task: task,
          onTap: () {},
          onToggleComplete: () {},
        ),
      ),
      child: TodoCard(
        task: task,
        onTap: onTap,
        onToggleComplete: onToggleComplete,
      ),
    );
  }
}
