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
      _anchorDate = _period == RoutineOverviewPeriod.week
          ? base.add(Duration(days: 7 * direction))
          : DateTime(base.year, base.month + direction, 1);
    });
  }

  void _resetToToday() => setState(() => _anchorDate = null);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final overviewAsync = ref.watch(
      routineOverviewProvider(period: _period, fromDate: _fromDateParam),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.routine_overview_title)),
      body: overviewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AppErrorState(
          error: error,
          title: l10n.routine_error_generic,
          onRetry: () => ref.invalidate(
            routineOverviewProvider(period: _period, fromDate: _fromDateParam),
          ),
        ),
        data: (overview) {
          final isWeekly = _period == RoutineOverviewPeriod.week;
          return ListView(
            padding: const EdgeInsets.all(AppSizes.spaceM),
            children: [
              RoutineOverviewCard(
                overview: overview,
                period: _period,
                onPeriodChanged: _setPeriod,
                showGauge: !isWeekly,
              ),
              const SizedBox(height: AppSizes.spaceS),
              _PeriodNavigationBar(
                from: overview.from,
                to: overview.to,
                isCurrent: _anchorDate == null,
                onPrevious: () => _shift(-1),
                onNext: () => _shift(1),
                onResetToToday: _resetToToday,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceXS,
                ),
                child: Text(
                  l10n.routine_badges_title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: AppSizes.spaceS),
              const RoutineBadgeGrid(shrinkWrap: true),
            ],
          );
        },
      ),
    );
  }
}

/// 좌우 화살표 + 현재 조회 중인 기간(YYYY-MM-DD ~ YYYY-MM-DD) 표시 바.
/// 오늘이 포함된 기간이 아니면 "오늘로" 버튼을 보여준다.
class _PeriodNavigationBar extends StatelessWidget {
  const _PeriodNavigationBar({
    required this.from,
    required this.to,
    required this.isCurrent,
    required this.onPrevious,
    required this.onNext,
    required this.onResetToToday,
  });

  final String from;
  final String to;
  final bool isCurrent;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onResetToToday;

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
        if (!isCurrent)
          TextButton(
            onPressed: onResetToToday,
            child: Text(l10n.routine_overview_today),
          ),
      ],
    );
  }
}
