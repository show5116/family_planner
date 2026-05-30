import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/assets/data/models/asset_trend_model.dart';
import 'package:family_planner/features/main/investment/data/models/indicator_model.dart';
import 'package:family_planner/features/main/investment/providers/indicator_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

// ─────────────────────────────────────────────
// 비교 대상 정의
// ─────────────────────────────────────────────

class _CompareTarget {
  final String symbol;
  final String labelKey; // l10n 키
  final Color color;
  final bool isDollar; // 달러 환산 라인

  const _CompareTarget({
    required this.symbol,
    required this.labelKey,
    required this.color,
    this.isDollar = false,
  });
}

const _targets = [
  _CompareTarget(symbol: 'KS11',   labelKey: 'KOSPI',   color: Color(0xFF3B82F6)),
  _CompareTarget(symbol: 'SPX',    labelKey: 'S&P500',  color: Color(0xFF22C55E)),
  _CompareTarget(symbol: 'NQ100',  labelKey: 'NASDAQ',  color: Color(0xFFF59E0B)),
  _CompareTarget(symbol: 'USDKRW', labelKey: 'USD환산', color: Color(0xFFEF4444), isDollar: true),
];

// ─────────────────────────────────────────────
// 내 자산 라인 색상
// ─────────────────────────────────────────────
const _myAssetColor = Color(0xFF6366F1);

// ─────────────────────────────────────────────
// 날짜 정규화 헬퍼
// ─────────────────────────────────────────────

/// 지표 히스토리를 월별(YYYY-MM) 또는 연도별(YYYY) 맵으로 집계
/// 각 기간의 마지막 값을 사용
Map<String, double> _aggregateIndicator(
  List<IndicatorPricePoint> points,
  TrendPeriod period,
) {
  final map = <String, double>{};
  for (final p in points) {
    final key = period == TrendPeriod.monthly
        ? '${p.recordedAt.year}-${p.recordedAt.month.toString().padLeft(2, '0')}'
        : '${p.recordedAt.year}';
    map[key] = p.price; // 후속 값이 덮어씌움 → 기간의 마지막 값
  }
  return map;
}

// ─────────────────────────────────────────────
// 정규화: 기준점(첫 공통 기간) = 100
// ─────────────────────────────────────────────
List<double?> _normalize(List<String> periods, Map<String, double> data) {
  // 첫 번째 유효값을 기준(100)으로
  double? base;
  final result = <double?>[];
  for (final p in periods) {
    final v = data[p];
    if (v == null) {
      result.add(null);
      continue;
    }
    base ??= v;
    result.add(base == 0 ? null : v / base * 100);
  }
  return result;
}

// ─────────────────────────────────────────────
// 메인 위젯
// ─────────────────────────────────────────────

class AssetComparisonChart extends ConsumerStatefulWidget {
  final List<AssetTrendPoint> assetPoints;
  final TrendPeriod period;

  const AssetComparisonChart({
    super.key,
    required this.assetPoints,
    required this.period,
  });

  @override
  ConsumerState<AssetComparisonChart> createState() =>
      _AssetComparisonChartState();
}

class _AssetComparisonChartState extends ConsumerState<AssetComparisonChart> {
  final Set<int> _enabledTargets = {0, 1}; // KS11, SPX 기본 활성화
  int? _touchedPeriodIdx;

