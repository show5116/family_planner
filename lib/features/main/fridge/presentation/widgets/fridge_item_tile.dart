import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/fridge/data/models/fridge_models.dart';

// ── Edit state (bulk save용) ──────────────────────────────────────────────────

class FridgeItemEditState {
  int quantity; // 로컬 수량 (±버튼으로 변경)
  String name;
  String? unit;
  String? expiresAt; // 'YYYY-MM-DD' or null
  int alertDaysBefore;
  String? memo;
  bool markedForDelete;

  FridgeItemEditState(FridgeItemModel item)
      : quantity = item.quantity,
        name = item.name,
        unit = item.unit,
        expiresAt = item.expiresAt != null
            ? '${item.expiresAt!.year}-${item.expiresAt!.month.toString().padLeft(2, '0')}-${item.expiresAt!.day.toString().padLeft(2, '0')}'
            : null,
        alertDaysBefore = item.alertDaysBefore,
        memo = item.memo,
        markedForDelete = false;

  bool hasChanges(FridgeItemModel original) {
    if (markedForDelete) return true;
    if (quantity != original.quantity) return true;
    if (name != original.name) return true;
    final unitChanged = unit != original.unit;
    if (unitChanged) return true;
    final origExpires = original.expiresAt != null
        ? '${original.expiresAt!.year}-${original.expiresAt!.month.toString().padLeft(2, '0')}-${original.expiresAt!.day.toString().padLeft(2, '0')}'
        : null;
    if (expiresAt != origExpires) return true;
    if (alertDaysBefore != original.alertDaysBefore) return true;
    if (memo != original.memo) return true;
    return false;
  }
}

// ── Tile (조회 모드) ──────────────────────────────────────────────────────────

class FridgeItemTile extends StatelessWidget {
  final FridgeItemModel item;
  final FridgeItemEditState editState;
  final VoidCallback onChanged;
  final VoidCallback onTapEdit; // 탭 → 바텀 시트

  const FridgeItemTile({
    super.key,
    required this.item,
    required this.editState,
    required this.onChanged,
    required this.onTapEdit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final deleted = editState.markedForDelete;
    final dday = item.daysUntilExpiry;

    return Dismissible(
      key: ValueKey('dismissible_${item.id}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        editState.markedForDelete = true;
        onChanged();
        return false; // 실제 위젯 제거는 하지 않음 (bulk save 패턴)
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSizes.spaceL),
        color: Theme.of(context).colorScheme.errorContainer,
        child: Icon(Icons.delete_outline,
            color: Theme.of(context).colorScheme.onErrorContainer),
      ),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: deleted ? 0.38 : 1.0,
        child: ListTile(
          onTap: deleted ? null : onTapEdit,
          contentPadding: const EdgeInsets.only(
            left: AppSizes.spaceL,
            right: AppSizes.spaceXS,
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  // 로컬 변경된 이름 반영
                  editState.name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        decoration: deleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                ),
              ),
              if (dday != null) ...[
                const SizedBox(width: AppSizes.spaceS),
                _DdayChip(days: dday, l10n: l10n),
              ],
            ],
          ),
          subtitle: _SubtitleRow(item: item, editState: editState, l10n: l10n),
          trailing: deleted
              ? IconButton(
                  icon: Icon(Icons.undo,
                      color: Theme.of(context).colorScheme.primary, size: 20),
                  tooltip: l10n.common_undo,
                  onPressed: () {
                    editState.markedForDelete = false;
                    if (editState.quantity == 0) {
                      editState.quantity = item.quantity;
                    }
                    onChanged();
                  },
                )
              : _QuantityButtons(
                  editState: editState,
                  onChanged: onChanged,
                ),
        ),
      ),
    );
  }
}

// ── 수량 ± 버튼 ───────────────────────────────────────────────────────────────

class _QuantityButtons extends StatelessWidget {
  final FridgeItemEditState editState;
  final VoidCallback onChanged;

  const _QuantityButtons({required this.editState, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove, size: 18),
          visualDensity: VisualDensity.compact,
          onPressed: editState.quantity > 0
              ? () {
                  editState.quantity--;
                  if (editState.quantity == 0) {
                    editState.markedForDelete = true;
                  }
                  onChanged();
                }
              : null,
        ),
        Text(
          editState.quantity.toString(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        IconButton(
          icon: const Icon(Icons.add, size: 18),
          visualDensity: VisualDensity.compact,
          onPressed: () {
            editState.quantity++;
            onChanged();
          },
        ),
      ],
    );
  }
}

// ── 보조 정보 행 ──────────────────────────────────────────────────────────────

class _SubtitleRow extends StatelessWidget {
  final FridgeItemModel item;
  final FridgeItemEditState editState;
  final AppLocalizations l10n;

  const _SubtitleRow(
      {required this.item, required this.editState, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.outline,
        );

    final parts = <String>[];

    // 단위 표시
    final unitStr = editState.unit;
    if (unitStr != null && unitStr.isNotEmpty) {
      parts.add(unitStr);
    }

    // 유통기한
    if (item.expiresAt != null) {
      parts.add(DateFormat('yyyy-MM-dd').format(item.expiresAt!));
    }

    // 등록일
    final now = DateTime.now();
    final registered = item.registeredAt;
    final elapsed = DateTime(now.year, now.month, now.day)
        .difference(DateTime(registered.year, registered.month, registered.day))
        .inDays;
    parts.add(
        '${registered.month}/${registered.day} +$elapsed${l10n.fridge_item_elapsed_days}');

    // 메모
    final memoStr = editState.memo;
    if (memoStr != null && memoStr.isNotEmpty) {
      parts.add(memoStr);
    }

    return Text(parts.join('  ·  '), style: style);
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
