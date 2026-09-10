import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/models/dashboard_widget_settings.dart';
import 'package:family_planner/core/providers/dashboard_widget_settings_provider.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/home/presentation/widgets/dashboard_error_state.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_badge_celebration_dialog.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_check_value_dialog.dart';
import 'package:family_planner/features/main/routine/providers/routine_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/dashboard_card.dart';

/// 오늘 뷰에서 한 번에 노출할 습관 개수
const _kTodayItemLimit = 3;

/// 스트릭 끊김 경고를 띄우기 시작하는 시각 (저녁)
const _kRiskWarningHour = 18;

/// 홈 대시보드 - 내 루틴 위젯.
///
/// 하나의 카드가 두 가지 뷰를 토글한다:
/// - [RoutineWidgetViewMode.today] 일일 목표 링 + 지금 시간대의 미체크 습관 인라인 체크
/// - [RoutineWidgetViewMode.weekly] 이번 주 7칸 히트맵 + 달성률 + 다음 배지까지 남은 일수
class RoutineSummaryWidget extends ConsumerStatefulWidget {
  const RoutineSummaryWidget({
    super.key,
    this.viewMode = RoutineWidgetViewMode.today,
  });

  final RoutineWidgetViewMode viewMode;

  @override
  ConsumerState<RoutineSummaryWidget> createState() =>
      _RoutineSummaryWidgetState();
}

class _RoutineSummaryWidgetState extends ConsumerState<RoutineSummaryWidget> {
  late RoutineWidgetViewMode _viewMode;

  @override
  void initState() {
    super.initState();
    _viewMode = widget.viewMode;
  }

  @override
  void didUpdateWidget(RoutineSummaryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.viewMode != oldWidget.viewMode) {
      _viewMode = widget.viewMode;
    }
  }

  bool get _isToday => _viewMode == RoutineWidgetViewMode.today;

  Future<void> _toggleViewMode() async {
    final next = _isToday
        ? RoutineWidgetViewMode.weekly
        : RoutineWidgetViewMode.today;
    setState(() => _viewMode = next);

    final current = ref.read(dashboardWidgetSettingsProvider).valueOrNull;
    if (current == null) return;
    await ref
        .read(dashboardWidgetSettingsProvider.notifier)
        .save(current.copyWith(routineViewMode: next));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DashboardCard(
      title: l10n.widgetSettings_routineSummary,
      icon: Icons.check_circle_outline,
      onTap: () => context.push(_isToday
          ? AppRoutes.routines
          : AppRoutes.routineOverview),
      action: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _isToday ? l10n.routineWidget_tabToday : l10n.routineWidget_tabWeekly,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          IconButton(
            iconSize: AppSizes.iconSmall,
            visualDensity: VisualDensity.compact,
            tooltip: l10n.routineWidget_viewToggleTooltip,
            icon: Icon(
              _isToday ? Icons.calendar_view_week : Icons.today_outlined,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            onPressed: _toggleViewMode,
          ),
        ],
      ),
      child: _isToday ? const _TodayView() : const _WeeklyView(),
    );
  }
}

// ── 오늘 뷰 ───────────────────────────────────────────────────────────────────

class _TodayView extends ConsumerWidget {
  const _TodayView();

  /// 현재 시각이 속한 시간대. 어느 시간대 습관을 먼저 보여줄지 결정한다.
  RoutineTimeFilter _currentSlot() {
    final hour = DateTime.now().hour;
    if (hour < 12) return RoutineTimeFilter.morning;
    if (hour < _kRiskWarningHour) return RoutineTimeFilter.afternoon;
    return RoutineTimeFilter.evening;
  }

  /// 미체크 → 현재 시간대 → 중요도 → 정렬순서 순으로 우선순위를 매긴다.
  List<Routine> _prioritize(List<Routine> routines) {
    final slot = _currentSlot();
    final candidates = routines
        .where((r) => r.status == RoutineStatus.active)
        .toList();

    candidates.sort((a, b) {
      // 1. 미체크 우선
      if (a.checkedToday != b.checkedToday) return a.checkedToday ? 1 : -1;
      // 2. 지금 시간대 우선
      final aSlot = a.timeFilter == slot ? 0 : 1;
      final bSlot = b.timeFilter == slot ? 0 : 1;
      if (aSlot != bSlot) return aSlot - bSlot;
      // 3. 중요도 높은 순
      final byImportance =
          _importanceRank(b.importance) - _importanceRank(a.importance);
      if (byImportance != 0) return byImportance;
      // 4. 사용자가 지정한 순서
      return a.sortOrder.compareTo(b.sortOrder);
    });

    return candidates;
  }

  int _importanceRank(RoutineImportance importance) {
    switch (importance) {
      case RoutineImportance.high:
        return 2;
      case RoutineImportance.medium:
        return 1;
      case RoutineImportance.low:
        return 0;
    }
  }

