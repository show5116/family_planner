import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/presentation/screens/routine_badges_screen.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_overview_card.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_overview_heatmap_calendar.dart';
import 'package:family_planner/features/main/routine/providers/routine_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';

/// 전체 루틴 통합 통계 화면. 개별 루틴이 아닌 모든 습관을 합산한
/// 달성률 + 통합 히트맵 + 전체 배지 현황을 한 화면에서 보여준다.
class RoutineOverviewScreen extends ConsumerStatefulWidget {
  const RoutineOverviewScreen({super.key});

  @override
  ConsumerState<RoutineOverviewScreen> createState() =>
      _RoutineOverviewScreenState();
}

class _RoutineOverviewScreenState extends ConsumerState<RoutineOverviewScreen> {
  RoutineOverviewPeriod _period = RoutineOverviewPeriod.week;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final overviewAsync = ref.watch(routineOverviewProvider(period: _period));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.routine_overview_title)),
      body: overviewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AppErrorState(
          error: error,
          title: l10n.routine_error_generic,
          onRetry: () =>
              ref.invalidate(routineOverviewProvider(period: _period)),
        ),
        data: (overview) => ListView(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          children: [
            RoutineOverviewCard(
              overview: overview,
              period: _period,
              onPeriodChanged: (period) => setState(() => _period = period),
            ),
            const SizedBox(height: AppSizes.spaceM),
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
        ),
      ),
    );
  }
}
