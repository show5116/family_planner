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
}

final dashboardWidgetSettingsProvider = AsyncNotifierProvider<
    DashboardWidgetSettingsNotifier, DashboardWidgetSettings>(
  DashboardWidgetSettingsNotifier.new,
);
