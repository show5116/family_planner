// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$locationHash() => r'864b1de1fac83a013b71b30eff442a1f639d30d0';

/// 위치 조회 (웹: Geolocation API, 비웹: 서울 기본값)
///
/// Copied from [location].
@ProviderFor(location)
final locationProvider = AutoDisposeFutureProvider<LatLon>.internal(
  location,
  name: r'locationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$locationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LocationRef = AutoDisposeFutureProviderRef<LatLon>;
String _$weatherHash() => r'3e3ad170175a384241a88f59352a07adf1eebad0';

/// 현재 날씨 Provider
///
/// Copied from [weather].
@ProviderFor(weather)
final weatherProvider = AutoDisposeFutureProvider<WeatherModel>.internal(
  weather,
  name: r'weatherProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$weatherHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WeatherRef = AutoDisposeFutureProviderRef<WeatherModel>;
String _$weatherForecastHash() => r'1a7ba7f7732eae92d9a29c81adf843bd779961cf';

/// 단기예보 Provider
///
/// Copied from [weatherForecast].
@ProviderFor(weatherForecast)
final weatherForecastProvider =
    AutoDisposeFutureProvider<WeatherForecastModel>.internal(
      weatherForecast,
      name: r'weatherForecastProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$weatherForecastHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WeatherForecastRef = AutoDisposeFutureProviderRef<WeatherForecastModel>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
