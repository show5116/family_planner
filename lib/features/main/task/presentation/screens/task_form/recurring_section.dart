import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/widgets/focus_dismiss_dropdown.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/features/main/task/providers/task_form_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 반복 설정 섹션 위젯
class RecurringSection extends StatelessWidget {
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;
  final bool readOnly;

  const RecurringSection({
    super.key,
    required this.formState,
    required this.formNotifier,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l10n.schedule_recurrence,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4),
            _RecurringInfoButton(),
          ],
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
              readOnly: readOnly,
            ),
            _RecurringChip(
              label: l10n.schedule_recurrenceDaily,
              type: RecurringRuleType.daily,
              formState: formState,
              formNotifier: formNotifier,
              readOnly: readOnly,
            ),
            _RecurringChip(
              label: l10n.schedule_recurrenceWeekly,
              type: RecurringRuleType.weekly,
              formState: formState,
              formNotifier: formNotifier,
              readOnly: readOnly,
            ),
            _RecurringChip(
              label: l10n.schedule_recurrenceMonthly,
              type: RecurringRuleType.monthly,
              formState: formState,
              formNotifier: formNotifier,
              readOnly: readOnly,
            ),
            _RecurringChip(
              label: l10n.schedule_recurrenceYearly,
              type: RecurringRuleType.yearly,
              formState: formState,
              formNotifier: formNotifier,
              readOnly: readOnly,
            ),
          ],
        ),

        // 반복 상세 설정 (반복 유형이 선택된 경우에만 표시)
        if (formState.recurringType != null) ...[
          const SizedBox(height: AppSizes.spaceL),
          _RecurringDetailSection(
            formState: formState,
            formNotifier: formNotifier,
            readOnly: readOnly,
          ),
        ],
      ],
    );
  }
}

