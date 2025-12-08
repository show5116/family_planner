import 'package:flutter/material.dart';
import 'package:family_planner/l10n/app_localizations.dart';

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

  /// 역할 색상 가져오기
  static Color getRoleColor(String role) {
    switch (role) {
      case 'OWNER':
        return Colors.red;
      case 'ADMIN':
        return Colors.orange;
      case 'MEMBER':
        return Colors.blue;
      default:
        return Colors.grey;
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

  /// 색상 파싱 (hex string -> Color)
  static Color? parseColor(String? colorHex) {
    if (colorHex == null) return null;
    try {
      return Color(int.parse(colorHex.substring(1), radix: 16) + 0xFF000000);
    } catch (e) {
      return null;
    }
  }

  /// 색상 변환 (Color -> hex string)
  static String colorToHex(Color color) {
    final a = (color.a * 255).round();
    final r = (color.r * 255).round();
    final g = (color.g * 255).round();
    final b = (color.b * 255).round();
    final value = a << 24 | r << 16 | g << 8 | b;
    return '#${value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  /// 날짜 포맷팅
  static String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// 현재 사용자가 그룹을 관리할 수 있는지 확인
  static bool canManageGroup(List<dynamic> members) {
    if (members.isEmpty) return false;
    // 첫 번째 멤버를 현재 사용자로 간주 (실제로는 authProvider에서 가져와야 함)
    final roleName = members.first.role?.name ?? '';
    return roleName == 'OWNER' || roleName == 'ADMIN';
  }

  /// 현재 사용자가 OWNER인지 확인
  static bool isOwner(List<dynamic> members) {
    if (members.isEmpty) return false;
    return members.first.role?.name == 'OWNER';
  }
}
