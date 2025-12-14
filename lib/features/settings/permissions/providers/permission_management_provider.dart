import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/settings/permissions/models/permission.dart';
import 'package:family_planner/features/settings/permissions/services/permission_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 권한 관리 상태
class PermissionManagementState {
  final List<Permission> permissions;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final String? selectedCategory;

  PermissionManagementState({
    this.permissions = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.selectedCategory,
  });

  /// 카테고리 목록 추출
  List<String> get categories {
    return permissions.map((p) => p.category).toSet().toList()..sort();
  }

  /// 필터링된 권한 목록
  List<Permission> get filteredPermissions {
    return permissions.where((permission) {
      final matchesSearch = searchQuery.isEmpty ||
          permission.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          permission.code.toLowerCase().contains(searchQuery.toLowerCase());

      final matchesCategory =
          selectedCategory == null || permission.category == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  PermissionManagementState copyWith({
    List<Permission>? permissions,
    bool? isLoading,
    String? error,
    String? searchQuery,
    String? selectedCategory,
    bool clearCategory = false,
  }) {
    return PermissionManagementState(
      permissions: permissions ?? this.permissions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
    );
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
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 검색어 설정
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// 카테고리 필터 설정
  void setCategory(String? category) {
    if (category == null) {
      state = state.copyWith(clearCategory: true);
    } else {
      state = state.copyWith(selectedCategory: category);
    }
  }

  /// 권한 생성
  Future<Permission> createPermission({
    required String code,
    required String name,
    String? description,
    required String category,
  }) async {
    final permission = await _permissionService.createPermission(
      code: code,
      name: name,
      description: description,
      category: category,
    );

    // 로컬 상태에 추가
    final updatedPermissions = [...state.permissions, permission];
    state = state.copyWith(permissions: updatedPermissions);

    return permission;
  }

  /// 권한 수정
  Future<Permission> updatePermission(
    String id, {
    String? name,
    String? description,
    bool? isActive,
  }) async {
    final updatedPermission = await _permissionService.updatePermission(
      id,
      name: name,
      description: description,
      isActive: isActive,
    );

    // 로컬 상태 업데이트
    final updatedPermissions = state.permissions.map((p) {
      return p.id == id ? updatedPermission : p;
    }).toList();
    state = state.copyWith(permissions: updatedPermissions);

    return updatedPermission;
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

  /// 권한 일괄 정렬 순서 업데이트
  Future<void> updateSortOrders(
    Map<String, int> sortOrders,
    List<Permission> reorderedPermissions,
  ) async {
    try {
      // API 호출 (성공 시 빈 응답)
      await _permissionService.bulkUpdateSortOrder(sortOrders);

      // 성공하면 재정렬된 권한 목록을 로컬 상태에 반영
      state = state.copyWith(permissions: reorderedPermissions);
    } catch (e) {
      rethrow;
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
        PermissionManagementState>((ref) {
  final permissionService = ref.watch(permissionServiceProvider);
  return PermissionManagementNotifier(permissionService);
});
