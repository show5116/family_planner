import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/settings/groups/models/group_member.dart';
import 'package:family_planner/features/settings/groups/widgets/common_widgets.dart';
import 'package:family_planner/features/settings/groups/widgets/role_management_dialogs.dart';
import 'package:family_planner/features/settings/groups/utils/group_utils.dart';

/// 그룹 역할 탭
class RolesTab extends ConsumerWidget {
  final String groupId;
  final AsyncValue<List<Role>> rolesAsync;
  final bool isOwner;
  final VoidCallback onRetry;
  final Function(Role role) onEditRole;
  final Function(Role role) onDeleteRole;

  const RolesTab({
    super.key,
    required this.groupId,
    required this.rolesAsync,
    required this.isOwner,
    required this.onRetry,
    required this.onEditRole,
    required this.onDeleteRole,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return rolesAsync.when(
      loading: () => const LoadingView(),
      error: (error, stack) => ErrorView(
        message: '역할 목록을 불러올 수 없습니다\n$error',
        onRetry: onRetry,
      ),
      data: (roles) => ListView(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        children: [
          _buildHeader(context, ref, l10n, theme),
          const SizedBox(height: AppSizes.spaceM),
          if (roles.isEmpty)
            _buildEmptyState(theme)
          else
            ...roles.map((role) => _buildRoleCard(context, l10n, theme, role)),
          const SizedBox(height: AppSizes.spaceM),
          _buildInfoCard(theme, isOwner),
        ],
      ),
    );
  }

  /// 헤더 (제목 + 역할 추가 버튼)
  Widget _buildHeader(BuildContext context, WidgetRef ref, AppLocalizations l10n, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.admin_panel_settings, color: theme.colorScheme.primary),
                const SizedBox(width: AppSizes.spaceS),
                Expanded(
                  child: Text(
                    '역할 관리',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isOwner)
                  ElevatedButton.icon(
                    onPressed: () => GroupRoleCreateDialog.show(
                      context,
                      ref,
                      l10n,
                      groupId,
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('역할 추가'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.spaceM,
                        vertical: AppSizes.spaceS,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceS),
            Text(
              '이 그룹의 역할 목록입니다.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 빈 상태
  Widget _buildEmptyState(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceXL),
        child: Center(
          child: Text(
            '역할이 없습니다',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  /// 역할 카드
  Widget _buildRoleCard(BuildContext context, AppLocalizations l10n, ThemeData theme, Role role) {
    final isCustomRole = role.groupId != null;
    final canEdit = isOwner && isCustomRole;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
      child: InkWell(
        onTap: canEdit ? () => _showRoleOptions(context, l10n, role) : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: GroupUtils.getRoleColor(role.name),
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
                    Text(
                      GroupUtils.getRoleName(l10n, role.name),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${role.name}',
                      style: theme.textTheme.bodySmall,
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
                    if (role.isDefaultRole)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
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
              ),
              if (canEdit)
                const Icon(Icons.edit, size: 20, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  /// 정보 카드
  Widget _buildInfoCard(ThemeData theme, bool isOwner) {
    return InfoCard(
      title: '안내',
      message: '',
      bulletPoints: [
        '공통 역할 (OWNER, ADMIN, MEMBER)은 모든 그룹에 기본으로 제공됩니다.',
        '커스텀 역할은 그룹 OWNER만 생성, 수정, 삭제할 수 있습니다.',
        if (!isOwner) '역할을 관리하려면 그룹 OWNER 권한이 필요합니다.',
      ],
      backgroundColor: Colors.blue[50],
      iconColor: Colors.blue[700],
      textColor: isOwner ? Colors.blue[900] : Colors.orange[900],
    );
  }

  /// 역할 옵션 표시
  void _showRoleOptions(BuildContext context, AppLocalizations l10n, Role role) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('역할 수정'),
              onTap: () {
                Navigator.pop(context);
                onEditRole(role);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('역할 삭제', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                onDeleteRole(role);
              },
            ),
          ],
        ),
      ),
    );
  }
}
