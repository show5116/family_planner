import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/notification/data/models/notification_model.dart';

/// 알림 클릭 시 화면 이동을 처리하는 서비스
///
/// 백엔드에서 알림 전송 시 data 필드에 다음 키를 포함해야 합니다:
/// - schedule: { "scheduleId": "uuid" }
/// - todo: { "todoId": "uuid" }
/// - household: { "householdId": "uuid" }
/// - asset: { "assetId": "uuid" }
/// - childcare: { "childId": "uuid" }
/// - group: { "groupId": "uuid" }
/// - system (공지사항): { "announcementId": "uuid" }
/// - system (QnA): { "questionId": "uuid" }
class NotificationNavigationService {
  NotificationNavigationService._();

  /// 알림 데이터를 기반으로 해당 화면으로 이동
  ///
  /// [context] BuildContext
  /// [notification] 알림 모델
  /// [returns] 이동 성공 여부
  static bool navigateToDetail(
    BuildContext context,
    NotificationModel notification,
  ) {
    final data = notification.data;
    if (data == null || data.isEmpty) {
      return false;
    }

    return _navigateByCategory(context, notification.category, data);
  }

  /// 카테고리와 데이터로 화면 이동 (푸시 알림용)
  ///
  /// [context] BuildContext
  /// [category] 알림 카테고리 문자열 (예: "SCHEDULE", "TODO")
  /// [data] 알림 데이터
  static bool navigateByData(
    BuildContext context,
    String? categoryString,
    Map<String, dynamic> data,
  ) {
    if (categoryString == null) return false;

    final category = _parseCategory(categoryString);
    if (category == null) return false;

    return _navigateByCategory(context, category, data);
  }

  /// 카테고리별 화면 이동 로직
  static bool _navigateByCategory(
    BuildContext context,
    NotificationCategory category,
    Map<String, dynamic> data,
  ) {
    switch (category) {
      case NotificationCategory.schedule:
        return _navigateToSchedule(context, data);

      case NotificationCategory.todo:
        return _navigateToTodo(context, data);

      case NotificationCategory.household:
        return _navigateToHousehold(context, data);

      case NotificationCategory.asset:
        return _navigateToAsset(context, data);

      case NotificationCategory.childcare:
        return _navigateToChildcare(context, data);

      case NotificationCategory.group:
        return _navigateToGroup(context, data);

      case NotificationCategory.system:
        return _navigateToSystem(context, data);
    }
  }

  /// 일정 상세 화면으로 이동
  static bool _navigateToSchedule(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    final scheduleId = data['scheduleId'] as String?;
    if (scheduleId == null) return false;

    context.push('${AppRoutes.calendarDetail}?id=$scheduleId');
    return true;
  }

  /// 할 일 상세 화면으로 이동
  static bool _navigateToTodo(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    final todoId = data['todoId'] as String?;
    if (todoId == null) return false;

    context.push('${AppRoutes.todoDetail}?id=$todoId');
    return true;
  }

  /// 가계부 상세 화면으로 이동
  static bool _navigateToHousehold(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    final householdId = data['householdId'] as String?;
    if (householdId == null) return false;

    context.push('${AppRoutes.householdDetail}?id=$householdId');
    return true;
  }

  /// 자산 상세 화면으로 이동
  static bool _navigateToAsset(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    final assetId = data['assetId'] as String?;
    if (assetId == null) return false;

    context.push('${AppRoutes.assetDetail}?id=$assetId');
    return true;
  }

  /// 육아 (자녀 포인트) 상세 화면으로 이동
  static bool _navigateToChildcare(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    final childId = data['childId'] as String?;
    if (childId == null) return false;

    context.push('${AppRoutes.childPointsDetail}?id=$childId');
    return true;
  }

  /// 그룹 상세 화면으로 이동
  static bool _navigateToGroup(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    final groupId = data['groupId'] as String?;
    if (groupId == null) return false;

    context.push(AppRoutes.groupDetail.replaceFirst(':id', groupId));
    return true;
  }

  /// 시스템 알림 화면으로 이동 (공지사항, QnA 등)
  static bool _navigateToSystem(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    // 공지사항
    final announcementId = data['announcementId'] as String?;
    if (announcementId != null) {
      context.push(
        AppRoutes.announcementDetail.replaceFirst(':id', announcementId),
      );
      return true;
    }

    // QnA
    final questionId = data['questionId'] as String?;
    if (questionId != null) {
      context.push(
        AppRoutes.questionDetail.replaceFirst(':id', questionId),
      );
      return true;
    }

    // 데이터가 없으면 공지사항 목록으로 이동
    context.push(AppRoutes.announcements);
    return true;
  }

  /// 카테고리 문자열을 enum으로 파싱
  static NotificationCategory? _parseCategory(String categoryString) {
    switch (categoryString.toUpperCase()) {
      case 'SCHEDULE':
        return NotificationCategory.schedule;
      case 'TODO':
        return NotificationCategory.todo;
      case 'HOUSEHOLD':
        return NotificationCategory.household;
      case 'ASSET':
        return NotificationCategory.asset;
      case 'CHILDCARE':
        return NotificationCategory.childcare;
      case 'GROUP':
        return NotificationCategory.group;
      case 'SYSTEM':
        return NotificationCategory.system;
      default:
        return null;
    }
  }
}
