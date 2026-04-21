import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/core/models/dashboard_widget_settings.dart';
import 'package:family_planner/features/main/assets/data/models/asset_statistics_model.dart';
import 'package:family_planner/features/main/assets/data/repositories/asset_repository.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/features/main/task/data/repositories/task_repository.dart';
import 'package:family_planner/features/memo/data/models/memo_model.dart';
import 'package:family_planner/features/memo/providers/memo_provider.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';

part 'dashboard_provider.g.dart';

/// 홈 화면 탭 전환 요청 provider
///
/// null: 요청 없음, String: 이동할 탭 ID (예: 'calendar', 'todo')
final homeTabNavigationProvider = StateProvider<String?>((ref) => null);

/// 대시보드 일정 (대시보드 전용) - 모드/그룹 필터에 따라 조회
@riverpod
Future<List<TaskModel>> dashboardTodayTasks(
  Ref ref, {
  ScheduleViewMode mode = ScheduleViewMode.today,
  /// null = 전체 그룹, 빈 리스트 = 개인만, 값 있음 = 선택된 그룹만
  List<String>? selectedGroupIds,
  bool includePersonal = true,
}) async {
  final now = DateTime.now();
  late final DateTime startDate;
  late final DateTime endDate;

  switch (mode) {
    case ScheduleViewMode.today:
      startDate = DateTime(now.year, now.month, now.day);
      endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    case ScheduleViewMode.week:
      final weekday = now.weekday;
      startDate = DateTime(now.year, now.month, now.day - (weekday - 1));
      endDate = DateTime(now.year, now.month, now.day + (7 - weekday), 23, 59, 59);
    case ScheduleViewMode.month:
      startDate = DateTime(now.year, now.month, 1);
      endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
  }

  // 그룹 전부 해제 + 개인도 끔 → 결과 없음
  if (selectedGroupIds != null && selectedGroupIds.isEmpty && !includePersonal) {
    return [];
  }

  final allGroups = await ref.watch(myGroupsProvider.future);
  final repository = ref.watch(taskRepositoryProvider);

  // null = 전체 선택 → 내 모든 그룹 ID 전달
  // [] = 전부 해제 → groupIds 생략 (개인만 클라이언트 필터링)
  final groupIdsToSend = selectedGroupIds == null
      ? allGroups.map((g) => g.id).toList()
      : selectedGroupIds.isNotEmpty
          ? selectedGroupIds
          : null;

  final response = await repository.getTasks(
    view: 'calendar',
    includePersonal: includePersonal,
    groupIds: groupIdsToSend,
    startDate: startDate,
    endDate: endDate,
    limit: 50,
  );

  List<TaskModel> result = [...response.data];

  // 그룹 전부 해제된 경우 개인 일정만 클라이언트 필터링
  if (selectedGroupIds != null && selectedGroupIds.isEmpty) {
    result = result.where((t) => t.groupId == null).toList();
  }

  return result
    ..sort((a, b) {
      if (a.scheduledAt == null) return 1;
      if (b.scheduledAt == null) return -1;
      return a.scheduledAt!.compareTo(b.scheduledAt!);
    });
}

/// 대시보드 할일 요약 (대시보드 전용) - 모드/그룹 필터에 따라 조회
@riverpod
Future<List<TaskModel>> dashboardTodoTasks(
  Ref ref, {
  ScheduleViewMode mode = ScheduleViewMode.today,
  List<String>? selectedGroupIds,
  bool includePersonal = true,
}) async {
  final now = DateTime.now();
  late final DateTime startDate;
  late final DateTime endDate;

  switch (mode) {
    case ScheduleViewMode.today:
      startDate = DateTime(now.year, now.month, now.day);
      endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    case ScheduleViewMode.week:
      final weekday = now.weekday;
      startDate = DateTime(now.year, now.month, now.day - (weekday - 1));
      endDate = DateTime(now.year, now.month, now.day + (7 - weekday), 23, 59, 59);
    case ScheduleViewMode.month:
      startDate = DateTime(now.year, now.month, 1);
      endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
  }

  // 그룹 전부 해제 + 개인도 끔 → 결과 없음
  if (selectedGroupIds != null && selectedGroupIds.isEmpty && !includePersonal) {
    return [];
  }

  final allGroups = await ref.watch(myGroupsProvider.future);
  final repository = ref.watch(taskRepositoryProvider);

  final groupIdsToSend = selectedGroupIds == null
      ? allGroups.map((g) => g.id).toList()
      : selectedGroupIds.isNotEmpty
          ? selectedGroupIds
          : null;

  final response = await repository.getTasks(
    view: 'todo',
    type: TaskType.todoLinked,
    includePersonal: includePersonal,
    groupIds: groupIdsToSend,
    startDate: startDate,
    endDate: endDate,
    limit: 50,
  );

  // 그룹 전부 해제된 경우 개인 일정만 클라이언트 필터링
  if (selectedGroupIds != null && selectedGroupIds.isEmpty) {
    return response.data.where((t) => t.groupId == null).toList();
  }

  return [...response.data];
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
