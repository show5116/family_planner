import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/assets/providers/asset_provider.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 자산관리 그룹 선택 바
class AssetGroupBar extends ConsumerWidget {
  final AsyncValue<List<Group>> groupsAsync;
  final String? selectedGroupId;

  const AssetGroupBar({
    super.key,
    required this.groupsAsync,
    required this.selectedGroupId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

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
                    l10n.asset_no_group_selected,
                    style: Theme.of(context).textTheme.bodyMedium,
                  );
                }
                return DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedGroupId ?? groups.first.id,
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
                      ref.read(assetSelectedGroupIdProvider.notifier).state = value;
                      ref.read(assetSelectedUserIdProvider.notifier).state = null;
                    },
                  ),
                );
              },
              loading: () => const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (_, _) => Text(l10n.asset_no_group_selected),
            ),
          ),
        ],
      ),
    );
  }
}
