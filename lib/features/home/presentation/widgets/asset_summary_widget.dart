import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/core/utils/extensions.dart';
import 'package:family_planner/features/home/providers/dashboard_provider.dart';
import 'package:family_planner/features/main/assets/data/models/account_model.dart';
import 'package:family_planner/features/main/assets/data/models/asset_statistics_model.dart';
import 'package:family_planner/shared/widgets/dashboard_card.dart';

/// 자산 요약 위젯
class AssetSummaryWidget extends ConsumerWidget {
  const AssetSummaryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardAssetStatisticsProvider);

    return statsAsync.when(
      loading: () => DashboardCard(
        title: '자산 현황',
        icon: Icons.account_balance_wallet,
        onTap: () {},
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.spaceM),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (_, _) => _buildCard(context, AssetStatisticsModel.empty()),
      data: (stats) => _buildCard(context, stats),
    );
  }

  Widget _buildCard(BuildContext context, AssetStatisticsModel stats) {
    final isProfit = stats.totalProfit >= 0;

    return DashboardCard(
      title: '자산 현황',
      icon: Icons.account_balance_wallet,
      action: IconButton(
        onPressed: () => context.push(AppRoutes.assetStatistics),
        icon: const Icon(Icons.show_chart, size: AppSizes.iconMedium),
      ),
      onTap: () => context.push(AppRoutes.assets),
      child: Column(
        children: [
          _AssetRow(
            label: '총 자산',
            value: stats.totalBalance.toCurrency(),
            valueStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
          ),
          const SizedBox(height: AppSizes.spaceM),
          const Divider(),
          const SizedBox(height: AppSizes.spaceM),
          _AssetRow(
            label: '총 수익',
            value: stats.totalProfit.toCurrency(),
            valueColor: isProfit ? AppColors.success : AppColors.error,
          ),
          const SizedBox(height: AppSizes.spaceS),
          _AssetRow(
            label: '수익률',
            value: stats.profitRate.toPercent(),
            valueColor: isProfit ? AppColors.success : AppColors.error,
            trailing: Icon(
              isProfit ? Icons.arrow_upward : Icons.arrow_downward,
              color: isProfit ? AppColors.success : AppColors.error,
              size: AppSizes.iconMedium,
            ),
          ),
          if (stats.byType.isNotEmpty) ...[
            const SizedBox(height: AppSizes.spaceM),
            _AssetDistribution(byType: stats.byType),
          ],
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
  const _AssetDistribution({required this.byType});

  final List<AccountTypeStatModel> byType;

  static String _typeLabel(AccountType? type) {
    switch (type) {
      case AccountType.bank:
        return '예금';
      case AccountType.stock:
        return '주식';
      case AccountType.fund:
        return '펀드';
      case AccountType.insurance:
        return '보험';
      case AccountType.realEstate:
        return '부동산';
      case AccountType.cash:
        return '현금';
      default:
        return '기타';
    }
  }

  static Color _typeColor(AccountType? type) {
    switch (type) {
      case AccountType.bank:
        return AppColors.primary;
      case AccountType.stock:
        return AppColors.investment;
      case AccountType.fund:
        return Colors.purple;
      case AccountType.insurance:
        return Colors.teal;
      case AccountType.realEstate:
        return Colors.brown;
      case AccountType.cash:
        return AppColors.success;
      default:
        return AppColors.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = byType.fold<double>(0, (sum, t) => sum + t.balance);
    if (total == 0) return const SizedBox.shrink();

    final distribution = byType
        .where((t) => t.balance > 0)
        .map((t) => (
              name: _typeLabel(t.type),
              ratio: t.balance / total,
              color: _typeColor(t.type),
            ))
        .toList();

    if (distribution.isEmpty) return const SizedBox.shrink();

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
        Row(
          children: distribution
              .map(
                (asset) => Expanded(
                  flex: (asset.ratio * 100).toInt().clamp(1, 100),
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: asset.color,
                      borderRadius: BorderRadius.horizontal(
                        left: distribution.first.name == asset.name
                            ? const Radius.circular(4)
                            : Radius.zero,
                        right: distribution.last.name == asset.name
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
        Wrap(
          spacing: AppSizes.spaceM,
          runSpacing: AppSizes.spaceS,
          children: distribution
              .map(
                (asset) => Row(
                  mainAxisSize: MainAxisSize.min,
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
