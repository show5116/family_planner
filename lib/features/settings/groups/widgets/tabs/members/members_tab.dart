import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/settings/groups/models/group_member.dart';
import 'package:family_planner/features/settings/groups/widgets/common_widgets.dart';
import 'package:family_planner/features/settings/groups/widgets/tabs/members/member_card.dart';

/// 그룹 멤버 탭
class MembersTab extends ConsumerWidget {
  final AsyncValue<List<GroupMember>> membersAsync;
  final VoidCallback onRetry;
  final Function(GroupMember member) onRemoveMember;
  final Function(GroupMember member) onChangeRole;

  const MembersTab({
    super.key,
    required this.membersAsync,
    required this.onRetry,
    required this.onRemoveMember,
    required this.onChangeRole,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return membersAsync.when(
      loading: () => const LoadingView(),
      error: (error, stack) => ErrorView(
        message: error.toString(),
        onRetry: onRetry,
      ),
      data: (members) {
        if (members.isEmpty) {
          return const EmptyView(
            message: '멤버가 없습니다',
            icon: Icons.people_outline,
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          itemCount: members.length,
          itemBuilder: (context, index) {
            final member = members[index];
            return MemberCard(
              member: member,
              allMembers: members,
              onRemove: () => onRemoveMember(member),
              onChangeRole: () => onChangeRole(member),
            );
          },
        );
      },
    );
  }
}
