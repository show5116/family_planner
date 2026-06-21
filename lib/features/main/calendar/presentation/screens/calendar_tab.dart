import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
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
import 'package:family_planner/shared/widgets/group_filter_bar.dart';

part '_calendar_onboarding.dart';

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

  final _fabKey = GlobalKey();
  final _calendarKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _scheduleCoachMark();
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
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _CalendarGroupFilterBar()),

                if (ref.watch(calendarSearchActiveProvider))
                  const SliverToBoxAdapter(child: CalendarSearchBar()),

                // 월간 캘린더
                SliverToBoxAdapter(
                  child: CalendarView(
                    key: _calendarKey,
                    tasksAsync: tasksAsync,
                    focusedDay: _focusedDay,
                    selectedDay: _selectedDay,
                    calendarFormat: _calendarFormat,
                    onDaySelected: _onDaySelected,
                    onPageChanged: _onPageChanged,
                    onFormatChanged: _onFormatChanged,
                  ),
                ),

                const SliverToBoxAdapter(child: Divider(height: 1)),

                // 선택된 날짜 일정 목록
                SliverTaskListSection(selectedDate: selectedDate),
              ],
            ),
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
              ref.read(includePersonalProvider.notifier).state = sel.includePersonal;
            },
          ),
        ),
        // 카테고리 필터 버튼
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLarge)),
      ),
      builder: (context) => CategoryFilterSheet(groups: groups),
    );
  }
}
