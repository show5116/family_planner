// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryModelImpl _$$CategoryModelImplFromJson(Map<String, dynamic> json) =>
    _$CategoryModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      groupId: json['groupId'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      emoji: json['emoji'] as String?,
      color: json['color'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$CategoryModelImplToJson(_$CategoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'groupId': instance.groupId,
      'name': instance.name,
      'description': instance.description,
      'emoji': instance.emoji,
      'color': instance.color,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$RecurringModelImpl _$$RecurringModelImplFromJson(Map<String, dynamic> json) =>
    _$RecurringModelImpl(
      id: json['id'] as String,
      ruleType: json['ruleType'] as String,
      ruleConfig: json['ruleConfig'] as Map<String, dynamic>?,
      generationType: json['generationType'] as String,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$RecurringModelImplToJson(
  _$RecurringModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'ruleType': instance.ruleType,
  'ruleConfig': instance.ruleConfig,
  'generationType': instance.generationType,
  'isActive': instance.isActive,
};

_$TaskReminderResponseImpl _$$TaskReminderResponseImplFromJson(
  Map<String, dynamic> json,
) => _$TaskReminderResponseImpl(
  id: json['id'] as String,
  reminderType: json['reminderType'] as String,
  offsetMinutes: (json['offsetMinutes'] as num).toInt(),
  sentAt: json['sentAt'] == null
      ? null
      : DateTime.parse(json['sentAt'] as String),
);

Map<String, dynamic> _$$TaskReminderResponseImplToJson(
  _$TaskReminderResponseImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'reminderType': instance.reminderType,
  'offsetMinutes': instance.offsetMinutes,
  'sentAt': instance.sentAt?.toIso8601String(),
};

_$TaskHistoryModelImpl _$$TaskHistoryModelImplFromJson(
  Map<String, dynamic> json,
) => _$TaskHistoryModelImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  action: json['action'] as String?,
  changes: json['changes'] as Map<String, dynamic>?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$TaskHistoryModelImplToJson(
  _$TaskHistoryModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'action': instance.action,
  'changes': instance.changes,
  'createdAt': instance.createdAt.toIso8601String(),
};

_$TaskModelImpl _$$TaskModelImplFromJson(Map<String, dynamic> json) =>
    _$TaskModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      groupId: json['groupId'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      location: json['location'] as String?,
      type: $enumDecodeNullable(_$TaskTypeEnumMap, json['type']),
      priority: $enumDecodeNullable(_$TaskPriorityEnumMap, json['priority']),
      category: json['category'] == null
          ? null
          : CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
      scheduledAt: json['scheduledAt'] == null
          ? null
          : DateTime.parse(json['scheduledAt'] as String),
      dueAt: json['dueAt'] == null
          ? null
          : DateTime.parse(json['dueAt'] as String),
      daysUntilDue: (json['daysUntilDue'] as num?)?.toInt(),
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      recurring: json['recurring'] == null
          ? null
          : RecurringModel.fromJson(json['recurring'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$TaskModelImplToJson(_$TaskModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'groupId': instance.groupId,
      'title': instance.title,
      'description': instance.description,
      'location': instance.location,
      'type': _$TaskTypeEnumMap[instance.type],
      'priority': _$TaskPriorityEnumMap[instance.priority],
      'category': instance.category,
      'scheduledAt': instance.scheduledAt?.toIso8601String(),
      'dueAt': instance.dueAt?.toIso8601String(),
      'daysUntilDue': instance.daysUntilDue,
      'isCompleted': instance.isCompleted,
      'completedAt': instance.completedAt?.toIso8601String(),
      'recurring': instance.recurring,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$TaskTypeEnumMap = {
  TaskType.schedule: 'SCHEDULE',
  TaskType.todo: 'TODO',
};

const _$TaskPriorityEnumMap = {
  TaskPriority.low: 'LOW',
  TaskPriority.medium: 'MEDIUM',
  TaskPriority.high: 'HIGH',
  TaskPriority.urgent: 'URGENT',
};

_$TaskListResponseImpl _$$TaskListResponseImplFromJson(
  Map<String, dynamic> json,
) => _$TaskListResponseImpl(
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$TaskListResponseImplToJson(
  _$TaskListResponseImpl instance,
) => <String, dynamic>{'data': instance.data, 'meta': instance.meta};

_$PaginationMetaImpl _$$PaginationMetaImplFromJson(Map<String, dynamic> json) =>
    _$PaginationMetaImpl(
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
      total: (json['total'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$PaginationMetaImplToJson(
  _$PaginationMetaImpl instance,
) => <String, dynamic>{
  'page': instance.page,
  'limit': instance.limit,
  'total': instance.total,
  'totalPages': instance.totalPages,
};

_$CreateTaskDtoImpl _$$CreateTaskDtoImplFromJson(Map<String, dynamic> json) =>
    _$CreateTaskDtoImpl(
      title: json['title'] as String,
      description: json['description'] as String?,
      location: json['location'] as String?,
      type: $enumDecodeNullable(_$TaskTypeEnumMap, json['type']),
      priority: $enumDecodeNullable(_$TaskPriorityEnumMap, json['priority']),
      categoryId: json['categoryId'] as String,
      groupId: json['groupId'] as String?,
      scheduledAt: json['scheduledAt'] as String?,
      dueAt: json['dueAt'] as String?,
      recurring: json['recurring'] == null
          ? null
          : RecurringRuleDto.fromJson(
              json['recurring'] as Map<String, dynamic>,
            ),
      reminders: (json['reminders'] as List<dynamic>?)
          ?.map((e) => TaskReminderDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CreateTaskDtoImplToJson(_$CreateTaskDtoImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'location': instance.location,
      'type': _$TaskTypeEnumMap[instance.type],
      'priority': _$TaskPriorityEnumMap[instance.priority],
      'categoryId': instance.categoryId,
      'groupId': instance.groupId,
      'scheduledAt': instance.scheduledAt,
      'dueAt': instance.dueAt,
      'recurring': instance.recurring,
      'reminders': instance.reminders,
    };

_$UpdateTaskDtoImpl _$$UpdateTaskDtoImplFromJson(Map<String, dynamic> json) =>
    _$UpdateTaskDtoImpl(
      title: json['title'] as String?,
      description: json['description'] as String?,
      location: json['location'] as String?,
      type: $enumDecodeNullable(_$TaskTypeEnumMap, json['type']),
      priority: $enumDecodeNullable(_$TaskPriorityEnumMap, json['priority']),
      scheduledAt: json['scheduledAt'] as String?,
      dueAt: json['dueAt'] as String?,
    );

Map<String, dynamic> _$$UpdateTaskDtoImplToJson(_$UpdateTaskDtoImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'location': instance.location,
      'type': _$TaskTypeEnumMap[instance.type],
      'priority': _$TaskPriorityEnumMap[instance.priority],
      'scheduledAt': instance.scheduledAt,
      'dueAt': instance.dueAt,
    };

_$RecurringRuleDtoImpl _$$RecurringRuleDtoImplFromJson(
  Map<String, dynamic> json,
) => _$RecurringRuleDtoImpl(
  ruleType: $enumDecode(_$RecurringRuleTypeEnumMap, json['ruleType']),
  ruleConfig: json['ruleConfig'] as Map<String, dynamic>?,
  generationType: $enumDecodeNullable(
    _$RecurringGenerationTypeEnumMap,
    json['generationType'],
  ),
);

Map<String, dynamic> _$$RecurringRuleDtoImplToJson(
  _$RecurringRuleDtoImpl instance,
) => <String, dynamic>{
  'ruleType': _$RecurringRuleTypeEnumMap[instance.ruleType]!,
  'ruleConfig': instance.ruleConfig,
  'generationType': _$RecurringGenerationTypeEnumMap[instance.generationType],
};

const _$RecurringRuleTypeEnumMap = {
  RecurringRuleType.daily: 'DAILY',
  RecurringRuleType.weekly: 'WEEKLY',
  RecurringRuleType.monthly: 'MONTHLY',
  RecurringRuleType.yearly: 'YEARLY',
};

const _$RecurringGenerationTypeEnumMap = {
  RecurringGenerationType.autoScheduler: 'AUTO_SCHEDULER',
  RecurringGenerationType.manual: 'MANUAL',
};

_$TaskReminderDtoImpl _$$TaskReminderDtoImplFromJson(
  Map<String, dynamic> json,
) => _$TaskReminderDtoImpl(
  reminderType: $enumDecode(_$TaskReminderTypeEnumMap, json['reminderType']),
  offsetMinutes: (json['offsetMinutes'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$TaskReminderDtoImplToJson(
  _$TaskReminderDtoImpl instance,
) => <String, dynamic>{
  'reminderType': _$TaskReminderTypeEnumMap[instance.reminderType]!,
  'offsetMinutes': instance.offsetMinutes,
};

const _$TaskReminderTypeEnumMap = {
  TaskReminderType.beforeStart: 'BEFORE_START',
  TaskReminderType.beforeDue: 'BEFORE_DUE',
  TaskReminderType.atTime: 'AT_TIME',
};
