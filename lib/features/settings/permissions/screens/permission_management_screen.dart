import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/settings/permissions/models/permission.dart';
import 'package:family_planner/features/settings/permissions/providers/permission_management_provider.dart';
import 'package:family_planner/features/settings/permissions/widgets/permission_card.dart';
import 'package:family_planner/features/settings/permissions/widgets/permission_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 권한 관리 화면 (리팩토링됨)
class PermissionManagementScreen extends ConsumerWidget {
  const PermissionManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(permissionManagementProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.permission_title),
        elevation: 0,
      ),
      body: Column(
        children: [
          // 검색 및 필터 영역
          Padding(
            padding: const EdgeInsets.all(AppSizes.spaceM),
            child: Column(
              children: [
                _buildSearchField(context, ref, l10n),
                const SizedBox(height: AppSizes.spaceM),
                _buildCategoryFilter(context, ref, l10n, state),
              ],
            ),
          ),
          // 권한 목록
          Expanded(
            child: _buildPermissionList(context, ref, l10n, state),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => PermissionCreateDialog.show(context, ref, l10n),
        icon: const Icon(Icons.add),
        label: Text(l10n.permission_create),
      ),
    );
  }

  Widget _buildSearchField(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    return TextField(
      decoration: InputDecoration(
        hintText: l10n.permission_search,
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        filled: true,
      ),
      onChanged: (value) {
        ref.read(permissionManagementProvider.notifier).setSearchQuery(value);
      },
    );
  }

  Widget _buildCategoryFilter(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    PermissionManagementState state,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildCategoryChip(
            context,
            ref,
            l10n.permission_allCategories,
            null,
            state.selectedCategory == null,
          ),
          const SizedBox(width: AppSizes.spaceS),
          ...state.categories.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: AppSizes.spaceS),
              child: _buildCategoryChip(
                context,
                ref,
                category,
                category,
                state.selectedCategory == category,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    WidgetRef ref,
    String label,
    String? category,
    bool isSelected,
  ) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        ref.read(permissionManagementProvider.notifier).setCategory(category);
      },
    );
  }

  Widget _buildPermissionList(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    PermissionManagementState state,
  ) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return _buildErrorView(context, ref, l10n, state);
    }

    final filteredPermissions = state.filteredPermissions;

    if (filteredPermissions.isEmpty) {
      return _buildEmptyView(context, l10n);
    }

    // 카테고리별로 그룹화
    final groupedPermissions = <String, List<Permission>>{};
    for (final permission in filteredPermissions) {
      groupedPermissions.putIfAbsent(permission.category, () => []);
      groupedPermissions[permission.category]!.add(permission);
    }

    return ListView(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      children: groupedPermissions.entries.map((entry) {
        final category = entry.key;
        final permissions = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategoryHeader(context, l10n, category, permissions.length),
            ...permissions.map((permission) {
              return PermissionCard(
                permission: permission,
                activeText: l10n.permission_active,
                inactiveText: l10n.permission_inactive,
                onTap: () => PermissionDetailDialog.show(
                  context,
                  ref,
                  l10n,
                  permission,
                ),
              );
            }),
            const SizedBox(height: AppSizes.spaceL),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildCategoryHeader(
    BuildContext context,
    AppLocalizations l10n,
    String category,
    int count,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceM),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceM,
              vertical: AppSizes.spaceS,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
            child: Text(
              category,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(width: AppSizes.spaceS),
          Text(
            '$count${l10n.permission_count}',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    PermissionManagementState state,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            l10n.permission_loadFailed,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            state.error!,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spaceL),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(permissionManagementProvider.notifier).loadPermissions();
            },
            icon: const Icon(Icons.refresh),
            label: Text(l10n.common_retry),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.security, size: 64, color: Colors.grey[400]),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            l10n.permission_noPermissions,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
