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
    return Card(
      elevation: AppSizes.elevation1,
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: _CategoryIcon(emoji: category.emoji),
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
        trailing: _CategoryTrailing(onEdit: onEdit, onDelete: onDelete),
      ),
    );
  }
}

/// 카테고리 아이콘
class _CategoryIcon extends StatelessWidget {
  final String? emoji;

  const _CategoryIcon({required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Center(
        child: emoji != null
            ? Text(emoji!, style: const TextStyle(fontSize: 24))
            : const Icon(Icons.category),
      ),
    );
  }
}

/// 카테고리 트레일링 (메뉴)
class _CategoryTrailing extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryTrailing({
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopupMenuButton<String>(
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
        );
  }
}
