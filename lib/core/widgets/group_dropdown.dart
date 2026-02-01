import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 그룹 선택 스타일 타입
enum GroupDropdownStyle {
  /// AppBar 타이틀용 (isDense: true)
  appBar,

  /// 일반 폼 필드용 (isExpanded: true)
  form,
}

/// 공통 그룹 드롭다운 위젯
///
/// 개인/그룹 선택을 위한 재사용 가능한 드롭다운입니다.
/// [style] 파라미터로 사용 컨텍스트에 맞는 스타일을 선택할 수 있습니다.
class GroupDropdown extends StatelessWidget {
  final List<Group> groups;
  final String? selectedGroupId;
  final ValueChanged<String?> onChanged;
  final GroupDropdownStyle style;

  const GroupDropdown({
    super.key,
    required this.groups,
    required this.selectedGroupId,
    required this.onChanged,
    this.style = GroupDropdownStyle.form,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = _buildItems(l10n);

    return DropdownButtonHideUnderline(
      child: DropdownButton<String?>(
        value: selectedGroupId,
        items: items,
        onChanged: onChanged,
        icon: const Icon(Icons.arrow_drop_down),
        isDense: style == GroupDropdownStyle.appBar,
        isExpanded: style == GroupDropdownStyle.form,
      ),
    );
  }

  List<DropdownMenuItem<String?>> _buildItems(AppLocalizations l10n) {
    final items = <DropdownMenuItem<String?>>[];

    // 개인 옵션
    items.add(
      DropdownMenuItem<String?>(
        value: null,
        child: Row(
          mainAxisSize: style == GroupDropdownStyle.appBar
              ? MainAxisSize.min
              : MainAxisSize.max,
          children: [
            const Icon(Icons.person, size: 20),
            const SizedBox(width: AppSizes.spaceS),
            Text(l10n.schedule_personal),
          ],
        ),
      ),
    );

    // 그룹 옵션들
    for (final group in groups) {
      items.add(
        DropdownMenuItem<String?>(
          value: group.id,
          child: Row(
            mainAxisSize: style == GroupDropdownStyle.appBar
                ? MainAxisSize.min
                : MainAxisSize.max,
            children: [
              Icon(
                Icons.group,
                size: 20,
                color: _parseGroupColor(group.defaultColor),
              ),
              const SizedBox(width: AppSizes.spaceS),
              style == GroupDropdownStyle.form
                  ? Expanded(
                      child: Text(
                        group.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  : Text(
                      group.name,
                      overflow: TextOverflow.ellipsis,
                    ),
            ],
          ),
        ),
      );
    }

    return items;
  }

  Color? _parseGroupColor(String? colorHex) {
    if (colorHex == null) return null;
    return Color(
      int.parse('FF${colorHex.replaceFirst('#', '')}', radix: 16),
    );
  }
}
