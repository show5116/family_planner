import 'package:flutter/material.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';

/// 색상 관련 공통 유틸리티
class ColorUtils {
  static const Color _defaultColor = Color(0xFF2196F3);

  /// hex string → Color 파싱
  static Color? parseColor(String? colorHex) {
    if (colorHex == null) return null;
    try {
      return Color(int.parse(colorHex.substring(1), radix: 16) + 0xFF000000);
    } catch (e) {
      return null;
    }
  }

  /// Color → hex string 변환
  static String colorToHex(Color color) {
    final a = (color.a * 255).round();
    final r = (color.r * 255).round();
    final g = (color.g * 255).round();
    final b = (color.b * 255).round();
    final value = a << 24 | r << 16 | g << 8 | b;
    return '#${value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  /// 그룹 색상 반환 (myColor → defaultColor → fallback 순)
  static Color groupColor(Group group, {Color fallback = _defaultColor}) {
    return parseColor(group.myColor) ??
        parseColor(group.defaultColor) ??
        fallback;
  }

  /// 개인 색상 반환 (personalColor hex → fallback 순)
  static Color personalColor(String? personalColorHex, {Color fallback = _defaultColor}) {
    return parseColor(personalColorHex) ?? fallback;
  }

  /// Task 색상 반환 — groupId 기준으로 그룹/개인 색상 결정
  ///
  /// [groupId]: null이면 개인 일정
  /// [groups]: 전체 그룹 목록
  /// [personalColorHex]: 사용자의 personalColor hex 문자열
  static Color taskColor({
    required String? groupId,
    required List<Group> groups,
    String? personalColorHex,
    Color fallback = _defaultColor,
  }) {
    if (groupId == null) {
      return personalColor(personalColorHex, fallback: fallback);
    }
    final group = groups.cast<Group?>().firstWhere(
      (g) => g?.id == groupId,
      orElse: () => null,
    );
    if (group == null) return fallback;
    return groupColor(group, fallback: fallback);
  }
}
