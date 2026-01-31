import 'package:flutter/material.dart';

import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/features/main/task/providers/task_form_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 우선순위 선택 섹션 위젯
class PrioritySection extends StatelessWidget {
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;

  const PrioritySection({
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
          l10n.schedule_priority,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SegmentedButton<TaskPriority>(
          segments: [
            ButtonSegment(
              value: TaskPriority.low,
              label: Text(l10n.schedule_priorityLow),
              icon: const Icon(Icons.arrow_downward, size: 16),
            ),
            ButtonSegment(
              value: TaskPriority.medium,
              label: Text(l10n.schedule_priorityMedium),
              icon: const Icon(Icons.remove, size: 16),
            ),
            ButtonSegment(
              value: TaskPriority.high,
              label: Text(l10n.schedule_priorityHigh),
              icon: const Icon(Icons.arrow_upward, size: 16),
            ),
            ButtonSegment(
              value: TaskPriority.urgent,
              label: Text(l10n.schedule_priorityUrgent),
              icon: const Icon(Icons.priority_high, size: 16),
            ),
          ],
          selected: {formState.priority},
          onSelectionChanged: (selected) => formNotifier.setPriority(selected.first),
        ),
      ],
    );
  }
}
