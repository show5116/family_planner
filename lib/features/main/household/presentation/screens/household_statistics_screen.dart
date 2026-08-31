import 'package:fl_chart/fl_chart.dart';
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
        if (_tabController.indexIsChanging ||
            _tabController.index != _tabIndex) {
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
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.white70),
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
                      icon: const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      ),
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
          _YearlyStatisticsTab(
            year: _selectedYear.toString(),
            onMonthDrillDown: (month) {
              setState(() => _selectedMonth = month);
              _tabController.animateTo(0);
            },
          ),
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
    final statsAsync = ref.watch(
      householdMonthlyStatisticsByMonthProvider(month),
    );

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
              onPressed: () =>
                  ref.invalidate(householdMonthlyStatisticsProvider),
              child: Text(l10n.common_retry),
            ),
          ],
        ),
      ),
    );
  }
}

enum _StatViewMode { category, merchant, member, filter }

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
  String? _filterMemberId; // null = 전체

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedGroupId = ref.watch(householdSelectedGroupIdProvider);

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
        _MonthComparisonSection(month: widget.month),
        const SizedBox(height: AppSizes.spaceXS),
        Row(
          children: [
            Icon(
              Icons.info_outline,
              size: 12,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(width: 4),
            Text(
              '환불금 및 이월 입금은 통계에서 제외됩니다',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spaceM),

        // 뷰 모드 세그먼트 (아이콘 전용, 툴팁으로 설명)
        SegmentedButton<_StatViewMode>(
          showSelectedIcon: false,
          segments: [
            const ButtonSegment(
              value: _StatViewMode.category,
              icon: Tooltip(
                message: '카테고리별',
                child: Icon(Icons.pie_chart_outline, size: 18),
              ),
            ),
            const ButtonSegment(
              value: _StatViewMode.merchant,
              icon: Tooltip(
                message: '소비처별',
                child: Icon(Icons.storefront_outlined, size: 18),
              ),
            ),
            if (selectedGroupId != null)
              const ButtonSegment(
                value: _StatViewMode.member,
                icon: Tooltip(
                  message: '멤버별',
                  child: Icon(Icons.people_outline, size: 18),
                ),
              ),
            const ButtonSegment(
              value: _StatViewMode.filter,
              icon: Tooltip(
                message: '직접 필터링',
                child: Icon(Icons.filter_list, size: 18),
              ),
            ),
          ],
          selected: {_viewMode},
          onSelectionChanged: (s) => setState(() {
            _viewMode = s.first;
          }),
          style: const ButtonStyle(visualDensity: VisualDensity.compact),
        ),
        const SizedBox(height: AppSizes.spaceM),

        if (_viewMode == _StatViewMode.category)
          ..._buildCategoryView(context, l10n)
        else if (_viewMode == _StatViewMode.merchant)
          ..._buildMerchantView(context, l10n)
        else if (_viewMode == _StatViewMode.member)
          ..._buildMemberView(context, l10n, selectedGroupId!)
        else
          ..._buildFilterView(context, l10n),
      ],
    );
  }

  List<Widget> _buildCategoryView(BuildContext context, AppLocalizations l10n) {
    final expensesAsync = ref.watch(
      householdExpensesByMonthProvider(widget.month),
    );

    // 멤버 필터가 적용된 경우 클라이언트 집계
    if (_filterMemberId != null) {
      return [
        expensesAsync.when(
          data: (allExpenses) {
            final expenses = allExpenses
                .where((e) => e.memberId == _filterMemberId)
                .toList();
            final incomes = expenses
                .where(
                  (e) =>
                      e.type == TransactionType.income &&
                      e.refundedExpenseId == null &&
                      e.incomeCategory != IncomeCategory.carryover,
                )
                .toList();
            final onlyExpenses = expenses
                .where((e) => e.type == TransactionType.expense)
                .toList();

            final totalIncome = incomes.fold<double>(0, (s, e) => s + e.amount);
            final totalExpense = onlyExpenses.fold<double>(
              0,
              (s, e) => s + e.amount,
            );

            if (expenses.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.spaceXL),
                  child: Text(
                    l10n.household_no_expenses,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
              );
            }

            // 수입 집계
            final incomeByCategory = <IncomeCategory, double>{};
            for (final e in incomes) {
              final cat = e.incomeCategory ?? IncomeCategory.otherIncome;
              incomeByCategory[cat] = (incomeByCategory[cat] ?? 0) + e.amount;
            }
            final sortedIncomes = incomeByCategory.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));

            // 지출 카테고리 집계
            final expByCategory = <ExpenseCategory, _ClientCatStat>{};
            for (final e in onlyExpenses) {
              final cat = e.category ?? ExpenseCategory.other;
              final prev = expByCategory[cat] ?? _ClientCatStat(cat, 0, 0);
              expByCategory[cat] = _ClientCatStat(
                cat,
                prev.total + e.amount,
                prev.count + 1,
              );
            }
            final sortedExpenses = expByCategory.values.toList()
              ..sort((a, b) => b.total.compareTo(a.total));

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (incomes.isNotEmpty) ...[
                  // 수입 요약
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.household_income,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '₩${_fmtAmount(totalIncome)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spaceS),
                  ...sortedIncomes.map(
                    (entry) => _IncomeCategoryStatItem(
                      category: entry.key,
                      amount: entry.value,
                      totalIncome: totalIncome,
                      month: widget.month,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceM),
                ],
                if (onlyExpenses.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '카테고리별 지출',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '₩${_fmtAmount(totalExpense)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spaceS),
                  ...sortedExpenses.map(
                    (stat) => _ClientCategoryStatItem(
                      stat: stat,
                      totalExpense: totalExpense,
                      month: widget.month,
                    ),
                  ),
                ],
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(child: Text(l10n.common_error)),
        ),
      ];
    }

    // 전체 보기: 기존 서버 stats 사용
    return [
      if (widget.stats.hasIncome) ...[
        Text(
          l10n.household_income,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSizes.spaceS),
        expensesAsync.when(
          data: (expenses) {
            // 통계 화면: 환불 입금 및 이월 입금 제외
            final incomes = expenses
                .where(
                  (e) =>
                      e.type == TransactionType.income &&
                      e.refundedExpenseId == null &&
                      e.incomeCategory != IncomeCategory.carryover,
                )
                .toList();
            if (incomes.isEmpty) {
              return _IncomeSummaryItem(
                totalIncome: widget.stats.totalIncome,
                month: widget.month,
              );
            }
            // IncomeCategory별 집계 — null은 otherIncome으로 통합
            final catTotals = <IncomeCategory, double>{};
            for (final e in incomes) {
              final cat = e.incomeCategory ?? IncomeCategory.otherIncome;
              catTotals[cat] = (catTotals[cat] ?? 0) + e.amount;
            }
            final sorted = catTotals.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...sorted.map(
                  (entry) => _IncomeCategoryStatItem(
                    category: entry.key,
                    amount: entry.value,
                    totalIncome: widget.stats.totalIncome,
                    month: widget.month,
                  ),
                ),
              ],
            );
          },
          loading: () => _IncomeSummaryItem(
            totalIncome: widget.stats.totalIncome,
            month: widget.month,
          ),
          error: (_, _) => _IncomeSummaryItem(
            totalIncome: widget.stats.totalIncome,
            month: widget.month,
          ),
        ),
        const SizedBox(height: AppSizes.spaceM),
      ],
      if (widget.stats.categories.isNotEmpty) ...[
        Text(
          '카테고리별 지출',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSizes.spaceS),
        ...widget.stats.categories.map(
          (cat) => _CategoryStatItem(stat: cat, month: widget.month),
        ),
      ] else if (!widget.stats.hasIncome)
        Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spaceXL),
            child: Text(
              l10n.household_no_expenses,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
        ),
    ];
  }

  List<Widget> _buildMerchantView(BuildContext context, AppLocalizations l10n) {
    final expensesAsync = ref.watch(
      householdExpensesByMonthProvider(widget.month),
    );

    return [
      expensesAsync.when(
        data: (expenses) {
          final filtered = _filterMemberId != null
              ? expenses.where((e) => e.memberId == _filterMemberId).toList()
              : expenses;
          final onlyExpenses = filtered
              .where((e) => e.type == TransactionType.expense)
              .toList();
          if (onlyExpenses.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.spaceXL),
                child: Text(
                  l10n.household_no_expenses,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
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
              final stat =
                  merchantMap[key] ??
                  _MerchantStat(
                    id: key,
                    name: e.merchant!.name,
                    total: 0,
                    count: 0,
                  );
              merchantMap[key] = _MerchantStat(
                id: stat.id,
                name: stat.name,
                total: stat.total + e.amount,
                count: stat.count + 1,
              );
            }
          }

          final sorted = merchantMap.values.toList()
            ..sort((a, b) => b.total.compareTo(a.total));
          final maxAmount = sorted.isEmpty ? 1.0 : sorted.first.total;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '소비처별 지출',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSizes.spaceS),
              ...sorted.map(
                (stat) => _MerchantStatItem(
                  stat: stat,
                  maxAmount: maxAmount,
                  onTap: () => context.push(
                    AppRoutes.householdCategoryExpenses,
                    extra: {
                      'month': widget.month,
                      'merchantId': stat.id,
                      'merchantName': stat.name,
                      'category': null,
                    },
                  ),
                ),
              ),
              if (noMerchantCount > 0)
                _MerchantStatItem(
                  stat: _MerchantStat(
                    id: '',
                    name: '소비처 없음',
                    total: noMerchantTotal,
                    count: noMerchantCount,
                  ),
                  maxAmount: maxAmount,
                  isNone: true,
                  onTap: () => context.push(
                    AppRoutes.householdCategoryExpenses,
                    extra: {
                      'month': widget.month,
                      'merchantId': '',
                      'merchantName': '소비처 없음',
                      'category': null,
                    },
                  ),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.common_error)),
      ),
    ];
  }

  List<Widget> _buildMemberView(
    BuildContext context,
    AppLocalizations l10n,
    String groupId,
  ) {
    final membersAsync = ref.watch(groupMembersProvider(groupId));
    final expensesAsync = ref.watch(
      householdExpensesByMonthProvider(widget.month),
    );

    return [
      membersAsync.when(
        data: (members) => expensesAsync.when(
          data: (allExpenses) {
            final onlyExpenses = allExpenses
                .where((e) => e.type == TransactionType.expense)
                .toList();
            if (onlyExpenses.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.spaceXL),
                  child: Text(
                    l10n.household_no_expenses,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
              );
            }

            // 멤버별 지출 집계
            final memberTotals = <String, double>{};
            final memberCounts = <String, int>{};
            double unassignedTotal = 0;
            int unassignedCount = 0;

            for (final e in onlyExpenses) {
              if (e.memberId == null) {
                unassignedTotal += e.amount;
                unassignedCount++;
              } else {
                memberTotals[e.memberId!] =
                    (memberTotals[e.memberId!] ?? 0) + e.amount;
                memberCounts[e.memberId!] =
                    (memberCounts[e.memberId!] ?? 0) + 1;
              }
            }

            final grandTotal = onlyExpenses.fold<double>(
              0,
              (s, e) => s + e.amount,
            );

            // 멤버 순서대로 정렬 (금액 내림차순)
            final memberEntries = memberTotals.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));

            // userId → 이름 매핑
            final nameMap = {
              for (final m in members)
                (m.user?.id ?? m.userId): (m.user?.name ?? m.userId),
            };

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '멤버별 지출',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSizes.spaceS),
                ...memberEntries.map((entry) {
                  final ratio = grandTotal > 0
                      ? (entry.value / grandTotal).clamp(0.0, 1.0)
                      : 0.0;
                  final name = nameMap[entry.key] ?? entry.key;
                  final count = memberCounts[entry.key] ?? 0;
                  return _MemberExpenseStatItem(
                    name: name,
                    amount: entry.value,
                    count: count,
                    ratio: ratio,
                    onTap: () => context.push(
                      AppRoutes.householdCategoryExpenses,
                      extra: {
                        'month': widget.month,
                        'memberId': entry.key,
                        'memberName': name,
                        'category': null,
                      },
                    ),
                  );
                }),
                if (unassignedCount > 0)
                  _MemberExpenseStatItem(
                    name: '미지정',
                    amount: unassignedTotal,
                    count: unassignedCount,
                    ratio: grandTotal > 0
                        ? (unassignedTotal / grandTotal).clamp(0.0, 1.0)
                        : 0.0,
                    isUnassigned: true,
                    onTap: () => context.push(
                      AppRoutes.householdCategoryExpenses,
                      extra: {
                        'month': widget.month,
                        'memberId': '',
                        'memberName': '미지정',
                        'category': null,
                      },
                    ),
                  ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(child: Text(l10n.common_error)),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.common_error)),
      ),
    ];
  }

  List<Widget> _buildFilterView(BuildContext context, AppLocalizations l10n) {
    final expensesAsync = ref.watch(
      householdExpensesByMonthProvider(widget.month),
    );
    final merchantsAsync = ref.watch(merchantsProvider);
    final selectedGroupId = ref.watch(householdSelectedGroupIdProvider);

    return [
      // 멤버 필터 (그룹 모드)
      if (selectedGroupId != null)
        ref
                .watch(groupMembersProvider(selectedGroupId))
                .whenOrNull(
                  data: (members) {
                    if (members.length <= 1) return const SizedBox.shrink();
                    return Column(
                      children: [
                        _FilterDropdownRow(
                          label: '멤버',
                          child: DropdownButton<String?>(
                            value: _filterMemberId,
                            isExpanded: true,
                            underline: const SizedBox(),
                            hint: const Text('전체'),
                            items: [
                              const DropdownMenuItem<String?>(
                                value: null,
                                child: Text('전체'),
                              ),
                              ...members.map((m) {
                                final userId = m.user?.id ?? m.userId;
                                final name = m.user?.name ?? userId;
                                return DropdownMenuItem(
                                  value: userId,
                                  child: Text(name),
                                );
                              }),
                            ],
                            onChanged: (v) =>
                                setState(() => _filterMemberId = v),
                          ),
                        ),
                        const SizedBox(height: AppSizes.spaceS),
                      ],
                    );
                  },
                ) ??
            const SizedBox.shrink(),
      // 카테고리 필터
      _FilterDropdownRow(
        label: '카테고리',
        child: DropdownButton<ExpenseCategory?>(
          value: _filterCategory,
          isExpanded: true,
          underline: const SizedBox(),
          hint: const Text('전체'),
          items: [
            const DropdownMenuItem<ExpenseCategory?>(
              value: null,
              child: Text('전체'),
            ),
            ...ExpenseCategory.values.map(
              (c) => DropdownMenuItem(
                value: c,
                child: Text(categoryName(l10n, c)),
              ),
            ),
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
              ...merchants.map(
                (m) => DropdownMenuItem(value: m.id, child: Text(m.name)),
              ),
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
          var filtered = expenses
              .where((e) => e.type == TransactionType.expense)
              .toList();
          if (_filterMemberId != null) {
            filtered = filtered
                .where((e) => e.memberId == _filterMemberId)
                .toList();
          }
          if (_filterCategory != null) {
            filtered = filtered
                .where((e) => e.category == _filterCategory)
                .toList();
          }
          if (_filterMerchantId != null) {
            filtered = filtered
                .where((e) => e.merchant?.id == _filterMerchantId)
                .toList();
          }

          if (filtered.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.spaceXL),
                child: Text(
                  l10n.household_no_expenses,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
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
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
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
              ...filtered.map((e) => ExpenseListItem(expense: e, onTap: () {})),
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

/// 클라이언트 집계용 카테고리 통계 (memberId 필터 시 사용)
class _ClientCatStat {
  final ExpenseCategory category;
  final double total;
  final int count;

  const _ClientCatStat(this.category, this.total, this.count);
}

class _ClientCategoryStatItem extends StatelessWidget {
  final _ClientCatStat stat;
  final double totalExpense;
  final String month;

  const _ClientCategoryStatItem({
    required this.stat,
    required this.totalExpense,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = categoryColor(stat.category);
    final ratio = totalExpense > 0
        ? (stat.total / totalExpense).clamp(0.0, 1.0)
        : 0.0;

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
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: ratio,
                      minHeight: 7,
                      backgroundColor: const Color(0xFFF0F4F8),
                      color: color,
                    ),
                  ),
                  Text(
                    '${stat.count}건 · ${(ratio * 100).toStringAsFixed(0)}%',
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

class _MerchantStat {
  final String id;
  final String name;
  final double total;
  final int count;

  const _MerchantStat({
    required this.id,
    required this.name,
    required this.total,
    required this.count,
  });
}

class _MerchantStatItem extends StatelessWidget {
  final _MerchantStat stat;
  final double maxAmount;
  final bool isNone;
  final VoidCallback? onTap;

  const _MerchantStatItem({
    required this.stat,
    required this.maxAmount,
    this.isNone = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = maxAmount > 0
        ? (stat.total / maxAmount).clamp(0.0, 1.0)
        : 0.0;
    final color = isNone
        ? Theme.of(context).colorScheme.outline
        : Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: onTap,
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
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
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
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      color: color,
                    ),
                  ),
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

class _MemberExpenseStatItem extends StatelessWidget {
  final String name;
  final double amount;
  final int count;
  final double ratio; // 전체 대비 비율
  final bool isUnassigned;
  final VoidCallback? onTap;

  const _MemberExpenseStatItem({
    required this.name,
    required this.amount,
    required this.count,
    required this.ratio,
    this.isUnassigned = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isUnassigned
        ? Theme.of(context).colorScheme.outline
        : Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: onTap,
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
              child: Icon(
                isUnassigned ? Icons.person_outline : Icons.person,
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
                      Text(
                        name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '₩${_fmt(amount)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: ratio,
                      minHeight: 7,
                      backgroundColor: const Color(0xFFF0F4F8),
                      color: color,
                    ),
                  ),
                  Text(
                    '$count건 · ${(ratio * 100).toStringAsFixed(0)}%',
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

class _FilterDropdownRow extends StatelessWidget {
  final String label;
  final Widget child;

  const _FilterDropdownRow({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
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
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
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
                        Text(
                          l10n.household_total_income,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '₩${_fmt(stats.totalIncome)}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
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
                          l10n.household_total_expense,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '₩${_fmt(stats.totalExpense)}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
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
                        Text(
                          l10n.household_balance,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '₩${_fmt(stats.balance)}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: stats.balance >= 0
                                    ? Colors.green
                                    : Theme.of(context).colorScheme.error,
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
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
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
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
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
                  minHeight: 10,
                  backgroundColor: const Color(0xFFF0F4F8),
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
    final ratio =
        stat.budgetRatio != null && stat.budget != null && stat.budget! > 0
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
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: ratio,
                        minHeight: 7,
                        backgroundColor: const Color(0xFFF0F4F8),
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
        extra: {
          'category': null,
          'month': month,
          'type': TransactionType.income,
        },
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
              child: const Icon(
                Icons.arrow_downward,
                color: Colors.green,
                size: 18,
              ),
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
  final void Function(String month)? onMonthDrillDown;

  const _YearlyStatisticsTab({required this.year, this.onMonthDrillDown});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final statsAsync = ref.watch(householdYearlyStatisticsProvider(year));

    return statsAsync.when(
      data: (stats) => _YearlyStatisticsContent(
        stats: stats,
        onMonthDrillDown: onMonthDrillDown,
      ),
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
  final void Function(String month)? onMonthDrillDown;

  const _YearlyStatisticsContent({required this.stats, this.onMonthDrillDown});

  @override
  Widget build(BuildContext context) {
    final expenseMonths = stats.months
        .where((m) => m.totalExpense > 0)
        .toList();
    final monthCount = expenseMonths.isEmpty ? 1 : expenseMonths.length;
    final avgExpense = stats.months.isEmpty
        ? 0.0
        : stats.totalExpense / monthCount;

    // 아웃라이어 캡: 평균의 3배 초과 시 캡 처리
    final capThreshold = avgExpense * 3.0;
    // 캡 이후의 effective max (캡된 달은 capThreshold, 아닌 달은 실제 값)
    final effectiveMax = stats.months.isEmpty
        ? 1.0
        : stats.months
              .map(
                (m) => m.totalExpense > capThreshold && capThreshold > 0
                    ? capThreshold
                    : m.totalExpense,
              )
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
        // 연간 합계 카드
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
            child: stats.hasIncome
                ? Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${stats.year}년 총 입금',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              '₩${_fmt(stats.totalIncome)}',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
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
                              '${stats.year}년 총 지출',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              '₩${_fmt(stats.totalExpense)}',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
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
                            Text(
                              '잔액',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              '₩${_fmt(stats.balance)}',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: stats.balance >= 0
                                        ? Colors.green
                                        : Theme.of(context).colorScheme.error,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${stats.year}년 총 지출',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              '₩${_fmt(stats.totalExpense)}',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '월평균',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                          ),
                          Text(
                            '₩${_fmt(avgExpense)}',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: AppSizes.spaceXS),
        Row(
          children: [
            Icon(
              Icons.info_outline,
              size: 12,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(width: 4),
            Text(
              '환불금 및 이월 입금은 통계에서 제외됩니다',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spaceM),
        // 월별 막대 차트
        if (stats.months.isNotEmpty) ...[
          Row(
            children: [
              Text(
                '월별 지출',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              if (stats.hasIncome)
                Text(
                  '월평균 ₩${_fmt(avgExpense)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceS),
          ...stats.months.map(
            (m) => _MonthBarItem(
              monthData: m,
              effectiveMax: effectiveMax,
              capThreshold: capThreshold > 0 ? capThreshold : double.infinity,
              avgExpense: avgExpense,
              onTap: onMonthDrillDown != null
                  ? () => onMonthDrillDown!(m.month)
                  : null,
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
  final double effectiveMax;
  final double capThreshold;
  final double avgExpense;
  final VoidCallback? onTap;

  const _MonthBarItem({
    required this.monthData,
    required this.effectiveMax,
    required this.capThreshold,
    required this.avgExpense,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final month = monthData.month.split('-')[1];
    final expense = monthData.totalExpense;
    final isCapped = expense > capThreshold && capThreshold < double.infinity;

    // 캡 처리: 아웃라이어는 capThreshold 기준으로 비율 계산
    final effectiveValue = isCapped ? capThreshold : expense;
    // 최소 4% 보장 (금액이 있는 경우)
    final rawRatio = effectiveMax > 0 ? effectiveValue / effectiveMax : 0.0;
    final ratio = expense > 0 ? rawRatio.clamp(0.04, 1.0) : 0.0;

    // 평균선 위치 (0~1)
    final avgRatio = avgExpense > 0 && effectiveMax > 0
        ? (avgExpense / effectiveMax).clamp(0.0, 1.0)
        : 0.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            SizedBox(
              width: 32,
              child: Text(
                '${int.parse(month)}월',
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: AppSizes.spaceS),
            Expanded(
              child: CustomPaint(
                foregroundPainter: _AvgLinePainter(
                  avgRatio: avgRatio,
                  color: colorScheme.outline.withValues(alpha: 0.6),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: ratio,
                        minHeight: 20,
                        backgroundColor: const Color(0xFFF0F4F8),
                        color: colorScheme.primary,
                      ),
                    ),
                    // 캡 표시
                    if (isCapped)
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Text(
                              '≫',
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSizes.spaceS),
            SizedBox(
              width: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onTap != null)
                    Icon(
                      Icons.chevron_right,
                      size: 14,
                      color: colorScheme.outline,
                    ),
                  Flexible(
                    child: Text(
                      expense > 0 ? '₩${_fmt(expense)}' : '-',
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: isCapped
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isCapped ? colorScheme.error : null,
                      ),
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
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

// 입금 카테고리별 통계 아이템
class _IncomeCategoryStatItem extends StatelessWidget {
  final IncomeCategory? category;
  final double amount;
  final double totalIncome;
  final String month;

  const _IncomeCategoryStatItem({
    required this.category,
    required this.amount,
    required this.totalIncome,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = incomeCategoryColor(category);
    final ratio = totalIncome > 0
        ? (amount / totalIncome).clamp(0.0, 1.0)
        : 0.0;

    return InkWell(
      onTap: () => context.push(
        AppRoutes.householdCategoryExpenses,
        extra: {
          'month': month,
          'type': TransactionType.income,
          'incomeCategory': category,
        },
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
              child: Icon(incomeCategoryIcon(category), color: color, size: 18),
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
                        incomeCategoryName(l10n, category),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '₩${_fmt(amount)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
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
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      color: color,
                    ),
                  ),
                  Text(
                    '총 입금의 ${(ratio * 100).toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
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

// ── 지난달 비교 섹션 ──────────────────────────────────────────────────────
class _MonthComparisonSection extends ConsumerWidget {
  final String month;
  const _MonthComparisonSection({required this.month});

  String _prevMonth(String m) {
    final parts = m.split('-');
    var y = int.parse(parts[0]);
    var mo = int.parse(parts[1]) - 1;
    if (mo < 1) {
      mo = 12;
      y--;
    }
    return '$y-${mo.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prev = _prevMonth(month);
    final thisAsync = ref.watch(householdExpensesByMonthProvider(month));
    final prevAsync = ref.watch(householdExpensesByMonthProvider(prev));

    return switch ((thisAsync, prevAsync)) {
      (AsyncData(:final value), AsyncData(value: final prevValue)) =>
        _MonthComparisonContent(
          month: month,
          prevMonth: prev,
          thisExpenses: value,
          prevExpenses: prevValue,
        ),
      (AsyncLoading(), _) || (_, AsyncLoading()) => const SizedBox(height: 4),
      _ => const SizedBox.shrink(),
    };
  }
}

class _MonthComparisonContent extends StatelessWidget {
  final String month;
  final String prevMonth;
  final List<ExpenseModel> thisExpenses;
  final List<ExpenseModel> prevExpenses;

  const _MonthComparisonContent({
    required this.month,
    required this.prevMonth,
    required this.thisExpenses,
    required this.prevExpenses,
  });

  Map<int, double> _dailyExpense(List<ExpenseModel> expenses) {
    final map = <int, double>{};
    for (final e in expenses) {
      if (e.type != TransactionType.expense) continue;
      if (e.refundedExpenseId != null) continue;
      if (e.category == ExpenseCategory.carryover) continue;
      final day = e.date.day;
      map[day] = (map[day] ?? 0) + e.amount;
    }
    return map;
  }

  String _fmt(double v) {
    final s = v.toInt().toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  String _labelMonth(String m) {
    final p = m.split('-');
    return '${int.parse(p[1])}월';
  }

  @override
  Widget build(BuildContext context) {
    final thisDaily = _dailyExpense(thisExpenses);
    final prevDaily = _dailyExpense(prevExpenses);

    if (prevDaily.isEmpty) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final now = DateTime.now();
    final monthParts = month.split('-');
    final isCurrentMonth =
        int.parse(monthParts[0]) == now.year &&
        int.parse(monthParts[1]) == now.month;
    final compareDay = isCurrentMonth
        ? now.day
        : DateTime(
            int.parse(monthParts[0]),
            int.parse(monthParts[1]) + 1,
            0,
          ).day;

    // 누적 합계 계산
    double thisCumulative = 0;
    double prevCumulative = 0;
    for (var d = 1; d <= compareDay; d++) {
      thisCumulative += thisDaily[d] ?? 0;
      prevCumulative += prevDaily[d] ?? 0;
    }
    final diff = thisCumulative - prevCumulative;
    final isMore = diff > 0;

    final prevParts = prevMonth.split('-');
    final prevLastDay = DateTime(
      int.parse(prevParts[0]),
      int.parse(prevParts[1]) + 1,
      0,
    ).day;
    final thisLastDay = DateTime(
      int.parse(monthParts[0]),
      int.parse(monthParts[1]) + 1,
      0,
    ).day;

    // 누적 추이 포인트 생성 (day=0 → cumulative=0 포함)
    final chartEndDay = isCurrentMonth ? compareDay : thisLastDay;
    final thisSpots = <FlSpot>[];
    final prevSpots = <FlSpot>[];
    double tCum = 0;
    double pCum = 0;
    thisSpots.add(const FlSpot(0, 0));
    prevSpots.add(const FlSpot(0, 0));
    for (var d = 1; d <= chartEndDay; d++) {
      tCum += thisDaily[d] ?? 0;
      thisSpots.add(FlSpot(d.toDouble(), tCum));
    }
    for (var d = 1; d <= prevLastDay; d++) {
      pCum += prevDaily[d] ?? 0;
      prevSpots.add(FlSpot(d.toDouble(), pCum));
    }

    final maxCumulative = [
      thisSpots.map((s) => s.y).fold(0.0, (a, b) => a > b ? a : b),
      prevSpots.map((s) => s.y).fold(0.0, (a, b) => a > b ? a : b),
    ].reduce((a, b) => a > b ? a : b);
    final chartMaxY = maxCumulative == 0 ? 1.0 : maxCumulative * 1.15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '지난달 비교',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSizes.spaceS),
        Card(
          elevation: 0,
          color: colorScheme.surfaceContainerLow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            side: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spaceM),
            child: Column(
              children: [
                // ── 요약 수치 ──
                Row(
                  children: [
                    Expanded(
                      child: _CompareAmountTile(
                        label: _labelMonth(month),
                        amount: thisCumulative,
                        color: colorScheme.primary,
                        fmt: _fmt,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 36,
                      color: colorScheme.outlineVariant,
                    ),
                    Expanded(
                      child: _CompareAmountTile(
                        label: _labelMonth(prevMonth),
                        amount: prevCumulative,
                        color: colorScheme.outline,
                        fmt: _fmt,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spaceS),
                Divider(color: colorScheme.outlineVariant, height: 1),
                const SizedBox(height: AppSizes.spaceS),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isMore ? Icons.trending_up : Icons.trending_down,
                      size: 16,
                      color: isMore ? colorScheme.error : Colors.teal,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isCurrentMonth ? '$compareDay일 기준  ' : '말일 기준  ',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '₩${_fmt(diff.abs())} ${isMore ? '더 사용' : '덜 사용'}',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isMore ? colorScheme.error : Colors.teal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spaceM),
                Divider(color: colorScheme.outlineVariant, height: 1),
                const SizedBox(height: AppSizes.spaceM),
                // ── 누적 추이 라인 차트 ──
                Row(
                  children: [
                    Text(
                      '누적 지출 추이',
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    _LegendLine(
                      color: colorScheme.primary,
                      label: _labelMonth(month),
                      dashed: false,
                    ),
                    const SizedBox(width: AppSizes.spaceS),
                    _LegendLine(
                      color: colorScheme.outline.withValues(alpha: 0.6),
                      label: _labelMonth(prevMonth),
                      dashed: true,
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spaceM),
                SizedBox(
                  height: 160,
                  child: LineChart(
                    LineChartData(
                      minX: 0,
                      maxX:
                          (chartEndDay > prevLastDay
                                  ? chartEndDay
                                  : prevLastDay)
                              .toDouble(),
                      minY: 0,
                      maxY: chartMaxY,
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (_) =>
                              colorScheme.surfaceContainerHighest,
                          getTooltipItems: (spots) => spots.map((spot) {
                            final isThis = spot.barIndex == 0;
                            final lbl = isThis
                                ? _labelMonth(month)
                                : _labelMonth(prevMonth);
                            return LineTooltipItem(
                              '$lbl ${spot.x.toInt()}일\n₩${_fmt(spot.y)}',
                              textTheme.bodySmall!.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 5,
                            getTitlesWidget: (value, meta) {
                              final d = value.toInt();
                              if (d == 0) return const SizedBox.shrink();
                              if (d % 10 != 0 && d != 1)
                                return const SizedBox.shrink();
                              return Text(
                                '$d일',
                                style: textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 9,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: chartMaxY / 4,
                        getDrawingHorizontalLine: (_) => FlLine(
                          color: colorScheme.outlineVariant.withValues(
                            alpha: 0.4,
                          ),
                          strokeWidth: 0.5,
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        // 이번달 실선
                        LineChartBarData(
                          spots: thisSpots,
                          isCurved: true,
                          curveSmoothness: 0.3,
                          color: colorScheme.primary,
                          barWidth: 2.5,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: colorScheme.primary.withValues(alpha: 0.08),
                          ),
                        ),
                        // 지난달 점선
                        LineChartBarData(
                          spots: prevSpots,
                          isCurved: true,
                          curveSmoothness: 0.3,
                          color: colorScheme.outline.withValues(alpha: 0.6),
                          barWidth: 2,
                          isStrokeCapRound: true,
                          dashArray: [4, 4],
                          dotData: const FlDotData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSizes.spaceL),
      ],
    );
  }
}

class _CompareAmountTile extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final String Function(double) fmt;

  const _CompareAmountTile({
    required this.label,
    required this.amount,
    required this.color,
    required this.fmt,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '₩${fmt(amount)}',
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _LegendLine extends StatelessWidget {
  final Color color;
  final String label;
  final bool dashed;

  const _LegendLine({
    required this.color,
    required this.label,
    required this.dashed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomPaint(
          size: const Size(16, 8),
          painter: _LinePainter(color: color, dashed: dashed),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _LinePainter extends CustomPainter {
  final Color color;
  final bool dashed;

  const _LinePainter({required this.color, required this.dashed});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final y = size.height / 2;
    if (!dashed) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    } else {
      const dashLen = 3.0;
      const gapLen = 3.0;
      var x = 0.0;
      while (x < size.width) {
        canvas.drawLine(
          Offset(x, y),
          Offset((x + dashLen).clamp(0, size.width), y),
          paint,
        );
        x += dashLen + gapLen;
      }
    }
  }

  @override
  bool shouldRepaint(_LinePainter old) =>
      old.color != color || old.dashed != dashed;
}

class _AvgLinePainter extends CustomPainter {
  final double avgRatio;
  final Color color;

  const _AvgLinePainter({required this.avgRatio, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (avgRatio <= 0) return;
    final x = size.width * avgRatio;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    const dashHeight = 3.0;
    const gapHeight = 2.0;
    double y = 0;
    while (y < size.height) {
      canvas.drawLine(
        Offset(x, y),
        Offset(x, (y + dashHeight).clamp(0, size.height)),
        paint,
      );
      y += dashHeight + gapHeight;
    }
  }

  @override
  bool shouldRepaint(_AvgLinePainter old) =>
      old.avgRatio != avgRatio || old.color != color;
}
