import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/main/household/data/models/expense_model.dart';
import 'package:family_planner/features/main/household/data/models/statistics_model.dart';
import 'package:family_planner/features/main/household/presentation/widgets/expense_list_item.dart';
import 'package:family_planner/features/main/household/providers/household_provider.dart';
import 'package:family_planner/features/main/household/providers/merchant_provider.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

class HouseholdStatisticsScreen extends ConsumerStatefulWidget {
  const HouseholdStatisticsScreen({super.key});

  @override
  ConsumerState<HouseholdStatisticsScreen> createState() =>
      _HouseholdStatisticsScreenState();
}

class _HouseholdStatisticsScreenState
    extends ConsumerState<HouseholdStatisticsScreen>
    with SingleTickerProviderStateMixin {
  late String _selectedMonth;
  late int _selectedYear;
  late TabController _tabController;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedMonth = ref.read(householdSelectedMonthProvider);
    _selectedYear = int.parse(_selectedMonth.split('-')[0]);
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        if (_tabController.indexIsChanging || _tabController.index != _tabIndex) {
          setState(() => _tabIndex = _tabController.index);
        }
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _changeMonth(int delta) {
    final parts = _selectedMonth.split('-');
    var year = int.parse(parts[0]);
    var month = int.parse(parts[1]) + delta;
    if (month > 12) {
      month = 1;
      year++;
    } else if (month < 1) {
      month = 12;
      year--;
    }
    setState(() {
      _selectedMonth = '$year-${month.toString().padLeft(2, '0')}';
    });
  }

  void _changeYear(int delta) {
    setState(() => _selectedYear += delta);
  }

  String _formatMonth(String month) {
    final parts = month.split('-');
    return '${parts[0]}년 ${int.parse(parts[1])}월';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedGroupId = ref.watch(householdSelectedGroupIdProvider);
    final groupsAsync = ref.watch(myGroupsProvider);
    final groupName = groupsAsync.whenOrNull(
      data: (groups) => groups
          .where((g) => g.id == selectedGroupId)
          .map((g) => g.name)
          .firstOrNull,
    );

    return Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.household_statistics),
              if (groupName != null)
                Text(
                  groupName,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(96),
            child: Column(
              children: [
                // 월간 탭: 월 선택 / 연간 탭: 연도 선택
                Container(
                  color: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left, color: Colors.white),
                        visualDensity: VisualDensity.compact,
                        onPressed: _tabIndex == 0
                            ? () => _changeMonth(-1)
                            : () => _changeYear(-1),
                      ),
                      Text(
                        _tabIndex == 0
                            ? _formatMonth(_selectedMonth)
                            : '$_selectedYear년',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right, color: Colors.white),
                        visualDensity: VisualDensity.compact,
                        onPressed: _tabIndex == 0
                            ? () => _changeMonth(1)
                            : () => _changeYear(1),
                      ),
                    ],
                  ),
                ),
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(text: l10n.household_monthly_statistics),
                    Tab(text: '연간 통계'),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _MonthlyStatisticsTab(month: _selectedMonth),
            _YearlyStatisticsTab(year: _selectedYear.toString()),
          ],
        ),
      );
  }
}

// 월간 통계 탭
class _MonthlyStatisticsTab extends ConsumerWidget {
  final String month;

  const _MonthlyStatisticsTab({required this.month});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final statsAsync =
        ref.watch(householdMonthlyStatisticsByMonthProvider(month));

    return statsAsync.when(
      data: (stats) => _MonthlyStatisticsContent(stats: stats, month: month),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.common_error),
            const SizedBox(height: AppSizes.spaceS),
            ElevatedButton(
              onPressed: () => ref.invalidate(householdMonthlyStatisticsProvider),
              child: Text(l10n.common_retry),
            ),
          ],
        ),
      ),
    );
  }
}

enum _StatViewMode { category, merchant, filter }

class _MonthlyStatisticsContent extends ConsumerStatefulWidget {
  final MonthlyStatisticsModel stats;
  final String month;

  const _MonthlyStatisticsContent({required this.stats, required this.month});

  @override
  ConsumerState<_MonthlyStatisticsContent> createState() =>
      _MonthlyStatisticsContentState();
}

