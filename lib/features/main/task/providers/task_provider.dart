import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/features/main/task/data/repositories/task_repository.dart';

part 'task_provider.g.dart';

/// 현재 선택된 날짜 Provider
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

/// 현재 보고 있는 월 Provider (캘린더 페이지 이동용)
final focusedMonthProvider = StateProvider<DateTime>((ref) => DateTime.now());

/// 현재 선택된 그룹 ID 목록 Provider (다중 선택 지원, 캘린더 필터용)
final selectedGroupIdsProvider = StateProvider<List<String>>((ref) => []);

/// 개인 일정 포함 여부 Provider (기본값: true)
final includePersonalProvider = StateProvider<bool>((ref) => true);

/// 현재 선택된 카테고리 ID 목록 Provider (캘린더 필터용)
final selectedCategoryIdsProvider = StateProvider<List<String>>((ref) => []);

/// 현재 선택된 그룹 ID Provider (카테고리 관리 등 단일 그룹 선택용)
final selectedGroupIdProvider = StateProvider<String?>((ref) => null);

/// Todo 필터: 완료된 항목 표시 여부 (기본값: false)
final showCompletedTodosProvider = StateProvider<bool>((ref) => false);

/// Todo 필터: 상태 필터 (null이면 전체)
final todoFilterStatusProvider = StateProvider<TaskStatus?>((ref) => null);

/// Todo 필터: 우선순위 필터 (null이면 전체)
final todoFilterPriorityProvider = StateProvider<TaskPriority?>((ref) => null);

/// Todo: 현재 선택된 주의 시작일 (월요일 기준)
final todoSelectedWeekStartProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  // 이번 주 월요일
  return DateTime(now.year, now.month, now.day - (now.weekday - 1));
});

/// Todo: 현재 선택된 날짜 (기본값: 오늘)
final todoSelectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

/// 월간 Task Provider (캘린더 뷰용) - 그룹/카테고리 필터 지원
@riverpod
class MonthlyTasks extends _$MonthlyTasks {
  @override
  Future<List<TaskModel>> build(int year, int month) async {
    final repository = ref.watch(taskRepositoryProvider);
    final groupIds = ref.watch(selectedGroupIdsProvider);
    final includePersonal = ref.watch(includePersonalProvider);
    final categoryIds = ref.watch(selectedCategoryIdsProvider);
    return await repository.getCalendarTasks(
      year: year,
      month: month,
      groupIds: groupIds.isEmpty ? null : groupIds,
      includePersonal: includePersonal,
      categoryIds: categoryIds.isEmpty ? null : categoryIds,
    );
  }

  /// 새로고침
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(taskRepositoryProvider);
      final groupIds = ref.read(selectedGroupIdsProvider);
      final includePersonal = ref.read(includePersonalProvider);
      final categoryIds = ref.read(selectedCategoryIdsProvider);
      return await repository.getCalendarTasks(
        year: year,
        month: month,
        groupIds: groupIds.isEmpty ? null : groupIds,
        includePersonal: includePersonal,
        categoryIds: categoryIds.isEmpty ? null : categoryIds,
      );
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

/// Todo 목록 Provider (할일 뷰용) - 주간 날짜 범위 기반 조회
@riverpod
class TodoTasks extends _$TodoTasks {
  @override
  Future<TaskListResponse> build({int page = 1}) async {
    final repository = ref.watch(taskRepositoryProvider);
    final groupIds = ref.watch(selectedGroupIdsProvider);
    final includePersonal = ref.watch(includePersonalProvider);
    final showCompleted = ref.watch(showCompletedTodosProvider);
    final priorityFilter = ref.watch(todoFilterPriorityProvider);
    final weekStart = ref.watch(todoSelectedWeekStartProvider);

    final startDate = weekStart;
    final endDate = DateTime(weekStart.year, weekStart.month, weekStart.day + 6, 23, 59, 59);

    final response = await repository.getTasks(
      view: 'todo',
      type: TaskType.todoLinked,
      groupIds: groupIds.isEmpty ? null : groupIds,
      includePersonal: includePersonal,
      priority: priorityFilter,
      startDate: startDate,
      endDate: endDate,
      page: page,
      limit: 100,
    );

    // 완료된 항목 숨김 처리 (클라이언트 필터링)
    if (!showCompleted) {
      final filteredData = response.data.where((t) => !t.isCompleted).toList();
      return response.copyWith(
        data: filteredData,
        meta: response.meta.copyWith(total: filteredData.length),
      );
    }

    return response;
  }

