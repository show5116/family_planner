import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';

/// Task Repository Provider
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository();
});

/// Task Repository (일정/할일 통합)
class TaskRepository {
  final Dio _dio = ApiClient.instance.dio;

  TaskRepository();

  /// Task 목록 조회 (캘린더/할일 뷰)
  /// [view]: 'calendar' 또는 'todo'
  /// [groupIds]: 그룹 ID 목록
  /// [includePersonal]: 개인 일정 포함 여부 (기본값: true)
  /// [categoryIds]: 카테고리 ID 목록
  /// [startDate], [endDate]: 기간 필터
  /// [type]: Task 타입 (SCHEDULE/TODO)
  /// [status]: 상태 필터 (PENDING, IN_PROGRESS, COMPLETED, CANCELLED)
  Future<TaskListResponse> getTasks({
    String? view,
    List<String>? groupIds,
    bool? includePersonal,
    List<String>? categoryIds,
    TaskType? type,
    TaskPriority? priority,
    TaskStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    int page = 1,
    int limit = 100,
  }) async {
    try {
      final response = await _dio.get('/tasks', queryParameters: {
        if (view != null) 'view': view,
        if (groupIds != null && groupIds.isNotEmpty) 'groupIds': groupIds.join(','),
        if (includePersonal != null) 'includePersonal': includePersonal,
        if (categoryIds != null && categoryIds.isNotEmpty) 'categoryIds': categoryIds.join(','),
        if (type != null) 'type': _taskTypeToString(type),
        if (priority != null) 'priority': _priorityToString(priority),
        if (status != null) 'status': _statusToString(status),
        if (startDate != null) 'startDate': startDate.toIso8601String(),
        if (endDate != null) 'endDate': endDate.toIso8601String(),
        'page': page,
        'limit': limit,
      });

      return TaskListResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [TaskRepository] Task 목록 조회 실패: ${e.message}');
      throw Exception('일정 조회 실패: ${e.message}');
    }
  }

  /// 캘린더 뷰용 Task 목록 조회 (월간)
  /// [groupIds]: 그룹 ID 목록
  /// [includePersonal]: 개인 일정 포함 여부 (기본값: true)
  /// [categoryIds]: 카테고리 ID 목록
  Future<List<TaskModel>> getCalendarTasks({
    required int year,
    required int month,
    List<String>? groupIds,
    bool includePersonal = true,
    List<String>? categoryIds,
  }) async {
    // 해당 월의 첫날과 마지막날
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0, 23, 59, 59);

    final response = await getTasks(
      view: 'calendar',
      startDate: startDate,
      endDate: endDate,
      groupIds: groupIds,
      includePersonal: includePersonal,
      categoryIds: categoryIds,
      limit: 500, // 월간 일정은 충분히 가져옴
    );

