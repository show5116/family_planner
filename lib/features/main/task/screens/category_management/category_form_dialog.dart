import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 카테고리 추가/수정 다이얼로그
class CategoryFormDialog extends StatefulWidget {
  final CategoryModel? category;
  final AppLocalizations l10n;

  const CategoryFormDialog({
    super.key,
    this.category,
    required this.l10n,
  });

  @override
  State<CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<CategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedEmoji;
  Color _selectedColor = AppColors.primary;

  bool get _isEditMode => widget.category != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      final category = widget.category!;
      _nameController.text = category.name;
      _descriptionController.text = category.description ?? '';
      _selectedEmoji = category.emoji;
      if (category.color != null) {
        _selectedColor = Color(
          int.parse('FF${category.color!.replaceFirst('#', '')}', radix: 16),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;

    return AlertDialog(
      title: Text(_isEditMode ? l10n.category_edit : l10n.category_add),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 카테고리 이름
              _NameField(
                controller: _nameController,
                l10n: l10n,
              ),
              const SizedBox(height: AppSizes.spaceM),

              // 설명
              _DescriptionField(
                controller: _descriptionController,
                l10n: l10n,
              ),
              const SizedBox(height: AppSizes.spaceM),

              // 이모지 선택
              _EmojiSelector(
                selectedEmoji: _selectedEmoji,
                selectedColor: _selectedColor,
                onEmojiSelected: (emoji) {
                  setState(() {
                    _selectedEmoji = _selectedEmoji == emoji ? null : emoji;
                  });
                },
                l10n: l10n,
              ),
              const SizedBox(height: AppSizes.spaceM),

              // 색상 선택
              _ColorSelector(
                selectedColor: _selectedColor,
                onColorSelected: (color) {
                  setState(() {
                    _selectedColor = color;
                  });
                },
                l10n: l10n,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.common_cancel),
        ),
        ElevatedButton(
          onPressed: _handleSubmit,
          child: Text(_isEditMode ? l10n.common_save : l10n.common_add),
        ),
      ],
    );
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final colorHex =
        '#${_selectedColor.toARGB32().toRadixString(16).substring(2).toUpperCase()}';

    Navigator.pop(context, {
      'name': _nameController.text.trim(),
      'description': _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      'emoji': _selectedEmoji,
      'color': colorHex,
    });
  }
}

/// 카테고리 이름 입력 필드
class _NameField extends StatelessWidget {
  final TextEditingController controller;
  final AppLocalizations l10n;

  const _NameField({
    required this.controller,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: l10n.category_name,
        hintText: l10n.category_nameHint,
        border: const OutlineInputBorder(),
      ),
      maxLength: 20,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return l10n.category_nameRequired;
        }
        return null;
      },
    );
  }
}

/// 카테고리 설명 입력 필드
class _DescriptionField extends StatelessWidget {
  final TextEditingController controller;
  final AppLocalizations l10n;

  const _DescriptionField({
    required this.controller,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: l10n.category_description,
        hintText: l10n.category_descriptionHint,
        border: const OutlineInputBorder(),
      ),
      maxLength: 50,
      maxLines: 2,
    );
  }
}

/// 이모지 선택 위젯
class _EmojiSelector extends StatelessWidget {
  final String? selectedEmoji;
  final Color selectedColor;
  final ValueChanged<String> onEmojiSelected;
  final AppLocalizations l10n;

  const _EmojiSelector({
    required this.selectedEmoji,
    required this.selectedColor,
    required this.onEmojiSelected,
    required this.l10n,
  });

  // 미리 정의된 이모지 목록
  static const List<String> _emojiOptions = [
    '💼', '📅', '🏠', '💪', '📚', '🎉', '✈️', '🍽️',
    '💰', '🏥', '🛒', '🎨', '🎵', '⚽', '🐾', '❤️',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.category_emoji,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: AppSizes.spaceS),
        Wrap(
          spacing: AppSizes.spaceXS,
          runSpacing: AppSizes.spaceXS,
          children: _emojiOptions.map((emoji) {
            final isSelected = selectedEmoji == emoji;
            return GestureDetector(
              onTap: () => onEmojiSelected(emoji),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? selectedColor.withValues(alpha: 0.2)
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? selectedColor : AppColors.divider,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 20)),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// 색상 선택 위젯
class _ColorSelector extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;
  final AppLocalizations l10n;

  const _ColorSelector({
    required this.selectedColor,
    required this.onColorSelected,
    required this.l10n,
  });

  // 미리 정의된 색상 목록
  static const List<Color> _colorOptions = [
    Color(0xFF3B82F6), // Blue
    Color(0xFF10B981), // Green
    Color(0xFFF59E0B), // Amber
    Color(0xFFEF4444), // Red
    Color(0xFF8B5CF6), // Purple
    Color(0xFFEC4899), // Pink
    Color(0xFF06B6D4), // Cyan
    Color(0xFF6366F1), // Indigo
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.category_color,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: AppSizes.spaceS),
        Wrap(
          spacing: AppSizes.spaceS,
          runSpacing: AppSizes.spaceS,
          children: _colorOptions.map((color) {
            final isSelected = selectedColor.toARGB32() == color.toARGB32();
            return GestureDetector(
              onTap: () => onColorSelected(color),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: Colors.white, width: 3)
                      : null,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: color.withValues(alpha: 0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
