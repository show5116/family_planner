import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/widgets/color_picker.dart';
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
    Color? selectedColor;

    await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Consumer(
        builder: (consumerContext, consumerRef, child) {
          // 권한 목록을 watch하여 로딩 상태 확인
          final permissionsState = consumerRef.watch(permissionManagementProvider);
          final allPermissions = permissionsState.permissions;
          final isLoadingPermissions = permissionsState.isLoading;

          return StatefulBuilder(
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
                          '역할 색상',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppSizes.spaceS),
                        ColorPicker(
                          selectedColor: selectedColor,
                          onColorSelected: (color) {
                            setState(() {
                              selectedColor = color;
                            });
                          },
                          showRgbInput: false,
                          showAdvancedPicker: false,
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
                        // 권한 로딩 중이면 스피너 표시
                        if (isLoadingPermissions)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(AppSizes.spaceM),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else
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
                        selectedColor != null
                            ? '#${selectedColor!.toARGB32().toRadixString(16).substring(2).toUpperCase()}'
                            : null,
                      );
                    },
                    child: Text(l10n.common_create),
                  ),
                ],
              );
            },
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
    String? color,
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
        color: color,
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
    Color? selectedColor = role.color != null
        ? Color(int.parse(role.color!.substring(1), radix: 16) + 0xFF000000)
        : null;

    await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Consumer(
        builder: (consumerContext, consumerRef, child) {
          // 권한 목록을 watch하여 로딩 상태 확인
          final permissionsState = consumerRef.watch(permissionManagementProvider);
          final allPermissions = permissionsState.permissions;
          final isLoadingPermissions = permissionsState.isLoading;

          return StatefulBuilder(
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
                        '역할 색상',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSizes.spaceS),
                      ColorPicker(
                        selectedColor: selectedColor,
                        onColorSelected: (color) {
                          setState(() {
                            selectedColor = color;
                          });
                        },
                        showRgbInput: false,
                        showAdvancedPicker: false,
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
                      // 권한 로딩 중이면 스피너 표시
                      if (isLoadingPermissions)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(AppSizes.spaceM),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else
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
                      selectedColor != null
                          ? '#${selectedColor!.toARGB32().toRadixString(16).substring(2).toUpperCase()}'
                          : null,
                    );
                  },
                  child: Text(l10n.common_save),
                ),
              ],
            ),
          );
        },
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
    String? color,
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
        color: color,
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

/// 그룹 역할 조회 전용 다이얼로그
class GroupRoleViewDialog {
  static Future<void> show(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    Role role,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => Consumer(
        builder: (consumerContext, consumerRef, child) {
          final permissionsState = consumerRef.watch(permissionManagementProvider);
          final allPermissions = permissionsState.permissions;
          final isLoadingPermissions = permissionsState.isLoading;

          return AlertDialog(
            title: Text(role.name),
            content: SingleChildScrollView(
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                // 기본 역할 표시
                if (role.isDefaultRole)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spaceM,
                      vertical: AppSizes.spaceS,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.blue[700]),
                        const SizedBox(width: AppSizes.spaceS),
                        Text(
                          '기본 역할 (새 멤버 가입 시 자동 부여)',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (role.isDefaultRole) const SizedBox(height: AppSizes.spaceM),

                // 역할 색상 표시
                if (role.color != null) ...[
                  const Text(
                    '역할 색상',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceS),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(
                        int.parse(role.color!.substring(1), radix: 16) +
                            0xFF000000,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceM),
                ],

                // 권한 목록 표시
                const Text(
                  '권한 목록',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSizes.spaceS),
                if (isLoadingPermissions)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSizes.spaceM),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (role.permissions.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSizes.spaceM),
                    child: Text(
                      '권한이 없습니다',
                      style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                else
                  ...allPermissions.map((permission) {
                    final hasPermission = role.permissions.contains(permission.code);
                    return ListTile(
                      dense: true,
                      leading: Icon(
                        hasPermission ? Icons.check_circle : Icons.cancel,
                        color: hasPermission ? Colors.green : Colors.grey[300],
                        size: 20,
                      ),
                      title: Text(
                        permission.name,
                        style: TextStyle(
                          color: hasPermission ? Colors.black : Colors.grey,
                        ),
                      ),
                      subtitle: Text(
                        permission.code,
                        style: TextStyle(
                          fontSize: 12,
                          color: hasPermission ? Colors.grey[600] : Colors.grey[400],
                        ),
                      ),
                    );
                  }),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(l10n.common_close),
              ),
            ],
          );
        },
      ),
    );
  }
}
