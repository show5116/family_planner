import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/investment/data/models/indicator_model.dart';
import 'package:family_planner/features/main/investment/providers/indicator_provider.dart';

class IndicatorDetailScreen extends ConsumerStatefulWidget {
  const IndicatorDetailScreen({super.key, required this.symbol});

  final String symbol;

  @override
  ConsumerState<IndicatorDetailScreen> createState() =>
      _IndicatorDetailScreenState();
}

class _IndicatorDetailScreenState
    extends ConsumerState<IndicatorDetailScreen> {
  int _selectedDays = 30;

  static const _dayOptions = [7, 30, 90, 180, 365];

  @override
  Widget build(BuildContext context) {
    final indicatorsAsync = ref.watch(indicatorsProvider);
    final historyAsync = ref.watch(
      indicatorHistoryProvider(widget.symbol, days: _selectedDays),
    );

    final indicator = indicatorsAsync.valueOrNull?.firstWhere(
      (e) => e.symbol == widget.symbol,
      orElse: () => _emptyIndicator,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(indicator?.nameKo ?? widget.symbol),
        actions: [
          if (indicator != null)
            IconButton(
              icon: Icon(
                indicator.isBookmarked ? Icons.star : Icons.star_border,
                color: indicator.isBookmarked
                    ? AppColors.investment
                    : null,
              ),
              onPressed: () => ref
                  .read(indicatorsProvider.notifier)
                  .toggleBookmark(widget.symbol),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (indicator != null) _PriceSummaryCard(indicator: indicator),
            const SizedBox(height: AppSizes.spaceL),
            _ChartSection(
              historyAsync: historyAsync,
              selectedDays: _selectedDays,
              onDaysChanged: (days) => setState(() => _selectedDays = days),
              dayOptions: _dayOptions,
            ),
          ],
        ),
      ),
    );
  }

  static final _emptyIndicator = IndicatorModel(
    symbol: '',
    name: '',
    nameKo: '',
    unit: '',
    isBookmarked: false,
  );
}

class _PriceSummaryCard extends StatelessWidget {
  const _PriceSummaryCard({required this.indicator});

  final IndicatorModel indicator;

  @override
  Widget build(BuildContext context) {
    final change = indicator.change;
    final changeRate = indicator.changeRate;
    final isPositive = (change ?? 0) >= 0;
    final changeColor = isPositive ? AppColors.success : AppColors.error;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              indicator.symbol,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppSizes.spaceS),
            Text(
              indicator.price != null
                  ? '${_formatNumber(indicator.price!)} ${indicator.unit}'
                  : '-',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppSizes.spaceXS),
            if (change != null && changeRate != null)
              Row(
                children: [
                  Icon(
                    isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 16,
                    color: changeColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    change.abs().toStringAsFixed(2),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: changeColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(width: AppSizes.spaceS),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: changeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    ),
                    child: Text(
                      '${isPositive ? '+' : ''}${changeRate.toStringAsFixed(2)}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: changeColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            if (indicator.prevPrice != null) ...[
              const SizedBox(height: AppSizes.spaceS),
              Text(
                '전일 종가  ${_formatNumber(indicator.prevPrice!)} ${indicator.unit}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
            if (indicator.spread != null) ...[
              const SizedBox(height: AppSizes.spaceS),
              _SpreadBadge(spread: indicator.spread!),
            ],
          ],
        ),
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

class _SpreadBadge extends StatelessWidget {
  const _SpreadBadge({required this.spread});

  final double spread;

  @override
  Widget build(BuildContext context) {
    final isPremium = spread >= 0;
    final color = isPremium ? AppColors.error : AppColors.success;
    final sign = isPremium ? '+' : '';

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          ),
          child: Text(
            '이격률 $sign${spread.toStringAsFixed(2)}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        const SizedBox(width: AppSizes.spaceXS),
        Text(
          isPremium ? '국제 환산가 대비 프리미엄' : '국제 환산가 대비 디스카운트',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

class _ChartSection extends StatelessWidget {
  const _ChartSection({
    required this.historyAsync,
    required this.selectedDays,
    required this.onDaysChanged,
    required this.dayOptions,
  });

  final AsyncValue<IndicatorHistoryModel> historyAsync;
  final int selectedDays;
  final ValueChanged<int> onDaysChanged;
  final List<int> dayOptions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '시세 추이',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const Spacer(),
            ...dayOptions.map(
              (days) => _DayChip(
                label: days >= 365 ? '1년' : '$days일',
                selected: selectedDays == days,
                onTap: () => onDaysChanged(days),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spaceM),
        SizedBox(
          height: 220,
          child: historyAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => const Center(child: Text('차트를 불러올 수 없습니다')),
            data: (history) {
              if (history.history.isEmpty) {
                return const Center(child: Text('데이터가 없습니다'));
              }
              return _LineChart(history: history, selectedDays: selectedDays);
            },
          ),
        ),
      ],
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: AppSizes.spaceXS),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.investment
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: selected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: selected ? FontWeight.bold : null,
              ),
        ),
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  const _LineChart({required this.history, required this.selectedDays});

  final IndicatorHistoryModel history;
  final int selectedDays;

  @override
  Widget build(BuildContext context) {
    final points = history.history;
    final prices = points.map((e) => e.price).toList();
    final minY = prices.reduce((a, b) => a < b ? a : b);
    final maxY = prices.reduce((a, b) => a > b ? a : b);
    final yPadding = (maxY - minY) * 0.1;

    final isPositive = prices.last >= prices.first;
    final lineColor = isPositive ? AppColors.success : AppColors.error;

    // 날짜 기반 X축: 기간 끝(오늘)을 maxX, 기간 시작을 0으로 설정
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: selectedDays - 1));

    final spots = points
        .map((p) {
          final dayOffset =
              p.recordedAt.difference(startDate).inDays.toDouble();
          return FlSpot(dayOffset, p.price);
        })
        .where((s) => s.x >= 0 && s.x <= (selectedDays - 1).toDouble())
        .toList();

    if (spots.isEmpty) {
      return const Center(child: Text('데이터가 없습니다'));
    }

    final maxX = (selectedDays - 1).toDouble();
    // X축 레이블 4개 균등 배치
    final labelInterval = (maxX / 3).ceilToDouble();

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: maxX,
        minY: minY - yPadding,
        maxY: maxY + yPadding,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => FlLine(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 52,
              getTitlesWidget: (value, _) => Text(
                _formatCompact(value),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              interval: labelInterval,
              getTitlesWidget: (value, _) {
                final date = startDate.add(Duration(days: value.toInt()));
                return Text(
                  '${date.month}/${date.day}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: lineColor,
            barWidth: 2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  lineColor.withValues(alpha: 0.2),
                  lineColor.withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final date = startDate.add(Duration(days: spot.x.toInt()));
                return LineTooltipItem(
                  '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}\n${_formatCompact(spot.y)}',
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  String _formatCompact(double value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return value.toStringAsFixed(1);
  }
}
