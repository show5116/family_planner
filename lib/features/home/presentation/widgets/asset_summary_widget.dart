import 'package:flutter/material.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/utils/extensions.dart';
import 'package:family_planner/shared/widgets/dashboard_card.dart';

/// 자산 요약 위젯
class AssetSummaryWidget extends StatelessWidget {
  const AssetSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 임시 데이터
    const totalAssets = 50000000;
    const totalProfit = 2600000;
    const profitRate = 5.2;

    return DashboardCard(
      title: '자산 현황',
      icon: Icons.account_balance_wallet,
      action: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.show_chart, size: AppSizes.iconMedium),
      ),
      onTap: () {},
      child: Column(
        children: [
          // 총 자산
          _AssetRow(
            label: '총 자산',
            value: totalAssets.toCurrency(),
            valueStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
          ),
          const SizedBox(height: AppSizes.spaceM),
          const Divider(),
          const SizedBox(height: AppSizes.spaceM),
          // 수익금
          _AssetRow(
            label: '총 수익',
            value: totalProfit.toCurrency(),
            valueColor: AppColors.success,
          ),
          const SizedBox(height: AppSizes.spaceS),
          // 수익률
          _AssetRow(
            label: '수익률',
            value: profitRate.toPercent(),
            valueColor: AppColors.success,
            trailing: Icon(
              Icons.arrow_upward,
              color: AppColors.success,
              size: AppSizes.iconMedium,
            ),
          ),
          const SizedBox(height: AppSizes.spaceM),
          // 자산 분포 (간단한 바)
          _AssetDistribution(),
        ],
      ),
    );
  }
}

class _AssetRow extends StatelessWidget {
  const _AssetRow({
    required this.label,
    required this.value,
    this.valueStyle,
    this.valueColor,
    this.trailing,
  });

  final String label;
  final String value;
  final TextStyle? valueStyle;
  final Color? valueColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        Row(
          children: [
            Text(
              value,
              style: valueStyle ??
                  Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: valueColor,
                        fontWeight: FontWeight.w600,
                      ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSizes.spaceS),
              trailing!,
            ],
          ],
        ),
      ],
    );
  }
}

class _AssetDistribution extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 임시 데이터 (비율)
    final distribution = [
      _AssetType('예금', 0.2, AppColors.primary),
      _AssetType('주식', 0.6, AppColors.investment),
      _AssetType('기타', 0.2, AppColors.secondary),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '자산 분포',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: AppSizes.spaceS),
        // 바 차트
        Row(
          children: distribution
              .map(
                (asset) => Expanded(
                  flex: (asset.ratio * 100).toInt(),
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: asset.color,
                      borderRadius: BorderRadius.horizontal(
                        left: distribution.first == asset
                            ? const Radius.circular(4)
                            : Radius.zero,
                        right: distribution.last == asset
                            ? const Radius.circular(4)
                            : Radius.zero,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: AppSizes.spaceS),
        // 범례
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: distribution
              .map(
                (asset) => Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: asset.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${asset.name} ${(asset.ratio * 100).toInt()}%',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _AssetType {
  final String name;
  final double ratio;
  final Color color;

  _AssetType(this.name, this.ratio, this.color);
}
