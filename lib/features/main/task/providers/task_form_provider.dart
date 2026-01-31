import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';

part 'task_form_provider.freezed.dart';
part 'task_form_provider.g.dart';

/// Task Form 상태 모델
/// - categories는 별도 Provider(selectedGroupCategoriesProvider)로 관리
/// - UI 렌더링에 필요한 상태만 포함
@freezed
class TaskFormState with _$TaskFormState {
  const factory TaskFormState({
    // 기본 정보
    @Default('') String title,
    @Default('') String description,
    @Default('') String location,

    // 날짜/시간
    required DateTime startDate,
    DateTime? dueDate,
    TimeOfDay? startTime,
    TimeOfDay? dueTime,
    @Default(true) bool isAllDay,
    @Default(false) bool hasDueDate,

    // 일정 속성
    @Default(TaskType.calendarOnly) TaskType taskType,
    @Default(TaskPriority.medium) TaskPriority priority,
    RecurringRuleType? recurringType,

    // 알림 (분 단위)
    @Default([]) List<int> selectedReminders,

    // 카테고리 (Provider에서 로드된 목록에서 선택)
    CategoryModel? selectedCategory,

    // 참가자
    @Default([]) List<String> selectedParticipantIds,

    // 제출 상태
    @Default(false) bool isSubmitting,

    // 수정 모드
    TaskModel? editingTask,
    String? editingTaskId,
  }) = _TaskFormState;

  const TaskFormState._();

  /// 수정 모드 여부
  bool get isEditMode => editingTask != null;

  // ============ DTO 변환 로직 (캡슐화) ============

  /// 시작 DateTime 계산 (정오 전략 적용)
  /// - 종일 일정: 정오(12:00)로 설정하여 타임존 안전성 확보
  /// - 시간 지정: 사용자 선택 시간 사용
  DateTime get scheduledDateTime {
    if (isAllDay) {
      // 정오(Noon) 전략: 타임존 변환 시에도 날짜가 바뀌지 않도록 12:00 사용
      return DateTime(startDate.year, startDate.month, startDate.day, 12, 0, 0);
    } else {
      return DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
        startTime?.hour ?? 9,
        startTime?.minute ?? 0,
      );
    }
  }

  /// 마감 DateTime 계산 (정오 전략 적용)
  DateTime? get dueDateTime {
    if (!hasDueDate || dueDate == null) return null;

    if (isAllDay) {
      // 종일 일정의 마감일도 정오로 설정
      return DateTime(dueDate!.year, dueDate!.month, dueDate!.day, 12, 0, 0);
    } else {
      return DateTime(
        dueDate!.year,
        dueDate!.month,
        dueDate!.day,
        dueTime?.hour ?? 18,
        dueTime?.minute ?? 0,
      );
    }
  }

  /// 반복 규칙 DTO 생성
  RecurringRuleDto? get recurringDto {
    if (recurringType == null) return null;
    return RecurringRuleDto(
      ruleType: recurringType!,
      generationType: RecurringGenerationType.autoScheduler,
    );
  }

  /// 알림 DTO 리스트 생성
  List<TaskReminderDto>? get remindersDto {
    if (selectedReminders.isEmpty) return null;
    return selectedReminders
        .map((minutes) => TaskReminderDto(
              reminderType: TaskReminderType.beforeStart,
              offsetMinutes: minutes,
            ))
        .toList();
  }

  /// CreateTaskDto 생성
  CreateTaskDto toCreateDto(String? groupId) {
    return CreateTaskDto(
      title: title.trim(),
      description: description.trim().isEmpty ? null : description.trim(),
      location: location.trim().isEmpty ? null : location.trim(),
      type: taskType,
      priority: priority,
      categoryId: selectedCategory!.id,
      groupId: groupId,
      scheduledAt: scheduledDateTime.toIso8601String(),
      dueAt: dueDateTime?.toIso8601String(),
      recurring: recurringDto,
      reminders: remindersDto,
      participantIds: groupId != null && selectedParticipantIds.isNotEmpty
          ? selectedParticipantIds
          : null,
    );
  }

  /// UpdateTaskDto 생성
  UpdateTaskDto toUpdateDto(String? groupId) {
    return UpdateTaskDto(
      title: title.trim(),
      description: description.trim().isEmpty ? null : description.trim(),
      location: location.trim().isEmpty ? null : location.trim(),
      type: taskType,
      priority: priority,
      scheduledAt: scheduledDateTime.toIso8601String(),
      dueAt: dueDateTime?.toIso8601String(),
      participantIds: groupId != null && selectedParticipantIds.isNotEmpty
          ? selectedParticipantIds
          : null,
    );
  }

  /// 유효성 검사
  /// - 반환값: null이면 유효, 문자열이면 에러 코드
  String? validate() {
    if (title.trim().isEmpty) return 'title_required';
    if (selectedCategory == null) return 'category_required';
    return null;
  }
}

