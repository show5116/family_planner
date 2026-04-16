import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/widgets/reorderable_widgets.dart';
import 'package:family_planner/core/utils/error_handler.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/models/group_member.dart';
import 'package:family_planner/features/settings/groups/presentation/widgets/common_widgets.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/features/settings/groups/presentation/widgets/tabs/roles/role_card.dart';
import 'package:family_planner/features/settings/groups/presentation/widgets/tabs/roles/role_header.dart';
import 'package:family_planner/features/settings/groups/presentation/widgets/tabs/roles/role_info_card.dart';
import 'package:family_planner/features/settings/groups/presentation/widgets/role_management_dialogs.dart';

/// 그룹 역할 탭
class RolesTab extends ConsumerStatefulWidget {
  final Group group;
  final String groupId;
  final AsyncValue<List<Role>> rolesAsync;
  final List<GroupMember> members;
  final bool isOwner;
  final bool canManageRole;
  final VoidCallback onRetry;
  final Function(Role role) onEditRole;
  final Function(Role role) onDeleteRole;

  const RolesTab({
    super.key,
    required this.group,
    required this.groupId,
    required this.rolesAsync,
    required this.members,
    required this.isOwner,
    required this.canManageRole,
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

    return widget.rolesAsync.when(
      loading: () => const LoadingView(),
      error: (error, stack) => ErrorView(
        message: '역할 목록을 불러올 수 없습니다\n${ErrorHandler.getErrorMessage(error)}',
        onRetry: widget.onRetry,
      ),
      data: (roles) {
        return Column(
          children: [
            // 저장 버튼 (변경사항이 있을 때만 표시)
            if (_hasChanges)
              ReorderChangesBar(
                onSave: _saveSortOrder,
                onCancel: _cancelReorder,
              ),
            Expanded(child: _buildRoleList(context, l10n, roles)),
          ],
        );
      },
    );
  }

  /// 역할 목록
  Widget _buildRoleList(
    BuildContext context,
    AppLocalizations l10n,
    List<Role> roles,
  ) {
    final displayRoles = _reorderedRoles ?? roles;

    if (displayRoles.isEmpty) {
      return _buildEmptyContent(context, l10n);
    }

    // groupId가 null이 아닌 항목에 기본 역할이 있는지 확인
    final hasCustomDefaultRole = displayRoles.any(
      (role) => role.groupId != null && role.isDefaultRole,
    );

    // 항상 ReorderableListView 사용 (드래그 앤 드롭 항상 가능)
    return ReorderableListView.builder(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      itemCount: displayRoles.length,
      buildDefaultDragHandles: false, // 기본 드래그 핸들 비활성화
      proxyDecorator: buildReorderableProxyDecorator,
      onReorder: (oldIndex, newIndex) {
        if (newIndex > oldIndex) newIndex -= 1;

        // 이동 대상(oldIndex)이나 목적지(newIndex) 중 하나라도 고정 항목이면 무시
        final movingRole = displayRoles[oldIndex];
        final targetRole = displayRoles[newIndex];
        if (movingRole.groupId == null || targetRole.groupId == null) return;

        setState(() {
          _reorderedRoles ??= List.from(displayRoles);
          final item = _reorderedRoles!.removeAt(oldIndex);
          _reorderedRoles!.insert(newIndex, item);
          _hasChanges = true;
        });
      },
      header: Column(
        children: [
          RoleHeader(isOwner: widget.isOwner),
          const SizedBox(height: AppSizes.spaceM),
        ],
      ),
      footer: Column(
        children: [
          const SizedBox(height: AppSizes.spaceM),
          RoleInfoCard(isOwner: widget.isOwner),
        ],
      ),
      itemBuilder: (context, index) {
        final role = displayRoles[index];
        return RoleCard(
          key: ValueKey(role.id),
          role: role,
          index: index,
          hasCustomDefaultRole: hasCustomDefaultRole,
          isOwner: widget.isOwner,
          canManageRole: widget.canManageRole,
          onTap: () => _handleRoleTap(context, l10n, role),
        );
      },
    );
  }

  /// 빈 콘텐츠 (헤더 + 빈 상태 + 정보 카드)
  Widget _buildEmptyContent(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      children: [
        RoleHeader(isOwner: widget.isOwner),
        const SizedBox(height: AppSizes.spaceM),
        _buildEmptyState(theme),
        const SizedBox(height: AppSizes.spaceM),
        RoleInfoCard(isOwner: widget.isOwner),
      ],
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
            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }

  /// 역할 카드 탭 처리
  void _handleRoleTap(
    BuildContext context,
    AppLocalizations l10n,
    Role role,
  ) {
    // 고정 역할(groupId == null)은 조회만 가능 — 운영자 전용 수정 항목
    if (role.groupId == null) {
      GroupRoleViewDialog.show(context, ref, l10n, role);
      return;
    }

    // 커스텀 역할 + MANAGE_ROLE 권한이 있으면 편집/삭제 옵션 표시
    if (widget.canManageRole) {
      _showRoleOptions(context, l10n, role);
      return;
    }

    // 권한이 없는 경우 조회만
    GroupRoleViewDialog.show(context, ref, l10n, role);
  }

  /// 역할 옵션 표시 (편집/삭제)
  void _showRoleOptions(
    BuildContext context,
    AppLocalizations l10n,
    Role role,
  ) {
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
  Future<void> _cancelReorder() async {
    final confirmed = await showReorderCancelDialog(context);
    if (confirmed && mounted) {
      setState(() {
        _reorderedRoles = null;
        _hasChanges = false;
      });
    }
  }

  /// 정렬 순서 저장
  Future<void> _saveSortOrder() async {
    if (_reorderedRoles == null) return;

    // 확인 다이얼로그
    final confirm = await showReorderSaveDialog(context);
    if (!confirm) return;

    try {
      final sortOrders = <String, int>{};
      var sortIndex = 0;
      // groupId가 null이 아닌 항목만 정렬 순서에 포함
      for (var i = 0; i < _reorderedRoles!.length; i++) {
        final role = _reorderedRoles![i];
        if (role.groupId != null) {
          sortOrders[role.id] = sortIndex++;
        }
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

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('정렬 순서가 저장되었습니다')));
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showErrorSnackBar(context, e);
      }
    }
  }
}
