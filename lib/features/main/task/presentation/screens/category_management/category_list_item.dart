import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 카테고리 목록 아이템 위젯
class CategoryListItem extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryListItem({
    super.key,
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = category.color != null
        ? Color(int.parse('FF${category.color!.replaceFirst('#', '')}', radix: 16))
        : AppColors.primary;

    return Card(
      elevation: AppSizes.elevation1,
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: _CategoryIcon(
          emoji: category.emoji,
          color: color,
        ),
        title: Text(
          category.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: category.description != null && category.description!.isNotEmpty
            ? Text(
                category.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: _CategoryTrailing(
          color: color,
          onEdit: onEdit,
          onDelete: onDelete,
        ),
      ),
    );
  }
}

/// 카테고리 아이콘
class _CategoryIcon extends StatelessWidget {
  final String? emoji;
  final Color color;

  const _CategoryIcon({
    required this.emoji,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Center(
        child: emoji != null
            ? Text(emoji!, style: const TextStyle(fontSize: 24))
            : Icon(Icons.category, color: color),
      ),
    );
  }
}

/// 카테고리 트레일링 (색상 표시 + 메뉴)
class _CategoryTrailing extends StatelessWidget {
  final Color color;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryTrailing({
    required this.color,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 색상 표시
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSizes.spaceS),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              onEdit();
            } else if (value == 'delete') {
              onDelete();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  const Icon(Icons.edit_outlined, size: 20),
                  const SizedBox(width: AppSizes.spaceS),
                  Text(l10n.common_edit),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                  const SizedBox(width: AppSizes.spaceS),
                  Text(l10n.common_delete, style: TextStyle(color: AppColors.error)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
