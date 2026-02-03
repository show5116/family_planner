import 'package:flutter/material.dart';

import 'package:family_planner/features/settings/permissions/models/permission.dart';

/// 권한 체크박스 타일 위젯
class PermissionCheckboxTile extends StatelessWidget {
  final Permission permission;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;

  const PermissionCheckboxTile({
    super.key,
    required this.permission,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(permission.name),
      subtitle: Text(
        '${permission.code}${permission.description != null ? '\n${permission.description}' : ''}',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      value: isSelected,
      onChanged: permission.isActive ? onChanged : null,
      secondary: Icon(
        Icons.security,
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Colors.grey,
      ),
      enabled: permission.isActive,
    );
  }
}
