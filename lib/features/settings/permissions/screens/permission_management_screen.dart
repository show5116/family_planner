import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/settings/permissions/models/permission.dart';
import 'package:family_planner/features/settings/permissions/providers/permission_management_provider.dart';
import 'package:family_planner/features/settings/permissions/widgets/permission_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 권한 관리 화면 (리팩토링됨)
class PermissionManagementScreen extends ConsumerStatefulWidget {
  const PermissionManagementScreen({super.key});

  @override
  ConsumerState<PermissionManagementScreen> createState() =>
      _PermissionManagementScreenState();
}

class _PermissionManagementScreenState
    extends ConsumerState<PermissionManagementScreen> {
  List<Permission>? _reorderedPermissions;
  bool _hasChanges = false;

  @override
  Widget build(BuildContext context) {
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
          // 저장 버튼 (변경사항이 있을 때만 표시)
          if (_hasChanges)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceM,
                vertical: AppSizes.spaceS,
              ),
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '순서가 변경되었습니다',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                    ),
                  ),
                  TextButton(
                    onPressed: _cancelReorder,
                    child: const Text('취소'),
                  ),
                  const SizedBox(width: AppSizes.spaceS),
                  ElevatedButton(
                    onPressed: _saveSortOrder,
                    child: const Text('저장'),
                  ),
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

    final permissions = _reorderedPermissions ?? state.filteredPermissions;

    if (permissions.isEmpty) {
      return _buildEmptyView(context, l10n);
    }

    // 항상 ReorderableListView 사용 (드래그 앤 드롭 항상 가능)
    return ReorderableListView.builder(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      itemCount: permissions.length,
      buildDefaultDragHandles: false, // 기본 드래그 핸들 비활성화
      proxyDecorator: (child, index, animation) {
        return Material(
          elevation: 8.0,
          borderRadius: BorderRadius.circular(12),
          child: child,
        );
      },
      onReorder: (oldIndex, newIndex) {
        setState(() {
          // 처음 변경 시 복사본 생성
          _reorderedPermissions ??= List.from(permissions);

          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final item = _reorderedPermissions!.removeAt(oldIndex);
          _reorderedPermissions!.insert(newIndex, item);

          // 변경사항 표시
          _hasChanges = true;
        });
      },
      itemBuilder: (context, index) {
        final permission = permissions[index];
        return ReorderableDragStartListener(
          key: ValueKey(permission.id),
          index: index,
          child: Card(
            margin: const EdgeInsets.only(bottom: AppSizes.spaceS),
            child: ListTile(
              leading: const Icon(
                Icons.drag_handle,
                color: Colors.grey,
              ),
              title: Text(permission.name),
              subtitle: Text(permission.code),
              trailing: Chip(
                label: Text(
                  permission.category,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              onTap: () => PermissionDetailDialog.show(
                context,
                ref,
                l10n,
                permission,
              ),
            ),
          ),
        );
      },
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

  /// 순서 변경 취소
  void _cancelReorder() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('순서 변경 취소'),
        content: const Text('변경한 순서를 취소하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('아니오'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _reorderedPermissions = null;
                _hasChanges = false;
              });
            },
            child: const Text('예'),
          ),
        ],
      ),
    );
  }

  /// 정렬 순서 저장
  Future<void> _saveSortOrder() async {
    if (_reorderedPermissions == null) return;

    // 확인 다이얼로그
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('순서 저장'),
        content: const Text('변경한 순서를 저장하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('저장'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final sortOrders = <String, int>{};
      for (var i = 0; i < _reorderedPermissions!.length; i++) {
        sortOrders[_reorderedPermissions![i].id] = i;
      }

      // 재정렬된 권한 목록과 함께 전달
      await ref
          .read(permissionManagementProvider.notifier)
          .updateSortOrders(sortOrders, _reorderedPermissions!);

      if (mounted) {
        setState(() {
          _reorderedPermissions = null;
          _hasChanges = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('정렬 순서가 저장되었습니다')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('저장 실패: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