  /// 새로고침
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(taskRepositoryProvider);
      final groupIds = ref.read(selectedGroupIdsProvider);
      final includePersonal = ref.read(includePersonalProvider);
      final showCompleted = ref.read(showCompletedTodosProvider);
      final priorityFilter = ref.read(todoFilterPriorityProvider);
      final weekStart = ref.read(todoSelectedWeekStartProvider);

      final startDate = weekStart;
      final endDate = DateTime(weekStart.year, weekStart.month, weekStart.day + 6, 23, 59, 59);

      final response = await repository.getTasks(
        view: 'todo',
        type: TaskType.todoLinked,
        groupIds: groupIds.isEmpty ? null : groupIds,
        includePersonal: includePersonal,
        priority: priorityFilter,
        startDate: startDate,
        endDate: endDate,
        page: page,
        limit: 100,
      );

      // 완료된 항목 숨김 처리 (클라이언트 필터링)
      if (!showCompleted) {
        final filteredData = response.data.where((t) => !t.isCompleted).toList();
        return response.copyWith(
          data: filteredData,
          meta: response.meta.copyWith(total: filteredData.length),
        );
      }

      return response;
    });
  }

  /// Task 추가 후 로컬 상태 갱신
  void addTask(TaskModel task) {
    if (!state.hasValue) return;

    final response = state.value!;
    final tasks = List<TaskModel>.from(response.data);
    tasks.insert(0, task);
    state = AsyncValue.data(
      response.copyWith(
        data: tasks,
        meta: response.meta.copyWith(total: response.meta.total + 1),
      ),
    );
  }

  /// Task 수정 후 로컬 상태 갱신
  void updateTask(TaskModel task) {
    if (!state.hasValue) return;

    final response = state.value!;
    final tasks = List<TaskModel>.from(response.data);
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      state = AsyncValue.data(response.copyWith(data: tasks));
    }
  }

  /// Task 삭제 후 로컬 상태 갱신
  void removeTask(String taskId) {
    if (!state.hasValue) return;

    final response = state.value!;
    final tasks = List<TaskModel>.from(response.data);
    tasks.removeWhere((t) => t.id == taskId);
    state = AsyncValue.data(
      response.copyWith(
        data: tasks,
        meta: response.meta.copyWith(total: response.meta.total - 1),
      ),
    );
  }
}

/// 선택된 날짜의 할일 목록 Provider (시작일~마감일 사이에 해당 날짜가 포함된 경우)
@riverpod
Future<List<TaskModel>> todoSelectedDateTasks(Ref ref) async {
  final selectedDate = ref.watch(todoSelectedDateProvider);
  final todosAsync = ref.watch(todoTasksProvider(page: 1));

  return todosAsync.maybeWhen(
    data: (response) {
      return response.data.where((task) {
        // scheduledAt 또는 dueAt이 없으면 제외
        if (task.scheduledAt == null) return false;

        final taskStartDate = DateTime(
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
          final taskEndDate = DateTime(
            task.dueAt!.year,
            task.dueAt!.month,
            task.dueAt!.day,
          );
          return !selected.isBefore(taskStartDate) && !selected.isAfter(taskEndDate);
        }

        // dueAt이 없으면 scheduledAt만 비교
        return taskStartDate == selected;
      }).toList();
    },
    orElse: () => <TaskModel>[],
  );
}

