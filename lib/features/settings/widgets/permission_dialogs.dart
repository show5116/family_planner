import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/settings/models/permission.dart';
import 'package:family_planner/features/settings/providers/permission_management_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 권한 생성 다이얼로그
class PermissionCreateDialog {
  static Future<void> show(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final codeController = TextEditingController();
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedCategory = 'BASIC';

    await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (builderContext, setState) => AlertDialog(
          title: Text(l10n.permission_create),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: codeController,
                  decoration: InputDecoration(
                    labelText: l10n.permission_code,
                    hintText: 'EXAMPLE_CODE',
                    border: const OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.characters,
                ),
                const SizedBox(height: AppSizes.spaceM),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: l10n.permission_name,
                    hintText: '예시 권한',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSizes.spaceM),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: l10n.permission_description,
                    hintText: '이 권한에 대한 설명을 입력하세요',
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: AppSizes.spaceM),
                DropdownButtonFormField<String>(
                  initialValue: selectedCategory,
                  decoration: InputDecoration(
                    labelText: l10n.permission_category,
                    border: const OutlineInputBorder(),
                  ),
                  items: ['BASIC', 'MEMBER', 'ROLE', 'INVITE', 'SCHEDULE', 'ASSET']
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedCategory = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.common_cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                if (codeController.text.isEmpty ||
                    nameController.text.isEmpty) {
                  ScaffoldMessenger.of(builderContext).showSnackBar(
                    SnackBar(
                      content: Text(l10n.permission_codeAndNameRequired),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                Navigator.pop(dialogContext);

                // 생성 실행
                await _performCreate(
                  context,
                  ref,
                  l10n,
                  codeController.text.toUpperCase(),
                  nameController.text,
                  descriptionController.text.isEmpty
                      ? null
                      : descriptionController.text,
                  selectedCategory,
                );
              },
              child: Text(l10n.common_create),
            ),
          ],
        ),
      ),
    );

    codeController.dispose();
    nameController.dispose();
    descriptionController.dispose();
  }

  static Future<void> _performCreate(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String code,
    String name,
    String? description,
    String category,
  ) async {
    debugPrint('Creating permission...');
    try {
      final notifier = ref.read(permissionManagementProvider.notifier);
      debugPrint('Calling API: createPermission');
      final createdPermission = await notifier.createPermission(
        code: code,
        name: name,
        description: description,
        category: category,
      );
      debugPrint('Permission created: ${createdPermission.id}');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.permission_createSuccess),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Create permission error: $e');
      debugPrint('Stack trace: $stackTrace');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.permission_createFailed}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// 권한 수정 다이얼로그
class PermissionEditDialog {
  static Future<void> show(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    Permission permission,
  ) async {
    debugPrint('Opening edit dialog for permission: ${permission.id}');
    final nameController = TextEditingController(text: permission.name);
    final descriptionController = TextEditingController(
      text: permission.description ?? '',
    );
    bool isActive = permission.isActive;

    await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (builderContext, setState) => AlertDialog(
          title: Text(l10n.common_edit),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: l10n.permission_code,
                    border: const OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: permission.code),
                ),
                const SizedBox(height: AppSizes.spaceM),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: l10n.permission_name,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSizes.spaceM),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: l10n.permission_description,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: AppSizes.spaceM),
                TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: l10n.permission_category,
                    border: const OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: permission.category),
                ),
                const SizedBox(height: AppSizes.spaceM),
                SwitchListTile(
                  title: Text(l10n.permission_status),
                  subtitle: Text(
                    isActive
                        ? l10n.permission_active
                        : l10n.permission_inactive,
                  ),
                  value: isActive,
                  onChanged: (value) {
                    setState(() {
                      isActive = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.common_cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty) {
                  ScaffoldMessenger.of(builderContext).showSnackBar(
                    SnackBar(
                      content: Text(l10n.permission_codeAndNameRequired),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                Navigator.pop(dialogContext);

                await _performUpdate(
                  context,
                  ref,
                  l10n,
                  permission,
                  nameController.text,
                  descriptionController.text.isEmpty
                      ? null
                      : descriptionController.text,
                  isActive,
                );
              },
              child: Text(l10n.common_save),
            ),
          ],
        ),
      ),
    );

    nameController.dispose();
    descriptionController.dispose();
  }

  static Future<void> _performUpdate(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    Permission permission,
    String name,
    String? description,
    bool isActive,
  ) async {
    debugPrint('Updating permission: ${permission.id}');
    try {
      final notifier = ref.read(permissionManagementProvider.notifier);
      debugPrint('Calling API: updatePermission');
      final updatedPermission = await notifier.updatePermission(
        permission.id,
        name: name,
        description: description,
        isActive: isActive,
      );
      debugPrint('Permission updated: ${updatedPermission.id}');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.permission_updateSuccess),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Update permission error: $e');
      debugPrint('Stack trace: $stackTrace');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.permission_updateFailed}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// 권한 삭제 확인 다이얼로그
