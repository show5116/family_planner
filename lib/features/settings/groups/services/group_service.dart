import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/models/group_member.dart';

/// 그룹 관리 서비스
class GroupService {
  final ApiClient _apiClient;

  GroupService(this._apiClient);

  /// 그룹 생성
  /// POST /groups
  Future<Group> createGroup({
    required String name,
    String? description,
    String? defaultColor,
  }) async {
    try {
      final response = await _apiClient.post(
        '/groups',
        data: {
          'name': name,
          if (description != null) 'description': description,
          if (defaultColor != null) 'defaultColor': defaultColor,
        },
      );
      return Group.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// 내가 속한 그룹 목록 조회
  /// GET /groups
  Future<List<Group>> getMyGroups() async {
    try {
      final response = await _apiClient.get('/groups');
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => Group.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// 그룹 상세 조회
  /// GET /groups/:id
  Future<Group> getGroup(String groupId) async {
    try {
      final response = await _apiClient.get('/groups/$groupId');
      return Group.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// 그룹 정보 수정
  /// PATCH /groups/:id
  Future<Group> updateGroup(
    String groupId, {
    String? name,
    String? description,
    String? defaultColor,
  }) async {
    try {
      final requestData = {
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (defaultColor != null) 'defaultColor': defaultColor,
      };

      final response = await _apiClient.patch(
        '/groups/$groupId',
        data: requestData,
      );

      return Group.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// 그룹 삭제
  /// DELETE /groups/:id
  Future<void> deleteGroup(String groupId) async {
    try {
      await _apiClient.delete('/groups/$groupId');
    } catch (e) {
      rethrow;
    }
  }

  /// 초대 코드로 그룹 가입
  /// POST /groups/join
  Future<Group> joinGroup(String inviteCode) async {
    try {
      final response = await _apiClient.post(
        '/groups/join',
        data: {'inviteCode': inviteCode},
      );
      return Group.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// 그룹 나가기
  /// POST /groups/:id/leave
  Future<void> leaveGroup(String groupId) async {
    try {
      await _apiClient.post('/groups/$groupId/leave');
    } catch (e) {
      rethrow;
    }
  }

  /// 그룹 멤버 목록 조회
  /// GET /groups/:id/members
  Future<List<GroupMember>> getGroupMembers(String groupId) async {
    try {
      final response = await _apiClient.get('/groups/$groupId/members');
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => GroupMember.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// 멤버 역할 변경
  /// PATCH /groups/:id/members/:userId/role
  Future<GroupMember> updateMemberRole(
    String groupId,
    String userId,
    String roleId,
  ) async {
    try {
      final response = await _apiClient.patch(
        '/groups/$groupId/members/$userId/role',
        data: {'roleId': roleId},
      );
      return GroupMember.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// 개인 그룹 색상 설정
  /// PATCH /groups/:id/my-color
  Future<GroupMember> updateMyColor(String groupId, String customColor) async {
    try {
      final response = await _apiClient.patch(
        '/groups/$groupId/my-color',
        data: {'customColor': customColor},
      );

      // 응답 데이터가 null이거나 잘못된 경우 처리
      if (response.data == null) {
        throw Exception('Empty response from server');
      }

      // Map이 아닌 경우 처리
      if (response.data is! Map<String, dynamic>) {
        throw Exception(
          'Invalid response format: expected Map but got ${response.data.runtimeType}',
        );
      }

      return GroupMember.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  /// 멤버 삭제
  /// DELETE /groups/:id/members/:userId
  Future<void> removeMember(String groupId, String userId) async {
    try {
      await _apiClient.delete('/groups/$groupId/members/$userId');
    } catch (e) {
      rethrow;
    }
  }

  /// 초대 코드 재생성
  /// POST /groups/:id/regenerate-code
  Future<Group> regenerateInviteCode(String groupId) async {
    try {
      final response = await _apiClient.post(
        '/groups/$groupId/regenerate-code',
      );
      return Group.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// 그룹의 역할 목록 조회
  /// GET /groups/:id/roles
  Future<List<Role>> getGroupRoles(String groupId) async {
    try {
      final response = await _apiClient.get('/groups/$groupId/roles');
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => Role.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// 그룹별 커스텀 역할 생성
  /// POST /groups/:groupId/roles
  Future<Role> createGroupRole(
    String groupId, {
    required String name,
    required List<String> permissions,
    bool isDefaultRole = false,
  }) async {
    try {
      final response = await _apiClient.post(
        '/groups/$groupId/roles',
        data: {
          'name': name,
          'permissions': permissions,
          'isDefaultRole': isDefaultRole,
        },
      );
      return Role.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// 그룹별 커스텀 역할 수정
  /// PATCH /groups/:groupId/roles/:id
  Future<Role> updateGroupRole(
    String groupId,
    String roleId, {
    String? name,
    List<String>? permissions,
    bool? isDefaultRole,
  }) async {
    try {
      final response = await _apiClient.patch(
        '/groups/$groupId/roles/$roleId',
        data: {
          if (name != null) 'name': name,
          if (permissions != null) 'permissions': permissions,
          if (isDefaultRole != null) 'isDefaultRole': isDefaultRole,
        },
      );
      return Role.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// 그룹별 커스텀 역할 삭제
  /// DELETE /groups/:groupId/roles/:id
  Future<void> deleteGroupRole(String groupId, String roleId) async {
    try {
      await _apiClient.delete('/groups/$groupId/roles/$roleId');
    } catch (e) {
      rethrow;
    }
  }

  /// 그룹별 역할 일괄 정렬 순서 업데이트
  /// PATCH /groups/:groupId/roles/bulk/sort-order
  /// items: 역할 ID와 sortOrder의 배열 (예: [{"id": "id1", "sortOrder": 0}, ...])
  /// 성공 시 빈 응답 반환하므로 void 처리
  Future<void> bulkUpdateGroupRoleSortOrder(
    String groupId,
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
        '/groups/$groupId/roles/bulk/sort-order',
        data: {'items': items},
      );

      // 성공하면 void 반환 (상태는 프로바이더에서 관리)
    } catch (e) {
      rethrow;
    }
  }
}