  Future<void> _toggleCheck(
    BuildContext context,
    WidgetRef ref,
    Routine routine,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    // 기록 방식이 BOOLEAN이 아니면 체크 전에 값을 입력받는다.
    // (체크 해제는 값이 필요 없다)
    RoutineCheckValue? value;
    if (!routine.checkedToday &&
        routine.recordType != RoutineRecordType.boolean_) {
      value = await showRoutineCheckValueDialog(context, routine.recordType);
      if (value == null) return;
      if (!context.mounted) return;
    }

    final result = await ref
        .read(routineManagementProvider.notifier)
        .toggleCheck(
          routine.id,
          routine.checkedToday,
          textValue: value?.textValue,
          numericValue: value?.numericValue,
          timeValue: value?.timeValue,
        );
    if (!context.mounted) return;

    if (!result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.routine_check_error)),
      );
    } else if (result.newlyEarnedBadges.isNotEmpty) {
      await showRoutineBadgeCelebration(context, result.newlyEarnedBadges);
    } else if (result.streakIncreased && result.currentStreakDays != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.routine_streak_celebration(result.currentStreakDays!),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final streakAsync = ref.watch(routineDailyStreakProvider);
    final routinesAsync = ref.watch(routineListProvider(null));

    void retry() {
      ref.invalidate(routineDailyStreakProvider);
      ref.invalidate(routineListProvider(null));
    }

    if (streakAsync.hasError || routinesAsync.hasError) {
      return DashboardErrorState(onRetry: retry);
    }
    final streak = streakAsync.valueOrNull;
    final routines = routinesAsync.valueOrNull;
    if (streak == null || routines == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.spaceM),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (routines.isEmpty) {
      return _EmptyState(message: l10n.routine_list_empty);
    }

    final prioritized = _prioritize(routines);
    final unchecked = prioritized.where((r) => !r.checkedToday).toList();
    final visible = unchecked.take(_kTodayItemLimit).toList();
    final hiddenCount = unchecked.length - visible.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _GoalRing(streak: streak),
        if (visible.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppSizes.spaceM),
            child: Text(
              streak.todayTargetCount == 0
                  ? l10n.routineWidget_noTargetToday
                  : l10n.routineWidget_allDone,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          )
        else ...[
          const SizedBox(height: AppSizes.spaceM),
          ...visible.map(
            (routine) => _TodayRoutineRow(
              routine: routine,
              onToggle: () => _toggleCheck(context, ref, routine),
            ),
          ),
          if (hiddenCount > 0)
            Padding(
              padding: const EdgeInsets.only(top: AppSizes.spaceXS),
              child: Text(
                l10n.routineWidget_moreCount(hiddenCount),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
        ],
      ],
    );
  }
}

/// 일일 목표 진행 링 + 스트릭/위험 경고
class _GoalRing extends StatelessWidget {
  const _GoalRing({required this.streak});

  final RoutineDailyStreak streak;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final target = streak.todayTargetCount;
    final progress = target == 0
        ? 0.0
        : (streak.todayCheckedCount / target).clamp(0.0, 1.0);

    // 저녁이 되도록 목표를 못 채웠고 이어온 스트릭이 있으면 끊김을 경고한다.
    final atRisk = !streak.todayAchieved &&
        streak.currentStreakDays > 0 &&
        DateTime.now().hour >= _kRiskWarningHour;

