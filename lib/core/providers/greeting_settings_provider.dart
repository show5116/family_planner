import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:family_planner/core/models/greeting_settings.dart';

const _prefsKey = 'greeting_settings';

/// 대시보드 인사말 설정 (기기 로컬 저장)
class GreetingSettingsNotifier extends AsyncNotifier<GreetingSettings> {
  @override
  Future<GreetingSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_prefsKey);
    if (json == null) return const GreetingSettings();
    return GreetingSettings.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<void> save(GreetingSettings settings) async {
    state = AsyncData(settings);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(settings.toJson()));
  }

  /// 내 인사말 사용 여부 토글
  Future<void> setEnabled(bool enabled) async {
    final current = state.valueOrNull;
    if (current == null) return;
    await save(current.copyWith(enabled: enabled));
  }

  /// 기본 제공 팩 on/off
  Future<void> setPackEnabled(String packId, bool enabled) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final packs = [...current.enabledPacks];
    if (enabled) {
      if (!packs.contains(packId)) packs.add(packId);
    } else {
      packs.remove(packId);
    }
    await save(current.copyWith(enabledPacks: packs));
  }

  /// 사용자 문구 추가 (성공 시 true, 개수 초과/중복이면 false)
  Future<bool> addMessage(String message) async {
    final current = state.valueOrNull;
    if (current == null) return false;
    final trimmed = message.trim();
    if (trimmed.isEmpty) return false;
    if (current.customMessages.length >= GreetingSettings.maxCustomMessages) {
      return false;
    }
    if (current.customMessages.contains(trimmed)) return false;
    await save(
      current.copyWith(customMessages: [...current.customMessages, trimmed]),
    );
    return true;
  }

  /// 사용자 문구 수정
  Future<void> updateMessage(int index, String message) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final trimmed = message.trim();
    if (trimmed.isEmpty) return;
    if (index < 0 || index >= current.customMessages.length) return;
    final messages = [...current.customMessages];
    messages[index] = trimmed;
    await save(current.copyWith(customMessages: messages));
  }

  /// 사용자 문구 삭제
  Future<void> removeMessage(int index) async {
    final current = state.valueOrNull;
    if (current == null) return;
    if (index < 0 || index >= current.customMessages.length) return;
    final messages = [...current.customMessages]..removeAt(index);
    await save(current.copyWith(customMessages: messages));
  }
}

final greetingSettingsProvider =
    AsyncNotifierProvider<GreetingSettingsNotifier, GreetingSettings>(
  GreetingSettingsNotifier.new,
);

/// 오늘의 문구를 수동으로 넘길 때 쓰는 회전 오프셋
///
/// 기본은 날짜 기준 하루 1개 고정이고, 대시보드를 당겨서 새로고침하면 +1 되어
/// 다음 문구로 넘어간다. 앱을 재시작하면 다시 오늘의 문구로 돌아온다.
final greetingRotationProvider = NotifierProvider<GreetingRotationNotifier, int>(
  GreetingRotationNotifier.new,
);

class GreetingRotationNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void next() => state = state + 1;
}
