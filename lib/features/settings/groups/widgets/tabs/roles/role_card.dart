import 'package:flutter/material.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/widgets/reorderable_widgets.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/settings/groups/models/group_member.dart';
import 'package:family_planner/features/settings/groups/utils/group_utils.dart';

/// 역할 카드
class RoleCard extends StatelessWidget {
  final Role role;
  final bool hasCustomDefaultRole;
  final bool isOwner;
  final bool canManageRole;
  final VoidCallback? onTap;

  const RoleCard({
    super.key,
    required this.role,
    required this.hasCustomDefaultRole,
    required this.isOwner,
    required this.canManageRole,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final isCustomRole = role.groupId != null;
    final canEdit = canManageRole && isCustomRole;
    final showDragHandle = canManageRole && isCustomRole;
    // groupId가 null이 아닌 항목에 기본 역할이 있으면, null인 항목의 기본 역할은 숨김
    final showDefaultBadge =
        role.isDefaultRole && (!hasCustomDefaultRole || role.groupId != null);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Row(
            children: [
              // MANAGE_ROLE 권한이 있고 그룹별 커스텀 역할인 경우만 드래그 핸들 표시
              if (showDragHandle) ...[
                const DragHandleIcon(),
                const SizedBox(width: AppSizes.spaceM),
              ],
              CircleAvatar(
                backgroundColor: role.color != null
                    ? Color(
                        int.parse(role.color!.substring(1), radix: 16) +
                            0xFF000000,
                      )
                    : Colors.grey,
                child: Icon(
                  GroupUtils.getRoleIcon(role.name),
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSizes.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            GroupUtils.getRoleName(l10n, role.name),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (showDefaultBadge)
                          Container(
                            margin: const EdgeInsets.only(
                              left: AppSizes.spaceS,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.spaceS,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '기본 역할',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.blue[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (role.permissions.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        '권한: ${role.permissions.length}개',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (canEdit)
                const Icon(Icons.edit, size: 20, color: Colors.grey)
              else if (!isCustomRole)
                const Icon(Icons.lock, size: 20, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
