import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/notification/data/models/notification_model.dart';
import 'package:family_planner/features/notification/data/repositories/notification_repository.dart';
import 'package:family_planner/features/notification/data/services/notification_navigation_service.dart';
import 'package:family_planner/features/notification/providers/notification_history_provider.dart';
import 'package:family_planner/features/notification/providers/unread_count_provider.dart';
import 'package:family_planner/features/notification/providers/unread_notifications_provider.dart';
import 'package:family_planner/features/notification/presentation/widgets/notification_history_item.dart';

/// 알림 히스토리 화면
class NotificationHistoryScreen extends ConsumerStatefulWidget {
  const NotificationHistoryScreen({super.key});

  @override
  ConsumerState<NotificationHistoryScreen> createState() =>
      _NotificationHistoryScreenState();
}

class _NotificationHistoryScreenState
    extends ConsumerState<NotificationHistoryScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 스크롤 이벤트 처리
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      // 80% 스크롤 시 다음 페이지 로드
      ref.read(notificationHistoryProvider.notifier).loadMore();
    }
  }

  /// 새로고침
  Future<void> _onRefresh() async {
    await ref.read(notificationHistoryProvider.notifier).refresh();
  }

  /// 알림 삭제
  Future<void> _onDelete(String notificationId) async {
    try {
      final repository = ref.read(notificationRepositoryProvider);
      await repository.deleteNotification(notificationId);

      // Provider 새로고침
      ref.invalidate(notificationHistoryProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('알림이 삭제되었습니다')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('알림 삭제 실패: $e')),
        );
      }
    }
  }

  /// 알림 탭
  Future<void> _onTap(NotificationModel notification) async {
    try {
      final repository = ref.read(notificationRepositoryProvider);
      await repository.markAsRead(notification.id);

      // Provider 새로고침
      ref.invalidate(notificationHistoryProvider);

      // 해당 화면으로 이동
      if (mounted) {
        NotificationNavigationService.navigateToDetail(context, notification);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('알림 읽음 처리 실패: $e')),
        );
      }
    }
  }

  /// 읽음 처리만 (화면 이동 없음)
  Future<void> _onMarkAsReadOnly(NotificationModel notification) async {
    try {
      final repository = ref.read(notificationRepositoryProvider);
      await repository.markAsRead(notification.id);

      // Provider 상태 업데이트
      ref.read(unreadCountProvider.notifier).decrementCount();
      ref.read(unreadNotificationsProvider.notifier).markAsRead(notification.id);
      ref.invalidate(notificationHistoryProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('알림 읽음 처리 실패: $e')),
        );
      }
    }
  }

  /// 전체 읽음 처리
  Future<void> _onMarkAllAsRead() async {
    try {
      final repository = ref.read(notificationRepositoryProvider);
      final count = await repository.markAllAsRead();

      // Provider 상태 업데이트
      ref.read(unreadCountProvider.notifier).clearCount();
      ref.read(unreadNotificationsProvider.notifier).clearAll();
      ref.invalidate(notificationHistoryProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$count개의 알림을 읽음 처리했습니다')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('전체 읽음 처리 실패: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(notificationHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('알림'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _onMarkAllAsRead,
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: const Text('전체 읽음'),
          ),
          const SizedBox(width: AppSizes.spaceS),
        ],
      ),
      body: historyState.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: notifications.length + 1,
              itemBuilder: (context, index) {
                // 로딩 인디케이터
                if (index == notifications.length) {
                  final hasMore =
                      ref.read(notificationHistoryProvider.notifier).hasMore;
                  if (hasMore) {
                    return const Padding(
                      padding: EdgeInsets.all(AppSizes.spaceM),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }

                // 알림 아이템
                final notification = notifications[index];
                return NotificationHistoryItem(
                  notification: notification,
                  onTap: () => _onTap(notification),
                  onDelete: () => _onDelete(notification.id),
                  onMarkAsRead: notification.isRead
                      ? null
                      : () => _onMarkAsReadOnly(notification),
                );
              },
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => _buildErrorState(error),
      ),
    );
  }

  /// 빈 상태 위젯
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            '알림이 없습니다',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
          ),
        ],
      ),
    );
  }

  /// 에러 상태 위젯
  Widget _buildErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            '알림을 불러오는 데 실패했습니다',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            error.toString(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spaceM),
          ElevatedButton.icon(
            onPressed: _onRefresh,
            icon: const Icon(Icons.refresh),
            label: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }
}
