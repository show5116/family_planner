import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';

/// 냉장고·장보기 공용 그룹 선택 바 — 자산관리 AssetGroupBar와 동일한 스타일
class FridgeGroupSelector extends ConsumerWidget {
  const FridgeGroupSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(myGroupsProvider);
    final selectedGroupId = ref.watch(fridgeSelectedGroupIdProvider);

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
          Expanded(
            child: groupsAsync.when(
              data: (groups) {
                if (groups.isEmpty) {
                  return Text(
                    '소속된 그룹이 없습니다',
                    style: Theme.of(context).textTheme.bodyMedium,
                  );
                }
                final effectiveId = selectedGroupId ?? groups.first.id;
                return DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: effectiveId,
                    isDense: true,
                    items: groups
                        .map<DropdownMenuItem<String>>(
                          (g) => DropdownMenuItem<String>(
                            value: g.id,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.group, size: 16),
                                const SizedBox(width: AppSizes.spaceXS),
                                Text(g.name),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      ref.read(fridgeSelectedGroupIdProvider.notifier).state =
                          value;
                      ref.invalidate(storagesProvider);
                      ref.invalidate(storagesWithItemsProvider);
                      ref.invalidate(frequentItemsProvider);
                      ref.invalidate(cartProvider);
                      ref.invalidate(shoppingHistoryProvider);
                    },
                  ),
                );
              },
              loading: () => const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (_, _) => Text(
                '소속된 그룹이 없습니다',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
