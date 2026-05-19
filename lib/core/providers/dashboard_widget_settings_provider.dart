import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:family_planner/core/models/dashboard_widget_settings.dart';

const _prefsKey = 'dashboard_widget_settings';

class DashboardWidgetSettingsNotifier
    extends AsyncNotifier<DashboardWidgetSettings> {
  @override
  Future<DashboardWidgetSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_prefsKey);
    if (json != null) {
      return DashboardWidgetSettings.fromJson(
        jsonDecode(json) as Map<String, dynamic>,
      );
    }
    return DashboardWidgetSettings.defaultSettings();
  }

  Future<void> save(DashboardWidgetSettings settings) async {
    state = AsyncData(settings);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(settings.toJson()));
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
