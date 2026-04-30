import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/main/child_points/presentation/screens/history_tab.dart';
import 'package:family_planner/features/main/child_points/presentation/screens/points_tab.dart';
import 'package:family_planner/features/main/child_points/presentation/screens/rules_tab.dart';
import 'package:family_planner/features/main/child_points/presentation/screens/shop_tab.dart';
import 'package:family_planner/features/main/child_points/presentation/widgets/group_and_child_bar.dart';
import 'package:family_planner/features/main/child_points/presentation/widgets/management_loading_overlay.dart';
import 'package:family_planner/features/main/child_points/providers/childcare_provider.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/ai_chat/presentation/widgets/ai_chat_icon_button.dart';

/// 육아포인트 메인 화면
class ChildPointsScreen extends ConsumerStatefulWidget {
  const ChildPointsScreen({super.key});

  @override
  ConsumerState<ChildPointsScreen> createState() => _ChildPointsScreenState();
}

const _kChildcareGroupIdKey = 'childcare_selected_group_id';
const _kChildcareChildIdKey = 'childcare_selected_child_id';

class _ChildPointsScreenState extends ConsumerState<ChildPointsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initGroupSelection();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initGroupSelection() async {
    final prefs = await SharedPreferences.getInstance();
    final savedGroupId = prefs.getString(_kChildcareGroupIdKey);
    final savedChildId = prefs.getString(_kChildcareChildIdKey);

    if (!mounted) return;

    if (savedGroupId != null) {
      ref.read(childcareSelectedGroupIdProvider.notifier).state = savedGroupId;
      ref.read(childcareSelectedChildIdProvider.notifier).state = savedChildId;
      return;
    }

    // 저장된 값 없으면 첫 번째 그룹 자동 선택
    final groups =
        await ref.read(myGroupsProvider.future).catchError((_) => <Group>[]);
    if (groups.isNotEmpty && mounted) {
      ref.read(childcareSelectedGroupIdProvider.notifier).state =
          groups.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final groupsAsync = ref.watch(myGroupsProvider);
    final selectedGroupId = ref.watch(childcareSelectedGroupIdProvider);
    final selectedChildId = ref.watch(childcareSelectedChildIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.childcare_title),
        leading: context.canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              )
            : null,
        automaticallyImplyLeading: false,
        actions: [
          const AiChatIconButton(),
          if (selectedChildId != null)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'allowance') {
                  context.push(
                    AppRoutes.childPointsAllowancePlan,
                    extra: {'childId': selectedChildId},
                  );
                } else if (value == 'link') {
                  context.push(
                    AppRoutes.childPointsLinkUser,
                    extra: {'childId': selectedChildId},
                  );
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'allowance',
                  child: ListTile(
                    leading: Icon(Icons.monetization_on_outlined),
                    title: Text('용돈 플랜 설정'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'link',
                  child: ListTile(
                    leading: Icon(Icons.link),
                    title: Text('앱 계정 연동'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          if (selectedGroupId != null)
            IconButton(
              icon: const Icon(Icons.person_add_outlined),
              tooltip: '자녀 등록',
              onPressed: () => context.push(
                AppRoutes.childPointsChildProfileForm,
                extra: {'groupId': selectedGroupId},
              ),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: l10n.childcare_tab_points),
            Tab(text: l10n.childcare_tab_rewards),
            Tab(text: l10n.childcare_tab_rules),
            Tab(text: l10n.childcare_tab_history),
          ],
        ),
      ),
      body: ManagementLoadingOverlay(
        child: Column(
          children: [
            GroupAndChildBar(
              groupsAsync: groupsAsync,
              selectedGroupId: selectedGroupId,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  PointsTab(selectedChildId: selectedChildId),
                  const ShopTab(),
                  const RulesTab(),
                  const HistoryTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
