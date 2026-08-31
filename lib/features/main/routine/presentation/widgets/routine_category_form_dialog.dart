import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/data/repositories/routine_repository.dart';
import 'package:family_planner/features/main/routine/providers/routine_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/color_picker_row.dart';
import 'package:family_planner/shared/widgets/emoji_picker_field.dart';

/// 루틴 카테고리 생성/수정 다이얼로그. [category]가 null이면 생성 모드.
class RoutineCategoryFormDialog extends ConsumerStatefulWidget {
  const RoutineCategoryFormDialog({super.key, this.category});

  final RoutineCategory? category;

  @override
  ConsumerState<RoutineCategoryFormDialog> createState() =>
      _RoutineCategoryFormDialogState();
}

class _RoutineCategoryFormDialogState
    extends ConsumerState<RoutineCategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _titleController = TextEditingController(
    text: widget.category?.title ?? '',
  );
  late String? _emoji = widget.category?.emoji ?? '✅';
  late String? _selectedColor = widget.category?.color;
  bool _saving = false;

  bool get _isEditing => widget.category != null;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final notifier = ref.read(routineCategoryManagementProvider.notifier);
    final title = _titleController.text.trim();
    final emoji = _emoji;

    final RoutineCategory? result;
    if (_isEditing) {
      result = await notifier.updateRoutineCategory(
        widget.category!.id,
        UpdateRoutineCategoryDto(
          title: title,
          emoji: (emoji == null || emoji.isEmpty) ? null : emoji,
          color: _selectedColor,
        ),
      );
    } else {
      result = await notifier.createRoutineCategory(
        CreateRoutineCategoryDto(
          title: title,
          emoji: (emoji == null || emoji.isEmpty) ? null : emoji,
          color: _selectedColor,
        ),
      );
    }

    if (!mounted) return;
    setState(() => _saving = false);

    final l10n = AppLocalizations.of(context)!;
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.routine_category_error_generic)),
      );
      return;
    }

    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(
        _isEditing ? l10n.routine_category_edit : l10n.routine_category_add,
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EmojiPickerField(
                selectedEmoji: _emoji,
                onEmojiChanged: (emoji) => setState(() => _emoji = emoji),
                controller: _titleController,
                maxLength: 50,
                labelText: l10n.routine_field_title,
                hintText: l10n.routine_category_field_title_hint,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.routine_field_title_required;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.spaceS),
              ColorPickerRow(
                label: l10n.routine_field_color,
                selectedColor: AppColors.parseHex(_selectedColor),
                availableColors: AppColors.routineColorPresets
                    .map((hex) => AppColors.parseHex(hex))
                    .toList(),
                onColorSelected: (color) =>
                    setState(() => _selectedColor = AppColors.toHex(color)),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.routine_category_save),
        ),
      ],
    );
  }
}