class PermissionDeleteDialog {
  static Future<void> show(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    Permission permission,
  ) async {
    debugPrint('Opening delete dialog for permission: ${permission.id}');

    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.permission_deleteConfirm),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.permission_deleteMessage(permission.name)),
            const SizedBox(height: AppSizes.spaceM),
            Text(
              l10n.permission_deleteSoftDescription,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: AppSizes.spaceS),
            Text(
              l10n.permission_deleteHardDescription,
              style: const TextStyle(fontSize: 12, color: Colors.red),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              debugPrint('Cancel button pressed in delete dialog');
              Navigator.pop(dialogContext);
            },
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () async {
              debugPrint('Soft delete button pressed');
              Navigator.pop(dialogContext);
              await _performDelete(context, ref, l10n, permission, false);
            },
            child: Text(l10n.permission_softDelete),
          ),
          TextButton(
            onPressed: () async {
              debugPrint('Hard delete button pressed');
              Navigator.pop(dialogContext);
              await _performDelete(context, ref, l10n, permission, true);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.permission_hardDelete),
          ),
        ],
      ),
    );
  }

  static Future<void> _performDelete(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    Permission permission,
    bool isHardDelete,
  ) async {
    debugPrint('Deleting permission: ${permission.id} (hard: $isHardDelete)');
    final notifier = ref.read(permissionManagementProvider.notifier);

    bool success;
    try {
      if (isHardDelete) {
        debugPrint('Calling API: hardDeletePermission');
        success = await notifier.hardDeletePermission(permission.id);
      } else {
        debugPrint('Calling API: deletePermission');
        success = await notifier.deletePermission(permission.id);
      }
      debugPrint('Delete result: $success');
    } catch (e, stackTrace) {
      debugPrint('Delete permission error: $e');
      debugPrint('Stack trace: $stackTrace');
      success = false;
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? l10n.permission_deleteSuccess
                : l10n.permission_deleteFailed,
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }
}

/// 권한 상세 다이얼로그
class PermissionDetailDialog {
  static Future<void> show(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    Permission permission,
  ) async {
    debugPrint('Opening permission detail dialog for: ${permission.id}');
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(permission.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow(l10n.permission_code, permission.code),
              const SizedBox(height: AppSizes.spaceS),
              _buildDetailRow(l10n.permission_name, permission.name),
              const SizedBox(height: AppSizes.spaceS),
              _buildDetailRow(l10n.permission_category, permission.category),
              const SizedBox(height: AppSizes.spaceS),
              _buildDetailRow(
                l10n.permission_status,
                permission.isActive
                    ? l10n.permission_active
                    : l10n.permission_inactive,
              ),
              if (permission.description != null &&
                  permission.description!.isNotEmpty) ...[
                const SizedBox(height: AppSizes.spaceS),
                _buildDetailRow(
                    l10n.permission_description, permission.description!),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.common_close),
          ),
          TextButton.icon(
            onPressed: () {
              debugPrint('Edit button pressed for permission: ${permission.id}');
              Navigator.pop(context);
              PermissionEditDialog.show(context, ref, l10n, permission);
            },
            icon: const Icon(Icons.edit),
            label: Text(l10n.common_edit),
          ),
          TextButton.icon(
            onPressed: () {
              debugPrint(
                  'Delete button pressed for permission: ${permission.id}');
              Navigator.pop(context);
              PermissionDeleteDialog.show(context, ref, l10n, permission);
            },
            icon: const Icon(Icons.delete),
            label: Text(l10n.common_delete),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  static Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }
}
