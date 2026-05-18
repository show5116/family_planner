import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/features/settings/groups/providers/default_group_provider.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';
import 'package:family_planner/features/main/fridge/presentation/screens/fridge_tab.dart';
import 'package:family_planner/features/main/fridge/presentation/widgets/fridge_group_selector.dart';
import 'package:family_planner/shared/widgets/app_bar_more_menu.dart';

class FridgeScreen extends ConsumerStatefulWidget {
  const FridgeScreen({super.key});

  @override
  ConsumerState<FridgeScreen> createState() => _FridgeScreenState();
}

class _FridgeScreenState extends ConsumerState<FridgeScreen> {
  VoidCallback? _replayOnboarding;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initGroupSelection());
  }

  Future<void> _initGroupSelection() async {
    final groupId = ref.read(fridgeSelectedGroupIdProvider);
    if (groupId != null) return;
    final defaultId = ref.read(defaultGroupProvider);
    final groups = await ref
        .read(myGroupsProvider.future)
        .catchError((_) => <Group>[]);
    if (groups.isEmpty || !mounted) return;
    final resolved = (defaultId != null && groups.any((g) => g.id == defaultId))
        ? defaultId
        : groups.first.id;
    ref.read(fridgeSelectedGroupIdProvider.notifier).state = resolved;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.fridge_title),
        actions: [
          AppBarMoreMenu(
            onReplayOnboarding: () => _replayOnboarding?.call(),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: FridgeGroupSelector(),
        ),
      ),
      body: FridgeTab(
        onReplayOnboardingReady: (replay) => _replayOnboarding = replay,
      ),
    );
  }
}
