// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScheduleAuthorImpl _$$ScheduleAuthorImplFromJson(Map<String, dynamic> json) =>
    _$ScheduleAuthorImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      profileImage: json['profileImage'] as String?,
    );

Map<String, dynamic> _$$ScheduleAuthorImplToJson(
  _$ScheduleAuthorImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'profileImage': instance.profileImage,
};

_$ScheduleShareMemberImpl _$$ScheduleShareMemberImplFromJson(
  Map<String, dynamic> json,
) => _$ScheduleShareMemberImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  profileImage: json['profileImage'] as String?,
);

Map<String, dynamic> _$$ScheduleShareMemberImplToJson(
  _$ScheduleShareMemberImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'profileImage': instance.profileImage,
};

_$RecurrenceRuleImpl _$$RecurrenceRuleImplFromJson(Map<String, dynamic> json) =>
    _$RecurrenceRuleImpl(
      type: $enumDecode(_$RecurrenceTypeEnumMap, json['type']),
      interval: (json['interval'] as num?)?.toInt() ?? 1,
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      daysOfWeek:
          (json['daysOfWeek'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      dayOfMonth: (json['dayOfMonth'] as num?)?.toInt(),
      monthOfYear: (json['monthOfYear'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$RecurrenceRuleImplToJson(
  _$RecurrenceRuleImpl instance,
) => <String, dynamic>{
  'type': _$RecurrenceTypeEnumMap[instance.type]!,
  'interval': instance.interval,
  'endDate': instance.endDate?.toIso8601String(),
  'daysOfWeek': instance.daysOfWeek,
  'dayOfMonth': instance.dayOfMonth,
  'monthOfYear': instance.monthOfYear,
};

const _$RecurrenceTypeEnumMap = {
  RecurrenceType.none: 'NONE',
  RecurrenceType.daily: 'DAILY',
  RecurrenceType.weekly: 'WEEKLY',
  RecurrenceType.monthly: 'MONTHLY',
  RecurrenceType.yearly: 'YEARLY',
};

_$ScheduleReminderImpl _$$ScheduleReminderImplFromJson(
  Map<String, dynamic> json,
) => _$ScheduleReminderImpl(
  id: json['id'] as String,
  minutesBefore: (json['minutesBefore'] as num).toInt(),
  isEnabled: json['isEnabled'] as bool? ?? true,
);

Map<String, dynamic> _$$ScheduleReminderImplToJson(
  _$ScheduleReminderImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'minutesBefore': instance.minutesBefore,
  'isEnabled': instance.isEnabled,
};

_$ScheduleModelImpl _$$ScheduleModelImplFromJson(Map<String, dynamic> json) =>
    _$ScheduleModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      location: json['location'] as String?,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      isAllDay: json['isAllDay'] as bool? ?? false,
      shareType:
          $enumDecodeNullable(_$ScheduleShareTypeEnumMap, json['shareType']) ??
          ScheduleShareType.family,
      sharedWith:
          (json['sharedWith'] as List<dynamic>?)
              ?.map(
                (e) => ScheduleShareMember.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      recurrence: json['recurrence'] == null
          ? null
          : RecurrenceRule.fromJson(json['recurrence'] as Map<String, dynamic>),
      reminders:
          (json['reminders'] as List<dynamic>?)
              ?.map((e) => ScheduleReminder.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      color: json['color'] as String?,
      author: ScheduleAuthor.fromJson(json['author'] as Map<String, dynamic>),
      groupId: json['groupId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ScheduleModelImplToJson(_$ScheduleModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'location': instance.location,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'isAllDay': instance.isAllDay,
      'shareType': _$ScheduleShareTypeEnumMap[instance.shareType]!,
      'sharedWith': instance.sharedWith,
      'recurrence': instance.recurrence,
      'reminders': instance.reminders,
      'color': instance.color,
      'author': instance.author,
      'groupId': instance.groupId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ScheduleShareTypeEnumMap = {
  ScheduleShareType.private: 'PRIVATE',
  ScheduleShareType.family: 'FAMILY',
  ScheduleShareType.specific: 'SPECIFIC',
};

_$ScheduleListResponseImpl _$$ScheduleListResponseImplFromJson(
  Map<String, dynamic> json,
) => _$ScheduleListResponseImpl(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => ScheduleModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  total: (json['total'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$ScheduleListResponseImplToJson(
  _$ScheduleListResponseImpl instance,
) => <String, dynamic>{'items': instance.items, 'total': instance.total};

_$MonthlyScheduleParamsImpl _$$MonthlyScheduleParamsImplFromJson(
  Map<String, dynamic> json,
) => _$MonthlyScheduleParamsImpl(
  year: (json['year'] as num).toInt(),
  month: (json['month'] as num).toInt(),
  memberId: json['memberId'] as String?,
);

Map<String, dynamic> _$$MonthlyScheduleParamsImplToJson(
  _$MonthlyScheduleParamsImpl instance,
) => <String, dynamic>{
  'year': instance.year,
  'month': instance.month,
  'memberId': instance.memberId,
};
