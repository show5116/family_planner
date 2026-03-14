import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web/web.dart' as web;

import 'package:family_planner/features/weather/models/weather_model.dart';
import 'package:family_planner/features/weather/repositories/weather_repository.dart';

part 'weather_provider.g.dart';

/// GPS 좌표 모델
class LatLon {
  final double lat;
  final double lon;

  const LatLon({required this.lat, required this.lon});
}

/// 위치 조회 (웹: Geolocation API, 비웹: 서울 기본값)
@riverpod
Future<LatLon> location(Ref ref) async {
  if (kIsWeb) {
    return _getWebLocation();
  }
  return const LatLon(lat: 37.5665, lon: 126.9780);
}

Future<LatLon> _getWebLocation() async {
  final completer = Completer<LatLon>();

  web.window.navigator.geolocation.getCurrentPosition(
    (web.GeolocationPosition pos) {
      completer.complete(LatLon(
        lat: pos.coords.latitude,
        lon: pos.coords.longitude,
      ));
    }.toJS,
    (web.GeolocationPositionError err) {
      debugPrint('⚠️ [Weather] 위치 권한 거부 — 서울 기본 좌표 사용 (${err.message})');
      completer.complete(const LatLon(lat: 37.5665, lon: 126.9780));
    }.toJS,
  );

  return completer.future.timeout(
    const Duration(seconds: 10),
    onTimeout: () {
      debugPrint('⚠️ [Weather] 위치 조회 타임아웃 — 서울 기본 좌표 사용');
      return const LatLon(lat: 37.5665, lon: 126.9780);
    },
  );
}

/// 현재 날씨 Provider
@riverpod
Future<WeatherModel> weather(Ref ref) async {
  final LatLon latLon = await ref.watch(locationProvider.future);
  final repository = ref.watch(weatherRepositoryProvider);
  return repository.getCurrentWeather(lat: latLon.lat, lon: latLon.lon);
}

/// 단기예보 Provider
@riverpod
Future<WeatherForecastModel> weatherForecast(Ref ref) async {
  final LatLon latLon = await ref.watch(locationProvider.future);
  final repository = ref.watch(weatherRepositoryProvider);
  return repository.getForecast(lat: latLon.lat, lon: latLon.lon);
}
