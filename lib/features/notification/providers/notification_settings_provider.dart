import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:family_planner/features/notification/data/models/notification_settings_model.dart';
import 'package:family_planner/features/notification/data/repositories/notification_repository.dart';

part 'notification_settings_provider.g.dart';

/// 알림 설정 Provider
@riverpod
class NotificationSettings extends _$NotificationSettings {
  static const _storageKey = 'notification_settings';

  @override
  Future<NotificationSettingsModel> build() async {
    // 로컬에서 설정 불러오기
    final settings = await _loadFromLocal();
    if (settings != null) {
      return settings;
    }

    // 백엔드에서 설정 가져오기
    try {
      final repository = ref.read(notificationRepositoryProvider);
      final remoteSettings = await repository.getSettings();
      await _saveToLocal(remoteSettings);
      return remoteSettings;
    } catch (e) {
      debugPrint('알림 설정 불러오기 실패: $e');
      // 기본 설정 반환
      return const NotificationSettingsModel();
    }
  }

  /// 알림 설정 업데이트
  Future<void> updateSetting({
    bool? scheduleEnabled,
    bool? todoEnabled,
    bool? householdEnabled,
    bool? assetEnabled,
    bool? childcareEnabled,
    bool? groupEnabled,
    bool? savingsEnabled,
    bool? systemEnabled,
    bool? weatherEnabled,
    int? weatherAlertHour,
    bool? routineEnabled,
    int? routineReminderHour,
  }) async {
    final current = await future;
    final updated = current.copyWith(
      scheduleEnabled: scheduleEnabled ?? current.scheduleEnabled,
      todoEnabled: todoEnabled ?? current.todoEnabled,
      householdEnabled: householdEnabled ?? current.householdEnabled,
      assetEnabled: assetEnabled ?? current.assetEnabled,
      childcareEnabled: childcareEnabled ?? current.childcareEnabled,
      groupEnabled: groupEnabled ?? current.groupEnabled,
      savingsEnabled: savingsEnabled ?? current.savingsEnabled,
      systemEnabled: systemEnabled ?? current.systemEnabled,
      weatherEnabled: weatherEnabled ?? current.weatherEnabled,
      weatherAlertHour: weatherAlertHour ?? current.weatherAlertHour,
      routineEnabled: routineEnabled ?? current.routineEnabled,
      routineReminderHour: routineReminderHour ?? current.routineReminderHour,
    );

    // 로컬 저장
    await _saveToLocal(updated);

    // 백엔드 동기화 (변경된 필드만)
    try {
      final repository = ref.read(notificationRepositoryProvider);

      if (scheduleEnabled != null) {
        await repository.updateSetting(category: 'SCHEDULE', enabled: scheduleEnabled);
      }
      if (todoEnabled != null) {
        await repository.updateSetting(category: 'TODO', enabled: todoEnabled);
      }
      if (householdEnabled != null) {
        await repository.updateSetting(category: 'HOUSEHOLD', enabled: householdEnabled);
      }
      if (assetEnabled != null) {
        await repository.updateSetting(category: 'ASSET', enabled: assetEnabled);
      }
      if (childcareEnabled != null) {
        await repository.updateSetting(category: 'CHILDCARE', enabled: childcareEnabled);
      }
      if (groupEnabled != null) {
        await repository.updateSetting(category: 'GROUP', enabled: groupEnabled);
      }
      if (savingsEnabled != null) {
        await repository.updateSetting(category: 'SAVINGS', enabled: savingsEnabled);
      }
      if (systemEnabled != null) {
        await repository.updateSetting(category: 'SYSTEM', enabled: systemEnabled);
      }
      // weatherEnabled 또는 weatherAlertHour 변경 시 WEATHER 카테고리로 전송
      if (weatherEnabled != null || weatherAlertHour != null) {
        await repository.updateSetting(
          category: 'WEATHER',
          enabled: weatherEnabled ?? current.weatherEnabled,
          weatherAlertHour: weatherAlertHour,
        );
      }
      // routineEnabled 또는 routineReminderHour 변경 시 ROUTINE 카테고리로 전송
      if (routineEnabled != null || routineReminderHour != null) {
        await repository.updateSetting(
          category: 'ROUTINE',
          enabled: routineEnabled ?? current.routineEnabled,
          routineReminderHour: routineReminderHour,
        );
      }

    } catch (e) {
      debugPrint('알림 설정 백엔드 동기화 실패: $e');
    }

    state = AsyncValue.data(updated);
  }

  /// 로컬에서 설정 불러오기
  Future<NotificationSettingsModel?> _loadFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_storageKey);

      if (json != null) {
        return NotificationSettingsModel.fromJson(jsonDecode(json));
      }
    } catch (e) {
      debugPrint('로컬 알림 설정 불러오기 실패: $e');
    }
    return null;
  }

  /// 로컬에 설정 저장
  Future<void> _saveToLocal(NotificationSettingsModel settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, jsonEncode(settings.toJson()));
    } catch (e) {
      debugPrint('로컬 알림 설정 저장 실패: $e');
    }
  }
}
