import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';
import 'package:family_planner/features/main/fridge/presentation/screens/fridge_tab.dart';
import 'package:family_planner/features/main/fridge/presentation/widgets/fridge_group_selector.dart';

class FridgeScreen extends ConsumerStatefulWidget {
  const FridgeScreen({super.key});

  @override
  ConsumerState<FridgeScreen> createState() => _FridgeScreenState();
}

class _FridgeScreenState extends ConsumerState<FridgeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initGroupSelection());
  }

  Future<void> _initGroupSelection() async {
    final groupId = ref.read(fridgeSelectedGroupIdProvider);
    if (groupId != null) return;
    final groups = await ref
        .read(myGroupsProvider.future)
        .catchError((_) => <Group>[]);
    if (groups.isNotEmpty && mounted) {
      ref.read(fridgeSelectedGroupIdProvider.notifier).state = groups.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.fridge_title),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: FridgeGroupSelector(),
        ),
      ),
      body: const FridgeTab(),
    );
  }
}
