import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

/// Task 타입
enum TaskType {
  @JsonValue('CALENDAR_ONLY')
  calendarOnly, // 단순 일정 (캘린더에만 표시)
  @JsonValue('TODO_LINKED')
  todoLinked, // 할일 연동 (캘린더 + 할일 목록에 표시)
  @JsonValue('TODO_ONLY')
  todoOnly, // 할일 전용 (할일 목록에만 표시, 캘린더 제외)
}

/// Task 우선순위
enum TaskPriority {
  @JsonValue('LOW')
  low,
  @JsonValue('MEDIUM')
  medium,
  @JsonValue('HIGH')
  high,
  @JsonValue('URGENT')
  urgent,
}

/// 반복 규칙 타입
enum RecurringRuleType {
  @JsonValue('DAILY')
  daily,
  @JsonValue('WEEKLY')
  weekly,
  @JsonValue('MONTHLY')
  monthly,
  @JsonValue('YEARLY')
  yearly,
}

/// 반복 생성 방식
enum RecurringGenerationType {
  @JsonValue('AUTO_SCHEDULER')
  autoScheduler,
  @JsonValue('MANUAL')
  manual,
}

/// 알림 타입
enum TaskReminderType {
  @JsonValue('BEFORE_START')
  beforeStart,
  @JsonValue('BEFORE_DUE')
  beforeDue,
  @JsonValue('AT_TIME')
  atTime,
}

/// Task 상태
enum TaskStatus {
  @JsonValue('PENDING')
  pending, // 대기중
  @JsonValue('IN_PROGRESS')
  inProgress, // 진행중
  @JsonValue('COMPLETED')
  completed, // 완료
  @JsonValue('HOLD')
  hold, // 보류
  @JsonValue('DROP')
  drop, // 드롭
  @JsonValue('FAILED')
  failed, // 실패
}

/// 카테고리 모델
@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required String id,
    required String userId,
    String? groupId,
    required String name,
    String? description,
    String? emoji,
    String? color,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}

/// 반복 정보 모델
@freezed
class RecurringModel with _$RecurringModel {
  const factory RecurringModel({
    required String id,
    required String ruleType,
    Map<String, dynamic>? ruleConfig,
    required String generationType,
    @Default(true) bool isActive,
  }) = _RecurringModel;

  factory RecurringModel.fromJson(Map<String, dynamic> json) =>
      _$RecurringModelFromJson(json);
}

/// 알림 응답 모델
@freezed
class TaskReminderResponse with _$TaskReminderResponse {
  const factory TaskReminderResponse({
    required String id,
    required String reminderType,
    required int offsetMinutes,
    DateTime? sentAt,
  }) = _TaskReminderResponse;

  factory TaskReminderResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskReminderResponseFromJson(json);
}

/// 변경 이력 모델
@freezed
class TaskHistoryModel with _$TaskHistoryModel {
  const factory TaskHistoryModel({
    required String id,
    required String userId,
    String? action,
    Map<String, dynamic>? changes,
    required DateTime createdAt,
  }) = _TaskHistoryModel;

  factory TaskHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$TaskHistoryModelFromJson(json);
}

/// 참여자 사용자 정보 모델
@freezed
class ParticipantUserModel with _$ParticipantUserModel {
  const factory ParticipantUserModel({
    required String id,
    required String name,
    String? profileImageKey,
  }) = _ParticipantUserModel;

  factory ParticipantUserModel.fromJson(Map<String, dynamic> json) =>
      _$ParticipantUserModelFromJson(json);
}

/// Task 참여자 모델
@freezed
class TaskParticipantModel with _$TaskParticipantModel {
  const factory TaskParticipantModel({
    required String id,
    required String taskId,
    required String userId,
    ParticipantUserModel? user,
    required DateTime createdAt,
  }) = _TaskParticipantModel;

  factory TaskParticipantModel.fromJson(Map<String, dynamic> json) =>
      _$TaskParticipantModelFromJson(json);
}

