import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/models/group_member.dart';
import 'package:family_planner/features/settings/groups/widgets/tabs/settings/group_info_card.dart';
import 'package:family_planner/features/settings/groups/widgets/tabs/settings/invite_code_card.dart';
import 'package:family_planner/features/settings/groups/widgets/tabs/settings/color_setting_card.dart';
import 'package:family_planner/features/settings/groups/widgets/tabs/settings/delete_group_card.dart';
import 'package:family_planner/features/settings/groups/widgets/tabs/settings/leave_group_card.dart';

/// 그룹 설정 탭
class SettingsTab extends ConsumerWidget {
  final Group group;
  final AsyncValue<List<GroupMember>> membersAsync;
  final bool canManage;
  final VoidCallback onRegenerateCode;
  final Function(Color color) onColorChange;
  final VoidCallback onResetColor;

  const SettingsTab({
    super.key,
    required this.group,
    required this.membersAsync,
    required this.canManage,
    required this.onRegenerateCode,
    required this.onColorChange,
    required this.onResetColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 권한 확인 - Group 모델의 myRole에서 확인
    final canInviteMember = group.hasPermission('INVITE_MEMBER');
    final canDeleteGroup = group.hasPermission('DELETE_GROUP');
    final canUpdateGroup = group.hasPermission('UPDATE_GROUP');
    final isOwner = group.myRole?.name == 'OWNER';

    return ListView(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      children: [
        GroupInfoCard(group: group, canUpdate: canUpdateGroup),
        const SizedBox(height: AppSizes.spaceM),
        if (canInviteMember) ...[
          InviteCodeCard(
            group: group,
            canManage: canManage,
            onRegenerateCode: onRegenerateCode,
          ),
          const SizedBox(height: AppSizes.spaceM),
        ],
        ColorSettingCard(
          group: group,
          membersAsync: membersAsync,
          onColorChange: onColorChange,
          onResetColor: onResetColor,
        ),
        // OWNER가 아닌 경우에만 그룹 나가기 표시
        if (!isOwner) ...[
          const SizedBox(height: AppSizes.spaceM),
          LeaveGroupCard(group: group),
        ],
        // OWNER만 그룹 삭제 가능
        if (canDeleteGroup) ...[
          const SizedBox(height: AppSizes.spaceM),
          DeleteGroupCard(group: group),
        ],
      ],
    );
  }
}
