import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/widgets/form_section_header.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/features/main/task/providers/task_form_provider.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 카테고리 선택 섹션 위젯
class CategorySection extends ConsumerWidget {
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;

  const CategorySection({
    super.key,
    required this.formState,
    required this.formNotifier,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final categoriesAsync = ref.watch(selectedGroupCategoriesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSectionHeader(
          title: l10n.category_management.split(' ').first,
          action: FormSectionAction(
            icon: Icons.settings,
            label: l10n.category_management,
            onPressed: () async {
              await context.push('/calendar/categories');
              ref.invalidate(selectedGroupCategoriesProvider);
            },
          ),
        ),
        categoriesAsync.when(
          data: (categories) {
            if (categories.isEmpty) {
              return _EmptyCategoryView(onAdd: () async {
                await context.push('/calendar/categories');
                ref.invalidate(selectedGroupCategoriesProvider);
              });
            }
            return _CategoryChips(
              categories: categories,
              formState: formState,
              formNotifier: formNotifier,
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(
            child: Text(
              l10n.category_loadError,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyCategoryView extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyCategoryView({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        children: [
          Text(
            l10n.category_empty,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSizes.spaceS),
          TextButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: Text(l10n.category_add),
          ),
        ],
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  final List<CategoryModel> categories;
  final TaskFormState formState;
  final TaskFormNotifier formNotifier;

  const _CategoryChips({
    required this.categories,
    required this.formState,
    required this.formNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.spaceS,
      runSpacing: AppSizes.spaceS,
      children: categories.map((category) {
        final isSelected = formState.selectedCategory?.id == category.id;
        final color = category.color != null
            ? Color(int.parse('FF${category.color!.replaceFirst('#', '')}', radix: 16))
            : AppColors.primary;

        return ChoiceChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (category.emoji != null) ...[
                Text(category.emoji!, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: AppSizes.spaceXS),
              ],
              Text(category.name),
            ],
          ),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) formNotifier.setSelectedCategory(category);
          },
          selectedColor: color.withValues(alpha: 0.3),
          labelStyle: TextStyle(
            color: isSelected ? color : null,
            fontWeight: isSelected ? FontWeight.bold : null,
          ),
        );
      }).toList(),
    );
  }
}
