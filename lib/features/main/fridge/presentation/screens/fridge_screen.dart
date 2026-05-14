import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/fridge/presentation/screens/fridge_tab.dart';
import 'package:family_planner/features/main/fridge/presentation/widgets/fridge_group_selector.dart';

class FridgeScreen extends ConsumerWidget {
  const FridgeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
