import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/settings/groups/models/group_member.dart';
import 'package:family_planner/features/settings/groups/widgets/common_widgets.dart';
import 'package:family_planner/features/settings/groups/widgets/role_management_dialogs.dart';
import 'package:family_planner/features/settings/groups/utils/group_utils.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';

/// 그룹 역할 탭
class RolesTab extends ConsumerStatefulWidget {
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
  ConsumerState<RolesTab> createState() => _RolesTabState();
}

class _RolesTabState extends ConsumerState<RolesTab> {
  List<Role>? _reorderedRoles;
  bool _hasChanges = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return widget.rolesAsync.when(
      loading: () => const LoadingView(),
      error: (error, stack) => ErrorView(
        message: '역할 목록을 불러올 수 없습니다\n$error',
        onRetry: widget.onRetry,
      ),
      data: (roles) {
        return Column(
          children: [
            // 저장 버튼 (변경사항이 있을 때만 표시)
            if (_hasChanges)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceM,
                  vertical: AppSizes.spaceS,
                ),
                color: theme.colorScheme.primaryContainer,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '순서가 변경되었습니다',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _cancelReorder,
                      child: const Text('취소'),
                    ),
                    const SizedBox(width: AppSizes.spaceS),
                    ElevatedButton(
                      onPressed: _saveSortOrder,
                      child: const Text('저장'),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: _buildRoleList(context, ref, l10n, theme, roles),
            ),
          ],
        );
      },
    );
  }

  /// 역할 목록
  Widget _buildRoleList(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    ThemeData theme,
    List<Role> roles,
  ) {
    final displayRoles = _reorderedRoles ?? roles;

    if (displayRoles.isEmpty) {
      return _buildEmptyContent(context, ref, l10n, theme);
    }

    // 항상 ReorderableListView 사용 (드래그 앤 드롭 항상 가능)
    return ReorderableListView.builder(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      itemCount: displayRoles.length,
      buildDefaultDragHandles: false, // 기본 드래그 핸들 비활성화
      proxyDecorator: (child, index, animation) {
        return Material(
          elevation: 8.0,
          borderRadius: BorderRadius.circular(12),
          child: child,
        );
      },
      onReorder: (oldIndex, newIndex) {
        setState(() {
          // 처음 변경 시 복사본 생성
          _reorderedRoles ??= List.from(displayRoles);

          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final item = _reorderedRoles!.removeAt(oldIndex);
          _reorderedRoles!.insert(newIndex, item);

          // 변경사항 표시
          _hasChanges = true;
        });
      },
      header: Column(
        children: [
          _buildHeader(context, ref, l10n, theme),
          const SizedBox(height: AppSizes.spaceM),
        ],
      ),
      footer: Column(
        children: [
          const SizedBox(height: AppSizes.spaceM),
          _buildInfoCard(theme, widget.isOwner),
        ],
      ),
      itemBuilder: (context, index) {
        final role = displayRoles[index];
        return ReorderableDragStartListener(
          key: ValueKey(role.id),
          index: index,
          child: _buildRoleCard(context, l10n, theme, role),
        );
      },
    );
  }

  /// 빈 콘텐츠 (헤더 + 빈 상태 + 정보 카드)
  Widget _buildEmptyContent(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return ListView(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      children: [
        _buildHeader(context, ref, l10n, theme),
        const SizedBox(height: AppSizes.spaceM),
        _buildEmptyState(theme),
        const SizedBox(height: AppSizes.spaceM),
        _buildInfoCard(theme, widget.isOwner),
      ],
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
                if (widget.isOwner)
                  ElevatedButton.icon(
                    onPressed: () => GroupRoleCreateDialog.show(
                      context,
                      ref,
                      l10n,
                      widget.groupId,
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
    final canEdit = widget.isOwner && isCustomRole;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
      child: InkWell(
        onTap: canEdit ? () => _showRoleOptions(context, l10n, role) : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Row(
            children: [
              const Icon(
                Icons.drag_handle,
                color: Colors.grey,
              ),
              const SizedBox(width: AppSizes.spaceM),
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
                widget.onEditRole(role);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('역할 삭제', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                widget.onDeleteRole(role);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 순서 변경 취소
  void _cancelReorder() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('순서 변경 취소'),
        content: const Text('변경한 순서를 취소하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('아니오'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _reorderedRoles = null;
                _hasChanges = false;
              });
            },
            child: const Text('예'),
          ),
        ],
      ),
    );
  }

  /// 정렬 순서 저장
  Future<void> _saveSortOrder() async {
    if (_reorderedRoles == null) return;

    // 확인 다이얼로그
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('순서 저장'),
        content: const Text('변경한 순서를 저장하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('저장'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final sortOrders = <String, int>{};
      for (var i = 0; i < _reorderedRoles!.length; i++) {
        sortOrders[_reorderedRoles![i].id] = i;
      }

      // API 호출만 수행 (성공 시 빈 응답)
      await ref
          .read(groupNotifierProvider.notifier)
          .updateGroupRoleSortOrders(widget.groupId, sortOrders);

      if (mounted) {
        // 성공하면 로컬 상태만 초기화 (provider는 자동으로 invalidate됨)
        setState(() {
          _reorderedRoles = null;
          _hasChanges = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('정렬 순서가 저장되었습니다')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('저장 실패: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
