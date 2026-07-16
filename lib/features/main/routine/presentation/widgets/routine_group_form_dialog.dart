import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/data/repositories/routine_repository.dart';
import 'package:family_planner/features/main/routine/providers/routine_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

const List<String> _kGroupEmojiPresets = [
  '🌅', '☀️', '🌙', '🏃', '💪', '🧘',
  '📚', '✍️', '🎯', '🧹', '💼', '🍎',
];

/// 루틴(습관 묶음) 생성/수정 다이얼로그. [group]이 null이면 생성 모드.
class RoutineGroupFormDialog extends ConsumerStatefulWidget {
  const RoutineGroupFormDialog({super.key, this.group});

  final RoutineGroup? group;

  @override
  ConsumerState<RoutineGroupFormDialog> createState() =>
      _RoutineGroupFormDialogState();
}

class _RoutineGroupFormDialogState
    extends ConsumerState<RoutineGroupFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _titleController = TextEditingController(
    text: widget.group?.title ?? '',
  );
  late final _emojiController = TextEditingController(
    text: widget.group?.emoji ?? '',
  );
  late String? _selectedColor = widget.group?.color;
  bool _saving = false;

  bool get _isEditing => widget.group != null;

  @override
  void dispose() {
    _titleController.dispose();
    _emojiController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final notifier = ref.read(routineGroupManagementProvider.notifier);
    final title = _titleController.text.trim();
    final emoji = _emojiController.text.trim();

    final RoutineGroup? result;
    if (_isEditing) {
      result = await notifier.updateRoutineGroup(
        widget.group!.id,
        UpdateRoutineGroupDto(
          title: title,
          emoji: emoji.isEmpty ? null : emoji,
          color: _selectedColor,
        ),
      );
    } else {
      result = await notifier.createRoutineGroup(
        CreateRoutineGroupDto(
          title: title,
          emoji: emoji.isEmpty ? null : emoji,
          color: _selectedColor,
        ),
      );
    }

    if (!mounted) return;
    setState(() => _saving = false);

    final l10n = AppLocalizations.of(context)!;
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.routine_group_error_generic)),
      );
      return;
    }

    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(_isEditing ? l10n.routine_group_edit : l10n.routine_group_add),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                maxLength: 100,
                decoration: InputDecoration(
                  labelText: l10n.routine_field_title,
                  hintText: l10n.routine_group_field_title_hint,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.routine_field_title_required;
                  }
                  if (value.trim().length > 100) {
                    return l10n.routine_field_title_too_long;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.spaceM),
              Text(l10n.routine_field_emoji, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: AppSizes.spaceS),
              Wrap(
                spacing: AppSizes.spaceS,
                runSpacing: AppSizes.spaceS,
                children: _kGroupEmojiPresets.map((emoji) {
                  final selected = _emojiController.text == emoji;
                  return InkWell(
                    onTap: () => setState(() => _emojiController.text = emoji),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: selected
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.surfaceContainerHighest,
                        shape: BoxShape.circle,
                        border: selected
                            ? Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              )
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(emoji, style: const TextStyle(fontSize: 18)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSizes.spaceS),
              TextFormField(
                controller: _emojiController,
                maxLength: 4,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: l10n.routine_field_emoji_custom,
                  helperText: l10n.routine_field_emoji_helper,
                ),
              ),
              const SizedBox(height: AppSizes.spaceS),
              Text(l10n.routine_field_color, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: AppSizes.spaceS),
              Wrap(
                spacing: AppSizes.spaceS,
                runSpacing: AppSizes.spaceS,
                children: AppColors.routineColorPresets.map((hex) {
                  final color = AppColors.parseHex(hex);
                  final selected = _selectedColor == hex;
                  return InkWell(
                    onTap: () => setState(() => _selectedColor = hex),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: selected
                            ? Border.all(
                                color: Theme.of(context).colorScheme.onSurface,
                                width: 2,
                              )
                            : null,
                      ),
                      child: selected
                          ? const Icon(Icons.check, color: Colors.white, size: 18)
                          : null,
                    ),
                  );
                }).toList(),
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
              : Text(l10n.routine_group_save),
        ),
      ],
    );
  }
}
