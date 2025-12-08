import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/settings/groups/models/group_member.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/features/settings/permissions/providers/permission_management_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 그룹 역할 생성 다이얼로그
class GroupRoleCreateDialog {
  static Future<void> show(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String groupId,
  ) async {
    final nameController = TextEditingController();
    bool isDefaultRole = false;
    List<String> selectedPermissions = [];

    // 권한 목록 로드
    final permissionsAsync = ref.read(permissionManagementProvider);
    final allPermissions = permissionsAsync.permissions;

    await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (builderContext, setState) {
          return AlertDialog(
            title: const Text('역할 생성'),
            content: SingleChildScrollView(
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: '역할 이름',
                        hintText: 'CUSTOM_ROLE',
                        border: OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.characters,
                    ),
                    const SizedBox(height: AppSizes.spaceM),
                    SwitchListTile(
                      title: const Text('기본 역할'),
                      subtitle: const Text('새 멤버 가입 시 자동 부여'),
                      value: isDefaultRole,
                      onChanged: (value) {
                        setState(() {
                          isDefaultRole = value;
                        });
                      },
                    ),
                    const SizedBox(height: AppSizes.spaceM),
                    const Text(
                      '권한 선택',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceS),
                    ...allPermissions.map((permission) {
                      final isSelected = selectedPermissions.contains(permission.code);
                      return CheckboxListTile(
                        title: Text(permission.name),
                        subtitle: Text(permission.code),
                        value: isSelected,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              selectedPermissions.add(permission.code);
                            } else {
                              selectedPermissions.remove(permission.code);
                            }
                          });
                        },
                      );
                    }),
                  ],
                ),
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
                      const SnackBar(
                        content: Text('역할 이름을 입력해주세요'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  Navigator.pop(dialogContext);

                  await _performCreate(
                    context,
                    ref,
                    l10n,
                    groupId,
                    nameController.text.toUpperCase(),
                    selectedPermissions,
                    isDefaultRole,
                  );
                },
                child: Text(l10n.common_create),
              ),
            ],
          );
        },
      ),
    );

    nameController.dispose();
  }

  static Future<void> _performCreate(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String groupId,
    String name,
    List<String> permissions,
    bool isDefaultRole,
  ) async {
    debugPrint('Creating group role...');
    try {
      final notifier = ref.read(groupNotifierProvider.notifier);
      debugPrint('Calling API: createGroupRole');
      final createdRole = await notifier.createGroupRole(
        groupId,
        name: name,
        permissions: permissions,
        isDefaultRole: isDefaultRole,
      );
      debugPrint('Role created: ${createdRole.id}');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('역할이 생성되었습니다'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Create role error: $e');
      debugPrint('Stack trace: $stackTrace');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('역할 생성 실패: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// 그룹 역할 수정 다이얼로그
class GroupRoleEditDialog {
  static Future<void> show(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String groupId,
    Role role,
  ) async {
    debugPrint('Opening edit dialog for role: ${role.id}');
    final nameController = TextEditingController(text: role.name);
    bool isDefaultRole = role.isDefaultRole;
    List<String> selectedPermissions = List.from(role.permissions);

    // 권한 목록 로드
    final permissionsAsync = ref.read(permissionManagementProvider);
    final allPermissions = permissionsAsync.permissions;

    await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (builderContext, setState) => AlertDialog(
          title: const Text('역할 수정'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: '역할 이름',
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.characters,
                  ),
                  const SizedBox(height: AppSizes.spaceM),
                  SwitchListTile(
                    title: const Text('기본 역할'),
                    subtitle: const Text('새 멤버 가입 시 자동 부여'),
                    value: isDefaultRole,
                    onChanged: (value) {
                      setState(() {
                        isDefaultRole = value;
                      });
                    },
                  ),
                  const SizedBox(height: AppSizes.spaceM),
                  const Text(
                    '권한 선택',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceS),
                  ...allPermissions.map((permission) {
                    final isSelected = selectedPermissions.contains(permission.code);
                    return CheckboxListTile(
                      title: Text(permission.name),
                      subtitle: Text(permission.code),
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            selectedPermissions.add(permission.code);
                          } else {
                            selectedPermissions.remove(permission.code);
                          }
                        });
                      },
                    );
                  }),
                ],
              ),
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
                    const SnackBar(
                      content: Text('역할 이름을 입력해주세요'),
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
                  groupId,
                  role.id,
                  nameController.text.toUpperCase(),
                  selectedPermissions,
                  isDefaultRole,
                );
              },
              child: Text(l10n.common_save),
            ),
          ],
        ),
      ),
    );

    nameController.dispose();
  }

  static Future<void> _performUpdate(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String groupId,
    String roleId,
    String name,
    List<String> permissions,
    bool isDefaultRole,
  ) async {
    debugPrint('Updating role: $roleId');
    try {
      final notifier = ref.read(groupNotifierProvider.notifier);
      debugPrint('Calling API: updateGroupRole');
      final updatedRole = await notifier.updateGroupRole(
        groupId,
        roleId,
        name: name,
        permissions: permissions,
        isDefaultRole: isDefaultRole,
      );
      debugPrint('Role updated: ${updatedRole.id}');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('역할이 수정되었습니다'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Update role error: $e');
      debugPrint('Stack trace: $stackTrace');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('역할 수정 실패: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// 그룹 역할 삭제 확인 다이얼로그
class GroupRoleDeleteDialog {
  static Future<void> show(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String groupId,
    Role role,
  ) async {
    debugPrint('Opening delete dialog for role: ${role.id}');

    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('역할 삭제'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${role.name} 역할을 삭제하시겠습니까?'),
            const SizedBox(height: AppSizes.spaceM),
            const Text(
              '⚠️ 이 역할을 사용 중인 멤버가 있으면 삭제할 수 없습니다.',
              style: TextStyle(fontSize: 12, color: Colors.red),
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
          ElevatedButton(
            onPressed: () async {
              debugPrint('Delete button pressed');
              Navigator.pop(dialogContext);
              await _performDelete(context, ref, l10n, groupId, role);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.common_delete),
          ),
        ],
      ),
    );
  }

  static Future<void> _performDelete(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String groupId,
    Role role,
  ) async {
    debugPrint('Deleting role: ${role.id}');
    try {
      final notifier = ref.read(groupNotifierProvider.notifier);
      debugPrint('Calling API: deleteGroupRole');
      await notifier.deleteGroupRole(groupId, role.id);
      debugPrint('Role deleted');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('역할이 삭제되었습니다'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Delete role error: $e');
      debugPrint('Stack trace: $stackTrace');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('역할 삭제 실패: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
