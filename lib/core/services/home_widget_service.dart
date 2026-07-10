import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

import 'package:family_planner/core/utils/color_utils.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/features/main/task/data/repositories/task_repository.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';

/// 홈 화면(OS) 위젯 데이터 동기화 서비스
///
/// Android(Glance)/iOS(WidgetKit) 위젯이 읽을 수 있도록
/// 일정 데이터를 App Group(iOS) / SharedPreferences(Android) 공유 저장소에 기록한다.
class HomeWidgetService {
  static const String appGroupId = 'group.com.hmncorp.familyplanner';
  static const String androidProviderName = 'ScheduleListWidgetReceiver';
  static const String androidCalendarProviderName = 'MonthCalendarWidgetReceiver';
  static const String iosKind = 'ScheduleWidget';

  static const String _todayTasksKey = 'today_tasks';
  static const String _monthTasksKey = 'month_tasks';
  static const String _lastSyncedAtKey = 'last_synced_at';

  /// 오늘 일정 동기화
  static Future<void> syncTodayTasks({
    required List<TaskModel> tasks,
    required List<Group> groups,
    String? personalColorHex,
  }) async {
    await HomeWidget.setAppGroupId(appGroupId);

    final payload = tasks
        .take(10)
        .map((task) => _taskToWidgetJson(task, groups, personalColorHex))
        .toList();

    await HomeWidget.saveWidgetData<String>(_todayTasksKey, jsonEncode(payload));
    await HomeWidget.saveWidgetData<String>(
      _lastSyncedAtKey,
      DateTime.now().toIso8601String(),
    );

    await _updateWidgets();
  }

  /// 이번달 일정 동기화 (달력 dot 표시 + 오늘 일정 리스트용)
  static Future<void> syncMonthTasks({
    required int year,
    required int month,
    required List<TaskModel> tasks,
    required List<Group> groups,
    String? personalColorHex,
  }) async {
    await HomeWidget.setAppGroupId(appGroupId);

    final markedDates = <String>{};
    for (final task in tasks) {
      if (task.type == TaskType.todoOnly) continue;
      if (task.scheduledAt == null) continue;

      final start = DateTime(
        task.scheduledAt!.year,
        task.scheduledAt!.month,
        task.scheduledAt!.day,
      );
      final end = task.dueAt != null
          ? DateTime(task.dueAt!.year, task.dueAt!.month, task.dueAt!.day)
          : start;

      for (var d = start; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
        markedDates.add(_dateKey(d));
      }
    }

    final payload = {
      'year': year,
      'month': month,
      'markedDates': markedDates.toList()..sort(),
    };

    await HomeWidget.saveWidgetData<String>(_monthTasksKey, jsonEncode(payload));
    await HomeWidget.saveWidgetData<String>(
      _lastSyncedAtKey,
      DateTime.now().toIso8601String(),
    );

    await _updateWidgets();
  }

  /// 서버에서 오늘 일정 + 이번달 일정을 다시 조회해 위젯 데이터를 동기화한다.
  ///
  /// Task 생성/수정/삭제가 성공한 직후, 그리고 대시보드 진입 시 호출한다.
  /// Riverpod provider의 캐시/watch 타이밍에 기대지 않고 항상 서버 최신 데이터로 갱신한다.
  static Future<void> syncFromServer(Ref ref) async {
    if (ref.read(authProvider).isAuthenticated != true) return;

    final groups = await ref.read(myGroupsProvider.future);
    final repository = ref.read(taskRepositoryProvider);
    final personalColorHex =
        ref.read(authProvider).user?['personalColor'] as String?;
    final now = DateTime.now();

    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final groupIds = groups.map((g) => g.id).toList();

    final results = await Future.wait([
      repository.getTasks(
        view: 'calendar',
        includePersonal: true,
        groupIds: groupIds,
        startDate: todayStart,
        endDate: todayEnd,
        limit: 50,
      ),
      repository.getCalendarTasks(
        year: now.year,
        month: now.month,
        groupIds: groupIds,
        includePersonal: true,
      ),
    ]);

    final todayTasks = (results[0] as TaskListResponse).data
      ..sort((a, b) {
        if (a.scheduledAt == null) return 1;
        if (b.scheduledAt == null) return -1;
        return a.scheduledAt!.compareTo(b.scheduledAt!);
      });
    final monthTasks = results[1] as List<TaskModel>;

    await syncTodayTasks(
      tasks: todayTasks,
      groups: groups,
      personalColorHex: personalColorHex,
    );
    await syncMonthTasks(
      year: now.year,
      month: now.month,
      tasks: monthTasks,
      groups: groups,
      personalColorHex: personalColorHex,
    );
  }

  /// 로그아웃 시 위젯 캐시 삭제
  static Future<void> clear() async {
    await HomeWidget.setAppGroupId(appGroupId);
    await HomeWidget.saveWidgetData<String>(_todayTasksKey, jsonEncode([]));
    await HomeWidget.saveWidgetData<String>(_monthTasksKey, jsonEncode({}));
    await HomeWidget.saveWidgetData<String>(_lastSyncedAtKey, '');
    await _updateWidgets();
  }

  static Future<void> _updateWidgets() async {
    await HomeWidget.updateWidget(
      androidName: androidProviderName,
      qualifiedAndroidName:
          'com.hmncorp.familyplanner.widget.$androidProviderName',
      iOSName: iosKind,
    );
    await HomeWidget.updateWidget(
      androidName: androidCalendarProviderName,
      qualifiedAndroidName:
          'com.hmncorp.familyplanner.widget.$androidCalendarProviderName',
      iOSName: iosKind,
    );
  }

  static String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  static Map<String, dynamic> _taskToWidgetJson(
    TaskModel task,
    List<Group> groups,
    String? personalColorHex,
  ) {
    final color = ColorUtils.taskColor(
      groupId: task.groupId,
      groups: groups,
      personalColorHex: personalColorHex,
    );

    return {
      'title': task.title,
      'scheduledAt': task.scheduledAt?.toIso8601String(),
      'allDay': task.allDay,
      'colorHex': ColorUtils.colorToHex(color),
      'isCompleted': task.isCompleted,
    };
  }
}
