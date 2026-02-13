import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

// 분리된 위젯 import
import 'package:family_planner/features/main/calendar/presentation/widgets/calendar_view.dart';
import 'package:family_planner/features/main/calendar/presentation/widgets/calendar_group_selector.dart';
import 'package:family_planner/features/main/calendar/presentation/widgets/task_list_section.dart';
import 'package:family_planner/features/main/calendar/presentation/widgets/calendar_search_bar.dart';
import 'package:family_planner/features/main/calendar/presentation/widgets/calendar_search_results.dart';

/// 일정 관리 탭 (월간 캘린더 뷰)
class CalendarTab extends ConsumerStatefulWidget {
  const CalendarTab({super.key});

  @override
  ConsumerState<CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends ConsumerState<CalendarTab> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedDate = ref.watch(selectedDateProvider);
    final focusedMonth = ref.watch(focusedMonthProvider);

    // 현재 보고 있는 월의 Task 데이터
    final tasksAsync = ref.watch(
      monthlyTasksProvider(focusedMonth.year, focusedMonth.month),
    );

    return Scaffold(
      appBar: AppBar(
        title: const CalendarGroupSelector(),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            tooltip: l10n.schedule_today,
            onPressed: _goToToday,
          ),
          IconButton(
            icon: Icon(
              ref.watch(calendarSearchActiveProvider)
                  ? Icons.search_off
                  : Icons.search,
            ),
            tooltip: l10n.common_search,
            onPressed: () {
              final isActive = ref.read(calendarSearchActiveProvider);
              if (isActive) {
                ref.read(calendarSearchQueryProvider.notifier).state = null;
                ref.read(calendarSearchActiveProvider.notifier).state = false;
              } else {
                ref.read(calendarSearchActiveProvider.notifier).state = true;
              }
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'categories') {
                context.push('/calendar/categories');
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'categories',
                child: Row(
                  children: [
                    const Icon(Icons.category_outlined, size: 20),
                    const SizedBox(width: AppSizes.spaceS),
                    Text(l10n.category_management),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // 검색바 (검색 모드일 때 표시)
          if (ref.watch(calendarSearchActiveProvider))
            const CalendarSearchBar(),

          // 검색 쿼리가 있으면 검색 결과, 아니면 캘린더 뷰
          if (ref.watch(calendarSearchQueryProvider) != null) ...[
            const Expanded(
              child: CalendarSearchResults(),
            ),
          ] else ...[
            // 월간 캘린더
            CalendarView(
              tasksAsync: tasksAsync,
              focusedDay: _focusedDay,
              selectedDay: _selectedDay,
              calendarFormat: _calendarFormat,
              onDaySelected: _onDaySelected,
              onPageChanged: _onPageChanged,
              onFormatChanged: _onFormatChanged,
            ),

            const Divider(height: 1),

            // 선택된 날짜 일정 목록
            Expanded(
              child: TaskListSection(selectedDate: selectedDate),
            ),
          ],
        ],
      ),
      floatingActionButton: ref.watch(calendarSearchQueryProvider) != null
          ? null
          : FloatingActionButton(
              heroTag: 'calendar_fab',
              onPressed: () {
                context.push('/calendar/add', extra: selectedDate);
              },
              tooltip: l10n.schedule_add,
              child: const Icon(Icons.add),
            ),
    );
  }

  /// 오늘 날짜로 이동
  void _goToToday() {
    final today = DateTime.now();
    setState(() {
      _focusedDay = today;
      _selectedDay = today;
    });
    ref.read(selectedDateProvider.notifier).state = today;
    ref.read(focusedMonthProvider.notifier).state = today;
  }

  /// 날짜 선택 시
  void _onDaySelected(DateTime selectedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = selectedDay;
    });
    ref.read(selectedDateProvider.notifier).state = selectedDay;
  }

  /// 페이지(월) 변경 시
  void _onPageChanged(DateTime focusedDay) {
    _focusedDay = focusedDay;
    ref.read(focusedMonthProvider.notifier).state = focusedDay;
  }

  /// 캘린더 포맷 변경 시
  void _onFormatChanged(CalendarFormat format) {
    if (_calendarFormat != format) {
      setState(() {
        _calendarFormat = format;
      });
    }
  }
}
