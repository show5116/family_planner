import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/widgets/duration_picker_dialog.dart';
import 'package:family_planner/core/widgets/form_section_header.dart';
import 'package:family_planner/features/main/task/providers/task_form_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 알림 설정 섹션 위젯
class ReminderSection extends StatelessWidget {
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;

  const ReminderSection({
    super.key,
    required this.formState,
    required this.formNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final quickOptions = [
      (5, l10n.schedule_reminder5Min),
      (15, l10n.schedule_reminder15Min),
      (30, l10n.schedule_reminder30Min),
      (60, l10n.schedule_reminder1Hour),
      (1440, l10n.schedule_reminder1Day),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSectionHeader(title: l10n.schedule_reminder),
        Wrap(
          spacing: AppSizes.spaceS,
          runSpacing: AppSizes.spaceS,
          children: [
            ...quickOptions.map((option) {
              final (minutes, label) = option;
              return FilterChip(
                label: Text(label),
                selected: formState.selectedReminders.contains(minutes),
                onSelected: (_) => formNotifier.toggleReminder(minutes),
              );
            }),
            ActionChip(
              avatar: const Icon(Icons.add, size: 18),
              label: Text(l10n.schedule_reminderCustom),
              onPressed: () => _showCustomReminderPicker(context, l10n),
            ),
          ],
        ),
        if (formState.selectedReminders.isNotEmpty) ...[
          const SizedBox(height: AppSizes.spaceM),
          _SelectedRemindersList(
            selectedReminders: formState.selectedReminders,
            onRemove: formNotifier.removeReminder,
          ),
        ],
      ],
    );
  }

  Future<void> _showCustomReminderPicker(BuildContext context, AppLocalizations l10n) async {
    final duration = await DurationPickerDialog.show(
      context: context,
      title: l10n.schedule_reminderCustomTitle,
      subtitle: l10n.schedule_reminderCustomHint,
      confirmText: l10n.common_add,
      cancelText: l10n.common_cancel,
      previewBuilder: (duration) => _ReminderPreview(
        minutes: duration.inMinutes,
        l10n: l10n,
      ),
    );

    if (duration != null && duration.inMinutes > 0) {
      formNotifier.addReminder(duration.inMinutes);
    }
  }
}

class _ReminderPreview extends StatelessWidget {
  final int minutes;
  final AppLocalizations l10n;

  const _ReminderPreview({
    required this.minutes,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.notifications_active, size: 20),
          const SizedBox(width: AppSizes.spaceS),
          Text(
            _formatReminderTime(minutes, l10n),
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  static String _formatReminderTime(int minutes, AppLocalizations l10n) {
    if (minutes == 0) {
      return l10n.schedule_reminderAtTime;
    } else if (minutes < 60) {
      return l10n.schedule_reminderMinutesBefore(minutes);
    } else if (minutes < 1440) {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return l10n.schedule_reminderHoursBefore(hours);
      } else {
        return l10n.schedule_reminderHoursMinutesBefore(hours, remainingMinutes);
      }
    } else {
      final days = minutes ~/ 1440;
      final remainingHours = (minutes % 1440) ~/ 60;
      if (remainingHours == 0) {
        return l10n.schedule_reminderDaysBefore(days);
      } else {
        return l10n.schedule_reminderDaysHoursBefore(days, remainingHours);
      }
    }
  }
}

class _SelectedRemindersList extends StatelessWidget {
  final List<int> selectedReminders;
  final ValueChanged<int> onRemove;

  const _SelectedRemindersList({
    required this.selectedReminders,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceS, vertical: AppSizes.spaceXS),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: selectedReminders.map((minutes) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceXS),
              child: Row(
                children: [
                  const Icon(Icons.notifications_outlined, size: 20),
                  const SizedBox(width: AppSizes.spaceS),
                  Expanded(
                    child: Text(
                      _ReminderPreview._formatReminderTime(minutes, l10n),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () => onRemove(minutes),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
