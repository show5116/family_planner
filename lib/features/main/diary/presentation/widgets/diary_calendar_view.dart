import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/diary/data/models/diary_models.dart';
import 'package:family_planner/features/main/diary/data/utils/diary_date.dart';
import 'package:family_planner/features/main/diary/providers/diary_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';

/// 캘린더 뷰 — 날짜를 알 때 찾아가는 뷰
///
/// 그룹 필터가 켜져 있으면 같은 날짜에 여러 사람의 일기가 올 수 있다
/// (하루 1편은 **사용자별** 제약이므로). 그래서 셀에 개수 뱃지를 표시한다.
class DiaryCalendarView extends ConsumerWidget {
  const DiaryCalendarView({super.key, required this.onDayTap});

  /// 날짜를 눌렀을 때 — 해당 날짜의 일기 목록을 넘긴다 (없으면 빈 목록)
  final void Function(String date, List<DiaryCalendarDay> entries) onDayTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final calendarAsync = ref.watch(diaryCalendarProvider);
    final focusedMonth = ref.watch(diaryCalendarMonthProvider);

    return calendarAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => AppErrorState(
        error: error,
        title: l10n.diary_load_error,
        onRetry: () => ref.invalidate(diaryCalendarProvider),
      ),
      data: (days) {
        // 날짜별로 묶어둔다 — 그룹 뷰에서는 한 날짜에 여러 건이 올 수 있다
        final byDate = <String, List<DiaryCalendarDay>>{};
        for (final day in days) {
          byDate.putIfAbsent(day.date, () => []).add(day);
        }

        return Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2000, 1, 1),
              lastDay: DateTime.utc(2100, 12, 31),
              focusedDay: focusedMonth,
              calendarFormat: CalendarFormat.month,
              locale: Localizations.localeOf(context).toString(),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              onPageChanged: (focused) {
                ref.read(diaryCalendarMonthProvider.notifier).state =
                    DateTime(focused.year, focused.month);
              },
              onDaySelected: (selected, _) {
                final date = toDiaryDate(selected);
                onDayTap(date, byDate[date] ?? const []);
              },
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, _) =>
                    _DayCell(day: day, entries: byDate[toDiaryDate(day)]),
                todayBuilder: (context, day, _) => _DayCell(
                  day: day,
                  entries: byDate[toDiaryDate(day)],
                  isToday: true,
                ),
              ),
            ),
            if (days.isEmpty)
              Padding(
                padding: const EdgeInsets.all(AppSizes.spaceL),
                child: Text(
                  l10n.diary_calendar_empty,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.entries,
    this.isToday = false,
  });

  final DateTime day;
  final List<DiaryCalendarDay>? entries;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final list = entries ?? const <DiaryCalendarDay>[];
    final hasEntry = list.isNotEmpty;

    // 기분이 있으면 숫자 대신 이모지를 보여준다 — 훨씬 빨리 읽힌다
    final mood = list.firstWhere(
      (e) => e.mood != null,
      orElse: () => const DiaryCalendarDay(
        date: '',
        diaryId: '',
        userId: '',
        authorName: '',
      ),
    ).mood;

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: hasEntry
            ? colorScheme.primary.withValues(alpha: 0.12)
            : Colors.transparent,
        shape: BoxShape.circle,
        border: isToday
            ? Border.all(color: colorScheme.primary, width: 2)
            : null,
      ),
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (mood != null)
            Text(mood, style: const TextStyle(fontSize: 16))
          else
            Text(
              '${day.day}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: hasEntry
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight:
                    hasEntry || isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          // 그룹 뷰에서 같은 날 여러 명이 썼을 때만 개수를 표시한다
          if (list.length > 1)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                ),
                child: Text(
                  '${list.length}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSecondary,
                    fontSize: 9,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
