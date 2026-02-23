// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memo_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$memoDetailHash() => r'0c1b3fc668fea7797fe241efc6a91b3790900e64';

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

/// 특정 메모 상세 Provider
///
/// Copied from [memoDetail].
@ProviderFor(memoDetail)
const memoDetailProvider = MemoDetailFamily();

/// 특정 메모 상세 Provider
///
/// Copied from [memoDetail].
class MemoDetailFamily extends Family<AsyncValue<MemoModel>> {
  /// 특정 메모 상세 Provider
  ///
  /// Copied from [memoDetail].
  const MemoDetailFamily();

  /// 특정 메모 상세 Provider
  ///
  /// Copied from [memoDetail].
  MemoDetailProvider call(String id) {
    return MemoDetailProvider(id);
  }

  @override
  MemoDetailProvider getProviderOverride(
    covariant MemoDetailProvider provider,
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
  String? get name => r'memoDetailProvider';
}

/// 특정 메모 상세 Provider
///
/// Copied from [memoDetail].
class MemoDetailProvider extends AutoDisposeFutureProvider<MemoModel> {
  /// 특정 메모 상세 Provider
  ///
  /// Copied from [memoDetail].
  MemoDetailProvider(String id)
    : this._internal(
        (ref) => memoDetail(ref as MemoDetailRef, id),
        from: memoDetailProvider,
        name: r'memoDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$memoDetailHash,
        dependencies: MemoDetailFamily._dependencies,
        allTransitiveDependencies: MemoDetailFamily._allTransitiveDependencies,
        id: id,
      );

  MemoDetailProvider._internal(
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
    FutureOr<MemoModel> Function(MemoDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MemoDetailProvider._internal(
        (ref) => create(ref as MemoDetailRef),
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
  AutoDisposeFutureProviderElement<MemoModel> createElement() {
    return _MemoDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MemoDetailProvider && other.id == id;
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
mixin MemoDetailRef on AutoDisposeFutureProviderRef<MemoModel> {
  /// The parameter `id` of this provider.
  String get id;
}

class _MemoDetailProviderElement
    extends AutoDisposeFutureProviderElement<MemoModel>
    with MemoDetailRef {
  _MemoDetailProviderElement(super.provider);

  @override
  String get id => (origin as MemoDetailProvider).id;
}

String _$memoListHash() => r'46ea715bc17c5bb34837a3bb1903b295b285c21e';

/// 메모 목록 Provider (무한 스크롤 + 검색 지원)
///
/// Copied from [MemoList].
@ProviderFor(MemoList)
final memoListProvider =
    AutoDisposeAsyncNotifierProvider<MemoList, List<MemoModel>>.internal(
      MemoList.new,
      name: r'memoListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$memoListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MemoList = AutoDisposeAsyncNotifier<List<MemoModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
