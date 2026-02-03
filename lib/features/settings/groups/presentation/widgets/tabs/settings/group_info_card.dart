import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/widgets/color_picker.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/features/settings/groups/utils/group_utils.dart';

/// 그룹 정보 카드
class GroupInfoCard extends ConsumerWidget {
  final Group group;
  final bool canUpdate;

  const GroupInfoCard({
    super.key,
    required this.group,
    required this.canUpdate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.group_groupName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (canUpdate)
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () => _showEditGroupDialog(context, ref, l10n),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              group.name,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.spaceM),
            Text(
              l10n.group_groupDescription,
              style: theme.textTheme.titleSmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(group.description ?? '-', style: theme.textTheme.bodyMedium),
            const SizedBox(height: AppSizes.spaceM),
            Text(
              l10n.group_createdAt,
              style: theme.textTheme.titleSmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              GroupUtils.formatDate(group.createdAt),
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  /// 그룹 수정 다이얼로그 표시
  Future<void> _showEditGroupDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final nameController = TextEditingController(text: group.name);
    final descriptionController = TextEditingController(
      text: group.description,
    );

    // 초기 색상 설정
    Color? selectedColor = GroupUtils.parseColor(group.defaultColor);

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.group_editGroup),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: l10n.group_groupName,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSizes.spaceM),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: l10n.group_groupDescription,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: AppSizes.spaceM),
                // 색상 선택 섹션
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.group_defaultColor,
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    ColorPicker(
                      selectedColor: selectedColor,
                      onColorSelected: (color) {
                        setState(() => selectedColor = color);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.group_cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, {
                'name': nameController.text,
                'description': descriptionController.text,
                'color': selectedColor,
              }),
              child: Text(l10n.group_save),
            ),
          ],
        ),
      ),
    );

    if (result == null) {
      return;
    }

    // context.mounted 체크를 하지 않고 바로 API 호출
    try {
      final String? colorHex = result['color'] != null
          ? GroupUtils.colorToHex(result['color'] as Color)
          : null;

      await ref
          .read(groupNotifierProvider.notifier)
          .updateGroup(
            group.id,
            name: result['name'] as String,
            description: result['description'] as String,
            defaultColor: colorHex,
          );

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.group_updateSuccess)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('오류: $e')));
      }
    }

    nameController.dispose();
    descriptionController.dispose();
  }
}
