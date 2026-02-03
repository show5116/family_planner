import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/task/providers/task_form_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 날짜/시간 선택 섹션 위젯
class DateTimeSection extends StatelessWidget {
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;

  const DateTimeSection({
    super.key,
    required this.formState,
    required this.formNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = DateFormat.yMMMEd(Localizations.localeOf(context).toString());
    final timeFormat = DateFormat.jm(Localizations.localeOf(context).toString());

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          children: [
            // 시작 날짜
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(l10n.schedule_startDate),
              subtitle: Text(dateFormat.format(formState.startDate)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _selectDate(context, isStart: true),
              contentPadding: EdgeInsets.zero,
            ),

            if (!formState.isAllDay) ...[
              const Divider(),
              ListTile(
                leading: const Icon(Icons.access_time),
                title: Text(l10n.schedule_startTime),
                subtitle: Text(formState.startTime != null
                    ? timeFormat.format(DateTime(2000, 1, 1, formState.startTime!.hour, formState.startTime!.minute))
                    : '-'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _selectTime(context, isStart: true),
                contentPadding: EdgeInsets.zero,
              ),
            ],

            const Divider(),

            // 마감일 토글
            SwitchListTile(
              title: Text(l10n.schedule_dueDate),
              secondary: const Icon(Icons.event_available),
              value: formState.hasDueDate,
              onChanged: formNotifier.setHasDueDate,
              contentPadding: EdgeInsets.zero,
            ),

            if (formState.hasDueDate) ...[
              const Divider(),
              ListTile(
                leading: const Icon(Icons.calendar_month),
                title: Text(l10n.schedule_dueDateSelect),
                subtitle: Text(formState.dueDate != null ? dateFormat.format(formState.dueDate!) : '-'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _selectDate(context, isStart: false),
                contentPadding: EdgeInsets.zero,
              ),
              if (!formState.isAllDay) ...[
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.access_time_filled),
                  title: Text(l10n.schedule_dueTime),
                  subtitle: Text(formState.dueTime != null
                      ? timeFormat.format(DateTime(2000, 1, 1, formState.dueTime!.hour, formState.dueTime!.minute))
                      : '-'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _selectTime(context, isStart: false),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, {required bool isStart}) async {
    final initialDate = isStart ? formState.startDate : (formState.dueDate ?? formState.startDate);
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: isStart ? DateTime(2020) : formState.startDate,
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      if (isStart) {
        formNotifier.setStartDate(picked);
      } else {
        formNotifier.setDueDate(picked);
      }
    }
  }

  Future<void> _selectTime(BuildContext context, {required bool isStart}) async {
    final initialTime = isStart
        ? (formState.startTime ?? const TimeOfDay(hour: 9, minute: 0))
        : (formState.dueTime ?? const TimeOfDay(hour: 18, minute: 0));

    final picked = await showTimePicker(context: context, initialTime: initialTime);
    if (picked != null) {
      if (isStart) {
        formNotifier.setStartTime(picked);
      } else {
        formNotifier.setDueTime(picked);
      }
    }
  }
}

/// 종일 스위치 위젯
class AllDaySwitch extends StatelessWidget {
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;

  const AllDaySwitch({
    super.key,
    required this.formState,
    required this.formNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      child: SwitchListTile(
        title: Text(l10n.schedule_allDay),
        secondary: const Icon(Icons.wb_sunny_outlined),
        value: formState.isAllDay,
        onChanged: formNotifier.setIsAllDay,
      ),
    );
  }
}
