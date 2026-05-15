import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';

const _kPersonalValue = '__personal__';

/// 화면 상단 그룹 선택 바 — 모든 기능 화면에서 공용으로 사용
///
/// - [showPersonal]: 개인 항목 표시 여부 (가계부 등에서 true)
/// - [selectedGroupId]: 현재 선택된 그룹 ID (null = 개인)
/// - [onChanged]: 선택 변경 콜백 (null이면 개인 선택)
/// - [trailing]: 오른쪽 추가 위젯 (가계부 월 이동 버튼 등)
/// - [personalLabel]: showPersonal=true일 때 표시할 개인 항목 텍스트 (기본: "개인")
class GroupFilterBar extends ConsumerWidget {
  const GroupFilterBar({
    super.key,
    required this.selectedGroupId,
    required this.onChanged,
    this.showPersonal = false,
    this.trailing,
    this.personalLabel,
    this.emptyText,
  });

  final String? selectedGroupId;
  final ValueChanged<String?> onChanged;
  final bool showPersonal;
  final Widget? trailing;
  final String? personalLabel;
  final String? emptyText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              data: (groups) => _buildDropdown(context, groups),
              loading: () => const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (_, _) => Text(
                emptyText ?? '그룹을 선택해주세요',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }

  Widget _buildDropdown(BuildContext context, List<Group> groups) {
    if (groups.isEmpty && !showPersonal) {
      return Text(
        emptyText ?? '소속된 그룹이 없습니다',
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }

    final String effectiveValue;
    if (showPersonal) {
      effectiveValue = selectedGroupId ?? _kPersonalValue;
    } else {
      effectiveValue = selectedGroupId ?? (groups.isNotEmpty ? groups.first.id : '');
    }

    final items = <DropdownMenuItem<String>>[
      if (showPersonal)
        DropdownMenuItem<String>(
          value: _kPersonalValue,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person_outline, size: 16),
              const SizedBox(width: AppSizes.spaceXS),
              Text(personalLabel ?? '개인'),
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
        emptyText ?? '소속된 그룹이 없습니다',
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
            onChanged(null);
          } else {
            onChanged(value);
          }
        },
      ),
    );
  }
}
