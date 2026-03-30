import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/child_points/data/models/childcare_model.dart';
import 'package:family_planner/features/main/child_points/presentation/widgets/transaction_list_item.dart';
import 'package:family_planner/features/main/child_points/providers/childcare_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/app_empty_state.dart';

/// 히스토리 탭
class HistoryTab extends ConsumerWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final account = ref.watch(selectedChildAccountProvider);
    final mode = ref.watch(childcareHistoryViewModeProvider);
    final selectedMonth = ref.watch(childcareSelectedMonthProvider);
    final selectedYear = ref.watch(childcareSelectedYearProvider);
    final transactionsAsync = ref.watch(childcareTransactionsProvider);

    if (account == null) {
      return Center(child: Text(l10n.childcare_no_child));
    }

    return Column(
      children: [
        // 월/연도 토글 + 이동 바
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceM,
            vertical: AppSizes.spaceXS,
          ),
          child: Column(
            children: [
              // 월별/연도별 토글
              SegmentedButton<HistoryViewMode>(
                segments: const [
                  ButtonSegment(
                    value: HistoryViewMode.monthly,
                    label: Text('월별'),
                    icon: Icon(Icons.calendar_view_month, size: 16),
                  ),
                  ButtonSegment(
                    value: HistoryViewMode.yearly,
                    label: Text('연도별'),
                    icon: Icon(Icons.calendar_today, size: 16),
                  ),
                ],
                selected: {mode},
                onSelectionChanged: (s) {
                  ref.read(childcareHistoryViewModeProvider.notifier).state =
                      s.first;
                },
                style: const ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              const SizedBox(height: AppSizes.spaceXS),
              // 기간 이동
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => mode == HistoryViewMode.monthly
                        ? _changeMonth(ref, selectedMonth, -1)
                        : _changeYear(ref, selectedYear, -1),
                    icon: const Icon(Icons.chevron_left),
                    visualDensity: VisualDensity.compact,
                  ),
                  Text(
                    mode == HistoryViewMode.monthly
                        ? _formatMonth(selectedMonth)
                        : selectedYear,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    onPressed: () => mode == HistoryViewMode.monthly
                        ? _changeMonth(ref, selectedMonth, 1)
                        : _changeYear(ref, selectedYear, 1),
                    icon: const Icon(Icons.chevron_right),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: transactionsAsync.when(
            data: (result) {
              final transactions = result.transactions;
              if (transactions.isEmpty) {
                return AppEmptyState(
                  icon: Icons.history,
                  message: l10n.childcare_empty_transactions,
                );
              }
              return RefreshIndicator(
                onRefresh: () =>
                    ref.read(childcareTransactionsProvider.notifier).refresh(),
                child: ListView(
                  children: [
                    if (mode == HistoryViewMode.monthly) ...[
                      _MonthlySummaryCard(transactions: transactions),
                      const SizedBox(height: AppSizes.spaceS),
                      _BalanceLineChart(
                        transactions: transactions,
                        month: selectedMonth,
                        closingBalance: result.closingBalance,
                      ),
                      const SizedBox(height: AppSizes.spaceS),
                      _TypeDonutChart(transactions: transactions),
                    ] else ...[
                      _YearlySummaryCard(transactions: transactions),
                      const SizedBox(height: AppSizes.spaceS),
                      _YearlyBarChart(
                        transactions: transactions,
                        year: selectedYear,
                      ),
                    ],
                    const SizedBox(height: AppSizes.spaceS),
                    const Divider(height: 1),
                    ...transactions.map(
                      (t) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TransactionListItem(transaction: t),
                          const Divider(height: 1),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) =>
                Center(child: Text(l10n.childcare_empty_transactions)),
          ),
        ),
      ],
    );
  }

  void _changeMonth(WidgetRef ref, String currentMonth, int delta) {
    final parts = currentMonth.split('-');
    var year = int.parse(parts[0]);
    var month = int.parse(parts[1]) + delta;
    if (month > 12) {
      month = 1;
      year++;
    } else if (month < 1) {
      month = 12;
      year--;
    }
    ref.read(childcareSelectedMonthProvider.notifier).state =
        '$year-${month.toString().padLeft(2, '0')}';
  }

  void _changeYear(WidgetRef ref, String currentYear, int delta) {
    final year = int.parse(currentYear) + delta;
    ref.read(childcareSelectedYearProvider.notifier).state = year.toString();
  }

  String _formatMonth(String month) {
    final parts = month.split('-');
    return '${parts[0]}.${parts[1]}';
  }
}

// ── 유틸 ──────────────────────────────────────────────────────────────────────

bool _isPositive(ChildcareTransactionType? type) {
  switch (type) {
    case ChildcareTransactionType.reward:
    case ChildcareTransactionType.bonus:
    case ChildcareTransactionType.allowance:
    case ChildcareTransactionType.interest:
    case ChildcareTransactionType.savingsWithdraw:
      return true;
    default:
      return false;
  }
}

// ── 월간 수지 요약 카드 ───────────────────────────────────────────────────────

class _MonthlySummaryCard extends StatelessWidget {
  const _MonthlySummaryCard({required this.transactions});

  final List<ChildcareTransaction> transactions;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    double income = 0;
    double expense = 0;
    for (final t in transactions) {
      if (_isPositive(t.type)) {
        income += t.amount;
      } else {
        expense += t.amount;
      }
    }
    final net = income - expense;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSizes.spaceM, AppSizes.spaceS, AppSizes.spaceM, 0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceM, vertical: AppSizes.spaceS),
          child: Row(
            children: [
              _SummaryItem(
                label: '수입',
                value: '+${income.toInt()}P',
                color: Colors.green,
              ),
              const SizedBox(width: AppSizes.spaceM),
              Container(width: 1, height: 32, color: colorScheme.outlineVariant),
              const SizedBox(width: AppSizes.spaceM),
              _SummaryItem(
                label: '지출',
                value: '-${expense.toInt()}P',
                color: colorScheme.error,
              ),
              const SizedBox(width: AppSizes.spaceM),
              Container(width: 1, height: 32, color: colorScheme.outlineVariant),
              const SizedBox(width: AppSizes.spaceM),
              _SummaryItem(
                label: '순변동',
                value: '${net >= 0 ? '+' : ''}${net.toInt()}P',
                color: net >= 0 ? Colors.green : colorScheme.error,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 연간 수지 요약 카드 ───────────────────────────────────────────────────────

class _YearlySummaryCard extends StatelessWidget {
  const _YearlySummaryCard({required this.transactions});

  final List<ChildcareTransaction> transactions;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    double income = 0;
    double expense = 0;
    for (final t in transactions) {
      if (_isPositive(t.type)) {
        income += t.amount;
      } else {
        expense += t.amount;
      }
    }
    final net = income - expense;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSizes.spaceM, AppSizes.spaceS, AppSizes.spaceM, 0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceM, vertical: AppSizes.spaceS),
          child: Row(
            children: [
              _SummaryItem(
                label: '연간 수입',
                value: '+${income.toInt()}P',
                color: Colors.green,
              ),
              const SizedBox(width: AppSizes.spaceM),
              Container(width: 1, height: 32, color: colorScheme.outlineVariant),
              const SizedBox(width: AppSizes.spaceM),
              _SummaryItem(
                label: '연간 지출',
                value: '-${expense.toInt()}P',
                color: colorScheme.error,
              ),
              const SizedBox(width: AppSizes.spaceM),
              Container(width: 1, height: 32, color: colorScheme.outlineVariant),
              const SizedBox(width: AppSizes.spaceM),
              _SummaryItem(
                label: '순변동',
                value: '${net >= 0 ? '+' : ''}${net.toInt()}P',
                color: net >= 0 ? Colors.green : colorScheme.error,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem(
      {required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: 2),
          Text(value,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: color, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

// ── 일별 잔액 라인 차트 ──────────────────────────────────────────────────────

class _BalanceLineChart extends StatelessWidget {
  const _BalanceLineChart({
    required this.transactions,
    required this.month,
    required this.closingBalance,
  });

  final List<ChildcareTransaction> transactions;
  final String month;
  final double closingBalance;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final parts = month.split('-');
    final year = int.parse(parts[0]);
    final mon = int.parse(parts[1]);
    final daysInMonth = DateUtils.getDaysInMonth(year, mon);

    final sorted = [...transactions]
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    // 일별 순변동 맵
    final Map<int, double> dailyNet = {};
    for (final t in sorted) {
      final day = t.createdAt.day;
      final delta = _isPositive(t.type) ? t.amount : -t.amount;
      dailyNet[day] = (dailyNet[day] ?? 0) + delta;
    }

    // closingBalance에서 역산으로 각 일의 잔액 계산
    double runningBalance = closingBalance;
    final Map<int, double> dailyBalance = {};

    final today = DateTime.now();
    final lastDay = (year == today.year && mon == today.month)
        ? today.day
        : daysInMonth;

    for (int d = lastDay; d >= 1; d--) {
      dailyBalance[d] = runningBalance;
      if (dailyNet.containsKey(d)) {
        runningBalance -= dailyNet[d]!;
      }
    }

    final spots = <FlSpot>[];
    for (int d = 1; d <= lastDay; d++) {
      spots.add(FlSpot(d.toDouble(), (dailyBalance[d] ?? runningBalance).clamp(0, double.infinity)));
    }

    if (spots.isEmpty) return const SizedBox.shrink();

    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final yPad = (maxY - minY) * 0.2 + 10;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSizes.spaceS, AppSizes.spaceM, AppSizes.spaceM, AppSizes.spaceS),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: AppSizes.spaceS),
                child: Text('잔액 추이',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: AppSizes.spaceS),
              SizedBox(
                height: 140,
                child: LineChart(
                  LineChartData(
                    minY: (minY - yPad).clamp(0, double.infinity),
                    maxY: maxY + yPad,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: maxY > 0 ? (maxY / 3).ceilToDouble() : 10,
                      getDrawingHorizontalLine: (_) => FlLine(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: maxY > 0 ? (maxY / 3).ceilToDouble() : 10,
                          getTitlesWidget: (v, _) => Text(
                            '${v.toInt()}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 9,
                                color: colorScheme.onSurfaceVariant),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: (lastDay / 4).ceilToDouble(),
                          getTitlesWidget: (v, _) => Text(
                            '${v.toInt()}일',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 9,
                                color: colorScheme.onSurfaceVariant),
                          ),
                        ),
                      ),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        curveSmoothness: 0.3,
                        color: colorScheme.primary,
                        barWidth: 2,
                        dotData: FlDotData(
                          show: true,
                          checkToShowDot: (spot, _) =>
                              dailyNet.containsKey(spot.x.toInt()),
                          getDotPainter: (_, spot, barData, index) =>
                              FlDotCirclePainter(
                            radius: 3,
                            color: colorScheme.primary,
                            strokeWidth: 0,
                          ),
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color: colorScheme.primary.withValues(alpha: 0.08),
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (_) => colorScheme.surfaceContainerHighest,
                        getTooltipItems: (spots) => spots
                            .map((s) => LineTooltipItem(
                                  '${s.y.toInt()}P',
                                  TextStyle(
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 연간 월별 수입/지출 막대 차트 ────────────────────────────────────────────

class _YearlyBarChart extends StatefulWidget {
  const _YearlyBarChart({
    required this.transactions,
    required this.year,
  });

  final List<ChildcareTransaction> transactions;
  final String year;

  @override
  State<_YearlyBarChart> createState() => _YearlyBarChartState();
}

class _YearlyBarChartState extends State<_YearlyBarChart> {
  bool _showIncome = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // 월별 수입/지출 집계
    final Map<int, double> monthlyIncome = {};
    final Map<int, double> monthlyExpense = {};
    for (final t in widget.transactions) {
      final m = t.createdAt.month;
      if (_isPositive(t.type)) {
        monthlyIncome[m] = (monthlyIncome[m] ?? 0) + t.amount;
      } else {
        monthlyExpense[m] = (monthlyExpense[m] ?? 0) + t.amount;
      }
    }

    final data = _showIncome ? monthlyIncome : monthlyExpense;
    final color = _showIncome ? Colors.green : colorScheme.error;

    final maxVal = data.values.isEmpty
        ? 100.0
        : data.values.reduce((a, b) => a > b ? a : b);

    final barGroups = List.generate(12, (i) {
      final month = i + 1;
      final value = data[month] ?? 0.0;
      return BarChartGroupData(
        x: month,
        barRods: [
          BarChartRodData(
            toY: value,
            color: value > 0 ? color : colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: 14,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSizes.spaceS, AppSizes.spaceM, AppSizes.spaceM, AppSizes.spaceS),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: AppSizes.spaceS),
                    child: Text('월별 현황',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold)),
                  ),
                  const Spacer(),
                  SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(value: true, label: Text('수입')),
                      ButtonSegment(value: false, label: Text('지출')),
                    ],
                    selected: {_showIncome},
                    onSelectionChanged: (s) =>
                        setState(() => _showIncome = s.first),
                    style: const ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceS),
              SizedBox(
                height: 160,
                child: BarChart(
                  BarChartData(
                    maxY: maxVal * 1.25 + 10,
                    barGroups: barGroups,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: maxVal > 0 ? (maxVal / 3).ceilToDouble() : 10,
                      getDrawingHorizontalLine: (_) => FlLine(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: maxVal > 0 ? (maxVal / 3).ceilToDouble() : 10,
                          getTitlesWidget: (v, _) => Text(
                            '${v.toInt()}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 9,
                                color: colorScheme.onSurfaceVariant),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (v, _) => Text(
                            '${v.toInt()}월',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 9,
                                color: colorScheme.onSurfaceVariant),
                          ),
                        ),
                      ),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (_) => colorScheme.surfaceContainerHighest,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                            BarTooltipItem(
                          '${rod.toY.toInt()}P',
                          TextStyle(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 유형별 도넛 차트 ─────────────────────────────────────────────────────────

class _TypeDonutChart extends StatefulWidget {
  const _TypeDonutChart({required this.transactions});

  final List<ChildcareTransaction> transactions;

  @override
  State<_TypeDonutChart> createState() => _TypeDonutChartState();
}

class _TypeDonutChartState extends State<_TypeDonutChart> {
  bool _showIncome = true;

  static const _typeLabels = {
    ChildcareTransactionType.allowance: '용돈',
    ChildcareTransactionType.reward: '보상',
    ChildcareTransactionType.bonus: '보너스',
    ChildcareTransactionType.interest: '이자',
    ChildcareTransactionType.savingsWithdraw: '적금 출금',
    ChildcareTransactionType.penalty: '벌점',
    ChildcareTransactionType.purchase: '상점',
    ChildcareTransactionType.cashout: '현금화',
    ChildcareTransactionType.savingsDeposit: '적금',
  };

  static const _typeColors = {
    ChildcareTransactionType.allowance: Color(0xFF4CAF50),
    ChildcareTransactionType.reward: Color(0xFF8BC34A),
    ChildcareTransactionType.bonus: Color(0xFF00BCD4),
    ChildcareTransactionType.interest: Color(0xFF009688),
    ChildcareTransactionType.savingsWithdraw: Color(0xFF26A69A),
    ChildcareTransactionType.penalty: Color(0xFFF44336),
    ChildcareTransactionType.purchase: Color(0xFFFF9800),
    ChildcareTransactionType.cashout: Color(0xFFE91E63),
    ChildcareTransactionType.savingsDeposit: Color(0xFF9C27B0),
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // 유형별 합산
    final Map<ChildcareTransactionType, double> byType = {};
    for (final t in widget.transactions) {
      final isInc = _isPositive(t.type);
      if (_showIncome != isInc) continue;
      if (t.type == null) continue;
      byType[t.type!] = (byType[t.type!] ?? 0) + t.amount;
    }

    if (byType.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spaceM),
            child: Center(
              child: Text(
                _showIncome ? '이번 달 수입 내역이 없습니다' : '이번 달 지출 내역이 없습니다',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant),
              ),
            ),
          ),
        ),
      );
    }

    final total = byType.values.fold(0.0, (a, b) => a + b);
    final sections = byType.entries.map((e) {
      final pct = e.value / total * 100;
      final color = _typeColors[e.key] ?? colorScheme.primary;
      return PieChartSectionData(
        value: e.value,
        color: color,
        radius: 40,
        title: pct >= 8 ? '${pct.toStringAsFixed(0)}%' : '',
        titleStyle: const TextStyle(
            fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('유형별 분포',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold)),
                  const Spacer(),
                  SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(value: true, label: Text('수입')),
                      ButtonSegment(value: false, label: Text('지출')),
                    ],
                    selected: {_showIncome},
                    onSelectionChanged: (s) =>
                        setState(() => _showIncome = s.first),
                    style: const ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceS),
              Row(
                children: [
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: PieChart(
                      PieChartData(
                        sections: sections,
                        centerSpaceRadius: 30,
                        sectionsSpace: 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.spaceM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: byType.entries.map((e) {
                        final color =
                            _typeColors[e.key] ?? colorScheme.primary;
                        final label = _typeLabels[e.key] ?? '기타';
                        final pct = e.value / total * 100;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                    color: color, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(label,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              Text(
                                '${e.value.toInt()}P',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 4),
                              SizedBox(
                                width: 32,
                                child: Text(
                                  '${pct.toStringAsFixed(0)}%',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: colorScheme.onSurfaceVariant),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
