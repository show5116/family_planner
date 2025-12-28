import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../data/models/notification_model.dart';

/// 알림 히스토리 아이템
class NotificationHistoryItem extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const NotificationHistoryItem({
    super.key,
    required this.notification,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MM/dd HH:mm');

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSizes.spaceM),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('알림 삭제'),
            content: const Text('이 알림을 삭제하시겠습니까?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('삭제'),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        onDelete?.call();
      },
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          decoration: BoxDecoration(
            color: notification.isRead
                ? Colors.transparent
                : theme.colorScheme.primary.withValues(alpha: 0.05),
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
              // 알림 아이콘
              Container(
                padding: const EdgeInsets.all(AppSizes.spaceS),
                decoration: BoxDecoration(
                  color: _getCategoryColor(notification.category).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                ),
                child: Icon(
                  _getCategoryIcon(notification.category),
                  color: _getCategoryColor(notification.category),
                  size: 24,
                ),
              ),

              const SizedBox(width: AppSizes.spaceM),

              // 알림 내용
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 제목 및 시간
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: notification.isRead
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSizes.spaceS),
                        Text(
                          dateFormat.format(notification.sentAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSizes.spaceXS),

                    // 내용
                    Text(
                      notification.body,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: notification.isRead
                            ? theme.colorScheme.onSurface.withValues(alpha: 0.7)
                            : theme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // 읽지 않음 표시
              if (!notification.isRead) ...[
                const SizedBox(width: AppSizes.spaceS),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
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
