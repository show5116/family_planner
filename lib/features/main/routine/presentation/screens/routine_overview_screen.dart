import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/presentation/screens/routine_badges_screen.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_overview_card.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_overview_heatmap_calendar.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_overview_weekly_breakdown.dart';
import 'package:family_planner/features/main/routine/providers/routine_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';

/// 전체 루틴 통합 통계 화면. 개별 루틴이 아닌 모든 습관을 합산한
/// 달성률(또는 주간 습관별 그리드) + 히트맵 + 전체 배지 현황을 한 화면에서
/// 보여준다. 좌우 화살표로 이전/다음 주(또는 달)로 이동할 수 있다.
class RoutineOverviewScreen extends ConsumerStatefulWidget {
  const RoutineOverviewScreen({super.key});

  @override
  ConsumerState<RoutineOverviewScreen> createState() =>
      _RoutineOverviewScreenState();
}

class _RoutineOverviewScreenState extends ConsumerState<RoutineOverviewScreen> {
  RoutineOverviewPeriod _period = RoutineOverviewPeriod.week;

  /// 현재 조회 중인 주/달에 속한 기준일. null이면 오늘(=이번 주/이번 달).
  DateTime? _anchorDate;

  String? get _fromDateParam =>
      _anchorDate != null ? _formatDate(_anchorDate!) : null;

  static String _formatDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  void _setPeriod(RoutineOverviewPeriod period) {
    setState(() {
      _period = period;
      // 기간 단위가 바뀌면 이전 주/달 기준일은 의미가 없으므로 오늘로 리셋.
      _anchorDate = null;
    });
  }

  void _shift(int direction) {
    setState(() {
      final base = _anchorDate ?? DateTime.now();
      final shifted = _period == RoutineOverviewPeriod.week
          ? base.add(Duration(days: 7 * direction))
          : DateTime(base.year, base.month + direction, 1);
      // 화살표로 왔다갔다 하다가 오늘이 속한 주/달로 돌아오면 "현재" 상태로
      // 취급한다. 그렇지 않으면 날짜 계산상 anchorDate가 null이 아니게 남아
      // "금주로" 버튼이 실제로는 이번 주인데도 계속 표시된다.
      _anchorDate = _isSamePeriodAsToday(shifted) ? null : shifted;
    });
  }

  bool _isSamePeriodAsToday(DateTime date) {
    final now = DateTime.now();
    if (_period == RoutineOverviewPeriod.month) {
      return date.year == now.year && date.month == now.month;
    }
    DateTime mondayOf(DateTime d) =>
        DateTime(d.year, d.month, d.day - (d.weekday - DateTime.monday));
    return mondayOf(date) == mondayOf(now);
  }

  void _resetToCurrent() => setState(() => _anchorDate = null);

  /// 직전에 성공적으로 받아온 데이터. [period]/[fromDate]가 바뀌면
  /// `routineOverviewProvider`는 family 파라미터가 달라진 완전히 다른
  /// provider 인스턴스가 되어 `valueOrNull`이 null부터 다시 시작한다.
  /// 이 캐시가 없으면 이동할 때마다 body 전체가 스피너로 사라졌다 나타나는
  /// 깜빡임이 발생한다.
  RoutineOverview? _lastOverview;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final overviewProvider = routineOverviewProvider(
      period: _period,
      fromDate: _fromDateParam,
    );
    final overviewAsync = ref.watch(overviewProvider);
    if (overviewAsync.hasValue) {
      _lastOverview = overviewAsync.value;
    }
    final overview = _lastOverview;
    final hasError = overviewAsync.hasError && overview == null;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.routine_overview_title)),
      body: hasError
          ? AppErrorState(
              error: overviewAsync.error!,
              title: l10n.routine_error_generic,
              onRetry: () => ref.invalidate(overviewProvider),
            )
          : overview == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                _RoutineOverviewContent(
                  overview: overview,
                  period: _period,
                  isCurrent: _anchorDate == null,
                  onPeriodChanged: _setPeriod,
                  onPrevious: () => _shift(-1),
                  onNext: () => _shift(1),
                  onResetToCurrent: _resetToCurrent,
                ),
                if (overviewAsync.isLoading)
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(minHeight: 2),
                  ),
              ],
            ),
    );
  }
}

class _RoutineOverviewContent extends StatelessWidget {
  const _RoutineOverviewContent({
    required this.overview,
    required this.period,
    required this.isCurrent,
    required this.onPeriodChanged,
    required this.onPrevious,
    required this.onNext,
    required this.onResetToCurrent,
  });

  final RoutineOverview overview;
  final RoutineOverviewPeriod period;
  final bool isCurrent;
  final ValueChanged<RoutineOverviewPeriod> onPeriodChanged;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onResetToCurrent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isWeekly = period == RoutineOverviewPeriod.week;

    return ListView(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      children: [
        RoutineOverviewCard(
          overview: overview,
          period: period,
          onPeriodChanged: onPeriodChanged,
          showGauge: !isWeekly,
        ),
        const SizedBox(height: AppSizes.spaceS),
        _PeriodNavigationBar(
          from: overview.from,
          to: overview.to,
          isWeekly: isWeekly,
          isCurrent: isCurrent,
          onPrevious: onPrevious,
          onNext: onNext,
          onResetToCurrent: onResetToCurrent,
        ),
        const SizedBox(height: AppSizes.spaceM),
        if (isWeekly)
          RoutineOverviewWeeklyBreakdown(overview: overview)
        else
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.routine_overview_heatmap_title,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  RoutineOverviewHeatmapCalendar(days: overview.heatmap),
                ],
              ),
            ),
          ),
        const SizedBox(height: AppSizes.spaceM),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceXS),
          child: Text(
            l10n.routine_badges_title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: AppSizes.spaceS),
        const RoutineBadgeGrid(shrinkWrap: true),
      ],
    );
  }
}

/// 좌우 화살표 + 현재 조회 중인 기간(YYYY-MM-DD ~ YYYY-MM-DD) 표시 바.
/// 현재 기간이 아니면 "금주로"/"이번 달로" 복귀 버튼을 보여준다. 버튼은
/// [Visibility]의 maintainSize로 항상 공간을 차지해서, 나타나거나
/// 사라져도 화살표/기간 텍스트 위치가 밀리지 않는다.
class _PeriodNavigationBar extends StatelessWidget {
  const _PeriodNavigationBar({
    required this.from,
    required this.to,
    required this.isWeekly,
    required this.isCurrent,
    required this.onPrevious,
    required this.onNext,
    required this.onResetToCurrent,
  });

  final String from;
  final String to;
  final bool isWeekly;
  final bool isCurrent;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onResetToCurrent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          tooltip: l10n.routine_overview_previous_period,
          onPressed: onPrevious,
        ),
        Expanded(
          child: Center(
            child: Text(
              '$from ~ $to',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          tooltip: l10n.routine_overview_next_period,
          onPressed: onNext,
        ),
        Visibility(
          visible: !isCurrent,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: TextButton(
            onPressed: onResetToCurrent,
            child: Text(
              isWeekly
                  ? l10n.routine_overview_this_week
                  : l10n.routine_overview_this_month,
            ),
          ),
        ),
      ],
    );
  }
}
