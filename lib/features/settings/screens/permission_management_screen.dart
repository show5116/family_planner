import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/settings/models/permission.dart';
import 'package:family_planner/features/settings/services/permission_service.dart';

/// 권한 관리 상태
class PermissionManagementState {
  final List<Permission> permissions;
  final bool isLoading;
  final String? error;
  final String? selectedCategory;
  final String searchQuery;

  PermissionManagementState({
    this.permissions = const [],
    this.isLoading = false,
    this.error,
    this.selectedCategory,
    this.searchQuery = '',
  });

  PermissionManagementState copyWith({
    List<Permission>? permissions,
    bool? isLoading,
    String? error,
    String? selectedCategory,
    String? searchQuery,
  }) {
    return PermissionManagementState(
      permissions: permissions ?? this.permissions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  List<Permission> get filteredPermissions {
    var result = permissions;

    // 카테고리 필터
    if (selectedCategory != null && selectedCategory!.isNotEmpty) {
      result = result.where((p) => p.category == selectedCategory).toList();
    }

    // 검색어 필터
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result.where((p) {
        return p.code.toLowerCase().contains(query) ||
            p.name.toLowerCase().contains(query) ||
            (p.description?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    return result;
  }

  Set<String> get categories {
    return permissions.map((p) => p.category).toSet();
  }
}

/// 권한 관리 Provider
class PermissionManagementNotifier
    extends StateNotifier<PermissionManagementState> {
  final PermissionService _permissionService;

  PermissionManagementNotifier(this._permissionService)
      : super(PermissionManagementState()) {
    loadPermissions();
  }

  /// 권한 목록 로드
  Future<void> loadPermissions({String? category}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final permissions = await _permissionService.getPermissions(
        category: category,
      );

      state = state.copyWith(permissions: permissions, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 검색어 설정
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// 카테고리 필터 설정
  void setCategory(String? category) {
    state = state.copyWith(selectedCategory: category);
    loadPermissions(category: category);
  }

  /// 권한 삭제 (소프트)
  Future<bool> deletePermission(String id) async {
    try {
      await _permissionService.deletePermission(id);

      // 로컬 상태에서 제거
      final updatedPermissions =
          state.permissions.where((p) => p.id != id).toList();
      state = state.copyWith(permissions: updatedPermissions);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 권한 하드 삭제
  Future<bool> hardDeletePermission(String id) async {
    try {
      await _permissionService.hardDeletePermission(id);

      // 로컬 상태에서 제거
      final updatedPermissions =
          state.permissions.where((p) => p.id != id).toList();
      state = state.copyWith(permissions: updatedPermissions);
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// Permission Service Provider
final permissionServiceProvider = Provider<PermissionService>((ref) {
  return PermissionService(ApiClient.instance);
});

/// Permission Management Provider
final permissionManagementProvider =
    StateNotifierProvider<PermissionManagementNotifier,
        PermissionManagementState>(
  (ref) {
    final permissionService = ref.watch(permissionServiceProvider);
    return PermissionManagementNotifier(permissionService);
  },
);

/// 권한 관리 화면
class PermissionManagementScreen extends ConsumerWidget {
  const PermissionManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(permissionManagementProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.permission_title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(permissionManagementProvider.notifier).loadPermissions();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 검색 바 및 필터
          Padding(
            padding: const EdgeInsets.all(AppSizes.spaceM),
            child: Column(
              children: [
                // 검색 필드
                TextField(
                  decoration: InputDecoration(
                    hintText: l10n.permission_search,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    ),
                    filled: true,
                  ),
                  onChanged: (value) {
                    ref
                        .read(permissionManagementProvider.notifier)
                        .setSearchQuery(value);
                  },
                ),
                const SizedBox(height: AppSizes.spaceM),

                // 카테고리 필터
                SingleChildScrollView(
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
        onPressed: () => _showCreatePermissionDialog(context, ref, l10n),
        icon: const Icon(Icons.add),
        label: Text(l10n.permission_create),
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
      onSelected: (selected) {
        ref
            .read(permissionManagementProvider.notifier)
            .setCategory(selected ? category : null);
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: AppSizes.spaceM),
            Text(
              l10n.permission_loadFailed,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSizes.spaceS),
            Text(
              state.error!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
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

    final filteredPermissions = state.filteredPermissions;

    if (filteredPermissions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.security,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: AppSizes.spaceM),
            Text(
              l10n.permission_noPermissions,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      );
    }

    // 카테고리별로 그룹화
    final groupedPermissions = <String, List<Permission>>{};
    for (final permission in filteredPermissions) {
      groupedPermissions.putIfAbsent(permission.category, () => []);
      groupedPermissions[permission.category]!.add(permission);
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(permissionManagementProvider.notifier).loadPermissions();
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(
          left: AppSizes.spaceM,
          right: AppSizes.spaceM,
          bottom: 80, // FAB 공간 확보
        ),
        itemCount: groupedPermissions.length,
        itemBuilder: (context, index) {
          final category = groupedPermissions.keys.elementAt(index);
          final permissions = groupedPermissions[category]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index > 0) const SizedBox(height: AppSizes.spaceL),
              // 카테고리 헤더
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceS,
                  vertical: AppSizes.spaceM,
                ),
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
                      '${permissions.length}${l10n.permission_count}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
              // 권한 카드들
              ...permissions.map((permission) {
                return _buildPermissionCard(context, ref, l10n, permission);
              }),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPermissionCard(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    Permission permission,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
      child: InkWell(
        onTap: () => _showPermissionDetailDialog(context, ref, l10n, permission),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // 권한 아이콘
                  Container(
                    padding: const EdgeInsets.all(AppSizes.spaceS),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    ),
                    child: Icon(
                      Icons.key,
                      size: 20,
                      color: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(width: AppSizes.spaceM),
                  // 권한 정보
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          permission.name,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          permission.code,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                                fontFamily: 'monospace',
                              ),
                        ),
                      ],
                    ),
                  ),
                  // 활성 상태 배지
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spaceS,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: permission.isActive ? Colors.green : Colors.grey,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    ),
                    child: Text(
                      permission.isActive
                          ? l10n.permission_active
                          : l10n.permission_inactive,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (permission.description != null &&
                  permission.description!.isNotEmpty) ...[
                const SizedBox(height: AppSizes.spaceM),
                Text(
                  permission.description!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showPermissionDetailDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    Permission permission,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(permission.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow(l10n.permission_code, permission.code),
              const SizedBox(height: AppSizes.spaceS),
              _buildDetailRow(l10n.permission_category, permission.category),
              const SizedBox(height: AppSizes.spaceS),
              _buildDetailRow(
                l10n.permission_status,
                permission.isActive
                    ? l10n.permission_active
                    : l10n.permission_inactive,
              ),
              if (permission.description != null &&
                  permission.description!.isNotEmpty) ...[
                const SizedBox(height: AppSizes.spaceM),
                Text(
                  l10n.permission_description,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSizes.spaceS),
                Text(permission.description!),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.common_close),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _showEditPermissionDialog(context, ref, l10n, permission);
            },
            icon: const Icon(Icons.edit),
            label: Text(l10n.common_edit),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _showDeleteConfirmDialog(context, ref, l10n, permission);
            },
            icon: const Icon(Icons.delete),
            label: Text(l10n.common_delete),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }

  Future<void> _showCreatePermissionDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    // TODO: 권한 생성 다이얼로그 구현
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.common_comingSoon)),
    );
  }

  Future<void> _showEditPermissionDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    Permission permission,
  ) async {
    // TODO: 권한 수정 다이얼로그 구현
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.common_comingSoon)),
    );
  }

  Future<void> _showDeleteConfirmDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    Permission permission,
  ) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.permission_deleteConfirm),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.permission_deleteMessage(permission.name)),
            const SizedBox(height: AppSizes.spaceM),
            Text(
              l10n.permission_deleteSoftDescription,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: AppSizes.spaceS),
            Text(
              l10n.permission_deleteHardDescription,
              style: const TextStyle(fontSize: 12, color: Colors.red),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'soft'),
            child: Text(l10n.permission_softDelete),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'hard'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text(l10n.permission_hardDelete),
          ),
        ],
      ),
    );

    if (result != null && context.mounted) {
      final notifier = ref.read(permissionManagementProvider.notifier);
      final success = result == 'hard'
          ? await notifier.hardDeletePermission(permission.id)
          : await notifier.deletePermission(permission.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? l10n.permission_deleteSuccess
                  : l10n.permission_deleteFailed,
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }
}
