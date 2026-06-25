import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/shared/widgets/app_bar_more_menu.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/features/onboarding/presentation/widgets/feature_coach_mark.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

// 분리된 위젯 import
import 'package:family_planner/features/main/calendar/presentation/widgets/calendar_view.dart';
import 'package:family_planner/features/main/calendar/presentation/widgets/task_list_section.dart';
import 'package:family_planner/features/main/calendar/presentation/widgets/calendar_search_bar.dart';
import 'package:family_planner/features/main/calendar/presentation/widgets/calendar_search_results.dart';
import 'package:family_planner/features/main/calendar/presentation/widgets/calendar_group_selector.dart';
import 'package:family_planner/features/main/calendar/presentation/widgets/week_timetable_view.dart';
import 'package:family_planner/features/main/calendar/presentation/widgets/day_view.dart';
import 'package:family_planner/features/main/calendar/presentation/widgets/year_view.dart';
import 'package:family_planner/shared/widgets/group_filter_bar.dart';

part '_calendar_onboarding.dart';

/// 일정 관리 탭 (월간 캘린더 뷰)
class CalendarTab extends ConsumerStatefulWidget {
  const CalendarTab({super.key});

  @override
  ConsumerState<CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends ConsumerState<CalendarTab> {
  CalendarViewMode _viewMode = CalendarViewMode.month;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final _fabKey = GlobalKey();
  final _calendarKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _scheduleCoachMark();
  }