class _RecurringInfoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.help_outline, size: 18),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      visualDensity: VisualDensity.compact,
      color: Theme.of(context).colorScheme.outline,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('반복 일정 안내'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('반복 일정은 아래 기준으로 자동 생성됩니다.'),
                SizedBox(height: 12),
                _InfoRow(label: '매일 / 매주', value: '3개월치 사전 생성'),
                SizedBox(height: 8),
                Text('월 단위', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                _InfoRow(label: '매월 (1개월마다)', value: '3개월치'),
                _InfoRow(label: '격월 (2개월마다)', value: '6개월치'),
                _InfoRow(label: '3개월마다', value: '9개월치'),
                SizedBox(height: 8),
                Text('연 단위', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                _InfoRow(label: '매년 (1년마다)', value: '13개월치'),
                _InfoRow(label: '2년마다', value: '25개월치'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('확인'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        children: [
          Text('· $label  ', style: Theme.of(context).textTheme.bodySmall),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _RecurringChip extends StatelessWidget {
  final String label;
  final RecurringRuleType? type;
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;
  final bool readOnly;

  const _RecurringChip({
    required this.label,
    required this.type,
    required this.formState,
    required this.formNotifier,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: formState.recurringType == type,
      onSelected: readOnly
          ? null
          : (selected) {
              if (selected) formNotifier.setRecurringType(type);
            },
    );
  }
}

/// 반복 상세 설정 섹션
class _RecurringDetailSection extends StatelessWidget {
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;
  final bool readOnly;

  const _RecurringDetailSection({
    required this.formState,
    required this.formNotifier,
    this.readOnly = false,
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
          _IntervalSection(
            formState: formState,
            formNotifier: formNotifier,
            readOnly: readOnly,
          ),
          const SizedBox(height: AppSizes.spaceM),
          _buildTypeSpecificSection(context),
          const SizedBox(height: AppSizes.spaceM),
          _EndConditionSection(
            formState: formState,
            formNotifier: formNotifier,
            readOnly: readOnly,
          ),
          const SizedBox(height: AppSizes.spaceM),
          _SkipSection(
            formState: formState,
            formNotifier: formNotifier,
            readOnly: readOnly,
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
          readOnly: readOnly,
        );
      case RecurringRuleType.monthly:
        return _MonthlySection(
          formState: formState,
          formNotifier: formNotifier,
          readOnly: readOnly,
        );
      case RecurringRuleType.yearly:
        return _YearlySection(
          formState: formState,
          formNotifier: formNotifier,
          readOnly: readOnly,
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
  final bool readOnly;

  const _IntervalSection({
    required this.formState,
    required this.formNotifier,
    this.readOnly = false,
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
        Text(l10n.schedule_recurringEvery, style: theme.textTheme.bodyMedium),
        const SizedBox(width: AppSizes.spaceS),
        SizedBox(
          width: 60,
          child: TextField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            readOnly: readOnly,
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
            onChanged: readOnly
                ? null
                : (value) {
                    final interval = int.tryParse(value);
                    if (interval != null && interval > 0) {
                      formNotifier.setRecurringInterval(interval);
                    }
                  },
          ),
        ),
        const SizedBox(width: AppSizes.spaceS),
        Text(unitLabel, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}

/// 주간 반복 설정 (요일 선택)
class _WeeklySection extends StatelessWidget {
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;
  final bool readOnly;

  const _WeeklySection({
    required this.formState,
    required this.formNotifier,
    this.readOnly = false,
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
              onSelected: readOnly
                  ? null
                  : (_) => formNotifier.toggleDayOfWeek(index),
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
  final bool readOnly;

  const _MonthlySection({
    required this.formState,
    required this.formNotifier,
    this.readOnly = false,
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
        SegmentedButton<MonthlyType>(
          showSelectedIcon: false,
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
          onSelectionChanged: readOnly
              ? null
              : (selection) => formNotifier.setMonthlyType(selection.first),
        ),
        const SizedBox(height: AppSizes.spaceS),
        if (formState.monthlyType == MonthlyType.dayOfMonth)
          _MonthlyDayPicker(
            formState: formState,
            formNotifier: formNotifier,
            readOnly: readOnly,
          )
        else
          _MonthlyWeekPicker(
            formState: formState,
            formNotifier: formNotifier,
            readOnly: readOnly,
          ),
      ],
    );
  }
}

/// 월간 - 날짜 선택
class _MonthlyDayPicker extends StatelessWidget {
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;
  final bool readOnly;

  const _MonthlyDayPicker({
    required this.formState,
    required this.formNotifier,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          l10n.schedule_recurringMonthlyEveryMonth,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(width: AppSizes.spaceS),
        FocusDismissDropdown(
          child: DropdownButton<int>(
            value: formState.monthlyDayOfMonth,
            items: List.generate(31, (i) => i + 1)
                .map((day) => DropdownMenuItem(value: day, child: Text('$day')))
                .toList(),
            onChanged: readOnly
                ? null
                : (value) {
                    if (value != null) formNotifier.setMonthlyDayOfMonth(value);
                  },
          ),
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
  final bool readOnly;

  const _MonthlyWeekPicker({
    required this.formState,
    required this.formNotifier,
    this.readOnly = false,
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
        Text(
          l10n.schedule_recurringMonthlyEveryMonth,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(width: AppSizes.spaceS),
        FocusDismissDropdown(
          child: DropdownButton<int>(
            value: formState.monthlyWeekOfMonth,
            items: List.generate(5, (i) => i + 1)
                .map(
                  (week) => DropdownMenuItem(
                    value: week,
                    child: Text(weekLabels[week - 1]),
                  ),
                )
                .toList(),
            onChanged: readOnly
                ? null
                : (value) {
                    if (value != null)
                      formNotifier.setMonthlyWeekOfMonth(value);
                  },
          ),
        ),
        const SizedBox(width: AppSizes.spaceS),
        FocusDismissDropdown(
          child: DropdownButton<int>(
            value: formState.monthlyDayOfWeek,
            items: List.generate(7, (i) => i)
                .map(
                  (day) =>
                      DropdownMenuItem(value: day, child: Text(dayLabels[day])),
                )
                .toList(),
            onChanged: readOnly
                ? null
                : (value) {
                    if (value != null) formNotifier.setMonthlyDayOfWeek(value);
                  },
          ),
        ),
      ],
    );
  }
}

/// 연간 반복 설정
class _YearlySection extends StatelessWidget {
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;
  final bool readOnly;

  const _YearlySection({
    required this.formState,
    required this.formNotifier,
    this.readOnly = false,
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
        Wrap(
          spacing: AppSizes.spaceS,
          runSpacing: AppSizes.spaceS,
          children: [
            ChoiceChip(
              label: Text(l10n.schedule_recurringYearlyDayOfMonth),
              selected: formState.yearlyType == YearlyType.dayOfMonth,
              onSelected: readOnly
                  ? null
                  : (_) => formNotifier.setYearlyType(YearlyType.dayOfMonth),
            ),
            ChoiceChip(
              label: Text(l10n.schedule_recurringYearlyWeekOfMonth),
              selected: formState.yearlyType == YearlyType.weekOfMonth,
              onSelected: readOnly
                  ? null
                  : (_) => formNotifier.setYearlyType(YearlyType.weekOfMonth),
            ),
            ChoiceChip(
              label: const Text('음력'),
              selected: formState.yearlyType == YearlyType.lunar,
              onSelected: readOnly
                  ? null
                  : (_) => formNotifier.setYearlyType(YearlyType.lunar),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spaceS),
        if (formState.yearlyType == YearlyType.dayOfMonth)
          _YearlyDayPicker(
            formState: formState,
            formNotifier: formNotifier,
            readOnly: readOnly,
          )
        else if (formState.yearlyType == YearlyType.weekOfMonth)
          _YearlyWeekPicker(
            formState: formState,
            formNotifier: formNotifier,
            readOnly: readOnly,
          )
        else
          _YearlyLunarPickerButton(
            formState: formState,
            formNotifier: formNotifier,
            readOnly: readOnly,
          ),
      ],
    );
  }
}

/// 연간 - 날짜 선택
class _YearlyDayPicker extends StatelessWidget {
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;
  final bool readOnly;

  const _YearlyDayPicker({
    required this.formState,
    required this.formNotifier,
    this.readOnly = false,
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
        Text(
          l10n.schedule_recurringYearlyEveryYear,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(width: AppSizes.spaceS),
        FocusDismissDropdown(
          child: DropdownButton<int>(
            value: formState.yearlyMonth,
            items: List.generate(12, (i) => i + 1)
                .map(
                  (month) => DropdownMenuItem(
                    value: month,
                    child: Text(monthLabels[month - 1]),
                  ),
                )
                .toList(),
            onChanged: readOnly
                ? null
                : (value) {
                    if (value != null) formNotifier.setYearlyMonth(value);
                  },
          ),
        ),
        const SizedBox(width: AppSizes.spaceS),
        FocusDismissDropdown(
          child: DropdownButton<int>(
            value: formState.yearlyDayOfMonth,
            items: List.generate(31, (i) => i + 1)
                .map((day) => DropdownMenuItem(value: day, child: Text('$day')))
                .toList(),
            onChanged: readOnly
                ? null
                : (value) {
                    if (value != null) formNotifier.setYearlyDayOfMonth(value);
                  },
          ),
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
  final bool readOnly;

  const _YearlyWeekPicker({
    required this.formState,
    required this.formNotifier,
    this.readOnly = false,
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
        Text(
          l10n.schedule_recurringYearlyEveryYear,
          style: theme.textTheme.bodyMedium,
        ),
        FocusDismissDropdown(
          child: DropdownButton<int>(
            value: formState.yearlyMonth,
            items: List.generate(12, (i) => i + 1)
                .map(
                  (month) => DropdownMenuItem(
                    value: month,
                    child: Text(monthLabels[month - 1]),
                  ),
                )
                .toList(),
            onChanged: readOnly
                ? null
                : (value) {
                    if (value != null) formNotifier.setYearlyMonth(value);
                  },
          ),
        ),
        FocusDismissDropdown(
          child: DropdownButton<int>(
            value: formState.yearlyWeekOfMonth,
            items: List.generate(5, (i) => i + 1)
                .map(
                  (week) => DropdownMenuItem(
                    value: week,
                    child: Text(weekLabels[week - 1]),
                  ),
                )
                .toList(),
            onChanged: readOnly
                ? null
                : (value) {
                    if (value != null) formNotifier.setYearlyWeekOfMonth(value);
                  },
          ),
        ),
        FocusDismissDropdown(
          child: DropdownButton<int>(
            value: formState.yearlyDayOfWeek,
            items: List.generate(7, (i) => i)
                .map(
                  (day) =>
                      DropdownMenuItem(value: day, child: Text(dayLabels[day])),
                )
                .toList(),
            onChanged: readOnly
                ? null
                : (value) {
                    if (value != null) formNotifier.setYearlyDayOfWeek(value);
                  },
          ),
        ),
      ],
    );
  }
}

/// 연간 - 음력 날짜 선택 버튼 (탭 시 바텀시트)
class _YearlyLunarPickerButton extends StatelessWidget {
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;
  final bool readOnly;

  const _YearlyLunarPickerButton({
    required this.formState,
    required this.formNotifier,
    this.readOnly = false,
  });

  String get _label {
    final prefix = formState.lunarIsLeap ? '윤' : '';
    return '음력 $prefix${formState.lunarMonth}월 ${formState.lunarDay}일';
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _LunarPickerSheet(
        initialMonth: formState.lunarMonth,
        initialDay: formState.lunarDay,
        initialIsLeap: formState.lunarIsLeap,
        onChanged:
            ({required int month, required int day, required bool isLeap}) {
              formNotifier.setLunarMonth(month);
              formNotifier.setLunarDay(day);
              formNotifier.setLunarIsLeap(isLeap);
            },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: readOnly ? null : () => _showPicker(context),
      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
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
            Icon(
              Icons.calendar_month_outlined,
              size: 18,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: AppSizes.spaceS),
            Text(_label, style: theme.textTheme.bodyMedium),
            const SizedBox(width: AppSizes.spaceS),
            Icon(
              Icons.arrow_drop_down,
              size: 18,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

/// 음력 날짜 선택 바텀시트
class _LunarPickerSheet extends StatefulWidget {
  final int initialMonth;
  final int initialDay;
  final bool initialIsLeap;
  final void Function({
    required int month,
    required int day,
    required bool isLeap,
  })
  onChanged;

  const _LunarPickerSheet({
    required this.initialMonth,
    required this.initialDay,
    required this.initialIsLeap,
    required this.onChanged,
  });

  @override
  State<_LunarPickerSheet> createState() => _LunarPickerSheetState();
}

class _LunarPickerSheetState extends State<_LunarPickerSheet> {
  late int _month;
  late int _day;
  late bool _isLeap;

  @override
  void initState() {
    super.initState();
    _month = widget.initialMonth;
    _day = widget.initialDay;
    _isLeap = widget.initialIsLeap;
  }

  void _apply() {
    widget.onChanged(month: _month, day: _day, isLeap: _isLeap);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: AppSizes.spaceL,
        right: AppSizes.spaceL,
        top: AppSizes.spaceL,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.spaceL,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 핸들
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.spaceL),
          Text(
            '음력 날짜 선택',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.spaceL),
          // 월 선택
          Text(
            '월',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSizes.spaceXS),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 12,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: AppSizes.spaceXS),
              itemBuilder: (_, i) {
                final m = i + 1;
                final selected = _month == m;
                return ChoiceChip(
                  label: Text('$m월'),
                  selected: selected,
                  visualDensity: VisualDensity.compact,
                  onSelected: (_) => setState(() => _month = m),
                );
              },
            ),
          ),
          const SizedBox(height: AppSizes.spaceM),
          // 일 선택
          Text(
            '일',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSizes.spaceXS),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 30,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: AppSizes.spaceXS),
              itemBuilder: (_, i) {
                final d = i + 1;
                final selected = _day == d;
                return ChoiceChip(
                  label: Text('$d일'),
                  selected: selected,
                  visualDensity: VisualDensity.compact,
                  onSelected: (_) => setState(() => _day = d),
                );
              },
            ),
          ),
          const SizedBox(height: AppSizes.spaceM),
          // 윤달
          Row(
            children: [
              Checkbox(
                value: _isLeap,
                onChanged: (v) => setState(() => _isLeap = v ?? false),
              ),
              Text('윤달', style: theme.textTheme.bodyMedium),
              const SizedBox(width: AppSizes.spaceS),
              Flexible(
                child: Text(
                  '윤달이 없는 해에는 해당 달의 같은 날로 처리됩니다',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceL),
          SizedBox(
            width: double.infinity,
            child: FilledButton(onPressed: _apply, child: const Text('확인')),
          ),
        ],
      ),
    );
  }
}

/// 종료 조건 설정
class _EndConditionSection extends StatelessWidget {
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;
  final bool readOnly;

  const _EndConditionSection({
    required this.formState,
    required this.formNotifier,
    this.readOnly = false,
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
        Wrap(
          spacing: AppSizes.spaceS,
          runSpacing: AppSizes.spaceS,
          children: [
            ChoiceChip(
              label: Text(l10n.schedule_recurringEndNever),
              selected: formState.recurringEndType == RecurringEndType.never,
              onSelected: readOnly
                  ? null
                  : (_) => formNotifier.setRecurringEndType(
                      RecurringEndType.never,
                    ),
            ),
            ChoiceChip(
              label: Text(l10n.schedule_recurringEndDate),
              selected: formState.recurringEndType == RecurringEndType.date,
              onSelected: readOnly
                  ? null
                  : (_) =>
                        formNotifier.setRecurringEndType(RecurringEndType.date),
            ),
            ChoiceChip(
              label: Text(l10n.schedule_recurringEndCount),
              selected: formState.recurringEndType == RecurringEndType.count,
              onSelected: readOnly
                  ? null
                  : (_) => formNotifier.setRecurringEndType(
                      RecurringEndType.count,
                    ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spaceS),
        if (formState.recurringEndType == RecurringEndType.date)
          _EndDatePicker(
            formState: formState,
            formNotifier: formNotifier,
            readOnly: readOnly,
          )
        else if (formState.recurringEndType == RecurringEndType.count)
          _EndCountPicker(
            formState: formState,
            formNotifier: formNotifier,
            readOnly: readOnly,
          ),
      ],
    );
  }
}

/// 종료 날짜 선택
class _EndDatePicker extends StatelessWidget {
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;
  final bool readOnly;

  const _EndDatePicker({
    required this.formState,
    required this.formNotifier,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final endDate =
        formState.recurringEndDate ??
        formState.startDate.add(const Duration(days: 30));

    return InkWell(
      onTap: readOnly
          ? null
          : () async {
              final date = await showDatePicker(
                context: context,
                initialDate: endDate,
                firstDate: formState.startDate,
                lastDate: formState.startDate.add(
                  const Duration(days: 365 * 10),
                ),
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
            Icon(
              Icons.calendar_today,
              size: 18,
              color: theme.colorScheme.primary,
            ),
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

/// 주말/공휴일 건너뜀 설정
class _SkipSection extends StatelessWidget {
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;
  final bool readOnly;

  const _SkipSection({
    required this.formState,
    required this.formNotifier,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasSkip = formState.skipWeekends || formState.skipHolidays;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '건너뜀 설정',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSizes.spaceS),
        Row(
          children: [
            _SkipChip(
              label: '주말',
              icon: Icons.weekend_outlined,
              selected: formState.skipWeekends,
              readOnly: readOnly,
              onTap: () =>
                  formNotifier.setSkipWeekends(!formState.skipWeekends),
            ),
            const SizedBox(width: AppSizes.spaceS),
            _SkipChip(
              label: '공휴일',
              icon: Icons.celebration_outlined,
              selected: formState.skipHolidays,
              readOnly: readOnly,
              onTap: () =>
                  formNotifier.setSkipHolidays(!formState.skipHolidays),
            ),
          ],
        ),
        if (hasSkip) ...[
          const SizedBox(height: AppSizes.spaceS),
          Text(
            '건너뛸 때',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSizes.spaceXS),
          SegmentedButton<SkipBehavior>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(
                value: SkipBehavior.skip,
                label: Text('건너뜀'),
                icon: Icon(Icons.skip_next_outlined),
              ),
              ButtonSegment(
                value: SkipBehavior.moveToNextWeekday,
                label: Text('다음 평일로'),
                icon: Icon(Icons.arrow_forward_outlined),
              ),
            ],
            selected: {formState.skipBehavior ?? SkipBehavior.skip},
            onSelectionChanged: readOnly
                ? null
                : (selection) => formNotifier.setSkipBehavior(selection.first),
          ),
        ],
      ],
    );
  }
}

class _SkipChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final bool readOnly;
  final VoidCallback onTap;

  const _SkipChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.readOnly,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      avatar: Icon(icon, size: 16, color: selected ? AppColors.primary : null),
      selected: selected,
      onSelected: readOnly ? null : (_) => onTap(),
    );
  }
}

/// 종료 횟수 선택
class _EndCountPicker extends StatelessWidget {
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;
  final bool readOnly;

  const _EndCountPicker({
    required this.formState,
    required this.formNotifier,
    this.readOnly = false,
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
            readOnly: readOnly,
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
            onChanged: readOnly
                ? null
                : (value) {
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
