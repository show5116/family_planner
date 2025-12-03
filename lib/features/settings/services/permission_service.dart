import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/settings/models/permission.dart';

/// 권한 관리 서비스
/// 운영자 전용 API (isAdmin: true 필요)
class PermissionService {
  final ApiClient _apiClient;

  PermissionService(this._apiClient);

  /// 권한 목록 조회
  /// GET /permissions?category={category}
  Future<List<Permission>> getPermissions({String? category}) async {
    try {
      final queryParams = category != null && category.isNotEmpty
          ? {'category': category}
          : null;

      final response = await _apiClient.get(
        '/permissions',
        queryParameters: queryParams,
      );

      // 응답 형태 확인 및 처리
      final dynamic responseData = response.data;

      List<dynamic> data;
      if (responseData is List) {
        // 배열 형태의 응답
        data = responseData;
      } else if (responseData is Map) {
        // Map 형태의 응답 처리
        // 일반적인 페이지네이션 응답 형태를 처리
        if (responseData.containsKey('data')) {
          data = responseData['data'] as List<dynamic>;
        } else if (responseData.containsKey('items')) {
          data = responseData['items'] as List<dynamic>;
        } else if (responseData.containsKey('permissions')) {
          data = responseData['permissions'] as List<dynamic>;
        } else {
          throw Exception('Unexpected response format: $responseData');
        }
      } else {
        throw Exception('Unexpected response type: ${responseData.runtimeType}');
      }

      return data.map((json) => Permission.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// 권한 생성
  /// POST /permissions
  Future<Permission> createPermission({
    required String code,
    required String name,
    String? description,
    required String category,
  }) async {
    try {
      final response = await _apiClient.post(
        '/permissions',
        data: {
          'code': code,
          'name': name,
          if (description != null) 'description': description,
          'category': category,
        },
      );

      // 응답 형태 확인 및 처리
      final dynamic responseData = response.data;

      if (responseData is Map) {
        // permission 키가 있는 경우 (예: { permission: {...} })
        if (responseData.containsKey('permission')) {
          return Permission.fromJson(
              responseData['permission'] as Map<String, dynamic>);
        }
        // data 키가 있는 경우 (예: { data: {...} })
        else if (responseData.containsKey('data')) {
          return Permission.fromJson(
              responseData['data'] as Map<String, dynamic>);
        }
        // 직접 Permission 객체인 경우
        else {
          return Permission.fromJson(responseData as Map<String, dynamic>);
        }
      }

      throw Exception('Unexpected response format: $responseData');
    } catch (e) {
      rethrow;
    }
  }

  /// 권한 수정
  /// PATCH /permissions/{id}
  Future<Permission> updatePermission(
    String permissionId, {
    String? name,
    String? description,
    bool? isActive,
  }) async {
    try {
      final response = await _apiClient.patch(
        '/permissions/$permissionId',
        data: {
          if (name != null) 'name': name,
          if (description != null) 'description': description,
          if (isActive != null) 'isActive': isActive,
        },
      );

      // 응답 형태 확인 및 처리
      final dynamic responseData = response.data;

      if (responseData is Map) {
        // permission 키가 있는 경우 (예: { permission: {...} })
        if (responseData.containsKey('permission')) {
          return Permission.fromJson(
              responseData['permission'] as Map<String, dynamic>);
        }
        // data 키가 있는 경우 (예: { data: {...} })
        else if (responseData.containsKey('data')) {
          return Permission.fromJson(
              responseData['data'] as Map<String, dynamic>);
        }
        // 직접 Permission 객체인 경우
        else {
          return Permission.fromJson(responseData as Map<String, dynamic>);
        }
      }

      throw Exception('Unexpected response format: $responseData');
    } catch (e) {
      rethrow;
    }
  }

  /// 권한 삭제 (소프트)
  /// DELETE /permissions/{id}
  Future<void> deletePermission(String permissionId) async {
    try {
      await _apiClient.delete('/permissions/$permissionId');
    } catch (e) {
      rethrow;
    }
  }

  /// 권한 완전 삭제 (하드)
  /// DELETE /permissions/{id}/hard
  Future<void> hardDeletePermission(String permissionId) async {
    try {
      await _apiClient.delete('/permissions/$permissionId/hard');
    } catch (e) {
      rethrow;
    }
  }
}
