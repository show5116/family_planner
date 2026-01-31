import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/features/main/task/providers/task_form_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 반복 설정 섹션 위젯
class RecurringSection extends StatelessWidget {
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;

  const RecurringSection({
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
          l10n.schedule_recurrence,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSizes.spaceM),
        Wrap(
          spacing: AppSizes.spaceS,
          runSpacing: AppSizes.spaceS,
          children: [
            _RecurringChip(
              label: l10n.schedule_recurrenceNone,
              type: null,
              formState: formState,
              formNotifier: formNotifier,
            ),
            _RecurringChip(
              label: l10n.schedule_recurrenceDaily,
              type: RecurringRuleType.daily,
              formState: formState,
              formNotifier: formNotifier,
            ),
            _RecurringChip(
              label: l10n.schedule_recurrenceWeekly,
              type: RecurringRuleType.weekly,
              formState: formState,
              formNotifier: formNotifier,
            ),
            _RecurringChip(
              label: l10n.schedule_recurrenceMonthly,
              type: RecurringRuleType.monthly,
              formState: formState,
              formNotifier: formNotifier,
            ),
            _RecurringChip(
              label: l10n.schedule_recurrenceYearly,
              type: RecurringRuleType.yearly,
              formState: formState,
              formNotifier: formNotifier,
            ),
          ],
        ),
      ],
    );
  }
}

class _RecurringChip extends StatelessWidget {
  final String label;
  final RecurringRuleType? type;
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;

  const _RecurringChip({
    required this.label,
    required this.type,
    required this.formState,
    required this.formNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: formState.recurringType == type,
      onSelected: (selected) {
        if (selected) formNotifier.setRecurringType(type);
      },
    );
  }
}
