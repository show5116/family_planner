// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$routineHeatmapHash() => r'e61d607555e5eda8f74bc56437fefd3a113c2a8d';

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

/// See also [routineHeatmap].
@ProviderFor(routineHeatmap)
const routineHeatmapProvider = RoutineHeatmapFamily();

/// See also [routineHeatmap].
class RoutineHeatmapFamily extends Family<AsyncValue<RoutineHeatmap>> {
  /// See also [routineHeatmap].
  const RoutineHeatmapFamily();

  /// See also [routineHeatmap].
  RoutineHeatmapProvider call(
    String routineId, {
    required String fromDate,
    required String toDate,
  }) {
    return RoutineHeatmapProvider(
      routineId,
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  @override
  RoutineHeatmapProvider getProviderOverride(
    covariant RoutineHeatmapProvider provider,
  ) {
    return call(
      provider.routineId,
      fromDate: provider.fromDate,
      toDate: provider.toDate,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'routineHeatmapProvider';
}

/// See also [routineHeatmap].
class RoutineHeatmapProvider extends AutoDisposeFutureProvider<RoutineHeatmap> {
  /// See also [routineHeatmap].
  RoutineHeatmapProvider(
    String routineId, {
    required String fromDate,
    required String toDate,
  }) : this._internal(
         (ref) => routineHeatmap(
           ref as RoutineHeatmapRef,
           routineId,
           fromDate: fromDate,
           toDate: toDate,
         ),
         from: routineHeatmapProvider,
         name: r'routineHeatmapProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$routineHeatmapHash,
         dependencies: RoutineHeatmapFamily._dependencies,
         allTransitiveDependencies:
             RoutineHeatmapFamily._allTransitiveDependencies,
         routineId: routineId,
         fromDate: fromDate,
         toDate: toDate,
       );

  RoutineHeatmapProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.routineId,
    required this.fromDate,
    required this.toDate,
  }) : super.internal();

  final String routineId;
  final String fromDate;
  final String toDate;

  @override
  Override overrideWith(
    FutureOr<RoutineHeatmap> Function(RoutineHeatmapRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RoutineHeatmapProvider._internal(
        (ref) => create(ref as RoutineHeatmapRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        routineId: routineId,
        fromDate: fromDate,
        toDate: toDate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<RoutineHeatmap> createElement() {
    return _RoutineHeatmapProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RoutineHeatmapProvider &&
        other.routineId == routineId &&
        other.fromDate == fromDate &&
        other.toDate == toDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, routineId.hashCode);
    hash = _SystemHash.combine(hash, fromDate.hashCode);
    hash = _SystemHash.combine(hash, toDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RoutineHeatmapRef on AutoDisposeFutureProviderRef<RoutineHeatmap> {
  /// The parameter `routineId` of this provider.
  String get routineId;

  /// The parameter `fromDate` of this provider.
  String get fromDate;

  /// The parameter `toDate` of this provider.
  String get toDate;
}

class _RoutineHeatmapProviderElement
    extends AutoDisposeFutureProviderElement<RoutineHeatmap>
    with RoutineHeatmapRef {
  _RoutineHeatmapProviderElement(super.provider);

  @override
  String get routineId => (origin as RoutineHeatmapProvider).routineId;
  @override
  String get fromDate => (origin as RoutineHeatmapProvider).fromDate;
  @override
  String get toDate => (origin as RoutineHeatmapProvider).toDate;
}

String _$routineStreakHash() => r'2e60ece26a1d5d47d31bebabe200268d9ccd369b';

/// See also [routineStreak].
@ProviderFor(routineStreak)
const routineStreakProvider = RoutineStreakFamily();

/// See also [routineStreak].
class RoutineStreakFamily extends Family<AsyncValue<RoutineStreak>> {
  /// See also [routineStreak].
  const RoutineStreakFamily();

  /// See also [routineStreak].
  RoutineStreakProvider call(String routineId) {
    return RoutineStreakProvider(routineId);
  }

  @override
  RoutineStreakProvider getProviderOverride(
    covariant RoutineStreakProvider provider,
  ) {
    return call(provider.routineId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'routineStreakProvider';
}

/// See also [routineStreak].
class RoutineStreakProvider extends AutoDisposeFutureProvider<RoutineStreak> {
  /// See also [routineStreak].
  RoutineStreakProvider(String routineId)
    : this._internal(
        (ref) => routineStreak(ref as RoutineStreakRef, routineId),
        from: routineStreakProvider,
        name: r'routineStreakProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$routineStreakHash,
        dependencies: RoutineStreakFamily._dependencies,
        allTransitiveDependencies:
            RoutineStreakFamily._allTransitiveDependencies,
        routineId: routineId,
      );

  RoutineStreakProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.routineId,
  }) : super.internal();

  final String routineId;

  @override
  Override overrideWith(
    FutureOr<RoutineStreak> Function(RoutineStreakRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RoutineStreakProvider._internal(
        (ref) => create(ref as RoutineStreakRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        routineId: routineId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<RoutineStreak> createElement() {
    return _RoutineStreakProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RoutineStreakProvider && other.routineId == routineId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, routineId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RoutineStreakRef on AutoDisposeFutureProviderRef<RoutineStreak> {
  /// The parameter `routineId` of this provider.
  String get routineId;
}

class _RoutineStreakProviderElement
    extends AutoDisposeFutureProviderElement<RoutineStreak>
    with RoutineStreakRef {
  _RoutineStreakProviderElement(super.provider);

  @override
  String get routineId => (origin as RoutineStreakProvider).routineId;
}

String _$routineRateHash() => r'34801408fc80155bdaf4b536282b983f77478b0c';

/// See also [routineRate].
@ProviderFor(routineRate)
const routineRateProvider = RoutineRateFamily();

/// See also [routineRate].
class RoutineRateFamily extends Family<AsyncValue<RoutineRate>> {
  /// See also [routineRate].
  const RoutineRateFamily();

  /// See also [routineRate].
  RoutineRateProvider call(
    String routineId, {
    required RoutineRatePeriod period,
    String? fromDate,
    String? toDate,
  }) {
    return RoutineRateProvider(
      routineId,
      period: period,
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  @override
  RoutineRateProvider getProviderOverride(
    covariant RoutineRateProvider provider,
  ) {
    return call(
      provider.routineId,
      period: provider.period,
      fromDate: provider.fromDate,
      toDate: provider.toDate,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'routineRateProvider';
}

/// See also [routineRate].
class RoutineRateProvider extends AutoDisposeFutureProvider<RoutineRate> {
  /// See also [routineRate].
  RoutineRateProvider(
    String routineId, {
    required RoutineRatePeriod period,
    String? fromDate,
    String? toDate,
  }) : this._internal(
         (ref) => routineRate(
           ref as RoutineRateRef,
           routineId,
           period: period,
           fromDate: fromDate,
           toDate: toDate,
         ),
         from: routineRateProvider,
         name: r'routineRateProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$routineRateHash,
         dependencies: RoutineRateFamily._dependencies,
         allTransitiveDependencies:
             RoutineRateFamily._allTransitiveDependencies,
         routineId: routineId,
         period: period,
         fromDate: fromDate,
         toDate: toDate,
       );

  RoutineRateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.routineId,
    required this.period,
    required this.fromDate,
    required this.toDate,
  }) : super.internal();

  final String routineId;
  final RoutineRatePeriod period;
  final String? fromDate;
  final String? toDate;

  @override
  Override overrideWith(
    FutureOr<RoutineRate> Function(RoutineRateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RoutineRateProvider._internal(
        (ref) => create(ref as RoutineRateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        routineId: routineId,
        period: period,
        fromDate: fromDate,
        toDate: toDate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<RoutineRate> createElement() {
    return _RoutineRateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RoutineRateProvider &&
        other.routineId == routineId &&
        other.period == period &&
        other.fromDate == fromDate &&
        other.toDate == toDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, routineId.hashCode);
    hash = _SystemHash.combine(hash, period.hashCode);
    hash = _SystemHash.combine(hash, fromDate.hashCode);
    hash = _SystemHash.combine(hash, toDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RoutineRateRef on AutoDisposeFutureProviderRef<RoutineRate> {
  /// The parameter `routineId` of this provider.
  String get routineId;

  /// The parameter `period` of this provider.
  RoutineRatePeriod get period;

  /// The parameter `fromDate` of this provider.
  String? get fromDate;

  /// The parameter `toDate` of this provider.
  String? get toDate;
}

class _RoutineRateProviderElement
    extends AutoDisposeFutureProviderElement<RoutineRate>
    with RoutineRateRef {
  _RoutineRateProviderElement(super.provider);

  @override
  String get routineId => (origin as RoutineRateProvider).routineId;
  @override
  RoutineRatePeriod get period => (origin as RoutineRateProvider).period;
  @override
  String? get fromDate => (origin as RoutineRateProvider).fromDate;
  @override
  String? get toDate => (origin as RoutineRateProvider).toDate;
}

String _$routineGroupMembersHash() =>
    r'7a7ffcd9afb587de9cba73175a60d5a8f8509ad1';

/// 그룹원별 공유 루틴 현황
///
/// Copied from [routineGroupMembers].
@ProviderFor(routineGroupMembers)
const routineGroupMembersProvider = RoutineGroupMembersFamily();

/// 그룹원별 공유 루틴 현황
///
/// Copied from [routineGroupMembers].
class RoutineGroupMembersFamily
    extends Family<AsyncValue<List<RoutineGroupMemberRoutines>>> {
  /// 그룹원별 공유 루틴 현황
  ///
  /// Copied from [routineGroupMembers].
  const RoutineGroupMembersFamily();

  /// 그룹원별 공유 루틴 현황
  ///
  /// Copied from [routineGroupMembers].
  RoutineGroupMembersProvider call(String groupId) {
    return RoutineGroupMembersProvider(groupId);
  }

  @override
  RoutineGroupMembersProvider getProviderOverride(
    covariant RoutineGroupMembersProvider provider,
  ) {
    return call(provider.groupId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'routineGroupMembersProvider';
}

/// 그룹원별 공유 루틴 현황
///
/// Copied from [routineGroupMembers].
class RoutineGroupMembersProvider
    extends AutoDisposeFutureProvider<List<RoutineGroupMemberRoutines>> {
  /// 그룹원별 공유 루틴 현황
  ///
  /// Copied from [routineGroupMembers].
  RoutineGroupMembersProvider(String groupId)
    : this._internal(
        (ref) => routineGroupMembers(ref as RoutineGroupMembersRef, groupId),
        from: routineGroupMembersProvider,
        name: r'routineGroupMembersProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$routineGroupMembersHash,
        dependencies: RoutineGroupMembersFamily._dependencies,
        allTransitiveDependencies:
            RoutineGroupMembersFamily._allTransitiveDependencies,
        groupId: groupId,
      );

  RoutineGroupMembersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.groupId,
  }) : super.internal();

  final String groupId;

  @override
  Override overrideWith(
    FutureOr<List<RoutineGroupMemberRoutines>> Function(
      RoutineGroupMembersRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RoutineGroupMembersProvider._internal(
        (ref) => create(ref as RoutineGroupMembersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        groupId: groupId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<RoutineGroupMemberRoutines>>
  createElement() {
    return _RoutineGroupMembersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RoutineGroupMembersProvider && other.groupId == groupId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RoutineGroupMembersRef
    on AutoDisposeFutureProviderRef<List<RoutineGroupMemberRoutines>> {
  /// The parameter `groupId` of this provider.
  String get groupId;
}

class _RoutineGroupMembersProviderElement
    extends AutoDisposeFutureProviderElement<List<RoutineGroupMemberRoutines>>
    with RoutineGroupMembersRef {
  _RoutineGroupMembersProviderElement(super.provider);

  @override
  String get groupId => (origin as RoutineGroupMembersProvider).groupId;
}

String _$routineSummaryHash() => r'3e14d302fdb36e7b5f8b5568d6b8bf8107b23c27';

/// See also [routineSummary].
@ProviderFor(routineSummary)
final routineSummaryProvider =
    AutoDisposeFutureProvider<List<RoutineSummaryItem>>.internal(
      routineSummary,
      name: r'routineSummaryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$routineSummaryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RoutineSummaryRef =
    AutoDisposeFutureProviderRef<List<RoutineSummaryItem>>;
String _$routineListHash() => r'70ffc896fbc405a4e3a7b82d11db7d9de2d340ac';

/// 활성 루틴 목록 Provider
///
/// Copied from [RoutineList].
@ProviderFor(RoutineList)
final routineListProvider =
    AutoDisposeAsyncNotifierProvider<RoutineList, List<Routine>>.internal(
      RoutineList.new,
      name: r'routineListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$routineListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RoutineList = AutoDisposeAsyncNotifier<List<Routine>>;
String _$routineDetailHash() => r'bd961b012fbcf0cac77a1ce1769c4c4bc7fbf044';

abstract class _$RoutineDetail
    extends BuildlessAutoDisposeAsyncNotifier<Routine> {
  late final String routineId;

  FutureOr<Routine> build(String routineId);
}

/// See also [RoutineDetail].
@ProviderFor(RoutineDetail)
const routineDetailProvider = RoutineDetailFamily();

/// See also [RoutineDetail].
class RoutineDetailFamily extends Family<AsyncValue<Routine>> {
  /// See also [RoutineDetail].
  const RoutineDetailFamily();

  /// See also [RoutineDetail].
  RoutineDetailProvider call(String routineId) {
    return RoutineDetailProvider(routineId);
  }

  @override
  RoutineDetailProvider getProviderOverride(
    covariant RoutineDetailProvider provider,
  ) {
    return call(provider.routineId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'routineDetailProvider';
}

/// See also [RoutineDetail].
class RoutineDetailProvider
    extends AutoDisposeAsyncNotifierProviderImpl<RoutineDetail, Routine> {
  /// See also [RoutineDetail].
  RoutineDetailProvider(String routineId)
    : this._internal(
        () => RoutineDetail()..routineId = routineId,
        from: routineDetailProvider,
        name: r'routineDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$routineDetailHash,
        dependencies: RoutineDetailFamily._dependencies,
        allTransitiveDependencies:
            RoutineDetailFamily._allTransitiveDependencies,
        routineId: routineId,
      );

  RoutineDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.routineId,
  }) : super.internal();

  final String routineId;

  @override
  FutureOr<Routine> runNotifierBuild(covariant RoutineDetail notifier) {
    return notifier.build(routineId);
  }

  @override
  Override overrideWith(RoutineDetail Function() create) {
    return ProviderOverride(
      origin: this,
      override: RoutineDetailProvider._internal(
        () => create()..routineId = routineId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        routineId: routineId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<RoutineDetail, Routine>
  createElement() {
    return _RoutineDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RoutineDetailProvider && other.routineId == routineId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, routineId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RoutineDetailRef on AutoDisposeAsyncNotifierProviderRef<Routine> {
  /// The parameter `routineId` of this provider.
  String get routineId;
}

class _RoutineDetailProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<RoutineDetail, Routine>
    with RoutineDetailRef {
  _RoutineDetailProviderElement(super.provider);

  @override
  String get routineId => (origin as RoutineDetailProvider).routineId;
}

String _$routineSharesHash() => r'597a57d96df067d7a2618f25c6ae02f6bf06e6b9';

abstract class _$RoutineShares
    extends BuildlessAutoDisposeAsyncNotifier<List<RoutineShare>> {
  late final String routineId;

  FutureOr<List<RoutineShare>> build(String routineId);
}

/// See also [RoutineShares].
@ProviderFor(RoutineShares)
const routineSharesProvider = RoutineSharesFamily();

/// See also [RoutineShares].
class RoutineSharesFamily extends Family<AsyncValue<List<RoutineShare>>> {
  /// See also [RoutineShares].
  const RoutineSharesFamily();

  /// See also [RoutineShares].
  RoutineSharesProvider call(String routineId) {
    return RoutineSharesProvider(routineId);
  }

  @override
  RoutineSharesProvider getProviderOverride(
    covariant RoutineSharesProvider provider,
  ) {
    return call(provider.routineId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'routineSharesProvider';
}

/// See also [RoutineShares].
class RoutineSharesProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          RoutineShares,
          List<RoutineShare>
        > {
  /// See also [RoutineShares].
  RoutineSharesProvider(String routineId)
    : this._internal(
        () => RoutineShares()..routineId = routineId,
        from: routineSharesProvider,
        name: r'routineSharesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$routineSharesHash,
        dependencies: RoutineSharesFamily._dependencies,
        allTransitiveDependencies:
            RoutineSharesFamily._allTransitiveDependencies,
        routineId: routineId,
      );

  RoutineSharesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.routineId,
  }) : super.internal();

  final String routineId;

  @override
  FutureOr<List<RoutineShare>> runNotifierBuild(
    covariant RoutineShares notifier,
  ) {
    return notifier.build(routineId);
  }

  @override
  Override overrideWith(RoutineShares Function() create) {
    return ProviderOverride(
      origin: this,
      override: RoutineSharesProvider._internal(
        () => create()..routineId = routineId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        routineId: routineId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<RoutineShares, List<RoutineShare>>
  createElement() {
    return _RoutineSharesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RoutineSharesProvider && other.routineId == routineId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, routineId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RoutineSharesRef
    on AutoDisposeAsyncNotifierProviderRef<List<RoutineShare>> {
  /// The parameter `routineId` of this provider.
  String get routineId;
}

class _RoutineSharesProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          RoutineShares,
          List<RoutineShare>
        >
    with RoutineSharesRef {
  _RoutineSharesProviderElement(super.provider);

  @override
  String get routineId => (origin as RoutineSharesProvider).routineId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
