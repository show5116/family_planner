import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/notification/data/models/notification_settings_model.dart';
import 'package:family_planner/features/notification/providers/notification_settings_provider.dart';
import 'package:family_planner/features/notification/presentation/widgets/notification_toggle_item.dart';

/// 알림 설정 섹션 위젯
class NotificationSettingsSection extends ConsumerWidget {
  final NotificationSettingsModel settings;

  const NotificationSettingsSection({
    super.key,
    required this.settings,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '알림 설정',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
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
      ],
    );
  }
}