  int get _days => widget.period == TrendPeriod.monthly ? 365 : 1825;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (widget.assetPoints.isEmpty) {
      return Center(
        child: Text(
          l10n.asset_trend_no_data,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
      );
    }

    // 지표 히스토리 로드 (활성화된 것만)
    final histories = <int, AsyncValue<IndicatorHistoryModel>>{};
    for (final i in _enabledTargets) {
      histories[i] = ref.watch(
        indicatorHistoryProvider(_targets[i].symbol, days: _days),
      );
    }

    final isLoading = histories.values.any((v) => v.isLoading);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 비교 대상 선택 칩
        _buildTargetChips(l10n),
        const SizedBox(height: AppSizes.spaceM),

        // 차트
        SizedBox(
          height: 240,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildChart(context, histories),
        ),

        const SizedBox(height: AppSizes.spaceS),
        // 범례
        _buildLegend(context),
      ],
    );
  }

  Widget _buildTargetChips(AppLocalizations l10n) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_targets.length, (i) {
          final t = _targets[i];
          final enabled = _enabledTargets.contains(i);
          return Padding(
            padding: const EdgeInsets.only(right: AppSizes.spaceXS),
            child: GestureDetector(
              onTap: () => setState(() {
                if (enabled) {
                  _enabledTargets.remove(i);
                } else {
                  _enabledTargets.add(i);
                }
                _touchedPeriodIdx = null;
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceS,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: enabled
                      ? t.color.withValues(alpha: 0.15)
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  border: Border.all(
                    color: enabled
                        ? t.color.withValues(alpha: 0.6)
                        : Colors.transparent,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: enabled ? t.color : Theme.of(context).colorScheme.outline,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      t.isDollar ? l10n.asset_compare_usd_label : t.labelKey,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: enabled
                                ? t.color
                                : Theme.of(context).colorScheme.outline,
                            fontWeight: enabled
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildChart(
    BuildContext context,
    Map<int, AsyncValue<IndicatorHistoryModel>> histories,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final periods = widget.assetPoints.map((p) => p.period).toList();

    // 내 자산 기준(원화) 맵
    final myAssetMap = {
      for (final p in widget.assetPoints) p.period: p.balance,
    };
    final myNorm = _normalize(periods, myAssetMap);

    // 각 지표의 정규화 데이터
    final normData = <int, List<double?>>{};

    for (final entry in histories.entries) {
      final i = entry.key;
      final v = entry.value;
      if (!v.hasValue) continue;
      final hist = v.value!;
      final aggr = _aggregateIndicator(hist.history, widget.period);

      if (_targets[i].isDollar) {
        // USD환산: 달러 환율로 내 자산(원화) ÷ 환율 → 달러 금액 추이
        final dollarAssetMap = <String, double>{};
        for (final p in periods) {
          final balance = myAssetMap[p];
          final rate = aggr[p];
          if (balance != null && rate != null && rate > 0) {
            dollarAssetMap[p] = balance / rate;
          }
        }
        normData[i] = _normalize(periods, dollarAssetMap);
      } else {
        normData[i] = _normalize(periods, aggr);
      }
    }

    // 전체 Y 범위 계산
    final allValues = <double>[...myNorm.whereType<double>()];
    for (final nd in normData.values) {
      allValues.addAll(nd.whereType<double>());
    }
    if (allValues.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.asset_trend_no_data,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }
    final minVal = allValues.reduce((a, b) => a < b ? a : b);
    final maxVal = allValues.reduce((a, b) => a > b ? a : b);
    final range = maxVal - minVal;
    final pad = range < 1e-6 ? 5.0 : range * 0.15;

    // ── 라인 데이터 빌드 ──────────────────────────────
    LineChartBarData buildLine(
      List<double?> normValues,
      Color color, {
      bool thick = false,
    }) {
      final spots = <FlSpot>[];
      for (var idx = 0; idx < normValues.length; idx++) {
        final v = normValues[idx];
        if (v != null) spots.add(FlSpot(idx.toDouble(), v));
      }
      return LineChartBarData(
        spots: spots,
        isCurved: false,
        color: color,
        barWidth: thick ? 2.5 : 1.5,
        dotData: const FlDotData(show: false),
        dashArray: thick ? null : [4, 3],
        showingIndicators: _touchedPeriodIdx != null
            ? spots
                .where((s) => s.x.toInt() == _touchedPeriodIdx)
                .map((s) => spots.indexOf(s))
                .toList()
            : [],
      );
    }

    final lineBars = <LineChartBarData>[
      buildLine(myNorm, _myAssetColor, thick: true),
      for (final entry in normData.entries)
        buildLine(normData[entry.key]!, _targets[entry.key].color),
    ];

    // 터치 시 툴팁
    final showingTooltips = <ShowingTooltipIndicators>[];
    if (_touchedPeriodIdx != null) {
      for (var barIdx = 0; barIdx < lineBars.length; barIdx++) {
        final bar = lineBars[barIdx];
        for (var spotIdx = 0; spotIdx < bar.spots.length; spotIdx++) {
          if (bar.spots[spotIdx].x.toInt() == _touchedPeriodIdx) {
            showingTooltips.add(ShowingTooltipIndicators(
              [LineBarSpot(bar, barIdx, bar.spots[spotIdx])],
            ));
          }
        }
      }
    }

    return GestureDetector(
      onTapDown: (d) {
        final idx = _xToIndex(d.localPosition.dx, periods.length);
        setState(() {
          _touchedPeriodIdx = (_touchedPeriodIdx == idx) ? null : idx;
        });
      },
      onPanUpdate: (d) {
        setState(() {
          _touchedPeriodIdx = _xToIndex(d.localPosition.dx, periods.length);
        });
      },
      child: LineChart(
        LineChartData(
          minY: minVal - pad,
          maxY: maxVal + pad,
          clipData: const FlClipData.all(),
          showingTooltipIndicators: showingTooltips,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(
              color: colorScheme.outlineVariant.withValues(alpha: 0.4),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: 100,
                color: colorScheme.outline.withValues(alpha: 0.4),
                strokeWidth: 1,
                dashArray: [6, 4],
              ),
            ],
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
                getTitlesWidget: (v, meta) {
                  if (v == meta.min || v == meta.max) return const SizedBox.shrink();
                  return Text(
                    v.toStringAsFixed(0),
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
                interval: _bottomInterval(periods.length),
                getTitlesWidget: (v, meta) {
                  final idx = v.toInt();
                  if (idx < 0 || idx >= periods.length) {
                    return const SizedBox.shrink();
                  }
                  final label = widget.period == TrendPeriod.monthly
                      ? periods[idx].substring(5) // MM
                      : periods[idx]; // YYYY
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
          lineBarsData: lineBars,
          lineTouchData: LineTouchData(
            handleBuiltInTouches: false,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => colorScheme.surfaceContainerHigh,
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipItems: (spots) {
                return spots.map((s) {
                  final val = s.y;
                  final diff = val - 100;
                  final sign = diff >= 0 ? '+' : '';
                  final diffColor = diff >= 0 ? Colors.green : Colors.red;

                  String label;
                  if (s.barIndex == 0) {
                    label = AppLocalizations.of(context)!.asset_compare_my_asset;
                  } else {
                    final targetIdx = _enabledTargets.elementAt(s.barIndex - 1);
                    final t = _targets[targetIdx];
                    label = t.isDollar
                        ? AppLocalizations.of(context)!.asset_compare_usd_label
                        : t.labelKey;
                  }

                  return LineTooltipItem(
                    '$label\n',
                    Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                    children: [
                      TextSpan(
                        text: '$sign${diff.toStringAsFixed(1)}%',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: diffColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Wrap(
      spacing: AppSizes.spaceM,
      runSpacing: AppSizes.spaceXS,
      children: [
        _LegendItem(
          color: _myAssetColor,
          label: AppLocalizations.of(context)!.asset_compare_my_asset,
          thick: true,
        ),
        for (final i in _enabledTargets)
          _LegendItem(
            color: _targets[i].color,
            label: _targets[i].isDollar
                ? AppLocalizations.of(context)!.asset_compare_usd_label
                : _targets[i].labelKey,
            dashed: true,
          ),
      ],
    );
  }

  int _xToIndex(double localX, int count) {
    // 차트 영역 좌측 reserved size = 44
    const leftReserved = 44.0;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return 0;
    final chartWidth = box.size.width - leftReserved;
    if (count <= 1) return 0;
    final ratio = ((localX - leftReserved) / chartWidth).clamp(0.0, 1.0);
    return (ratio * (count - 1)).round().clamp(0, count - 1);
  }

  double _bottomInterval(int count) {
    if (count <= 6) return 1;
    if (count <= 12) return 2;
    return (count / 6).ceilToDouble();
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool thick;
  final bool dashed;

  const _LegendItem({
    required this.color,
    required this.label,
    this.thick = false,
    this.dashed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 20,
          height: 2,
          child: CustomPaint(
            painter: _LinePainter(color: color, dashed: dashed, thick: thick),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
        ),
      ],
    );
  }
}

class _LinePainter extends CustomPainter {
  final Color color;
  final bool dashed;
  final bool thick;

  const _LinePainter({required this.color, required this.dashed, required this.thick});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thick ? 2.5 : 1.5
      ..style = PaintingStyle.stroke;

    if (dashed) {
      double x = 0;
      while (x < size.width) {
        canvas.drawLine(Offset(x, size.height / 2), Offset((x + 4).clamp(0, size.width), size.height / 2), paint);
        x += 7;
      }
    } else {
      canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
    }
  }

  @override
  bool shouldRepaint(_LinePainter old) => false;
}
