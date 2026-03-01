import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/household/data/models/statistics_model.dart';
import 'package:family_planner/features/main/household/presentation/widgets/expense_list_item.dart';
import 'package:family_planner/features/main/household/providers/household_provider.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

class HouseholdStatisticsScreen extends ConsumerWidget {
  const HouseholdStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedMonth = ref.watch(householdSelectedMonthProvider);
    final year = selectedMonth.split('-')[0];
    final selectedGroupId = ref.watch(householdSelectedGroupIdProvider);
    final groupsAsync = ref.watch(myGroupsProvider);
    final groupName = groupsAsync.whenOrNull(
      data: (groups) => groups
          .where((g) => g.id == selectedGroupId)
          .map((g) => g.name)
          .firstOrNull,
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: l10n.household_monthly_statistics),
              Tab(text: '연간 통계'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _MonthlyStatisticsTab(month: selectedMonth),
            _YearlyStatisticsTab(year: year),
          ],
        ),
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
    final statsAsync = ref.watch(householdMonthlyStatisticsProvider);

    return statsAsync.when(
      data: (stats) => _MonthlyStatisticsContent(stats: stats),
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

class _MonthlyStatisticsContent extends StatelessWidget {
  final MonthlyStatisticsModel stats;

  const _MonthlyStatisticsContent({required this.stats});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      children: [
        // 총합 카드
        _TotalSummaryCard(stats: stats),
        const SizedBox(height: AppSizes.spaceM),

        // 카테고리별 분석
        if (stats.categories.isNotEmpty) ...[
          Text(
            '카테고리별 지출',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppSizes.spaceS),
          ...stats.categories.map(
            (cat) => _CategoryStatItem(stat: cat),
          ),
        ] else
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
      ],
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
            if (stats.totalBudget > 0) ...[
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

  const _CategoryStatItem({required this.stat});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = categoryColor(stat.category);
    final ratio = stat.budget != null && stat.budget! > 0
        ? (stat.total / stat.budget!).clamp(0.0, 1.0)
        : null;

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
            .map((m) => m.total)
            .reduce((a, b) => a > b ? a : b)
            .clamp(1.0, double.infinity);

    return ListView(
      padding: const EdgeInsets.all(AppSizes.spaceM),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${stats.year}년 총 지출',
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
    final ratio = maxAmount > 0 ? (monthData.total / maxAmount).clamp(0.0, 1.0) : 0.0;
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
              '₩${_fmt(monthData.total)}',
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
