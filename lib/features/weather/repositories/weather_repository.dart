import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/weather/models/weather_model.dart';

final weatherRepositoryProvider = Provider<WeatherRepository>(
  (ref) => WeatherRepository(),
);

class WeatherRepository {
  final Dio _dio = ApiClient.instance.dio;

  /// 현재 날씨 조회 (초단기실황)
  Future<WeatherModel> getCurrentWeather({
    required double lat,
    required double lon,
  }) async {
    try {
      final response = await _dio.get(
        '/weather',
        queryParameters: {'lat': lat, 'lon': lon},
      );
      return WeatherModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [WeatherRepository] 현재 날씨 조회 실패: ${e.message}');
      throw Exception('날씨 조회 실패: ${e.message}');
    }
  }

  /// 단기예보 조회 (3일 시간별)
  Future<WeatherForecastModel> getForecast({
    required double lat,
    required double lon,
  }) async {
    try {
      final response = await _dio.get(
        '/weather/forecast',
        queryParameters: {'lat': lat, 'lon': lon},
      );
      return WeatherForecastModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      debugPrint('❌ [WeatherRepository] 단기예보 조회 실패: ${e.message}');
      throw Exception('단기예보 조회 실패: ${e.message}');
    }
  }
}
