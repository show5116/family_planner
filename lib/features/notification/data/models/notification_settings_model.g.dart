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
  assetEnabled: json['assetEnabled'] as bool? ?? true,
  childcareEnabled: json['childcareEnabled'] as bool? ?? true,
  groupEnabled: json['groupEnabled'] as bool? ?? true,
  systemEnabled: json['systemEnabled'] as bool? ?? true,
);

Map<String, dynamic> _$$NotificationSettingsModelImplToJson(
  _$NotificationSettingsModelImpl instance,
) => <String, dynamic>{
  'scheduleEnabled': instance.scheduleEnabled,
  'todoEnabled': instance.todoEnabled,
  'householdEnabled': instance.householdEnabled,
  'assetEnabled': instance.assetEnabled,
  'childcareEnabled': instance.childcareEnabled,
  'groupEnabled': instance.groupEnabled,
  'systemEnabled': instance.systemEnabled,
};
