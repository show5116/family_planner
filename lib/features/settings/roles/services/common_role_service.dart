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
  Future<List<CommonRole>> getCommonRoles() async {
    try {
      final response = await _apiClient.get('/roles');

      final dynamic responseData = response.data;

      List<dynamic> data;
      if (responseData is List) {
        data = responseData;
      } else if (responseData is Map) {
        if (responseData.containsKey('data')) {
          data = responseData['data'] as List<dynamic>;
        } else if (responseData.containsKey('roles')) {
          data = responseData['roles'] as List<dynamic>;
        } else {
          throw Exception('Unexpected response format: $responseData');
        }
      } else {
        throw Exception('Unexpected response type: ${responseData.runtimeType}');
      }

      return data.map((json) => CommonRole.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// 공통 역할 상세 조회 (권한 포함)
  /// GET /roles/:id
  Future<CommonRole> getCommonRole(String roleId) async {
    try {
      final response = await _apiClient.get('/roles/$roleId');

      final dynamic responseData = response.data;

      if (responseData is Map) {
        if (responseData.containsKey('role')) {
          return CommonRole.fromJson(
              responseData['role'] as Map<String, dynamic>);
        } else if (responseData.containsKey('data')) {
          return CommonRole.fromJson(
              responseData['data'] as Map<String, dynamic>);
        } else {
          return CommonRole.fromJson(responseData as Map<String, dynamic>);
        }
      }

      throw Exception('Unexpected response format: $responseData');
    } catch (e) {
      rethrow;
    }
  }

  /// 공통 역할 생성
  /// POST /roles (공통 역할 생성, groupId는 자동으로 null)
  Future<CommonRole> createCommonRole({
    required String name,
    String? description,
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

      if (responseData is Map) {
        if (responseData.containsKey('role')) {
          return CommonRole.fromJson(
              responseData['role'] as Map<String, dynamic>);
        } else if (responseData.containsKey('data')) {
          return CommonRole.fromJson(
              responseData['data'] as Map<String, dynamic>);
        } else {
          return CommonRole.fromJson(responseData as Map<String, dynamic>);
        }
      }

      throw Exception('Unexpected response format: $responseData');
    } catch (e) {
      rethrow;
    }
  }

  /// 공통 역할 수정
  /// PATCH /roles/:id
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

      if (responseData is Map) {
        if (responseData.containsKey('role')) {
          return CommonRole.fromJson(
              responseData['role'] as Map<String, dynamic>);
        } else if (responseData.containsKey('data')) {
          return CommonRole.fromJson(
              responseData['data'] as Map<String, dynamic>);
        } else {
          return CommonRole.fromJson(responseData as Map<String, dynamic>);
        }
      }

      throw Exception('Unexpected response format: $responseData');
    } catch (e) {
      rethrow;
    }
  }

  /// 공통 역할 삭제
  /// DELETE /roles/:id
  Future<void> deleteCommonRole(String roleId) async {
    try {
      await _apiClient.delete('/roles/$roleId');
    } catch (e) {
      rethrow;
    }
  }

  /// 공통 역할의 권한 업데이트
  /// PATCH /roles/:id 를 사용하여 permissions 배열 업데이트
  /// permissionIds: 해당 역할에 할당할 권한 ID 배열
  Future<CommonRole> updateRolePermissions(
    String roleId,
    List<String> permissionIds,
  ) async {
    try {
      // PATCH /roles/:id 에 permissions 배열을 포함하여 전송
      final response = await _apiClient.patch(
        '/roles/$roleId',
        data: {'permissions': permissionIds},
      );

      final dynamic responseData = response.data;

      if (responseData is Map) {
        if (responseData.containsKey('role')) {
          return CommonRole.fromJson(
              responseData['role'] as Map<String, dynamic>);
        } else if (responseData.containsKey('data')) {
          return CommonRole.fromJson(
              responseData['data'] as Map<String, dynamic>);
        } else {
          return CommonRole.fromJson(responseData as Map<String, dynamic>);
        }
      }

      throw Exception('Unexpected response format: $responseData');
    } catch (e) {
      rethrow;
    }
  }
}
