import 'package:shared_preferences/shared_preferences.dart';

/// 최근 사용한 이모지 목록을 SharedPreferences에 저장/조회하는 서비스 (LRU, 최대 24개)
class RecentEmojiStore {
  RecentEmojiStore._();

  static const String _key = 'recent_emojis';
  static const int _maxSize = 24;

  static Future<List<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? const [];
  }

  static Future<List<String>> add(String emoji) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_key) ?? <String>[];
    final updated = [emoji, ...current.where((e) => e != emoji)];
    final trimmed = updated.take(_maxSize).toList();
    await prefs.setStringList(_key, trimmed);
    return trimmed;
  }
}
