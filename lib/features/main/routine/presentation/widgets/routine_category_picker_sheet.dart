import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/widgets/reorderable_widgets.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_category_form_dialog.dart';
import 'package:family_planner/features/main/routine/providers/routine_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 루틴 카테고리 다중 선택 바텀시트를 연다.
/// 선택된 카테고리 id 집합을 반환하며, 취소(뒤로가기)해도 그 시점까지의
/// 선택값이 반환된다(별도 취소 개념 없이 즉시 반영되는 체크리스트 방식).
Future<Set<String>> showRoutineCategoryPickerSheet(
  BuildContext context, {
  required Set<String> selectedIds,
}) async {
  final result = await showModalBottomSheet<Set<String>>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSizes.radiusMedium),
      ),
    ),
    builder: (context) =>
        _RoutineCategoryPickerSheet(initialSelectedIds: selectedIds),
  );
  return result ?? selectedIds;
}

class _RoutineCategoryPickerSheet extends ConsumerStatefulWidget {
  const _RoutineCategoryPickerSheet({required this.initialSelectedIds});

  final Set<String> initialSelectedIds;

  @override
  ConsumerState<_RoutineCategoryPickerSheet> createState() =>
      _RoutineCategoryPickerSheetState();
}

class _RoutineCategoryPickerSheetState
    extends ConsumerState<_RoutineCategoryPickerSheet> {
  final Set<String> _selectedIds = {};
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _selectedIds.addAll(widget.initialSelectedIds);
  }

  Future<void> _addCategory() async {
    final result = await showDialog<RoutineCategory>(
      context: context,
      builder: (context) => const RoutineCategoryFormDialog(),
    );
    if (result != null) {
      setState(() => _selectedIds.add(result.id));
    }
  }

  Future<void> _editCategory(RoutineCategory category) async {
    await showDialog<RoutineCategory>(
      context: context,
      builder: (context) => RoutineCategoryFormDialog(category: category),
    );
  }

  Future<void> _deleteCategory(RoutineCategory category) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.routine_category_delete),
        content: Text(l10n.routine_category_delete_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.routine_category_delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final success = await ref
        .read(routineCategoryManagementProvider.notifier)
        .deleteRoutineCategory(category.id);
    if (success) {
      setState(() => _selectedIds.remove(category.id));
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.routine_category_error_generic)),
      );
    }
  }

  void _reorder(List<RoutineCategory> categories, int oldIndex, int newIndex) {
    final reordered = [...categories];
    final moved = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, moved);
    ref
        .read(routineCategoryManagementProvider.notifier)
        .reorderCategories(reordered);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final categoriesAsync = ref.watch(routineCategoryListProvider);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      builder: (context, scrollController) => SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.spaceM,
                AppSizes.spaceM,
                AppSizes.spaceS,
                AppSizes.spaceS,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.routine_category_picker_title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _editing = !_editing),
                    child: Text(
                      _editing
                          ? l10n.routine_category_edit_mode_done
                          : l10n.routine_category_edit_mode,
                    ),
                  ),
                ],
              ),
            ),
            if (_editing)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceM,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.routine_category_reorder_hint,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: AppSizes.spaceXS),
            Expanded(
              child: categoriesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) =>
                    Center(child: Text(l10n.routine_category_error_generic)),
                data: (categories) {
                  if (categories.isEmpty) {
                    return Center(child: Text(l10n.routine_category_empty));
                  }
                  return _editing
                      ? _buildEditList(context, categories, scrollController)
                      : _buildSelectList(context, categories, scrollController);
                },
              ),
            ),
            if (_editing)
              Padding(
                padding: const EdgeInsets.all(AppSizes.spaceM),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _addCategory,
                    icon: const Icon(Icons.add),
                    label: Text(l10n.routine_category_add),
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(AppSizes.spaceM),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(_selectedIds),
                    child: Text(l10n.routine_category_select_done),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectList(
    BuildContext context,
    List<RoutineCategory> categories,
    ScrollController scrollController,
  ) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceS),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final selected = _selectedIds.contains(category.id);
        return CheckboxListTile(
          value: selected,
          onChanged: (value) => setState(() {
            if (value ?? false) {
              _selectedIds.add(category.id);
            } else {
              _selectedIds.remove(category.id);
            }
          }),
          title: Text('${category.emoji ?? ''} ${category.title}'.trim()),
          controlAffinity: ListTileControlAffinity.leading,
        );
      },
    );
  }

  Widget _buildEditList(
    BuildContext context,
    List<RoutineCategory> categories,
    ScrollController scrollController,
  ) {
    return ReorderableListView.builder(
      scrollController: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceS),
      itemCount: categories.length,
      onReorderItem: (oldIndex, newIndex) =>
          _reorder(categories, oldIndex, newIndex),
      proxyDecorator: buildReorderableProxyDecorator,
      itemBuilder: (context, index) {
        final category = categories[index];
        return ListTile(
          key: ValueKey(category.id),
          leading: const DragHandleIcon(),
          title: Text('${category.emoji ?? ''} ${category.title}'.trim()),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => _editCategory(category),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _deleteCategory(category),
              ),
            ],
          ),
        );
      },
    );
  }
}
