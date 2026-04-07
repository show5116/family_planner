// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$assetStatisticsHash() => r'6c05ac4e76c4d992b1eed5c55f47e8e815e442af';

/// 자산 통계 Provider
///
/// Copied from [assetStatistics].
@ProviderFor(assetStatistics)
final assetStatisticsProvider =
    AutoDisposeFutureProvider<AssetStatisticsModel>.internal(
      assetStatistics,
      name: r'assetStatisticsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$assetStatisticsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AssetStatisticsRef = AutoDisposeFutureProviderRef<AssetStatisticsModel>;
String _$groupAssetTrendHash() => r'962d356a2f73fd298da4e561e76562260bf662cd';

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

/// 그룹 자산 추이 Provider
///
/// Copied from [groupAssetTrend].
@ProviderFor(groupAssetTrend)
const groupAssetTrendProvider = GroupAssetTrendFamily();

/// 그룹 자산 추이 Provider
///
/// Copied from [groupAssetTrend].
class GroupAssetTrendFamily extends Family<AsyncValue<List<AssetTrendPoint>>> {
  /// 그룹 자산 추이 Provider
  ///
  /// Copied from [groupAssetTrend].
  const GroupAssetTrendFamily();

  /// 그룹 자산 추이 Provider
  ///
  /// Copied from [groupAssetTrend].
  GroupAssetTrendProvider call({required TrendPeriod period, String? year}) {
    return GroupAssetTrendProvider(period: period, year: year);
  }

  @override
  GroupAssetTrendProvider getProviderOverride(
    covariant GroupAssetTrendProvider provider,
  ) {
    return call(period: provider.period, year: provider.year);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'groupAssetTrendProvider';
}

/// 그룹 자산 추이 Provider
///
/// Copied from [groupAssetTrend].
class GroupAssetTrendProvider
    extends AutoDisposeFutureProvider<List<AssetTrendPoint>> {
  /// 그룹 자산 추이 Provider
  ///
  /// Copied from [groupAssetTrend].
  GroupAssetTrendProvider({required TrendPeriod period, String? year})
    : this._internal(
        (ref) => groupAssetTrend(
          ref as GroupAssetTrendRef,
          period: period,
          year: year,
        ),
        from: groupAssetTrendProvider,
        name: r'groupAssetTrendProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$groupAssetTrendHash,
        dependencies: GroupAssetTrendFamily._dependencies,
        allTransitiveDependencies:
            GroupAssetTrendFamily._allTransitiveDependencies,
        period: period,
        year: year,
      );

  GroupAssetTrendProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.period,
    required this.year,
  }) : super.internal();

  final TrendPeriod period;
  final String? year;

  @override
  Override overrideWith(
    FutureOr<List<AssetTrendPoint>> Function(GroupAssetTrendRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GroupAssetTrendProvider._internal(
        (ref) => create(ref as GroupAssetTrendRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        period: period,
        year: year,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<AssetTrendPoint>> createElement() {
    return _GroupAssetTrendProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupAssetTrendProvider &&
        other.period == period &&
        other.year == year;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, period.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GroupAssetTrendRef
    on AutoDisposeFutureProviderRef<List<AssetTrendPoint>> {
  /// The parameter `period` of this provider.
  TrendPeriod get period;

  /// The parameter `year` of this provider.
  String? get year;
}

class _GroupAssetTrendProviderElement
    extends AutoDisposeFutureProviderElement<List<AssetTrendPoint>>
    with GroupAssetTrendRef {
  _GroupAssetTrendProviderElement(super.provider);

  @override
  TrendPeriod get period => (origin as GroupAssetTrendProvider).period;
  @override
  String? get year => (origin as GroupAssetTrendProvider).year;
}

String _$accountAssetTrendHash() => r'ad67eae8c4bf5426dc9418cec9defa9d6b695daa';

/// 계좌별 자산 추이 Provider
///
/// Copied from [accountAssetTrend].
@ProviderFor(accountAssetTrend)
const accountAssetTrendProvider = AccountAssetTrendFamily();

/// 계좌별 자산 추이 Provider
///
/// Copied from [accountAssetTrend].
class AccountAssetTrendFamily
    extends Family<AsyncValue<List<AssetTrendPoint>>> {
  /// 계좌별 자산 추이 Provider
  ///
  /// Copied from [accountAssetTrend].
  const AccountAssetTrendFamily();

  /// 계좌별 자산 추이 Provider
  ///
  /// Copied from [accountAssetTrend].
  AccountAssetTrendProvider call(
    String accountId, {
    required TrendPeriod period,
    String? year,
  }) {
    return AccountAssetTrendProvider(accountId, period: period, year: year);
  }

  @override
  AccountAssetTrendProvider getProviderOverride(
    covariant AccountAssetTrendProvider provider,
  ) {
    return call(
      provider.accountId,
      period: provider.period,
      year: provider.year,
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
  String? get name => r'accountAssetTrendProvider';
}

/// 계좌별 자산 추이 Provider
///
/// Copied from [accountAssetTrend].
class AccountAssetTrendProvider
    extends AutoDisposeFutureProvider<List<AssetTrendPoint>> {
  /// 계좌별 자산 추이 Provider
  ///
  /// Copied from [accountAssetTrend].
  AccountAssetTrendProvider(
    String accountId, {
    required TrendPeriod period,
    String? year,
  }) : this._internal(
         (ref) => accountAssetTrend(
           ref as AccountAssetTrendRef,
           accountId,
           period: period,
           year: year,
         ),
         from: accountAssetTrendProvider,
         name: r'accountAssetTrendProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$accountAssetTrendHash,
         dependencies: AccountAssetTrendFamily._dependencies,
         allTransitiveDependencies:
             AccountAssetTrendFamily._allTransitiveDependencies,
         accountId: accountId,
         period: period,
         year: year,
       );

  AccountAssetTrendProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.accountId,
    required this.period,
    required this.year,
  }) : super.internal();

  final String accountId;
  final TrendPeriod period;
  final String? year;

  @override
  Override overrideWith(
    FutureOr<List<AssetTrendPoint>> Function(AccountAssetTrendRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountAssetTrendProvider._internal(
        (ref) => create(ref as AccountAssetTrendRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        accountId: accountId,
        period: period,
        year: year,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<AssetTrendPoint>> createElement() {
    return _AccountAssetTrendProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountAssetTrendProvider &&
        other.accountId == accountId &&
        other.period == period &&
        other.year == year;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountId.hashCode);
    hash = _SystemHash.combine(hash, period.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AccountAssetTrendRef
    on AutoDisposeFutureProviderRef<List<AssetTrendPoint>> {
  /// The parameter `accountId` of this provider.
  String get accountId;

  /// The parameter `period` of this provider.
  TrendPeriod get period;

  /// The parameter `year` of this provider.
  String? get year;
}

class _AccountAssetTrendProviderElement
    extends AutoDisposeFutureProviderElement<List<AssetTrendPoint>>
    with AccountAssetTrendRef {
  _AccountAssetTrendProviderElement(super.provider);

  @override
  String get accountId => (origin as AccountAssetTrendProvider).accountId;
  @override
  TrendPeriod get period => (origin as AccountAssetTrendProvider).period;
  @override
  String? get year => (origin as AccountAssetTrendProvider).year;
}

String _$assetAccountsHash() => r'9a52b94d6ee8dd733db83b3bb8fe1bb86fe0d69c';

/// 계좌 목록 Provider
///
/// Copied from [AssetAccounts].
@ProviderFor(AssetAccounts)
final assetAccountsProvider =
    AutoDisposeAsyncNotifierProvider<
      AssetAccounts,
      List<AccountModel>
    >.internal(
      AssetAccounts.new,
      name: r'assetAccountsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$assetAccountsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AssetAccounts = AutoDisposeAsyncNotifier<List<AccountModel>>;
String _$assetRecordsHash() => r'da424947cd9847935fea322da1d5b087331e78e2';

abstract class _$AssetRecords
    extends BuildlessAutoDisposeAsyncNotifier<List<AssetRecordModel>> {
  late final String accountId;

  FutureOr<List<AssetRecordModel>> build(String accountId);
}

/// 자산 기록 Provider
///
/// Copied from [AssetRecords].
@ProviderFor(AssetRecords)
const assetRecordsProvider = AssetRecordsFamily();

/// 자산 기록 Provider
///
/// Copied from [AssetRecords].
class AssetRecordsFamily extends Family<AsyncValue<List<AssetRecordModel>>> {
  /// 자산 기록 Provider
  ///
  /// Copied from [AssetRecords].
  const AssetRecordsFamily();

  /// 자산 기록 Provider
  ///
  /// Copied from [AssetRecords].
  AssetRecordsProvider call(String accountId) {
    return AssetRecordsProvider(accountId);
  }

  @override
  AssetRecordsProvider getProviderOverride(
    covariant AssetRecordsProvider provider,
  ) {
    return call(provider.accountId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'assetRecordsProvider';
}

/// 자산 기록 Provider
///
/// Copied from [AssetRecords].
class AssetRecordsProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          AssetRecords,
          List<AssetRecordModel>
        > {
  /// 자산 기록 Provider
  ///
  /// Copied from [AssetRecords].
  AssetRecordsProvider(String accountId)
    : this._internal(
        () => AssetRecords()..accountId = accountId,
        from: assetRecordsProvider,
        name: r'assetRecordsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$assetRecordsHash,
        dependencies: AssetRecordsFamily._dependencies,
        allTransitiveDependencies:
            AssetRecordsFamily._allTransitiveDependencies,
        accountId: accountId,
      );

  AssetRecordsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.accountId,
  }) : super.internal();

  final String accountId;

  @override
  FutureOr<List<AssetRecordModel>> runNotifierBuild(
    covariant AssetRecords notifier,
  ) {
    return notifier.build(accountId);
  }

  @override
  Override overrideWith(AssetRecords Function() create) {
    return ProviderOverride(
      origin: this,
      override: AssetRecordsProvider._internal(
        () => create()..accountId = accountId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        accountId: accountId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<AssetRecords, List<AssetRecordModel>>
  createElement() {
    return _AssetRecordsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AssetRecordsProvider && other.accountId == accountId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AssetRecordsRef
    on AutoDisposeAsyncNotifierProviderRef<List<AssetRecordModel>> {
  /// The parameter `accountId` of this provider.
  String get accountId;
}

class _AssetRecordsProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          AssetRecords,
          List<AssetRecordModel>
        >
    with AssetRecordsRef {
  _AssetRecordsProviderElement(super.provider);

  @override
  String get accountId => (origin as AssetRecordsProvider).accountId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
