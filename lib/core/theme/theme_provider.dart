import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 테마 모드를 관리하는 Provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

/// 테마 모드 상태 관리 Notifier
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadThemeMode();
  }

  static const String _key = 'theme_mode';

  /// 저장된 테마 모드 불러오기
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString(_key);

    if (themeModeString != null) {
      state = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == themeModeString,
        orElse: () => ThemeMode.system,
      );
    }
  }

  /// 테마 모드 변경 및 저장
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.toString());
  }

  /// Light 모드로 변경
  Future<void> setLightMode() async {
    await setThemeMode(ThemeMode.light);
  }

  /// Dark 모드로 변경
  Future<void> setDarkMode() async {
    await setThemeMode(ThemeMode.dark);
  }

  /// System 모드로 변경
  Future<void> setSystemMode() async {
    await setThemeMode(ThemeMode.system);
  }
}
