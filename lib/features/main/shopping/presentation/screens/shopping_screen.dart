import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/features/settings/groups/providers/default_group_provider.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';
import 'package:family_planner/features/main/fridge/presentation/widgets/fridge_group_selector.dart';
import 'package:family_planner/features/main/shopping/presentation/screens/cart_tab.dart';
import 'package:family_planner/features/main/shopping/presentation/screens/frequent_items_tab.dart';
import 'package:family_planner/features/main/shopping/presentation/screens/shopping_history_tab.dart';
import 'package:family_planner/shared/widgets/app_bar_more_menu.dart';

class ShoppingScreen extends ConsumerStatefulWidget {
  const ShoppingScreen({super.key});

  @override
  ConsumerState<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends ConsumerState<ShoppingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  VoidCallback? _replayCartOnboarding;
  VoidCallback? _replayFrequentOnboarding;
  VoidCallback? _replayHistoryOnboarding;

  // 탭 전환 중 중복 호출 방지
  bool _transitioning = false;

  static const _tabAnimationDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// 탭 전환 후 충분히 안정된 시점에 콜백 실행
  /// TabBarView 스와이프 애니메이션(300ms) + 렌더링 2프레임 대기
  Future<void> _switchTabAndStart(int targetIndex, VoidCallback startOnboarding) async {
    if (_transitioning || !mounted) return;
    _transitioning = true;

    _tabController.animateTo(targetIndex);

    // 탭 전환 애니메이션 완료 대기
    await Future.delayed(_tabAnimationDuration + const Duration(milliseconds: 50));
    if (!mounted) {
      _transitioning = false;
      return;
    }

    // 렌더링 안정화: 2프레임 대기 (첫 프레임에 레이아웃, 둘째 프레임에 GlobalKey 위치 확정)
    final completer = Completer<void>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) => completer.complete());
    });
    await completer.future;

    if (mounted) startOnboarding();
    _transitioning = false;
  }

  void _replayCurrentTabOnboarding() {
    switch (_tabController.index) {
      case 0:
        _replayCartOnboarding?.call();
      case 1:
        _replayFrequentOnboarding?.call();
      case 2:
        _replayHistoryOnboarding?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.shopping_title),
        actions: [
          AppBarMoreMenu(
            onReplayOnboarding: _replayCurrentTabOnboarding,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(96),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: [
                  Tab(text: l10n.fridge_tab_cart),
                  Tab(text: l10n.fridge_tab_frequent),
                  Tab(text: l10n.fridge_tab_history),
                ],
              ),
              const FridgeGroupSelector(),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CartTab(
            onReplayOnboardingReady: (replay) => _replayCartOnboarding = replay,
            onOnboardingFinished: () => _switchTabAndStart(
              1,
              () => _replayFrequentOnboarding?.call(),
            ),
          ),
          FrequentItemsTab(
            onReplayOnboardingReady: (replay) =>
                _replayFrequentOnboarding = replay,
            onOnboardingFinished: () => _switchTabAndStart(
              2,
              () => _replayHistoryOnboarding?.call(),
            ),
          ),
          ShoppingHistoryTab(
            onReplayOnboardingReady: (replay) =>
                _replayHistoryOnboarding = replay,
            // 마지막 탭 — 체인 종료
          ),
        ],
      ),
    );
  }
}
