import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';
import 'package:family_planner/shared/widgets/group_filter_bar.dart';

/// 냉장고·장보기 공용 그룹 선택 바
class FridgeGroupSelector extends ConsumerWidget {
  const FridgeGroupSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGroupId = ref.watch(fridgeSelectedGroupIdProvider);

    return GroupFilterBar(
      selectedGroupId: selectedGroupId,
      onChanged: (value) {
        ref.read(fridgeSelectedGroupIdProvider.notifier).state = value;
        ref.invalidate(storagesProvider);
        ref.invalidate(storagesWithItemsProvider);
        ref.invalidate(frequentItemsProvider);
        ref.invalidate(cartProvider);
        ref.invalidate(shoppingHistoryProvider);
      },
    );
  }
}
