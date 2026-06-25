import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/assets/data/models/holding_model.dart';
import 'package:family_planner/features/main/assets/providers/asset_provider.dart';
import 'package:family_planner/features/main/assets/presentation/widgets/holding_form_sheet.dart';
import 'package:family_planner/l10n/app_localizations.dart';

// ─── 색상 팔레트 (파이 조각용) ─────────────────────────────────────────────────
const _palette = [
  Color(0xFF4285F4),
  Color(0xFFEA4335),
  Color(0xFFFBBC05),
  Color(0xFF34A853),
  Color(0xFFAB47BC),
  Color(0xFF00ACC1),
  Color(0xFFFF7043),
  Color(0xFF8D6E63),
];

Color _colorFor(int index) => _palette[index % _palette.length];

// ─── 파이차트 Painter ──────────────────────────────────────────────────────────
class _PieChartPainter extends CustomPainter {
  final List<HoldingModel> holdings;
  final double totalRatio;

  _PieChartPainter(this.holdings, this.totalRatio);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final paint = Paint()..style = PaintingStyle.fill;

    // 미할당 비중(회색)을 포함해서 360° 채움
    final remaining = (100 - totalRatio).clamp(0.0, 100.0);
    final items = [
      ...holdings.map((h) => (ratio: h.ratio, color: _colorFor(holdings.indexOf(h)))),
      if (remaining > 0) (ratio: remaining, color: const Color(0xFFE0E0E0)),
    ];

    double startAngle = -math.pi / 2;
    for (final item in items) {
      final sweep = (item.ratio / 100) * 2 * math.pi;
      paint.color = item.color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweep,
        true,
        paint,
      );
      startAngle += sweep;
    }

    // 중앙 흰 원 (도넛 효과)
    paint.color = Colors.white;
    canvas.drawCircle(center, radius * 0.55, paint);
  }

  @override
  bool shouldRepaint(_PieChartPainter old) =>
      old.holdings != holdings || old.totalRatio != totalRatio;
}

// ─── 포트폴리오 비중 섹션 ──────────────────────────────────────────────────────
class HoldingsSection extends ConsumerWidget {
  final String accountId;

  const HoldingsSection({super.key, required this.accountId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final holdingsAsync = ref.watch(holdingsProvider(accountId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 헤더
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.spaceM, AppSizes.spaceS, AppSizes.spaceM, 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.asset_holdings,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton.icon(
                onPressed: () => _showHoldingSheet(context, ref, l10n, null),
                icon: const Icon(Icons.add, size: 18),
                label: Text(l10n.asset_holding_add),
              ),
            ],
          ),
        ),

        holdingsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSizes.spaceL),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, _) => Padding(
            padding: const EdgeInsets.all(AppSizes.spaceM),
            child: Text(l10n.common_error,
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
          data: (holdings) {
            if (holdings.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceL),
                child: Center(
                  child: Text(
                    l10n.asset_holdings_empty,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ),
              );
            }

            final totalRatio = holdings.fold(0.0, (s, h) => s + h.ratio);

            return Column(
              children: [
                const SizedBox(height: AppSizes.spaceM),
                // 파이차트
                SizedBox(
                  height: 160,
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomPaint(
                          painter: _PieChartPainter(holdings, totalRatio),
                        ),
                      ),
                      // 범례
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...holdings.map((h) => _LegendItem(
                                  color: _colorFor(holdings.indexOf(h)),
                                  label: h.ticker != null
                                      ? '${h.name} (${h.ticker})'
                                      : h.name,
                                  ratio: h.ratio,
                                )),
                            if (totalRatio < 100)
                              _LegendItem(
                                color: const Color(0xFFE0E0E0),
                                label: '미할당',
                                ratio: 100 - totalRatio,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.spaceS),
                // 합계 표시
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${l10n.asset_holding_total_ratio}: ${totalRatio.toStringAsFixed(1)}%',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: totalRatio > 100
                                  ? Theme.of(context).colorScheme.error
                                  : Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.spaceS),
                // 목록 (순서 변경 가능)
                ReorderableListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: holdings.length,
                  itemBuilder: (ctx, i) {
                    final h = holdings[i];
                    return _HoldingListItem(
                      key: ValueKey(h.id),
                      holding: h,
                      color: _colorFor(i),
                      onEdit: () => _showHoldingSheet(context, ref, l10n, h),
                      onDelete: () => _confirmDelete(context, ref, l10n, h),
                    );
                  },
                  onReorderItem: (oldIndex, newIndex) {
                    final reordered = [...holdings];
                    reordered.insert(newIndex, reordered.removeAt(oldIndex));
                    ref.read(holdingsProvider(accountId).notifier).reorder(reordered);
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Future<void> _showHoldingSheet(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    HoldingModel? existing,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => HoldingFormSheet(
        accountId: accountId,
        existing: existing,
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    HoldingModel holding,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.asset_holding_delete),
        content: Text(l10n.asset_holding_delete_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              l10n.common_delete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      try {
        await ref.read(holdingsProvider(accountId).notifier).delete(holding.id);
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.common_error)),
          );
        }
      }
    }
  }
}

// ─── 범례 아이템 ───────────────────────────────────────────────────────────────
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final double ratio;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.ratio,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '${ratio.toStringAsFixed(1)}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

// ─── 목록 아이템 ───────────────────────────────────────────────────────────────
class _HoldingListItem extends StatelessWidget {
  final HoldingModel holding;
  final Color color;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _HoldingListItem({
    super.key,
    required this.holding,
    required this.color,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: 0,
      ),
      leading: Container(
        width: 12,
        height: 12,
        margin: const EdgeInsets.only(top: 4),
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      title: Text(
        holding.ticker != null ? '${holding.name} (${holding.ticker})' : holding.name,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${holding.ratio.toStringAsFixed(1)}%',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(width: AppSizes.spaceS),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, size: 18),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'edit',
                child: Text(AppLocalizations.of(ctx)!.asset_holding_edit),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Text(
                  AppLocalizations.of(ctx)!.asset_holding_delete,
                  style: TextStyle(color: Theme.of(ctx).colorScheme.error),
                ),
              ),
            ],
            onSelected: (v) {
              if (v == 'edit') onEdit();
              if (v == 'delete') onDelete();
            },
          ),
        ],
      ),
    );
  }
}

