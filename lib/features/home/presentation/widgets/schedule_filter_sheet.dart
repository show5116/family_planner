import 'package:flutter/material.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';

/// 일정/할일 위젯 공통 필터 바텀시트
class ScheduleFilterSheet extends StatefulWidget {
  const ScheduleFilterSheet({
    super.key,
    required this.groups,
    required this.selectedGroupIds,
    required this.includePersonal,
    required this.onApply,
  });

  final List<Group> groups;
  final List<String>? selectedGroupIds;
  final bool includePersonal;
  final void Function(List<String>? selectedGroupIds, bool includePersonal) onApply;

  @override
  State<ScheduleFilterSheet> createState() => _ScheduleFilterSheetState();
}

class _ScheduleFilterSheetState extends State<ScheduleFilterSheet> {
  late List<String>? _selectedGroupIds;
  late bool _includePersonal;

  @override
  void initState() {
    super.initState();
    _selectedGroupIds = widget.selectedGroupIds == null
        ? null
        : List<String>.from(widget.selectedGroupIds!);
    _includePersonal = widget.includePersonal;
  }

  bool _isAllGroups() => _selectedGroupIds == null;

  void _toggleAllGroups() {
    setState(() {
      if (_selectedGroupIds == null) {
        // 전체 선택 → 전체 해제
        _selectedGroupIds = [];
      } else {
        // 일부 또는 없음 → 전체 선택
        _selectedGroupIds = null;
      }
    });
  }

  void _toggleGroup(String groupId) {
    setState(() {
      if (_selectedGroupIds == null) {
        // 전체 선택 상태에서 하나 해제
        _selectedGroupIds = widget.groups
            .map((g) => g.id)
            .where((id) => id != groupId)
            .toList();
      } else if (_selectedGroupIds!.contains(groupId)) {
        _selectedGroupIds!.remove(groupId);
        // 빈 리스트 허용 — 그룹 전부 해제 = 개인만 보기
      } else {
        _selectedGroupIds!.add(groupId);
        if (_selectedGroupIds!.length == widget.groups.length) {
          _selectedGroupIds = null;
        }
      }
    });
  }

  bool _isGroupSelected(String groupId) {
    if (_selectedGroupIds == null) return true;
    return _selectedGroupIds!.contains(groupId);
  }

  Color _parseColor(String? hex) {
    if (hex == null) return Colors.grey;
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: AppSizes.spaceM),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.spaceL, AppSizes.spaceM, AppSizes.spaceL, AppSizes.spaceS,
            ),
            child: Text('필터', style: Theme.of(context).textTheme.titleLarge),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('개인 일정'),
            subtitle: const Text('내 개인 일정 포함'),
            value: _includePersonal,
            onChanged: (v) => setState(() => _includePersonal = v),
          ),
          if (widget.groups.isNotEmpty) ...[
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceL,
                vertical: AppSizes.spaceS,
              ),
              child: Text(
                '그룹 일정',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
            CheckboxListTile(
              title: const Text('전체 그룹'),
              value: _isAllGroups(),
              onChanged: (_) => _toggleAllGroups(),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            ...widget.groups.map((group) => CheckboxListTile(
                  title: Text(group.name),
                  value: _isGroupSelected(group.id),
                  onChanged: (_) => _toggleGroup(group.id),
                  controlAffinity: ListTileControlAffinity.leading,
                  secondary: group.myColor != null || group.defaultColor != null
                      ? CircleAvatar(
                          radius: 8,
                          backgroundColor:
                              _parseColor(group.myColor ?? group.defaultColor),
                        )
                      : null,
                )),
          ],
          const SizedBox(height: AppSizes.spaceS),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.spaceL, 0, AppSizes.spaceL, AppSizes.spaceL,
            ),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () =>
                    widget.onApply(_selectedGroupIds, _includePersonal),
                child: const Text('적용'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
