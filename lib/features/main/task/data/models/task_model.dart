import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

/// Task 타입
enum TaskType {
  @JsonValue('CALENDAR_ONLY')
  calendarOnly, // 단순 일정 (캘린더에만 표시)
  @JsonValue('TODO_LINKED')
  todoLinked, // 할일 연동 (캘린더 + 할일 목록에 표시)
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
  pending, // 대기 중
  @JsonValue('IN_PROGRESS')
  inProgress, // 진행 중
  @JsonValue('COMPLETED')
  completed, // 완료
  @JsonValue('CANCELLED')
  cancelled, // 취소
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
@freezed
class TaskModel with _$TaskModel {
  const TaskModel._();

  const factory TaskModel({
    required String id,
    required String userId,
    String? groupId,
    required String title,
    String? description,
    String? location,
    TaskType? type,
    TaskPriority? priority,
    CategoryModel? category,
    DateTime? scheduledAt,
    DateTime? dueAt,
    int? daysUntilDue,
    @Default(TaskStatus.pending) TaskStatus status,
    DateTime? completedAt,
    RecurringModel? recurring,
    @Default([]) List<TaskParticipantModel> participants,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  /// 카테고리 색상 (hex to int)
  int get colorValue {
    if (category?.color == null) return 0xFF2196F3; // 기본 파란색
    final hex = category!.color!.replaceFirst('#', '');
    return int.parse('FF$hex', radix: 16);
  }

  /// 종일 일정 여부 (시간 정보가 없으면 종일로 간주)
  bool get isAllDay {
    if (scheduledAt == null) return true;
    // 시간이 00:00:00이면 종일로 간주
    return scheduledAt!.hour == 0 &&
        scheduledAt!.minute == 0 &&
        scheduledAt!.second == 0;
  }

  /// 완료 여부 (status가 completed인 경우)
  bool get isCompleted => status == TaskStatus.completed;

  /// 진행 중 여부
  bool get isInProgress => status == TaskStatus.inProgress;

  /// 취소 여부
  bool get isCancelled => status == TaskStatus.cancelled;

  /// 대기 중 여부
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
@freezed
class TaskListResponse with _$TaskListResponse {
  const factory TaskListResponse({
    @Default([]) List<TaskModel> data,
    required PaginationMeta meta,
  }) = _TaskListResponse;

  factory TaskListResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskListResponseFromJson(json);
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
    required String categoryId,
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