class _MonthlyStatisticsContentState
    extends ConsumerState<_MonthlyStatisticsContent> {
  _StatViewMode _viewMode = _StatViewMode.category;
  ExpenseCategory? _filterCategory;
  String? _filterMerchantId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: EdgeInsets.only(
        left: AppSizes.spaceM,
        right: AppSizes.spaceM,
        top: AppSizes.spaceM,
        bottom: AppSizes.spaceM + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        _TotalSummaryCard(stats: widget.stats),
        const SizedBox(height: AppSizes.spaceM),

        // 뷰 모드 세그먼트
        SegmentedButton<_StatViewMode>(
          segments: const [
            ButtonSegment(value: _StatViewMode.category, label: Text('카테고리별'), icon: Icon(Icons.pie_chart_outline, size: 16)),
            ButtonSegment(value: _StatViewMode.merchant, label: Text('소비처별'), icon: Icon(Icons.storefront_outlined, size: 16)),
            ButtonSegment(value: _StatViewMode.filter, label: Text('직접 필터링'), icon: Icon(Icons.filter_list, size: 16)),
          ],
          selected: {_viewMode},
          onSelectionChanged: (s) => setState(() {
            _viewMode = s.first;
          }),
          style: ButtonStyle(
            visualDensity: VisualDensity.compact,
            textStyle: WidgetStateProperty.all(
              const TextStyle(fontSize: 11),
            ),
          ),
        ),
        const SizedBox(height: AppSizes.spaceM),

        if (_viewMode == _StatViewMode.category)
          ..._buildCategoryView(context, l10n)
        else if (_viewMode == _StatViewMode.merchant)
          ..._buildMerchantView(context, l10n)
        else
          ..._buildFilterView(context, l10n),
      ],
    );
  }

  List<Widget> _buildCategoryView(BuildContext context, AppLocalizations l10n) {
    return [
      if (widget.stats.hasIncome) ...[
        Text(
          l10n.household_income,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSizes.spaceS),
        _IncomeSummaryItem(totalIncome: widget.stats.totalIncome, month: widget.month),
        const SizedBox(height: AppSizes.spaceM),
      ],
      if (widget.stats.categories.isNotEmpty) ...[
        Text(
          '카테고리별 지출',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSizes.spaceS),
        ...widget.stats.categories.map((cat) => _CategoryStatItem(stat: cat, month: widget.month)),
      ] else if (!widget.stats.hasIncome)
        Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spaceXL),
            child: Text(
              l10n.household_no_expenses,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.outline),
            ),
          ),
        ),
    ];
  }

  List<Widget> _buildMerchantView(BuildContext context, AppLocalizations l10n) {
    final expensesAsync = ref.watch(householdExpensesByMonthProvider(widget.month));

    return [
      expensesAsync.when(
        data: (expenses) {
          final onlyExpenses = expenses.where((e) => e.type == TransactionType.expense).toList();
          if (onlyExpenses.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.spaceXL),
                child: Text(
                  l10n.household_no_expenses,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.outline),
                ),
              ),
            );
          }

          // merchant별 집계
          final Map<String, _MerchantStat> merchantMap = {};
          double noMerchantTotal = 0;
          int noMerchantCount = 0;

          for (final e in onlyExpenses) {
            if (e.merchant == null) {
              noMerchantTotal += e.amount;
              noMerchantCount++;
            } else {
              final key = e.merchant!.id;
              final stat = merchantMap[key] ?? _MerchantStat(id: key, name: e.merchant!.name, total: 0, count: 0);
              merchantMap[key] = _MerchantStat(id: stat.id, name: stat.name, total: stat.total + e.amount, count: stat.count + 1);
            }
          }

          final sorted = merchantMap.values.toList()..sort((a, b) => b.total.compareTo(a.total));
          final maxAmount = sorted.isEmpty ? 1.0 : sorted.first.total;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '소비처별 지출',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSizes.spaceS),
              ...sorted.map((stat) => _MerchantStatItem(stat: stat, maxAmount: maxAmount)),
              if (noMerchantCount > 0)
                _MerchantStatItem(
                  stat: _MerchantStat(id: '', name: '소비처 없음', total: noMerchantTotal, count: noMerchantCount),
                  maxAmount: maxAmount,
                  isNone: true,
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.common_error)),
      ),
    ];
  }

  List<Widget> _buildFilterView(BuildContext context, AppLocalizations l10n) {
    final expensesAsync = ref.watch(householdExpensesByMonthProvider(widget.month));
    final merchantsAsync = ref.watch(merchantsProvider);

    return [
      // 카테고리 필터
      _FilterDropdownRow(
        label: '카테고리',
        child: DropdownButton<ExpenseCategory?>(
          value: _filterCategory,
          isExpanded: true,
          underline: const SizedBox(),
          hint: const Text('전체'),
          items: [
            const DropdownMenuItem<ExpenseCategory?>(value: null, child: Text('전체')),
            ...ExpenseCategory.values.map((c) => DropdownMenuItem(
              value: c,
              child: Text(categoryName(l10n, c)),
            )),
          ],
          onChanged: (v) => setState(() => _filterCategory = v),
        ),
      ),
      const SizedBox(height: AppSizes.spaceS),
      // 소비처 필터
      merchantsAsync.when(
        data: (merchants) => _FilterDropdownRow(
          label: '소비처',
          child: DropdownButton<String?>(
            value: _filterMerchantId,
            isExpanded: true,
            underline: const SizedBox(),
            hint: const Text('전체'),
            items: [
              const DropdownMenuItem<String?>(value: null, child: Text('전체')),
              ...merchants.map((m) => DropdownMenuItem(value: m.id, child: Text(m.name))),
            ],
            onChanged: (v) => setState(() => _filterMerchantId = v),
          ),
        ),
        loading: () => const SizedBox(),
        error: (_, _) => const SizedBox(),
      ),
      const SizedBox(height: AppSizes.spaceM),
      // 필터된 지출 목록
      expensesAsync.when(
        data: (expenses) {
          var filtered = expenses.where((e) => e.type == TransactionType.expense).toList();
          if (_filterCategory != null) {
            filtered = filtered.where((e) => e.category == _filterCategory).toList();
          }
          if (_filterMerchantId != null) {
            filtered = filtered.where((e) => e.merchant?.id == _filterMerchantId).toList();
          }

          if (filtered.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.spaceXL),
                child: Text(
                  l10n.household_no_expenses,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.outline),
                ),
              ),
            );
          }

          final total = filtered.fold<double>(0, (sum, e) => sum + e.amount);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${filtered.length}건',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.outline),
                  ),
                  Text(
                    '합계 ₩${_fmtAmount(total)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceS),
              ...filtered.map((e) => ExpenseListItem(expense: e, onTap: () {}, onDelete: () {})),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.common_error)),
      ),
    ];
  }

  String _fmtAmount(double amount) {
    final i = amount.toInt();
    final s = i.toString();
    final buf = StringBuffer();
    for (var j = 0; j < s.length; j++) {
      if (j > 0 && (s.length - j) % 3 == 0) buf.write(',');
      buf.write(s[j]);
    }
    return buf.toString();
  }
}

