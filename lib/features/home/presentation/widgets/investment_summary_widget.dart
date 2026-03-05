import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/main/investment/data/models/indicator_model.dart';
import 'package:family_planner/core/utils/format_utils.dart';
import 'package:family_planner/features/main/investment/providers/indicator_provider.dart';
import 'package:family_planner/shared/widgets/dashboard_card.dart';
import 'package:family_planner/shared/widgets/sparkline_chart.dart';

/// 투자 지표 요약 위젯 (대시보드용 - 즐겨찾기 목록 표시)
class InvestmentSummaryWidget extends ConsumerWidget {
  const InvestmentSummaryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkedAsync = ref.watch(bookmarkedIndicatorsProvider);

    return DashboardCard(
      title: '투자 지표',
      icon: Icons.trending_up,
      action: IconButton(
        onPressed: () => ref.read(bookmarkedIndicatorsProvider.notifier).refresh(),
        icon: const Icon(Icons.refresh, size: AppSizes.iconMedium),
      ),
      onTap: () => context.push(AppRoutes.investmentIndicators),
      child: bookmarkedAsync.when(
        loading: () => const _LoadingIndicators(),
        error: (_, _) => const _ErrorIndicators(),
        data: (indicators) {
          if (indicators.isEmpty) {
            return const _EmptyIndicators();
          }
          return Column(
            children: indicators
                .map((indicator) => _IndicatorItem(indicator: indicator))
                .toList(),
          );
        },
      ),
    );
  }
}

class _LoadingIndicators extends StatelessWidget {
  const _LoadingIndicators();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.spaceM),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _ErrorIndicators extends StatelessWidget {
  const _ErrorIndicators();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceM),
      child: Center(
        child: Text(
          '데이터를 불러올 수 없습니다',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.error,
              ),
        ),
      ),
    );
  }
}

class _EmptyIndicators extends StatelessWidget {
  const _EmptyIndicators();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceM),
      child: Center(
        child: Text(
          '즐겨찾기한 지표가 없습니다',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ),
    );
  }
}

class _IndicatorItem extends ConsumerWidget {
  const _IndicatorItem({required this.indicator});

  final IndicatorModel indicator;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final change = indicator.change;
    final changeRate = indicator.changeRate;
    final isPositive = (change ?? 0) >= 0;
    final changeColor = isPositive ? AppColors.success : AppColors.error;
    final sparklineAsync = ref.watch(indicatorSparklineProvider(indicator.symbol));

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceM),
      child: Row(
        children: [
          // 이름
          Expanded(
            flex: 2,
            child: Text(
              indicator.nameKo,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          // 스파크라인 (고정 너비)
          SizedBox(
            width: 60,
            height: 32,
            child: sparklineAsync.when(
              data: (points) => SparklineChart(
                points: points,
                color: isPositive ? AppColors.success : AppColors.error,
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ),
          const SizedBox(width: AppSizes.spaceS),
          // 가격 (수치·단위 두 줄 고정) + 변동
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (indicator.price != null)
                  Text(
                    '${formatIndicatorPrice(indicator.price!)} ${indicator.unit}',
                    textAlign: TextAlign.right,
                    softWrap: true,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  )
                else
                  Text('-', style: Theme.of(context).textTheme.bodyLarge),
                if (change != null && changeRate != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 14,
                        color: changeColor,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${formatIndicatorChange(change)} (${changeRate.abs().toStringAsFixed(2)}%)',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: changeColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
