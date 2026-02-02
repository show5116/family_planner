import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/notification/data/repositories/notification_repository.dart';
import 'package:family_planner/features/notification/providers/notification_settings_provider.dart';
import 'package:family_planner/features/notification/providers/unread_notifications_provider.dart';
import 'package:family_planner/features/notification/providers/unread_count_provider.dart';
import 'package:family_planner/features/notification/presentation/widgets/notification_permission_card.dart';
import 'package:family_planner/features/notification/presentation/widgets/notification_settings_section.dart';
import 'package:family_planner/features/notification/presentation/widgets/notification_error_state.dart';

/// 알림 설정 화면
class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  /// 테스트 알림 전송
  Future<void> _sendTestNotification(BuildContext context, WidgetRef ref) async {
    try {
      final repository = ref.read(notificationRepositoryProvider);
      await repository.sendTestNotification();

      ref.invalidate(unreadNotificationsProvider);
      ref.invalidate(unreadCountProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('테스트 알림이 전송되었습니다'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('테스트 알림 전송 실패: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(notificationSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('알림 설정')),
      body: settingsAsync.when(
        data: (settings) => ListView(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          children: [
            // 알림 권한 상태 카드
            const NotificationPermissionCard(),
            const SizedBox(height: AppSizes.spaceL),

            // 알림 설정 섹션
            NotificationSettingsSection(settings: settings),
            const SizedBox(height: AppSizes.spaceL),

            // 알림 히스토리 버튼
            _NotificationHistoryTile(
              onTap: () => context.push(AppRoutes.notificationHistory),
            ),
            const SizedBox(height: AppSizes.spaceL),

            // 테스트 알림 버튼 (운영자 전용)
            _TestNotificationTile(
              onTap: () => _sendTestNotification(context, ref),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => NotificationErrorState(
          error: error,
          title: '알림 설정을 불러올 수 없습니다',
          onRetry: () => ref.invalidate(notificationSettingsProvider),
        ),
      ),
    );
  }
}

/// 알림 히스토리 타일
class _NotificationHistoryTile extends StatelessWidget {
  final VoidCallback onTap;

  const _NotificationHistoryTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.history),
        title: const Text('알림 히스토리'),
        subtitle: const Text('받은 알림 목록을 확인합니다'),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

/// 테스트 알림 타일
class _TestNotificationTile extends StatelessWidget {
  final VoidCallback onTap;

  const _TestNotificationTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.notifications_active, color: Colors.orange),
        title: const Text('테스트 알림 전송'),
        subtitle: const Text('테스트 알림을 자신에게 전송합니다 (운영자 전용)'),
        trailing: const Icon(Icons.send),
        onTap: onTap,
      ),
    );
  }
}
