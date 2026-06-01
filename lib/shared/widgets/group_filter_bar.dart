import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/default_group_provider.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';

const _kPersonalValue = '__personal__';

enum FilterMode { single, withAll }

/// 다중선택 필터 상태
class FilterSelection {
  const FilterSelection({
    required this.includePersonal,
    required this.groupIds, // null = 전체(모두 선택)
  });

  final bool includePersonal;
  final List<String>? groupIds;

  bool get isAll => groupIds == null;

  @override
  String toString() =>
      'FilterSelection(personal=$includePersonal, groups=$groupIds)';
}

/// 그룹 선택 바 — 드롭다운 방식
///
/// [FilterMode.single]: 그룹 중 하나 선택 (가계부, 육아 등)
/// [FilterMode.withAll]: 전체/나만보기/그룹 다중 선택 (일정, 할일, 메모 필터용)
///   - [onMultiFilterChanged] 콜백으로 [FilterSelection] 전달
///   - [savedKey] 지정 시 SharedPreferences에 저장/복원
///   - 최초 진입 시 대표 그룹(defaultGroupProvider) 자동 선택
class GroupFilterBar extends ConsumerStatefulWidget {
  const GroupFilterBar({
    super.key,
    // ── single 모드 ──
    this.selectedGroupId,
    this.onChanged,
    this.showPersonal = false,
    this.trailing,
    this.personalLabel,
    this.emptyText,
    // ── withAll 모드 ──
    this.filterMode = FilterMode.single,
    this.onMultiFilterChanged,
    this.savedKey,
  });

  // single 모드
  final String? selectedGroupId;
  final ValueChanged<String?>? onChanged;
  final bool showPersonal;
  final Widget? trailing;
  final String? personalLabel;
  final String? emptyText;

  // withAll 모드
  final FilterMode filterMode;
  final ValueChanged<FilterSelection>? onMultiFilterChanged;
  final String? savedKey;

  @override
  ConsumerState<GroupFilterBar> createState() => _GroupFilterBarState();
}

