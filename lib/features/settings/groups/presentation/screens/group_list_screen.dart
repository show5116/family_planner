import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/utils/error_handler.dart';
import 'package:family_planner/core/widgets/reorderable_widgets.dart';
import 'package:family_planner/features/onboarding/presentation/widgets/feature_coach_mark.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/features/settings/groups/presentation/widgets/group_card.dart';
import 'package:family_planner/features/settings/groups/presentation/widgets/group_create_dialog.dart';
import 'package:family_planner/features/settings/groups/presentation/widgets/group_join_dialog.dart';
import 'package:family_planner/shared/widgets/app_bar_more_menu.dart';
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
  final _myRequestsKey = GlobalKey();

  List<Group>? _reorderedGroups;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showCoachMark());
  }

  void _replayOnboarding() => _showCoachMark(force: true);

  Future<void> _showCoachMark({bool force = false}) async {
    await FeatureCoachMark.show(
      context: context,
      featureKey: CoachMarkKeys.groupManagement,
      forceShow: force,
      alignSkip: Alignment.bottomLeft,
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
        TargetFocus(
          identify: 'group_my_requests',
          keyTarget: _myRequestsKey,
          shape: ShapeLightFocus.Circle,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (_, _) => FeatureCoachMark.buildContent(
                title: '신청 내역',
                description: '내가 참여 신청한 그룹 목록을 확인하고\n수락 여부를 여기서 확인할 수 있어요.',
                icon: Icons.assignment_outlined,
                color: Colors.orange,
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

    // 외부에서 그룹 목록이 변경되면 로컬 순서 초기화
    ref.listen(groupNotifierProvider, (previous, next) {
      if (next is AsyncData && previous is AsyncData) {
        final prevIds = previous?.valueOrNull?.map((g) => g.id).toList() ?? [];
        final nextIds = next.valueOrNull?.map((g) => g.id).toList() ?? [];
        if (prevIds.length != nextIds.length ||
            !prevIds.every((id) => nextIds.contains(id))) {
          setState(() {
            _reorderedGroups = null;
            _hasChanges = false;
          });
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.group_title),
        actions: [
          if (!_hasChanges) ...[
            IconButton(
              key: _myRequestsKey,
              icon: const Icon(Icons.assignment_outlined),
              tooltip: l10n.group_myJoinRequests,
              onPressed: () => context.push(AppRoutes.groupMyJoinRequests),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                ref.read(groupNotifierProvider.notifier).loadGroups();
              },
            ),
            AppBarMoreMenu(
              onReplayOnboarding: _replayOnboarding,
              guideUrl: 'https://show5116.tistory.com/entry/Family-Planner-%EA%B0%80%EC%9D%B4%EB%93%9C-%EC%95%B1%EC%9D%98-%ED%95%B5%EC%8B%AC-%EA%B7%B8%EB%A3%B9-%EC%83%9D%EC%84%B1-%EB%B0%8F-%EB%A9%A4%EB%B2%84-%EC%B4%88%EB%8C%80%ED%95%98%EA%B8%B0-1%ED%8E%B8',
            ),
          ],
        ],
      ),
      body: groupsAsyncValue.when(
        data: (groups) {
          if (groups.isEmpty) {
            return AppEmptyState(
              icon: Icons.groups_outlined,
              message: l10n.group_noGroups,
              subtitle: l10n.group_noGroupsDescription,
            );
          }
          final displayGroups = _reorderedGroups ?? groups;
          return Column(
            children: [
              if (_hasChanges)
                ReorderChangesBar(
                  onSave: _saveSortOrder,
                  onCancel: _cancelReorder,
                ),
              Expanded(
                child: ReorderableListView.builder(
                  padding: const EdgeInsets.all(AppSizes.spaceM),
                  buildDefaultDragHandles: false,
                  proxyDecorator: buildReorderableProxyDecorator,
                  onReorder: (oldIndex, newIndex) {
                    if (newIndex > oldIndex) newIndex -= 1;
                    setState(() {
                      _reorderedGroups ??= List.from(displayGroups);
                      final item = _reorderedGroups!.removeAt(oldIndex);
                      _reorderedGroups!.insert(newIndex, item);
                      _hasChanges = true;
                    });
                  },
                  itemCount: displayGroups.length,
                  itemBuilder: (context, index) {
                    final group = displayGroups[index];
                    return _GroupReorderableCard(
                      key: ValueKey(group.id),
                      group: group,
                      index: index,
                      isLast: index == displayGroups.length - 1,
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => AppErrorState(
          error: error,
          title: l10n.error_unknown,
          onRetry: () {
            ref.read(groupNotifierProvider.notifier).loadGroups();
          },
        ),
      ),
      floatingActionButton: _hasChanges
          ? null
          : Column(
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

  Future<void> _cancelReorder() async {
    final confirmed = await showReorderCancelDialog(context);
    if (confirmed && mounted) {
      setState(() {
        _reorderedGroups = null;
        _hasChanges = false;
      });
    }
  }

  Future<void> _saveSortOrder() async {
    if (_reorderedGroups == null) return;

    final confirm = await showReorderSaveDialog(context);
    if (!confirm) return;

    try {
      final groupIds = _reorderedGroups!.map((g) => g.id).toList();
      await ref.read(groupNotifierProvider.notifier).updateMyGroupOrder(groupIds);

      if (mounted) {
        setState(() {
          _reorderedGroups = null;
          _hasChanges = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('그룹 순서가 저장되었습니다')),
        );
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showErrorSnackBar(context, e);
      }
    }
  }
}

/// 드래그 핸들이 있는 그룹 카드 래퍼
class _GroupReorderableCard extends StatelessWidget {
  final Group group;
  final int index;
  final bool isLast;

  const _GroupReorderableCard({
    super.key,
    required this.group,
    required this.index,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GroupCard(group: group, isLast: isLast),
        Positioned(
          top: 0,
          bottom: isLast ? 96 : AppSizes.spaceM,
          right: 0,
          child: ReorderableDragStartListener(
            index: index,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.spaceM),
              child: Center(child: DragHandleIcon()),
            ),
          ),
        ),
      ],
    );
  }
}
