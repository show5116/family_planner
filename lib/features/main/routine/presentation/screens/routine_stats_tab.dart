import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_rate_card.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_streak_card.dart';
import 'package:family_planner/features/main/routine/providers/routine_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';

/// 루틴 상세 - 통계(스트릭 + 달성률) 탭
class RoutineStatsTab extends ConsumerStatefulWidget {
  const RoutineStatsTab({super.key, required this.routineId});

  final String routineId;

  @override
  ConsumerState<RoutineStatsTab> createState() => _RoutineStatsTabState();
}

class _RoutineStatsTabState extends ConsumerState<RoutineStatsTab> {
  RoutineRatePeriod _period = RoutineRatePeriod.week;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final streakProviderArg = routineStreakProvider(widget.routineId);
    final streakAsync = ref.watch(streakProviderArg);
    final rateProviderArg =
        routineRateProvider(widget.routineId, period: _period);
    final rateAsync = ref.watch(rateProviderArg);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSizes.spaceM,
        AppSizes.spaceM,
        AppSizes.spaceM,
        AppSizes.spaceM + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          streakAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => AppErrorState(
              error: error,
              title: l10n.routine_error_generic,
              onRetry: () => ref.invalidate(streakProviderArg),
            ),
            data: (streak) => RoutineStreakCard(streak: streak),
          ),
          const SizedBox(height: AppSizes.spaceM),
          rateAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => AppErrorState(
              error: error,
              title: l10n.routine_error_generic,
              onRetry: () => ref.invalidate(rateProviderArg),
            ),
            data: (rate) => RoutineRateCard(
              rate: rate,
              period: _period,
              onPeriodChanged: (p) => setState(() => _period = p),
            ),
          ),
        ],
      ),
    );
  }
}