class _GroupFilterBarState extends ConsumerState<GroupFilterBar> {
  // withAll 모드 상태 (null groupIds = 전체)
  List<String>? _selectedGroupIds;
  bool _includePersonal = true;
  bool _loaded = false;
  final _buttonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.filterMode == FilterMode.withAll) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadSaved());
    }
  }

  Future<void> _loadSaved() async {
    List<String>? groupIds;
    bool includePersonal = true;

    if (widget.savedKey != null) {
      final prefs = await SharedPreferences.getInstance();
      final savedAll = prefs.getBool('${widget.savedKey}_all');
      if (savedAll == null) {
        // 최초 진입 — 대표 그룹
        final defaultId = ref.read(defaultGroupProvider);
        if (defaultId != null) {
          final groups = await ref
              .read(myGroupsProvider.future)
              .catchError((_) => <Group>[]);
          if (groups.any((g) => g.id == defaultId)) {
            groupIds = [defaultId];
            includePersonal = false;
          }
        }
      } else if (savedAll) {
        groupIds = null; // 전체
        includePersonal = prefs.getBool('${widget.savedKey}_personal') ?? true;
      } else {
        final savedIds = prefs.getStringList('${widget.savedKey}_ids') ?? [];
        includePersonal =
            prefs.getBool('${widget.savedKey}_personal') ?? false;
        // 현재 계정에 속한 그룹만 남김 (계정 전환 후 이전 계정의 groupId 제거)
        final groups = await ref
            .read(myGroupsProvider.future)
            .catchError((_) => <Group>[]);
        final validIds = savedIds.where((id) => groups.any((g) => g.id == id)).toList();
        groupIds = validIds;
        if (validIds.isEmpty && !includePersonal) {
          // 유효한 그룹이 하나도 없으면 전체로 fallback
          groupIds = null;
          includePersonal = true;
        }
      }
    }

    if (!mounted) return;
    setState(() {
      _selectedGroupIds = groupIds;
      _includePersonal = includePersonal;
      _loaded = true;
    });
    _emit();
  }

  Future<void> _save() async {
    if (widget.savedKey == null) return;
    final prefs = await SharedPreferences.getInstance();
    final isAll = _selectedGroupIds == null;
    await prefs.setBool('${widget.savedKey}_all', isAll);
    await prefs.setBool('${widget.savedKey}_personal', _includePersonal);
    if (!isAll) {
      await prefs.setStringList(
          '${widget.savedKey}_ids', _selectedGroupIds ?? []);
    }
  }

  void _emit() {
    widget.onMultiFilterChanged?.call(FilterSelection(
      includePersonal: _selectedGroupIds == null ? true : _includePersonal,
      groupIds: _selectedGroupIds,
    ));
  }

  // ── 드롭다운 버튼 라벨 ────────────────────────────────────────────────────

  String _buildLabel(List<Group> groups) {
    if (_selectedGroupIds == null) return '전체';

    final parts = <String>[];
    if (_includePersonal) parts.add('나만 보기');
    for (final g in groups) {
      if (_selectedGroupIds!.contains(g.id)) parts.add(g.name);
    }
    if (parts.isEmpty) return '전체';
    if (parts.length == 1) return parts.first;
    return '${parts.first} 외 ${parts.length - 1}개';
  }

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (widget.filterMode == FilterMode.withAll && !_loaded) {
      return const SizedBox.shrink();
    }

    final groupsAsync = ref.watch(myGroupsProvider);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceS,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: groupsAsync.when(
              data: (groups) => widget.filterMode == FilterMode.withAll
                  ? _buildMultiDropdown(context, groups)
                  : _buildSingleDropdown(context, groups),
              loading: () => const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (_, _) => Text(
                widget.emptyText ?? '그룹을 선택해주세요',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          if (widget.trailing != null) widget.trailing!,
        ],
      ),
    );
  }

  // ── withAll 모드: 다중선택 드롭다운 ─────────────────────────────────────

  Widget _buildMultiDropdown(BuildContext context, List<Group> groups) {
    final label = _buildLabel(groups);
    final isAll = _selectedGroupIds == null;

    return InkWell(
      key: _buttonKey,
      borderRadius: BorderRadius.circular(4),
      onTap: () => _showMultiSelectMenu(context, groups),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight:
                        isAll ? FontWeight.normal : FontWeight.w600,
                  ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _showMultiSelectMenu(
      BuildContext context, List<Group> groups) async {
    // 메뉴 내 공유 상태 — ValueNotifier로 한 번에 갱신
    final notifier = _FilterMenuNotifier(
      groupIds: _selectedGroupIds != null
          ? List<String>.from(_selectedGroupIds!)
          : null,
      includePersonal: _includePersonal,
    );

    void applyToWidget() {
      final s = notifier.value;
      setState(() {
        _selectedGroupIds = s.groupIds;
        _includePersonal = s.includePersonal;
      });
      _emit();
      _save();
    }

    final keyContext = _buttonKey.currentContext;
    if (keyContext == null) return;
    final box = keyContext.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final offset = box.localToGlobal(Offset.zero);
    final size = box.size;

    await showMenu<void>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height,
        offset.dx + size.width,
        0,
      ),
      items: [
        _MultiFilterMenuItem(
          notifier: notifier,
          groups: groups,
          onChanged: applyToWidget,
        ),
      ],
    );

    notifier.dispose();
  }

  // ── single 모드 드롭다운 (기존) ──────────────────────────────────────────

  Widget _buildSingleDropdown(BuildContext context, List<Group> groups) {
    if (groups.isEmpty && !widget.showPersonal) {
      return Text(
        widget.emptyText ?? '소속된 그룹이 없습니다',
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }

    final String effectiveValue;
    if (widget.showPersonal) {
      effectiveValue = widget.selectedGroupId ?? _kPersonalValue;
    } else {
      effectiveValue =
          widget.selectedGroupId ?? (groups.isNotEmpty ? groups.first.id : '');
    }

    final items = <DropdownMenuItem<String>>[
      if (widget.showPersonal)
        DropdownMenuItem<String>(
          value: _kPersonalValue,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person_outline, size: 16),
              const SizedBox(width: AppSizes.spaceXS),
              Text(widget.personalLabel ?? '개인'),
            ],
          ),
        ),
      ...groups.map<DropdownMenuItem<String>>(
        (g) => DropdownMenuItem<String>(
          value: g.id,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.group_outlined, size: 16),
              const SizedBox(width: AppSizes.spaceXS),
              Text(g.name),
            ],
          ),
        ),
      ),
    ];

    if (items.isEmpty) {
      return Text(
        widget.emptyText ?? '소속된 그룹이 없습니다',
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: items.any((item) => item.value == effectiveValue)
            ? effectiveValue
            : items.first.value,
        isDense: true,
        isExpanded: false,
        items: items,
        onChanged: (value) {
          if (value == _kPersonalValue) {
            widget.onChanged?.call(null);
          } else {
            widget.onChanged?.call(value);
          }
        },
      ),
    );
  }
}

// ── 메뉴 내부 상태 ──────────────────────────────────────────────────────────

/// PopupMenuEntry 구현 — 내부 탭이 메뉴를 닫지 않음
class _MultiFilterMenuItem extends PopupMenuEntry<void> {
  const _MultiFilterMenuItem({
    required this.notifier,
    required this.groups,
    required this.onChanged,
  });

  final _FilterMenuNotifier notifier;
  final List<Group> groups;
  final VoidCallback onChanged;

  @override
  double get height => 0; // showMenu가 높이를 자동 계산

  @override
  bool represents(void value) => false;

  @override
  State<_MultiFilterMenuItem> createState() => _MultiFilterMenuItemState();
}

