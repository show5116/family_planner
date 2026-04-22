import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/providers/dashboard_widget_settings_provider.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/core/utils/extensions.dart';
import 'package:family_planner/features/home/providers/dashboard_provider.dart';
import 'package:family_planner/features/main/assets/data/models/account_model.dart';
import 'package:family_planner/features/main/assets/data/models/asset_statistics_model.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/shared/widgets/dashboard_card.dart';

/// 자산 요약 위젯
class AssetSummaryWidget extends ConsumerStatefulWidget {
  const AssetSummaryWidget({
    super.key,
    this.initialSelectedGroupId,
  });

  final String? initialSelectedGroupId;

  @override
  ConsumerState<AssetSummaryWidget> createState() => _AssetSummaryWidgetState();
}

class _AssetSummaryWidgetState extends ConsumerState<AssetSummaryWidget> {
  String? _selectedGroupId;

  @override
  void initState() {
    super.initState();
    _selectedGroupId = widget.initialSelectedGroupId;
  }

  Future<void> _saveFilter() async {
    final current = ref.read(dashboardWidgetSettingsProvider).valueOrNull;
    if (current == null) return;
    await ref.read(dashboardWidgetSettingsProvider.notifier).save(
          current.copyWith(assetSelectedGroupId: _selectedGroupId),
        );
  }

  Future<void> _showGroupPicker(List<Group> groups) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusMedium),
        ),
      ),
      builder: (context) => _AssetGroupPickerSheet(
        groups: groups,
        selectedGroupId: _selectedGroupId,
        onApply: (groupId) {
          setState(() => _selectedGroupId = groupId);
          _saveFilter();
          Navigator.pop(context);
        },
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    final groups = ref.watch(myGroupsProvider).valueOrNull ?? [];
    final statsAsync = ref.watch(
      dashboardAssetStatisticsProvider(selectedGroupId: _selectedGroupId),
    );

    final hasActiveFilter = _selectedGroupId != null;

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
      error: (e, _) => _buildCard(context, groups, AssetStatisticsModel.empty(), hasActiveFilter),
      data: (stats) => _buildCard(context, groups, stats, hasActiveFilter),
    );
  }

  Widget _buildCard(BuildContext context, List<Group> groups, AssetStatisticsModel stats, bool hasActiveFilter) {
    final isProfit = stats.totalProfit >= 0;

    String title = '자산 현황';
    if (_selectedGroupId != null && groups.isNotEmpty) {
      final group = groups.where((g) => g.id == _selectedGroupId).firstOrNull;
      if (group != null) title = '${group.name} 자산';
    }

    return DashboardCard(
      title: title,
      icon: Icons.account_balance_wallet,
      action: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (groups.isNotEmpty)
            IconButton(
              iconSize: 20,
              visualDensity: VisualDensity.compact,
              tooltip: '그룹 선택',
              icon: Badge(
                isLabelVisible: hasActiveFilter,
                smallSize: 7,
                child: Icon(
                  Icons.tune,
                  color: hasActiveFilter
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              onPressed: () => _showGroupPicker(groups),
            ),
          IconButton(
            onPressed: () => context.push(AppRoutes.assetStatistics),
            icon: const Icon(Icons.show_chart, size: AppSizes.iconMedium),
          ),
        ],
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

/// 자산 위젯 그룹 선택 바텀시트
class _AssetGroupPickerSheet extends StatefulWidget {
  const _AssetGroupPickerSheet({
    required this.groups,
    required this.selectedGroupId,
    required this.onApply,
  });

  final List<Group> groups;
  final String? selectedGroupId;
  final void Function(String groupId) onApply;

  @override
  State<_AssetGroupPickerSheet> createState() => _AssetGroupPickerSheetState();
}

class _AssetGroupPickerSheetState extends State<_AssetGroupPickerSheet> {
  late String _selectedGroupId;

  @override
  void initState() {
    super.initState();
    _selectedGroupId = widget.selectedGroupId ?? widget.groups.first.id;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: AppSizes.spaceM),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.spaceL, AppSizes.spaceM, AppSizes.spaceL, AppSizes.spaceS,
            ),
            child: Text('그룹 선택', style: Theme.of(context).textTheme.titleLarge),
          ),
          const Divider(),
          RadioGroup<String>(
            groupValue: _selectedGroupId,
            onChanged: (v) => setState(() => _selectedGroupId = v!),
            child: Column(
              children: widget.groups
                  .map((group) => RadioListTile<String>(
                        title: Text(group.name),
                        value: group.id,
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: AppSizes.spaceS),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.spaceL, 0, AppSizes.spaceL, AppSizes.spaceL,
            ),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => widget.onApply(_selectedGroupId),
                child: const Text('적용'),
              ),
            ),
          ),
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
