import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/main/assets/data/models/asset_statistics_model.dart';
import 'package:family_planner/features/main/assets/data/repositories/asset_repository.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/features/main/task/data/repositories/task_repository.dart';
import 'package:family_planner/features/memo/data/models/memo_model.dart';
import 'package:family_planner/features/memo/providers/memo_provider.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';

part 'dashboard_provider.g.dart';

/// 오늘의 일정 (대시보드 전용) - 그룹 상태와 무관하게 오늘 날짜 기준 조회
@riverpod
Future<List<TaskModel>> dashboardTodayTasks(Ref ref) async {
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

  final repository = ref.watch(taskRepositoryProvider);

  final response = await repository.getTasks(
    view: 'calendar',
    includePersonal: true,
    startDate: startOfDay,
    endDate: endOfDay,
    limit: 20,
  );

  return response.data
    ..sort((a, b) {
      if (a.isAllDay && !b.isAllDay) return 1;
      if (!a.isAllDay && b.isAllDay) return -1;
      if (a.scheduledAt == null) return 1;
      if (b.scheduledAt == null) return -1;
      return a.scheduledAt!.compareTo(b.scheduledAt!);
    });
}

/// 대시보드 할일 요약 (대시보드 전용) - 할일 탭 UI 상태와 완전히 독립
@riverpod
Future<List<TaskModel>> dashboardTodoTasks(Ref ref) async {
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

  final repository = ref.watch(taskRepositoryProvider);

  final response = await repository.getTasks(
    view: 'todo',
    type: TaskType.todoLinked,
    includePersonal: true,
    startDate: startOfDay,
    endDate: endOfDay,
    limit: 20,
  );

  return response.data;
}

/// 대시보드 자산 통계 (대시보드 전용) - 자산 탭 그룹 선택 상태와 독립
@riverpod
Future<AssetStatisticsModel> dashboardAssetStatistics(Ref ref) async {
  final groupsAsync = await ref.watch(myGroupsProvider.future);

  if (groupsAsync.isEmpty) return AssetStatisticsModel.empty();

  final firstGroupId = groupsAsync.first.id;
  final repository = ref.watch(assetRepositoryProvider);

  return repository.getAssetStatistics(groupId: firstGroupId);
}

/// 대시보드 메모 요약 - 핀된 메모 목록 위임
@riverpod
Future<List<MemoModel>> dashboardMemos(Ref ref) {
  return ref.watch(pinnedMemosProvider.future);
}
