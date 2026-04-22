// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memo_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$memoTagsHash() => r'7154ba2f0be2b83f6e97b712b5e56d801d005a47';

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

/// 태그 목록 Provider
/// [groupId]: 특정 그룹의 태그, [personal]: 개인 메모 태그, 둘 다 null이면 전체
///
/// Copied from [memoTags].
@ProviderFor(memoTags)
const memoTagsProvider = MemoTagsFamily();

/// 태그 목록 Provider
/// [groupId]: 특정 그룹의 태그, [personal]: 개인 메모 태그, 둘 다 null이면 전체
///
/// Copied from [memoTags].
class MemoTagsFamily extends Family<AsyncValue<List<String>>> {
  /// 태그 목록 Provider
  /// [groupId]: 특정 그룹의 태그, [personal]: 개인 메모 태그, 둘 다 null이면 전체
  ///
  /// Copied from [memoTags].
  const MemoTagsFamily();

  /// 태그 목록 Provider
  /// [groupId]: 특정 그룹의 태그, [personal]: 개인 메모 태그, 둘 다 null이면 전체
  ///
  /// Copied from [memoTags].
  MemoTagsProvider call({String? groupId, bool? personal}) {
    return MemoTagsProvider(groupId: groupId, personal: personal);
  }

  @override
  MemoTagsProvider getProviderOverride(covariant MemoTagsProvider provider) {
    return call(groupId: provider.groupId, personal: provider.personal);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'memoTagsProvider';
}

/// 태그 목록 Provider
/// [groupId]: 특정 그룹의 태그, [personal]: 개인 메모 태그, 둘 다 null이면 전체
///
/// Copied from [memoTags].
class MemoTagsProvider extends AutoDisposeFutureProvider<List<String>> {
  /// 태그 목록 Provider
  /// [groupId]: 특정 그룹의 태그, [personal]: 개인 메모 태그, 둘 다 null이면 전체
  ///
  /// Copied from [memoTags].
  MemoTagsProvider({String? groupId, bool? personal})
    : this._internal(
        (ref) =>
            memoTags(ref as MemoTagsRef, groupId: groupId, personal: personal),
        from: memoTagsProvider,
        name: r'memoTagsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$memoTagsHash,
        dependencies: MemoTagsFamily._dependencies,
        allTransitiveDependencies: MemoTagsFamily._allTransitiveDependencies,
        groupId: groupId,
        personal: personal,
      );

  MemoTagsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.groupId,
    required this.personal,
  }) : super.internal();

  final String? groupId;
  final bool? personal;

  @override
  Override overrideWith(
    FutureOr<List<String>> Function(MemoTagsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MemoTagsProvider._internal(
        (ref) => create(ref as MemoTagsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        groupId: groupId,
        personal: personal,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<String>> createElement() {
    return _MemoTagsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MemoTagsProvider &&
        other.groupId == groupId &&
        other.personal == personal;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);
    hash = _SystemHash.combine(hash, personal.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MemoTagsRef on AutoDisposeFutureProviderRef<List<String>> {
  /// The parameter `groupId` of this provider.
  String? get groupId;

  /// The parameter `personal` of this provider.
  bool? get personal;
}

class _MemoTagsProviderElement
    extends AutoDisposeFutureProviderElement<List<String>>
    with MemoTagsRef {
  _MemoTagsProviderElement(super.provider);

  @override
  String? get groupId => (origin as MemoTagsProvider).groupId;
  @override
  bool? get personal => (origin as MemoTagsProvider).personal;
}

String _$memoDetailHash() => r'0c1b3fc668fea7797fe241efc6a91b3790900e64';

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

String _$pinnedMemosHash() => r'6df659f574252cd1ef2109008cf68a8d33d18c4d';

/// 핀된 메모 목록 Provider
///
/// Copied from [pinnedMemos].
@ProviderFor(pinnedMemos)
const pinnedMemosProvider = PinnedMemosFamily();

/// 핀된 메모 목록 Provider
///
/// Copied from [pinnedMemos].
class PinnedMemosFamily extends Family<AsyncValue<List<MemoModel>>> {
  /// 핀된 메모 목록 Provider
  ///
  /// Copied from [pinnedMemos].
  const PinnedMemosFamily();

  /// 핀된 메모 목록 Provider
  ///
  /// Copied from [pinnedMemos].
  PinnedMemosProvider call({String? groupId, bool? personal}) {
    return PinnedMemosProvider(groupId: groupId, personal: personal);
  }

  @override
  PinnedMemosProvider getProviderOverride(
    covariant PinnedMemosProvider provider,
  ) {
    return call(groupId: provider.groupId, personal: provider.personal);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'pinnedMemosProvider';
}

/// 핀된 메모 목록 Provider
///
/// Copied from [pinnedMemos].
class PinnedMemosProvider extends AutoDisposeFutureProvider<List<MemoModel>> {
  /// 핀된 메모 목록 Provider
  ///
  /// Copied from [pinnedMemos].
  PinnedMemosProvider({String? groupId, bool? personal})
    : this._internal(
        (ref) => pinnedMemos(
          ref as PinnedMemosRef,
          groupId: groupId,
          personal: personal,
        ),
        from: pinnedMemosProvider,
        name: r'pinnedMemosProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$pinnedMemosHash,
        dependencies: PinnedMemosFamily._dependencies,
        allTransitiveDependencies: PinnedMemosFamily._allTransitiveDependencies,
        groupId: groupId,
        personal: personal,
      );

  PinnedMemosProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.groupId,
    required this.personal,
  }) : super.internal();

  final String? groupId;
  final bool? personal;

  @override
  Override overrideWith(
    FutureOr<List<MemoModel>> Function(PinnedMemosRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PinnedMemosProvider._internal(
        (ref) => create(ref as PinnedMemosRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        groupId: groupId,
        personal: personal,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<MemoModel>> createElement() {
    return _PinnedMemosProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PinnedMemosProvider &&
        other.groupId == groupId &&
        other.personal == personal;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);
    hash = _SystemHash.combine(hash, personal.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PinnedMemosRef on AutoDisposeFutureProviderRef<List<MemoModel>> {
  /// The parameter `groupId` of this provider.
  String? get groupId;

  /// The parameter `personal` of this provider.
  bool? get personal;
}

class _PinnedMemosProviderElement
    extends AutoDisposeFutureProviderElement<List<MemoModel>>
    with PinnedMemosRef {
  _PinnedMemosProviderElement(super.provider);

  @override
  String? get groupId => (origin as PinnedMemosProvider).groupId;
  @override
  bool? get personal => (origin as PinnedMemosProvider).personal;
}

String _$memoListHash() => r'1855d2a1c7bbc4a87baaac7dee6f81efc50025b0';

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
