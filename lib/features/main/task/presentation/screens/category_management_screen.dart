import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

// 분리된 위젯 import
import 'package:family_planner/features/main/task/presentation/screens/category_management/category_list_item.dart';
import 'package:family_planner/features/main/task/presentation/screens/category_management/category_form_dialog.dart';
import 'package:family_planner/features/main/task/presentation/screens/category_management/category_group_selector.dart';

/// 카테고리 관리 화면
class CategoryManagementScreen extends ConsumerWidget {
  const CategoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final categoriesAsync = ref.watch(categoryManagementProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.category_management),
      ),
      body: Column(
        children: [
          // 그룹 선택 섹션
          const CategoryGroupSelector(),

          // 카테고리 목록
          Expanded(
            child: categoriesAsync.when(
              data: (categories) {
                if (categories.isEmpty) {
                  return _EmptyState(l10n: l10n);
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(AppSizes.spaceM),
                  itemCount: categories.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSizes.spaceS),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return CategoryListItem(
                      category: category,
                      onEdit: () => _showCategoryDialog(context, ref, l10n, category: category),
                      onDelete: () => _confirmDelete(context, ref, l10n, category),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _ErrorState(
                error: error.toString(),
                onRetry: () => ref.read(categoryManagementProvider.notifier).refresh(),
                l10n: l10n,
              ),
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

  Future<void> _showCategoryDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n, {
    CategoryModel? category,
  }) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => CategoryFormDialog(
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

/// 빈 상태 위젯
class _EmptyState extends StatelessWidget {
  final AppLocalizations l10n;

  const _EmptyState({required this.l10n});

  @override
  Widget build(BuildContext context) {
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
}

/// 에러 상태 위젯
class _ErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  final AppLocalizations l10n;

  const _ErrorState({
    required this.error,
    required this.onRetry,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
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
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.common_retry),
          ),
        ],
      ),
    );
  }
}
