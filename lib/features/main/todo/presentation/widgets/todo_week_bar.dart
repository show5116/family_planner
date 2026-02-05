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
                    onTap: () => _pickDate(context, ref, weekStart),
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
                  onPressed: () => _goToThisWeek(ref),
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
                final isToday = date == today;

                return Expanded(
                  child: _DayChip(
                    date: date,
                    isToday: isToday,
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
    ref.read(todoSelectedWeekStartProvider.notifier).state =
        DateTime(current.year, current.month, current.day + days);
  }

  void _goToThisWeek(WidgetRef ref) {
    final now = DateTime.now();
    ref.read(todoSelectedWeekStartProvider.notifier).state =
        DateTime(now.year, now.month, now.day - (now.weekday - 1));
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
      ref.read(todoSelectedWeekStartProvider.notifier).state = monday;
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
  final AppLocalizations l10n;

  const _DayChip({
    required this.date,
    required this.isToday,
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          dayNames[date.weekday - 1],
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: dayColor,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isToday ? AppColors.primary : Colors.transparent,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '${date.day}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isToday ? Colors.white : AppColors.textPrimary,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
