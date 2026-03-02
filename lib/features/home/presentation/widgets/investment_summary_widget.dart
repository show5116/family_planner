import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/main/investment/data/models/indicator_model.dart';
import 'package:family_planner/features/main/investment/providers/indicator_provider.dart';
import 'package:family_planner/shared/widgets/dashboard_card.dart';

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
                .take(3)
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

class _IndicatorItem extends StatelessWidget {
  const _IndicatorItem({required this.indicator});

  final IndicatorModel indicator;

  @override
  Widget build(BuildContext context) {
    final change = indicator.change;
    final changeRate = indicator.changeRate;
    final isPositive = (change ?? 0) >= 0;
    final changeColor = isPositive ? AppColors.success : AppColors.error;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceM),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              indicator.nameKo,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  indicator.price != null
                      ? '${_formatNumber(indicator.price!)} ${indicator.unit}'
                      : '-',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
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
                        '${change.abs().toStringAsFixed(2)} (${changeRate.abs().toStringAsFixed(2)}%)',
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

  String _formatNumber(double value) {
    if (value >= 1000) {
      return value.toStringAsFixed(2).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]},',
          );
    }
    return value.toStringAsFixed(2);
  }
}
