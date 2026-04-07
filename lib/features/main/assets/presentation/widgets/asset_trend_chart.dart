import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/assets/data/models/asset_trend_model.dart';
import 'package:family_planner/features/main/assets/utils/asset_utils.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 자산 추이 차트 위젯
/// [trendAsync] - 외부에서 Provider를 watch한 결과를 주입
class AssetTrendChart extends ConsumerStatefulWidget {
  final AsyncValue<List<AssetTrendPoint>> Function(TrendPeriod, String?) trendBuilder;

  const AssetTrendChart({super.key, required this.trendBuilder});

  @override
  ConsumerState<AssetTrendChart> createState() => _AssetTrendChartState();
}

enum _ChartMetric { balance, profitRate }

class _AssetTrendChartState extends ConsumerState<AssetTrendChart> {
  TrendPeriod _period = TrendPeriod.monthly;
  _ChartMetric _metric = _ChartMetric.balance;
  late String _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = DateTime.now().year.toString();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final year = _period == TrendPeriod.monthly ? _selectedYear : null;
    final trendAsync = widget.trendBuilder(_period, year);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 월별 / 연도별 토글
        Row(
          children: [
            Expanded(
              child: SegmentedButton<TrendPeriod>(
                segments: [
                  ButtonSegment(
                    value: TrendPeriod.monthly,
                    label: Text(l10n.asset_trend_monthly),
                  ),
                  ButtonSegment(
                    value: TrendPeriod.yearly,
                    label: Text(l10n.asset_trend_yearly),
                  ),
                ],
                selected: {_period},
                onSelectionChanged: (s) => setState(() => _period = s.first),
              ),
            ),
            if (_period == TrendPeriod.monthly) ...[
              const SizedBox(width: AppSizes.spaceS),
              _YearPicker(
                selectedYear: _selectedYear,
                onChanged: (y) => setState(() => _selectedYear = y),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSizes.spaceS),

        // 잔액 / 수익률 탭
        Row(
          children: [
            _MetricChip(
              label: l10n.asset_trend_balance,
              selected: _metric == _ChartMetric.balance,
              onTap: () => setState(() => _metric = _ChartMetric.balance),
            ),
            const SizedBox(width: AppSizes.spaceXS),
            _MetricChip(
              label: l10n.asset_trend_profit_rate,
              selected: _metric == _ChartMetric.profitRate,
              onTap: () => setState(() => _metric = _ChartMetric.profitRate),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spaceM),

        // 차트
        SizedBox(
          height: 200,
          child: trendAsync.when(
            data: (points) {
              if (points.isEmpty) {
                return Center(
                  child: Text(
                    l10n.asset_trend_no_data,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                );
              }
              return _TrendLineChart(
                points: points,
                metric: _metric,
                period: _period,
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(
              child: Text(
                l10n.common_error,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _YearPicker extends StatelessWidget {
  final String selectedYear;
  final ValueChanged<String> onChanged;

  const _YearPicker({required this.selectedYear, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    final years = List.generate(5, (i) => (currentYear - i).toString());

    return DropdownButton<String>(
      value: selectedYear,
      underline: const SizedBox(),
      isDense: true,
      items: years
          .map((y) => DropdownMenuItem(value: y, child: Text(y)))
          .toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}

class _MetricChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _MetricChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceS,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: selected ? colorScheme.primary : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: selected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
        ),
      ),
    );
  }
}

class _TrendLineChart extends StatelessWidget {
  final List<AssetTrendPoint> points;
  final _ChartMetric metric;
  final TrendPeriod period;

  const _TrendLineChart({
    required this.points,
    required this.metric,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isBalance = metric == _ChartMetric.balance;

    final spots = points.asMap().entries.map((e) {
      final value = isBalance ? e.value.balance : e.value.profitRate;
      return FlSpot(e.key.toDouble(), value);
    }).toList();

    final values = spots.map((s) => s.y).toList();
    final minY = values.reduce((a, b) => a < b ? a : b);
    final maxY = values.reduce((a, b) => a > b ? a : b);
    final padding = (maxY - minY) * 0.15;
    final chartMinY = (minY - padding).floorToDouble();
    final chartMaxY = (maxY + padding).ceilToDouble();

    return LineChart(
      LineChartData(
        minY: chartMinY,
        maxY: chartMaxY == chartMinY ? chartMinY + 1 : chartMaxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => FlLine(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 56,
              getTitlesWidget: (value, meta) {
                if (value == meta.min || value == meta.max) {
                  return const SizedBox.shrink();
                }
                final label = isBalance
                    ? '${formatAssetAmount(value)}원'
                    : '${value.toStringAsFixed(1)}%';
                return Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.outline,
                        fontSize: 9,
                      ),
                  textAlign: TextAlign.right,
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              interval: _bottomInterval(points.length),
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= points.length) return const SizedBox.shrink();
                final p = points[idx].period;
                final label = period == TrendPeriod.monthly
                    ? p.substring(5) // MM
                    : p; // YYYY
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.outline,
                          fontSize: 10,
                        ),
                  ),
                );
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.3,
            color: colorScheme.primary,
            barWidth: 2.5,
            dotData: FlDotData(
              show: points.length <= 12,
              getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                radius: 3,
                color: colorScheme.primary,
                strokeWidth: 1.5,
                strokeColor: colorScheme.surface,
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
            getTooltipColor: (_) => colorScheme.surfaceContainerHigh,
            getTooltipItems: (spots) => spots.map((s) {
              final idx = s.x.toInt();
              final p = points[idx];
              final label = isBalance
                  ? '₩${formatAssetAmount(p.balance)}'
                  : '${p.profitRate.toStringAsFixed(2)}%';
              return LineTooltipItem(
                '${p.period}\n$label',
                Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  double _bottomInterval(int count) {
    if (count <= 6) return 1;
    if (count <= 12) return 2;
    return (count / 6).ceilToDouble();
  }
}
