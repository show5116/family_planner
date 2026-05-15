import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/memo/providers/memo_provider.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/default_group_provider.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';

const _kMemoFilterKey = 'memo_filter_value';
// null → 전체, 'PRIVATE' → 나만보기, groupId → 그룹

/// 메모 목록 상단 그룹/공개범위 필터 바 (chip 단일선택 + 저장)
class MemoFilterBar extends ConsumerStatefulWidget {
  const MemoFilterBar({super.key});

  @override
  ConsumerState<MemoFilterBar> createState() => _MemoFilterBarState();
}

class _MemoFilterBarState extends ConsumerState<MemoFilterBar> {
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadSaved());
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kMemoFilterKey);
    if (!mounted) return;

    String? initial;
    if (saved == null) {
      // 최초 진입: 대표 그룹이 있으면 그 그룹으로 초기화
      final defaultId = ref.read(defaultGroupProvider);
      if (defaultId != null) {
        final groups = await ref
            .read(myGroupsProvider.future)
            .catchError((_) => <Group>[]);
        if (groups.any((g) => g.id == defaultId)) {
          initial = defaultId;
        }
      }
    } else if (saved == '__null__') {
      initial = null;
    } else {
      initial = saved;
    }

    if (!mounted) return;
    setState(() => _loaded = true);
    ref.read(memoSelectedFilterProvider.notifier).state = initial;
    _applyFilter(initial);
  }

  void _select(String? value) {
    final current = ref.read(memoSelectedFilterProvider);
    if (current == value) return;
    ref.read(memoSelectedFilterProvider.notifier).state = value;
    _applyFilter(value);
    _saveFilter(value);
  }

  void _applyFilter(String? value) {
    final notifier = ref.read(memoListProvider.notifier);
    if (value == null) {
      notifier.setFilter(groupId: null, visibility: null);
    } else if (value == 'PRIVATE') {
      notifier.setFilter(groupId: null, visibility: 'PRIVATE');
    } else {
      notifier.setFilter(groupId: value, visibility: null);
    }
  }

  Future<void> _saveFilter(String? value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kMemoFilterKey, value ?? '__null__');
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return const SizedBox.shrink();

    final selected = ref.watch(memoSelectedFilterProvider);
    final groupsAsync = ref.watch(myGroupsProvider);

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
            _MemoChip(
              label: '전체',
              icon: Icons.all_inclusive,
              isSelected: selected == null,
              onTap: () => _select(null),
            ),
            const SizedBox(width: AppSizes.spaceS),
            _MemoChip(
              label: '나만 보기',
              icon: Icons.lock_outline,
              isSelected: selected == 'PRIVATE',
              onTap: () => _select('PRIVATE'),
            ),
            ...groupsAsync.valueOrNull?.map((g) {
                  return Padding(
                    padding: const EdgeInsets.only(left: AppSizes.spaceS),
                    child: _MemoChip(
                      label: g.name,
                      icon: Icons.group_outlined,
                      isSelected: selected == g.id,
                      onTap: () => _select(g.id),
                    ),
                  );
                }).toList() ??
                [],
          ],
        ),
      ),
    );
  }
}

class _MemoChip extends StatelessWidget {
  const _MemoChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return FilterChip(
      avatar: Icon(
        icon,
        size: 15,
        color: isSelected ? color : Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      selectedColor: color.withValues(alpha: 0.15),
      checkmarkColor: color,
      labelStyle: TextStyle(
        fontSize: 12,
        color: isSelected ? color : null,
        fontWeight: isSelected ? FontWeight.w600 : null,
      ),
      side: isSelected
          ? BorderSide(color: color, width: 1.5)
          : BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      showCheckmark: false,
    );
  }
}
