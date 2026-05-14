import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 냉장고 화면 상단 그룹 선택 드롭다운
class FridgeGroupSelector extends ConsumerWidget {
  const FridgeGroupSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedGroupId = ref.watch(fridgeSelectedGroupIdProvider);
    final groupsAsync = ref.watch(myGroupsProvider);

    return groupsAsync.when(
      data: (groups) {
        if (groups.isEmpty) return const SizedBox.shrink();

        const personalValue = '__personal__';
        final currentValue = selectedGroupId ?? personalValue;

        final items = <DropdownMenuItem<String>>[
          DropdownMenuItem(
            value: personalValue,
            child: Row(
              children: [
                const Icon(Icons.person_outline, size: 18),
                const SizedBox(width: 6),
                Text(l10n.fridge_group_selector_personal),
              ],
            ),
          ),
          ...groups.map(
            (g) => DropdownMenuItem(
              value: g.id,
              child: Row(
                children: [
                  const Icon(Icons.group_outlined, size: 18),
                  const SizedBox(width: 6),
                  Text(g.name),
                ],
              ),
            ),
          ),
        ];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentValue,
              isExpanded: true,
              items: items,
              onChanged: (val) {
                final newId = val == personalValue ? null : val;
                ref.read(fridgeSelectedGroupIdProvider.notifier).state = newId;
                ref.invalidate(storagesProvider);
                ref.invalidate(frequentItemsProvider);
                ref.invalidate(cartProvider);
                ref.invalidate(shoppingHistoryProvider);
              },
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
