import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/notification/data/models/notification_settings_model.dart';
import 'package:family_planner/features/notification/providers/notification_settings_provider.dart';
import 'package:family_planner/features/notification/presentation/widgets/notification_toggle_item.dart';

/// 시간 선택 타일 (날씨 알림 시간 / 루틴 리마인드 시간 등 공용)
class _HourPickerTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final int hour;
  final List<int> availableHours;
  final ValueChanged<int> onChanged;

  const _HourPickerTile({
    required this.title,
    required this.subtitle,
    required this.hour,
    required this.availableHours,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      leading: Icon(Icons.access_time, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
      ),
      trailing: DropdownButton<int>(
        value: hour,
        underline: const SizedBox.shrink(),
        items: availableHours.map((h) {
          final label = h < 12
              ? l10n.notif_hour_am('$h')
              : (h == 12 ? l10n.notif_hour_noon : l10n.notif_hour_pm('${h - 12}'));
          return DropdownMenuItem(value: h, child: Text(label));
        }).toList(),
        onChanged: (v) { if (v != null) onChanged(v); },
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceXS,
      ),
    );
  }
}

/// 알림 설정 섹션 위젯
class NotificationSettingsSection extends ConsumerWidget {
  final NotificationSettingsModel settings;

  const NotificationSettingsSection({
    super.key,
    required this.settings,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.notif_settings,
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
                title: l10n.notif_task,
                subtitle: l10n.notif_task_desc,
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
                title: l10n.notif_todo,
                subtitle: l10n.notif_todo_desc,
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
                title: l10n.notif_household,
                subtitle: l10n.notif_household_desc,
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
                title: l10n.notif_assets,
                subtitle: l10n.notif_assets_desc,
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
                title: l10n.notif_childcare,
                subtitle: l10n.notif_childcare_desc,
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
                title: l10n.notif_group,
                subtitle: l10n.notif_group_desc,
                value: settings.groupEnabled,
                onChanged: (value) {
                  ref
                      .read(notificationSettingsProvider.notifier)
                      .updateSetting(groupEnabled: value);
                },
              ),
              const Divider(height: 1),
              NotificationToggleItem(
                icon: Icons.wallet_outlined,
                title: l10n.notif_savings,
                subtitle: l10n.notif_savings_desc,
                value: settings.savingsEnabled,
                onChanged: (value) {
                  ref
                      .read(notificationSettingsProvider.notifier)
                      .updateSetting(savingsEnabled: value);
                },
              ),
              const Divider(height: 1),
              NotificationToggleItem(
                icon: Icons.campaign_outlined,
                title: l10n.notif_system,
                subtitle: l10n.notif_system_desc,
                value: settings.systemEnabled,
                onChanged: (value) {
                  ref
                      .read(notificationSettingsProvider.notifier)
                      .updateSetting(systemEnabled: value);
                },
              ),
              const Divider(height: 1),
              NotificationToggleItem(
                icon: Icons.wb_cloudy_outlined,
                title: l10n.notif_weather,
                subtitle: l10n.notif_weather_desc,
                value: settings.weatherEnabled,
                onChanged: (value) {
                  ref
                      .read(notificationSettingsProvider.notifier)
                      .updateSetting(weatherEnabled: value);
                },
              ),
              if (settings.weatherEnabled) ...[
                const Divider(height: 1),
                _HourPickerTile(
                  title: l10n.notif_weather_time,
                  subtitle: l10n.notif_weather_time_desc,
                  hour: settings.weatherAlertHour,
                  availableHours: List.generate(17, (i) => i + 5),
                  onChanged: (hour) {
                    ref
                        .read(notificationSettingsProvider.notifier)
                        .updateSetting(weatherAlertHour: hour);
                  },
                ),
              ],
              const Divider(height: 1),
              NotificationToggleItem(
                icon: Icons.checklist_outlined,
                title: l10n.notif_routine,
                subtitle: l10n.notif_routine_desc,
                value: settings.routineEnabled,
                onChanged: (value) {
                  ref
                      .read(notificationSettingsProvider.notifier)
                      .updateSetting(routineEnabled: value);
                },
              ),
              if (settings.routineEnabled) ...[
                const Divider(height: 1),
                _HourPickerTile(
                  title: l10n.notif_routine_time,
                  subtitle: l10n.notif_routine_time_desc,
                  hour: settings.routineReminderHour,
                  availableHours: List.generate(24, (h) => h),
                  onChanged: (hour) {
                    ref
                        .read(notificationSettingsProvider.notifier)
                        .updateSetting(routineReminderHour: hour);
                  },
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
