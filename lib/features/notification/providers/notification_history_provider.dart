import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/notification/data/models/notification_model.dart';
import 'package:family_planner/features/notification/data/repositories/notification_repository.dart';

part 'notification_history_provider.g.dart';

/// 알림 히스토리 Provider
@riverpod
class NotificationHistory extends _$NotificationHistory {
  int _currentPage = 1;
  final int _limit = 20;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  @override
  Future<List<NotificationModel>> build() async {
    return _fetchNotifications();
  }

  /// 알림 목록 조회
  Future<List<NotificationModel>> _fetchNotifications() async {
    try {
      final repository = ref.read(notificationRepositoryProvider);
      final result = await repository.getHistory(
        page: _currentPage,
        limit: _limit,
      );

      final notifications = result['notifications'] as List<NotificationModel>;
      final meta = result['meta'] as Map<String, dynamic>;

      // 다음 페이지가 있는지 확인
      final totalPages = meta['totalPages'] as int;
      _hasMore = _currentPage < totalPages;

      return notifications;
    } catch (e) {
      debugPrint('알림 히스토리 조회 실패: $e');
      return [];
    }
  }

  /// 다음 페이지 로드
  Future<void> loadMore() async {
    if (!_hasMore || _isLoadingMore) return;

    final currentList = state.valueOrNull;
    if (currentList == null) return;

    _isLoadingMore = true;
    _currentPage++;

    try {
      final repository = ref.read(notificationRepositoryProvider);
      final result = await repository.getHistory(
        page: _currentPage,
        limit: _limit,
      );

      final newNotifications = result['notifications'] as List<NotificationModel>;
      final meta = result['meta'] as Map<String, dynamic>;

      final totalPages = meta['totalPages'] as int;
      _hasMore = _currentPage < totalPages;

      state = AsyncValue.data([...currentList, ...newNotifications]);
    } catch (e) {
      debugPrint('알림 히스토리 추가 로드 실패: $e');
      _currentPage--;
    } finally {
      _isLoadingMore = false;
    }
  }

  /// 새로고침
  Future<void> refresh() async {
    _currentPage = 1;
    _hasMore = true;
    state = const AsyncValue.loading();
    state = AsyncValue.data(await _fetchNotifications());
  }

  /// 알림 읽음 처리
  Future<void> markAsRead(String notificationId) async {
    try {
      final repository = ref.read(notificationRepositoryProvider);
      await repository.markAsRead(notificationId);

      markReadLocally(notificationId);
    } catch (e) {
      debugPrint('알림 읽음 처리 실패: $e');
    }
  }

  /// 로컬 읽음 상태 업데이트 (스크롤 위치 유지)
  void markReadLocally(String notificationId) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncValue.data(
      current.map((n) => n.id == notificationId ? n.copyWith(isRead: true) : n).toList(),
    );
  }

  /// 로컬 삭제 (스크롤 위치 유지)
  void removeLocally(String notificationId) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncValue.data(
      current.where((n) => n.id != notificationId).toList(),
    );
  }

  /// 더 불러올 데이터가 있는지 여부
  bool get hasMore => _hasMore;
}
