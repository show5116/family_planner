import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/widgets/color_picker.dart';
import 'package:family_planner/core/utils/error_handler.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/models/group_member.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/features/settings/groups/utils/group_utils.dart';

/// 그룹 관련 다이얼로그 유틸리티
class GroupDialogs {
  /// 초대 코드 재생성 다이얼로그
  static Future<void> showRegenerateCodeDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String groupId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.group_regenerateCode),
        content: const Text('초대 코드를 재생성하시겠습니까?\n기존 초대 코드는 사용할 수 없게 됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.group_cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.group_confirm),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref
            .read(groupNotifierProvider.notifier)
            .regenerateInviteCode(groupId);
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.group_codeRegenerated)));
        }
      } catch (e) {
        if (context.mounted) {
          ErrorHandler.showErrorSnackBar(context, e);
        }
      }
    }
  }

  /// 멤버 초대 다이얼로그
  static void showInviteMemberDialog(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.group_inviteByEmail),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: l10n.group_email,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 8),
            Text(
              '초대 코드를 공유하거나 이메일로 직접 초대할 수 있습니다.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.group_cancel),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: 이메일 초대 기능은 백엔드 API 추가 필요
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('이메일 초대 기능은 개발 중입니다. 초대 코드를 공유해주세요.'),
                ),
              );
            },
            child: Text(l10n.group_send),
          ),
        ],
      ),
    );
  }

  /// 멤버 삭제 다이얼로그
  static Future<void> showRemoveMemberDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String groupId,
    GroupMember member,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.group_delete),
        content: Text('${member.user?.name ?? 'Unknown'} 님을 그룹에서 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.group_cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.group_delete),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref
            .read(groupNotifierProvider.notifier)
            .removeMember(groupId, member.userId);
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('멤버가 삭제되었습니다')));
        }
      } catch (e) {
        if (context.mounted) {
          ErrorHandler.showErrorSnackBar(context, e);
        }
      }
    }
  }

  /// 역할 변경 다이얼로그
  static Future<void> showChangeRoleDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String groupId,
    GroupMember member,
  ) async {
    final rolesAsync = ref.read(groupRolesProvider(groupId));

    final result = await showDialog<String>(
      context: context,
      builder: (context) => rolesAsync.when(
        loading: () => AlertDialog(
          title: Text(l10n.group_role),
          content: const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          ),
        ),
        error: (error, stack) => AlertDialog(
          title: Text(l10n.group_role),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('역할 목록을 불러올 수 없습니다:\n$error'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.group_cancel),
            ),
          ],
        ),
        data: (roles) {
          String? selectedRoleId = member.roleId;

          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              title: Text(l10n.group_role),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${member.user?.name ?? 'Unknown'}님의 역할을 변경합니다.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ...roles.map((role) {
                    // OWNER 역할은 양도만 가능하므로 선택지에서 제외
                    if (role.name == 'OWNER') return const SizedBox.shrink();

                    return RadioListTile<String>(
                      title: Text(GroupUtils.getRoleName(l10n, role.name)),
                      subtitle: Text(role.name),
                      value: role.id,
                      groupValue: selectedRoleId,
                      onChanged: (value) {
                        setState(() {
                          selectedRoleId = value;
                        });
                      },
                    );
                  }),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.group_cancel),
                ),
                ElevatedButton(
                  onPressed:
                      selectedRoleId != null && selectedRoleId != member.roleId
                      ? () => Navigator.pop(context, selectedRoleId)
                      : null,
                  child: Text(l10n.group_save),
                ),
              ],
            ),
          );
        },
      ),
    );

    if (result != null && context.mounted) {
      try {
        await ref
            .read(groupNotifierProvider.notifier)
            .updateMemberRole(groupId, member.userId, result);
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('역할이 변경되었습니다')));
        }
      } catch (e) {
        if (context.mounted) {
          ErrorHandler.showErrorSnackBar(context, e);
        }
      }
    }
  }

  /// 그룹 수정 다이얼로그
  static Future<void> showEditGroupDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    Group group,
  ) async {
    final nameController = TextEditingController(text: group.name);
    final descriptionController = TextEditingController(
      text: group.description,
    );

    // 초기 색상 설정
    Color? selectedColor = GroupUtils.parseColor(group.defaultColor);

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.group_editGroup),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: l10n.group_groupName,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSizes.spaceM),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: l10n.group_groupDescription,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: AppSizes.spaceM),
                // 색상 선택 섹션
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.group_defaultColor,
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    ColorPicker(
                      selectedColor: selectedColor,
                      onColorSelected: (color) {
                        setState(() => selectedColor = color);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.group_cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, {
                'name': nameController.text,
                'description': descriptionController.text,
                'color': selectedColor,
              }),
              child: Text(l10n.group_save),
            ),
          ],
        ),
      ),
    );

    if (result == null) {
      return;
    }

    // context.mounted 체크를 하지 않고 바로 API 호출
    try {
      final String? colorHex = result['color'] != null
          ? GroupUtils.colorToHex(result['color'] as Color)
          : null;

      await ref
          .read(groupNotifierProvider.notifier)
          .updateGroup(
            group.id,
            name: result['name'] as String,
            description: result['description'] as String,
            defaultColor: colorHex,
          );

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.group_updateSuccess)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('오류: $e')));
      }
    }
  }

  /// 그룹 삭제 다이얼로그
  static Future<void> showDeleteGroupDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String groupId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.group_deleteConfirmTitle),
        content: Text(l10n.group_deleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.group_cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.group_delete),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(groupNotifierProvider.notifier).deleteGroup(groupId);
        if (context.mounted) {
          Navigator.pop(context); // 그룹 상세 화면 닫기
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.group_deleteSuccess)));
        }
      } catch (e) {
        if (context.mounted) {
          ErrorHandler.showErrorSnackBar(context, e);
        }
      }
    }
  }

  /// 그룹 탈퇴 다이얼로그
  static Future<void> showLeaveGroupDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String groupId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.group_leaveConfirmTitle),
        content: Text(l10n.group_leaveConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.group_cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.group_leave),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(groupNotifierProvider.notifier).leaveGroup(groupId);
        if (context.mounted) {
          Navigator.pop(context); // 그룹 상세 화면 닫기
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.group_leaveSuccess)));
        }
      } catch (e) {
        if (context.mounted) {
          ErrorHandler.showErrorSnackBar(context, e);
        }
      }
    }
  }

  /// 설정 메뉴 BottomSheet
  static void showSettingsBottomSheet(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    Group group,
    bool canManage,
    bool isOwner,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (canManage)
              ListTile(
                leading: const Icon(Icons.edit),
                title: Text(l10n.group_editGroup),
                onTap: () {
                  Navigator.pop(context);
                  showEditGroupDialog(context, ref, l10n, group);
                },
              ),
            if (isOwner)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text(
                  l10n.group_deleteGroup,
                  style: const TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showDeleteGroupDialog(context, ref, l10n, group.id);
                },
              ),
            if (!isOwner)
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.orange),
                title: Text(
                  l10n.group_leaveGroup,
                  style: const TextStyle(color: Colors.orange),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showLeaveGroupDialog(context, ref, l10n, group.id);
                },
              ),
          ],
        ),
      ),
    );
  }
}
