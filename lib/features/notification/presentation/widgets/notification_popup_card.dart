import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/notification/data/models/notification_model.dart';
import 'package:family_planner/features/notification/data/repositories/notification_repository.dart';
import 'package:family_planner/features/notification/data/services/notification_navigation_service.dart';
import 'package:family_planner/features/notification/providers/unread_notifications_provider.dart';
import 'package:family_planner/features/notification/providers/unread_count_provider.dart';

/// 알림 팝업 카드
/// 우측 상단 알림 아이콘을 클릭하면 나타나는 작은 팝업
class NotificationPopupCard extends ConsumerWidget {
  const NotificationPopupCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(unreadNotificationsProvider);

    return Card(
      elevation: 8,
      margin: EdgeInsets.zero,
      child: Container(
        width: 360,
        constraints: const BoxConstraints(maxHeight: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Padding(
              padding: const EdgeInsets.all(AppSizes.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 타이틀 행
                  Row(
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: AppSizes.spaceS),
                      Text(
                        '읽지 않은 알림',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spaceS),
                  // 버튼 행
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => _onMarkAllAsRead(context, ref),
                        child: const Text('전체 읽음'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.push(AppRoutes.notificationHistory);
                        },
                        child: const Text('전체보기'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // 알림 목록
            Flexible(
              child: notificationsAsync.when(
                data: (notifications) {
                  if (notifications.isEmpty) {
                    return _buildEmptyState(context);
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return _NotificationPopupItem(
                        notification: notification,
                        onTap: () => _onNotificationTap(
                          context,
                          ref,
                          notification,
                        ),
                        onMarkAsRead: () => _onMarkAsReadOnly(
                          context,
                          ref,
                          notification,
                        ),
                      );
                    },
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(AppSizes.spaceL),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stack) => _buildErrorState(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 알림 탭 처리
  Future<void> _onNotificationTap(
    BuildContext context,
    WidgetRef ref,
    NotificationModel notification,
  ) async {
    try {
      // 팝업 닫기
      Navigator.of(context).pop();

      // 읽음 처리
      final repository = ref.read(notificationRepositoryProvider);
      await repository.markAsRead(notification.id);

      // Provider 상태 업데이트
      ref.read(unreadNotificationsProvider.notifier).markAsRead(notification.id);
      ref.read(unreadCountProvider.notifier).decrementCount();

      // 상세 화면으로 이동 (data에 따라 다른 화면으로)
      if (context.mounted && notification.data != null) {
        _navigateToDetail(context, notification);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('알림 처리 실패: $e')),
        );
      }
    }
  }

  /// 읽음 처리만 (화면 이동 없음)
  Future<void> _onMarkAsReadOnly(
    BuildContext context,
    WidgetRef ref,
    NotificationModel notification,
  ) async {
    try {
      final repository = ref.read(notificationRepositoryProvider);
      await repository.markAsRead(notification.id);

      // Provider 상태 업데이트
      ref.read(unreadNotificationsProvider.notifier).markAsRead(notification.id);
      ref.read(unreadCountProvider.notifier).decrementCount();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('알림 처리 실패: $e')),
        );
      }
    }
  }

  /// 전체 읽음 처리
  Future<void> _onMarkAllAsRead(BuildContext context, WidgetRef ref) async {
    try {
      final repository = ref.read(notificationRepositoryProvider);
      final count = await repository.markAllAsRead();

      // Provider 상태 업데이트
      ref.read(unreadCountProvider.notifier).clearCount();
      ref.read(unreadNotificationsProvider.notifier).clearAll();

      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$count개의 알림을 읽음 처리했습니다')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('전체 읽음 처리 실패: $e')),
        );
      }
    }
  }

  /// 데이터에 따라 상세 화면으로 이동
  void _navigateToDetail(BuildContext context, NotificationModel notification) {
    NotificationNavigationService.navigateToDetail(context, notification);
  }

  /// 빈 상태 위젯
  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.spaceL),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.notifications_none,
              size: 48,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: AppSizes.spaceS),
            Text(
              '새로운 알림이 없습니다',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  /// 에러 상태 위젯
  Widget _buildErrorState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.spaceL),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: AppSizes.spaceS),
            Text(
              '알림을 불러올 수 없습니다',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

/// 알림 팝업 아이템
class _NotificationPopupItem extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onMarkAsRead;

  const _NotificationPopupItem({
    required this.notification,
    required this.onTap,
    required this.onMarkAsRead,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MM/dd HH:mm');

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.02),
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor,
              width: 1,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 카테고리 아이콘
            Container(
              padding: const EdgeInsets.all(AppSizes.spaceS),
              decoration: BoxDecoration(
                color: _getCategoryColor(notification.category).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              ),
              child: Icon(
                _getCategoryIcon(notification.category),
                color: _getCategoryColor(notification.category),
                size: 20,
              ),
            ),

            const SizedBox(width: AppSizes.spaceM),

            // 알림 내용
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 제목
                  Text(
                    notification.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: AppSizes.spaceXS),

                  // 내용
                  Text(
                    notification.body,
                    style: theme.textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: AppSizes.spaceXS),

                  // 시간
                  Text(
                    dateFormat.format(notification.sentAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),

            // 읽음 처리 버튼
            IconButton(
              onPressed: onMarkAsRead,
              icon: Icon(
                Icons.check_circle_outline,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              tooltip: '읽음 처리',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  /// 카테고리별 아이콘
  IconData _getCategoryIcon(NotificationCategory category) {
    switch (category) {
      case NotificationCategory.schedule:
        return Icons.calendar_today_outlined;
      case NotificationCategory.todo:
        return Icons.check_box_outlined;
      case NotificationCategory.household:
        return Icons.account_balance_wallet_outlined;
      case NotificationCategory.asset:
        return Icons.savings_outlined;
      case NotificationCategory.childcare:
        return Icons.child_care_outlined;
      case NotificationCategory.group:
        return Icons.group_outlined;
      case NotificationCategory.system:
        return Icons.campaign_outlined;
    }
  }

  /// 카테고리별 색상
  Color _getCategoryColor(NotificationCategory category) {
    switch (category) {
      case NotificationCategory.schedule:
        return Colors.blue;
      case NotificationCategory.todo:
        return Colors.green;
      case NotificationCategory.household:
        return Colors.orange;
      case NotificationCategory.asset:
        return Colors.purple;
      case NotificationCategory.childcare:
        return Colors.pink;
      case NotificationCategory.group:
        return Colors.teal;
      case NotificationCategory.system:
        return Colors.red;
    }
  }
}
