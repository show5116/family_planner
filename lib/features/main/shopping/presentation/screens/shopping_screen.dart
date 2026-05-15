import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';
import 'package:family_planner/features/main/fridge/presentation/widgets/fridge_group_selector.dart';
import 'package:family_planner/features/main/shopping/presentation/screens/cart_tab.dart';
import 'package:family_planner/features/main/shopping/presentation/screens/frequent_items_tab.dart';
import 'package:family_planner/features/main/shopping/presentation/screens/shopping_history_tab.dart';

class ShoppingScreen extends ConsumerStatefulWidget {
  const ShoppingScreen({super.key});

  @override
  ConsumerState<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends ConsumerState<ShoppingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.shopping_title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(96),
          child: Column(
            children: [
              const FridgeGroupSelector(),
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: l10n.fridge_tab_cart),
                  Tab(text: l10n.fridge_tab_frequent),
                  Tab(text: l10n.fridge_tab_history),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          CartTab(),
          FrequentItemsTab(),
          ShoppingHistoryTab(),
        ],
      ),
    );
  }
}