class _MerchantStat {
  final String id;
  final String name;
  final double total;
  final int count;

  const _MerchantStat({required this.id, required this.name, required this.total, required this.count});
}

class _MerchantStatItem extends StatelessWidget {
  final _MerchantStat stat;
  final double maxAmount;
  final bool isNone;

  const _MerchantStatItem({required this.stat, required this.maxAmount, this.isNone = false});

  @override
  Widget build(BuildContext context) {
    final ratio = maxAmount > 0 ? (stat.total / maxAmount).clamp(0.0, 1.0) : 0.0;
    final color = isNone
        ? Theme.of(context).colorScheme.outline
        : Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
            child: Icon(
              isNone ? Icons.storefront_outlined : Icons.storefront,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: AppSizes.spaceS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        stat.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '₩${_fmt(stat.total)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: ratio,
                    minHeight: 4,
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                    color: color,
                  ),
                ),
                Text(
                  '${stat.count}건',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.outline),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(double amount) {
    final i = amount.toInt();
    final s = i.toString();
    final buf = StringBuffer();
    for (var j = 0; j < s.length; j++) {
      if (j > 0 && (s.length - j) % 3 == 0) buf.write(',');
      buf.write(s[j]);
    }
    return buf.toString();
  }
}

class _FilterDropdownRow extends StatelessWidget {
  final String label;
  final Widget child;

