import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/providers/dashboard_widget_settings_provider.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/core/utils/extensions.dart';
import 'package:family_planner/core/models/dashboard_widget_settings.dart';
import 'package:family_planner/features/home/providers/dashboard_provider.dart';
import 'package:family_planner/features/main/household/data/models/expense_model.dart';
import 'package:family_planner/features/main/household/providers/household_provider.dart';
import 'package:family_planner/features/main/household/data/models/statistics_model.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/shared/widgets/dashboard_card.dart';

// 개인 모드를 나타내는 sentinel 값 (groupId: null로 API 호출)
const _kPersonal = '__personal__';

class HouseholdSummaryWidget extends ConsumerStatefulWidget {
  const HouseholdSummaryWidget({
    super.key,
    this.initialSelectedGroupId,
    this.viewMode = HouseholdWidgetViewMode.budget,
  });

  final String? initialSelectedGroupId;
  final HouseholdWidgetViewMode viewMode;

  @override
  ConsumerState<HouseholdSummaryWidget> createState() => _HouseholdSummaryWidgetState();
}

class _HouseholdSummaryWidgetState extends ConsumerState<HouseholdSummaryWidget> {
  // null = 초기값(첫 번째 그룹 자동 선택), _kPersonal = 개인, 그 외 = 그룹 ID
  String? _selectedGroupId;

  @override
  void initState() {
    super.initState();
    _selectedGroupId = widget.initialSelectedGroupId;
  }

  // 개인 모드 여부
  bool get _isPersonal => _selectedGroupId == _kPersonal;

  Future<void> _saveFilter() async {
    final current = ref.read(dashboardWidgetSettingsProvider).valueOrNull;
    if (current == null) return;
    await ref.read(dashboardWidgetSettingsProvider.notifier).save(
          current.copyWith(householdSelectedGroupId: _selectedGroupId),
        );
  }

  Future<void> _showGroupPicker(List<Group> groups) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusMedium),
        ),
      ),
      builder: (context) => _HouseholdGroupPickerSheet(
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
      dashboardHouseholdStatisticsProvider(
        selectedGroupId: _isPersonal ? null : _selectedGroupId,
        useFirstGroup: !_isPersonal && _selectedGroupId == null,
      ),
    );

    final hasActiveFilter = _selectedGroupId != null;

    return statsAsync.when(
      loading: () => DashboardCard(
        title: '가계 현황',
        icon: Icons.account_balance,
        onTap: () {},
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.spaceM),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (e, _) => _buildCard(context, groups, _emptyStats(), hasActiveFilter),
      data: (stats) => _buildCard(context, groups, stats, hasActiveFilter),
    );
  }

  MonthlyStatisticsModel _emptyStats() {
    final now = DateTime.now();
    final month = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    return MonthlyStatisticsModel(
      month: month,
      totalExpense: 0,
      totalBudget: 0,
      categories: [],
    );
  }

  Widget _buildCard(
    BuildContext context,
    List<Group> groups,
    MonthlyStatisticsModel stats,
    bool hasActiveFilter,
  ) {
    final now = DateTime.now();
    final monthLabel = '${now.month}월';

    const title = '가계 현황';

    final hasBudget = stats.totalBudget > 0;
    final budgetRatio = hasBudget ? (stats.totalExpense / stats.totalBudget).clamp(0.0, 1.0) : null;
    final isOverBudget = hasBudget && stats.totalExpense > stats.totalBudget;
    final remaining = stats.totalBudget - stats.totalExpense;

    return DashboardCard(
      title: title,
      icon: Icons.account_balance,
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
            onPressed: () {
              // 대시보드에서 선택한 그룹을 통계 화면에 동기화
              final effectiveGroupId = _isPersonal
                  ? null
                  : (_selectedGroupId ?? (groups.isNotEmpty ? groups.first.id : null));
              ref.read(householdSelectedGroupIdProvider.notifier).state =
                  effectiveGroupId;
              context.push(AppRoutes.householdStatistics);
            },
            icon: const Icon(Icons.bar_chart, size: AppSizes.iconMedium),
          ),
        ],
      ),
      onTap: () => context.push(AppRoutes.household),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 입금이 있을 때: 입금 / 지출 / 잔액 3열 요약
          if (stats.hasIncome) ...[
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$monthLabel 입금',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      Text(
                        '+${stats.totalIncome.toCurrency()}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '$monthLabel 지출',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      Text(
                        stats.totalExpense.toCurrency(),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.error,
                            ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '잔액',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      Text(
                        stats.balance.toCurrency(),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: stats.balance >= 0 ? Colors.green : AppColors.error,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ] else ...[
          // 입금 없을 때: 기존 지출 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$monthLabel 지출',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              if (hasBudget)
                Text(
                  '예산 ${stats.totalBudget.toCurrency()}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            stats.totalExpense.toCurrency(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isOverBudget ? AppColors.error : AppColors.primary,
                ),
          ),
          ],
          // budget 모드: 전체 예산 소진율 바 (입금 없을 때만)
          if (!stats.hasIncome && widget.viewMode == HouseholdWidgetViewMode.budget && hasBudget) ...[
            const SizedBox(height: AppSizes.spaceS),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: budgetRatio,
                minHeight: 8,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isOverBudget ? AppColors.error : AppColors.success,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spaceS),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(budgetRatio! * 100).toInt()}% 사용',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isOverBudget ? AppColors.error : AppColors.success,
                      ),
                ),
                Text(
                  isOverBudget
                      ? '${(stats.totalExpense - stats.totalBudget).toCurrency()} 초과'
                      : '${remaining.toCurrency()} 남음',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isOverBudget
                            ? AppColors.error
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ],
          // category 모드: 카테고리별 지출 + 예산 소진율
          if (widget.viewMode == HouseholdWidgetViewMode.category &&
              stats.categories.isNotEmpty) ...[
            const SizedBox(height: AppSizes.spaceM),
            const Divider(),
            const SizedBox(height: AppSizes.spaceS),
            _CategoryDistribution(categories: stats.categories),
          ],
        ],
      ),
    );
  }
}