class _MultiFilterMenuItemState extends State<_MultiFilterMenuItem> {
  @override
  Widget build(BuildContext context) {
    return _MultiFilterMenuBody(
      notifier: widget.notifier,
      groups: widget.groups,
      onChanged: widget.onChanged,
    );
  }
}

class _MenuState {
  _MenuState({required this.groupIds, required this.includePersonal});
  List<String>? groupIds; // null = 전체
  bool includePersonal;
}

class _FilterMenuNotifier extends ValueNotifier<_MenuState> {
  _FilterMenuNotifier({
    required List<String>? groupIds,
    required bool includePersonal,
  }) : super(_MenuState(groupIds: groupIds, includePersonal: includePersonal));

  void toggleAll() {
    if (value.groupIds == null) {
      // 이미 전체 선택 → 나만 보기로 fallback
      value = _MenuState(groupIds: [], includePersonal: true);
    } else {
      // 전체 선택
      value = _MenuState(groupIds: null, includePersonal: true);
    }
  }

  void togglePersonal(List<Group> groups) {
    final cur = value;
    if (cur.groupIds == null) {
      // 전체 → 개인만
      value = _MenuState(groupIds: [], includePersonal: true);
    } else {
      final newInclude = !cur.includePersonal;
      if (!newInclude && (cur.groupIds?.isEmpty ?? true)) return;
      final newIds = List<String>.from(cur.groupIds!);
      final newState = _MenuState(groupIds: newIds, includePersonal: newInclude);
      value = _collapse(newState, groups);
    }
  }

  void toggleGroup(String groupId, List<Group> groups) {
    final cur = value;
    List<String> newIds;
    if (cur.groupIds == null) {
      newIds = groups.map((g) => g.id).where((id) => id != groupId).toList();
    } else {
      newIds = List<String>.from(cur.groupIds!);
      if (newIds.contains(groupId)) {
        if (newIds.length == 1 && !cur.includePersonal) return;
        newIds.remove(groupId);
      } else {
        newIds.add(groupId);
      }
    }
    final newState = _MenuState(groupIds: newIds, includePersonal: cur.includePersonal);
    value = _collapse(newState, groups);
  }

  // 전부 선택된 상태면 null(전체)로 수렴
  _MenuState _collapse(_MenuState s, List<Group> groups) {
    if (s.groupIds != null &&
        s.groupIds!.length == groups.length &&
        s.includePersonal) {
      return _MenuState(groupIds: null, includePersonal: true);
    }
    return s;
  }
}

// ── 메뉴 본문 위젯 ──────────────────────────────────────────────────────────

class _MultiFilterMenuBody extends StatefulWidget {
  const _MultiFilterMenuBody({
    required this.notifier,
    required this.groups,
    required this.onChanged,
  });

  final _FilterMenuNotifier notifier;
  final List<Group> groups;
  final VoidCallback onChanged;

  @override
  State<_MultiFilterMenuBody> createState() => _MultiFilterMenuBodyState();
}

class _MultiFilterMenuBodyState extends State<_MultiFilterMenuBody> {
  @override
  void initState() {
    super.initState();
    widget.notifier.addListener(_onNotifier);
  }

  @override
  void dispose() {
    widget.notifier.removeListener(_onNotifier);
    super.dispose();
  }

  void _onNotifier() {
    if (mounted) setState(() {});
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.notifier.value;
    final isAll = s.groupIds == null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 전체
        CheckboxListTile(
          dense: true,
          value: isAll,
          title: const Row(children: [
            Icon(Icons.all_inclusive, size: 16),
            SizedBox(width: AppSizes.spaceXS),
            Text('전체'),
          ]),
          onChanged: (_) => widget.notifier.toggleAll(),
          controlAffinity: ListTileControlAffinity.leading,
          tristate: false,
        ),
        // 나만 보기
        CheckboxListTile(
          dense: true,
          value: isAll || s.includePersonal,
          title: const Row(children: [
            Icon(Icons.person_outline, size: 16),
            SizedBox(width: AppSizes.spaceXS),
            Text('나만 보기'),
          ]),
          onChanged: (_) => widget.notifier.togglePersonal(widget.groups),
          controlAffinity: ListTileControlAffinity.leading,
          tristate: false,
        ),
        // 그룹별
        ...widget.groups.map(
          (g) => CheckboxListTile(
            dense: true,
            value: isAll || (s.groupIds?.contains(g.id) ?? false),
            title: Row(children: [
              const Icon(Icons.group_outlined, size: 16),
              const SizedBox(width: AppSizes.spaceXS),
              Text(g.name),
            ]),
            onChanged: (_) => widget.notifier.toggleGroup(g.id, widget.groups),
            controlAffinity: ListTileControlAffinity.leading,
            tristate: false,
          ),
        ),
      ],
    );
  }
}