    return Row(
      children: [
        SizedBox(
          width: AppSizes.iconXLarge,
          height: AppSizes.iconXLarge,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 5,
                backgroundColor: colorScheme.surfaceContainerHighest,
                color: streak.todayAchieved
                    ? AppColors.success
                    : colorScheme.primary,
              ),
              Text(
                '${streak.todayCheckedCount}/$target',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSizes.spaceM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (streak.currentStreakDays > 0)
                Text(
                  '🔥 ${streak.currentStreakDays}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              if (atRisk)
                Text(
                  l10n.routineWidget_streakAtRisk(streak.currentStreakDays),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w600,
                      ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TodayRoutineRow extends StatelessWidget {
  const _TodayRoutineRow({required this.routine, required this.onToggle});

  final Routine routine;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final slotLabel = _timeFilterLabel(context, routine.timeFilter);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
      child: Row(
        children: [
          Text(routine.emoji ?? '✅',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(width: AppSizes.spaceS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  routine.title,
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
                if (slotLabel != null)
                  Text(
                    slotLabel,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
              ],
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            tooltip: routine.checkedToday
                ? AppLocalizations.of(context)!.routine_uncheck
                : AppLocalizations.of(context)!.routine_check,
            icon: Icon(
              routine.checkedToday
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: routine.checkedToday
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            onPressed: onToggle,
          ),
        ],
      ),
    );
  }

  String? _timeFilterLabel(BuildContext context, RoutineTimeFilter? filter) {
    final l10n = AppLocalizations.of(context)!;
    switch (filter) {
      case RoutineTimeFilter.morning:
        return l10n.routine_time_filter_morning;
      case RoutineTimeFilter.afternoon:
        return l10n.routine_time_filter_afternoon;
      case RoutineTimeFilter.evening:
        return l10n.routine_time_filter_evening;
      case null:
        return null;
    }
  }
}

// ── 이번 주 뷰 ────────────────────────────────────────────────────────────────

class _WeeklyView extends ConsumerWidget {
  const _WeeklyView();

  /// 아직 못 받은 배지 중 "연속 달성 N일" 기준으로 가장 가까운 것을 찾는다.
  /// 누적/퍼펙트위크 기준 배지는 현재 진행값을 알 수 없어 대상에서 제외한다.
  ({RoutineBadge badge, int remainingDays})? _nextStreakBadge(
    List<RoutineBadge> catalog,
    List<UserRoutineBadge> earned,
    int currentStreakDays,
  ) {
    final earnedIds = earned.map((e) => e.badgeId).toSet();
    ({RoutineBadge badge, int remainingDays})? best;

    for (final badge in catalog) {
      if (earnedIds.contains(badge.id)) continue;
      if (badge.criteriaType != BadgeCriteriaType.goalStreakDays) continue;
      final remaining = badge.criteriaValue - currentStreakDays;
      if (remaining <= 0) continue;
      if (best == null || remaining < best.remainingDays) {
        best = (badge: badge, remainingDays: remaining);
      }
    }
    return best;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final overviewAsync = ref.watch(
      routineOverviewProvider(period: RoutineOverviewPeriod.week),
    );

    if (overviewAsync.hasError) {
      return DashboardErrorState(
        onRetry: () => ref.invalidate(routineOverviewProvider),
      );
    }
    final overview = overviewAsync.valueOrNull;
    if (overview == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.spaceM),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (overview.totalRoutines == 0) {
      return _EmptyState(message: l10n.routine_list_empty);
    }

    // 배지 정보는 부가 정보라 실패하거나 로딩 중이면 그냥 생략한다.
    final catalog = ref.watch(routineBadgeCatalogProvider).valueOrNull;
    final myBadges = ref.watch(routineMyBadgesProvider).valueOrNull;
    final streak = ref.watch(routineDailyStreakProvider).valueOrNull;
    final nextBadge = (catalog != null && myBadges != null && streak != null)
        ? _nextStreakBadge(catalog, myBadges, streak.currentStreakDays)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _WeeklyHeatmapStrip(days: overview.heatmap),
        const SizedBox(height: AppSizes.spaceM),
        Text(
          '${l10n.routineWidget_achievementRate(overview.achievementRate.round())}'
          '  ·  '
          '${l10n.routineWidget_goalDays(overview.goalAchievedDays, overview.goalTotalDays)}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        if (nextBadge != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSizes.spaceXS),
            child: Text(
              '${nextBadge.badge.iconEmoji ?? '🏅'} '
              '${l10n.routineWidget_nextBadge(nextBadge.badge.title, nextBadge.remainingDays)}',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
      ],
    );
  }
}

/// 이번 주 7칸 히트맵. 셀 색은 그날의 일일 목표 달성 여부를 나타낸다.
class _WeeklyHeatmapStrip extends StatelessWidget {
  const _WeeklyHeatmapStrip({required this.days});

  final List<RoutineOverviewHeatmapDay> days;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).languageCode;
    final today = DateTime.now();
    final todayKey =
        '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    return Row(
      children: days.map((day) {
        final date = DateTime.tryParse(day.date);
        final isFuture = date != null && day.date.compareTo(todayKey) > 0;
        final isToday = day.date == todayKey;

        final Color cellColor;
        if (isFuture) {
          cellColor = colorScheme.surfaceContainerHighest.withValues(alpha: 0.4);
        } else if (day.goalAchieved == true) {
          cellColor = AppColors.success;
        } else if (day.goalAchieved == false) {
          cellColor = colorScheme.surfaceContainerHighest;
        } else {
          // 그날 대상 습관이 0개 — 집계 대상이 아니라 중립 처리
          cellColor = colorScheme.surfaceContainerHighest.withValues(alpha: 0.6);
        }

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceXS / 2),
            child: Column(
              children: [
                Text(
                  date != null ? DateFormat('E', locale).format(date) : '',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: AppSizes.spaceXS),
                Container(
                  height: AppSizes.iconMedium,
                  decoration: BoxDecoration(
                    color: cellColor,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    border: isToday
                        ? Border.all(color: colorScheme.primary, width: 2)
                        : null,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── 공통 ─────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceM),
      child: Center(
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ),
    );
  }
}
