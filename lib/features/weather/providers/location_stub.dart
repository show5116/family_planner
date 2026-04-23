import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import 'package:family_planner/features/weather/providers/weather_provider.dart';

const _defaultLatLon = LatLon(lat: 37.5665, lon: 126.9780); // 서울 기본값

Future<LatLon> getWebLocation() async {
  try {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('⚠️ [Weather] 위치 서비스 비활성화 — 서울 기본 좌표 사용');
      return _defaultLatLon;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('⚠️ [Weather] 위치 권한 거부 — 서울 기본 좌표 사용');
        return _defaultLatLon;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('⚠️ [Weather] 위치 권한 영구 거부 — 서울 기본 좌표 사용');
      return _defaultLatLon;
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low,
        timeLimit: Duration(seconds: 10),
      ),
    );

    debugPrint('✅ [Weather] 위치 획득: ${position.latitude}, ${position.longitude}');
    return LatLon(lat: position.latitude, lon: position.longitude);
  } catch (e) {
    debugPrint('⚠️ [Weather] 위치 조회 실패 — 서울 기본 좌표 사용: $e');
    return _defaultLatLon;
  }
}