/// Task Form Notifier
/// - 비즈니스 로직만 담당
/// - Categories는 별도 Provider 사용 (Riverpod 패턴 준수)
@riverpod
class TaskFormNotifier extends _$TaskFormNotifier {
  @override
  TaskFormState build({
    String? taskId,
    TaskModel? task,
    DateTime? initialDate,
  }) {
    final startDate = initialDate ?? DateTime.now();

    // 수정 모드인 경우 기존 데이터로 초기화
    if (task != null) {
      return _initFromTask(task, taskId);
    }

    // 신규 작성 모드
    return TaskFormState(
      startDate: startDate,
      editingTaskId: taskId,
      editingTask: task,
    );
  }

  /// 기존 Task 데이터로 상태 초기화
  TaskFormState _initFromTask(TaskModel task, String? taskId) {
    TimeOfDay? startTime;
    TimeOfDay? dueTime;
    bool isAllDay = task.isAllDay;
    DateTime startDate = task.scheduledAt ?? DateTime.now();

    if (task.scheduledAt != null && !isAllDay) {
      startTime = TimeOfDay.fromDateTime(task.scheduledAt!);
    }

    DateTime? dueDate;
    bool hasDueDate = false;
    if (task.dueAt != null) {
      hasDueDate = true;
      dueDate = task.dueAt;
      if (!isAllDay) {
        dueTime = TimeOfDay.fromDateTime(task.dueAt!);
      }
    }

    RecurringRuleType? recurringType;
    if (task.recurring != null) {
      recurringType = _parseRecurringType(task.recurring!.ruleType);
    }

    return TaskFormState(
      title: task.title,
      description: task.description ?? '',
      location: task.location ?? '',
      startDate: startDate,
      dueDate: dueDate,
      startTime: startTime,
      dueTime: dueTime,
      isAllDay: isAllDay,
      hasDueDate: hasDueDate,
      taskType: task.type ?? TaskType.calendarOnly,
      priority: task.priority ?? TaskPriority.medium,
      recurringType: recurringType,
      selectedCategory: task.category,
      selectedParticipantIds: task.participants.map((p) => p.userId).toList(),
      editingTask: task,
      editingTaskId: taskId,
    );
  }

  RecurringRuleType? _parseRecurringType(String ruleType) {
    switch (ruleType.toUpperCase()) {
      case 'DAILY':
        return RecurringRuleType.daily;
      case 'WEEKLY':
        return RecurringRuleType.weekly;
      case 'MONTHLY':
        return RecurringRuleType.monthly;
      case 'YEARLY':
        return RecurringRuleType.yearly;
      default:
        return null;
    }
  }

  // ============ 기본 정보 업데이트 ============

  void setTitle(String value) {
    state = state.copyWith(title: value);
  }

  void setDescription(String value) {
    state = state.copyWith(description: value);
  }

  void setLocation(String value) {
    state = state.copyWith(location: value);
  }

  // ============ 날짜/시간 업데이트 ============

