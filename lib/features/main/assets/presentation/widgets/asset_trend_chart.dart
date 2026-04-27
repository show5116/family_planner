import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/assets/data/models/asset_trend_model.dart';
import 'package:family_planner/features/main/assets/utils/asset_utils.dart';
import 'package:family_planner/l10n/app_localizations.dart';

class AssetTrendChart extends ConsumerStatefulWidget {
  final AsyncValue<List<AssetTrendPoint>> Function(TrendPeriod, String?) trendBuilder;

  const AssetTrendChart({super.key, required this.trendBuilder});

  @override
  ConsumerState<AssetTrendChart> createState() => _AssetTrendChartState();
}

enum _ChartMetric { balance, principal, profit, profitRate, periodReturn }

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

        // 지표 선택 탭
        Wrap(
          spacing: AppSizes.spaceXS,
          runSpacing: AppSizes.spaceXS,
          children: [
            _MetricChip(
              label: l10n.asset_trend_balance,
              selected: _metric == _ChartMetric.balance,
              onTap: () => setState(() => _metric = _ChartMetric.balance),
            ),
            _MetricChip(
              label: l10n.asset_trend_principal,
              selected: _metric == _ChartMetric.principal,
              onTap: () => setState(() => _metric = _ChartMetric.principal),
            ),
            _MetricChip(
              label: l10n.asset_trend_profit,
              selected: _metric == _ChartMetric.profit,
              onTap: () => setState(() => _metric = _ChartMetric.profit),
            ),
            _MetricChip(
              label: l10n.asset_trend_profit_rate,
              selected: _metric == _ChartMetric.profitRate,
              onTap: () => setState(() => _metric = _ChartMetric.profitRate),
            ),
            _MetricChip(
              label: l10n.asset_trend_period_return,
              selected: _metric == _ChartMetric.periodReturn,
              onTap: () => setState(() => _metric = _ChartMetric.periodReturn),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spaceM),

        // 차트
        SizedBox(
          height: 220,
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
      items: years.map((y) => DropdownMenuItem(value: y, child: Text(y))).toList(),
      onChanged: (v) { if (v != null) onChanged(v); },
    );
  }
}

class _MetricChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _MetricChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceS, vertical: 4),
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

class _TrendLineChart extends StatefulWidget {
  final List<AssetTrendPoint> points;
  final _ChartMetric metric;
  final TrendPeriod period;

  const _TrendLineChart({
    required this.points,
    required this.metric,
    required this.period,
  });

  @override
  State<_TrendLineChart> createState() => _TrendLineChartState();
}

class _TrendLineChartState extends State<_TrendLineChart> {
  // 드래그 비교: 첫 번째로 터치한 인덱스 고정, 두 번째는 이동 중인 인덱스
  int? _anchorIdx;
  int? _dragIdx;

  /// 기간별 수익률: (이번 잔액 - 전 잔액) / 전 잔액 × 100
  List<double> _periodReturns(List<AssetTrendPoint> pts) {
    return List.generate(pts.length, (i) {
      if (i == 0) return 0;
      final prev = pts[i - 1].balance;
      if (prev == 0) return 0;
      return (pts[i].balance - prev) / prev * 100;
    });
  }

  double _valueAt(int i) {
    final p = widget.points[i];
    if (widget.metric == _ChartMetric.periodReturn) {
      return _periodReturns(widget.points)[i];
    }
    return switch (widget.metric) {
      _ChartMetric.balance => p.balance,
      _ChartMetric.principal => p.principal,
      _ChartMetric.profit => p.profit,
      _ChartMetric.profitRate => p.profitRate,
      _ChartMetric.periodReturn => 0,
    };
  }

  bool get _isPercent =>
      widget.metric == _ChartMetric.profitRate ||
      widget.metric == _ChartMetric.periodReturn;

