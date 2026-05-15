import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/child_points/providers/childcare_provider.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/shared/widgets/group_filter_bar.dart';
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
    final childrenAsync = ref.watch(childcareChildrenProvider);
    final selectedChildId = ref.watch(childcareSelectedChildIdProvider);

    return GroupFilterBar(
      selectedGroupId: selectedGroupId,
      onChanged: (value) {
        ref.read(childcareSelectedGroupIdProvider.notifier).state = value;
        ref.read(childcareSelectedChildIdProvider.notifier).state = null;
      },
      trailing: selectedGroupId != null
          ? childrenAsync.when(
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
              loading: () => const Padding(
                padding: EdgeInsets.only(left: AppSizes.spaceS),
                child: SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              error: (_, _) => const SizedBox.shrink(),
            )
          : null,
      emptyText: AppLocalizations.of(context)!.childcare_no_group,
    );
  }
}
