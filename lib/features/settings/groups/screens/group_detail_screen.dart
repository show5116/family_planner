import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/models/group_member.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/features/settings/groups/widgets/common_widgets.dart';
import 'package:family_planner/features/settings/groups/widgets/members_tab.dart';
import 'package:family_planner/features/settings/groups/widgets/settings_tab.dart';
import 'package:family_planner/features/settings/groups/widgets/roles_tab.dart';
import 'package:family_planner/features/settings/groups/widgets/group_dialogs.dart';
import 'package:family_planner/features/settings/groups/widgets/role_management_dialogs.dart';
import 'package:family_planner/features/settings/groups/utils/group_utils.dart';

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
          data: (members) => GroupUtils.canManageGroup(members),
          orElse: () => false,
        );

        final isOwner = membersAsync.maybeWhen(
          data: (members) => GroupUtils.isOwner(members),
          orElse: () => false,
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(group.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => GroupDialogs.showSettingsBottomSheet(
                  context,
                  ref,
                  l10n,
                  group,
                  canManage,
                  isOwner,
                ),
              ),
            ],
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
              _buildMembersTab(l10n, membersAsync),
              _buildSettingsTab(group, membersAsync, canManage),
              _buildRolesTab(isOwner),
            ],
          ),
          floatingActionButton: _buildFloatingActionButton(canManage, isOwner),
        );
      },
    );
  }

  /// 멤버 탭 빌드
  Widget _buildMembersTab(AppLocalizations l10n, AsyncValue<List<GroupMember>> membersAsync) {
    return MembersTab(
      membersAsync: membersAsync,
      onRetry: () => ref.invalidate(groupMembersProvider(widget.groupId)),
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
    );
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
      onColorChange: (color) => _updateColor(color),
    );
  }

  /// 역할 탭 빌드
  Widget _buildRolesTab(bool isOwner) {
    final l10n = AppLocalizations.of(context)!;
    final rolesAsync = ref.watch(groupRolesProvider(widget.groupId));

    return RolesTab(
      groupId: widget.groupId,
      rolesAsync: rolesAsync,
      isOwner: isOwner,
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
  Widget? _buildFloatingActionButton(bool canManage, bool isOwner) {
    final l10n = AppLocalizations.of(context)!;
    final tabIndex = _tabController.index;

    if (tabIndex == 0 && canManage) {
      // 멤버 탭 - 멤버 초대 버튼
      return FloatingActionButton.extended(
        onPressed: () => GroupDialogs.showInviteMemberDialog(context, l10n),
        icon: const Icon(Icons.person_add),
        label: Text(l10n.group_inviteMembers),
      );
    } else if (tabIndex == 2 && isOwner) {
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
}
