import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 칸반 보드용 할일 카드 위젯
class TodoCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onTap;
  final VoidCallback onToggleComplete;

  const TodoCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = Color(task.colorValue);

    return Card(
      elevation: AppSizes.elevation2,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            border: Border(
              left: BorderSide(
                color: color,
                width: 4,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 헤더: 체크박스 + 제목
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CompletionCheckbox(
                    isCompleted: task.isCompleted,
                    color: color,
                    onTap: onToggleComplete,
                  ),
                  const SizedBox(width: AppSizes.spaceS),
                  Expanded(
                    child: Text(
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              // 설명 (있는 경우)
              if (task.description != null &&
                  task.description!.isNotEmpty) ...[
                const SizedBox(height: AppSizes.spaceS),
                Text(
                  task.description!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: AppSizes.spaceS),

              // 하단: 마감일, 카테고리, 우선순위
              Row(
                children: [
                  // 마감일 / D-Day
                  if (task.dueAt != null || task.daysUntilDue != null) ...[
                    _DueDateChip(task: task, l10n: l10n),
                    const SizedBox(width: AppSizes.spaceS),
                  ],

                  const Spacer(),

                  // 카테고리 이모지
                  if (task.category?.emoji != null)
                    Text(
                      task.category!.emoji!,
                      style: const TextStyle(fontSize: 16),
                    ),

                  // 우선순위 아이콘
                  if (task.priority != null &&
                      task.priority != TaskPriority.low) ...[
                    const SizedBox(width: AppSizes.spaceXS),
                    _PriorityIcon(priority: task.priority!),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 완료 체크박스
class _CompletionCheckbox extends StatelessWidget {
  final bool isCompleted;
  final Color color;
  final VoidCallback onTap;

  const _CompletionCheckbox({
    required this.isCompleted,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: isCompleted ? color : Colors.transparent,
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: isCompleted
            ? const Icon(Icons.check, size: 14, color: Colors.white)
            : null,
      ),
    );
  }
}

/// 마감일 칩
class _DueDateChip extends StatelessWidget {
  final TaskModel task;
  final AppLocalizations l10n;

  const _DueDateChip({
    required this.task,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final days = task.daysUntilDue;
    final dueDate = task.dueAt ?? task.scheduledAt;

    Color chipColor;
    String text;

    if (days != null) {
      if (days < 0) {
        chipColor = AppColors.error;
        text = 'D+${days.abs()}';
      } else if (days == 0) {
        chipColor = AppColors.warning;
        text = 'D-Day';
      } else if (days <= 3) {
        chipColor = AppColors.secondary;
        text = 'D-$days';
      } else {
        chipColor = AppColors.textSecondary;
        text = 'D-$days';
      }
    } else if (dueDate != null) {
      chipColor = AppColors.textSecondary;
      text = '${dueDate.month}/${dueDate.day}';
    } else {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event, size: 12, color: chipColor),
          const SizedBox(width: 2),
          Text(
            text,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: chipColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// 우선순위 아이콘
class _PriorityIcon extends StatelessWidget {
  final TaskPriority priority;

  const _PriorityIcon({required this.priority});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (priority) {
      case TaskPriority.urgent:
        icon = Icons.priority_high;
        color = AppColors.error;
        break;
      case TaskPriority.high:
        icon = Icons.arrow_upward;
        color = AppColors.secondary;
        break;
      case TaskPriority.medium:
        icon = Icons.remove;
        color = AppColors.primary;
        break;
      case TaskPriority.low:
        icon = Icons.arrow_downward;
        color = AppColors.textSecondary;
        break;
    }

    return Icon(icon, size: 16, color: color);
  }
}
