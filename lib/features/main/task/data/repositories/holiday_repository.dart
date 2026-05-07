import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/main/task/data/models/holiday_model.dart';

final holidayRepositoryProvider = Provider<HolidayRepository>((ref) {
  return HolidayRepository();
});

class HolidayRepository {
  final Dio _dio = ApiClient.instance.dio;

  // 대체공휴일 포함 달: TTL 7일, 일반 달: TTL 30일
  static const int _normalTtlDays = 30;
  static const int _substituteTtlDays = 7;

  String _cacheKey(int year, int month) => 'holidays_cache_${year}_$month';
  String _cachedAtKey(int year, int month) => 'holidays_cached_at_${year}_$month';

  /// 공휴일 조회 (캐시 우선, 만료 시 재검증)
  Future<List<HolidayModel>> getHolidays(int year, int month) async {
    final prefs = await SharedPreferences.getInstance();
    final cached = _loadFromCache(prefs, year, month);

    if (cached != null) {
      final isExpired = _isCacheExpired(prefs, year, month, cached);
      if (!isExpired) return cached.holidays;

      // 만료된 경우 백그라운드 갱신 후 우선 캐시 반환
      _fetchAndCache(year, month, prefs);
      return cached.holidays;
    }

    return _fetchAndCache(year, month, prefs);
  }

  /// 특별한 날 조회 (캐시 우선, 만료 시 재검증)
  Future<List<SpecialDayModel>> getSpecialDays(int year, int month) async {
    final prefs = await SharedPreferences.getInstance();
    final cached = _loadFromCache(prefs, year, month);

    if (cached != null) {
      final isExpired = _isCacheExpired(prefs, year, month, cached);
      if (!isExpired) return cached.specialDays;

      _fetchAndCache(year, month, prefs);
      return cached.specialDays;
    }

    await _fetchAndCache(year, month, prefs);
    final updated = _loadFromCache(prefs, year, month);
    return updated?.specialDays ?? [];
  }

  /// 캐시 강제 무효화 (특정 월)
  Future<void> invalidateCache(int year, int month) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey(year, month));
    await prefs.remove(_cachedAtKey(year, month));
  }

  HolidayResponse? _loadFromCache(SharedPreferences prefs, int year, int month) {
    final json = prefs.getString(_cacheKey(year, month));
    if (json == null) return null;
    try {
      return HolidayResponse.fromJson(jsonDecode(json) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  bool _isCacheExpired(
    SharedPreferences prefs,
    int year,
    int month,
    HolidayResponse cached,
  ) {
    final cachedAtMs = prefs.getInt(_cachedAtKey(year, month));
    if (cachedAtMs == null) return true;

    final cachedAt = DateTime.fromMillisecondsSinceEpoch(cachedAtMs);
    final hasSubstitute = cached.holidays.any((h) => h.isSubstitute);
    final ttl = hasSubstitute ? _substituteTtlDays : _normalTtlDays;

    return DateTime.now().difference(cachedAt).inDays >= ttl;
  }

  Future<List<HolidayModel>> _fetchAndCache(
    int year,
    int month,
    SharedPreferences prefs,
  ) async {
    final response = await _dio.get(
      '/tasks/holidays',
      queryParameters: {'year': year, 'month': month},
    );
    final holidayResponse = HolidayResponse.fromJson(
      response.data as Map<String, dynamic>,
    );

    await prefs.setString(_cacheKey(year, month), holidayResponse.toJsonString());
    await prefs.setInt(
      _cachedAtKey(year, month),
      DateTime.now().millisecondsSinceEpoch,
    );

    return holidayResponse.holidays;
  }
}
