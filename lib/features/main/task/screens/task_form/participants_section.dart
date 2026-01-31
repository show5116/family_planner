import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/widgets/form_section_header.dart';
import 'package:family_planner/features/main/task/providers/task_form_provider.dart';
import 'package:family_planner/features/settings/groups/models/group_member.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 참가자 선택 섹션 위젯
class ParticipantsSection extends ConsumerWidget {
  final String groupId;
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;

  const ParticipantsSection({
    super.key,
    required this.groupId,
    required this.formState,
    required this.formNotifier,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final membersAsync = ref.watch(groupMembersProvider(groupId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSectionHeader(
          title: l10n.schedule_participants,
          subtitle: l10n.schedule_participantsHint,
          action: membersAsync.maybeWhen(
            data: (members) {
              if (members.isEmpty) return null;
              final allSelected = members.every((m) => formState.selectedParticipantIds.contains(m.userId));
              return FormSectionAction(
                icon: allSelected ? Icons.deselect : Icons.select_all,
                label: allSelected ? l10n.schedule_participantsDeselectAll : l10n.schedule_participantsSelectAll,
                onPressed: () {
                  if (allSelected) {
                    formNotifier.clearParticipants();
                  } else {
                    formNotifier.selectAllParticipants(members.map((m) => m.userId).toList());
                  }
                },
              );
            },
            orElse: () => null,
          ),
        ),
        membersAsync.when(
          data: (members) => _ParticipantChips(
            members: members,
            formState: formState,
            formNotifier: formNotifier,
          ),
          loading: () => const Center(
            child: Padding(padding: EdgeInsets.all(AppSizes.spaceM), child: CircularProgressIndicator()),
          ),
          error: (_, _) => Text(
            l10n.schedule_participantsLoadError,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.error),
          ),
        ),
      ],
    );
  }
}

class _ParticipantChips extends StatelessWidget {
  final List<GroupMember> members;
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;

  const _ParticipantChips({
    required this.members,
    required this.formState,
    required this.formNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (members.isEmpty) {
      return Text(
        l10n.schedule_noMembers,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
      );
    }

    return Wrap(
      spacing: AppSizes.spaceS,
      runSpacing: AppSizes.spaceS,
      children: members.map((member) {
        final isSelected = formState.selectedParticipantIds.contains(member.userId);
        final userName = member.user?.name ?? 'Unknown';

        return FilterChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : AppColors.textSecondary.withValues(alpha: 0.3),
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                  style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : AppColors.textSecondary),
                ),
              ),
              const SizedBox(width: AppSizes.spaceXS),
              Text(userName),
            ],
          ),
          selected: isSelected,
          onSelected: (_) => formNotifier.toggleParticipant(member.userId),
        );
      }).toList(),
    );
  }
}
