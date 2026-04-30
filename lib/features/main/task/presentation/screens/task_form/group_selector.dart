import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/widgets/group_dropdown.dart';
import 'package:family_planner/features/main/task/providers/task_form_provider.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// Task 폼의 그룹 선택 위젯
class GroupSelector extends ConsumerWidget {
  final TaskFormNotifier formNotifier;
  final bool isReadOnly;

  const GroupSelector({
    super.key,
    required this.formNotifier,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedGroupId = ref.watch(selectedGroupIdProvider);
    final groupsAsync = ref.watch(myGroupsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.schedule_group,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppSizes.spaceS),
        Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          child: groupsAsync.when(
            data: (groups) => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceM,
                vertical: AppSizes.spaceS,
              ),
              child: isReadOnly
                  ? _ReadOnlyGroupLabel(
                      selectedGroupId: selectedGroupId,
                      groups: groups,
                      l10n: l10n,
                    )
                  : GroupDropdown(
                      selectedGroupId: selectedGroupId,
                      groups: groups,
                      onChanged: (value) {
                        ref.read(selectedGroupIdProvider.notifier).state = value;
                        formNotifier.clearCategory();
                      },
                      style: GroupDropdownStyle.form,
                    ),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(AppSizes.spaceM),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, _) => Padding(
              padding: const EdgeInsets.all(AppSizes.spaceM),
              child: Text(l10n.schedule_personal, style: Theme.of(context).textTheme.bodyLarge),
            ),
          ),
        ),
      ],
    );
  }
}

class _ReadOnlyGroupLabel extends StatelessWidget {
  final String? selectedGroupId;
  final List<Group> groups;
  final AppLocalizations l10n;

  const _ReadOnlyGroupLabel({
    required this.selectedGroupId,
    required this.groups,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (selectedGroupId == null) {
      return Row(
        children: [
          Icon(Icons.person, size: 20, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: AppSizes.spaceS),
          Text(
            l10n.schedule_personal,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      );
    }

    final Group? group = groups.where((g) => g.id == selectedGroupId).firstOrNull;

    final groupName = group?.name ?? selectedGroupId!;
    final groupColor = group?.defaultColor != null
        ? Color(int.parse('FF${group!.defaultColor!.replaceFirst('#', '')}', radix: 16))
        : colorScheme.onSurfaceVariant;

    return Row(
      children: [
        Icon(Icons.group, size: 20, color: groupColor),
        const SizedBox(width: AppSizes.spaceS),
        Expanded(
          child: Text(
            groupName,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
