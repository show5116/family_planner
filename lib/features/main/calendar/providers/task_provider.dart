import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/main/calendar/data/models/task_model.dart';
import 'package:family_planner/features/main/calendar/data/repositories/task_repository.dart';

part 'task_provider.g.dart';

/// 현재 선택된 날짜 Provider
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

/// 현재 보고 있는 월 Provider (캘린더 페이지 이동용)
final focusedMonthProvider = StateProvider<DateTime>((ref) => DateTime.now());

/// 월간 Task Provider (캘린더 뷰용)
@riverpod
class MonthlyTasks extends _$MonthlyTasks {
  @override
  Future<List<TaskModel>> build(int year, int month) async {
    final repository = ref.watch(taskRepositoryProvider);
    return await repository.getCalendarTasks(year: year, month: month);
  }

  /// 새로고침
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(taskRepositoryProvider);
      return await repository.getCalendarTasks(year: year, month: month);
    });
  }

  /// Task 추가 후 로컬 상태 갱신
  void addTask(TaskModel task) {
    if (!state.hasValue) return;

    final tasks = List<TaskModel>.from(state.value!);
    tasks.add(task);
    state = AsyncValue.data(tasks);
  }

  /// Task 수정 후 로컬 상태 갱신
  void updateTask(TaskModel task) {
    if (!state.hasValue) return;

    final tasks = List<TaskModel>.from(state.value!);
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      state = AsyncValue.data(tasks);
    }
  }

  /// Task 삭제 후 로컬 상태 갱신
  void removeTask(String taskId) {
    if (!state.hasValue) return;

    final tasks = List<TaskModel>.from(state.value!);
    tasks.removeWhere((t) => t.id == taskId);
    state = AsyncValue.data(tasks);
  }
}

/// 선택된 날짜의 Task Provider
@riverpod
Future<List<TaskModel>> selectedDateTasks(Ref ref) async {
  final selectedDate = ref.watch(selectedDateProvider);
  final tasksAsync = ref.watch(
    monthlyTasksProvider(selectedDate.year, selectedDate.month),
  );

  return tasksAsync.maybeWhen(
    data: (tasks) {
      // 선택된 날짜에 해당하는 Task만 필터링
      return tasks.where((task) {
        if (task.scheduledAt == null) return false;

        final taskDate = DateTime(
          task.scheduledAt!.year,
          task.scheduledAt!.month,
          task.scheduledAt!.day,
        );
        final selected = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
        );

        // dueAt이 있으면 기간 일정으로 처리
        if (task.dueAt != null) {
          final dueDate = DateTime(
            task.dueAt!.year,
            task.dueAt!.month,
            task.dueAt!.day,
          );
          return !selected.isBefore(taskDate) && !selected.isAfter(dueDate);
        }

        return taskDate == selected;
      }).toList();
    },
    orElse: () => <TaskModel>[],
  );
}

/// 날짜별 Task 개수 Provider (캘린더 마커용)
@riverpod
Map<DateTime, int> taskCountByDate(Ref ref, int year, int month) {
  final tasksAsync = ref.watch(monthlyTasksProvider(year, month));

  return tasksAsync.maybeWhen(
    data: (tasks) {
      final Map<DateTime, int> countMap = {};

      for (final task in tasks) {
        if (task.scheduledAt == null) continue;

        final startDate = DateTime(
          task.scheduledAt!.year,
          task.scheduledAt!.month,
          task.scheduledAt!.day,
        );

        // dueAt이 있으면 기간 동안 모든 날짜에 표시
        final endDate = task.dueAt != null
            ? DateTime(
                task.dueAt!.year,
                task.dueAt!.month,
                task.dueAt!.day,
              )
            : startDate;

        for (var date = startDate;
            !date.isAfter(endDate);
            date = date.add(const Duration(days: 1))) {
          countMap[date] = (countMap[date] ?? 0) + 1;
        }
      }

      return countMap;
    },
    orElse: () => <DateTime, int>{},
  );
}

/// Task 상세 Provider
@riverpod
Future<TaskDetailModel> taskDetail(Ref ref, String id) async {
  final repository = ref.watch(taskRepositoryProvider);
  return await repository.getTaskById(id);
}

/// 카테고리 목록 Provider
@riverpod
Future<List<CategoryModel>> categories(Ref ref, {String? groupId}) async {
  final repository = ref.watch(taskRepositoryProvider);
  return await repository.getCategories(groupId: groupId);
}

/// Task 관리 Notifier
class TaskManagementNotifier extends StateNotifier<AsyncValue<void>> {
  final TaskRepository _repository;
  final Ref _ref;

  TaskManagementNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  /// Task 생성
  Future<TaskModel?> createTask(CreateTaskDto dto) async {
    state = const AsyncValue.loading();
    try {
      final task = await _repository.createTask(dto);

      // 해당 월의 Task 목록에 추가
      if (task.scheduledAt != null) {
        _ref
            .read(monthlyTasksProvider(
              task.scheduledAt!.year,
              task.scheduledAt!.month,
            ).notifier)
            .addTask(task);
      }

      state = const AsyncValue.data(null);
      return task;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Task 수정
  Future<TaskModel?> updateTask(
    String id,
    UpdateTaskDto dto, {
    String? updateScope,
    DateTime? originalDate,
  }) async {
    state = const AsyncValue.loading();
    try {
      final task = await _repository.updateTask(id, dto, updateScope: updateScope);

      // 해당 월의 Task 목록 갱신
      if (task.scheduledAt != null) {
        _ref
            .read(monthlyTasksProvider(
              task.scheduledAt!.year,
              task.scheduledAt!.month,
            ).notifier)
            .updateTask(task);
      }

      // 이전 월과 다른 경우 이전 월에서 제거
      if (originalDate != null &&
          task.scheduledAt != null &&
          (originalDate.year != task.scheduledAt!.year ||
              originalDate.month != task.scheduledAt!.month)) {
        _ref
            .read(monthlyTasksProvider(originalDate.year, originalDate.month).notifier)
            .removeTask(id);
      }

      // 상세 Provider 무효화
      _ref.invalidate(taskDetailProvider(id));

      state = const AsyncValue.data(null);
      return task;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Task 완료/미완료 토글
  Future<TaskModel?> toggleComplete(String id, bool isCompleted, DateTime taskDate) async {
    state = const AsyncValue.loading();
    try {
      final task = await _repository.toggleComplete(id, isCompleted);

      // 해당 월의 Task 목록 갱신
      _ref
          .read(monthlyTasksProvider(taskDate.year, taskDate.month).notifier)
          .updateTask(task);

      // 상세 Provider 무효화
      _ref.invalidate(taskDetailProvider(id));

      state = const AsyncValue.data(null);
      return task;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Task 삭제
  Future<bool> deleteTask(
    String id,
    DateTime taskDate, {
    String? deleteScope,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteTask(id, deleteScope: deleteScope);

      // 해당 월의 Task 목록에서 제거
      _ref
          .read(monthlyTasksProvider(taskDate.year, taskDate.month).notifier)
          .removeTask(id);

      // 상세 Provider 무효화
      _ref.invalidate(taskDetailProvider(id));

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

/// Task 관리 Provider
final taskManagementProvider =
    StateNotifierProvider<TaskManagementNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TaskManagementNotifier(repository, ref);
});
