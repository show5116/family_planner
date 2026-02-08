import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 주간 날짜 선택 바
class TodoWeekBar extends ConsumerWidget {
  const TodoWeekBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final weekStart = ref.watch(todoSelectedWeekStartProvider);
    final selectedDate = ref.watch(todoSelectedDateProvider);
    final todoCountByDate = ref.watch(todoCountByDateProvider);
    final weekEnd = DateTime(weekStart.year, weekStart.month, weekStart.day + 6);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 주간 네비게이션 (이전주 / 날짜 범위 / 다음주)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceS,
              vertical: AppSizes.spaceXS,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => _changeWeek(ref, weekStart, -7),
                  tooltip: l10n.todo_prevWeek,
                  iconSize: 20,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickDate(context, ref, selectedDate),
                    child: Text(
                      _formatWeekRange(weekStart, weekEnd, l10n),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                // 오늘 버튼
                TextButton(
                  onPressed: () => _goToToday(ref),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceS),
                    minimumSize: const Size(0, 32),
                  ),
                  child: Text(
                    l10n.schedule_today,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => _changeWeek(ref, weekStart, 7),
                  tooltip: l10n.todo_nextWeek,
                  iconSize: 20,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
              ],
            ),
          ),

          // 요일 버튼 행
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.spaceS,
              0,
              AppSizes.spaceS,
              AppSizes.spaceS,
            ),
            child: Row(
              children: List.generate(7, (index) {
                final date = DateTime(
                  weekStart.year,
                  weekStart.month,
                  weekStart.day + index,
                );
                final normalizedDate = DateTime(date.year, date.month, date.day);
                final isToday = normalizedDate == today;
                final isSelected = normalizedDate == selectedDate;
                final taskCount = todoCountByDate[normalizedDate] ?? 0;

                return Expanded(
                  child: _DayChip(
                    date: date,
                    isToday: isToday,
                    isSelected: isSelected,
                    taskCount: taskCount,
                    onTap: () => _selectDate(ref, date),
                    l10n: l10n,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  void _changeWeek(WidgetRef ref, DateTime current, int days) {
    final newWeekStart = DateTime(current.year, current.month, current.day + days);
    ref.read(todoSelectedWeekStartProvider.notifier).state = newWeekStart;
    // 주가 변경되면 선택 날짜도 해당 주의 첫날로 변경
    ref.read(todoSelectedDateProvider.notifier).state = newWeekStart;
  }

  void _goToToday(WidgetRef ref) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final monday = DateTime(now.year, now.month, now.day - (now.weekday - 1));
    ref.read(todoSelectedWeekStartProvider.notifier).state = monday;
    ref.read(todoSelectedDateProvider.notifier).state = today;
  }

  void _selectDate(WidgetRef ref, DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    ref.read(todoSelectedDateProvider.notifier).state = normalizedDate;
  }

  Future<void> _pickDate(
    BuildContext context,
    WidgetRef ref,
    DateTime current,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      // 선택한 날짜가 속한 주의 월요일로 설정
      final monday = DateTime(picked.year, picked.month, picked.day - (picked.weekday - 1));
      final normalizedPicked = DateTime(picked.year, picked.month, picked.day);
      ref.read(todoSelectedWeekStartProvider.notifier).state = monday;
      ref.read(todoSelectedDateProvider.notifier).state = normalizedPicked;
    }
  }

  String _formatWeekRange(DateTime start, DateTime end, AppLocalizations l10n) {
    if (start.month == end.month) {
      return '${start.year}.${start.month.toString().padLeft(2, '0')}.${start.day.toString().padLeft(2, '0')} - ${end.day.toString().padLeft(2, '0')}';
    }
    return '${start.month.toString().padLeft(2, '0')}.${start.day.toString().padLeft(2, '0')} - ${end.month.toString().padLeft(2, '0')}.${end.day.toString().padLeft(2, '0')}';
  }
}

/// 요일 칩
class _DayChip extends StatelessWidget {
  final DateTime date;
  final bool isToday;
  final bool isSelected;
  final int taskCount;
  final VoidCallback onTap;
  final AppLocalizations l10n;

  const _DayChip({
    required this.date,
    required this.isToday,
    required this.isSelected,
    required this.taskCount,
    required this.onTap,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final dayNames = [
      l10n.schedule_dayMon,
      l10n.schedule_dayTue,
      l10n.schedule_dayWed,
      l10n.schedule_dayThu,
      l10n.schedule_dayFri,
      l10n.schedule_daySat,
      l10n.schedule_daySun,
    ];

    final isSunday = date.weekday == DateTime.sunday;
    final isSaturday = date.weekday == DateTime.saturday;

    Color dayColor;
    if (isSunday) {
      dayColor = AppColors.error;
    } else if (isSaturday) {
      dayColor = AppColors.primary;
    } else {
      dayColor = AppColors.textSecondary;
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            dayNames[date.weekday - 1],
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isSelected ? AppColors.primary : dayColor,
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : isToday
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.transparent,
              shape: BoxShape.circle,
              border: isToday && !isSelected
                  ? Border.all(color: AppColors.primary, width: 1.5)
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              '${date.day}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? Colors.white
                    : isToday
                        ? AppColors.primary
                        : AppColors.textPrimary,
                fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(height: 2),
          // 할일 개수 표시 (점)
          if (taskCount > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                taskCount > 3 ? 3 : taskCount,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            )
          else
            const SizedBox(height: 4),
        ],
      ),
    );
  }
}
