// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'indicator_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$indicatorHistoryHash() => r'5700d8c1dfe6ceaeff6405ab1fbefda2e6ba804d';

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

/// 지표 시세 히스토리 Provider (symbol별)
///
/// Copied from [indicatorHistory].
@ProviderFor(indicatorHistory)
const indicatorHistoryProvider = IndicatorHistoryFamily();

/// 지표 시세 히스토리 Provider (symbol별)
///
/// Copied from [indicatorHistory].
class IndicatorHistoryFamily extends Family<AsyncValue<IndicatorHistoryModel>> {
  /// 지표 시세 히스토리 Provider (symbol별)
  ///
  /// Copied from [indicatorHistory].
  const IndicatorHistoryFamily();

  /// 지표 시세 히스토리 Provider (symbol별)
  ///
  /// Copied from [indicatorHistory].
  IndicatorHistoryProvider call(String symbol, {int days = 30}) {
    return IndicatorHistoryProvider(symbol, days: days);
  }

  @override
  IndicatorHistoryProvider getProviderOverride(
    covariant IndicatorHistoryProvider provider,
  ) {
    return call(provider.symbol, days: provider.days);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'indicatorHistoryProvider';
}

/// 지표 시세 히스토리 Provider (symbol별)
///
/// Copied from [indicatorHistory].
class IndicatorHistoryProvider
    extends AutoDisposeFutureProvider<IndicatorHistoryModel> {
  /// 지표 시세 히스토리 Provider (symbol별)
  ///
  /// Copied from [indicatorHistory].
  IndicatorHistoryProvider(String symbol, {int days = 30})
    : this._internal(
        (ref) =>
            indicatorHistory(ref as IndicatorHistoryRef, symbol, days: days),
        from: indicatorHistoryProvider,
        name: r'indicatorHistoryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$indicatorHistoryHash,
        dependencies: IndicatorHistoryFamily._dependencies,
        allTransitiveDependencies:
            IndicatorHistoryFamily._allTransitiveDependencies,
        symbol: symbol,
        days: days,
      );

  IndicatorHistoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.symbol,
    required this.days,
  }) : super.internal();

  final String symbol;
  final int days;

  @override
  Override overrideWith(
    FutureOr<IndicatorHistoryModel> Function(IndicatorHistoryRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IndicatorHistoryProvider._internal(
        (ref) => create(ref as IndicatorHistoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        symbol: symbol,
        days: days,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<IndicatorHistoryModel> createElement() {
    return _IndicatorHistoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IndicatorHistoryProvider &&
        other.symbol == symbol &&
        other.days == days;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, symbol.hashCode);
    hash = _SystemHash.combine(hash, days.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin IndicatorHistoryRef
    on AutoDisposeFutureProviderRef<IndicatorHistoryModel> {
  /// The parameter `symbol` of this provider.
  String get symbol;

  /// The parameter `days` of this provider.
  int get days;
}

class _IndicatorHistoryProviderElement
    extends AutoDisposeFutureProviderElement<IndicatorHistoryModel>
    with IndicatorHistoryRef {
  _IndicatorHistoryProviderElement(super.provider);

  @override
  String get symbol => (origin as IndicatorHistoryProvider).symbol;
  @override
  int get days => (origin as IndicatorHistoryProvider).days;
}

String _$indicatorsHash() => r'e806b629a925e94a61d999bbb0dfdd1e89dd5710';

/// 전체 지표 목록 Provider
///
/// Copied from [Indicators].
@ProviderFor(Indicators)
final indicatorsProvider =
    AutoDisposeAsyncNotifierProvider<Indicators, List<IndicatorModel>>.internal(
      Indicators.new,
      name: r'indicatorsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$indicatorsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Indicators = AutoDisposeAsyncNotifier<List<IndicatorModel>>;
String _$bookmarkedIndicatorsHash() =>
    r'fb6e7ae195e5ace747371649e423548546c55cb3';

/// 즐겨찾기 지표 목록 Provider
///
/// Copied from [BookmarkedIndicators].
@ProviderFor(BookmarkedIndicators)
final bookmarkedIndicatorsProvider =
    AutoDisposeAsyncNotifierProvider<
      BookmarkedIndicators,
      List<IndicatorModel>
    >.internal(
      BookmarkedIndicators.new,
      name: r'bookmarkedIndicatorsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$bookmarkedIndicatorsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BookmarkedIndicators = AutoDisposeAsyncNotifier<List<IndicatorModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
