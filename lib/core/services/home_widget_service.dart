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
  static const String _groupsKey = 'widget_groups';
  static const String _lastSyncedAtKey = 'last_synced_at';

  /// 오늘 일정 동기화
  ///
  /// 각 항목에 groupId를 포함시켜, 위젯이 인스턴스별 그룹 필터 설정에 따라
  /// 클라이언트(네이티브)에서 재필터링할 수 있도록 한다.
  static Future<void> syncTodayTasks({
    required List<TaskModel> tasks,
    required List<Group> groups,
    String? personalColorHex,
  }) async {
    await HomeWidget.setAppGroupId(appGroupId);

    final payload = tasks
        .take(30)
        .map((task) => _taskToWidgetJson(task, groups, personalColorHex))
        .toList();

    await HomeWidget.saveWidgetData<String>(_todayTasksKey, jsonEncode(payload));
    await _syncGroupList(groups);
    await HomeWidget.saveWidgetData<String>(
      _lastSyncedAtKey,
      DateTime.now().toIso8601String(),
    );

    await _updateWidgets();
  }

  /// 지난달/이번달/다음달 일정 동기화 (달력 dot 표시 + 위젯 내 월 이동/날짜 선택용)
  ///
  /// 위젯이 오프라인으로 이전/다음달 버튼 및 날짜 선택에 즉시 반응하도록,
  /// 이번달 기준 -1 ~ +1 범위의 월을 한 번에 저장한다. 각 entry에 일정 상세
  /// (id/title/시간/색상 등)까지 포함해, 위젯이 날짜를 탭했을 때 서버 호출 없이
  /// 그 날짜의 일정 목록을 바로 그릴 수 있도록 한다.
  static Future<void> syncMonthTasks({
    required Map<DateTime, List<TaskModel>> tasksByMonth,
    required List<Group> groups,
    String? personalColorHex,
  }) async {
    await HomeWidget.setAppGroupId(appGroupId);

    final months = tasksByMonth.entries.map((monthEntry) {
      final year = monthEntry.key.year;
      final month = monthEntry.key.month;
      final entries = <Map<String, dynamic>>[];

      for (final task in monthEntry.value) {
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

        final taskJson = _taskToWidgetJson(task, groups, personalColorHex);
        for (var d = start; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
          entries.add({'date': _dateKey(d), ...taskJson});
        }
      }

      return {'year': year, 'month': month, 'entries': entries};
    }).toList();

    final payload = {'months': months};

    await HomeWidget.saveWidgetData<String>(_monthTasksKey, jsonEncode(payload));
    await _syncGroupList(groups);
    await HomeWidget.saveWidgetData<String>(
      _lastSyncedAtKey,
      DateTime.now().toIso8601String(),
    );

    await _updateWidgets();
  }

  /// 위젯 Configuration 화면(그룹 선택)에서 사용할 그룹 목록 동기화
  static Future<void> _syncGroupList(List<Group> groups) async {
    final payload = groups
        .map((g) => {
              'id': g.id,
              'name': g.name,
              'colorHex': ColorUtils.colorToHex(ColorUtils.groupColor(g)),
            })
        .toList();
    await HomeWidget.saveWidgetData<String>(_groupsKey, jsonEncode(payload));
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

    // 위젯 내 월 이동(이전/다음달) 버튼이 오프라인으로 동작하도록 -1 ~ +1 범위를 함께 동기화
    final targetMonths = [-1, 0, 1]
        .map((offset) => DateTime(now.year, now.month + offset))
        .toList();

    final results = await Future.wait([
      repository.getTasks(
        view: 'calendar',
        includePersonal: true,
        groupIds: groupIds,
        startDate: todayStart,
        endDate: todayEnd,
        limit: 50,
      ),
      for (final target in targetMonths)
        repository.getCalendarTasks(
          year: target.year,
          month: target.month,
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

    final tasksByMonth = <DateTime, List<TaskModel>>{
      for (var i = 0; i < targetMonths.length; i++)
        targetMonths[i]: results[i + 1] as List<TaskModel>,
    };

    await syncTodayTasks(
      tasks: todayTasks,
      groups: groups,
      personalColorHex: personalColorHex,
    );
    await syncMonthTasks(
      tasksByMonth: tasksByMonth,
      groups: groups,
      personalColorHex: personalColorHex,
    );
  }

  /// 로그아웃 시 위젯 캐시 삭제
  static Future<void> clear() async {
    await HomeWidget.setAppGroupId(appGroupId);
    await HomeWidget.saveWidgetData<String>(_todayTasksKey, jsonEncode([]));
    await HomeWidget.saveWidgetData<String>(_monthTasksKey, jsonEncode({}));
    await HomeWidget.saveWidgetData<String>(_groupsKey, jsonEncode([]));
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
      'id': task.id,
      'title': task.title,
      'scheduledAt': task.scheduledAt?.toIso8601String(),
      'allDay': task.allDay,
      'colorHex': ColorUtils.colorToHex(color),
      'isCompleted': task.isCompleted,
      'groupId': task.groupId,
    };
  }
}
