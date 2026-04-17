import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/models/group_member.dart';
import 'package:family_planner/features/settings/groups/models/join_request.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/features/settings/groups/presentation/widgets/common_widgets.dart';
import 'package:family_planner/features/settings/groups/presentation/widgets/tabs/members/members_tab.dart';
import 'package:family_planner/features/settings/groups/presentation/widgets/tabs/settings/settings_tab.dart';
import 'package:family_planner/features/settings/groups/presentation/widgets/tabs/roles/roles_tab.dart';
import 'package:family_planner/features/settings/groups/presentation/widgets/group_dialogs.dart';
import 'package:family_planner/features/settings/groups/presentation/widgets/role_management_dialogs.dart';
import 'package:family_planner/features/settings/groups/presentation/widgets/transfer_ownership_dialog.dart';
import 'package:family_planner/core/utils/color_utils.dart';
import 'package:family_planner/shared/widgets/app_tab_bar.dart';
import 'package:family_planner/features/onboarding/presentation/widgets/feature_coach_mark.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';

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


  // 그룹장 여부 — 데이터 로드 후 세팅
  bool? _isOwner;

  // 코치마크용 GlobalKey
  final _inviteCodeKey = GlobalKey();
  final _fabKey = GlobalKey();

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

  /// 그룹 데이터가 처음 로드된 뒤 1회 코치마크 실행
  void _maybeShowCoachMark(bool isOwner) {
    if (_isOwner != null) return; // 이미 실행됨
    _isOwner = isOwner;
    WidgetsBinding.instance.addPostFrameCallback((_) => _showCoachMark(isOwner));
  }

  Future<void> _showCoachMark(bool isOwner) async {
    final featureKey = CoachMarkKeys.groupDetail(widget.groupId);

    // 탭 위치 계산
    // AppBar(56) + StatusBar 높이만큼 아래에 TabBar가 위치
    final screenWidth = MediaQuery.of(context).size.width;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    const appBarHeight = kToolbarHeight; // 56
    const tabBarHeight = kToolbarHeight; // AppTabBar.preferredSize
    final tabTop = statusBarHeight + appBarHeight;
    final tabWidth = screenWidth / 3; // 탭 3개

    // 설정 탭(인덱스 1), 역할 탭(인덱스 2) 위치
    TargetFocus settingsTabTarget(String title, String description, IconData icon, Color color) {
      return TargetFocus(
        identify: 'group_settings_tab',
        targetPosition: TargetPosition(
          Size(tabWidth, tabBarHeight),
          Offset(tabWidth * 1, tabTop),
        ),
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: title,
              description: description,
              icon: icon,
              color: color,
            ),
          ),
        ],
      );
    }

    if (isOwner) {
      await FeatureCoachMark.show(
        context: context,
        featureKey: featureKey,
        onClickTarget: (target) async {
          if (!mounted) return;
          if (target.identify == 'group_settings_tab') {
            _tabController.animateTo(1);
            // 설정 탭 렌더링 완료까지 대기 — 다음 타겟(초대 코드 카드)의 key가 유효해야 함
            await Future.delayed(const Duration(milliseconds: 600));
          } else if (target.identify == 'group_roles_tab') {
            _tabController.animateTo(2);
            await Future.delayed(const Duration(milliseconds: 500));
          }
        },
        beforeFocus: (target) async {
          if (!mounted) return;
          // FAB 하이라이트 전 — 역할 탭으로 이동 후 대기
          if (target.identify == 'group_role_fab') {
            _tabController.animateTo(2);
            await Future.delayed(const Duration(milliseconds: 500));
          }
        },
        targets: [
          // 1. 설정 탭 — 초대 안내 (클릭 시 설정 탭으로 이동)
          settingsTabTarget(
            '멤버를 초대해보세요',
            '설정 탭에서 초대 코드를 공유하거나\n이메일로 직접 멤버를 초대할 수 있어요.\n\n탭을 눌러 설정으로 이동하세요.',
            Icons.person_add_outlined,
            Colors.blue,
          ),
          // 2. 초대 코드 카드 — 설정 탭이 이미 활성화된 상태에서 하이라이트
          TargetFocus(
            identify: 'group_invite_code',
            keyTarget: _inviteCodeKey,
            shape: ShapeLightFocus.RRect,
            radius: 12,
            contents: [
              TargetContent(
                align: ContentAlign.bottom,
                builder: (_, _) => FeatureCoachMark.buildContent(
                  title: '초대 코드로 멤버 초대',
                  description: '코드를 복사해 공유하거나\n이메일로 직접 초대장을 보낼 수 있어요.',
                  icon: Icons.vpn_key_outlined,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          // 3. 역할 탭 — 권한 관리 안내 (클릭 시 역할 탭으로 이동)
          TargetFocus(
            identify: 'group_roles_tab',
            targetPosition: TargetPosition(
              Size(tabWidth, tabBarHeight),
              Offset(tabWidth * 2, tabTop),
            ),
            shape: ShapeLightFocus.RRect,
            radius: 8,
            contents: [
              TargetContent(
                align: ContentAlign.bottom,
                builder: (_, _) => FeatureCoachMark.buildContent(
                  title: '역할로 권한을 관리하세요',
                  description: '역할 탭에서 새로운 역할을 만들고\n멤버별 권한을 세밀하게 설정할 수 있어요.\n\n탭을 눌러 역할 관리로 이동하세요.',
                  icon: Icons.manage_accounts_outlined,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          // 4. 역할 추가 FAB
          TargetFocus(
            identify: 'group_role_fab',
            keyTarget: _fabKey,
            shape: ShapeLightFocus.RRect,
            radius: 16,
            contents: [
              TargetContent(
                align: ContentAlign.top,
                builder: (_, _) => FeatureCoachMark.buildContent(
                  title: '새 역할 만들기',
                  description: '버튼을 눌러 역할을 만들고\n이름, 색상, 권한을 자유롭게 설정하세요.',
                  icon: Icons.add_circle_outline,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      // 그룹원: 설정 탭의 색상 설정 안내
      await FeatureCoachMark.show(
        context: context,
        featureKey: featureKey,
        onClickTarget: (target) {
          if (!mounted) return;
          if (target.identify == 'group_settings_tab') {
            _tabController.animateTo(1);
          }
        },
        targets: [
          settingsTabTarget(
            '나만의 그룹 색상을 설정하세요',
            '설정 탭에서 이 그룹의 색상을 지정할 수 있어요.\n설정한 색상은 일정 등 다양한 메뉴에서\n이 그룹의 항목을 구분하는 데 사용돼요.\n\n탭을 눌러 설정으로 이동하세요.',
            Icons.palette_outlined,
            Colors.purple,
          ),
        ],
      );
    }
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
        // Group 객체의 myRole을 사용하여 권한 확인
        final isOwner = group.myRole?.name == 'OWNER';
        _maybeShowCoachMark(isOwner);
        final canManage = isOwner || group.myRole?.name == 'ADMIN';
        final canInvite = group.hasPermission('INVITE_MEMBER');
        final canManageRole = group.hasPermission('MANAGE_ROLE');

        // 초대 권한이 있을 때만 가입 요청 목록 조회
        final joinRequestsAsync = canInvite
            ? ref.watch(groupJoinRequestsProvider(widget.groupId))
            : const AsyncValue<List<JoinRequest>>.data([]);

        return Scaffold(
          appBar: AppBar(
            title: Text(group.name),
            bottom: AppTabBar(
              controller: _tabController,
              tabs: [
                l10n.group_members,
                l10n.group_settings,
                l10n.group_role,
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildMembersTab(l10n, group, membersAsync, joinRequestsAsync),
              _buildSettingsTab(group, membersAsync, canManage),
              _buildRolesTab(group, membersAsync, isOwner, canManageRole),
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
    Group group,
    AsyncValue<List<GroupMember>> membersAsync,
    AsyncValue<List<JoinRequest>> joinRequestsAsync,
  ) {
    return MembersTab(
      group: group,
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
      onTransferOwnership: (member) => TransferOwnershipDialog.show(
        context,
        ref,
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
      inviteCodeKey: _inviteCodeKey,
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
  Widget _buildRolesTab(
    Group group,
    AsyncValue<List<GroupMember>> membersAsync,
    bool isOwner,
    bool canManageRole,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final rolesAsync = ref.watch(groupRolesProvider(widget.groupId));

    return membersAsync.when(
      loading: () => const LoadingView(),
      error: (error, stack) => ErrorView(
        message: error.toString(),
        onRetry: () => ref.invalidate(groupMembersProvider(widget.groupId)),
      ),
      data: (members) => RolesTab(
        group: group,
        groupId: widget.groupId,
        rolesAsync: rolesAsync,
        members: members,
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
        key: _fabKey,
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
      final colorHex = ColorUtils.colorToHex(color);
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
