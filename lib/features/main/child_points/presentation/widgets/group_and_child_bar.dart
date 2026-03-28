import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/child_points/providers/childcare_provider.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 그룹 + 자녀 선택 바
class GroupAndChildBar extends ConsumerWidget {
  const GroupAndChildBar({
    super.key,
    required this.groupsAsync,
    required this.selectedGroupId,
  });

  final AsyncValue<List<Group>> groupsAsync;
  final String? selectedGroupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final childrenAsync = ref.watch(childcareChildrenProvider);
    final selectedChildId = ref.watch(childcareSelectedChildIdProvider);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceS,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // 그룹 선택
          const Icon(Icons.group, size: AppSizes.iconSmall),
          const SizedBox(width: AppSizes.spaceXS),
          groupsAsync.when(
            data: (groups) {
              if (groups.isEmpty) {
                return Text(l10n.childcare_no_group,
                    style: Theme.of(context).textTheme.bodySmall);
              }
              return DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedGroupId ?? groups.first.id,
                  isDense: true,
                  items: groups
                      .map<DropdownMenuItem<String>>(
                        (g) => DropdownMenuItem<String>(
                          value: g.id,
                          child: Text(g.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    ref
                        .read(childcareSelectedGroupIdProvider.notifier)
                        .state = value;
                    ref
                        .read(childcareSelectedChildIdProvider.notifier)
                        .state = null;
                  },
                ),
              );
            },
            loading: () => const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            error: (_, _) => Text(l10n.childcare_select_group),
          ),
          // 자녀 선택
          if (selectedGroupId != null)
            childrenAsync.when(
              data: (children) {
                if (children.isEmpty) return const SizedBox.shrink();

                if (selectedChildId == null && children.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ref
                        .read(childcareSelectedChildIdProvider.notifier)
                        .state = children.first.id;
                  });
                }

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: AppSizes.spaceS),
                    Container(
                      width: 1,
                      height: 16,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    const SizedBox(width: AppSizes.spaceS),
                    const Icon(Icons.child_care, size: AppSizes.iconSmall),
                    const SizedBox(width: AppSizes.spaceXS),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedChildId ?? children.first.id,
                        isDense: true,
                        items: children.map<DropdownMenuItem<String>>((c) {
                          return DropdownMenuItem<String>(
                            value: c.id,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(c.name),
                                if (c.userId != null) ...[
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.link,
                                    size: 14,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                  ),
                                ],
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          ref
                              .read(childcareSelectedChildIdProvider.notifier)
                              .state = value;
                        },
                      ),
                    ),
                  ],
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
        ],
      ),
    );
  }
}
