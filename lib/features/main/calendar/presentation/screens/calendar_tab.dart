import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:family_planner/shared/widgets/app_bar_more_menu.dart';
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

  void _replayOnboarding() => _showCoachMark(force: true);

  TargetPosition? _keyToPosition(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero, ancestor: overlay);
    return TargetPosition(box.size, offset);
  }

  Future<void> _showCoachMark({bool force = false}) async {
    final calendarPos = _keyToPosition(_calendarKey);
    final fabPos = _keyToPosition(_fabKey);

    await FeatureCoachMark.show(
      context: context,
      featureKey: CoachMarkKeys.calendar,
      forceShow: force,
      onClickTarget: (target) {
        if (!mounted) return;
        if (target.identify == 'calendar_fab') {
          final selectedDate = ref.read(selectedDateProvider);
          context.push('/calendar/add', extra: {'date': selectedDate, 'isOnboarding': true});
        }
      },
      targets: [
        TargetFocus(
          identify: 'calendar_view',
          targetPosition: calendarPos,
          keyTarget: calendarPos == null ? _calendarKey : null,
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
          targetPosition: fabPos,
          keyTarget: fabPos == null ? _fabKey : null,
          shape: ShapeLightFocus.Circle,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (_, _) => FeatureCoachMark.buildContent(
                title: '일정 추가',
                description: '버튼을 눌러 새 일정을 만드세요.\n눌러서 생성 화면을 살펴보세요.',
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
