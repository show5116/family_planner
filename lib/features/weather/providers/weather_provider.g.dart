// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$locationHash() => r'2f1634f4904ed26b40ab3b2f6726b7b12518434c';

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
String _$weatherHash() => r'168b0ced0916864f14478af383a4f0505bf1988d';

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
String _$weatherForecastHash() => r'3423985ed329a49c36c30e75a0350b297fab21bf';

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
