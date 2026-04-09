import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

import 'package:family_planner/features/weather/providers/weather_provider.dart';

Future<LatLon> getWebLocation() async {
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
