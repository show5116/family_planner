import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/assets/data/models/asset_trend_model.dart';
import 'package:family_planner/features/main/assets/presentation/widgets/asset_comparison_chart.dart';
import 'package:family_planner/features/main/assets/utils/asset_utils.dart';
import 'package:family_planner/l10n/app_localizations.dart';

enum _TrendViewMode { chart, compare }

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
  _TrendViewMode _viewMode = _TrendViewMode.chart;
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
        // 월별 / 연도별 토글 + 비교 모드 토글
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
            const SizedBox(width: AppSizes.spaceS),
            // 비교 모드 토글
            _CompareToggle(
              active: _viewMode == _TrendViewMode.compare,
              onTap: () => setState(() {
                _viewMode = _viewMode == _TrendViewMode.compare
                    ? _TrendViewMode.chart
                    : _TrendViewMode.compare;
              }),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spaceS),

        // 지표 선택 탭 (비교 모드에서는 숨김)
        if (_viewMode == _TrendViewMode.chart) ...[
          Wrap(
            spacing: AppSizes.spaceXS,
            runSpacing: AppSizes.spaceXS,
            children: [
                _MetricChip(
                  label: l10n.asset_trend_balance,
                  selected: _metric == _ChartMetric.balance,
                  onTap: () => setState(() => _metric = _ChartMetric.balance),
                  tooltipTitle: '잔액',
                  tooltipBody: '각 시점의 총 자산 잔액입니다.\n잔액 = 원금 + 수익금',
                ),
                _MetricChip(
                  label: l10n.asset_trend_principal,
                  selected: _metric == _ChartMetric.principal,
                  onTap: () => setState(() => _metric = _ChartMetric.principal),
                  tooltipTitle: '원금',
                  tooltipBody: '각 시점까지 실제로 입금한 누적 투자 원금입니다.\n수익·손실은 포함되지 않습니다.',
                ),
                _MetricChip(
                  label: l10n.asset_trend_profit,
                  selected: _metric == _ChartMetric.profit,
                  onTap: () => setState(() => _metric = _ChartMetric.profit),
                  tooltipTitle: '수익금',
                  tooltipBody: '각 시점의 누적 수익금입니다.\n수익금 = 잔액 − 원금',
                ),
                _MetricChip(
                  label: l10n.asset_trend_profit_rate,
                  selected: _metric == _ChartMetric.profitRate,
                  onTap: () => setState(() => _metric = _ChartMetric.profitRate),
                  tooltipTitle: '누적 수익률',
                  tooltipBody: '각 시점의 누적 수익률입니다.\n누적 수익률 = 수익금 ÷ 원금 × 100',
                ),
                _MetricChip(
                  label: l10n.asset_trend_period_return,
                  selected: _metric == _ChartMetric.periodReturn,
                  onTap: () => setState(() => _metric = _ChartMetric.periodReturn),
                  tooltipTitle: '기간 수익률',
                  tooltipBody: '직전 시점 대비 해당 기간의 수익률입니다.\n원금 입·출금의 영향을 제거하고 순수한 수익 변화만 반영합니다.\n\n기간 수익률 = (이번 수익금 − 전 수익금) ÷ 전 원금 × 100',
                ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceM),
        ],

        // 차트
        trendAsync.when(
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
            if (_viewMode == _TrendViewMode.compare) {
              return AssetComparisonChart(
                assetPoints: points,
                period: _period,
              );
            }
            return SizedBox(
              height: 220,
              child: _TrendLineChart(
                points: points,
                metric: _metric,
                period: _period,
              ),
            );
          },
          loading: () => const SizedBox(
            height: 220,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, s) => SizedBox(
            height: 220,
            child: Center(
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

class _CompareToggle extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;

  const _CompareToggle({required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceS, vertical: 6),
        decoration: BoxDecoration(
          color: active
              ? colorScheme.secondaryContainer
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          border: Border.all(
            color: active
                ? colorScheme.secondary.withValues(alpha: 0.5)
                : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.compare_arrows,
              size: 14,
              color: active ? colorScheme.secondary : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              l10n.asset_compare_button,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: active ? colorScheme.secondary : colorScheme.onSurfaceVariant,
                    fontWeight: active ? FontWeight.bold : FontWeight.normal,
                  ),
            ),
          ],
        ),
      ),
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
  final String tooltipTitle;
  final String tooltipBody;

  const _MetricChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.tooltipTitle,
    required this.tooltipBody,
  });

  void _showInfo(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(tooltipTitle),
        content: Text(tooltipBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final labelColor = selected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: AppSizes.spaceS, right: 4, top: 4, bottom: 4),
        decoration: BoxDecoration(
          color: selected ? colorScheme.primary : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: labelColor,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  ),
            ),
            const SizedBox(width: 2),
            GestureDetector(
              onTap: () => _showInfo(context),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Icon(
                  Icons.info_outline,
                  size: 13,
                  color: labelColor.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
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
  // 드래그 비교: 처음 누른 인덱스(고정) / 현재 드래그 인덱스(이동)
  int? _anchorIdx;
  int? _dragIdx;
  final _chartKey = GlobalKey();

  // 픽셀 x 좌표 → 데이터 인덱스 변환
  // fl_chart는 좌측 axis 영역(reservedSize=56)을 제외한 나머지가 실제 차트 영역
  static const double _leftReserved = 56.0;

  int _xToIndex(double localX) {
    final box = _chartKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return 0;
    final chartWidth = box.size.width - _leftReserved;
    final n = widget.points.length;
    if (n <= 1) return 0;
    final ratio = ((localX - _leftReserved) / chartWidth).clamp(0.0, 1.0);
    return (ratio * (n - 1)).round().clamp(0, n - 1);
  }

  /// 기간별 수익률: (이번 수익금 - 전 수익금) / 전 원금 × 100
  /// 잔액 대신 profit 변화를 principal로 나눠 원금 입금의 영향을 제거한다.
  List<double> _periodReturns(List<AssetTrendPoint> pts) {
    return List.generate(pts.length, (i) {
      if (i == 0) return 0;
      final prevPrincipal = pts[i - 1].principal;
      if (prevPrincipal == 0) return 0;
      return (pts[i].profit - pts[i - 1].profit) / prevPrincipal * 100;
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

    final double yPadding;
    if (range < 1e-9) {
      yPadding = maxY.abs() * 0.1 + 1;
    } else if (_isPercent) {
      yPadding = range * 0.3;
    } else {
      final minBased = minY.abs() * 0.05;
      yPadding = (range * 0.2).clamp(minBased, double.infinity);
    }
    final chartMinY = minY - yPadding;
    final chartMaxY = maxY + yPadding;

    // 앵커(드래그 시작) 보조선
    final extraLines = <VerticalLine>[];
    if (_anchorIdx != null && _dragIdx != null && _anchorIdx != _dragIdx) {
      extraLines.add(VerticalLine(
        x: _anchorIdx!.toDouble(),
        color: colorScheme.tertiary.withValues(alpha: 0.6),
        strokeWidth: 1.5,
        dashArray: [4, 4],
      ));
    }

    // handleBuiltInTouches: false 일 때 툴팁을 강제 표시하려면
    // showingTooltipIndicators + LineChartBarData.showingIndicators 둘 다 필요
    final barData = LineChartBarData(
      spots: spots,
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
      showingIndicators: _dragIdx != null ? [_dragIdx!] : [],
    );

    final showingTooltips = _dragIdx != null
        ? [ShowingTooltipIndicators([LineBarSpot(barData, 0, spots[_dragIdx!])])]
        : <ShowingTooltipIndicators>[];

    final chart = LineChart(
      LineChartData(
        minY: chartMinY,
        maxY: chartMaxY,
        clipData: const FlClipData.all(),
        extraLinesData: ExtraLinesData(verticalLines: extraLines),
        showingTooltipIndicators: showingTooltips,
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
              reservedSize: 52,
              getTitlesWidget: (value, meta) {
                if (value == meta.min || value == meta.max) {
                  return const SizedBox.shrink();
                }
                final label = _isPercent
                    ? '${value.toStringAsFixed(1)}%'
                    : (formatAssetAmountKorean(value) ?? '${formatAssetAmount(value)}원');
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
                    ? '${int.parse(p.substring(5))}월'
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
        lineBarsData: [barData],
        lineTouchData: LineTouchData(
          handleBuiltInTouches: false,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => colorScheme.surfaceContainerHigh,
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipItems: (touchedSpots) => touchedSpots.map((s) {
              final idx = s.x.toInt();
              if (idx < 0 || idx >= pts.length) return null;
              final p = pts[idx];
              final val = _valueAt(idx);

              if (_anchorIdx != null && _dragIdx != null && _anchorIdx != _dragIdx) {
                final anchorVal = _valueAt(_anchorIdx!);
                final diff = val - anchorVal;
                final sign = diff >= 0 ? '+' : '';
                final diffStr = _isPercent
                    ? '$sign${diff.toStringAsFixed(2)}%'
                    : '$sign${formatAssetAmount(diff)}원';
                final diffColor = diff >= 0 ? Colors.green : Colors.red;
                return LineTooltipItem(
                  '${p.period}\n${_formatValue(val)}\n',
                  Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                  children: [
                    TextSpan(
                      text: diffStr,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: diffColor,
                            fontWeight: FontWeight.bold,
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

    return GestureDetector(
      key: _chartKey,
      onPanStart: (d) {
        setState(() {
          _anchorIdx = _xToIndex(d.localPosition.dx);
          _dragIdx = _anchorIdx;
        });
      },
      onPanUpdate: (d) {
        setState(() {
          _dragIdx = _xToIndex(d.localPosition.dx);
        });
      },
      onTapDown: (d) {
        final idx = _xToIndex(d.localPosition.dx);
        setState(() {
          // 같은 지점 탭 시 토글 해제, 다른 지점이면 새로 선택
          if (_dragIdx == idx && _anchorIdx == idx) {
            _anchorIdx = null;
            _dragIdx = null;
          } else {
            _anchorIdx = idx;
            _dragIdx = idx;
          }
        });
      },
      child: chart,
    );
  }

  double _bottomInterval(int count) {
    if (count <= 6) return 1;
    if (count <= 12) return 2;
    return (count / 6).ceilToDouble();
  }
}
