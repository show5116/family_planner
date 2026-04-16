import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/widgets/color_picker.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';

/// 그룹 생성 다이얼로그
class GroupCreateDialog {
  static void show(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    Color selectedColor = const Color(0xFF6366F1); // 기본 색상

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.group_createGroup),
          content: SizedBox(
            width: double.maxFinite,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: l10n.group_groupName,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.group_groupNameRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.spaceM),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: l10n.group_groupDescription,
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: AppSizes.spaceM),
                    // 색상 선택
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.group_defaultColor,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceS),
                    ColorPicker(
                      selectedColor: selectedColor,
                      onColorSelected: (color) {
                        setState(() => selectedColor = color);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.group_cancel),
            ),
            ElevatedButton(
              onPressed: () => _handleCreate(
                dialogContext,
                context,
                ref,
                l10n,
                formKey,
                nameController,
                descriptionController,
                selectedColor,
              ),
              child: Text(l10n.group_create),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _handleCreate(
    BuildContext dialogContext,
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    GlobalKey<FormState> formKey,
    TextEditingController nameController,
    TextEditingController descriptionController,
    Color selectedColor,
  ) async {
    if (formKey.currentState!.validate()) {
      final r = (selectedColor.r * 255).round();
      final g = (selectedColor.g * 255).round();
      final b = (selectedColor.b * 255).round();
      final hexColor =
          '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}'.toUpperCase();
      try {
        await ref.read(groupNotifierProvider.notifier).createGroup(
              name: nameController.text,
              description: descriptionController.text.isEmpty
                  ? null
                  : descriptionController.text,
              defaultColor: hexColor,
            );

        if (dialogContext.mounted) {
          Navigator.pop(dialogContext);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.group_createSuccess)),
          );
        }
      } catch (e) {
        if (dialogContext.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('오류: ${e.toString()}')),
          );
        }
      }
    }
  }
}
