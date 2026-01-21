import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/notification/data/models/notification_model.dart';
import 'package:family_planner/features/notification/data/repositories/notification_repository.dart';

part 'unread_notifications_provider.g.dart';

/// 읽지 않은 알림 Provider
/// 홈 화면에서 최신 읽지 않은 알림 목록을 표시하기 위해 사용
@riverpod
class UnreadNotifications extends _$UnreadNotifications {
  static const int _limit = 5; // 홈 화면에는 최대 5개만 표시

  @override
  Future<List<NotificationModel>> build() async {
    return _fetchUnreadNotifications();
  }

  /// 읽지 않은 알림 조회
  Future<List<NotificationModel>> _fetchUnreadNotifications() async {
    try {
      final repository = ref.read(notificationRepositoryProvider);
      final result = await repository.getHistory(
        page: 1,
        limit: _limit,
        unreadOnly: true,
      );

      final notifications = result['notifications'] as List<NotificationModel>;
      return notifications;
    } catch (e) {
      debugPrint('읽지 않은 알림 조회 실패: $e');
      return [];
    }
  }

  /// 새로고침
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchUnreadNotifications());
  }

  /// 알림을 읽음 처리 (로컬 상태 업데이트)
  Future<void> markAsRead(String notificationId) async {
    final currentList = await future;
    // 읽음 처리한 알림은 목록에서 제거
    final updatedList = currentList
        .where((notification) => notification.id != notificationId)
        .toList();
    state = AsyncValue.data(updatedList);
  }

  /// 전체 읽음 처리 (로컬 상태 업데이트)
  void clearAll() {
    state = const AsyncValue.data([]);
  }
}
