import 'package:flutter/material.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/models/group_member.dart';
import 'package:family_planner/features/settings/groups/presentation/widgets/common_widgets.dart';
import 'package:family_planner/features/settings/groups/presentation/widgets/report_member_dialog.dart';
import 'package:family_planner/features/settings/groups/utils/group_utils.dart';

/// 멤버 카드 위젯
class MemberCard extends StatelessWidget {
  final Group group;
  final GroupMember member;
  final String? currentUserId;
  final VoidCallback onRemove;
  final VoidCallback onChangeRole;
  final VoidCallback? onTransferOwnership;

  const MemberCard({
    super.key,
    required this.group,
    required this.member,
    required this.currentUserId,
    required this.onRemove,
    required this.onChangeRole,
    this.onTransferOwnership,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final String roleName = GroupUtils.getRoleName(l10n, member.role?.name ?? 'MEMBER');
    final bool isOwner = member.role?.name == 'OWNER';
    final bool isCurrentUser = member.user?.id == currentUserId;

    // Group의 myRole을 사용하여 MANAGE_MEMBER 권한이 있고, 본인이 아니고, OWNER가 아닌 경우에만 메뉴 표시
    final bool canManage = group.hasPermission('MANAGE_MEMBER')
        && !isCurrentUser
        && !isOwner;

    // 현재 사용자가 OWNER이고, 대상이 본인이 아닌 경우 그룹장 양도 가능
    final bool isCurrentUserOwner = group.myRole?.name == 'OWNER';
    final bool canTransfer = isCurrentUserOwner && !isCurrentUser && onTransferOwnership != null;

    // 본인이 아닌 경우 신고 가능
    final bool canReport = !isCurrentUser;

    // 메뉴 표시 조건: MANAGE_MEMBER 권한이 있거나 그룹장 양도가 가능하거나 신고 가능한 경우
    final bool showMenu = canManage || canTransfer || canReport;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: member.user?.profileImageUrl != null
              ? NetworkImage(member.user!.profileImageUrl!)
              : null,
          child: member.user?.profileImageUrl == null
              ? Text(
                  (member.user?.name ?? 'U').substring(0, 1),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              : null,
        ),
        title: Row(
          children: [
            Text(
              member.user?.name ?? 'Unknown',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isCurrentUser) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '나',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(member.user?.email ?? ''),
            const SizedBox(height: 4),
            Row(
              children: [
                RoleBadge(
                  roleName: roleName,
                  color: member.role?.color != null
                      ? Color(
                          int.parse(member.role!.color!.substring(1), radix: 16) +
                              0xFF000000,
                        )
                      : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  '${l10n.group_joinedAt}: ${GroupUtils.formatDate(member.joinedAt)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: showMenu
            ? PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'remove') {
                    onRemove();
                  } else if (value == 'changeRole') {
                    onChangeRole();
                  } else if (value == 'transferOwnership') {
                    onTransferOwnership?.call();
                  } else if (value == 'report') {
                    showDialog<void>(
                      context: context,
                      builder: (_) => ReportMemberDialog(
                        groupId: group.id,
                        userId: member.userId,
                        userName: member.user?.name ?? 'Unknown',
                      ),
                    );
                  }
                },
                itemBuilder: (context) => [
                  // 그룹장 양도 옵션 (OWNER만, 본인이 아닌 경우)
                  if (canTransfer)
                    PopupMenuItem(
                      value: 'transferOwnership',
                      child: Row(
                        children: [
                          const Icon(Icons.swap_horiz, size: 20, color: Colors.orange),
                          const SizedBox(width: 8),
                          const Text('그룹장 양도'),
                        ],
                      ),
                    ),
                  // 역할 변경 및 삭제 옵션 (MANAGE_MEMBER 권한 있는 경우)
                  if (canManage) ...[
                    const PopupMenuItem(
                      value: 'changeRole',
                      child: Row(
                        children: [
                          Icon(Icons.manage_accounts_outlined, size: 20),
                          SizedBox(width: 8),
                          Text('역할 변경'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'remove',
                      child: Row(
                        children: [
                          Icon(Icons.person_remove_outlined, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('멤버 탈퇴', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  // 신고 옵션 (본인 제외 항상 표시)
                  if (canReport)
                    const PopupMenuItem(
                      value: 'report',
                      child: Row(
                        children: [
                          Icon(Icons.flag_outlined, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('신고하기', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                ],
              )
            : null,
      ),
    );
  }
}
