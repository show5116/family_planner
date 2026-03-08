import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/utils/format_utils.dart';
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

  static const _dayOptions = [1, 7, 30, 90, 180, 365];

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
            // GOLD_KRW_SPOT 전용: 이격률 차트
            historyAsync.maybeWhen(
              data: (history) => history.spreadHistory.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSizes.spaceL),
                        _SpreadChartSection(
                          history: history,
                          selectedDays: _selectedDays,
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              orElse: () => const SizedBox.shrink(),
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
                    formatIndicatorChange(change),
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

  String _formatNumber(double value) => formatIndicatorPrice(value);
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

class _ChartSection extends StatefulWidget {
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
  State<_ChartSection> createState() => _ChartSectionState();
}

class _ChartSectionState extends State<_ChartSection> {
  // 드래그 범위 선택 (날짜 오프셋)
  double? _dragStartX;
  double? _dragEndX;

  void _onRangeChanged(double? startX, double? endX) {
    setState(() {
      _dragStartX = startX;
      _dragEndX = endX;
    });
  }

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
            ...widget.dayOptions.map(
              (days) => _DayChip(
                label: days >= 365 ? '1년' : '$days일',
                selected: widget.selectedDays == days,
                onTap: () {
                  _onRangeChanged(null, null);
                  widget.onDaysChanged(days);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spaceM),
        widget.historyAsync.maybeWhen(
          data: (history) {
            if (history.history.isEmpty) return const SizedBox.shrink();
            final lastDate = history.history
                .map((p) => p.recordedAt)
                .reduce((a, b) => a.isAfter(b) ? a : b);
            final today = DateTime.now();
            final lastDateOnly =
                DateTime(lastDate.year, lastDate.month, lastDate.day);
            final todayOnly =
                DateTime(today.year, today.month, today.day);
            final daysDiff = todayOnly.difference(lastDateOnly).inDays;
            if (daysDiff >= 1) {
              return _MarketClosedBadge(lastDate: lastDateOnly);
            }
            return const SizedBox.shrink();
          },
          orElse: () => const SizedBox.shrink(),
        ),
        const SizedBox(height: AppSizes.spaceS),
        SizedBox(
          height: 220,
          child: widget.historyAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => const Center(child: Text('차트를 불러올 수 없습니다')),
            data: (history) {
              if (history.history.isEmpty) {
                return const Center(child: Text('데이터가 없습니다'));
              }
              return _LineChart(
                history: history,
                selectedDays: widget.selectedDays,
                dragStartX: _dragStartX,
                dragEndX: _dragEndX,
                onRangeChanged: _onRangeChanged,
              );
            },
          ),
        ),
        // 드래그 범위 등락률 표시
        widget.historyAsync.maybeWhen(
          data: (history) {
            if (_dragStartX == null || _dragEndX == null) {
              return const SizedBox(height: AppSizes.spaceM);
            }
            return _RangeSummaryBar(
              history: history,
              selectedDays: widget.selectedDays,
              dragStartX: _dragStartX!,
              dragEndX: _dragEndX!,
            );
          },
          orElse: () => const SizedBox(height: AppSizes.spaceM),
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

class _LineChart extends StatefulWidget {
  const _LineChart({
    required this.history,
    required this.selectedDays,
    required this.dragStartX,
    required this.dragEndX,
    required this.onRangeChanged,
  });

  final IndicatorHistoryModel history;
  final int selectedDays;
  final double? dragStartX;
  final double? dragEndX;
  final void Function(double? startX, double? endX) onRangeChanged;

  @override
  State<_LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<_LineChart> {
  // fl_chart가 터치를 처리하므로 여기서는 드래그 시작 X(chart 좌표)만 보관
  double? _touchStartX;

  @override
  Widget build(BuildContext context) {
    final points = widget.history.history;
    final prices = points.map((e) => e.price).toList();
    final minY = prices.reduce((a, b) => a < b ? a : b);
    final maxY = prices.reduce((a, b) => a > b ? a : b);
    final yPadding = (maxY - minY) * 0.1;

    final isPositive = prices.last >= prices.first;
    final lineColor = isPositive ? AppColors.success : AppColors.error;

    // Y축 interval: 전체 Y 범위를 4등분하여 레이블 중복 방지
    final yRange = (maxY + yPadding) - (minY - yPadding);
    final yInterval = yRange > 0 ? yRange / 4 : 1.0;

    final isOneDay = widget.selectedDays == 1;

    // ── 1일 모드: 분(minute) 오프셋 기반 ──────────────────────────────────
    // ── 다일 모드: 날짜(day) 오프셋 기반 ──────────────────────────────────
    final List<FlSpot> spots;
    final double maxX;
    final double labelInterval;
    String Function(double x) bottomLabel;
    String Function(double x) tooltipLabel;

    if (isOneDay) {
      final startTime = points
          .map((p) => p.recordedAt)
          .reduce((a, b) => a.isBefore(b) ? a : b);
      // 분 오프셋으로 변환, 같은 분은 마지막 값 유지
      final spotsMap = <int, double>{};
      for (final p in points) {
        final minOffset = p.recordedAt.difference(startTime).inMinutes;
        spotsMap[minOffset] = p.price;
      }
      spots = spotsMap.entries
          .map((e) => FlSpot(e.key.toDouble(), e.value))
          .toList()
        ..sort((a, b) => a.x.compareTo(b.x));
      maxX = spots.isEmpty ? 1 : spots.last.x;
      labelInterval = (maxX / 3).ceilToDouble().clamp(1, double.infinity);
      bottomLabel = (x) {
        final t = startTime.add(Duration(minutes: x.toInt()));
        return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
      };
      tooltipLabel = (x) {
        final t = startTime.add(Duration(minutes: x.toInt()));
        return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
      };
    } else {
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: widget.selectedDays - 1));
      final spotsMap = <int, double>{};
      for (final p in points) {
        final dayOffset = p.recordedAt.difference(startDate).inDays;
        if (dayOffset >= 0 && dayOffset <= widget.selectedDays - 1) {
          spotsMap[dayOffset] = p.price;
        }
      }
      spots = spotsMap.entries
          .map((e) => FlSpot(e.key.toDouble(), e.value))
          .toList()
        ..sort((a, b) => a.x.compareTo(b.x));
      // maxX: 마지막 데이터 날짜 오프셋으로 고정 (휴장일 빈 공간 제거)
      maxX = spots.isEmpty ? (widget.selectedDays - 1).toDouble() : spots.last.x;
      labelInterval = (maxX / 3).ceilToDouble().clamp(1, double.infinity);
      bottomLabel = (x) {
        final date = startDate.add(Duration(days: x.toInt()));
        return '${date.month}/${date.day}';
      };
      tooltipLabel = (x) {
        final date = startDate.add(Duration(days: x.toInt()));
        return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
      };
    }

    if (spots.isEmpty) {
      return const Center(child: Text('데이터가 없습니다'));
    }

    // 포인트가 적으면 곡선이 세모처럼 튀므로 직선 처리
    final useCurve = spots.length >= 5;

    // 선택 범위 강조 수직선
    final rangeStart = widget.dragStartX;
    final rangeEnd = widget.dragEndX;
    final hasRange = rangeStart != null && rangeEnd != null;
    final selLeft = hasRange
        ? (rangeStart < rangeEnd ? rangeStart : rangeEnd)
        : null;
    final selRight = hasRange
        ? (rangeStart < rangeEnd ? rangeEnd : rangeStart)
        : null;

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
              reservedSize: 64,
              interval: yInterval,
              getTitlesWidget: (value, _) => Text(
                _formatPrice(value),
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
              getTitlesWidget: (value, _) => Text(
                bottomLabel(value),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
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
        // 선택 범위 배경 + 수직선
        extraLinesData: hasRange
            ? ExtraLinesData(
                verticalLines: [
                  VerticalLine(
                    x: selLeft!,
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.7),
                    strokeWidth: 1.5,
                    dashArray: [4, 4],
                  ),
                  VerticalLine(
                    x: selRight!,
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.7),
                    strokeWidth: 1.5,
                    dashArray: [4, 4],
                  ),
                ],
              )
            : null,
        rangeAnnotations: hasRange
            ? RangeAnnotations(
                verticalRangeAnnotations: [
                  VerticalRangeAnnotation(
                    x1: selLeft!,
                    x2: selRight!,
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.08),
                  ),
                ],
              )
            : null,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: useCurve,
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
          touchCallback: (event, response) {
            final x = response?.lineBarSpots?.first.x;
            if (x == null) return;

            if (event is FlPanStartEvent) {
              _touchStartX = x;
              widget.onRangeChanged(x, x);
            } else if (event is FlPanUpdateEvent) {
              if (_touchStartX != null) {
                widget.onRangeChanged(_touchStartX, x);
              }
            } else if (event is FlPanEndEvent ||
                event is FlTapUpEvent ||
                event is FlLongPressEnd) {
              if (_touchStartX != null &&
                  widget.dragEndX != null &&
                  (widget.dragEndX! - _touchStartX!).abs() < 1) {
                // 단순 탭 → 범위 해제
                _touchStartX = null;
                widget.onRangeChanged(null, null);
              } else {
                _touchStartX = null;
              }
            }
          },
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '${tooltipLabel(spot.x)}\n${_formatPrice(spot.y)}',
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

  String _formatPrice(double value) => formatIndicatorPrice(value);
}

/// 드래그 범위의 등락률 요약 바
class _RangeSummaryBar extends StatelessWidget {
  const _RangeSummaryBar({
    required this.history,
    required this.selectedDays,
    required this.dragStartX,
    required this.dragEndX,
  });

  final IndicatorHistoryModel history;
  final int selectedDays;
  final double dragStartX;
  final double dragEndX;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: selectedDays - 1));

    final selLeft = dragStartX < dragEndX ? dragStartX : dragEndX;
    final selRight = dragStartX < dragEndX ? dragEndX : dragStartX;

    // 선택 범위에 포함된 포인트 수집
    final inRange = history.history.where((p) {
      final offset = p.recordedAt.difference(startDate).inDays.toDouble();
      return offset >= selLeft - 0.5 && offset <= selRight + 0.5;
    }).toList();

    if (inRange.isEmpty) return const SizedBox(height: AppSizes.spaceM);

    inRange.sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
    final fromPrice = inRange.first.price;
    final toPrice = inRange.last.price;
    final change = toPrice - fromPrice;
    final changeRate = fromPrice != 0 ? (change / fromPrice) * 100 : 0.0;
    final isPositive = change >= 0;
    final color = isPositive ? AppColors.success : AppColors.error;

    final fromDate = inRange.first.recordedAt;
    final toDate = inRange.last.recordedAt;

    String fmt(DateTime d) =>
        '${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';
    String fmtPrice(double v) => formatIndicatorPrice(v);

    return Container(
      margin: const EdgeInsets.only(top: AppSizes.spaceS),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceS,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(
            isPositive ? Icons.arrow_upward : Icons.arrow_downward,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            '${fmt(fromDate)} → ${fmt(toDate)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const Spacer(),
          Text(
            '${fmtPrice(fromPrice)} → ${fmtPrice(toPrice)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          const SizedBox(width: AppSizes.spaceS),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
            child: Text(
              '${isPositive ? '+' : ''}${changeRate.toStringAsFixed(2)}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── GOLD_KRW_SPOT 전용: 이격률 차트 ──────────────────────────────────────────

class _SpreadChartSection extends StatelessWidget {
  const _SpreadChartSection({
    required this.history,
    required this.selectedDays,
  });

  final IndicatorHistoryModel history;
  final int selectedDays;

  @override
  Widget build(BuildContext context) {
    final points = history.spreadHistory;
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: selectedDays - 1));

    // 날짜 오프셋 변환 + 중복 제거(같은 날 마지막 값 유지)
    final spotsMap = <int, double>{};
    for (final p in points) {
      final dayOffset = p.recordedAt.difference(startDate).inDays;
      if (dayOffset >= 0 && dayOffset <= selectedDays - 1) {
        spotsMap[dayOffset] = p.spread;
      }
    }
    final spots = spotsMap.entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList()
      ..sort((a, b) => a.x.compareTo(b.x));

    if (spots.isEmpty) return const SizedBox.shrink();

    final spreads = spots.map((s) => s.y).toList();
    final minY = spreads.reduce((a, b) => a < b ? a : b);
    final maxY = spreads.reduce((a, b) => a > b ? a : b);
    final yPadding = ((maxY - minY) * 0.15).clamp(0.1, double.infinity);
    // maxX: 마지막 데이터 날짜 오프셋으로 고정 (휴장일 빈 공간 제거)
    final maxX = spots.last.x;
    final labelInterval = (maxX / 3).ceilToDouble();
    final yRange = (maxY + yPadding) - (minY - yPadding);
    final yInterval = yRange > 0 ? yRange / 4 : 0.5;
    final useCurve = spots.length >= 5;

    // 최신 이격률 기준 색상
    final latestSpread = spots.last.y;
    final spreadColor = latestSpread >= 0 ? AppColors.error : AppColors.success;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '이격률 추이',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(width: AppSizes.spaceS),
            Text(
              '(국제 환산가 대비)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spaceXS),
        // 현재 이격률 요약
        _SpreadSummaryBadge(spread: latestSpread),
        const SizedBox(height: AppSizes.spaceM),
        SizedBox(
          height: 180,
          child: LineChart(
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
              // 0% 기준선
              extraLinesData: ExtraLinesData(
                horizontalLines: [
                  HorizontalLine(
                    y: 0,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant
                        .withValues(alpha: 0.5),
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ],
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 48,
                    interval: yInterval,
                    getTitlesWidget: (value, _) => Text(
                      '${value.toStringAsFixed(1)}%',
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
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
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
                  isCurved: useCurve,
                  color: spreadColor,
                  barWidth: 2,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        spreadColor.withValues(alpha: 0.15),
                        spreadColor.withValues(alpha: 0.0),
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
                      final date =
                          startDate.add(Duration(days: spot.x.toInt()));
                      final sign = spot.y >= 0 ? '+' : '';
                      return LineTooltipItem(
                        '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}\n$sign${spot.y.toStringAsFixed(2)}%',
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
          ),
        ),
      ],
    );
  }
}

class _MarketClosedBadge extends StatelessWidget {
  const _MarketClosedBadge({required this.lastDate});

  final DateTime lastDate;

  @override
  Widget build(BuildContext context) {
    final label =
        '${lastDate.month.toString().padLeft(2, '0')}/${lastDate.day.toString().padLeft(2, '0')}';
    return Row(
      children: [
        Icon(
          Icons.access_time_rounded,
          size: 13,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          '휴장 중 · 마지막 거래일: $label',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

class _SpreadSummaryBadge extends StatelessWidget {
  const _SpreadSummaryBadge({required this.spread});

  final double spread;

  @override
  Widget build(BuildContext context) {
    final isPremium = spread >= 0;
    final color = isPremium ? AppColors.error : AppColors.success;
    final sign = isPremium ? '+' : '';
    final label = isPremium ? '프리미엄' : '디스카운트';

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          ),
          child: Text(
            '$sign${spread.toStringAsFixed(2)}%',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(width: AppSizes.spaceS),
        Text(
          '현재 국제 환산가 대비 $label',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
