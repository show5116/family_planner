/// 현재 날씨 모델 (초단기실황)
class WeatherModel {
  final int temperature;
  final int humidity;
  final double windSpeed;
  final double precipitation;
  final int precipitationType;
  final String weatherDescription;
  final String baseDate;
  final String baseTime;

  const WeatherModel({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.precipitation,
    required this.precipitationType,
    required this.weatherDescription,
    required this.baseDate,
    required this.baseTime,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: (json['temperature'] as num).toInt(),
      humidity: (json['humidity'] as num).toInt(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      precipitation: (json['precipitation'] as num).toDouble(),
      precipitationType: (json['precipitationType'] as num).toInt(),
      weatherDescription: json['weatherDescription'] as String,
      baseDate: json['baseDate'] as String,
      baseTime: json['baseTime'] as String,
    );
  }
}

/// 시간별 예보 아이템 모델
class ForecastItemModel {
  final String fcstDate;
  final String fcstTime;
  final int temperature;
  final int? minTemperature;
  final int? maxTemperature;
  final int precipitationProbability;
  final double precipitation;
  final int humidity;
  final double windSpeed;
  final int sky;
  final int precipitationType;
  final String weatherDescription;

  const ForecastItemModel({
    required this.fcstDate,
    required this.fcstTime,
    required this.temperature,
    this.minTemperature,
    this.maxTemperature,
    required this.precipitationProbability,
    required this.precipitation,
    required this.humidity,
    required this.windSpeed,
    required this.sky,
    required this.precipitationType,
    required this.weatherDescription,
  });

  factory ForecastItemModel.fromJson(Map<String, dynamic> json) {
    return ForecastItemModel(
      fcstDate: json['fcstDate'] as String,
      fcstTime: json['fcstTime'] as String,
      temperature: (json['temperature'] as num).toInt(),
      minTemperature: json['minTemperature'] != null
          ? (json['minTemperature'] as num).toInt()
          : null,
      maxTemperature: json['maxTemperature'] != null
          ? (json['maxTemperature'] as num).toInt()
          : null,
      precipitationProbability:
          (json['precipitationProbability'] as num).toInt(),
      precipitation: (json['precipitation'] as num).toDouble(),
      humidity: (json['humidity'] as num).toInt(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      sky: (json['sky'] as num).toInt(),
      precipitationType: (json['precipitationType'] as num).toInt(),
      weatherDescription: json['weatherDescription'] as String,
    );
  }

  /// 날짜 + 시간으로 DateTime 변환 (표시용)
  DateTime get forecastDateTime {
    final year = int.parse(fcstDate.substring(0, 4));
    final month = int.parse(fcstDate.substring(4, 6));
    final day = int.parse(fcstDate.substring(6, 8));
    final hour = int.parse(fcstTime.substring(0, 2));
    final minute = int.parse(fcstTime.substring(2, 4));
    return DateTime(year, month, day, hour, minute);
  }
}

/// 단기예보 응답 모델
class WeatherForecastModel {
  final String baseDate;
  final String baseTime;
  final List<ForecastItemModel> forecasts;

  const WeatherForecastModel({
    required this.baseDate,
    required this.baseTime,
    required this.forecasts,
  });

  factory WeatherForecastModel.fromJson(Map<String, dynamic> json) {
    return WeatherForecastModel(
      baseDate: json['baseDate'] as String,
      baseTime: json['baseTime'] as String,
      forecasts: (json['forecasts'] as List<dynamic>)
          .map((e) => ForecastItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// 날짜별로 그룹핑된 예보 (날짜 문자열 → 해당 날 예보 목록)
  Map<String, List<ForecastItemModel>> get byDate {
    final map = <String, List<ForecastItemModel>>{};
    for (final item in forecasts) {
      map.putIfAbsent(item.fcstDate, () => []).add(item);
    }
    return map;
  }
}
