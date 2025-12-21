import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/settings/groups/services/group_service.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/models/group_member.dart';
import 'package:family_planner/features/settings/groups/models/join_request.dart';

/// GroupService Provider
final groupServiceProvider = Provider<GroupService>((ref) {
  return GroupService(ApiClient.instance);
});

/// 내 그룹 목록 Provider
final myGroupsProvider = FutureProvider<List<Group>>((ref) async {
  final groupService = ref.watch(groupServiceProvider);
  return await groupService.getMyGroups();
});

/// 특정 그룹 상세 Provider
/// 그룹 목록에서 해당 그룹을 찾아서 반환 (myRole 포함 보장)
final groupDetailProvider = FutureProvider.family<Group, String>((ref, groupId) async {
  // 먼저 그룹 목록에서 찾기 (myRole 포함됨)
  final groupsAsync = await ref.watch(myGroupsProvider.future);
  final group = groupsAsync.firstWhere(
    (g) => g.id == groupId,
    orElse: () => throw Exception('그룹을 찾을 수 없습니다'),
  );

  return group;
});

/// 그룹 멤버 목록 Provider
final groupMembersProvider = FutureProvider.family<List<GroupMember>, String>((ref, groupId) async {
  final groupService = ref.watch(groupServiceProvider);
  return await groupService.getGroupMembers(groupId);
});

/// 그룹 역할 목록 Provider
final groupRolesProvider = FutureProvider.family<List<Role>, String>((ref, groupId) async {
  final groupService = ref.watch(groupServiceProvider);
  return await groupService.getGroupRoles(groupId);
});

/// 그룹 가입 요청 목록 Provider (PENDING 상태만)
final groupJoinRequestsProvider = FutureProvider.family<List<JoinRequest>, String>((ref, groupId) async {
  final groupService = ref.watch(groupServiceProvider);
  return await groupService.getJoinRequests(groupId, status: 'PENDING');
});

/// 그룹 관리 상태 관리 NotifierProvider
class GroupNotifier extends StateNotifier<AsyncValue<List<Group>>> {
  final GroupService _groupService;
  final Ref _ref;

  GroupNotifier(this._groupService, this._ref) : super(const AsyncValue.loading()) {
    loadGroups();
  }

