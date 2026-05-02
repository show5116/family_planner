// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'holiday_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$holidaysHash() => r'60c9f3f2874be849fa1111ac35c0e1ea1a4d1d8b';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// 특정 연월의 공휴일 목록 Provider
/// 캐시 우선 조회, 만료 시 백그라운드 재검증
///
/// Copied from [holidays].
@ProviderFor(holidays)
const holidaysProvider = HolidaysFamily();

/// 특정 연월의 공휴일 목록 Provider
/// 캐시 우선 조회, 만료 시 백그라운드 재검증
///
/// Copied from [holidays].
class HolidaysFamily extends Family<AsyncValue<List<HolidayModel>>> {
  /// 특정 연월의 공휴일 목록 Provider
  /// 캐시 우선 조회, 만료 시 백그라운드 재검증
  ///
  /// Copied from [holidays].
  const HolidaysFamily();

  /// 특정 연월의 공휴일 목록 Provider
  /// 캐시 우선 조회, 만료 시 백그라운드 재검증
  ///
  /// Copied from [holidays].
  HolidaysProvider call(int year, int month) {
    return HolidaysProvider(year, month);
  }

  @override
  HolidaysProvider getProviderOverride(covariant HolidaysProvider provider) {
    return call(provider.year, provider.month);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'holidaysProvider';
}

/// 특정 연월의 공휴일 목록 Provider
/// 캐시 우선 조회, 만료 시 백그라운드 재검증
///
/// Copied from [holidays].
class HolidaysProvider extends AutoDisposeFutureProvider<List<HolidayModel>> {
  /// 특정 연월의 공휴일 목록 Provider
  /// 캐시 우선 조회, 만료 시 백그라운드 재검증
  ///
  /// Copied from [holidays].
  HolidaysProvider(int year, int month)
    : this._internal(
        (ref) => holidays(ref as HolidaysRef, year, month),
        from: holidaysProvider,
        name: r'holidaysProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$holidaysHash,
        dependencies: HolidaysFamily._dependencies,
        allTransitiveDependencies: HolidaysFamily._allTransitiveDependencies,
        year: year,
        month: month,
      );

  HolidaysProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
    required this.month,
  }) : super.internal();

  final int year;
  final int month;

  @override
  Override overrideWith(
    FutureOr<List<HolidayModel>> Function(HolidaysRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HolidaysProvider._internal(
        (ref) => create(ref as HolidaysRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        year: year,
        month: month,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<HolidayModel>> createElement() {
    return _HolidaysProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HolidaysProvider &&
        other.year == year &&
        other.month == month;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);
    hash = _SystemHash.combine(hash, month.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HolidaysRef on AutoDisposeFutureProviderRef<List<HolidayModel>> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _HolidaysProviderElement
    extends AutoDisposeFutureProviderElement<List<HolidayModel>>
    with HolidaysRef {
  _HolidaysProviderElement(super.provider);

  @override
  int get year => (origin as HolidaysProvider).year;
  @override
  int get month => (origin as HolidaysProvider).month;
}

String _$holidayForDateHash() => r'0deb452af28ca622ebeee4e62c5deb8ff28b6403';

/// 특정 날짜가 공휴일인지 확인하는 Provider
/// date 형식: 'YYYY-MM-DD'
///
/// Copied from [holidayForDate].
@ProviderFor(holidayForDate)
const holidayForDateProvider = HolidayForDateFamily();

/// 특정 날짜가 공휴일인지 확인하는 Provider
/// date 형식: 'YYYY-MM-DD'
///
/// Copied from [holidayForDate].
class HolidayForDateFamily extends Family<AsyncValue<HolidayModel?>> {
  /// 특정 날짜가 공휴일인지 확인하는 Provider
  /// date 형식: 'YYYY-MM-DD'
  ///
  /// Copied from [holidayForDate].
  const HolidayForDateFamily();

  /// 특정 날짜가 공휴일인지 확인하는 Provider
  /// date 형식: 'YYYY-MM-DD'
  ///
  /// Copied from [holidayForDate].
  HolidayForDateProvider call(DateTime date) {
    return HolidayForDateProvider(date);
  }

  @override
  HolidayForDateProvider getProviderOverride(
    covariant HolidayForDateProvider provider,
  ) {
    return call(provider.date);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'holidayForDateProvider';
}

/// 특정 날짜가 공휴일인지 확인하는 Provider
/// date 형식: 'YYYY-MM-DD'
///
/// Copied from [holidayForDate].
class HolidayForDateProvider
    extends AutoDisposeProvider<AsyncValue<HolidayModel?>> {
  /// 특정 날짜가 공휴일인지 확인하는 Provider
  /// date 형식: 'YYYY-MM-DD'
  ///
  /// Copied from [holidayForDate].
  HolidayForDateProvider(DateTime date)
    : this._internal(
        (ref) => holidayForDate(ref as HolidayForDateRef, date),
        from: holidayForDateProvider,
        name: r'holidayForDateProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$holidayForDateHash,
        dependencies: HolidayForDateFamily._dependencies,
        allTransitiveDependencies:
            HolidayForDateFamily._allTransitiveDependencies,
        date: date,
      );

  HolidayForDateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final DateTime date;

  @override
  Override overrideWith(
    AsyncValue<HolidayModel?> Function(HolidayForDateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HolidayForDateProvider._internal(
        (ref) => create(ref as HolidayForDateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<AsyncValue<HolidayModel?>> createElement() {
    return _HolidayForDateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HolidayForDateProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HolidayForDateRef on AutoDisposeProviderRef<AsyncValue<HolidayModel?>> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _HolidayForDateProviderElement
    extends AutoDisposeProviderElement<AsyncValue<HolidayModel?>>
    with HolidayForDateRef {
  _HolidayForDateProviderElement(super.provider);

  @override
  DateTime get date => (origin as HolidayForDateProvider).date;
}

String _$holidayMapForMonthHash() =>
    r'da3c86c96bb3fd8bf9b5cda8ec2039b58df92eca';

/// 특정 연월의 공휴일을 날짜 문자열 기준 Map으로 제공하는 Provider
/// 캘린더 렌더링 시 O(1) 조회용
///
/// Copied from [holidayMapForMonth].
@ProviderFor(holidayMapForMonth)
const holidayMapForMonthProvider = HolidayMapForMonthFamily();

/// 특정 연월의 공휴일을 날짜 문자열 기준 Map으로 제공하는 Provider
/// 캘린더 렌더링 시 O(1) 조회용
///
/// Copied from [holidayMapForMonth].
class HolidayMapForMonthFamily
    extends Family<AsyncValue<Map<String, HolidayModel>>> {
  /// 특정 연월의 공휴일을 날짜 문자열 기준 Map으로 제공하는 Provider
  /// 캘린더 렌더링 시 O(1) 조회용
  ///
  /// Copied from [holidayMapForMonth].
  const HolidayMapForMonthFamily();

  /// 특정 연월의 공휴일을 날짜 문자열 기준 Map으로 제공하는 Provider
  /// 캘린더 렌더링 시 O(1) 조회용
  ///
  /// Copied from [holidayMapForMonth].
  HolidayMapForMonthProvider call(int year, int month) {
    return HolidayMapForMonthProvider(year, month);
  }

  @override
  HolidayMapForMonthProvider getProviderOverride(
    covariant HolidayMapForMonthProvider provider,
  ) {
    return call(provider.year, provider.month);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'holidayMapForMonthProvider';
}

/// 특정 연월의 공휴일을 날짜 문자열 기준 Map으로 제공하는 Provider
/// 캘린더 렌더링 시 O(1) 조회용
///
/// Copied from [holidayMapForMonth].
class HolidayMapForMonthProvider
    extends AutoDisposeProvider<AsyncValue<Map<String, HolidayModel>>> {
  /// 특정 연월의 공휴일을 날짜 문자열 기준 Map으로 제공하는 Provider
  /// 캘린더 렌더링 시 O(1) 조회용
  ///
  /// Copied from [holidayMapForMonth].
  HolidayMapForMonthProvider(int year, int month)
    : this._internal(
        (ref) => holidayMapForMonth(ref as HolidayMapForMonthRef, year, month),
        from: holidayMapForMonthProvider,
        name: r'holidayMapForMonthProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$holidayMapForMonthHash,
        dependencies: HolidayMapForMonthFamily._dependencies,
        allTransitiveDependencies:
            HolidayMapForMonthFamily._allTransitiveDependencies,
        year: year,
        month: month,
      );

  HolidayMapForMonthProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
    required this.month,
  }) : super.internal();

  final int year;
  final int month;

  @override
  Override overrideWith(
    AsyncValue<Map<String, HolidayModel>> Function(
      HolidayMapForMonthRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HolidayMapForMonthProvider._internal(
        (ref) => create(ref as HolidayMapForMonthRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        year: year,
        month: month,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<AsyncValue<Map<String, HolidayModel>>>
  createElement() {
    return _HolidayMapForMonthProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HolidayMapForMonthProvider &&
        other.year == year &&
        other.month == month;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);
    hash = _SystemHash.combine(hash, month.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HolidayMapForMonthRef
    on AutoDisposeProviderRef<AsyncValue<Map<String, HolidayModel>>> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _HolidayMapForMonthProviderElement
    extends AutoDisposeProviderElement<AsyncValue<Map<String, HolidayModel>>>
    with HolidayMapForMonthRef {
  _HolidayMapForMonthProviderElement(super.provider);

  @override
  int get year => (origin as HolidayMapForMonthProvider).year;
  @override
  int get month => (origin as HolidayMapForMonthProvider).month;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
