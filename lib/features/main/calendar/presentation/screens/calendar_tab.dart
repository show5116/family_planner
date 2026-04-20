import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/ai_chat/presentation/widgets/ai_chat_icon_button.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/features/onboarding/presentation/widgets/feature_coach_mark.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

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

  final _fabKey = GlobalKey();
  final _calendarKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showCoachMark());
  }

  Future<void> _showCoachMark() async {
    await FeatureCoachMark.show(
      context: context,
      featureKey: CoachMarkKeys.calendar,
      targets: [
        TargetFocus(
          identify: 'calendar_view',
          keyTarget: _calendarKey,
          shape: ShapeLightFocus.RRect,
          radius: 8,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (_, _) => FeatureCoachMark.buildContent(
                title: '공유 캘린더',
                description: '그룹 구성원의 일정을 한눈에 볼 수 있어요.\n날짜를 탭해 해당 날의 일정을 확인하세요.',
                icon: Icons.calendar_month,
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: 'calendar_fab',
          keyTarget: _fabKey,
          shape: ShapeLightFocus.Circle,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (_, _) => FeatureCoachMark.buildContent(
                title: '일정 추가',
                description: '버튼을 눌러 새 일정을 만드세요.\n그룹원과 함께하는 일정도 등록할 수 있어요.',
                icon: Icons.add,
              ),
            ),
          ],
        ),
      ],
    );
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
        title: const CalendarGroupSelector(),
        bottom: isLoading
            ? const PreferredSize(
                preferredSize: Size.fromHeight(2),
                child: LinearProgressIndicator(),
              )
            : null,
        actions: [
          const AiChatIconButton(),
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
      body: ref.watch(calendarSearchQueryProvider) != null
          ? Column(
              children: [
                if (ref.watch(calendarSearchActiveProvider))
                  const CalendarSearchBar(),
                const Expanded(child: CalendarSearchResults()),
              ],
            )
          : CustomScrollView(
              slivers: [
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
