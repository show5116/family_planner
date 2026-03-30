// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'indicator_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$indicatorHistoryHash() => r'1c7aa0ac61cacdec30eb767aebf18b3a072f5ba1';

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

String _$indicatorSparklineHash() =>
    r'c85e2cd8c300091a1c346707fcca9320c52418b7';

/// 스파크라인용 당일 히스토리 Provider (symbol별, days=1)
///
/// Copied from [indicatorSparkline].
@ProviderFor(indicatorSparkline)
const indicatorSparklineProvider = IndicatorSparklineFamily();

/// 스파크라인용 당일 히스토리 Provider (symbol별, days=1)
///
/// Copied from [indicatorSparkline].
class IndicatorSparklineFamily extends Family<AsyncValue<List<double>>> {
  /// 스파크라인용 당일 히스토리 Provider (symbol별, days=1)
  ///
  /// Copied from [indicatorSparkline].
  const IndicatorSparklineFamily();

  /// 스파크라인용 당일 히스토리 Provider (symbol별, days=1)
  ///
  /// Copied from [indicatorSparkline].
  IndicatorSparklineProvider call(String symbol) {
    return IndicatorSparklineProvider(symbol);
  }

  @override
  IndicatorSparklineProvider getProviderOverride(
    covariant IndicatorSparklineProvider provider,
  ) {
    return call(provider.symbol);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'indicatorSparklineProvider';
}

/// 스파크라인용 당일 히스토리 Provider (symbol별, days=1)
///
/// Copied from [indicatorSparkline].
class IndicatorSparklineProvider
    extends AutoDisposeFutureProvider<List<double>> {
  /// 스파크라인용 당일 히스토리 Provider (symbol별, days=1)
  ///
  /// Copied from [indicatorSparkline].
  IndicatorSparklineProvider(String symbol)
    : this._internal(
        (ref) => indicatorSparkline(ref as IndicatorSparklineRef, symbol),
        from: indicatorSparklineProvider,
        name: r'indicatorSparklineProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$indicatorSparklineHash,
        dependencies: IndicatorSparklineFamily._dependencies,
        allTransitiveDependencies:
            IndicatorSparklineFamily._allTransitiveDependencies,
        symbol: symbol,
      );

  IndicatorSparklineProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.symbol,
  }) : super.internal();

  final String symbol;

  @override
  Override overrideWith(
    FutureOr<List<double>> Function(IndicatorSparklineRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IndicatorSparklineProvider._internal(
        (ref) => create(ref as IndicatorSparklineRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        symbol: symbol,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<double>> createElement() {
    return _IndicatorSparklineProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IndicatorSparklineProvider && other.symbol == symbol;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, symbol.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin IndicatorSparklineRef on AutoDisposeFutureProviderRef<List<double>> {
  /// The parameter `symbol` of this provider.
  String get symbol;
}

class _IndicatorSparklineProviderElement
    extends AutoDisposeFutureProviderElement<List<double>>
    with IndicatorSparklineRef {
  _IndicatorSparklineProviderElement(super.provider);

  @override
  String get symbol => (origin as IndicatorSparklineProvider).symbol;
}

String _$initIndicatorHistoryHash() =>
    r'c75848666f354a1d4a26aebe7a1d2a17463e29e9';

/// [어드민] 과거 데이터 일괄 초기화 Provider
///
/// Copied from [initIndicatorHistory].
@ProviderFor(initIndicatorHistory)
const initIndicatorHistoryProvider = InitIndicatorHistoryFamily();

/// [어드민] 과거 데이터 일괄 초기화 Provider
///
/// Copied from [initIndicatorHistory].
class InitIndicatorHistoryFamily extends Family<AsyncValue<InitHistoryResult>> {
  /// [어드민] 과거 데이터 일괄 초기화 Provider
  ///
  /// Copied from [initIndicatorHistory].
  const InitIndicatorHistoryFamily();

  /// [어드민] 과거 데이터 일괄 초기화 Provider
  ///
  /// Copied from [initIndicatorHistory].
  InitIndicatorHistoryProvider call({int? days}) {
    return InitIndicatorHistoryProvider(days: days);
  }

  @override
  InitIndicatorHistoryProvider getProviderOverride(
    covariant InitIndicatorHistoryProvider provider,
  ) {
    return call(days: provider.days);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'initIndicatorHistoryProvider';
}

/// [어드민] 과거 데이터 일괄 초기화 Provider
///
/// Copied from [initIndicatorHistory].
class InitIndicatorHistoryProvider
    extends AutoDisposeFutureProvider<InitHistoryResult> {
  /// [어드민] 과거 데이터 일괄 초기화 Provider
  ///
  /// Copied from [initIndicatorHistory].
  InitIndicatorHistoryProvider({int? days})
    : this._internal(
        (ref) =>
            initIndicatorHistory(ref as InitIndicatorHistoryRef, days: days),
        from: initIndicatorHistoryProvider,
        name: r'initIndicatorHistoryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$initIndicatorHistoryHash,
        dependencies: InitIndicatorHistoryFamily._dependencies,
        allTransitiveDependencies:
            InitIndicatorHistoryFamily._allTransitiveDependencies,
        days: days,
      );

  InitIndicatorHistoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.days,
  }) : super.internal();

  final int? days;

  @override
  Override overrideWith(
    FutureOr<InitHistoryResult> Function(InitIndicatorHistoryRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: InitIndicatorHistoryProvider._internal(
        (ref) => create(ref as InitIndicatorHistoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        days: days,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<InitHistoryResult> createElement() {
    return _InitIndicatorHistoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is InitIndicatorHistoryProvider && other.days == days;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, days.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin InitIndicatorHistoryRef
    on AutoDisposeFutureProviderRef<InitHistoryResult> {
  /// The parameter `days` of this provider.
  int? get days;
}

class _InitIndicatorHistoryProviderElement
    extends AutoDisposeFutureProviderElement<InitHistoryResult>
    with InitIndicatorHistoryRef {
  _InitIndicatorHistoryProviderElement(super.provider);

  @override
  int? get days => (origin as InitIndicatorHistoryProvider).days;
}

String _$indicatorsHash() => r'e4285660fdde937c26eaef0ac8ba99943949dd93';

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
String _$marketBriefingHash() => r'4c84bb77a22d1d88b295a4e56d8877d45b7c729a';

/// AI 시황 브리핑 Provider
///
/// Copied from [MarketBriefing].
@ProviderFor(MarketBriefing)
final marketBriefingProvider =
    AutoDisposeAsyncNotifierProvider<
      MarketBriefing,
      MarketBriefingModel
    >.internal(
      MarketBriefing.new,
      name: r'marketBriefingProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$marketBriefingHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MarketBriefing = AutoDisposeAsyncNotifier<MarketBriefingModel>;
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
