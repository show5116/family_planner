import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:family_planner/core/theme/app_theme.dart';

/// 테마 설정 상태 (컬러 변형 + 밝기 모드)
class ThemeSettings {
  const ThemeSettings({
    this.variant = AppThemeVariant.blue,
    this.mode = ThemeMode.light,
  });

  final AppThemeVariant variant;
  final ThemeMode mode;

  ThemeSettings copyWith({AppThemeVariant? variant, ThemeMode? mode}) {
    return ThemeSettings(
      variant: variant ?? this.variant,
      mode: mode ?? this.mode,
    );
  }
}

final themeSettingsProvider =
    StateNotifierProvider<ThemeSettingsNotifier, ThemeSettings>(
  (ref) => ThemeSettingsNotifier(),
);

/// 하위 호환성 — 기존 코드가 themeModeProvider를 참조하는 경우
final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(themeSettingsProvider).mode;
});

class ThemeSettingsNotifier extends StateNotifier<ThemeSettings> {
  ThemeSettingsNotifier() : super(const ThemeSettings()) {
    _load();
  }

  static const _keyVariant = 'theme_variant';
  static const _keyMode = 'theme_mode';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();

    final variantId = prefs.getString(_keyVariant);
    final modeStr = prefs.getString(_keyMode);

    final variant = variantId != null
        ? AppThemeVariant.values.firstWhere(
            (v) => v.id == variantId,
            orElse: () => AppThemeVariant.blue,
          )
        : AppThemeVariant.blue;

    final mode = modeStr != null
        ? ThemeMode.values.firstWhere(
            (m) => m.toString() == modeStr,
            orElse: () => ThemeMode.system,
          )
        : ThemeMode.light;

    state = ThemeSettings(variant: variant, mode: mode);
  }

  Future<void> setVariant(AppThemeVariant variant) async {
    state = state.copyWith(variant: variant);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyVariant, variant.id);
  }

  Future<void> setMode(ThemeMode mode) async {
    state = state.copyWith(mode: mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyMode, mode.toString());
  }

  Future<void> setLightMode() async => setMode(ThemeMode.light);
  Future<void> setDarkMode() async => setMode(ThemeMode.dark);
  Future<void> setSystemMode() async => setMode(ThemeMode.system);
}
