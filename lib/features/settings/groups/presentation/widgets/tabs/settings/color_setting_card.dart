import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/widgets/color_picker.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/models/group_member.dart';
import 'package:family_planner/features/settings/groups/utils/group_utils.dart';

/// 색상 설정 카드
class ColorSettingCard extends StatelessWidget {
  final Group group;
  final AsyncValue<List<GroupMember>> membersAsync;
  final Function(Color color) onColorChange;
  final VoidCallback onResetColor;

  const ColorSettingCard({
    super.key,
    required this.group,
    required this.membersAsync,
    required this.onColorChange,
    required this.onResetColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // 현재 사용자의 customColor 또는 그룹 defaultColor 가져오기
    final String? displayColorHex = membersAsync.when(
      data: (members) {
        if (members.isEmpty) return group.defaultColor;
        // 첫 번째 멤버를 현재 사용자로 간주
        final currentMember = members.first;
        return currentMember.customColor ?? group.defaultColor;
      },
      loading: () => group.defaultColor,
      error: (_, __) => group.defaultColor,
    );

    final Color displayColor =
        GroupUtils.parseColor(displayColorHex) ?? Colors.blue;
    final bool hasCustomColor = membersAsync.when(
      data: (members) =>
          members.isNotEmpty && members.first.customColor != null,
      loading: () => false,
      error: (_, __) => false,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '나만의 그룹 색상',
              style: theme.textTheme.titleSmall?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: displayColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                ),
                const SizedBox(width: AppSizes.spaceM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!hasCustomColor)
                        Text(
                          '설정하지 않음 (그룹 기본 색상 사용)',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        )
                      else
                        Text(
                          '설정됨',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
                if (hasCustomColor)
                  TextButton(
                    onPressed: onResetColor,
                    child: const Text('초기화'),
                  ),
                TextButton(
                  onPressed: () =>
                      _showColorPicker(context, l10n, displayColor),
                  child: Text(l10n.group_edit),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showColorPicker(
    BuildContext context,
    AppLocalizations l10n,
    Color currentColor,
  ) async {
    final selectedColor = await showColorPickerDialog(
      context: context,
      title: l10n.group_customColor,
      initialColor: currentColor,
      confirmText: l10n.group_save,
      cancelText: l10n.group_cancel,
    );

    if (selectedColor != null) {
      onColorChange(selectedColor);
    }
  }
}
