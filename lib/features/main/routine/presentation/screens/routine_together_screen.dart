import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/main/routine/presentation/screens/routine_group_members_screen.dart';
import 'package:family_planner/features/main/routine/presentation/screens/routine_leaderboard_screen.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/app_empty_state.dart';
import 'package:family_planner/shared/widgets/app_tab_bar.dart';

/// 그룹과 함께 루틴을 보는 화면.
///
/// 이전에는 "그룹원 현황"과 "랭킹보드"가 별도 화면이라 목록 → 바텀시트 →
/// 현황 → 랭킹까지 3단계를 들어가야 했다. 같은 그룹을 대상으로 하는
/// 화면들이라 하나로 합치고, 그룹 선택은 상단 드롭다운으로 올렸다.
///
/// 공유 설정(어느 그룹에 내 루틴을 보여줄지)은 성격이 달라 탭에 넣지 않고
/// 우상단 톱니 아이콘으로 분리했다 — 자주 보는 것과 한 번 정하는 것을
/// 섞으면 탭 전환이 어색해진다.
class RoutineTogetherScreen extends ConsumerStatefulWidget {
  const RoutineTogetherScreen({super.key, this.initialGroupId});

  /// 진입 시 선택할 그룹. null이면 첫 번째 그룹을 쓴다.
  final String? initialGroupId;

  @override
  ConsumerState<RoutineTogetherScreen> createState() =>
      _RoutineTogetherScreenState();
}

class _RoutineTogetherScreenState extends ConsumerState<RoutineTogetherScreen> {
  String? _groupId;

  /// 그룹 목록이 로드되면 선택값을 확정한다. 이미 고른 그룹이 목록에서
  /// 사라졌을 때(탈퇴 등)도 첫 그룹으로 되돌린다.
  void _syncSelection(List<Group> groups) {
    if (groups.isEmpty) return;
    final valid = _groupId != null && groups.any((g) => g.id == _groupId);
    if (valid) return;
    final initial = widget.initialGroupId;
    _groupId = (initial != null && groups.any((g) => g.id == initial))
        ? initial
        : groups.first.id;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final groups = ref.watch(myGroupsProvider).valueOrNull ?? const <Group>[];
    _syncSelection(groups);

    // 앱바 액션은 앱바 전경색을 따라야 한다. 기본값(primary)은 라이트 모드
    // 앱바 배경과 같은 색이라 보이지 않는다.
    final appBarForeground =
        Theme.of(context).appBarTheme.foregroundColor ??
        Theme.of(context).colorScheme.onPrimary;

    if (groups.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.routine_together_title),
          actions: [_settingsAction(appBarForeground, l10n)],
        ),
        body: AppEmptyState(
          icon: Icons.groups_outlined,
          message: l10n.routine_share_no_groups,
        ),
      );
    }

    final groupId = _groupId!;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.routine_together_title),
          actions: [_settingsAction(appBarForeground, l10n)],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(
              // 그룹이 하나뿐이면 선택기를 띄울 이유가 없다.
              groups.length > 1 ? kToolbarHeight * 2 : kToolbarHeight,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (groups.length > 1)
                  _GroupSelector(
                    groups: groups,
                    selectedId: groupId,
                    foregroundColor: appBarForeground,
                    onChanged: (id) => setState(() => _groupId = id),
                  ),
                Builder(
                  builder: (context) => AppTabBar(
                    controller: DefaultTabController.of(context),
                    tabs: [
                      l10n.routine_together_tab_status,
                      l10n.routine_together_tab_ranking,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // 그룹을 바꾸면 탭 내부 상태(랭킹 기간/기준 등)가 이어지지
            // 않도록 key로 새 인스턴스를 만든다.
            RoutineGroupMembersTab(
              key: ValueKey('members_$groupId'),
              groupId: groupId,
            ),
            RoutineLeaderboardTab(
              key: ValueKey('leaderboard_$groupId'),
              groupId: groupId,
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsAction(Color foreground, AppLocalizations l10n) {
    return IconButton(
      icon: const Icon(Icons.settings_outlined),
      tooltip: l10n.routine_share_title,
      color: foreground,
      onPressed: () => context.push(AppRoutes.routineShareSettings),
    );
  }
}

/// 앱바 하단의 그룹 선택 드롭다운. 그룹이 2개 이상일 때만 노출된다.
class _GroupSelector extends StatelessWidget {
  const _GroupSelector({
    required this.groups,
    required this.selectedId,
    required this.foregroundColor,
    required this.onChanged,
  });

  final List<Group> groups;
  final String selectedId;
  final Color foregroundColor;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM),
        child: Row(
          children: [
            Icon(Icons.groups_outlined, size: 18, color: foregroundColor),
            const SizedBox(width: AppSizes.spaceS),
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedId,
                  isExpanded: true,
                  dropdownColor: Theme.of(context).colorScheme.surface,
                  iconEnabledColor: foregroundColor,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: foregroundColor,
                    fontWeight: FontWeight.bold,
                  ),
                  selectedItemBuilder: (context) => groups
                      .map(
                        (g) => Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            g.name,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: foregroundColor,
                                  fontWeight: FontWeight.bold,
                                ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      )
                      .toList(),
                  items: groups
                      .map(
                        (g) => DropdownMenuItem(
                          value: g.id,
                          child: Text(
                            g.name,
                            style: Theme.of(context).textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) onChanged(value);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