  /// 그룹 목록 로드
  Future<void> loadGroups() async {
    state = const AsyncValue.loading();
    try {
      final groups = await _groupService.getMyGroups();
      state = AsyncValue.data(groups);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// 그룹 생성
  Future<Group?> createGroup({
    required String name,
    String? description,
    String? defaultColor,
  }) async {
    try {
      final newGroup = await _groupService.createGroup(
        name: name,
        description: description,
        defaultColor: defaultColor,
      );

      // 그룹 목록 새로고침
      await loadGroups();

      return newGroup;
    } catch (e) {
      rethrow;
    }
  }

  /// 그룹 수정
  Future<Group?> updateGroup(
    String groupId, {
    String? name,
    String? description,
    String? defaultColor,
  }) async {
    try {
      final updatedGroup = await _groupService.updateGroup(
        groupId,
        name: name,
        description: description,
        defaultColor: defaultColor,
      );

      // 그룹 목록 새로고침
      await loadGroups();

      // 그룹 상세도 새로고침
      _ref.invalidate(groupDetailProvider(groupId));

      return updatedGroup;
    } catch (e) {
      rethrow;
    }
  }

  /// 그룹 삭제
  Future<void> deleteGroup(String groupId) async {
    try {
      await _groupService.deleteGroup(groupId);

      // 그룹 목록 새로고침
      await loadGroups();
    } catch (e) {
      rethrow;
    }
  }

  /// 초대 코드로 그룹 가입
  Future<Map<String, dynamic>> joinGroup(String inviteCode) async {
    try {
      final result = await _groupService.joinGroup(inviteCode);

      // 그룹 목록 새로고침 (이메일 초대인 경우 즉시 가입, 일반 요청인 경우 대기)
      await loadGroups();

      return result;
    } catch (e) {
      rethrow;
    }
  }

  /// 그룹 나가기
  Future<void> leaveGroup(String groupId) async {
    try {
      await _groupService.leaveGroup(groupId);

      // 그룹 목록 새로고침
      await loadGroups();
    } catch (e) {
      rethrow;
    }
  }

  /// 초대 코드 재생성
  Future<Group?> regenerateInviteCode(String groupId) async {
    try {
      final updatedGroup = await _groupService.regenerateInviteCode(groupId);

      // 그룹 상세 새로고침
      _ref.invalidate(groupDetailProvider(groupId));

      // 그룹 목록 새로고침
      await loadGroups();

      return updatedGroup;
    } catch (e) {
      rethrow;
    }
  }

  /// 개인 색상 설정
  Future<void> updateMyColor(String groupId, String? customColor) async {
    try {
      await _groupService.updateMyColor(groupId, customColor);

      // 그룹 상세 새로고침
      _ref.invalidate(groupDetailProvider(groupId));
      _ref.invalidate(groupMembersProvider(groupId));

      // 그룹 목록 새로고침
      await loadGroups();
    } catch (e) {
      rethrow;
    }
  }

  /// 멤버 역할 변경
  Future<void> updateMemberRole(String groupId, String userId, String roleId) async {
    try {
      await _groupService.updateMemberRole(groupId, userId, roleId);

      // 멤버 목록 새로고침
      _ref.invalidate(groupMembersProvider(groupId));
    } catch (e) {
      rethrow;
    }
  }

  /// 멤버 삭제
  Future<void> removeMember(String groupId, String userId) async {
    try {
      await _groupService.removeMember(groupId, userId);

      // 멤버 목록 새로고침
      _ref.invalidate(groupMembersProvider(groupId));
    } catch (e) {
      rethrow;
    }
  }

  /// 그룹별 커스텀 역할 생성
  Future<Role> createGroupRole(
    String groupId, {
    required String name,
    required List<String> permissions,
    bool isDefaultRole = false,
    String? color,
  }) async {
    try {
      final role = await _groupService.createGroupRole(
        groupId,
        name: name,
        permissions: permissions,
        isDefaultRole: isDefaultRole,
        color: color,
      );

      // 역할 목록 새로고침
      _ref.invalidate(groupRolesProvider(groupId));

      return role;
    } catch (e) {
      rethrow;
    }
  }

  /// 그룹별 커스텀 역할 수정
  Future<Role> updateGroupRole(
    String groupId,
    String roleId, {
    String? name,
    List<String>? permissions,
    bool? isDefaultRole,
    String? color,
  }) async {
    try {
      final role = await _groupService.updateGroupRole(
        groupId,
        roleId,
        name: name,
        permissions: permissions,
        isDefaultRole: isDefaultRole,
        color: color,
      );

      // 역할 목록 새로고침
      _ref.invalidate(groupRolesProvider(groupId));

      return role;
    } catch (e) {
      rethrow;
    }
  }

  /// 그룹별 커스텀 역할 삭제
  Future<void> deleteGroupRole(String groupId, String roleId) async {
    try {
      await _groupService.deleteGroupRole(groupId, roleId);

      // 역할 목록 새로고침
      _ref.invalidate(groupRolesProvider(groupId));
    } catch (e) {
      rethrow;
    }
  }

  /// 그룹별 역할 일괄 정렬 순서 업데이트
  Future<void> updateGroupRoleSortOrders(
    String groupId,
    Map<String, int> sortOrders,
  ) async {
    try {
      await _groupService.bulkUpdateGroupRoleSortOrder(groupId, sortOrders);

      // 역할 목록 새로고침
      _ref.invalidate(groupRolesProvider(groupId));
    } catch (e) {
      rethrow;
    }
  }

  /// 가입 요청 승인
  Future<void> acceptJoinRequest(String groupId, String requestId) async {
    try {
      await _groupService.acceptJoinRequest(groupId, requestId);

      // 멤버 목록 및 가입 요청 목록 새로고침
      _ref.invalidate(groupMembersProvider(groupId));
      _ref.invalidate(groupJoinRequestsProvider(groupId));
    } catch (e) {
      rethrow;
    }
  }

  /// 가입 요청 거부
  Future<void> rejectJoinRequest(String groupId, String requestId) async {
    try {
      await _groupService.rejectJoinRequest(groupId, requestId);

      // 가입 요청 목록 새로고침
      _ref.invalidate(groupJoinRequestsProvider(groupId));
    } catch (e) {
      rethrow;
    }
  }

  /// 이메일로 초대
  Future<Map<String, dynamic>> inviteByEmail(String groupId, String email) async {
    try {
      final result = await _groupService.inviteByEmail(groupId, email);

      // 가입 요청 목록 새로고침
      _ref.invalidate(groupJoinRequestsProvider(groupId));

      return result;
    } catch (e) {
      rethrow;
    }
  }

  /// 초대 취소
  Future<void> cancelInvite(String groupId, String requestId) async {
    try {
      await _groupService.cancelInvite(groupId, requestId);

      // 가입 요청 목록 새로고침
      _ref.invalidate(groupJoinRequestsProvider(groupId));
    } catch (e) {
      rethrow;
    }
  }

  /// 초대 재전송
  Future<Map<String, dynamic>> resendInvite(String groupId, String requestId) async {
    try {
      final result = await _groupService.resendInvite(groupId, requestId);

      // 가입 요청 목록 새로고침 (필요시)
      _ref.invalidate(groupJoinRequestsProvider(groupId));

      return result;
    } catch (e) {
      rethrow;
    }
  }
}

/// 그룹 관리 NotifierProvider
final groupNotifierProvider = StateNotifierProvider<GroupNotifier, AsyncValue<List<Group>>>((ref) {
  final groupService = ref.watch(groupServiceProvider);
  return GroupNotifier(groupService, ref);
});
