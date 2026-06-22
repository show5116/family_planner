import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:family_planner/core/models/dashboard_widget_settings.dart';
import 'package:family_planner/core/services/analytics_service.dart';

const _prefsKey = 'dashboard_widget_settings';

class DashboardWidgetSettingsNotifier
    extends AsyncNotifier<DashboardWidgetSettings> {
  @override
  Future<DashboardWidgetSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_prefsKey);
    final settings = json != null
        ? DashboardWidgetSettings.fromJson(jsonDecode(json) as Map<String, dynamic>)
        : DashboardWidgetSettings.defaultSettings();

    // 앱 실행 시 현재 위젯 구성 스냅샷 전송 → 유저들이 실제로 유지 중인 상태 파악
    // bool → int 변환: iOS Firebase Analytics는 bool 타입 파라미터를 지원하지 않음
    try {
      await AnalyticsService.instance.logEvent(
        'dashboard_widget_snapshot',
        parameters: {
          'order': settings.widgetOrder.join(','),
          'count': settings.widgetOrder.length,
        },
      );
    } catch (_) {}

    return settings;
  }

  Future<void> save(DashboardWidgetSettings settings) async {
    final previous = state.valueOrNull;
    state = AsyncData(settings);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(settings.toJson()));

    // 위젯 표시 여부 변경 추적
    if (previous != null) {
      _trackWidgetChanges(previous, settings);
    }
    // 위젯 순서 변경 추적
    await AnalyticsService.instance.logEvent(
      'dashboard_widget_order_changed',
      parameters: {'order': settings.widgetOrder.join(',')},
    );
  }

  void _trackWidgetChanges(
    DashboardWidgetSettings prev,
    DashboardWidgetSettings next,
  ) {
    final prevSet = prev.widgetOrder.toSet();
    final nextSet = next.widgetOrder.toSet();
    for (final added in nextSet.difference(prevSet)) {
      AnalyticsService.instance.logEvent(
        'dashboard_widget_toggled',
        parameters: {'widget': added, 'enabled': 1},
      ).catchError((_) {});
    }
    for (final removed in prevSet.difference(nextSet)) {
      AnalyticsService.instance.logEvent(
        'dashboard_widget_toggled',
        parameters: {'widget': removed, 'enabled': 0},
      ).catchError((_) {});
    }
  }

  /// 로그아웃/계정 전환 시 저장된 그룹 ID를 초기화 (위젯 표시 설정은 유지)
  Future<void> clearGroupIds() async {
    final current = state.valueOrNull;
    if (current == null) return;
    final cleared = current.copyWith(
      scheduleSelectedGroupIds: null,
      todoSelectedGroupIds: null,
      assetSelectedGroupId: null,
      memoSelectedGroupId: null,
      householdSelectedGroupId: null,
      childcareSelectedGroupId: null,
      savingsSelectedGroupId: null,
      fridgeExpirySelectedGroupId: null,
    );
    await save(cleared);
  }
}

final dashboardWidgetSettingsProvider = AsyncNotifierProvider<
    DashboardWidgetSettingsNotifier, DashboardWidgetSettings>(
  DashboardWidgetSettingsNotifier.new,
);