  const _FilterDropdownRow({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.outline),
          ),
          const SizedBox(width: AppSizes.spaceS),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _TotalSummaryCard extends StatelessWidget {
  final MonthlyStatisticsModel stats;

  const _TotalSummaryCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ratio = stats.totalBudget > 0
        ? (stats.totalExpense / stats.totalBudget).clamp(0.0, 1.0)
        : 0.0;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 입금이 있으면 입금·지출·잔액 3열, 없으면 지출·예산 2열
            if (stats.hasIncome)
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.household_total_income, style: Theme.of(context).textTheme.bodySmall),
                        Text(
                          '₩${_fmt(stats.totalIncome)}',
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
                        Text(l10n.household_total_expense, style: Theme.of(context).textTheme.bodySmall),
                        Text(
                          '₩${_fmt(stats.totalExpense)}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.error,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(l10n.household_balance, style: Theme.of(context).textTheme.bodySmall),
                        Text(
                          '₩${_fmt(stats.balance)}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: stats.balance >= 0 ? Colors.green : Theme.of(context).colorScheme.error,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.household_total_expense,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '₩${_fmt(stats.totalExpense)}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.error,
                            ),
                      ),
                    ],
                  ),
                  if (stats.totalBudget > 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          l10n.household_total_budget,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '₩${_fmt(stats.totalBudget)}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                ],
              ),
            if (!stats.hasIncome && stats.totalBudget > 0) ...[
              const SizedBox(height: AppSizes.spaceM),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: ratio,
                  minHeight: 8,
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  color: ratio >= 1.0
                      ? Theme.of(context).colorScheme.error
                      : ratio >= 0.8
                          ? Colors.orange
                          : Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: AppSizes.spaceXS),
              Text(
                '예산의 ${(ratio * 100).toStringAsFixed(1)}% 사용',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _fmt(double amount) {
    final i = amount.toInt();
    final s = i.toString();
    final buf = StringBuffer();
    for (var j = 0; j < s.length; j++) {
      if (j > 0 && (s.length - j) % 3 == 0) buf.write(',');
      buf.write(s[j]);
    }
    return buf.toString();
  }
}

class _CategoryStatItem extends StatelessWidget {
  final CategoryStatModel stat;
  final String month;

  const _CategoryStatItem({required this.stat, required this.month});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = categoryColor(stat.category);
    final ratio = stat.budgetRatio != null && stat.budget != null && stat.budget! > 0
        ? (stat.budgetRatio! / 100.0).clamp(0.0, 1.0)
        : null;

    return InkWell(
      onTap: () => context.push(
        AppRoutes.householdCategoryExpenses,
        extra: {'category': stat.category, 'month': month},
      ),
      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      child: Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
            child: Icon(categoryIcon(stat.category), color: color, size: 18),
          ),
          const SizedBox(width: AppSizes.spaceS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      categoryName(l10n, stat.category),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      '₩${_fmt(stat.total)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                  ],
                ),
                if (ratio != null) ...[
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: ratio,
                      minHeight: 4,
                      backgroundColor:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      color: ratio >= 1.0
                          ? Theme.of(context).colorScheme.error
                          : color,
                    ),
                  ),
                  Text(
                    '${stat.count}건 · 예산 ${(ratio * 100).toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ] else
                  Text(
                    '${stat.count}건',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  String _fmt(double amount) {
    final i = amount.toInt();
    final s = i.toString();
    final buf = StringBuffer();
    for (var j = 0; j < s.length; j++) {
      if (j > 0 && (s.length - j) % 3 == 0) buf.write(',');
      buf.write(s[j]);
    }
    return buf.toString();
  }
}

class _IncomeSummaryItem extends StatelessWidget {
  final double totalIncome;
  final String month;

  const _IncomeSummaryItem({required this.totalIncome, required this.month});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(
        AppRoutes.householdCategoryExpenses,
        extra: {'category': null, 'month': month, 'type': TransactionType.income},
      ),
      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              ),
              child: const Icon(Icons.arrow_downward, color: Colors.green, size: 18),
            ),
            const SizedBox(width: AppSizes.spaceS),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.household_income,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    '₩${_fmt(totalIncome)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSizes.spaceXS),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: Theme.of(context).colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(double amount) {
    final i = amount.toInt();
    final s = i.toString();
    final buf = StringBuffer();
    for (var j = 0; j < s.length; j++) {
      if (j > 0 && (s.length - j) % 3 == 0) buf.write(',');
      buf.write(s[j]);
    }
    return buf.toString();
  }
}

