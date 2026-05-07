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

/// See also [holidays].
@ProviderFor(holidays)
const holidaysProvider = HolidaysFamily();

/// See also [holidays].
class HolidaysFamily extends Family<AsyncValue<List<HolidayModel>>> {
  /// See also [holidays].
  const HolidaysFamily();

  /// See also [holidays].
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

/// See also [holidays].
class HolidaysProvider extends AutoDisposeFutureProvider<List<HolidayModel>> {
  /// See also [holidays].
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

String _$specialDaysHash() => r'36803c1331f46b87f98201269a06d58de2fff484';

/// See also [specialDays].
@ProviderFor(specialDays)
const specialDaysProvider = SpecialDaysFamily();

/// See also [specialDays].
class SpecialDaysFamily extends Family<AsyncValue<List<SpecialDayModel>>> {
  /// See also [specialDays].
  const SpecialDaysFamily();

  /// See also [specialDays].
  SpecialDaysProvider call(int year, int month) {
    return SpecialDaysProvider(year, month);
  }

  @override
  SpecialDaysProvider getProviderOverride(
    covariant SpecialDaysProvider provider,
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
  String? get name => r'specialDaysProvider';
}

/// See also [specialDays].
class SpecialDaysProvider
    extends AutoDisposeFutureProvider<List<SpecialDayModel>> {
  /// See also [specialDays].
  SpecialDaysProvider(int year, int month)
    : this._internal(
        (ref) => specialDays(ref as SpecialDaysRef, year, month),
        from: specialDaysProvider,
        name: r'specialDaysProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$specialDaysHash,
        dependencies: SpecialDaysFamily._dependencies,
        allTransitiveDependencies: SpecialDaysFamily._allTransitiveDependencies,
        year: year,
        month: month,
      );

  SpecialDaysProvider._internal(
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
    FutureOr<List<SpecialDayModel>> Function(SpecialDaysRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SpecialDaysProvider._internal(
        (ref) => create(ref as SpecialDaysRef),
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
  AutoDisposeFutureProviderElement<List<SpecialDayModel>> createElement() {
    return _SpecialDaysProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SpecialDaysProvider &&
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
mixin SpecialDaysRef on AutoDisposeFutureProviderRef<List<SpecialDayModel>> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _SpecialDaysProviderElement
    extends AutoDisposeFutureProviderElement<List<SpecialDayModel>>
    with SpecialDaysRef {
  _SpecialDaysProviderElement(super.provider);

  @override
  int get year => (origin as SpecialDaysProvider).year;
  @override
  int get month => (origin as SpecialDaysProvider).month;
}

String _$holidayForDateHash() => r'0deb452af28ca622ebeee4e62c5deb8ff28b6403';

/// See also [holidayForDate].
@ProviderFor(holidayForDate)
const holidayForDateProvider = HolidayForDateFamily();

/// See also [holidayForDate].
class HolidayForDateFamily extends Family<AsyncValue<HolidayModel?>> {
  /// See also [holidayForDate].
  const HolidayForDateFamily();

  /// See also [holidayForDate].
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

/// See also [holidayForDate].
class HolidayForDateProvider
    extends AutoDisposeProvider<AsyncValue<HolidayModel?>> {
  /// See also [holidayForDate].
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

/// See also [holidayMapForMonth].
@ProviderFor(holidayMapForMonth)
const holidayMapForMonthProvider = HolidayMapForMonthFamily();

/// See also [holidayMapForMonth].
class HolidayMapForMonthFamily
    extends Family<AsyncValue<Map<String, HolidayModel>>> {
  /// See also [holidayMapForMonth].
  const HolidayMapForMonthFamily();

  /// See also [holidayMapForMonth].
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

/// See also [holidayMapForMonth].
class HolidayMapForMonthProvider
    extends AutoDisposeProvider<AsyncValue<Map<String, HolidayModel>>> {
  /// See also [holidayMapForMonth].
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

String _$specialDayMapForMonthHash() =>
    r'e5e4f60e91aeefe8aff8fae7505569530c34a69d';

/// See also [specialDayMapForMonth].
@ProviderFor(specialDayMapForMonth)
const specialDayMapForMonthProvider = SpecialDayMapForMonthFamily();

/// See also [specialDayMapForMonth].
class SpecialDayMapForMonthFamily
    extends Family<AsyncValue<Map<String, SpecialDayModel>>> {
  /// See also [specialDayMapForMonth].
  const SpecialDayMapForMonthFamily();

  /// See also [specialDayMapForMonth].
  SpecialDayMapForMonthProvider call(int year, int month) {
    return SpecialDayMapForMonthProvider(year, month);
  }

  @override
  SpecialDayMapForMonthProvider getProviderOverride(
    covariant SpecialDayMapForMonthProvider provider,
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
  String? get name => r'specialDayMapForMonthProvider';
}

/// See also [specialDayMapForMonth].
class SpecialDayMapForMonthProvider
    extends AutoDisposeProvider<AsyncValue<Map<String, SpecialDayModel>>> {
  /// See also [specialDayMapForMonth].
  SpecialDayMapForMonthProvider(int year, int month)
    : this._internal(
        (ref) =>
            specialDayMapForMonth(ref as SpecialDayMapForMonthRef, year, month),
        from: specialDayMapForMonthProvider,
        name: r'specialDayMapForMonthProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$specialDayMapForMonthHash,
        dependencies: SpecialDayMapForMonthFamily._dependencies,
        allTransitiveDependencies:
            SpecialDayMapForMonthFamily._allTransitiveDependencies,
        year: year,
        month: month,
      );

  SpecialDayMapForMonthProvider._internal(
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
    AsyncValue<Map<String, SpecialDayModel>> Function(
      SpecialDayMapForMonthRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SpecialDayMapForMonthProvider._internal(
        (ref) => create(ref as SpecialDayMapForMonthRef),
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
  AutoDisposeProviderElement<AsyncValue<Map<String, SpecialDayModel>>>
  createElement() {
    return _SpecialDayMapForMonthProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SpecialDayMapForMonthProvider &&
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
mixin SpecialDayMapForMonthRef
    on AutoDisposeProviderRef<AsyncValue<Map<String, SpecialDayModel>>> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _SpecialDayMapForMonthProviderElement
    extends AutoDisposeProviderElement<AsyncValue<Map<String, SpecialDayModel>>>
    with SpecialDayMapForMonthRef {
  _SpecialDayMapForMonthProviderElement(super.provider);

  @override
  int get year => (origin as SpecialDayMapForMonthProvider).year;
  @override
  int get month => (origin as SpecialDayMapForMonthProvider).month;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
