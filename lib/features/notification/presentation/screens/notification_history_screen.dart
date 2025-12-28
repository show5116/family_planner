import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../data/repositories/notification_repository.dart';
import '../../providers/notification_history_provider.dart';
import '../widgets/notification_history_item.dart';

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
  Future<void> _onTap(String notificationId) async {
    try {
      final repository = ref.read(notificationRepositoryProvider);
      await repository.markAsRead(notificationId);

      // Provider 새로고침
      ref.invalidate(notificationHistoryProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('알림 읽음 처리 실패: $e')),
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
                  onTap: () => _onTap(notification.id),
                  onDelete: () => _onDelete(notification.id),
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
