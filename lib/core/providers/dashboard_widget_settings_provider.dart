import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:family_planner/core/models/dashboard_widget_settings.dart';

const _prefsKey = 'dashboard_widget_settings';

class DashboardWidgetSettingsNotifier extends Notifier<DashboardWidgetSettings> {
  @override
  DashboardWidgetSettings build() {
    _load();
    return DashboardWidgetSettings.defaultSettings();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_prefsKey);
    if (json != null) {
      state = DashboardWidgetSettings.fromJson(
        jsonDecode(json) as Map<String, dynamic>,
      );
    }
  }

  Future<void> update(DashboardWidgetSettings settings) async {
    state = settings;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(settings.toJson()));
  }
}

final dashboardWidgetSettingsProvider =
    NotifierProvider<DashboardWidgetSettingsNotifier, DashboardWidgetSettings>(
  DashboardWidgetSettingsNotifier.new,
);
