import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/fridge/data/models/fridge_models.dart';

// ── Edit state ────────────────────────────────────────────────────────────────

class FridgeItemEditState {
  final TextEditingController name;
  final TextEditingController quantity;
  final TextEditingController unit;
  final TextEditingController expiresAt;
  final TextEditingController alertDays;
  final TextEditingController memo;
  bool markedForDelete;

  FridgeItemEditState(FridgeItemModel item)
      : name = TextEditingController(text: item.name),
        quantity = TextEditingController(text: item.quantity.toString()),
        unit = TextEditingController(text: item.unit ?? ''),
        expiresAt = TextEditingController(
            text: item.expiresAt != null
                ? '${item.expiresAt!.year}-${item.expiresAt!.month.toString().padLeft(2, '0')}-${item.expiresAt!.day.toString().padLeft(2, '0')}'
                : ''),
        alertDays = TextEditingController(
            text: item.alertDaysBefore == 0
                ? ''
                : item.alertDaysBefore.toString()),
        memo = TextEditingController(text: item.memo ?? ''),
        markedForDelete = false;

  bool hasChanges(FridgeItemModel original) {
    if (markedForDelete) return true;
    if (name.text.trim() != original.name) return true;
    if ((int.tryParse(quantity.text) ?? original.quantity) != original.quantity) {
      return true;
    }
    final unitVal = unit.text.trim().isEmpty ? null : unit.text.trim();
    if (unitVal != original.unit) return true;
    final expiresVal = expiresAt.text.trim().isEmpty ? null : expiresAt.text.trim();
    final originalExpires = original.expiresAt != null
        ? '${original.expiresAt!.year}-${original.expiresAt!.month.toString().padLeft(2, '0')}-${original.expiresAt!.day.toString().padLeft(2, '0')}'
        : null;
    if (expiresVal != originalExpires) return true;
    final alertVal = int.tryParse(alertDays.text.trim()) ?? 0;
    if (alertVal != original.alertDaysBefore) return true;
    final memoVal = memo.text.trim().isEmpty ? null : memo.text.trim();
    if (memoVal != original.memo) return true;
    return false;
  }

  void dispose() {
    name.dispose();
    quantity.dispose();
    unit.dispose();
    expiresAt.dispose();
    alertDays.dispose();
    memo.dispose();
  }
}

// ── Tile ──────────────────────────────────────────────────────────────────────

class FridgeItemTile extends StatelessWidget {
  final FridgeItemModel item;
  final FridgeItemEditState editState;
  final VoidCallback onChanged;

  const FridgeItemTile({
    super.key,
    required this.item,
    required this.editState,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final deleted = editState.markedForDelete;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: deleted ? 0.38 : 1.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceM, vertical: AppSizes.spaceXS),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 삭제/되돌리기 버튼
            IconButton(
              icon: Icon(
                deleted ? Icons.undo : Icons.delete_outline,
                color: deleted
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.error,
                size: 20,
              ),
              tooltip: deleted ? l10n.common_undo : l10n.common_delete,
              onPressed: () {
                editState.markedForDelete = !editState.markedForDelete;
                onChanged();
              },
            ),
            Expanded(
              child: IgnorePointer(
                ignoring: deleted,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 이름
                    TextField(
                      controller: editState.name,
                      decoration: InputDecoration(
                        labelText: l10n.fridge_item_name,
                        isDense: true,
                        border: const UnderlineInputBorder(),
                      ),
                      onChanged: (_) => onChanged(),
                    ),
                    const SizedBox(height: AppSizes.spaceXS),
                    Row(
                      children: [
                        // 수량
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: editState.quantity,
                            decoration: InputDecoration(
                              labelText: l10n.fridge_item_quantity,
                              isDense: true,
                              border: const UnderlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (_) => onChanged(),
                          ),
                        ),
                        const SizedBox(width: AppSizes.spaceS),
                        // 단위
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: editState.unit,
                            decoration: InputDecoration(
                              labelText: l10n.fridge_item_unit,
                              isDense: true,
                              border: const UnderlineInputBorder(),
                            ),
                            onChanged: (_) => onChanged(),
                          ),
                        ),
                        const SizedBox(width: AppSizes.spaceS),
                        // 알림 일수
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: editState.alertDays,
                            decoration: InputDecoration(
                              labelText: l10n.fridge_item_alert_days(0)
                                  .replaceAll('0', '')
                                  .trim(),
                              isDense: true,
                              border: const UnderlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (_) => onChanged(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.spaceXS),
                    Row(
                      children: [
                        // 유통기한
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: editState.expiresAt,
                            decoration: InputDecoration(
                              labelText: l10n.fridge_item_expires_at,
                              hintText: 'YYYY-MM-DD',
                              isDense: true,
                              border: const UnderlineInputBorder(),
                            ),
                            onChanged: (_) => onChanged(),
                          ),
                        ),
                        const SizedBox(width: AppSizes.spaceS),
                        // 메모
                        Expanded(
                          flex: 4,
                          child: TextField(
                            controller: editState.memo,
                            decoration: InputDecoration(
                              labelText: l10n.fridge_item_memo,
                              isDense: true,
                              border: const UnderlineInputBorder(),
                            ),
                            onChanged: (_) => onChanged(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.spaceXS),
                    // D-day 칩 (읽기 전용 표시)
                    _DdayRow(item: item, l10n: l10n),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── D-day row ─────────────────────────────────────────────────────────────────

class _DdayRow extends StatelessWidget {
  final FridgeItemModel item;
  final AppLocalizations l10n;
  const _DdayRow({required this.item, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final dday = item.daysUntilExpiry;
    final now = DateTime.now();
    final registered = item.registeredAt;
    final elapsedDays = DateTime(now.year, now.month, now.day)
        .difference(
            DateTime(registered.year, registered.month, registered.day))
        .inDays;
    final registeredLabel =
        '${registered.month}/${registered.day}  +$elapsedDays${l10n.fridge_item_elapsed_days}';

    return Row(
      children: [
        Text(
          registeredLabel,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.outline),
        ),
        if (dday != null) ...[
          const SizedBox(width: AppSizes.spaceS),
          _DdayChip(days: dday, l10n: l10n),
        ],
      ],
    );
  }
}

// ── D-day chip ────────────────────────────────────────────────────────────────

class _DdayChip extends StatelessWidget {
  final int days;
  final AppLocalizations l10n;
  const _DdayChip({required this.days, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String label;

    if (days < 0) {
      color = Theme.of(context).colorScheme.error;
      label = l10n.fridge_item_dday_expired(-days);
    } else if (days == 0) {
      color = Theme.of(context).colorScheme.error;
      label = l10n.fridge_item_dday_today;
    } else if (days <= 3) {
      color = Colors.orange;
      label = l10n.fridge_item_dday_remaining(days);
    } else {
      color = Theme.of(context).colorScheme.primary;
      label = l10n.fridge_item_dday_remaining(days);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
