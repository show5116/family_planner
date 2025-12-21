import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/settings/groups/models/group_member.dart';
import 'package:family_planner/features/settings/groups/models/join_request.dart';
import 'package:family_planner/features/settings/groups/widgets/common_widgets.dart';
import 'package:family_planner/features/settings/groups/widgets/tabs/members/member_card.dart';
import 'package:family_planner/features/settings/groups/widgets/tabs/members/pending_request_card.dart';
import 'package:family_planner/features/settings/groups/utils/group_utils.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';

/// 그룹 멤버 탭
class MembersTab extends ConsumerStatefulWidget {
  final AsyncValue<List<GroupMember>> membersAsync;
  final AsyncValue<List<JoinRequest>> joinRequestsAsync;
  final VoidCallback onRetry;
  final Function(GroupMember member) onRemoveMember;
  final Function(GroupMember member) onChangeRole;
  final Function(JoinRequest request) onAcceptRequest;
  final Function(JoinRequest request) onRejectRequest;
  final Function(JoinRequest request)? onCancelInvite;
  final Function(JoinRequest request)? onResendInvite;

  const MembersTab({
    super.key,
    required this.membersAsync,
    required this.joinRequestsAsync,
    required this.onRetry,
    required this.onRemoveMember,
    required this.onChangeRole,
    required this.onAcceptRequest,
    required this.onRejectRequest,
    this.onCancelInvite,
    this.onResendInvite,
  });

  @override
  ConsumerState<MembersTab> createState() => _MembersTabState();
}

class _MembersTabState extends ConsumerState<MembersTab> {
  bool _showPending = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    debugPrint('[MembersTab.build] authState: isAuthenticated=${authState.isAuthenticated}, user=${authState.user}');
    debugPrint('[MembersTab.build] user keys: ${authState.user?.keys}');

    final currentUserId = authState.user?['id']?.toString();
    debugPrint('[MembersTab.build] currentUserId: $currentUserId');

    // 초대 권한 확인
    final canInvite = widget.membersAsync.maybeWhen(
      data: (members) => GroupUtils.canInviteMembers(members, currentUserId: currentUserId),
      orElse: () => false,
    );

    return Column(
      children: [
        // 토글 버튼 (초대 권한이 있을 때만 표시)
        if (canInvite)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceM,
              vertical: AppSizes.spaceS,
            ),
            child: SegmentedButton<bool>(
              segments: [
                ButtonSegment<bool>(
                  value: false,
                  label: Text(l10n.group_members),
                  icon: const Icon(Icons.people),
                ),
                ButtonSegment<bool>(
                  value: true,
                  label: Text(l10n.group_pending),
                  icon: const Icon(Icons.hourglass_empty),
                ),
              ],
              selected: {_showPending},
              onSelectionChanged: (Set<bool> newSelection) {
                setState(() {
                  _showPending = newSelection.first;
                });
              },
            ),
          ),
        // 콘텐츠
        Expanded(
          child: _showPending
              ? _buildPendingRequestsList()
              : _buildMembersList(),
        ),
      ],
    );
  }

  Widget _buildMembersList() {
    final authState = ref.watch(authProvider);
    debugPrint('[MembersTab._buildMembersList] authState: isAuthenticated=${authState.isAuthenticated}, user=${authState.user}');
    debugPrint('[MembersTab._buildMembersList] user keys: ${authState.user?.keys}');
    debugPrint('[MembersTab._buildMembersList] user[\'id\']: ${authState.user?['id']} (${authState.user?['id'].runtimeType})');

    final currentUserId = authState.user?['id']?.toString();
    debugPrint('[MembersTab._buildMembersList] currentUserId: $currentUserId (${currentUserId.runtimeType})');

    return widget.membersAsync.when(
      loading: () => const LoadingView(),
      error: (error, stack) => ErrorView(
        message: error.toString(),
        onRetry: widget.onRetry,
      ),
      data: (members) {
        if (members.isEmpty) {
          return const EmptyView(
            message: '멤버가 없습니다',
            icon: Icons.people_outline,
          );
        }

        // 본인을 최상단으로 정렬
        final sortedMembers = List<GroupMember>.from(members);
        sortedMembers.sort((a, b) {
          final aIsCurrentUser = a.user?.id == currentUserId;
          final bIsCurrentUser = b.user?.id == currentUserId;
          debugPrint('[MembersTab.sort] a.user?.id: ${a.user?.id}, b.user?.id: ${b.user?.id}, currentUserId: $currentUserId, aIsCurrentUser: $aIsCurrentUser, bIsCurrentUser: $bIsCurrentUser');
          if (aIsCurrentUser && !bIsCurrentUser) return -1;
          if (!aIsCurrentUser && bIsCurrentUser) return 1;
          return 0;
        });
        debugPrint('[MembersTab] sortedMembers first: ${sortedMembers.first.user?.id}, name: ${sortedMembers.first.user?.name}');

        return ListView.builder(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          itemCount: sortedMembers.length,
          itemBuilder: (context, index) {
            final member = sortedMembers[index];
            return MemberCard(
              member: member,
              allMembers: members,
              currentUserId: currentUserId,
              onRemove: () => widget.onRemoveMember(member),
              onChangeRole: () => widget.onChangeRole(member),
            );
          },
        );
      },
    );
  }

  Widget _buildPendingRequestsList() {
    final l10n = AppLocalizations.of(context)!;

    return widget.joinRequestsAsync.when(
      loading: () => const LoadingView(),
      error: (error, stack) => ErrorView(
        message: error.toString(),
        onRetry: widget.onRetry,
      ),
      data: (requests) {
        if (requests.isEmpty) {
          return EmptyView(
            message: l10n.group_noPendingRequests,
            icon: Icons.hourglass_empty,
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            final isInvite = request.type == 'INVITE';

            return PendingRequestCard(
              request: request,
              onAccept: () => widget.onAcceptRequest(request),
              onReject: () => widget.onRejectRequest(request),
              onCancel: isInvite && widget.onCancelInvite != null
                  ? () => widget.onCancelInvite!(request)
                  : null,
              onResend: isInvite && widget.onResendInvite != null
                  ? () => widget.onResendInvite!(request)
                  : null,
            );
          },
        );
      },
    );
  }
}