  String _formatValue(double v) {
    if (_isPercent) return '${v.toStringAsFixed(2)}%';
    return '₩${formatAssetAmount(v)}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final pts = widget.points;

    final rawValues = List.generate(pts.length, _valueAt);
    final spots = rawValues.asMap().entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();

    final minY = rawValues.reduce((a, b) => a < b ? a : b);
    final maxY = rawValues.reduce((a, b) => a > b ? a : b);
    final range = maxY - minY;

    // 1번 수정: 변동폭이 작을 때 Y축 범위를 최솟값 기준 비율로 확보
    final double yPadding;
    if (range < 1e-9) {
      // 값이 모두 같은 경우
      yPadding = maxY.abs() * 0.1 + 1;
    } else if (_isPercent) {
      yPadding = range * 0.3;
    } else {
      // 변동폭이 최솟값의 5% 미만이면 최솟값 기준 5%를 padding으로 사용
      final minBased = minY.abs() * 0.05;
      yPadding = (range * 0.2).clamp(minBased, double.infinity);
    }
    final chartMinY = minY - yPadding;
    final chartMaxY = maxY + yPadding;

    // 드래그 중 보조선 (anchorIdx)
    final extraLines = <VerticalLine>[];
    if (_anchorIdx != null && _dragIdx != null && _anchorIdx != _dragIdx) {
      extraLines.add(VerticalLine(
        x: _anchorIdx!.toDouble(),
        color: colorScheme.tertiary.withValues(alpha: 0.6),
        strokeWidth: 1.5,
        dashArray: [4, 4],
      ));
    }

    return LineChart(
      LineChartData(
        minY: chartMinY,
        maxY: chartMaxY,
        clipData: const FlClipData.all(),
        extraLinesData: ExtraLinesData(verticalLines: extraLines),
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
                final label = _isPercent
                    ? '${value.toStringAsFixed(1)}%'
                    : '${formatAssetAmount(value)}원';
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
              interval: _bottomInterval(pts.length),
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= pts.length) return const SizedBox.shrink();
                final p = pts[idx].period;
                final label = widget.period == TrendPeriod.monthly
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
            // 2번 수정: 직선 연결
            isCurved: false,
            color: colorScheme.primary,
            barWidth: 2.5,
            dotData: FlDotData(
              show: pts.length <= 12,
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
        // 3번 수정: 드래그로 두 점 비교
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchCallback: (event, response) {
            final idx = response?.lineBarSpots?.first.x.toInt();
            setState(() {
              if (event is FlTapDownEvent || event is FlPanStartEvent) {
                _anchorIdx = idx;
                _dragIdx = idx;
              } else if (event is FlPanUpdateEvent || event is FlPanCancelEvent) {
                _dragIdx = idx;
              } else if (event is FlTapUpEvent || event is FlPanEndEvent) {
                // 터치 끝나면 초기화
                _anchorIdx = null;
                _dragIdx = null;
              }
            });
          },
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => colorScheme.surfaceContainerHigh,
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipItems: (touchedSpots) => touchedSpots.map((s) {
              final idx = s.x.toInt();
              final p = pts[idx];
              final val = _valueAt(idx);

              // 드래그 비교 모드
              if (_anchorIdx != null && _dragIdx != null &&
                  _anchorIdx != _dragIdx && idx == _dragIdx) {
                final anchorVal = _valueAt(_anchorIdx!);
                final diff = val - anchorVal;
                final sign = diff >= 0 ? '+' : '';
                final diffStr = _isPercent
                    ? '$sign${diff.toStringAsFixed(2)}%'
                    : '$sign${formatAssetAmount(diff)}원';
                return LineTooltipItem(
                  '${p.period}\n${_formatValue(val)}\n$diffStr',
                  Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                  children: [
                    TextSpan(
                      text: '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: diff >= 0 ? Colors.green : Colors.red,
                          ),
                    ),
                  ],
                );
              }

              return LineTooltipItem(
                '${p.period}\n${_formatValue(val)}',
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
