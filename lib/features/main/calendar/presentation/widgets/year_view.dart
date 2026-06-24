import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';

/// 연도 뷰 — 12개월 미니 캘린더 그리드 (Google Calendar 스타일)
class YearView extends ConsumerWidget {
  final int year;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onMonthTap;
  final VoidCallback? onViewModeTap;
  final String? viewModeLabel;

  const YearView({
    super.key,
    required this.year,
    required this.selectedDate,
    required this.onMonthTap,
    this.onViewModeTap,
    this.viewModeLabel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now();

    // 1~12월 이벤트 도트용 카운트 맵 수집
    // 올해에 대해 month별로 watch
    final countMaps = List.generate(12, (i) {
      final m = i + 1;
      return ref.watch(taskCountByDateProvider(year, m));
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(
        children: [
          // 연도 네비게이션 헤더
          _YearHeader(
            year: year,
            onMonthTap: onMonthTap,
            onViewModeTap: onViewModeTap,
            viewModeLabel: viewModeLabel,
          ),
          const SizedBox(height: 12),

          // 12개월 그리드 (3열 × 4행)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisExtent: 195,
              crossAxisSpacing: 8,
              mainAxisSpacing: 12,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              final month = index + 1;
              return _MiniMonthCalendar(
                year: year,
                month: month,
                today: today,
                selectedDate: selectedDate,
                eventCountMap: countMaps[index],
                onTap: () => onMonthTap(DateTime(year, month, 1)),
                onDayTap: (date) => onMonthTap(date),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 연도 헤더
// ─────────────────────────────────────────────────────────────────────────────

class _YearHeader extends StatelessWidget {
  final int year;
  final ValueChanged<DateTime> onMonthTap;
  final VoidCallback? onViewModeTap;
  final String? viewModeLabel;

  const _YearHeader({
    required this.year,
    required this.onMonthTap,
    this.onViewModeTap,
    this.viewModeLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$year년',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        if (onViewModeTap != null) ...[
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onViewModeTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    viewModeLabel ?? '연도',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const Icon(Icons.arrow_drop_down, size: 14),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 미니 월 캘린더
// ─────────────────────────────────────────────────────────────────────────────

class _MiniMonthCalendar extends StatelessWidget {
  final int year;
  final int month;
  final DateTime today;
  final DateTime selectedDate;
  final Map<DateTime, int> eventCountMap;
  final VoidCallback onTap;
  final ValueChanged<DateTime> onDayTap;

  const _MiniMonthCalendar({
    required this.year,
    required this.month,
    required this.today,
    required this.selectedDate,
    required this.eventCountMap,
    required this.onTap,
    required this.onDayTap,
  });

  static const _dayNames = ['일', '월', '화', '수', '목', '금', '토'];

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final isCurrentMonth =
        today.year == year && today.month == month;
    final isSelectedMonth =
        selectedDate.year == year && selectedDate.month == month;

    final monthLabel = DateFormat('M월', locale).format(DateTime(year, month));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelectedMonth
              ? AppColors.primary.withValues(alpha: 0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isCurrentMonth
              ? Border.all(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  width: 1,
                )
              : null,
        ),
        padding: const EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 월 제목
            Padding(
              padding: const EdgeInsets.only(left: 2, bottom: 4),
              child: Text(
                monthLabel,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isCurrentMonth ? AppColors.primary : null,
                    ),
              ),
            ),

            // 요일 헤더 (일~토)
            Row(
              children: _dayNames.asMap().entries.map((e) {
                final i = e.key;
                Color c;
                if (i == 0) {
                  c = AppColors.error.withValues(alpha: 0.7);
                } else if (i == 6) {
                  c = AppColors.primary.withValues(alpha: 0.7);
                } else {
                  c = AppColors.textSecondary;
                }
                return Expanded(
                  child: Text(
                    e.value,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: c,
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 2),

            // 날짜 그리드
            _buildDayGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDayGrid(BuildContext context) {
    // 해당 월 1일의 요일 (0=일, 6=토)
    final firstDay = DateTime(year, month, 1);
    final startOffset = firstDay.weekday % 7; // 0=일 기준
    final daysInMonth = DateUtils.getDaysInMonth(year, month);
    final totalCells = startOffset + daysInMonth;
    final rows = (totalCells / 7).ceil();

    // 각 행을 고정 높이(24px)로 렌더링해 overflow 방지
    const rowH = 24.0;
    return SizedBox(
      height: rows * rowH,
      child: Column(
        children: List.generate(rows, (row) {
          return SizedBox(
            height: rowH,
            child: Row(
              children: List.generate(7, (col) {
                final cellIndex = row * 7 + col;
                final day = cellIndex - startOffset + 1;
                if (day < 1 || day > daysInMonth) {
                  return const Expanded(child: SizedBox());
                }
                return Expanded(child: _DayCell(
                  day: day,
                  year: year,
                  month: month,
                  today: today,
                  selectedDate: selectedDate,
                  hasEvent: (eventCountMap[DateTime(year, month, day)] ?? 0) > 0,
                  columnIndex: col,
                  onTap: onDayTap,
                ));
              }),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 날짜 셀
// ─────────────────────────────────────────────────────────────────────────────

class _DayCell extends StatelessWidget {
  final int day;
  final int year;
  final int month;
  final DateTime today;
  final DateTime selectedDate;
  final bool hasEvent;
  final int columnIndex; // 0=일, 6=토
  final ValueChanged<DateTime> onTap;

  const _DayCell({
    required this.day,
    required this.year,
    required this.month,
    required this.today,
    required this.selectedDate,
    required this.hasEvent,
    required this.columnIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final date = DateTime(year, month, day);
    final isToday =
        date.year == today.year && date.month == today.month && date.day == today.day;
    final isSelected = date.year == selectedDate.year &&
        date.month == selectedDate.month &&
        date.day == selectedDate.day;

    Color textColor;
    if (isSelected) {
      textColor = Colors.white;
    } else if (columnIndex == 0) {
      textColor = AppColors.error.withValues(alpha: 0.8);
    } else if (columnIndex == 6) {
      textColor = AppColors.primary;
    } else {
      textColor = Theme.of(context).colorScheme.onSurface;
    }

    return GestureDetector(
      onTap: () => onTap(date),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : isToday
                      ? AppColors.primary.withValues(alpha: 0.2)
                      : Colors.transparent,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$day',
              style: TextStyle(
                fontSize: 9,
                fontWeight:
                    isToday || isSelected ? FontWeight.bold : FontWeight.normal,
                color: textColor,
                height: 1,
              ),
            ),
          ),
          if (hasEvent)
            Container(
              width: 3,
              height: 3,
              margin: const EdgeInsets.only(top: 1),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.8)
                    : AppColors.primary.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
            )
          else
            const SizedBox(height: 4),
        ],
      ),
    );
  }
}