/// 주간 날짜별 할일 개수 Provider (캘린더 마커용)
@riverpod
Map<DateTime, int> todoCountByDate(Ref ref) {
  final todosAsync = ref.watch(todoTasksProvider(page: 1));

  return todosAsync.maybeWhen(
    data: (response) {
      final Map<DateTime, int> countMap = {};

      for (final task in response.data) {
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

/// 카테고리 목록 Provider (groupId 파라미터 지원)
@riverpod
Future<List<CategoryModel>> categories(Ref ref, {String? groupId}) async {
  final repository = ref.watch(taskRepositoryProvider);
  return await repository.getCategories(groupId: groupId);
}

/// 현재 선택된 그룹의 카테고리 목록 Provider
@riverpod
Future<List<CategoryModel>> selectedGroupCategories(Ref ref) async {
  final groupId = ref.watch(selectedGroupIdProvider);
  final repository = ref.watch(taskRepositoryProvider);
  return await repository.getCategories(groupId: groupId);
}

/// 카테고리 관리 Notifier (그룹 지원)
class CategoryManagementNotifier extends StateNotifier<AsyncValue<List<CategoryModel>>> {
  final TaskRepository _repository;
  final Ref _ref;
  String? _groupId;

  CategoryManagementNotifier(this._repository, this._ref)
      : super(const AsyncValue.loading()) {
    _groupId = _ref.read(selectedGroupIdProvider);
    _loadCategories();

    // 그룹 변경 감지
    _ref.listen(selectedGroupIdProvider, (previous, next) {
      if (previous != next) {
        _groupId = next;
        _loadCategories();
      }
    });
  }

  Future<void> _loadCategories() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getCategories(groupId: _groupId));
  }

  /// 새로고침
  Future<void> refresh() async {
    await _loadCategories();
  }

  /// 카테고리 생성
  Future<CategoryModel?> createCategory({
    required String name,
    String? description,
    String? emoji,
    String? color,
  }) async {
    try {
      final category = await _repository.createCategory(
        name: name,
        description: description,
        emoji: emoji,
        color: color,
        groupId: _groupId,
      );

      // 로컬 상태에 추가
      if (state.hasValue) {
        final categories = List<CategoryModel>.from(state.value!);
        categories.add(category);
        state = AsyncValue.data(categories);
      }

      // categories provider 무효화
      _ref.invalidate(categoriesProvider(groupId: _groupId));
      _ref.invalidate(selectedGroupCategoriesProvider);

      return category;
    } catch (e) {
      return null;
    }
  }

  /// 카테고리 수정
  Future<CategoryModel?> updateCategory(
    String id, {
    String? name,
    String? description,
    String? emoji,
    String? color,
  }) async {
    try {
      final category = await _repository.updateCategory(
        id,
        name: name,
        description: description,
        emoji: emoji,
        color: color,
      );

      // 로컬 상태 업데이트
      if (state.hasValue) {
        final categories = List<CategoryModel>.from(state.value!);
        final index = categories.indexWhere((c) => c.id == id);
        if (index != -1) {
          categories[index] = category;
          state = AsyncValue.data(categories);
        }
      }

      // categories provider 무효화
      _ref.invalidate(categoriesProvider(groupId: _groupId));
      _ref.invalidate(selectedGroupCategoriesProvider);

      return category;
    } catch (e) {
      return null;
    }
  }

  /// 카테고리 삭제
  Future<bool> deleteCategory(String id) async {
    try {
      await _repository.deleteCategory(id);

      // 로컬 상태에서 제거
      if (state.hasValue) {
        final categories = List<CategoryModel>.from(state.value!);
        categories.removeWhere((c) => c.id == id);
        state = AsyncValue.data(categories);
      }

      // categories provider 무효화
      _ref.invalidate(categoriesProvider(groupId: _groupId));
      _ref.invalidate(selectedGroupCategoriesProvider);

      return true;
    } catch (e) {
      return false;
    }
  }
}

/// 카테고리 관리 Provider
final categoryManagementProvider =
    StateNotifierProvider<CategoryManagementNotifier, AsyncValue<List<CategoryModel>>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return CategoryManagementNotifier(repository, ref);
});

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

  /// Task 상태 변경
  Future<TaskModel?> updateStatus(String id, TaskStatus status, DateTime taskDate) async {
    state = const AsyncValue.loading();
    try {
      final task = await _repository.updateStatus(id, status);

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

  /// Task 완료/미완료 토글 (하위 호환성 유지)
  Future<TaskModel?> toggleComplete(String id, bool isCompleted, DateTime taskDate) async {
    return updateStatus(
      id,
      isCompleted ? TaskStatus.completed : TaskStatus.pending,
      taskDate,
    );
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
