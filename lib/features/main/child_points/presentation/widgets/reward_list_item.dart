import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/child_points/data/models/childcare_model.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 보상 항목 아이템
class RewardListItem extends StatelessWidget {
  const RewardListItem({
    super.key,
    required this.reward,
    this.onEdit,
    this.onDelete,
    this.onToggleActive,
  });

  final ChildcareReward reward;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleActive;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: reward.isActive
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.card_giftcard,
          color: reward.isActive
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant,
          size: AppSizes.iconMedium,
        ),
      ),
      title: Text(
        reward.name,
        style: TextStyle(
          color: reward.isActive ? null : colorScheme.onSurfaceVariant,
          decoration:
              reward.isActive ? null : TextDecoration.lineThrough,
        ),
      ),
      subtitle: reward.description != null
          ? Text(
              reward.description!,
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
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
            child: Text(
              l10n.childcare_reward_points_cost(reward.points.toInt()),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          if (onEdit != null || onDelete != null) ...[
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
                  PopupMenuItem(
                    value: 'edit',
                    child: Text(reward.isActive ? '수정' : '수정'),
                  ),
                if (onToggleActive != null)
                  PopupMenuItem(
                    value: 'toggle',
                    child: Text(reward.isActive ? '비활성화' : '활성화'),
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