class _HouseholdGroupPickerSheet extends StatefulWidget {
  const _HouseholdGroupPickerSheet({
    required this.groups,
    required this.selectedGroupId,
    required this.onApply,
  });

  final List<Group> groups;
  final String? selectedGroupId;
  final void Function(String groupId) onApply;

  @override
  State<_HouseholdGroupPickerSheet> createState() => _HouseholdGroupPickerSheetState();
}

class _HouseholdGroupPickerSheetState extends State<_HouseholdGroupPickerSheet> {
  late String _selectedGroupId;

  @override
  void initState() {
    super.initState();
    // null(초기값)이면 첫 번째 그룹으로 기본 선택
    _selectedGroupId = widget.selectedGroupId ??
        (widget.groups.isNotEmpty ? widget.groups.first.id : _kPersonal);
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
            child: Text('필터 선택', style: Theme.of(context).textTheme.titleLarge),
          ),
          const Divider(),
          RadioGroup<String>(
            groupValue: _selectedGroupId,
            onChanged: (v) => setState(() => _selectedGroupId = v!),
            child: Column(
              children: [
                // 개인 옵션
                RadioListTile<String>(
                  title: const Text('개인'),
                  subtitle: const Text('그룹 없이 개인 지출만'),
                  value: _kPersonal,
                ),
                if (widget.groups.isNotEmpty) const Divider(height: 1),
                // 그룹 목록
                ...widget.groups.map((group) => RadioListTile<String>(
                      title: Text(group.name),
                      value: group.id,
                    )),
              ],
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

class _CategoryDistribution extends StatelessWidget {
  const _CategoryDistribution({required this.categories});

  final List<CategoryStatModel> categories;

  static String _categoryLabel(ExpenseCategory? category) {
    switch (category) {
      case ExpenseCategory.transportation:
        return '교통';
      case ExpenseCategory.food:
        return '식비';
      case ExpenseCategory.leisure:
        return '여가';
      case ExpenseCategory.living:
        return '생활';
      case ExpenseCategory.medical:
        return '의료';
      case ExpenseCategory.education:
        return '교육';
      case ExpenseCategory.allowance:
        return '용돈';
      case ExpenseCategory.celebration:
        return '경조사비';
      case ExpenseCategory.assetTransfer:
        return '자산이동';
      case ExpenseCategory.childcare:
        return '육아비';
      default:
        return '기타';
    }
  }

  static Color _categoryColor(ExpenseCategory? category) {
    switch (category) {
      case ExpenseCategory.food:
        return AppColors.primary;
      case ExpenseCategory.transportation:
        return Colors.blue;
      case ExpenseCategory.leisure:
        return Colors.purple;
      case ExpenseCategory.living:
        return Colors.teal;
      case ExpenseCategory.medical:
        return Colors.red;
      case ExpenseCategory.education:
        return Colors.orange;
      case ExpenseCategory.allowance:
        return Colors.teal;
      case ExpenseCategory.celebration:
        return Colors.pink;
      case ExpenseCategory.assetTransfer:
        return Colors.blueGrey;
      case ExpenseCategory.childcare:
        return Colors.lightBlue;
      default:
        return AppColors.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sorted = [...categories]
      ..sort((a, b) => b.total.compareTo(a.total));
    final top = sorted.toList();
    if (top.isEmpty || top.fold<double>(0, (s, c) => s + c.total) == 0) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '카테고리별 지출',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: AppSizes.spaceS),
        ...top.map((cat) {
          final color = _categoryColor(cat.category);
          final hasBudget = cat.budget != null && cat.budget! > 0 && cat.budgetRatio != null;
          final barValue = hasBudget
              ? (cat.budgetRatio! / 100.0).clamp(0.0, 1.0)
              : null;
          final isOverBudget = hasBudget && cat.total > cat.budget!;
          final barColor = isOverBudget ? AppColors.error : color;

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSizes.spaceS),
                    Text(
                      _categoryLabel(cat.category),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const Spacer(),
                    Text(
                      cat.total.toCurrency(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isOverBudget ? AppColors.error : null,
                          ),
                    ),
                    if (hasBudget) ...[
                      Text(
                        ' / ${cat.budget!.toCurrency()}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ],
                ),
                if (barValue != null) ...[
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: barValue,
                      minHeight: 6,
                      backgroundColor:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(barColor),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isOverBudget
                        ? '${(cat.total - cat.budget!).toCurrency()} 초과'
                        : '${(barValue * 100).toInt()}% 사용',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isOverBudget
                              ? AppColors.error
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }
}
