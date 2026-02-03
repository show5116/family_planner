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
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSizes.spaceM),

        // 반복 유형 선택
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

        // 반복 상세 설정 (반복 유형이 선택된 경우에만 표시)
        if (formState.recurringType != null) ...[
          const SizedBox(height: AppSizes.spaceL),
          _RecurringDetailSection(
            formState: formState,
            formNotifier: formNotifier,
          ),
        ],
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

/// 반복 상세 설정 섹션
class _RecurringDetailSection extends StatelessWidget {
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;

  const _RecurringDetailSection({
    required this.formState,
    required this.formNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 반복 간격 설정
          _IntervalSection(
            formState: formState,
            formNotifier: formNotifier,
          ),

          const SizedBox(height: AppSizes.spaceM),

          // 타입별 추가 설정
          _buildTypeSpecificSection(context),

          const SizedBox(height: AppSizes.spaceM),

          // 종료 조건 설정
          _EndConditionSection(
            formState: formState,
            formNotifier: formNotifier,
          ),
        ],
      ),
    );
  }

  Widget _buildTypeSpecificSection(BuildContext context) {
    switch (formState.recurringType) {
      case RecurringRuleType.weekly:
        return _WeeklySection(
          formState: formState,
          formNotifier: formNotifier,
        );
      case RecurringRuleType.monthly:
        return _MonthlySection(
          formState: formState,
          formNotifier: formNotifier,
        );
      case RecurringRuleType.yearly:
        return _YearlySection(
          formState: formState,
          formNotifier: formNotifier,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

/// 반복 간격 설정
class _IntervalSection extends StatelessWidget {
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;

  const _IntervalSection({
    required this.formState,
    required this.formNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    String unitLabel;
    switch (formState.recurringType) {
      case RecurringRuleType.daily:
        unitLabel = l10n.schedule_recurringIntervalDay;
        break;
      case RecurringRuleType.weekly:
        unitLabel = l10n.schedule_recurringIntervalWeek;
        break;
      case RecurringRuleType.monthly:
        unitLabel = l10n.schedule_recurringIntervalMonth;
        break;
      case RecurringRuleType.yearly:
        unitLabel = l10n.schedule_recurringIntervalYear;
        break;
      default:
        unitLabel = '';
    }

    return Row(
      children: [
        Text(
          l10n.schedule_recurringEvery,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(width: AppSizes.spaceS),
        SizedBox(
          width: 60,
          child: TextField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            controller: TextEditingController(
              text: formState.recurringInterval.toString(),
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceS,
                vertical: AppSizes.spaceS,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              ),
            ),
            onChanged: (value) {
              final interval = int.tryParse(value);
              if (interval != null && interval > 0) {
                formNotifier.setRecurringInterval(interval);
              }
            },
          ),
        ),
        const SizedBox(width: AppSizes.spaceS),
        Text(
          unitLabel,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}

/// 주간 반복 설정 (요일 선택)
class _WeeklySection extends StatelessWidget {
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;

  const _WeeklySection({
    required this.formState,
    required this.formNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final dayLabels = [
      l10n.schedule_daySun,
      l10n.schedule_dayMon,
      l10n.schedule_dayTue,
      l10n.schedule_dayWed,
      l10n.schedule_dayThu,
      l10n.schedule_dayFri,
      l10n.schedule_daySat,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.schedule_recurringDaysOfWeek,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSizes.spaceS),
        Wrap(
          spacing: AppSizes.spaceXS,
          runSpacing: AppSizes.spaceXS,
          children: List.generate(7, (index) {
            final isSelected = formState.recurringDaysOfWeek.contains(index);
            return FilterChip(
              label: Text(dayLabels[index]),
              selected: isSelected,
              onSelected: (_) => formNotifier.toggleDayOfWeek(index),
              visualDensity: VisualDensity.compact,
            );
          }),
        ),
      ],
    );
  }
}

/// 월간 반복 설정
class _MonthlySection extends StatelessWidget {
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;

  const _MonthlySection({
    required this.formState,
    required this.formNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.schedule_recurringMonthlyType,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSizes.spaceS),

        // 월간 반복 타입 선택
        SegmentedButton<MonthlyType>(
          segments: [
            ButtonSegment(
              value: MonthlyType.dayOfMonth,
              label: Text(l10n.schedule_recurringMonthlyDayOfMonth),
            ),
            ButtonSegment(
              value: MonthlyType.weekOfMonth,
              label: Text(l10n.schedule_recurringMonthlyWeekOfMonth),
            ),
          ],
          selected: {formState.monthlyType},
          onSelectionChanged: (selection) {
            formNotifier.setMonthlyType(selection.first);
          },
        ),

        const SizedBox(height: AppSizes.spaceS),

        // 타입별 상세 설정
        if (formState.monthlyType == MonthlyType.dayOfMonth)
          _MonthlyDayPicker(
            formState: formState,
            formNotifier: formNotifier,
          )
        else
          _MonthlyWeekPicker(
            formState: formState,
            formNotifier: formNotifier,
          ),
      ],
    );
  }
}

/// 월간 - 날짜 선택
class _MonthlyDayPicker extends StatelessWidget {
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;

  const _MonthlyDayPicker({
    required this.formState,
    required this.formNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(l10n.schedule_recurringMonthlyEveryMonth, style: theme.textTheme.bodyMedium),
        const SizedBox(width: AppSizes.spaceS),
        DropdownButton<int>(
          value: formState.monthlyDayOfMonth,
          items: List.generate(31, (i) => i + 1).map((day) {
            return DropdownMenuItem(
              value: day,
              child: Text('$day'),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) formNotifier.setMonthlyDayOfMonth(value);
          },
        ),
        const SizedBox(width: AppSizes.spaceS),
        Text(l10n.schedule_recurringDay, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}

/// 월간 - 주차/요일 선택
class _MonthlyWeekPicker extends StatelessWidget {
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;

  const _MonthlyWeekPicker({
    required this.formState,
    required this.formNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final weekLabels = [
      l10n.schedule_recurringWeek1,
      l10n.schedule_recurringWeek2,
      l10n.schedule_recurringWeek3,
      l10n.schedule_recurringWeek4,
      l10n.schedule_recurringWeekLast,
    ];

    final dayLabels = [
      l10n.schedule_daySunday,
      l10n.schedule_dayMonday,
      l10n.schedule_dayTuesday,
      l10n.schedule_dayWednesday,
      l10n.schedule_dayThursday,
      l10n.schedule_dayFriday,
      l10n.schedule_daySaturday,
    ];

    return Row(
      children: [
        Text(l10n.schedule_recurringMonthlyEveryMonth, style: theme.textTheme.bodyMedium),
        const SizedBox(width: AppSizes.spaceS),
        DropdownButton<int>(
          value: formState.monthlyWeekOfMonth,
          items: List.generate(5, (i) => i + 1).map((week) {
            return DropdownMenuItem(
              value: week,
              child: Text(weekLabels[week - 1]),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) formNotifier.setMonthlyWeekOfMonth(value);
          },
        ),
        const SizedBox(width: AppSizes.spaceS),
        DropdownButton<int>(
          value: formState.monthlyDayOfWeek,
          items: List.generate(7, (i) => i).map((day) {
            return DropdownMenuItem(
              value: day,
              child: Text(dayLabels[day]),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) formNotifier.setMonthlyDayOfWeek(value);
          },
        ),
      ],
    );
  }
}

/// 연간 반복 설정
class _YearlySection extends StatelessWidget {
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;

  const _YearlySection({
    required this.formState,
    required this.formNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.schedule_recurringYearlyType,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSizes.spaceS),

        // 연간 반복 타입 선택
        SegmentedButton<YearlyType>(
          segments: [
            ButtonSegment(
              value: YearlyType.dayOfMonth,
              label: Text(l10n.schedule_recurringYearlyDayOfMonth),
            ),
            ButtonSegment(
              value: YearlyType.weekOfMonth,
              label: Text(l10n.schedule_recurringYearlyWeekOfMonth),
            ),
          ],
          selected: {formState.yearlyType},
          onSelectionChanged: (selection) {
            formNotifier.setYearlyType(selection.first);
          },
        ),

        const SizedBox(height: AppSizes.spaceS),

        // 타입별 상세 설정
        if (formState.yearlyType == YearlyType.dayOfMonth)
          _YearlyDayPicker(
            formState: formState,
            formNotifier: formNotifier,
          )
        else
          _YearlyWeekPicker(
            formState: formState,
            formNotifier: formNotifier,
          ),
      ],
    );
  }
}

/// 연간 - 날짜 선택
class _YearlyDayPicker extends StatelessWidget {
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;

  const _YearlyDayPicker({
    required this.formState,
    required this.formNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final monthLabels = [
      l10n.schedule_month1,
      l10n.schedule_month2,
      l10n.schedule_month3,
      l10n.schedule_month4,
      l10n.schedule_month5,
      l10n.schedule_month6,
      l10n.schedule_month7,
      l10n.schedule_month8,
      l10n.schedule_month9,
      l10n.schedule_month10,
      l10n.schedule_month11,
      l10n.schedule_month12,
    ];

    return Row(
      children: [
        Text(l10n.schedule_recurringYearlyEveryYear, style: theme.textTheme.bodyMedium),
        const SizedBox(width: AppSizes.spaceS),
        DropdownButton<int>(
          value: formState.yearlyMonth,
          items: List.generate(12, (i) => i + 1).map((month) {
            return DropdownMenuItem(
              value: month,
              child: Text(monthLabels[month - 1]),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) formNotifier.setYearlyMonth(value);
          },
        ),
        const SizedBox(width: AppSizes.spaceS),
        DropdownButton<int>(
          value: formState.yearlyDayOfMonth,
          items: List.generate(31, (i) => i + 1).map((day) {
            return DropdownMenuItem(
              value: day,
              child: Text('$day'),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) formNotifier.setYearlyDayOfMonth(value);
          },
        ),
        const SizedBox(width: AppSizes.spaceS),
        Text(l10n.schedule_recurringDay, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}

/// 연간 - 주차/요일 선택
class _YearlyWeekPicker extends StatelessWidget {
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;

  const _YearlyWeekPicker({
    required this.formState,
    required this.formNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final monthLabels = [
      l10n.schedule_month1,
      l10n.schedule_month2,
      l10n.schedule_month3,
      l10n.schedule_month4,
      l10n.schedule_month5,
      l10n.schedule_month6,
      l10n.schedule_month7,
      l10n.schedule_month8,
      l10n.schedule_month9,
      l10n.schedule_month10,
      l10n.schedule_month11,
      l10n.schedule_month12,
    ];

    final weekLabels = [
      l10n.schedule_recurringWeek1,
      l10n.schedule_recurringWeek2,
      l10n.schedule_recurringWeek3,
      l10n.schedule_recurringWeek4,
      l10n.schedule_recurringWeekLast,
    ];

    final dayLabels = [
      l10n.schedule_daySunday,
      l10n.schedule_dayMonday,
      l10n.schedule_dayTuesday,
      l10n.schedule_dayWednesday,
      l10n.schedule_dayThursday,
      l10n.schedule_dayFriday,
      l10n.schedule_daySaturday,
    ];

    return Wrap(
      spacing: AppSizes.spaceS,
      runSpacing: AppSizes.spaceS,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(l10n.schedule_recurringYearlyEveryYear, style: theme.textTheme.bodyMedium),
        DropdownButton<int>(
          value: formState.yearlyMonth,
          items: List.generate(12, (i) => i + 1).map((month) {
            return DropdownMenuItem(
              value: month,
              child: Text(monthLabels[month - 1]),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) formNotifier.setYearlyMonth(value);
          },
        ),
        DropdownButton<int>(
          value: formState.yearlyWeekOfMonth,
          items: List.generate(5, (i) => i + 1).map((week) {
            return DropdownMenuItem(
              value: week,
              child: Text(weekLabels[week - 1]),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) formNotifier.setYearlyWeekOfMonth(value);
          },
        ),
        DropdownButton<int>(
          value: formState.yearlyDayOfWeek,
          items: List.generate(7, (i) => i).map((day) {
            return DropdownMenuItem(
              value: day,
              child: Text(dayLabels[day]),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) formNotifier.setYearlyDayOfWeek(value);
          },
        ),
      ],
    );
  }
}

/// 종료 조건 설정
class _EndConditionSection extends StatelessWidget {
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;

  const _EndConditionSection({
    required this.formState,
    required this.formNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.schedule_recurringEndCondition,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSizes.spaceS),

        // 종료 조건 선택
        Wrap(
          spacing: AppSizes.spaceS,
          runSpacing: AppSizes.spaceS,
          children: [
            ChoiceChip(
              label: Text(l10n.schedule_recurringEndNever),
              selected: formState.recurringEndType == RecurringEndType.never,
              onSelected: (_) =>
                  formNotifier.setRecurringEndType(RecurringEndType.never),
            ),
            ChoiceChip(
              label: Text(l10n.schedule_recurringEndDate),
              selected: formState.recurringEndType == RecurringEndType.date,
              onSelected: (_) =>
                  formNotifier.setRecurringEndType(RecurringEndType.date),
            ),
            ChoiceChip(
              label: Text(l10n.schedule_recurringEndCount),
              selected: formState.recurringEndType == RecurringEndType.count,
              onSelected: (_) =>
                  formNotifier.setRecurringEndType(RecurringEndType.count),
            ),
          ],
        ),

        const SizedBox(height: AppSizes.spaceS),

        // 종료 조건별 상세 설정
        if (formState.recurringEndType == RecurringEndType.date)
          _EndDatePicker(
            formState: formState,
            formNotifier: formNotifier,
          )
        else if (formState.recurringEndType == RecurringEndType.count)
          _EndCountPicker(
            formState: formState,
            formNotifier: formNotifier,
          ),
      ],
    );
  }
}

/// 종료 날짜 선택
class _EndDatePicker extends StatelessWidget {
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;

  const _EndDatePicker({
    required this.formState,
    required this.formNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final endDate = formState.recurringEndDate ?? formState.startDate.add(const Duration(days: 30));

    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: endDate,
          firstDate: formState.startDate,
          lastDate: formState.startDate.add(const Duration(days: 365 * 10)),
        );
        if (date != null) {
          formNotifier.setRecurringEndDate(date);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceM,
          vertical: AppSizes.spaceS,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_today, size: 18, color: theme.colorScheme.primary),
            const SizedBox(width: AppSizes.spaceS),
            Text(
              '${endDate.year}/${endDate.month}/${endDate.day}',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

/// 종료 횟수 선택
class _EndCountPicker extends StatelessWidget {
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;

  const _EndCountPicker({
    required this.formState,
    required this.formNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Row(
      children: [
        SizedBox(
          width: 80,
          child: TextField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            controller: TextEditingController(
              text: formState.recurringCount.toString(),
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceS,
                vertical: AppSizes.spaceS,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              ),
            ),
            onChanged: (value) {
              final count = int.tryParse(value);
              if (count != null && count > 0) {
                formNotifier.setRecurringCount(count);
              }
            },
          ),
        ),
        const SizedBox(width: AppSizes.spaceS),
        Text(
          l10n.schedule_recurringCountTimes,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
