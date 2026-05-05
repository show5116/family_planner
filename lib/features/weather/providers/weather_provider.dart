import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/weather/models/weather_model.dart';
import 'package:family_planner/features/weather/providers/location_stub.dart'
    if (dart.library.js_interop) 'package:family_planner/features/weather/providers/location_web.dart';
import 'package:family_planner/features/weather/repositories/weather_repository.dart';

part 'weather_provider.g.dart';

/// GPS 좌표 모델
class LatLon {
  final double lat;
  final double lon;

  const LatLon({required this.lat, required this.lon});
}

/// 마지막 날씨 조회 시각 (앱 재개 시 만료 여부 판단에 사용)
DateTime? _lastWeatherFetch;

/// 위치 조회 (웹: Geolocation API, 모바일/데스크톱: GPS)
@riverpod
Future<LatLon> location(Ref ref) async {
  return getWebLocation();
}

/// 현재 날씨 Provider
@riverpod
Future<WeatherModel> weather(Ref ref) async {
  final link = ref.keepAlive();
  _lastWeatherFetch = DateTime.now();
  final timer = Timer(const Duration(minutes: 30), link.close);
  ref.onDispose(timer.cancel);

  final LatLon latLon = await ref.watch(locationProvider.future);
  final repository = ref.watch(weatherRepositoryProvider);
  return repository.getCurrentWeather(lat: latLon.lat, lon: latLon.lon);
}

/// 단기예보 Provider
@riverpod
Future<WeatherForecastModel> weatherForecast(Ref ref) async {
  final link = ref.keepAlive();
  final timer = Timer(const Duration(minutes: 30), link.close);
  ref.onDispose(timer.cancel);

  final LatLon latLon = await ref.watch(locationProvider.future);
  final repository = ref.watch(weatherRepositoryProvider);
  return repository.getForecast(lat: latLon.lat, lon: latLon.lon);
}

/// 날씨 캐시가 만료되었는지 확인 (30분 기준)
bool isWeatherCacheExpired() {
  if (_lastWeatherFetch == null) return true;
  return DateTime.now().difference(_lastWeatherFetch!) > const Duration(minutes: 30);
}