/// Task 모델 (일정/할일 통합)
class TaskModel {
  final String id;
  final String userId;
  final String? groupId;
  final String title;
  final String? description;
  final String? location;
  final TaskType? type;
  final TaskPriority? priority;
  final CategoryModel? category;
  final DateTime? scheduledAt;
  final DateTime? dueAt;
  final int? daysUntilDue;
  final TaskStatus status;
  final DateTime? completedAt;
  final RecurringModel? recurring;
  final List<TaskParticipantModel> participants;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TaskModel({
    required this.id,
    required this.userId,
    this.groupId,
    required this.title,
    this.description,
    this.location,
    this.type,
    this.priority,
    this.category,
    this.scheduledAt,
    this.dueAt,
    this.daysUntilDue,
    this.status = TaskStatus.pending,
    this.completedAt,
    this.recurring,
    this.participants = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final rawScheduledAt = json['scheduledAt'] != null
        ? DateTime.parse(json['scheduledAt'] as String)
        : null;

    TaskType? parseType(dynamic v) {
      if (v == null) return null;
      switch (v as String) {
        case 'CALENDAR_ONLY': return TaskType.calendarOnly;
        case 'TODO_LINKED': return TaskType.todoLinked;
        case 'TODO_ONLY': return TaskType.todoOnly;
        default: return null;
      }
    }

    TaskPriority? parsePriority(dynamic v) {
      if (v == null) return null;
      switch (v as String) {
        case 'LOW': return TaskPriority.low;
        case 'MEDIUM': return TaskPriority.medium;
        case 'HIGH': return TaskPriority.high;
        case 'URGENT': return TaskPriority.urgent;
        default: return null;
      }
    }

    TaskStatus parseStatus(dynamic v) {
      if (v == null) return TaskStatus.pending;
      switch (v as String) {
        case 'IN_PROGRESS': return TaskStatus.inProgress;
        case 'COMPLETED': return TaskStatus.completed;
        case 'HOLD': return TaskStatus.hold;
        case 'DROP': return TaskStatus.drop;
        case 'FAILED': return TaskStatus.failed;
        default: return TaskStatus.pending;
      }
    }

    return TaskModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      groupId: json['groupId'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      location: json['location'] as String?,
      type: parseType(json['type']),
      priority: parsePriority(json['priority']),
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      scheduledAt: rawScheduledAt?.toLocal(),
      dueAt: json['dueAt'] != null
          ? DateTime.parse(json['dueAt'] as String).toLocal()
          : null,
      daysUntilDue: json['daysUntilDue'] as int?,
      status: parseStatus(json['status']),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String).toLocal()
          : null,
      recurring: json['recurring'] != null
          ? RecurringModel.fromJson(json['recurring'] as Map<String, dynamic>)
          : null,
      participants: (json['participants'] as List<dynamic>? ?? [])
          .map((e) => TaskParticipantModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
    );
  }

  TaskModel copyWith({
    String? id,
    String? userId,
    String? groupId,
    String? title,
    String? description,
    String? location,
    TaskType? type,
    TaskPriority? priority,
    CategoryModel? category,
    DateTime? scheduledAt,
    DateTime? dueAt,
    int? daysUntilDue,
    TaskStatus? status,
    DateTime? completedAt,
    RecurringModel? recurring,
    List<TaskParticipantModel>? participants,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      groupId: groupId ?? this.groupId,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      dueAt: dueAt ?? this.dueAt,
      daysUntilDue: daysUntilDue ?? this.daysUntilDue,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
      recurring: recurring ?? this.recurring,
      participants: participants ?? this.participants,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// 카테고리 색상 (hex to int)
  int get colorValue {
    if (category?.color == null) return 0xFF2196F3;
    final hex = category!.color!.replaceFirst('#', '');
    return int.parse('FF$hex', radix: 16);
  }

  bool get isCompleted => status == TaskStatus.completed;
  bool get isInProgress => status == TaskStatus.inProgress;
  bool get isHold => status == TaskStatus.hold;
  bool get isDrop => status == TaskStatus.drop;
  bool get isFailed => status == TaskStatus.failed;
  bool get isPending => status == TaskStatus.pending;
}

/// Task 상세 모델 (알림, 이력 포함)
@freezed
class TaskDetailModel with _$TaskDetailModel {
  const factory TaskDetailModel({
    required TaskModel task,
    @Default([]) List<TaskReminderResponse> reminders,
    @Default([]) List<TaskHistoryModel> histories,
  }) = _TaskDetailModel;

  factory TaskDetailModel.fromJson(Map<String, dynamic> json) {
    // task 기본 필드와 reminders, histories를 분리하여 처리
    final taskJson = Map<String, dynamic>.from(json);
    taskJson.remove('reminders');
    taskJson.remove('histories');

    return TaskDetailModel(
      task: TaskModel.fromJson(taskJson),
      reminders: (json['reminders'] as List<dynamic>?)
              ?.map(
                  (e) => TaskReminderResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      histories: (json['histories'] as List<dynamic>?)
              ?.map((e) => TaskHistoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// Task 목록 응답 모델
class TaskListResponse {
  final List<TaskModel> data;
  final PaginationMeta meta;

  const TaskListResponse({this.data = const [], required this.meta});

  factory TaskListResponse.fromJson(Map<String, dynamic> json) {
    return TaskListResponse(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }

  TaskListResponse copyWith({List<TaskModel>? data, PaginationMeta? meta}) {
    return TaskListResponse(
      data: data ?? this.data,
      meta: meta ?? this.meta,
    );
  }
}

/// 페이지네이션 메타
@freezed
class PaginationMeta with _$PaginationMeta {
  const factory PaginationMeta({
    @Default(1) int page,
    @Default(20) int limit,
    @Default(0) int total,
    @Default(0) int totalPages,
  }) = _PaginationMeta;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaFromJson(json);
}

/// Task 생성 DTO
@freezed
class CreateTaskDto with _$CreateTaskDto {
  const factory CreateTaskDto({
    required String title,
    String? description,
    String? location,
    TaskType? type,
    TaskPriority? priority,
    String? categoryId,
    String? groupId,
    String? scheduledAt,
    String? dueAt,
    RecurringRuleDto? recurring,
    List<TaskReminderDto>? reminders,
    List<String>? participantIds,
  }) = _CreateTaskDto;

  factory CreateTaskDto.fromJson(Map<String, dynamic> json) =>
      _$CreateTaskDtoFromJson(json);
}

/// Task 수정 DTO
@freezed
class UpdateTaskDto with _$UpdateTaskDto {
  const factory UpdateTaskDto({
    String? title,
    String? description,
    String? location,
    TaskType? type,
    TaskPriority? priority,
    String? scheduledAt,
    String? dueAt,
    List<String>? participantIds,
    List<TaskReminderDto>? reminders,
  }) = _UpdateTaskDto;

  factory UpdateTaskDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateTaskDtoFromJson(json);
}

/// 반복 규칙 DTO
@freezed
class RecurringRuleDto with _$RecurringRuleDto {
  const factory RecurringRuleDto({
    required RecurringRuleType ruleType,
    Map<String, dynamic>? ruleConfig,
    RecurringGenerationType? generationType,
  }) = _RecurringRuleDto;

  factory RecurringRuleDto.fromJson(Map<String, dynamic> json) =>
      _$RecurringRuleDtoFromJson(json);
}

/// 알림 DTO
@freezed
class TaskReminderDto with _$TaskReminderDto {
  const factory TaskReminderDto({
    required TaskReminderType reminderType,
    @Default(0) int offsetMinutes,
  }) = _TaskReminderDto;

  factory TaskReminderDto.fromJson(Map<String, dynamic> json) =>
      _$TaskReminderDtoFromJson(json);
}