  void setIsAllDay(bool value) {
    state = state.copyWith(
      isAllDay: value,
      startTime: value ? null : state.startTime,
      dueTime: value ? null : state.dueTime,
    );
  }

  void setStartDate(DateTime value) {
    DateTime? newDueDate = state.dueDate;
    if (newDueDate != null && value.isAfter(newDueDate)) {
      newDueDate = value;
    }
    state = state.copyWith(startDate: value, dueDate: newDueDate);
  }

  void setStartTime(TimeOfDay? value) {
    state = state.copyWith(startTime: value);
  }

  void setHasDueDate(bool value) {
    state = state.copyWith(
      hasDueDate: value,
      dueDate: value && state.dueDate == null ? state.startDate : state.dueDate,
    );
  }

  void setDueDate(DateTime? value) {
    state = state.copyWith(dueDate: value);
  }

  void setDueTime(TimeOfDay? value) {
    state = state.copyWith(dueTime: value);
  }

  // ============ 일정 속성 업데이트 ============

  void setTaskType(TaskType value) {
    state = state.copyWith(taskType: value);
  }

  void setPriority(TaskPriority value) {
    state = state.copyWith(priority: value);
  }

  void setRecurringType(RecurringRuleType? value) {
    state = state.copyWith(recurringType: value);
  }

  // ============ 카테고리 ============

  void setSelectedCategory(CategoryModel? value) {
    state = state.copyWith(selectedCategory: value);
  }

  /// 그룹 변경 시 카테고리 초기화
  void clearCategory() {
    state = state.copyWith(selectedCategory: null);
  }

  // ============ 알림 ============

  void toggleReminder(int minutes) {
    final reminders = List<int>.from(state.selectedReminders);
    if (reminders.contains(minutes)) {
      reminders.remove(minutes);
    } else {
      reminders.add(minutes);
      reminders.sort();
    }
    state = state.copyWith(selectedReminders: reminders);
  }

  void addReminder(int minutes) {
    if (!state.selectedReminders.contains(minutes)) {
      final reminders = List<int>.from(state.selectedReminders)..add(minutes);
      reminders.sort();
      state = state.copyWith(selectedReminders: reminders);
    }
  }

  void removeReminder(int minutes) {
    final reminders = List<int>.from(state.selectedReminders)..remove(minutes);
    state = state.copyWith(selectedReminders: reminders);
  }

  // ============ 참가자 ============

  void toggleParticipant(String userId) {
    final participants = List<String>.from(state.selectedParticipantIds);
    if (participants.contains(userId)) {
      participants.remove(userId);
    } else {
      participants.add(userId);
    }
    state = state.copyWith(selectedParticipantIds: participants);
  }

  void selectAllParticipants(List<String> userIds) {
    state = state.copyWith(selectedParticipantIds: userIds);
  }

  void clearParticipants() {
    state = state.copyWith(selectedParticipantIds: []);
  }

  // ============ 제출 처리 ============

  /// Task 생성
  Future<void> createTask(String? groupId) async {
    state = state.copyWith(isSubmitting: true);
    try {
      final dto = state.toCreateDto(groupId);
      await ref.read(taskManagementProvider.notifier).createTask(dto);
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }

  /// Task 수정
  Future<void> updateTask(String? groupId) async {
    if (state.editingTaskId == null) return;

    state = state.copyWith(isSubmitting: true);
    try {
      final dto = state.toUpdateDto(groupId);
      await ref.read(taskManagementProvider.notifier).updateTask(
            state.editingTaskId!,
            dto,
            originalDate: state.editingTask?.scheduledAt,
          );
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }

  /// Task 삭제
  Future<void> deleteTask() async {
    if (state.editingTaskId == null || state.editingTask == null) return;

    state = state.copyWith(isSubmitting: true);
    try {
      await ref.read(taskManagementProvider.notifier).deleteTask(
            state.editingTaskId!,
            state.editingTask!.scheduledAt ?? DateTime.now(),
          );
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }
}
