import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/settings/roles/models/common_role.dart';

/// 공통 역할 관리 서비스
/// 운영자 전용 API (isAdmin: true 필요)
/// groupId = null인 공통 역할들만 관리
class CommonRoleService {
  final ApiClient _apiClient;

  CommonRoleService(this._apiClient);

  /// 공통 역할 목록 조회
  /// GET /roles (공통 역할만 조회, groupId=null)
  /// 백엔드 스펙: response.data는 Role[] 배열
  Future<List<CommonRole>> getCommonRoles() async {
    try {
      final response = await _apiClient.get('/roles');

      final dynamic responseData = response.data;

      if (responseData is! List) {
        throw Exception('Invalid response format: expected Role[]');
      }

      return responseData.map((json) => CommonRole.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // 참고: 백엔드에는 단일 역할 조회 엔드포인트가 없습니다.
  // 필요시 getCommonRoles()로 전체 목록을 가져온 후 필터링하거나,
  // 백엔드에 엔드포인트 추가를 요청해야 합니다.

  /// 공통 역할 생성
  /// POST /roles (공통 역할 생성, groupId는 자동으로 null)
  /// 백엔드 스펙: response.data는 Role 객체
  Future<CommonRole> createCommonRole({
    required String name,
    bool isDefaultRole = false,
    List<String> permissions = const [],
  }) async {
    try {
      final response = await _apiClient.post(
        '/roles',
        data: {
          'name': name,
          'isDefaultRole': isDefaultRole,
          'permissions': permissions,
          // groupId는 보내지 않으면 백엔드에서 자동으로 null 처리
        },
      );

      final dynamic responseData = response.data;

      if (responseData is! Map) {
        throw Exception('Invalid response format: expected Role object');
      }

      return CommonRole.fromJson(responseData as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  /// 공통 역할 수정
  /// PATCH /roles/:id
  /// 백엔드 스펙: response.data는 Role 객체
  Future<CommonRole> updateCommonRole(
    String roleId, {
    String? name,
    bool? isDefaultRole,
    List<String>? permissions,
  }) async {
    try {
      final response = await _apiClient.patch(
        '/roles/$roleId',
        data: {
          if (name != null) 'name': name,
          if (isDefaultRole != null) 'isDefaultRole': isDefaultRole,
          if (permissions != null) 'permissions': permissions,
        },
      );

      final dynamic responseData = response.data;

      if (responseData is! Map) {
        throw Exception('Invalid response format: expected Role object');
      }

      return CommonRole.fromJson(responseData as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  /// 공통 역할 삭제
  /// DELETE /roles/:id
  /// 백엔드 스펙: response.data는 {message: string, deletedRole: Role}
  Future<void> deleteCommonRole(String roleId) async {
    try {
      await _apiClient.delete('/roles/$roleId');
      // 백엔드는 {message, deletedRole} 형태로 응답하지만, void 반환으로 충분
    } catch (e) {
      rethrow;
    }
  }

  /// 공통 역할의 권한 업데이트
  /// PATCH /roles/:id 를 사용하여 permissions 배열 업데이트
  /// 백엔드 스펙: response.data는 Role 객체
  /// permissionCodes: 해당 역할에 할당할 권한 코드 배열 (예: ["group:read", "group:update"])
  Future<CommonRole> updateRolePermissions(
    String roleId,
    List<String> permissionCodes,
  ) async {
    try {
      final response = await _apiClient.patch(
        '/roles/$roleId',
        data: {'permissions': permissionCodes},
      );

      final dynamic responseData = response.data;

      if (responseData is! Map) {
        throw Exception('Invalid response format: expected Role object');
      }

      return CommonRole.fromJson(responseData as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  /// 공통 역할 일괄 정렬 순서 업데이트
  /// PATCH /roles/bulk/sort-order
  /// items: 역할 ID와 sortOrder의 배열 (예: [{"id": "id1", "sortOrder": 0}, ...])
  /// 성공 시 빈 응답 반환하므로 void 처리
  Future<void> bulkUpdateSortOrder(
    Map<String, int> sortOrders,
  ) async {
    try {
      // Map을 items 배열로 변환
      final items = sortOrders.entries
          .map((entry) => {
                'id': entry.key,
                'sortOrder': entry.value,
              })
          .toList();

      await _apiClient.patch(
        '/roles/bulk/sort-order',
        data: {'items': items},
      );

      // 성공하면 void 반환 (상태는 프로바이더에서 관리)
    } catch (e) {
      rethrow;
    }
  }
}
