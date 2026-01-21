import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/notification/data/repositories/notification_repository.dart';

part 'unread_count_provider.g.dart';

/// 읽지 않은 알림 개수 Provider
@riverpod
class UnreadCount extends _$UnreadCount {
  @override
  Future<int> build() async {
    return _fetchUnreadCount();
  }

  /// 읽지 않은 알림 개수 조회
  Future<int> _fetchUnreadCount() async {
    try {
      final repository = ref.read(notificationRepositoryProvider);
      return await repository.getUnreadCount();
    } catch (e) {
      debugPrint('읽지 않은 알림 개수 조회 실패: $e');
      return 0;
    }
  }

  /// 새로고침
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchUnreadCount());
  }

  /// 알림을 읽었을 때 개수 감소
  void decrementCount() {
    state.whenData((count) {
      if (count > 0) {
        state = AsyncValue.data(count - 1);
      }
    });
  }

  /// 전체 읽음 처리 시 개수 0으로 초기화
  void clearCount() {
    state = const AsyncValue.data(0);
  }
}
