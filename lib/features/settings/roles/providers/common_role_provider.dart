import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/settings/roles/models/common_role.dart';
import 'package:family_planner/features/settings/roles/services/common_role_service.dart';

/// CommonRoleService Provider
final commonRoleServiceProvider = Provider<CommonRoleService>((ref) {
  return CommonRoleService(ApiClient.instance);
});

/// 공통 역할 관리 상태
class CommonRoleState {
  final List<CommonRole> roles;
  final bool isLoading;
  final String? error;

  CommonRoleState({this.roles = const [], this.isLoading = false, this.error});

  CommonRoleState copyWith({
    List<CommonRole>? roles,
    bool? isLoading,
    String? error,
  }) {
    return CommonRoleState(
      roles: roles ?? this.roles,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// 공통 역할 관리 Notifier
class CommonRoleNotifier extends StateNotifier<CommonRoleState> {
  final CommonRoleService _service;

  CommonRoleNotifier(this._service) : super(CommonRoleState()) {
    loadRoles();
  }

  /// 공통 역할 목록 조회
  Future<void> loadRoles() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final roles = await _service.getCommonRoles();
      state = state.copyWith(roles: roles, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 공통 역할 생성
  Future<void> createRole({
    required String name,
    bool isDefaultRole = false,
  }) async {
    try {
      final newRole = await _service.createCommonRole(
        name: name,
        isDefaultRole: isDefaultRole,
      );
      state = state.copyWith(roles: [...state.roles, newRole]);
    } catch (e) {
      rethrow;
    }
  }

  /// 공통 역할 수정
  Future<void> updateRole(
    String roleId, {
    String? name,
    bool? isDefaultRole,
  }) async {
    try {
      final updatedRole = await _service.updateCommonRole(
        roleId,
        name: name,
        isDefaultRole: isDefaultRole,
      );

      state = state.copyWith(
        roles: state.roles
            .map((role) => role.id == roleId ? updatedRole : role)
            .toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// 공통 역할 삭제
  Future<void> deleteRole(String roleId) async {
    try {
      await _service.deleteCommonRole(roleId);
      state = state.copyWith(
        roles: state.roles.where((role) => role.id != roleId).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// 공통 역할의 권한 업데이트
  Future<void> updateRolePermissions(
    String roleId,
    List<String> permissionIds,
  ) async {
    try {
      final updatedRole = await _service.updateRolePermissions(
        roleId,
        permissionIds,
      );

      state = state.copyWith(
        roles: state.roles
            .map((role) => role.id == roleId ? updatedRole : role)
            .toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// 공통 역할 일괄 정렬 순서 업데이트
  Future<void> updateSortOrders(
    Map<String, int> sortOrders,
    List<CommonRole> reorderedRoles,
  ) async {
    try {
      // API 호출 (성공 시 빈 응답)
      await _service.bulkUpdateSortOrder(sortOrders);

      // 성공하면 재정렬된 역할 목록을 로컬 상태에 반영
      state = state.copyWith(roles: reorderedRoles);
    } catch (e) {
      rethrow;
    }
  }
}

/// 공통 역할 관리 Provider
final commonRoleProvider =
    StateNotifierProvider<CommonRoleNotifier, CommonRoleState>((ref) {
      final service = ref.watch(commonRoleServiceProvider);
      return CommonRoleNotifier(service);
    });
