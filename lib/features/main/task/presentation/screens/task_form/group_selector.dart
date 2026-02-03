import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/widgets/group_dropdown.dart';
import 'package:family_planner/features/main/task/providers/task_form_provider.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// Task 폼의 그룹 선택 위젯
class GroupSelector extends ConsumerWidget {
  final TaskFormNotifier formNotifier;

  const GroupSelector({
    super.key,
    required this.formNotifier,
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
              child: GroupDropdown(
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
