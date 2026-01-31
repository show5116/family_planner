import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';

part 'task_form_provider.freezed.dart';
part 'task_form_provider.g.dart';

/// 반복 종료 타입
enum RecurringEndType {
  never,
  date,
  count,
}

/// 월간 반복 타입
enum MonthlyType {
  dayOfMonth, // 매월 N일
  weekOfMonth, // 매월 N째 주 X요일
}

/// 연간 반복 타입
enum YearlyType {
  dayOfMonth, // 매년 N월 N일
  weekOfMonth, // 매년 N월 N째 주 X요일
}

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

    // 반복 상세 설정
    @Default(1) int recurringInterval, // 반복 간격 (1 = 매번, 2 = 격일/격주 등)
    @Default(RecurringEndType.never) RecurringEndType recurringEndType,
    DateTime? recurringEndDate, // endType이 date일 때
    @Default(10) int recurringCount, // endType이 count일 때
    @Default([]) List<int> recurringDaysOfWeek, // weekly: 요일 선택 (0=일 ~ 6=토)
    @Default(MonthlyType.dayOfMonth) MonthlyType monthlyType,
    @Default(1) int monthlyDayOfMonth, // 1-31
    @Default(1) int monthlyWeekOfMonth, // 1-5 (5=마지막 주)
    @Default(1) int monthlyDayOfWeek, // 0-6
    @Default(YearlyType.dayOfMonth) YearlyType yearlyType,
    @Default(1) int yearlyMonth, // 1-12
    @Default(1) int yearlyDayOfMonth, // 1-31
    @Default(1) int yearlyWeekOfMonth, // 1-5
    @Default(1) int yearlyDayOfWeek, // 0-6

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

    final config = <String, dynamic>{
      'interval': recurringInterval,
      'endType': recurringEndType.name.toUpperCase(),
    };

    // 종료 조건 설정
    if (recurringEndType == RecurringEndType.date && recurringEndDate != null) {
      config['endDate'] = recurringEndDate!.toIso8601String().split('T')[0];
    } else if (recurringEndType == RecurringEndType.count) {
      config['count'] = recurringCount;
    }

    // 타입별 추가 설정
    switch (recurringType!) {
      case RecurringRuleType.daily:
        // daily는 공통 필드만 사용
        break;
      case RecurringRuleType.weekly:
        config['daysOfWeek'] = recurringDaysOfWeek.isNotEmpty
            ? recurringDaysOfWeek
            : [startDate.weekday % 7]; // 기본값: 시작일의 요일
        break;
      case RecurringRuleType.monthly:
        config['monthlyType'] =
            monthlyType == MonthlyType.dayOfMonth ? 'dayOfMonth' : 'weekOfMonth';
        if (monthlyType == MonthlyType.dayOfMonth) {
          config['dayOfMonth'] = monthlyDayOfMonth;
        } else {
          config['weekOfMonth'] = monthlyWeekOfMonth;
          config['dayOfWeek'] = monthlyDayOfWeek;
        }
        break;
      case RecurringRuleType.yearly:
        config['month'] = yearlyMonth;
        config['yearlyType'] =
            yearlyType == YearlyType.dayOfMonth ? 'dayOfMonth' : 'weekOfMonth';
        if (yearlyType == YearlyType.dayOfMonth) {
          config['dayOfMonth'] = yearlyDayOfMonth;
        } else {
          config['weekOfMonth'] = yearlyWeekOfMonth;
          config['dayOfWeek'] = yearlyDayOfWeek;
        }
        break;
    }

    return RecurringRuleDto(
      ruleType: recurringType!,
      ruleConfig: config,
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

    // 반복 설정 파싱
    RecurringRuleType? recurringType;
    int recurringInterval = 1;
    RecurringEndType recurringEndType = RecurringEndType.never;
    DateTime? recurringEndDate;
    int recurringCount = 10;
    List<int> recurringDaysOfWeek = [];
    MonthlyType monthlyType = MonthlyType.dayOfMonth;
    int monthlyDayOfMonth = startDate.day;
    int monthlyWeekOfMonth = ((startDate.day - 1) ~/ 7) + 1;
    int monthlyDayOfWeek = startDate.weekday % 7;
    YearlyType yearlyType = YearlyType.dayOfMonth;
    int yearlyMonth = startDate.month;
    int yearlyDayOfMonth = startDate.day;
    int yearlyWeekOfMonth = ((startDate.day - 1) ~/ 7) + 1;
    int yearlyDayOfWeek = startDate.weekday % 7;

    if (task.recurring != null) {
      recurringType = _parseRecurringType(task.recurring!.ruleType);
      final config = task.recurring!.ruleConfig;
      if (config != null) {
        recurringInterval = (config['interval'] as num?)?.toInt() ?? 1;

        final endTypeStr = config['endType'] as String?;
        if (endTypeStr != null) {
          switch (endTypeStr.toUpperCase()) {
            case 'DATE':
              recurringEndType = RecurringEndType.date;
              if (config['endDate'] != null) {
                recurringEndDate = DateTime.tryParse(config['endDate'] as String);
              }
              break;
            case 'COUNT':
              recurringEndType = RecurringEndType.count;
              recurringCount = (config['count'] as num?)?.toInt() ?? 10;
              break;
            default:
              recurringEndType = RecurringEndType.never;
          }
        }

        // Weekly 설정
        if (config['daysOfWeek'] != null) {
          recurringDaysOfWeek = (config['daysOfWeek'] as List)
              .map((e) => (e as num).toInt())
              .toList();
        }

        // Monthly 설정
        if (config['monthlyType'] != null) {
          monthlyType = config['monthlyType'] == 'weekOfMonth'
              ? MonthlyType.weekOfMonth
              : MonthlyType.dayOfMonth;
        }
        if (config['dayOfMonth'] != null) {
          monthlyDayOfMonth = (config['dayOfMonth'] as num).toInt();
        }
        if (config['weekOfMonth'] != null) {
          monthlyWeekOfMonth = (config['weekOfMonth'] as num).toInt();
        }
        if (config['dayOfWeek'] != null) {
          monthlyDayOfWeek = (config['dayOfWeek'] as num).toInt();
        }

        // Yearly 설정
        if (config['month'] != null) {
          yearlyMonth = (config['month'] as num).toInt();
        }
        if (config['yearlyType'] != null) {
          yearlyType = config['yearlyType'] == 'weekOfMonth'
              ? YearlyType.weekOfMonth
              : YearlyType.dayOfMonth;
        }
        if (config['dayOfMonth'] != null && recurringType == RecurringRuleType.yearly) {
          yearlyDayOfMonth = (config['dayOfMonth'] as num).toInt();
        }
        if (config['weekOfMonth'] != null && recurringType == RecurringRuleType.yearly) {
          yearlyWeekOfMonth = (config['weekOfMonth'] as num).toInt();
        }
        if (config['dayOfWeek'] != null && recurringType == RecurringRuleType.yearly) {
          yearlyDayOfWeek = (config['dayOfWeek'] as num).toInt();
        }
      }
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
      recurringInterval: recurringInterval,
      recurringEndType: recurringEndType,
      recurringEndDate: recurringEndDate,
      recurringCount: recurringCount,
      recurringDaysOfWeek: recurringDaysOfWeek,
      monthlyType: monthlyType,
      monthlyDayOfMonth: monthlyDayOfMonth,
      monthlyWeekOfMonth: monthlyWeekOfMonth,
      monthlyDayOfWeek: monthlyDayOfWeek,
      yearlyType: yearlyType,
      yearlyMonth: yearlyMonth,
      yearlyDayOfMonth: yearlyDayOfMonth,
      yearlyWeekOfMonth: yearlyWeekOfMonth,
      yearlyDayOfWeek: yearlyDayOfWeek,
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
    // 반복 타입 변경 시 기본값으로 초기화
    if (value != state.recurringType) {
      final weekday = state.startDate.weekday % 7; // 0=일 ~ 6=토
      state = state.copyWith(
        recurringType: value,
        recurringInterval: 1,
        recurringEndType: RecurringEndType.never,
        recurringDaysOfWeek: value == RecurringRuleType.weekly ? [weekday] : [],
        monthlyType: MonthlyType.dayOfMonth,
        monthlyDayOfMonth: state.startDate.day,
        monthlyWeekOfMonth: ((state.startDate.day - 1) ~/ 7) + 1,
        monthlyDayOfWeek: weekday,
        yearlyType: YearlyType.dayOfMonth,
        yearlyMonth: state.startDate.month,
        yearlyDayOfMonth: state.startDate.day,
        yearlyWeekOfMonth: ((state.startDate.day - 1) ~/ 7) + 1,
        yearlyDayOfWeek: weekday,
      );
    } else {
      state = state.copyWith(recurringType: value);
    }
  }

  // ============ 반복 상세 설정 ============

  void setRecurringInterval(int value) {
    state = state.copyWith(recurringInterval: value.clamp(1, 99));
  }

  void setRecurringEndType(RecurringEndType value) {
    state = state.copyWith(recurringEndType: value);
  }

  void setRecurringEndDate(DateTime? value) {
    state = state.copyWith(recurringEndDate: value);
  }

  void setRecurringCount(int value) {
    state = state.copyWith(recurringCount: value.clamp(1, 999));
  }

  void toggleDayOfWeek(int day) {
    final days = List<int>.from(state.recurringDaysOfWeek);
    if (days.contains(day)) {
      if (days.length > 1) {
        days.remove(day);
      }
    } else {
      days.add(day);
      days.sort();
    }
    state = state.copyWith(recurringDaysOfWeek: days);
  }

  void setMonthlyType(MonthlyType value) {
    state = state.copyWith(monthlyType: value);
  }

  void setMonthlyDayOfMonth(int value) {
    state = state.copyWith(monthlyDayOfMonth: value.clamp(1, 31));
  }

  void setMonthlyWeekOfMonth(int value) {
    state = state.copyWith(monthlyWeekOfMonth: value.clamp(1, 5));
  }

  void setMonthlyDayOfWeek(int value) {
    state = state.copyWith(monthlyDayOfWeek: value.clamp(0, 6));
  }

  void setYearlyType(YearlyType value) {
    state = state.copyWith(yearlyType: value);
  }

  void setYearlyMonth(int value) {
    state = state.copyWith(yearlyMonth: value.clamp(1, 12));
  }

  void setYearlyDayOfMonth(int value) {
    state = state.copyWith(yearlyDayOfMonth: value.clamp(1, 31));
  }

  void setYearlyWeekOfMonth(int value) {
    state = state.copyWith(yearlyWeekOfMonth: value.clamp(1, 5));
  }

  void setYearlyDayOfWeek(int value) {
    state = state.copyWith(yearlyDayOfWeek: value.clamp(0, 6));
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
