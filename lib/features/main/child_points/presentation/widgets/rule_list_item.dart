import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/child_points/data/models/childcare_model.dart';

/// 규칙 항목 아이템
class RuleListItem extends StatelessWidget {
  const RuleListItem({
    super.key,
    required this.rule,
    this.onApplyRule,
    this.onEdit,
    this.onDelete,
    this.onToggleActive,
  });

  final ChildcareRule rule;
  final VoidCallback? onApplyRule;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleActive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final (iconData, iconColor, bgColor, badgeColor, badgeText) =
        switch (rule.type) {
      ChildcareRuleType.plus => (
          Icons.add_circle_outline,
          Colors.green.shade700,
          Colors.green.shade50,
          Colors.green.shade700,
          '+${rule.points}P',
        ),
      ChildcareRuleType.minus => (
          Icons.remove_circle_outline,
          colorScheme.error,
          colorScheme.error.withValues(alpha: 0.12),
          colorScheme.error,
          '-${rule.points}P',
        ),
      ChildcareRuleType.info => (
          Icons.info_outline,
          colorScheme.primary,
          colorScheme.primaryContainer,
          colorScheme.primary,
          '일반',
        ),
    };

    final activeIconColor =
        rule.isActive ? iconColor : colorScheme.onSurfaceVariant;
    final activeBgColor =
        rule.isActive ? bgColor : colorScheme.surfaceContainerHighest;

    // plus/minus 타입이고 활성화 상태이며 포인트가 있을 때만 탭 가능
    final canApply = onApplyRule != null &&
        rule.isActive &&
        rule.type != ChildcareRuleType.info &&
        rule.points > 0;

    return ListTile(
      onTap: canApply ? onApplyRule : null,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: activeBgColor,
          shape: BoxShape.circle,
        ),
        child: Icon(iconData, color: activeIconColor, size: AppSizes.iconSmall),
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
          if (rule.type != ChildcareRuleType.info || rule.points > 0)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceS,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: rule.isActive
                    ? bgColor
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
              child: Text(
                badgeText,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: rule.isActive
                          ? badgeColor
                          : colorScheme.onSurfaceVariant,
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
                if (value == 'toggle') onToggleActive?.call();
                if (value == 'delete') onDelete?.call();
              },
              itemBuilder: (context) => [
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
