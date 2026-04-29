import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/utils/color_utils.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/features/main/assets/providers/asset_provider.dart';
import 'package:family_planner/features/main/household/providers/household_provider.dart';
import 'package:family_planner/features/main/savings/providers/savings_provider.dart';
import 'package:family_planner/features/main/child_points/providers/childcare_provider.dart';
import 'package:family_planner/features/votes/providers/vote_list_provider.dart';
import 'package:family_planner/features/minigame/providers/minigame_provider.dart';

/// 그룹 관련 유틸리티 함수
class GroupUtils {
  /// 역할명 가져오기
  static String getRoleName(AppLocalizations l10n, String role) {
    switch (role) {
      case 'OWNER':
        return l10n.group_owner;
      case 'ADMIN':
        return l10n.group_admin;
      case 'MEMBER':
        return l10n.group_member;
      default:
        return role;
    }
  }

  /// 역할 아이콘 가져오기
  static IconData getRoleIcon(String role) {
    switch (role) {
      case 'OWNER':
        return Icons.star;
      case 'ADMIN':
        return Icons.admin_panel_settings;
      default:
        return Icons.person;
    }
  }

  /// 색상 파싱 (hex string -> Color) — ColorUtils.parseColor로 위임
  static Color? parseColor(String? colorHex) => ColorUtils.parseColor(colorHex);

  /// 색상 변환 (Color -> hex string) — ColorUtils.colorToHex로 위임
  static String colorToHex(Color color) => ColorUtils.colorToHex(color);

  /// 날짜 포맷팅
  static String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// 멤버 목록에서 현재 사용자 찾기
  /// 현재 사용자 ID를 전달받아서 해당하는 멤버를 찾음
  static dynamic _getCurrentUserMember(List<dynamic> members, String? currentUserId) {
    if (members.isEmpty || currentUserId == null) {
      return null;
    }

    try {
      final found = members.where((member) => member.user?.id?.toString() == currentUserId).toList();
      return found.isNotEmpty ? found.first : null;
    } catch (e) {
      return null;
    }
  }

  /// 현재 사용자가 그룹을 관리할 수 있는지 확인
  static bool canManageGroup(List<dynamic> members, {String? currentUserId}) {
    final currentMember = _getCurrentUserMember(members, currentUserId);
    if (currentMember == null) return false;
    final roleName = currentMember.role?.name ?? '';
    return roleName == 'OWNER' || roleName == 'ADMIN';
  }

  /// 현재 사용자가 OWNER인지 확인
  static bool isOwner(List<dynamic> members, {String? currentUserId}) {
    final currentMember = _getCurrentUserMember(members, currentUserId);
    if (currentMember == null) return false;
    return currentMember.role?.name == 'OWNER';
  }

  /// 현재 사용자가 특정 권한을 가지고 있는지 확인
  static bool hasPermission(List<dynamic> members, String permission, {String? currentUserId}) {
    final currentMember = _getCurrentUserMember(members, currentUserId);
    if (currentMember == null) return false;
    final role = currentMember.role;
    if (role == null) return false;
    return role.hasPermission(permission);
  }

  /// 현재 사용자가 멤버를 초대할 수 있는지 확인
  static bool canInviteMembers(List<dynamic> members, {String? currentUserId}) {
    final currentMember = _getCurrentUserMember(members, currentUserId);
    if (currentMember == null) return false;
    final role = currentMember.role;
    if (role == null) return false;
    return role.hasPermission('INVITE_MEMBER');
  }

  /// 현재 사용자가 멤버를 관리할 수 있는지 확인
  static bool canManageMembers(List<dynamic> members, {String? currentUserId}) {
    return hasPermission(members, 'MANAGE_MEMBER', currentUserId: currentUserId);
  }

  /// 삭제/탈퇴된 그룹이 각 화면 필터에 남아있으면 초기화
  static void clearGroupFromFilters(WidgetRef ref, String groupId) {
    // task: List<String>? (다중 선택, 캘린더 필터용)
    final selectedGroupIds = ref.read(selectedGroupIdsProvider);
    if (selectedGroupIds != null && selectedGroupIds.contains(groupId)) {
      final updated = selectedGroupIds.where((id) => id != groupId).toList();
      ref.read(selectedGroupIdsProvider.notifier).state = updated.isEmpty ? null : updated;
    }

    // task: String? (단일 선택, 카테고리 관리용)
    if (ref.read(selectedGroupIdProvider) == groupId) {
      ref.read(selectedGroupIdProvider.notifier).state = null;
    }

    // 가계부
    if (ref.read(householdSelectedGroupIdProvider) == groupId) {
      ref.read(householdSelectedGroupIdProvider.notifier).state = null;
    }

    // 자산
    if (ref.read(assetSelectedGroupIdProvider) == groupId) {
      ref.read(assetSelectedGroupIdProvider.notifier).state = null;
    }

    // 적립금
    if (ref.read(savingsSelectedGroupIdProvider) == groupId) {
      ref.read(savingsSelectedGroupIdProvider.notifier).state = null;
    }

    // 육아포인트
    if (ref.read(childcareSelectedGroupIdProvider) == groupId) {
      ref.read(childcareSelectedGroupIdProvider.notifier).state = null;
    }

    // 투표
    if (ref.read(voteSelectedGroupIdProvider) == groupId) {
      ref.read(voteSelectedGroupIdProvider.notifier).state = null;
    }

    // 미니게임
    if (ref.read(minigameSelectedGroupIdProvider) == groupId) {
      ref.read(minigameSelectedGroupIdProvider.notifier).state = null;
    }
  }
}
