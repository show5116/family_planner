import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/features/main/task/providers/task_form_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 일정 유형 선택 섹션 위젯
class TaskTypeSection extends StatelessWidget {
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;

  const TaskTypeSection({
    super.key,
    required this.formState,
    required this.formNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.schedule_taskType,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          child: Column(
            children: [
              RadioListTile<TaskType>(
                title: Text(l10n.schedule_taskTypeCalendarOnly),
                subtitle: Text(
                  l10n.schedule_taskTypeCalendarOnlyDesc,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                ),
                value: TaskType.calendarOnly,
                groupValue: formState.taskType,
                onChanged: (value) {
                  if (value != null) formNotifier.setTaskType(value);
                },
                secondary: const Icon(Icons.calendar_today),
              ),
              const Divider(height: 1),
              RadioListTile<TaskType>(
                title: Text(l10n.schedule_taskTypeTodoLinked),
                subtitle: Text(
                  l10n.schedule_taskTypeTodoLinkedDesc,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                ),
                value: TaskType.todoLinked,
                groupValue: formState.taskType,
                onChanged: (value) {
                  if (value != null) formNotifier.setTaskType(value);
                },
                secondary: const Icon(Icons.checklist),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
