import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/routes/app_routes.dart';
import '../../providers/notification_settings_provider.dart';
import '../widgets/notification_permission_card.dart';
import '../widgets/notification_toggle_item.dart';

/// 알림 설정 화면
class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

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

            // 알림 설정
            Text(
              '알림 설정',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSizes.spaceM),

            Card(
              child: Column(
                children: [
                  NotificationToggleItem(
                    icon: Icons.calendar_today_outlined,
                    title: '일정 알림',
                    subtitle: '일정 시작 전 알림을 받습니다',
                    value: settings.scheduleEnabled,
                    onChanged: (value) {
                      ref
                          .read(notificationSettingsProvider.notifier)
                          .updateSetting(scheduleEnabled: value);
                    },
                  ),
                  const Divider(height: 1),
                  NotificationToggleItem(
                    icon: Icons.check_box_outlined,
                    title: '할 일 알림',
                    subtitle: '할 일 마감 기한 알림을 받습니다',
                    value: settings.todoEnabled,
                    onChanged: (value) {
                      ref
                          .read(notificationSettingsProvider.notifier)
                          .updateSetting(todoEnabled: value);
                    },
                  ),
                  const Divider(height: 1),
                  NotificationToggleItem(
                    icon: Icons.account_balance_wallet_outlined,
                    title: '가계부 알림',
                    subtitle: '가계부 관련 알림을 받습니다',
                    value: settings.householdEnabled,
                    onChanged: (value) {
                      ref
                          .read(notificationSettingsProvider.notifier)
                          .updateSetting(householdEnabled: value);
                    },
                  ),
                  const Divider(height: 1),
                  NotificationToggleItem(
                    icon: Icons.savings_outlined,
                    title: '자산 알림',
                    subtitle: '자산 변동 관련 알림을 받습니다',
                    value: settings.assetEnabled,
                    onChanged: (value) {
                      ref
                          .read(notificationSettingsProvider.notifier)
                          .updateSetting(assetEnabled: value);
                    },
                  ),
                  const Divider(height: 1),
                  NotificationToggleItem(
                    icon: Icons.child_care_outlined,
                    title: '육아 알림',
                    subtitle: '육아 포인트 관련 알림을 받습니다',
                    value: settings.childcareEnabled,
                    onChanged: (value) {
                      ref
                          .read(notificationSettingsProvider.notifier)
                          .updateSetting(childcareEnabled: value);
                    },
                  ),
                  const Divider(height: 1),
                  NotificationToggleItem(
                    icon: Icons.group_outlined,
                    title: '그룹 알림',
                    subtitle: '그룹 관련 알림을 받습니다',
                    value: settings.groupEnabled,
                    onChanged: (value) {
                      ref
                          .read(notificationSettingsProvider.notifier)
                          .updateSetting(groupEnabled: value);
                    },
                  ),
                  const Divider(height: 1),
                  NotificationToggleItem(
                    icon: Icons.campaign_outlined,
                    title: '시스템 알림',
                    subtitle: '중요한 시스템 알림을 받습니다',
                    value: settings.systemEnabled,
                    onChanged: (value) {
                      ref
                          .read(notificationSettingsProvider.notifier)
                          .updateSetting(systemEnabled: value);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.spaceL),

            // 알림 히스토리 버튼
            Card(
              child: ListTile(
                leading: const Icon(Icons.history),
                title: const Text('알림 히스토리'),
                subtitle: const Text('받은 알림 목록을 확인합니다'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.push(AppRoutes.notificationHistory);
                },
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: AppSizes.spaceM),
              Text('알림 설정을 불러올 수 없습니다\n$error'),
              const SizedBox(height: AppSizes.spaceM),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(notificationSettingsProvider);
                },
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
