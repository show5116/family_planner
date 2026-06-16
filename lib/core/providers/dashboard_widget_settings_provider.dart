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
    await AnalyticsService.instance.logEvent(
      'dashboard_widget_snapshot',
      parameters: {
        'weather': settings.showWeather,
        'todaySchedule': settings.showTodaySchedule,
        'todoSummary': settings.showTodoSummary,
        'assetSummary': settings.showAssetSummary,
        'memoSummary': settings.showMemoSummary,
        'householdSummary': settings.showHouseholdSummary,
        'investmentSummary': settings.showInvestmentSummary,
        'childcareSummary': settings.showChildcareSummary,
        'savingsSummary': settings.showSavingsSummary,
        'fridgeSummary': settings.showFridgeSummary,
        'order': settings.widgetOrder.join(','),
      },
    );

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
    final checks = {
      'weather': (prev.showWeather, next.showWeather),
      'todaySchedule': (prev.showTodaySchedule, next.showTodaySchedule),
      'todoSummary': (prev.showTodoSummary, next.showTodoSummary),
      'assetSummary': (prev.showAssetSummary, next.showAssetSummary),
      'memoSummary': (prev.showMemoSummary, next.showMemoSummary),
      'householdSummary': (prev.showHouseholdSummary, next.showHouseholdSummary),
      'investmentSummary': (prev.showInvestmentSummary, next.showInvestmentSummary),
      'childcareSummary': (prev.showChildcareSummary, next.showChildcareSummary),
      'savingsSummary': (prev.showSavingsSummary, next.showSavingsSummary),
      'fridgeSummary': (prev.showFridgeSummary, next.showFridgeSummary),
    };
    for (final entry in checks.entries) {
      final (prevVal, nextVal) = entry.value;
      if (prevVal != nextVal) {
        AnalyticsService.instance.logEvent(
          'dashboard_widget_toggled',
          parameters: {
            'widget': entry.key,
            'enabled': nextVal,
          },
        );
      }
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
