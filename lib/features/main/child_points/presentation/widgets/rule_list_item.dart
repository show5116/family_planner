import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/child_points/data/models/childcare_model.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 규칙 항목 아이템
class RuleListItem extends StatelessWidget {
  const RuleListItem({
    super.key,
    required this.rule,
    this.onEdit,
    this.onDelete,
    this.onToggleActive,
    this.onApplyPenalty,
  });

  final ChildcareRule rule;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleActive;
  final VoidCallback? onApplyPenalty;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: rule.isActive
            ? colorScheme.errorContainer
            : colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.rule_rounded,
          color: rule.isActive
              ? colorScheme.error
              : colorScheme.onSurfaceVariant,
          size: AppSizes.iconMedium,
        ),
      ),
      title: Text(
        rule.name,
        style: TextStyle(
          color: rule.isActive ? null : colorScheme.onSurfaceVariant,
          decoration: rule.isActive ? null : TextDecoration.lineThrough,
        ),
      ),
      subtitle: rule.description != null
          ? Text(
              rule.description!,
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
              color: colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
            child: Text(
              l10n.childcare_rule_penalty(rule.penalty.toInt()),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          if (onEdit != null || onDelete != null || onApplyPenalty != null) ...[
            const SizedBox(width: 4),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'apply') onApplyPenalty?.call();
                if (value == 'edit') onEdit?.call();
                if (value == 'toggle') onToggleActive?.call();
                if (value == 'delete') onDelete?.call();
              },
              itemBuilder: (context) => [
                if (onApplyPenalty != null && rule.isActive)
                  PopupMenuItem(
                    value: 'apply',
                    child: Text(
                      '규칙 위반 적용',
                      style: TextStyle(color: colorScheme.error),
                    ),
                  ),
                if (onEdit != null)
                  const PopupMenuItem(value: 'edit', child: Text('수정')),
                if (onToggleActive != null)
                  PopupMenuItem(
                    value: 'toggle',
                    child: Text(rule.isActive ? '비활성화' : '활성화'),
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
