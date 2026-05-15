import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kDefaultGroupIdKey = 'default_group_id';

/// 대표 그룹 Provider — SharedPreferences에 저장되며 앱 재시작 후에도 유지
final defaultGroupProvider = StateNotifierProvider<DefaultGroupNotifier, String?>(
  (ref) => DefaultGroupNotifier(),
);

class DefaultGroupNotifier extends StateNotifier<String?> {
  DefaultGroupNotifier() : super(null) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(_kDefaultGroupIdKey);
  }

  Future<void> setDefaultGroup(String groupId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kDefaultGroupIdKey, groupId);
    state = groupId;
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kDefaultGroupIdKey);
    state = null;
  }
}
