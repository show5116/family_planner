import 'package:flutter/material.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/shared/widgets/dashboard_card.dart';

/// 투자 지표 요약 위젯
class InvestmentSummaryWidget extends StatelessWidget {
  const InvestmentSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 임시 데이터
    final indicators = [
      _Indicator('KOSPI', '2,500.00', 15.0, 0.6),
      _Indicator('NASDAQ', '15,000.00', -50.0, -0.3),
      _Indicator('USD/KRW', '1,300원', 10.0, 0.8),
    ];

    return DashboardCard(
      title: '투자 지표',
      icon: Icons.trending_up,
      action: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.refresh, size: AppSizes.iconMedium),
      ),
      onTap: () {},
      child: Column(
        children: indicators
            .map((indicator) => _IndicatorItem(indicator: indicator))
            .toList(),
      ),
    );
  }
}

class _IndicatorItem extends StatelessWidget {
  const _IndicatorItem({required this.indicator});

  final _Indicator indicator;

  @override
  Widget build(BuildContext context) {
    final isPositive = indicator.change >= 0;
    final changeColor = isPositive ? AppColors.success : AppColors.error;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceM),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              indicator.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  indicator.value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 16,
                      color: changeColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${indicator.change.abs()} (${indicator.changePercent.abs()}%)',
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

class _Indicator {
  final String name;
  final String value;
  final double change;
  final double changePercent;

  _Indicator(this.name, this.value, this.change, this.changePercent);
}
