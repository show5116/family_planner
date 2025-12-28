// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationModelImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  category: $enumDecode(_$NotificationCategoryEnumMap, json['category']),
  title: json['title'] as String,
  body: json['body'] as String,
  data: json['data'] as Map<String, dynamic>?,
  isRead: json['isRead'] as bool? ?? false,
  sentAt: DateTime.parse(json['sentAt'] as String),
  readAt: json['readAt'] == null
      ? null
      : DateTime.parse(json['readAt'] as String),
);

Map<String, dynamic> _$$NotificationModelImplToJson(
  _$NotificationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'category': _$NotificationCategoryEnumMap[instance.category]!,
  'title': instance.title,
  'body': instance.body,
  'data': instance.data,
  'isRead': instance.isRead,
  'sentAt': instance.sentAt.toIso8601String(),
  'readAt': instance.readAt?.toIso8601String(),
};

const _$NotificationCategoryEnumMap = {
  NotificationCategory.schedule: 'SCHEDULE',
  NotificationCategory.todo: 'TODO',
  NotificationCategory.household: 'HOUSEHOLD',
  NotificationCategory.asset: 'ASSET',
  NotificationCategory.childcare: 'CHILDCARE',
  NotificationCategory.group: 'GROUP',
  NotificationCategory.system: 'SYSTEM',
};