  String get _viewModeLabel {
    switch (_viewMode) {
      case CalendarViewMode.day:   return '일';
      case CalendarViewMode.week:  return '주';
      case CalendarViewMode.month: return '월';
      case CalendarViewMode.year:  return '연도';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedDate = ref.watch(selectedDateProvider);
    final focusedMonth = ref.watch(focusedMonthProvider);

    final tasksAsync = ref.watch(
      monthlyTasksProvider(focusedMonth.year, focusedMonth.month),
    );

    final isLoading = tasksAsync.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.nav_calendar),
        bottom: isLoading
            ? const PreferredSize(
                preferredSize: Size.fromHeight(2),
                child: LinearProgressIndicator(),
              )
            : null,
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
          AppBarMoreMenu(
            onReplayOnboarding: _replayOnboarding,
            extraItems: [
              MoreMenuItem(
                id: 'anniversaries',
                icon: Icons.celebration_outlined,
                label: '기념일 관리',
                onTap: (ctx) => ctx.push('/calendar/anniversaries'),
              ),
              MoreMenuItem(
                id: 'categories',
                icon: Icons.category_outlined,
                label: l10n.category_management,
                onTap: (ctx) => ctx.push('/calendar/categories'),
              ),
            ],
          ),
        ],
      ),
      body: ref.watch(calendarSearchQueryProvider) != null
          ? Column(
              children: [
                _CalendarGroupFilterBar(),
                if (ref.watch(calendarSearchActiveProvider))
                  const CalendarSearchBar(),
                const Expanded(child: CalendarSearchResults()),
              ],
            )
          : _buildBody(context, selectedDate, tasksAsync),
      floatingActionButton: ref.watch(calendarSearchQueryProvider) != null
          ? null
          : FloatingActionButton(
              key: _fabKey,
              heroTag: 'calendar_fab',
              onPressed: () {
                context.push('/calendar/add', extra: selectedDate);
              },
              tooltip: l10n.schedule_add,
              child: const Icon(Icons.add),
            ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    DateTime selectedDate,
    AsyncValue<List<TaskModel>> tasksAsync,
  ) {
    switch (_viewMode) {
      case CalendarViewMode.day:
        return Column(
          children: [
            _CalendarGroupFilterBar(),
            if (ref.watch(calendarSearchActiveProvider))
              const CalendarSearchBar(),
            Expanded(
              child: DayView(
                selectedDate: selectedDate,
                onDayChanged: _onDaySelected,
                onViewModeTap: _showViewModeSheet,
                viewModeLabel: _viewModeLabel,
              ),
            ),
          ],
        );

      case CalendarViewMode.week:
        return Column(
          children: [
            _CalendarGroupFilterBar(),
            if (ref.watch(calendarSearchActiveProvider))
              const CalendarSearchBar(),
            CalendarView(
              key: _calendarKey,
              tasksAsync: tasksAsync,
              focusedDay: _focusedDay,
              selectedDay: _selectedDay,
              calendarFormat: CalendarFormat.week,
              onDaySelected: _onDaySelected,
              onPageChanged: _onPageChanged,
              onFormatChanged: _onCalendarFormatChanged,
              onViewModeTap: _showViewModeSheet,
              viewModeLabel: _viewModeLabel,
            ),
            const Divider(height: 1),
            Expanded(
              child: WeekTimetableView(
                selectedDate: selectedDate,
                onDaySelected: _onDaySelected,
                showDayHeader: false,
              ),
            ),
          ],
        );

      case CalendarViewMode.month:
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _CalendarGroupFilterBar()),

            if (ref.watch(calendarSearchActiveProvider))
              const SliverToBoxAdapter(child: CalendarSearchBar()),

            SliverToBoxAdapter(
              child: CalendarView(
                key: _calendarKey,
                tasksAsync: tasksAsync,
                focusedDay: _focusedDay,
                selectedDay: _selectedDay,
                calendarFormat: CalendarFormat.month,
                onDaySelected: _onDaySelected,
                onPageChanged: _onPageChanged,
                onFormatChanged: _onCalendarFormatChanged,
                onViewModeTap: _showViewModeSheet,
                viewModeLabel: _viewModeLabel,
              ),
            ),

            const SliverToBoxAdapter(child: Divider(height: 1)),

            SliverTaskListSection(selectedDate: selectedDate),
          ],
        );

      case CalendarViewMode.year:
        return Column(
          children: [
            _CalendarGroupFilterBar(),
            Expanded(
              child: YearView(
                year: _focusedDay.year,
                selectedDate: selectedDate,
                onMonthTap: (date) {
                  _onDaySelected(date);
                  _onViewModeChanged(CalendarViewMode.month);
                },
                onViewModeTap: _showViewModeSheet,
                viewModeLabel: _viewModeLabel,
              ),
            ),
          ],
        );
    }
  }

  void _goToToday() {
    final today = DateTime.now();
    setState(() {
      _focusedDay = today;
      _selectedDay = today;
    });
    ref.read(selectedDateProvider.notifier).state = today;
    ref.read(focusedMonthProvider.notifier).state = today;
  }

  void _onDaySelected(DateTime selectedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = selectedDay;
    });
    ref.read(selectedDateProvider.notifier).state = selectedDay;
  }

  void _onPageChanged(DateTime focusedDay) {
    _focusedDay = focusedDay;
    ref.read(focusedMonthProvider.notifier).state = focusedDay;
    if (_viewMode == CalendarViewMode.week) {
      setState(() => _selectedDay = focusedDay);
      ref.read(selectedDateProvider.notifier).state = focusedDay;
    }
  }

  void _onCalendarFormatChanged(CalendarFormat format) {
    // onViewModeTap 사용 시 table_calendar 내부 토글은 무시
  }

  void _onViewModeChanged(CalendarViewMode mode) {
    if (_viewMode == mode) return;
    setState(() => _viewMode = mode);
    ref.read(calendarViewModeProvider.notifier).state = mode;
  }

  /// 뷰 모드 선택 바텀시트
  void _showViewModeSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLarge)),
      ),
      builder: (ctx) => _ViewModeSheet(
        currentMode: _viewMode,
        onModeChanged: (mode) {
          Navigator.pop(ctx);
          _onViewModeChanged(mode);
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 뷰 모드 선택 바텀시트
// ─────────────────────────────────────────────────────────────────────────────

class _ViewModeSheet extends StatelessWidget {
  final CalendarViewMode currentMode;
  final ValueChanged<CalendarViewMode> onModeChanged;

  const _ViewModeSheet({
    required this.currentMode,
    required this.onModeChanged,
  });

  static const _modes = [
    CalendarViewMode.day,
    CalendarViewMode.week,
    CalendarViewMode.month,
    CalendarViewMode.year,
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '뷰 선택',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          const SizedBox(height: 8),
          ..._modes.map((mode) {
            final isSelected = mode == currentMode;
            return ListTile(
              leading: Icon(
                _modeIcon(mode),
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              title: Text(
                _modeLabel(mode),
                style: TextStyle(
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
              ),
              trailing: isSelected
                  ? Icon(Icons.check,
                      color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () => onModeChanged(mode),
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  String _modeLabel(CalendarViewMode mode) {
    switch (mode) {
      case CalendarViewMode.day:   return '일';
      case CalendarViewMode.week:  return '주';
      case CalendarViewMode.month: return '월';
      case CalendarViewMode.year:  return '연도';
    }
  }

  IconData _modeIcon(CalendarViewMode mode) {
    switch (mode) {
      case CalendarViewMode.day:   return Icons.calendar_view_day_outlined;
      case CalendarViewMode.week:  return Icons.calendar_view_week_outlined;
      case CalendarViewMode.month: return Icons.calendar_view_month_outlined;
      case CalendarViewMode.year:  return Icons.calendar_today_outlined;
    }
  }
}

/// 일정 화면용 그룹 + 카테고리 필터 바
class _CalendarGroupFilterBar extends ConsumerWidget {
  const _CalendarGroupFilterBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategoryIds = ref.watch(selectedCategoryIdsProvider);
    final groupsAsync = ref.watch(myGroupsProvider);
    final groups = groupsAsync.valueOrNull ?? [];

    return Row(
      children: [
        Expanded(
          child: GroupFilterBar(
            filterMode: FilterMode.withAll,
            savedKey: 'calendar_group_filter',
            onMultiFilterChanged: (sel) {
              ref.read(selectedGroupIdsProvider.notifier).state = sel.groupIds;
              ref.read(includePersonalProvider.notifier).state =
                  sel.includePersonal;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: AppSizes.spaceS),
          child: IconButton(
            icon: Badge(
              isLabelVisible: selectedCategoryIds.isNotEmpty,
              label: Text('${selectedCategoryIds.length}'),
              child: const Icon(Icons.label_outline, size: 22),
            ),
            tooltip: AppLocalizations.of(context)!.category_filter,
            onPressed: () => _showCategoryFilter(context, ref, groups),
          ),
        ),
      ],
    );
  }

  void _showCategoryFilter(BuildContext context, WidgetRef ref, groups) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.radiusLarge)),
      ),
      builder: (context) => CategoryFilterSheet(groups: groups),
    );
  }
}
