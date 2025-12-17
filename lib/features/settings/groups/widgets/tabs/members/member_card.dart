import 'package:flutter/material.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/settings/groups/models/group_member.dart';
import 'package:family_planner/features/settings/groups/widgets/common_widgets.dart';
import 'package:family_planner/features/settings/groups/utils/group_utils.dart';

/// 멤버 카드 위젯
class MemberCard extends StatelessWidget {
  final GroupMember member;
  final List<GroupMember> allMembers;
  final VoidCallback onRemove;
  final VoidCallback onChangeRole;

  const MemberCard({
    super.key,
    required this.member,
    required this.allMembers,
    required this.onRemove,
    required this.onChangeRole,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final String roleName = GroupUtils.getRoleName(l10n, member.role?.name ?? 'MEMBER');
    final bool isOwner = member.role?.name == 'OWNER';
    // 첫 번째 멤버를 현재 사용자로 간주
    final bool canManage = allMembers.isNotEmpty &&
        allMembers.first.role?.name == 'OWNER' && !isOwner;

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
        title: Text(
          member.user?.name ?? 'Unknown',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
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
                  color: GroupUtils.getRoleColor(member.role?.name ?? 'MEMBER'),
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
        trailing: canManage
            ? PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'remove') {
                    onRemove();
                  } else if (value == 'changeRole') {
                    onChangeRole();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'changeRole',
                    child: Text(l10n.group_role),
                  ),
                  PopupMenuItem(
                    value: 'remove',
                    child: Text(l10n.group_delete),
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
