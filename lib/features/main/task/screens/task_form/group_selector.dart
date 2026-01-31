import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/task/providers/task_form_provider.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 그룹 선택 위젯
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
            data: (groups) => _GroupDropdown(
              selectedGroupId: selectedGroupId,
              groups: groups,
              formNotifier: formNotifier,
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

class _GroupDropdown extends ConsumerWidget {
  final String? selectedGroupId;
  final List<Group> groups;
  final TaskFormNotifier formNotifier;

  const _GroupDropdown({
    required this.selectedGroupId,
    required this.groups,
    required this.formNotifier,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final items = <DropdownMenuItem<String?>>[];

    items.add(
      DropdownMenuItem<String?>(
        value: null,
        child: Row(
          children: [
            const Icon(Icons.person, size: 20),
            const SizedBox(width: AppSizes.spaceS),
            Text(l10n.schedule_personal),
          ],
        ),
      ),
    );

    for (final group in groups) {
      items.add(
        DropdownMenuItem<String?>(
          value: group.id,
          child: Row(
            children: [
              Icon(
                Icons.group,
                size: 20,
                color: group.defaultColor != null
                    ? Color(int.parse('FF${group.defaultColor!.replaceFirst('#', '')}', radix: 16))
                    : null,
              ),
              const SizedBox(width: AppSizes.spaceS),
              Expanded(child: Text(group.name, overflow: TextOverflow.ellipsis)),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM, vertical: AppSizes.spaceS),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: selectedGroupId,
          items: items,
          onChanged: (value) {
            ref.read(selectedGroupIdProvider.notifier).state = value;
            formNotifier.clearCategory();
          },
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down),
        ),
      ),
    );
  }
}
