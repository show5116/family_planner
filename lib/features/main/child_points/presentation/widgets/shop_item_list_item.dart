import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/child_points/data/models/childcare_model.dart';

/// 포인트 상점 아이템 리스트 아이템
class ShopItemListItem extends StatelessWidget {
  const ShopItemListItem({
    super.key,
    required this.item,
    this.onUse,
    this.onEdit,
    this.onDelete,
    this.onToggleActive,
  });

  final ChildcareShopItem item;
  final VoidCallback? onUse;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleActive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      onTap: item.isActive ? onUse : null,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: item.isActive
              ? colorScheme.secondaryContainer
              : colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.storefront_outlined,
          color: item.isActive
              ? colorScheme.secondary
              : colorScheme.onSurfaceVariant,
          size: AppSizes.iconSmall,
        ),
      ),
      title: Text(
        item.name,
        style: TextStyle(
          color: item.isActive ? null : colorScheme.onSurfaceVariant,
          decoration: item.isActive ? null : TextDecoration.lineThrough,
        ),
      ),
      subtitle: item.description != null
          ? Text(
              item.description!,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceS,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
            child: Text(
              '${item.points}P',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          if (onEdit != null || onDelete != null || onToggleActive != null) ...[
            const SizedBox(width: 4),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'edit') onEdit?.call();
                if (value == 'delete') onDelete?.call();
                if (value == 'toggle') onToggleActive?.call();
              },
              itemBuilder: (context) => [
                if (onEdit != null)
                  const PopupMenuItem(value: 'edit', child: Text('수정')),
                if (onToggleActive != null)
                  PopupMenuItem(
                    value: 'toggle',
                    child: Text(item.isActive ? '비활성화' : '활성화'),
                  ),
                if (onDelete != null)
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      '삭제',
                      style: TextStyle(color: colorScheme.error),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
