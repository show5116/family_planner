// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedDateSchedulesHash() =>
    r'0798d7939ea7c1876ecb72b2acf8da08ad8d8654';

/// 선택된 날짜의 일정 Provider
///
/// Copied from [selectedDateSchedules].
@ProviderFor(selectedDateSchedules)
final selectedDateSchedulesProvider =
    AutoDisposeFutureProvider<List<ScheduleModel>>.internal(
      selectedDateSchedules,
      name: r'selectedDateSchedulesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedDateSchedulesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedDateSchedulesRef =
    AutoDisposeFutureProviderRef<List<ScheduleModel>>;
String _$scheduleCountByDateHash() =>
    r'1cf2aa1534bfc0f8869970e730489b303545fc25';

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

/// 특정 날짜의 일정 개수 Provider (캘린더 마커용)
///
/// Copied from [scheduleCountByDate].
@ProviderFor(scheduleCountByDate)
const scheduleCountByDateProvider = ScheduleCountByDateFamily();

/// 특정 날짜의 일정 개수 Provider (캘린더 마커용)
///
/// Copied from [scheduleCountByDate].
class ScheduleCountByDateFamily extends Family<Map<DateTime, int>> {
  /// 특정 날짜의 일정 개수 Provider (캘린더 마커용)
  ///
  /// Copied from [scheduleCountByDate].
  const ScheduleCountByDateFamily();

  /// 특정 날짜의 일정 개수 Provider (캘린더 마커용)
  ///
  /// Copied from [scheduleCountByDate].
  ScheduleCountByDateProvider call(int year, int month) {
    return ScheduleCountByDateProvider(year, month);
  }

  @override
  ScheduleCountByDateProvider getProviderOverride(
    covariant ScheduleCountByDateProvider provider,
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
  String? get name => r'scheduleCountByDateProvider';
}

/// 특정 날짜의 일정 개수 Provider (캘린더 마커용)
///
/// Copied from [scheduleCountByDate].
class ScheduleCountByDateProvider
    extends AutoDisposeProvider<Map<DateTime, int>> {
  /// 특정 날짜의 일정 개수 Provider (캘린더 마커용)
  ///
  /// Copied from [scheduleCountByDate].
  ScheduleCountByDateProvider(int year, int month)
    : this._internal(
        (ref) =>
            scheduleCountByDate(ref as ScheduleCountByDateRef, year, month),
        from: scheduleCountByDateProvider,
        name: r'scheduleCountByDateProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$scheduleCountByDateHash,
        dependencies: ScheduleCountByDateFamily._dependencies,
        allTransitiveDependencies:
            ScheduleCountByDateFamily._allTransitiveDependencies,
        year: year,
        month: month,
      );

  ScheduleCountByDateProvider._internal(
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
    Map<DateTime, int> Function(ScheduleCountByDateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ScheduleCountByDateProvider._internal(
        (ref) => create(ref as ScheduleCountByDateRef),
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
  AutoDisposeProviderElement<Map<DateTime, int>> createElement() {
    return _ScheduleCountByDateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ScheduleCountByDateProvider &&
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
mixin ScheduleCountByDateRef on AutoDisposeProviderRef<Map<DateTime, int>> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _ScheduleCountByDateProviderElement
    extends AutoDisposeProviderElement<Map<DateTime, int>>
    with ScheduleCountByDateRef {
  _ScheduleCountByDateProviderElement(super.provider);

  @override
  int get year => (origin as ScheduleCountByDateProvider).year;
  @override
  int get month => (origin as ScheduleCountByDateProvider).month;
}

String _$scheduleDetailHash() => r'f532bc1847391818a2a880123e1e92ed55722d50';

/// 일정 상세 Provider
///
/// Copied from [scheduleDetail].
@ProviderFor(scheduleDetail)
const scheduleDetailProvider = ScheduleDetailFamily();

/// 일정 상세 Provider
///
/// Copied from [scheduleDetail].
class ScheduleDetailFamily extends Family<AsyncValue<ScheduleModel>> {
  /// 일정 상세 Provider
  ///
  /// Copied from [scheduleDetail].
  const ScheduleDetailFamily();

  /// 일정 상세 Provider
  ///
  /// Copied from [scheduleDetail].
  ScheduleDetailProvider call(String id) {
    return ScheduleDetailProvider(id);
  }

  @override
  ScheduleDetailProvider getProviderOverride(
    covariant ScheduleDetailProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'scheduleDetailProvider';
}

/// 일정 상세 Provider
///
/// Copied from [scheduleDetail].
class ScheduleDetailProvider extends AutoDisposeFutureProvider<ScheduleModel> {
  /// 일정 상세 Provider
  ///
  /// Copied from [scheduleDetail].
  ScheduleDetailProvider(String id)
    : this._internal(
        (ref) => scheduleDetail(ref as ScheduleDetailRef, id),
        from: scheduleDetailProvider,
        name: r'scheduleDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$scheduleDetailHash,
        dependencies: ScheduleDetailFamily._dependencies,
        allTransitiveDependencies:
            ScheduleDetailFamily._allTransitiveDependencies,
        id: id,
      );

  ScheduleDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<ScheduleModel> Function(ScheduleDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ScheduleDetailProvider._internal(
        (ref) => create(ref as ScheduleDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ScheduleModel> createElement() {
    return _ScheduleDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ScheduleDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ScheduleDetailRef on AutoDisposeFutureProviderRef<ScheduleModel> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ScheduleDetailProviderElement
    extends AutoDisposeFutureProviderElement<ScheduleModel>
    with ScheduleDetailRef {
  _ScheduleDetailProviderElement(super.provider);

  @override
  String get id => (origin as ScheduleDetailProvider).id;
}

String _$monthlySchedulesHash() => r'2851bdeec7def03529266b4ddefdb3c770880f37';

abstract class _$MonthlySchedules
    extends BuildlessAutoDisposeAsyncNotifier<List<ScheduleModel>> {
  late final int year;
  late final int month;

  FutureOr<List<ScheduleModel>> build(int year, int month);
}

/// 월간 일정 Provider
///
/// Copied from [MonthlySchedules].
@ProviderFor(MonthlySchedules)
const monthlySchedulesProvider = MonthlySchedulesFamily();

/// 월간 일정 Provider
///
/// Copied from [MonthlySchedules].
class MonthlySchedulesFamily extends Family<AsyncValue<List<ScheduleModel>>> {
  /// 월간 일정 Provider
  ///
  /// Copied from [MonthlySchedules].
  const MonthlySchedulesFamily();

  /// 월간 일정 Provider
  ///
  /// Copied from [MonthlySchedules].
  MonthlySchedulesProvider call(int year, int month) {
    return MonthlySchedulesProvider(year, month);
  }

  @override
  MonthlySchedulesProvider getProviderOverride(
    covariant MonthlySchedulesProvider provider,
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
  String? get name => r'monthlySchedulesProvider';
}

/// 월간 일정 Provider
///
/// Copied from [MonthlySchedules].
class MonthlySchedulesProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          MonthlySchedules,
          List<ScheduleModel>
        > {
  /// 월간 일정 Provider
  ///
  /// Copied from [MonthlySchedules].
  MonthlySchedulesProvider(int year, int month)
    : this._internal(
        () => MonthlySchedules()
          ..year = year
          ..month = month,
        from: monthlySchedulesProvider,
        name: r'monthlySchedulesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$monthlySchedulesHash,
        dependencies: MonthlySchedulesFamily._dependencies,
        allTransitiveDependencies:
            MonthlySchedulesFamily._allTransitiveDependencies,
        year: year,
        month: month,
      );

  MonthlySchedulesProvider._internal(
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
  FutureOr<List<ScheduleModel>> runNotifierBuild(
    covariant MonthlySchedules notifier,
  ) {
    return notifier.build(year, month);
  }

  @override
  Override overrideWith(MonthlySchedules Function() create) {
    return ProviderOverride(
      origin: this,
      override: MonthlySchedulesProvider._internal(
        () => create()
          ..year = year
          ..month = month,
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
  AutoDisposeAsyncNotifierProviderElement<MonthlySchedules, List<ScheduleModel>>
  createElement() {
    return _MonthlySchedulesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlySchedulesProvider &&
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
mixin MonthlySchedulesRef
    on AutoDisposeAsyncNotifierProviderRef<List<ScheduleModel>> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _MonthlySchedulesProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          MonthlySchedules,
          List<ScheduleModel>
        >
    with MonthlySchedulesRef {
  _MonthlySchedulesProviderElement(super.provider);

  @override
  int get year => (origin as MonthlySchedulesProvider).year;
  @override
  int get month => (origin as MonthlySchedulesProvider).month;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
