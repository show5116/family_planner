import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/models/group_member.dart';
import 'package:family_planner/features/settings/groups/models/join_request.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/features/settings/groups/widgets/common_widgets.dart';
import 'package:family_planner/features/settings/groups/widgets/tabs/members/members_tab.dart';
import 'package:family_planner/features/settings/groups/widgets/tabs/settings/settings_tab.dart';
import 'package:family_planner/features/settings/groups/widgets/tabs/roles/roles_tab.dart';
import 'package:family_planner/features/settings/groups/widgets/group_dialogs.dart';
import 'package:family_planner/features/settings/groups/widgets/role_management_dialogs.dart';
import 'package:family_planner/features/settings/groups/utils/group_utils.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';

/// 그룹 상세 화면
class GroupDetailScreen extends ConsumerStatefulWidget {
  final String groupId;

  const GroupDetailScreen({
    super.key,
    required this.groupId,
  });

  @override
  ConsumerState<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends ConsumerState<GroupDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // 탭 변경 시 FAB 업데이트
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final groupAsync = ref.watch(groupDetailProvider(widget.groupId));
    final membersAsync = ref.watch(groupMembersProvider(widget.groupId));
    final authState = ref.watch(authProvider);
    final currentUserId = authState.user?['id']?.toString();

    return groupAsync.when(
      loading: () => const Scaffold(
        body: LoadingView(),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: Text(l10n.group_groupName)),
        body: ErrorView(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(groupDetailProvider(widget.groupId));
            ref.invalidate(groupMembersProvider(widget.groupId));
          },
        ),
      ),
      data: (group) {
        final canManage = membersAsync.maybeWhen(
          data: (members) => GroupUtils.canManageGroup(members, currentUserId: currentUserId),
          orElse: () => false,
        );

        final isOwner = membersAsync.maybeWhen(
          data: (members) => GroupUtils.isOwner(members, currentUserId: currentUserId),
          orElse: () => false,
        );

        // 초대 권한 확인
        final canInvite = membersAsync.maybeWhen(
          data: (members) => GroupUtils.canInviteMembers(members, currentUserId: currentUserId),
          orElse: () => false,
        );

        // 역할 관리 권한 확인
        final canManageRole = membersAsync.maybeWhen(
          data: (members) => GroupUtils.hasPermission(members, 'MANAGE_ROLE', currentUserId: currentUserId),
          orElse: () => false,
        );

        // 초대 권한이 있을 때만 가입 요청 목록 조회
        final joinRequestsAsync = canInvite
            ? ref.watch(groupJoinRequestsProvider(widget.groupId))
            : const AsyncValue<List<JoinRequest>>.data([]);

        return Scaffold(
          appBar: AppBar(
            title: Text(group.name),
            bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: l10n.group_members),
                Tab(text: l10n.group_settings),
                Tab(text: l10n.group_role),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildMembersTab(l10n, membersAsync, joinRequestsAsync),
              _buildSettingsTab(group, membersAsync, canManage),
              _buildRolesTab(isOwner, canManageRole),
            ],
          ),
          floatingActionButton: _buildFloatingActionButton(canManage, isOwner, canManageRole),
        );
      },
    );
  }

  /// 멤버 탭 빌드
  Widget _buildMembersTab(
    AppLocalizations l10n,
    AsyncValue<List<GroupMember>> membersAsync,
    AsyncValue<List<JoinRequest>> joinRequestsAsync,
  ) {
    return MembersTab(
      membersAsync: membersAsync,
      joinRequestsAsync: joinRequestsAsync,
      onRetry: () {
        ref.invalidate(groupMembersProvider(widget.groupId));
        ref.invalidate(groupJoinRequestsProvider(widget.groupId));
      },
      onRemoveMember: (member) => GroupDialogs.showRemoveMemberDialog(
        context,
        ref,
        l10n,
        widget.groupId,
        member,
      ),
      onChangeRole: (member) => GroupDialogs.showChangeRoleDialog(
        context,
        ref,
        l10n,
        widget.groupId,
        member,
      ),
      onAcceptRequest: (request) => _handleAcceptRequest(l10n, request),
      onRejectRequest: (request) => _handleRejectRequest(l10n, request),
      onCancelInvite: (request) => _handleCancelInvite(l10n, request),
      onResendInvite: (request) => _handleResendInvite(l10n, request),
    );
  }

  /// 가입 요청 승인 처리
  Future<void> _handleAcceptRequest(AppLocalizations l10n, JoinRequest request) async {
    try {
      await ref.read(groupNotifierProvider.notifier).acceptJoinRequest(
            widget.groupId,
            request.id,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.group_acceptSuccess)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  /// 가입 요청 거부 처리
  Future<void> _handleRejectRequest(AppLocalizations l10n, JoinRequest request) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.group_confirm),
        content: Text(l10n.group_rejectConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.group_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.group_reject),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(groupNotifierProvider.notifier).rejectJoinRequest(
            widget.groupId,
            request.id,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.group_rejectSuccess)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  /// 초대 취소 처리
  Future<void> _handleCancelInvite(AppLocalizations l10n, JoinRequest request) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('초대 취소'),
        content: Text('${request.email}에게 보낸 초대를 취소하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.group_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('취소'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(groupNotifierProvider.notifier).cancelInvite(
            widget.groupId,
            request.id,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('초대가 취소되었습니다')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  /// 초대 재전송 처리
  Future<void> _handleResendInvite(AppLocalizations l10n, JoinRequest request) async {
    try {
      await ref.read(groupNotifierProvider.notifier).resendInvite(
            widget.groupId,
            request.id,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${request.email}에게 초대 이메일이 재전송되었습니다')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  /// 설정 탭 빌드
  Widget _buildSettingsTab(Group group, AsyncValue<List<GroupMember>> membersAsync, bool canManage) {
    final l10n = AppLocalizations.of(context)!;

    return SettingsTab(
      group: group,
      membersAsync: membersAsync,
      canManage: canManage,
      onRegenerateCode: () => GroupDialogs.showRegenerateCodeDialog(
        context,
        ref,
        l10n,
        widget.groupId,
      ),
      onInviteByEmail: () => GroupDialogs.showInviteMemberDialog(
        context,
        ref,
        l10n,
        widget.groupId,
      ),
      onColorChange: (color) => _updateColor(color),
      onResetColor: () => _resetColor(),
    );
  }

  /// 역할 탭 빌드
  Widget _buildRolesTab(bool isOwner, bool canManageRole) {
    final l10n = AppLocalizations.of(context)!;
    final rolesAsync = ref.watch(groupRolesProvider(widget.groupId));

    return RolesTab(
      groupId: widget.groupId,
      rolesAsync: rolesAsync,
      isOwner: isOwner,
      canManageRole: canManageRole,
      onRetry: () => ref.invalidate(groupRolesProvider(widget.groupId)),
      onEditRole: (role) => GroupRoleEditDialog.show(
        context,
        ref,
        l10n,
        widget.groupId,
        role,
      ),
      onDeleteRole: (role) => GroupRoleDeleteDialog.show(
        context,
        ref,
        l10n,
        widget.groupId,
        role,
      ),
    );
  }

  /// FloatingActionButton 빌드
  Widget? _buildFloatingActionButton(bool canManage, bool isOwner, bool canManageRole) {
    final l10n = AppLocalizations.of(context)!;
    final tabIndex = _tabController.index;

    if (tabIndex == 0 && canManage) {
      // 멤버 탭 - 멤버 초대 버튼
      return FloatingActionButton.extended(
        onPressed: () => GroupDialogs.showInviteMemberDialog(
          context,
          ref,
          l10n,
          widget.groupId,
        ),
        icon: const Icon(Icons.person_add),
        label: Text(l10n.group_inviteMembers),
      );
    } else if (tabIndex == 2 && canManageRole) {
      // 역할 탭 - 역할 추가 버튼
      return FloatingActionButton.extended(
        onPressed: () => GroupRoleCreateDialog.show(
          context,
          ref,
          l10n,
          widget.groupId,
        ),
        icon: const Icon(Icons.add),
        label: const Text('역할 추가'),
      );
    }

    return null;
  }

  /// 색상 업데이트
  Future<void> _updateColor(Color color) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      final colorHex = GroupUtils.colorToHex(color);
      debugPrint('Updating color to: $colorHex');

      await ref.read(groupNotifierProvider.notifier).updateMyColor(
        widget.groupId,
        colorHex,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.group_updateSuccess)),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Error updating color: $e');
      debugPrint('Stack trace: $stackTrace');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('색상 변경 실패: ${e.toString()}'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  /// 색상 초기화 (그룹 기본 색상으로 되돌림)
  Future<void> _resetColor() async {
    try {
      await ref.read(groupNotifierProvider.notifier).updateMyColor(
        widget.groupId,
        null, // null을 전달하여 customColor 제거
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('그룹 기본 색상으로 초기화되었습니다')),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Error resetting color: $e');
      debugPrint('Stack trace: $stackTrace');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('색상 초기화 실패: ${e.toString()}'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }
}
