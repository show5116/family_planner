import 'package:flutter/material.dart';
import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/models/group_member.dart';
import 'package:family_planner/features/settings/groups/models/join_request.dart';

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
      final group = Group.fromJson(response.data);
      return group;
    } catch (e) {
      debugPrint('[GroupService.getGroup] Error: $e');
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
  /// 성공 시 가입 요청 정보를 반환 (그룹 객체 아님)
  Future<Map<String, dynamic>> joinGroup(String inviteCode) async {
    try {
      final response = await _apiClient.post(
        '/groups/join',
        data: {'inviteCode': inviteCode},
      );
      return response.data as Map<String, dynamic>;
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
  Future<GroupMember> updateMyColor(String groupId, String? customColor) async {
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
    String? color,
  }) async {
    try {
      final response = await _apiClient.post(
        '/groups/$groupId/roles',
        data: {
          'name': name,
          'permissions': permissions,
          'isDefaultRole': isDefaultRole,
          if (color != null) 'color': color,
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
    String? color,
  }) async {
    try {
      final response = await _apiClient.patch(
        '/groups/$groupId/roles/$roleId',
        data: {
          if (name != null) 'name': name,
          if (permissions != null) 'permissions': permissions,
          if (isDefaultRole != null) 'isDefaultRole': isDefaultRole,
          if (color != null) 'color': color,
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
          .map((entry) => {'id': entry.key, 'sortOrder': entry.value})
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

  /// 그룹 가입 요청 목록 조회
  /// GET /groups/:id/join-requests
  /// status 쿼리 파라미터로 필터링 가능 (PENDING, ACCEPTED, REJECTED)
  Future<List<JoinRequest>> getJoinRequests(
    String groupId, {
    String? status,
  }) async {
    try {
      final response = await _apiClient.get(
        '/groups/$groupId/join-requests',
        queryParameters: status != null ? {'status': status} : null,
      );
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => JoinRequest.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// 가입 요청 승인
  /// POST /groups/:id/join-requests/:requestId/accept
  Future<GroupMember> acceptJoinRequest(
    String groupId,
    String requestId,
  ) async {
    try {
      final response = await _apiClient.post(
        '/groups/$groupId/join-requests/$requestId/accept',
      );
      return GroupMember.fromJson(response.data['member']);
    } catch (e) {
      rethrow;
    }
  }

  /// 가입 요청 거부
  /// POST /groups/:id/join-requests/:requestId/reject
  Future<void> rejectJoinRequest(
    String groupId,
    String requestId,
  ) async {
    try {
      await _apiClient.post(
        '/groups/$groupId/join-requests/$requestId/reject',
      );
    } catch (e) {
      rethrow;
    }
  }

  /// 이메일로 그룹 초대
  /// POST /groups/:id/invite-by-email
  Future<Map<String, dynamic>> inviteByEmail(
    String groupId,
    String email,
  ) async {
    try {
      final response = await _apiClient.post(
        '/groups/$groupId/invite-by-email',
        data: {'email': email},
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// 초대 취소
  /// DELETE /groups/:id/invites/:requestId
  Future<void> cancelInvite(
    String groupId,
    String requestId,
  ) async {
    try {
      await _apiClient.delete(
        '/groups/$groupId/invites/$requestId',
      );
    } catch (e) {
      rethrow;
    }
  }

  /// 초대 재전송
  /// POST /groups/:id/invites/:requestId/resend
  Future<Map<String, dynamic>> resendInvite(
    String groupId,
    String requestId,
  ) async {
    try {
      final response = await _apiClient.post(
        '/groups/$groupId/invites/$requestId/resend',
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// 그룹장 권한 양도
  /// POST /groups/:id/transfer-ownership
  /// newOwnerId: 새로운 OWNER가 될 사용자 ID
  Future<Map<String, dynamic>> transferOwnership(
    String groupId,
    String newOwnerId,
  ) async {
    try {
      final response = await _apiClient.post(
        '/groups/$groupId/transfer-ownership',
        data: {'newOwnerId': newOwnerId},
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }
}
