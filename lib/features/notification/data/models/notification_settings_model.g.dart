// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationSettingsModelImpl _$$NotificationSettingsModelImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationSettingsModelImpl(
  scheduleEnabled: json['scheduleEnabled'] as bool? ?? true,
  todoEnabled: json['todoEnabled'] as bool? ?? true,
  householdEnabled: json['householdEnabled'] as bool? ?? true,
  groupInviteEnabled: json['groupInviteEnabled'] as bool? ?? true,
  announcementEnabled: json['announcementEnabled'] as bool? ?? true,
);

Map<String, dynamic> _$$NotificationSettingsModelImplToJson(
  _$NotificationSettingsModelImpl instance,
) => <String, dynamic>{
  'scheduleEnabled': instance.scheduleEnabled,
  'todoEnabled': instance.todoEnabled,
  'householdEnabled': instance.householdEnabled,
  'groupInviteEnabled': instance.groupInviteEnabled,
  'announcementEnabled': instance.announcementEnabled,
};
