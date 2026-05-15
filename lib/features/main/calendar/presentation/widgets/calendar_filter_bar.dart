import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/utils/color_utils.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/default_group_provider.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

const _kCalendarGroupIdsKey = 'calendar_selected_group_ids';
const _kCalendarAllGroupsKey = 'calendar_all_groups_selected';
const _kCalendarIncludePersonalKey = 'calendar_include_personal';

/// 일정·할일 화면 body 상단용 그룹 멀티필터 바
class CalendarFilterBar extends ConsumerStatefulWidget {
  const CalendarFilterBar({super.key});

  @override
  ConsumerState<CalendarFilterBar> createState() => _CalendarFilterBarState();
}

class _CalendarFilterBarState extends ConsumerState<CalendarFilterBar> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadSavedFilter());
  }

  Future<void> _loadSavedFilter() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool(_kCalendarAllGroupsKey);

    if (!mounted) return;

    if (saved == null) {
      // 최초 진입: 대표 그룹 기준으로 초기화
      final defaultId = ref.read(defaultGroupProvider);
      final groups = await ref
          .read(myGroupsProvider.future)
          .catchError((_) => <Group>[]);
      if (!mounted) return;
      if (groups.isEmpty) {
        ref.read(selectedGroupIdsProvider.notifier).state = null;
        ref.read(includePersonalProvider.notifier).state = true;
        return;
      }
      if (defaultId != null && groups.any((g) => g.id == defaultId)) {
        ref.read(selectedGroupIdsProvider.notifier).state = [defaultId];
        ref.read(includePersonalProvider.notifier).state = false;
      } else {
        ref.read(selectedGroupIdsProvider.notifier).state = null;
        ref.read(includePersonalProvider.notifier).state = true;
      }
    } else {
      final isAllGroups = saved;
      final savedGroupIds = prefs.getStringList(_kCalendarGroupIdsKey);
      final includePersonal = prefs.getBool(_kCalendarIncludePersonalKey) ?? true;
      ref.read(selectedGroupIdsProvider.notifier).state =
          isAllGroups ? null : (savedGroupIds ?? []);
      ref.read(includePersonalProvider.notifier).state = includePersonal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedGroupIds = ref.watch(selectedGroupIdsProvider);
    final includePersonal = ref.watch(includePersonalProvider);
    final groupsAsync = ref.watch(myGroupsProvider);

    return groupsAsync.when(
      data: (groups) => _buildBar(context, l10n, groups, selectedGroupIds, includePersonal),
      loading: () => const SizedBox(height: 40),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Widget _buildBar(
    BuildContext context,
    AppLocalizations l10n,
    List<Group> groups,
    List<String>? selectedGroupIds,
    bool includePersonal,
  ) {
    final bool isAllSelected = selectedGroupIds == null;
    final selectedIds = selectedGroupIds ?? [];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 0.5,
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceM,
          vertical: AppSizes.spaceS,
        ),
        child: Row(
          children: [
            // 전체 칩
            _GroupChip(
              label: l10n.common_all,
              icon: Icons.all_inclusive,
              isSelected: isAllSelected,
              color: null,
              onTap: () => _toggleAll(groups),
            ),
            const SizedBox(width: AppSizes.spaceS),

            // 개인 칩
            _GroupChip(
              label: l10n.schedule_personal,
              icon: Icons.person_outline,
              isSelected: !isAllSelected && includePersonal,
              color: null,
              onTap: () => _togglePersonal(selectedIds, includePersonal, groups),
            ),

            // 그룹 칩들
            ...groups.map((g) {
              final isSelected = isAllSelected || selectedIds.contains(g.id);
              return Padding(
                padding: const EdgeInsets.only(left: AppSizes.spaceS),
                child: _GroupChip(
                  label: g.name,
                  icon: Icons.group_outlined,
                  isSelected: isSelected,
                  color: ColorUtils.parseColor(g.defaultColor),
                  onTap: () => _toggleGroup(g.id, selectedIds, includePersonal, groups),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _toggleAll(List<Group> groups) {
    ref.read(selectedGroupIdsProvider.notifier).state = null;
    ref.read(includePersonalProvider.notifier).state = true;
    _saveFilter(null, true);
  }

  void _togglePersonal(
    List<String> selectedIds,
    bool includePersonal,
    List<Group> groups,
  ) {
    final newInclude = !includePersonal;
    // 모두 해제 방지
    if (!newInclude && selectedIds.isEmpty) return;

    final newIds = List<String>.from(selectedIds);
    ref.read(selectedGroupIdsProvider.notifier).state = newIds;
    ref.read(includePersonalProvider.notifier).state = newInclude;
    _saveFilter(newIds, newInclude);
  }

  void _toggleGroup(
    String groupId,
    List<String> selectedIds,
    bool includePersonal,
    List<Group> groups,
  ) {
    List<String> newIds;
    bool newInclude = includePersonal;

    final wasAllSelected = ref.read(selectedGroupIdsProvider) == null;
    if (wasAllSelected) {
      // 전체 → 해당 그룹만 빼기
      newIds = groups.map((g) => g.id).where((id) => id != groupId).toList();
    } else {
      newIds = List<String>.from(selectedIds);
      if (newIds.contains(groupId)) {
        // 모두 해제 방지
        if (newIds.length == 1 && !includePersonal) return;
        newIds.remove(groupId);
      } else {
        newIds.add(groupId);
      }
    }

    // 전체 선택과 동일한 상태면 null로
    if (newIds.length == groups.length && newInclude) {
      ref.read(selectedGroupIdsProvider.notifier).state = null;
      _saveFilter(null, newInclude);
    } else {
      ref.read(selectedGroupIdsProvider.notifier).state = newIds;
      ref.read(includePersonalProvider.notifier).state = newInclude;
      _saveFilter(newIds, newInclude);
    }
  }

  Future<void> _saveFilter(List<String>? groupIds, bool includePersonal) async {
    final prefs = await SharedPreferences.getInstance();
    if (groupIds == null) {
      await prefs.setBool(_kCalendarAllGroupsKey, true);
      await prefs.remove(_kCalendarGroupIdsKey);
    } else {
      await prefs.setBool(_kCalendarAllGroupsKey, false);
      await prefs.setStringList(_kCalendarGroupIdsKey, groupIds);
    }
    await prefs.setBool(_kCalendarIncludePersonalKey, includePersonal);
  }
}

class _GroupChip extends StatelessWidget {
  const _GroupChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final Color? color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chipColor = color ?? theme.colorScheme.primary;

    return FilterChip(
      avatar: Icon(
        icon,
        size: 15,
        color: isSelected ? chipColor : theme.colorScheme.onSurfaceVariant,
      ),
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      selectedColor: chipColor.withValues(alpha: 0.15),
      checkmarkColor: chipColor,
      labelStyle: TextStyle(
        fontSize: 12,
        color: isSelected ? chipColor : null,
        fontWeight: isSelected ? FontWeight.w600 : null,
      ),
      side: isSelected
          ? BorderSide(color: chipColor, width: 1.5)
          : BorderSide(color: theme.colorScheme.outlineVariant),
      showCheckmark: false,
    );
  }
}
