import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/assets/data/models/account_model.dart';
import 'package:family_planner/features/main/assets/data/models/asset_statistics_model.dart';
import 'package:family_planner/features/main/assets/utils/asset_utils.dart';
import 'package:family_planner/l10n/app_localizations.dart';

enum PieChartMode { type, account, portfolio }

/// 파이차트 데이터 슬라이스 (3가지 모드 공통)
class _PieSlice {
  final String label;
  final double amount;

  const _PieSlice({required this.label, required this.amount});
}

/// 자산 파이차트 (유형별 / 계좌별 / 포트폴리오 합산)
class AssetPieChart extends StatefulWidget {
  final List<AccountModel> accounts;
  final AssetStatisticsModel stats;

  const AssetPieChart({
    super.key,
    required this.accounts,
    required this.stats,
  });

  @override
  State<AssetPieChart> createState() => _AssetPieChartState();
}

class _AssetPieChartState extends State<AssetPieChart> {
  PieChartMode _mode = PieChartMode.type;
  int? _touchedIndex;

  static const List<Color> _palette = [
    Color(0xFF6366F1),
    Color(0xFF22C55E),
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
    Color(0xFF14B8A6),
    Color(0xFFA855F7),
    Color(0xFFF97316),
    Color(0xFF3B82F6),
    Color(0xFFEC4899),
    Color(0xFF84CC16),
  ];

  Color _colorFor(int index) => _palette[index % _palette.length];

  List<_PieSlice> _buildSlices(AppLocalizations l10n) {
    switch (_mode) {
      case PieChartMode.type:
        return widget.stats.byType
            .where((t) => t.balance > 0)
            .map((t) => _PieSlice(
                  label: accountTypeLabel(l10n, t.type),
                  amount: t.balance,
                ))
            .toList();

      case PieChartMode.account:
        return widget.accounts
            .where((a) => (a.latestBalance ?? 0) > 0)
            .map((a) => _PieSlice(
                  label: a.name,
                  amount: a.latestBalance!,
                ))
            .toList();

      case PieChartMode.portfolio:
        if (widget.stats.byHolding.isEmpty) return [];
        // 이름이 같으면 합산 (서버가 이미 합산해서 내려주지만 방어적으로 처리)
        final merged = <String, double>{};
        for (final h in widget.stats.byHolding) {
          merged[h.name] = (merged[h.name] ?? 0) + h.estimatedAmount;
        }
        final sorted = merged.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        return sorted
            .map((e) => _PieSlice(label: e.key, amount: e.value))
            .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final slices = _buildSlices(l10n);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 모드 선택 탭
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _ModeChip(
                label: l10n.asset_pie_mode_type,
                selected: _mode == PieChartMode.type,
                onTap: () => setState(() {
                  _mode = PieChartMode.type;
                  _touchedIndex = null;
                }),
              ),
              const SizedBox(width: AppSizes.spaceXS),
              _ModeChip(
                label: l10n.asset_pie_mode_account,
                selected: _mode == PieChartMode.account,
                onTap: () => setState(() {
                  _mode = PieChartMode.account;
                  _touchedIndex = null;
                }),
              ),
              const SizedBox(width: AppSizes.spaceXS),
              _ModeChip(
                label: l10n.asset_pie_mode_portfolio,
                selected: _mode == PieChartMode.portfolio,
                onTap: () => setState(() {
                  _mode = PieChartMode.portfolio;
                  _touchedIndex = null;
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.spaceM),

        // 차트 본체
        if (slices.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceXL),
              child: Text(
                _mode == PieChartMode.portfolio
                    ? l10n.asset_pie_no_portfolio
                    : l10n.asset_trend_no_data,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ),
          )
        else
          _PieChartBody(
            slices: slices,
            touchedIndex: _touchedIndex,
            colorFor: _colorFor,
            onTouch: (idx) => setState(() {
              _touchedIndex = (_touchedIndex == idx) ? null : idx;
            }),
          ),
      ],
    );
  }
}

class _PieChartBody extends StatefulWidget {
  final List<_PieSlice> slices;
  final int? touchedIndex;
  final Color Function(int) colorFor;
  final void Function(int) onTouch;

  const _PieChartBody({
    required this.slices,
    required this.touchedIndex,
    required this.colorFor,
    required this.onTouch,
  });

  @override
  State<_PieChartBody> createState() => _PieChartBodyState();
}

class _PieChartBodyState extends State<_PieChartBody> {
  static const _legendInitialCount = 6;
  bool _legendExpanded = false;

  @override
  void didUpdateWidget(_PieChartBody old) {
    super.didUpdateWidget(old);
    // 모드 전환 시 접기 초기화
    if (old.slices != widget.slices) _legendExpanded = false;
  }

  @override
  Widget build(BuildContext context) {
    final slices = widget.slices;
    final total = slices.fold<double>(0, (s, e) => s + e.amount);
    final touched = widget.touchedIndex != null &&
            widget.touchedIndex! >= 0 &&
            widget.touchedIndex! < slices.length
        ? slices[widget.touchedIndex!]
        : null;

    final sections = List.generate(slices.length, (i) {
      final slice = slices[i];
      final ratio = slice.amount / total;
      final isTouched = widget.touchedIndex == i;

      return PieChartSectionData(
        value: slice.amount,
        color: widget.colorFor(i),
        radius: isTouched ? 72 : 60,
        showTitle: ratio >= 0.06,
        title: '${(ratio * 100).toStringAsFixed(1)}%',
        titleStyle: TextStyle(
          fontSize: isTouched ? 13 : 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titlePositionPercentageOffset: 0.6,
      );
    });

    final hasMore = slices.length > _legendInitialCount;
    final visibleSlices =
        _legendExpanded ? slices : slices.take(_legendInitialCount).toList();

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 48,
              sectionsSpace: 2,
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  if (event is! FlTapUpEvent) return;
                  if (response?.touchedSection == null) return;
                  final idx = response!.touchedSection!.touchedSectionIndex;
                  if (idx < 0 || idx >= slices.length) return;
                  widget.onTouch(idx);
                },
              ),
            ),
          ),
        ),

        // 선택된 항목 정보
        if (touched != null) ...[
          const SizedBox(height: AppSizes.spaceS),
          Text(
            touched.label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          Text(
            '₩${formatAssetAmount(touched.amount)}  '
            '(${(touched.amount / total * 100).toStringAsFixed(1)}%)',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppSizes.spaceS),
        ] else
          const SizedBox(height: AppSizes.spaceM),

        // 범례
        Wrap(
          spacing: AppSizes.spaceS,
          runSpacing: AppSizes.spaceXS,
          alignment: WrapAlignment.center,
          children: [
            ...List.generate(visibleSlices.length, (i) {
              final slice = visibleSlices[i];
              final ratio = slice.amount / total * 100;
              final isTouched = widget.touchedIndex == i;

              return GestureDetector(
                onTap: () => widget.onTouch(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spaceS,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isTouched
                        ? widget.colorFor(i).withValues(alpha: 0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    border: isTouched
                        ? Border.all(color: widget.colorFor(i).withValues(alpha: 0.4))
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: widget.colorFor(i),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${slice.label}  ${ratio.toStringAsFixed(1)}%',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: isTouched ? FontWeight.bold : FontWeight.normal,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            if (hasMore)
              GestureDetector(
                onTap: () => setState(() => _legendExpanded = !_legendExpanded),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spaceS,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _legendExpanded ? Icons.expand_less : Icons.expand_more,
                        size: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        _legendExpanded
                            ? '접기'
                            : '+${slices.length - _legendInitialCount}개 더보기',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeChip({
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
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceS, vertical: 6),
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
