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

      final List<dynamic> data = response.data as List<dynamic>;
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

      return Permission.fromJson(response.data);
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

      return Permission.fromJson(response.data);
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
