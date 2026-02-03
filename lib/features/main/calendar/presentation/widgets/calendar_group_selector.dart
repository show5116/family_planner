import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/widgets/group_dropdown.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 캘린더 AppBar용 그룹 선택 드롭다운
class CalendarGroupSelector extends ConsumerWidget {
  const CalendarGroupSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedGroupId = ref.watch(selectedGroupIdProvider);
    final groupsAsync = ref.watch(myGroupsProvider);

    return groupsAsync.when(
      data: (groups) => GroupDropdown(
        groups: groups,
        selectedGroupId: selectedGroupId,
        onChanged: (value) {
          ref.read(selectedGroupIdProvider.notifier).state = value;
        },
        style: GroupDropdownStyle.appBar,
      ),
      loading: () => Text(l10n.nav_calendar),
      error: (error, stack) => Text(l10n.nav_calendar),
    );
  }
}