// 연간 통계 탭
class _YearlyStatisticsTab extends ConsumerWidget {
  final String year;

  const _YearlyStatisticsTab({required this.year});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final statsAsync = ref.watch(householdYearlyStatisticsProvider(year));

    return statsAsync.when(
      data: (stats) => _YearlyStatisticsContent(stats: stats),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.common_error),
            const SizedBox(height: AppSizes.spaceS),
            ElevatedButton(
              onPressed: () =>
                  ref.invalidate(householdYearlyStatisticsProvider(year)),
              child: Text(l10n.common_retry),
            ),
          ],
        ),
      ),
    );
  }
}

class _YearlyStatisticsContent extends StatelessWidget {
  final YearlyStatisticsModel stats;

  const _YearlyStatisticsContent({required this.stats});

  @override
  Widget build(BuildContext context) {
    final maxMonthly = stats.months.isEmpty
        ? 1.0
        : stats.months
            .map((m) => m.totalExpense)
            .reduce((a, b) => a > b ? a : b)
            .clamp(1.0, double.infinity);

    return ListView(
      padding: EdgeInsets.only(
        left: AppSizes.spaceM,
        right: AppSizes.spaceM,
        top: AppSizes.spaceM,
        bottom: AppSizes.spaceM + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        // 연간 합계
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            side: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spaceM),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.spaceM),
              child: stats.hasIncome
                  ? Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${stats.year}년 총 입금', style: Theme.of(context).textTheme.bodySmall),
                              Text(
                                '₩${_fmt(stats.totalIncome)}',
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
                              Text('${stats.year}년 총 지출', style: Theme.of(context).textTheme.bodySmall),
                              Text(
                                '₩${_fmt(stats.totalExpense)}',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.error,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('잔액', style: Theme.of(context).textTheme.bodySmall),
                              Text(
                                '₩${_fmt(stats.balance)}',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: stats.balance >= 0 ? Colors.green : Theme.of(context).colorScheme.error,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${stats.year}년 총 지출', style: Theme.of(context).textTheme.bodySmall),
                        Text(
                          '₩${_fmt(stats.totalExpense)}',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.error,
                              ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        const SizedBox(height: AppSizes.spaceM),
        // 월별 막대 차트
        if (stats.months.isNotEmpty) ...[
          Text(
            '월별 지출',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppSizes.spaceS),
          ...stats.months.map(
            (m) => _MonthBarItem(
              monthData: m,
              maxAmount: maxMonthly,
            ),
          ),
        ],
      ],
    );
  }

  String _fmt(double amount) {
    final i = amount.toInt();
    final s = i.toString();
    final buf = StringBuffer();
    for (var j = 0; j < s.length; j++) {
      if (j > 0 && (s.length - j) % 3 == 0) buf.write(',');
      buf.write(s[j]);
    }
    return buf.toString();
  }
}

class _MonthBarItem extends StatelessWidget {
  final MonthlyTotalModel monthData;
  final double maxAmount;

  const _MonthBarItem({
    required this.monthData,
    required this.maxAmount,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = maxAmount > 0 ? (monthData.totalExpense / maxAmount).clamp(0.0, 1.0) : 0.0;
    final month = monthData.month.split('-')[1];

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              '${int.parse(month)}월',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(width: AppSizes.spaceS),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 20,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: AppSizes.spaceS),
          SizedBox(
            width: 80,
            child: Text(
              '₩${_fmt(monthData.totalExpense)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(double amount) {
    final i = amount.toInt();
    final s = i.toString();
    final buf = StringBuffer();
    for (var j = 0; j < s.length; j++) {
      if (j > 0 && (s.length - j) % 3 == 0) buf.write(',');
      buf.write(s[j]);
    }
    return buf.toString();
  }
}
