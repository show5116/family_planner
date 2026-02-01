import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/widgets/group_dropdown.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 카테고리 관리 화면의 그룹 선택 섹션
class CategoryGroupSelector extends ConsumerWidget {
  const CategoryGroupSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedGroupId = ref.watch(selectedGroupIdProvider);
    final groupsAsync = ref.watch(myGroupsProvider);

    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            l10n.schedule_group,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(width: AppSizes.spaceM),
          Expanded(
            child: groupsAsync.when(
              data: (groups) => GroupDropdown(
                groups: groups,
                selectedGroupId: selectedGroupId,
                onChanged: (value) {
                  ref.read(selectedGroupIdProvider.notifier).state = value;
                },
                style: GroupDropdownStyle.form,
              ),
              loading: () => const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (error, stack) => Text(l10n.schedule_personal),
            ),
          ),
        ],
      ),
    );
  }
}
