import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/widgets/reorderable_widgets.dart';
import 'package:family_planner/features/settings/roles/models/common_role.dart';

/// 역할 카드 위젯
class RoleCard extends StatelessWidget {
  final CommonRole role;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onPermissions;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const RoleCard({
    super.key,
    required this.role,
    required this.index,
    required this.onTap,
    required this.onPermissions,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableDragStartListener(
      index: index,
      child: Card(
        margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
        child: ListTile(
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const DragHandleIcon(),
              const SizedBox(width: AppSizes.spaceS),
              _buildRoleAvatar(context),
            ],
          ),
          title: _buildRoleTitle(context),
          subtitle: role.description != null
              ? Text(
                  role.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          trailing: _buildPopupMenu(context),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildRoleAvatar(BuildContext context) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: role.color != null
          ? Color(int.parse(role.color!.substring(1), radix: 16) + 0xFF000000)
          : Colors.blue,
      child: Text(
        role.name.substring(0, 1),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildRoleTitle(BuildContext context) {
    return Row(
      children: [
        Text(
          role.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        if (role.isDefaultRole) ...[
          const SizedBox(width: AppSizes.spaceS),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceS,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
            child: Text(
              '기본',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'permissions':
            onPermissions();
            break;
          case 'edit':
            onEdit();
            break;
          case 'delete':
            onDelete();
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'permissions',
          child: Row(
            children: [
              Icon(Icons.security),
              SizedBox(width: AppSizes.spaceS),
              Text('권한 관리'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit),
              SizedBox(width: AppSizes.spaceS),
              Text('수정'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              SizedBox(width: AppSizes.spaceS),
              Text('삭제', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }
}
