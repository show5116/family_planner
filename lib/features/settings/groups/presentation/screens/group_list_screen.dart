import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/onboarding/presentation/widgets/feature_coach_mark.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/features/settings/groups/presentation/widgets/group_card.dart';
import 'package:family_planner/features/settings/groups/presentation/widgets/group_create_dialog.dart';
import 'package:family_planner/features/settings/groups/presentation/widgets/group_join_dialog.dart';
import 'package:family_planner/shared/widgets/app_empty_state.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';

/// 그룹 목록 화면
class GroupListScreen extends ConsumerStatefulWidget {
  const GroupListScreen({super.key});

  @override
  ConsumerState<GroupListScreen> createState() => _GroupListScreenState();
}

class _GroupListScreenState extends ConsumerState<GroupListScreen> {
  final _createFabKey = GlobalKey();
  final _joinFabKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showCoachMark());
  }

  Future<void> _showCoachMark() async {
    await FeatureCoachMark.show(
      context: context,
      featureKey: CoachMarkKeys.groupManagement,
      targets: [
        TargetFocus(
          identify: 'group_create_fab',
          keyTarget: _createFabKey,
          shape: ShapeLightFocus.RRect,
          radius: 28,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (_, _) => FeatureCoachMark.buildContent(
                title: '그룹 만들기',
                description: '가족, 연인, 친구, 팀 등\n원하는 그룹을 직접 만들어 보세요.',
                icon: Icons.group_add,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: 'group_join_fab',
          keyTarget: _joinFabKey,
          shape: ShapeLightFocus.RRect,
          radius: 28,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (_, _) => FeatureCoachMark.buildContent(
                title: '그룹 참여하기',
                description: '초대 코드를 입력해 기존 그룹에 합류하세요.\n그룹원이 공유한 코드를 사용하면 돼요.',
                icon: Icons.login,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final groupsAsyncValue = ref.watch(groupNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.group_title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(groupNotifierProvider.notifier).loadGroups();
            },
          ),
        ],
      ),
      body: groupsAsyncValue.when(
        data: (groups) => groups.isEmpty
            ? AppEmptyState(
                icon: Icons.groups_outlined,
                message: l10n.group_noGroups,
                subtitle: l10n.group_noGroupsDescription,
              )
            : RefreshIndicator(
                onRefresh: () async {
                  await ref.read(groupNotifierProvider.notifier).loadGroups();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppSizes.spaceM),
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    final group = groups[index];
                    return GroupCard(group: group);
                  },
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => AppErrorState(
          error: error,
          title: l10n.error_unknown,
          onRetry: () {
            ref.read(groupNotifierProvider.notifier).loadGroups();
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            key: _joinFabKey,
            onPressed: () => GroupJoinDialog.show(context, ref),
            icon: const Icon(Icons.login),
            label: Text(l10n.group_joinGroup),
            heroTag: 'join',
          ),
          const SizedBox(height: AppSizes.spaceM),
          FloatingActionButton.extended(
            key: _createFabKey,
            onPressed: () => GroupCreateDialog.show(context, ref),
            icon: const Icon(Icons.add),
            label: Text(l10n.group_createGroup),
            heroTag: 'create',
          ),
        ],
      ),
    );
  }
}
