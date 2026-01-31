import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 카테고리 관리 화면
class CategoryManagementScreen extends ConsumerWidget {
  const CategoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final categoriesAsync = ref.watch(categoryManagementProvider);
    final selectedGroupId = ref.watch(selectedGroupIdProvider);
    final groupsAsync = ref.watch(myGroupsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.category_management),
      ),
      body: Column(
        children: [
          // 그룹 선택 섹션
          _buildGroupSelector(context, ref, l10n, selectedGroupId, groupsAsync),

          // 카테고리 목록
          Expanded(
            child: categoriesAsync.when(
              data: (categories) {
                if (categories.isEmpty) {
                  return _buildEmptyState(context, l10n);
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(AppSizes.spaceM),
                  itemCount: categories.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSizes.spaceS),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return _CategoryListItem(
                      category: category,
                      onEdit: () => _showCategoryDialog(context, ref, l10n, category: category),
                      onDelete: () => _confirmDelete(context, ref, l10n, category),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _buildErrorState(context, l10n, ref, error.toString()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(context, ref, l10n),
        tooltip: l10n.category_add,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// 그룹 선택 섹션
  Widget _buildGroupSelector(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String? selectedGroupId,
    AsyncValue<List<Group>> groupsAsync,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            l10n.schedule_group,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(width: AppSizes.spaceM),
          Expanded(
            child: groupsAsync.when(
              data: (groups) {
                final items = <DropdownMenuItem<String?>>[];

                // 개인 옵션
                items.add(
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Row(
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
                        children: [
                          Icon(
                            Icons.group,
                            size: 20,
                            color: group.defaultColor != null
                                ? Color(int.parse('FF${group.defaultColor!.replaceFirst('#', '')}', radix: 16))
                                : null,
                          ),
                          const SizedBox(width: AppSizes.spaceS),
                          Expanded(
                            child: Text(
                              group.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return DropdownButtonHideUnderline(
                  child: DropdownButton<String?>(
                    value: selectedGroupId,
                    items: items,
                    onChanged: (value) {
                      ref.read(selectedGroupIdProvider.notifier).state = value;
                    },
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down),
                  ),
                );
              },
              loading: () => const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (error, stack) => Text(l10n.schedule_personal),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category_outlined,
            size: AppSizes.iconXLarge,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            l10n.category_empty,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            l10n.category_emptyHint,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, AppLocalizations l10n, WidgetRef ref, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: AppSizes.iconXLarge,
            color: AppColors.error,
          ),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            l10n.category_loadError,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            error,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spaceM),
          ElevatedButton.icon(
            onPressed: () => ref.read(categoryManagementProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh),
            label: Text(l10n.common_retry),
          ),
        ],
      ),
    );
  }

  Future<void> _showCategoryDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n, {
    CategoryModel? category,
  }) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _CategoryFormDialog(
        category: category,
        l10n: l10n,
      ),
    );

    if (result != null && context.mounted) {
      final notifier = ref.read(categoryManagementProvider.notifier);

      if (category != null) {
        // 수정
        final updated = await notifier.updateCategory(
          category.id,
          name: result['name'] as String,
          description: result['description'] as String?,
          emoji: result['emoji'] as String?,
          color: result['color'] as String?,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(updated != null
                  ? l10n.category_updateSuccess
                  : l10n.category_updateError),
              backgroundColor: updated != null ? null : AppColors.error,
            ),
          );
        }
      } else {
        // 생성
        final created = await notifier.createCategory(
          name: result['name'] as String,
          description: result['description'] as String?,
          emoji: result['emoji'] as String?,
          color: result['color'] as String?,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(created != null
                  ? l10n.category_createSuccess
                  : l10n.category_createError),
              backgroundColor: created != null ? null : AppColors.error,
            ),
          );
        }
      }
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    CategoryModel category,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.category_deleteDialogTitle),
        content: Text(l10n.category_deleteDialogMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.common_delete),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success =
          await ref.read(categoryManagementProvider.notifier).deleteCategory(category.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? l10n.category_deleteSuccess
                : l10n.category_deleteError),
            backgroundColor: success ? null : AppColors.error,
          ),
        );
      }
    }
  }
}

/// 카테고리 목록 아이템 위젯
class _CategoryListItem extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryListItem({
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = category.color != null
        ? Color(int.parse('FF${category.color!.replaceFirst('#', '')}', radix: 16))
        : AppColors.primary;

    return Card(
      elevation: AppSizes.elevation1,
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          child: Center(
            child: category.emoji != null
                ? Text(category.emoji!, style: const TextStyle(fontSize: 24))
                : Icon(Icons.category, color: color),
          ),
        ),
        title: Text(
          category.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: category.description != null && category.description!.isNotEmpty
            ? Text(
                category.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 색상 표시
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSizes.spaceS),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (context) {
                final l10n = AppLocalizations.of(context)!;
                return [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        const Icon(Icons.edit_outlined, size: 20),
                        const SizedBox(width: AppSizes.spaceS),
                        Text(l10n.common_edit),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                        const SizedBox(width: AppSizes.spaceS),
                        Text(l10n.common_delete, style: TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// 카테고리 추가/수정 다이얼로그
class _CategoryFormDialog extends StatefulWidget {
  final CategoryModel? category;
  final AppLocalizations l10n;

  const _CategoryFormDialog({
    this.category,
    required this.l10n,
  });

  @override
  State<_CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<_CategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedEmoji;
  Color _selectedColor = AppColors.primary;

  // 미리 정의된 색상 목록
  final List<Color> _colorOptions = [
    const Color(0xFF3B82F6), // Blue
    const Color(0xFF10B981), // Green
    const Color(0xFFF59E0B), // Amber
    const Color(0xFFEF4444), // Red
    const Color(0xFF8B5CF6), // Purple
    const Color(0xFFEC4899), // Pink
    const Color(0xFF06B6D4), // Cyan
    const Color(0xFF6366F1), // Indigo
  ];

  // 미리 정의된 이모지 목록
  final List<String> _emojiOptions = [
    '💼', '📅', '🏠', '💪', '📚', '🎉', '✈️', '🍽️',
    '💰', '🏥', '🛒', '🎨', '🎵', '⚽', '🐾', '❤️',
  ];

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
              TextFormField(
                controller: _nameController,
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
              ),
              const SizedBox(height: AppSizes.spaceM),

              // 설명
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: l10n.category_description,
                  hintText: l10n.category_descriptionHint,
                  border: const OutlineInputBorder(),
                ),
                maxLength: 50,
                maxLines: 2,
              ),
              const SizedBox(height: AppSizes.spaceM),

              // 이모지 선택
              Text(
                l10n.category_emoji,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: AppSizes.spaceS),
              Wrap(
                spacing: AppSizes.spaceXS,
                runSpacing: AppSizes.spaceXS,
                children: _emojiOptions.map((emoji) {
                  final isSelected = _selectedEmoji == emoji;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedEmoji = isSelected ? null : emoji;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? _selectedColor.withValues(alpha: 0.2)
                            : Colors.transparent,
                        border: Border.all(
                          color: isSelected ? _selectedColor : AppColors.divider,
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
              const SizedBox(height: AppSizes.spaceM),

              // 색상 선택
              Text(
                l10n.category_color,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: AppSizes.spaceS),
              Wrap(
                spacing: AppSizes.spaceS,
                runSpacing: AppSizes.spaceS,
                children: _colorOptions.map((color) {
                  final isSelected = _selectedColor.toARGB32() == color.toARGB32();
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
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