    return response.data;
  }

  /// Task 상세 조회
  Future<TaskDetailModel> getTaskById(String id) async {
    try {
      final response = await _dio.get('/tasks/$id');
      return TaskDetailModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('일정을 찾을 수 없습니다');
      }
      if (e.response?.statusCode == 403) {
        throw Exception('접근 권한이 없습니다');
      }
      throw Exception('일정 조회 실패: ${e.message}');
    }
  }

  /// Task 생성
  Future<TaskModel> createTask(CreateTaskDto dto) async {
    try {
      final response = await _dio.post('/tasks', data: dto.toJson());
      return TaskModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [TaskRepository] Task 생성 실패: ${e.message}');
      throw Exception('일정 생성 실패: ${e.message}');
    }
  }

  /// Task 수정
  /// [updateScope]: 'current' (현재만) 또는 'future' (이후 모두) - 반복 일정용
  Future<TaskModel> updateTask(
    String id,
    UpdateTaskDto dto, {
    String? updateScope,
  }) async {
    try {
      final response = await _dio.put(
        '/tasks/$id',
        data: dto.toJson(),
        queryParameters: {
          if (updateScope != null) 'updateScope': updateScope,
        },
      );
      return TaskModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('일정을 찾을 수 없습니다');
      }
      if (e.response?.statusCode == 403) {
        throw Exception('수정 권한이 없습니다');
      }
      throw Exception('일정 수정 실패: ${e.message}');
    }
  }

  /// Task 상태 변경
  Future<TaskModel> updateStatus(String id, TaskStatus status) async {
    try {
      final response = await _dio.patch(
        '/tasks/$id/status',
        data: {'status': _statusToString(status)},
      );
      return TaskModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('일정을 찾을 수 없습니다');
      }
      throw Exception('상태 변경 실패: ${e.message}');
    }
  }

  /// Task 완료/미완료 토글 (하위 호환성 유지)
  Future<TaskModel> toggleComplete(String id, bool isCompleted) async {
    return updateStatus(
      id,
      isCompleted ? TaskStatus.completed : TaskStatus.pending,
    );
  }

  /// Task 삭제
  /// [deleteScope]: 'current' (현재만), 'future' (이후 모두), 'all' (전체) - 반복 일정용
  Future<void> deleteTask(String id, {String? deleteScope}) async {
    try {
      await _dio.delete(
        '/tasks/$id',
        queryParameters: {
          if (deleteScope != null) 'deleteScope': deleteScope,
        },
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('일정을 찾을 수 없습니다');
      }
      if (e.response?.statusCode == 403) {
        throw Exception('삭제 권한이 없습니다');
      }
      throw Exception('일정 삭제 실패: ${e.message}');
    }
  }

  /// 카테고리 목록 조회
  Future<List<CategoryModel>> getCategories({String? groupId}) async {
    try {
      final response = await _dio.get('/tasks/categories', queryParameters: {
        if (groupId != null) 'groupId': groupId,
      });

      final data = response.data;
      if (data is List) {
        return data
            .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [TaskRepository] 카테고리 조회 실패: ${e.message}');
      throw Exception('카테고리 조회 실패: ${e.message}');
    }
  }

  /// 카테고리 생성
  Future<CategoryModel> createCategory({
    required String name,
    String? description,
    String? emoji,
    String? color,
    String? groupId,
  }) async {
    try {
      final response = await _dio.post('/tasks/categories', data: {
        'name': name,
        if (description != null) 'description': description,
        if (emoji != null) 'emoji': emoji,
        if (color != null) 'color': color,
        if (groupId != null) 'groupId': groupId,
      });
      return CategoryModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('카테고리 생성 실패: ${e.message}');
    }
  }

  /// 카테고리 수정
  Future<CategoryModel> updateCategory(
    String id, {
    String? name,
    String? description,
    String? emoji,
    String? color,
  }) async {
    try {
      final response = await _dio.put('/tasks/categories/$id', data: {
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (emoji != null) 'emoji': emoji,
        if (color != null) 'color': color,
      });
      return CategoryModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('카테고리를 찾을 수 없습니다');
      }
      if (e.response?.statusCode == 403) {
        throw Exception('수정 권한이 없습니다');
      }
      throw Exception('카테고리 수정 실패: ${e.message}');
    }
  }

  /// 카테고리 삭제
  Future<void> deleteCategory(String id) async {
    try {
      await _dio.delete('/tasks/categories/$id');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('카테고리를 찾을 수 없습니다');
      }
      if (e.response?.statusCode == 403) {
        throw Exception('연결된 일정이 있어 삭제할 수 없습니다');
      }
      throw Exception('카테고리 삭제 실패: ${e.message}');
    }
  }

  /// 반복 일정 일시정지/재개
  Future<RecurringModel> toggleRecurringPause(String recurringId) async {
    try {
      final response = await _dio.patch('/tasks/recurrings/$recurringId/pause');
      return RecurringModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('반복 규칙을 찾을 수 없습니다');
      }
      throw Exception('반복 일정 상태 변경 실패: ${e.message}');
    }
  }

  /// 반복 일정 건너뛰기
  Future<void> skipRecurring(
    String recurringId, {
    required String skipDate,
    String? reason,
  }) async {
    try {
      await _dio.post('/tasks/recurrings/$recurringId/skip', data: {
        'skipDate': skipDate,
        if (reason != null) 'reason': reason,
      });
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('반복 규칙을 찾을 수 없습니다');
      }
      throw Exception('반복 일정 건너뛰기 실패: ${e.message}');
    }
  }

  /// TaskType enum to string
  String _taskTypeToString(TaskType type) {
    switch (type) {
      case TaskType.calendarOnly:
        return 'CALENDAR_ONLY';
      case TaskType.todoLinked:
        return 'TODO_LINKED';
    }
  }

  /// TaskPriority enum to string
  String _priorityToString(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'LOW';
      case TaskPriority.medium:
        return 'MEDIUM';
      case TaskPriority.high:
        return 'HIGH';
      case TaskPriority.urgent:
        return 'URGENT';
    }
  }

  /// TaskStatus enum to string
  String _statusToString(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'PENDING';
      case TaskStatus.inProgress:
        return 'IN_PROGRESS';
      case TaskStatus.completed:
        return 'COMPLETED';
      case TaskStatus.hold:
        return 'HOLD';
      case TaskStatus.drop:
        return 'DROP';
      case TaskStatus.failed:
        return 'FAILED';
    }
  }
}
