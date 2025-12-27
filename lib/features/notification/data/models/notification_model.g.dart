// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationModelImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  body: json['body'] as String,
  type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
  timestamp: DateTime.parse(json['timestamp'] as String),
  isRead: json['isRead'] as bool? ?? false,
  data: json['data'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$$NotificationModelImplToJson(
  _$NotificationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'body': instance.body,
  'type': _$NotificationTypeEnumMap[instance.type]!,
  'timestamp': instance.timestamp.toIso8601String(),
  'isRead': instance.isRead,
  'data': instance.data,
};

const _$NotificationTypeEnumMap = {
  NotificationType.schedule: 'schedule',
  NotificationType.todo: 'todo',
  NotificationType.household: 'household',
  NotificationType.groupInvite: 'groupInvite',
  NotificationType.announcement: 'announcement',
};
