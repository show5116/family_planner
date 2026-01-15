// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pinnedAnnouncementsHash() =>
    r'ad00a3d6eefbf344cd4785365fd0170dd212f213';

/// 고정 공지사항 목록 Provider
///
/// Copied from [pinnedAnnouncements].
@ProviderFor(pinnedAnnouncements)
final pinnedAnnouncementsProvider =
    AutoDisposeFutureProvider<List<AnnouncementModel>>.internal(
      pinnedAnnouncements,
      name: r'pinnedAnnouncementsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pinnedAnnouncementsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PinnedAnnouncementsRef =
    AutoDisposeFutureProviderRef<List<AnnouncementModel>>;
String _$announcementDetailHash() =>
    r'73c1dd4eae858524860be5b72f648a440d5ff103';

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

/// 특정 공지사항 상세 Provider
///
/// Copied from [announcementDetail].
@ProviderFor(announcementDetail)
const announcementDetailProvider = AnnouncementDetailFamily();

/// 특정 공지사항 상세 Provider
///
/// Copied from [announcementDetail].
class AnnouncementDetailFamily extends Family<AsyncValue<AnnouncementModel>> {
  /// 특정 공지사항 상세 Provider
  ///
  /// Copied from [announcementDetail].
  const AnnouncementDetailFamily();

  /// 특정 공지사항 상세 Provider
  ///
  /// Copied from [announcementDetail].
  AnnouncementDetailProvider call(String id) {
    return AnnouncementDetailProvider(id);
  }

  @override
  AnnouncementDetailProvider getProviderOverride(
    covariant AnnouncementDetailProvider provider,
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
  String? get name => r'announcementDetailProvider';
}

/// 특정 공지사항 상세 Provider
///
/// Copied from [announcementDetail].
class AnnouncementDetailProvider
    extends AutoDisposeFutureProvider<AnnouncementModel> {
  /// 특정 공지사항 상세 Provider
  ///
  /// Copied from [announcementDetail].
  AnnouncementDetailProvider(String id)
    : this._internal(
        (ref) => announcementDetail(ref as AnnouncementDetailRef, id),
        from: announcementDetailProvider,
        name: r'announcementDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$announcementDetailHash,
        dependencies: AnnouncementDetailFamily._dependencies,
        allTransitiveDependencies:
            AnnouncementDetailFamily._allTransitiveDependencies,
        id: id,
      );

  AnnouncementDetailProvider._internal(
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
    FutureOr<AnnouncementModel> Function(AnnouncementDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AnnouncementDetailProvider._internal(
        (ref) => create(ref as AnnouncementDetailRef),
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
  AutoDisposeFutureProviderElement<AnnouncementModel> createElement() {
    return _AnnouncementDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AnnouncementDetailProvider && other.id == id;
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
mixin AnnouncementDetailRef on AutoDisposeFutureProviderRef<AnnouncementModel> {
  /// The parameter `id` of this provider.
  String get id;
}

class _AnnouncementDetailProviderElement
    extends AutoDisposeFutureProviderElement<AnnouncementModel>
    with AnnouncementDetailRef {
  _AnnouncementDetailProviderElement(super.provider);

  @override
  String get id => (origin as AnnouncementDetailProvider).id;
}

String _$unreadAnnouncementCountHash() =>
    r'53c170d481f02c39f094bbdf05ad1761399ecde3';

/// 읽지 않은 공지사항 개수 Provider
///
/// Copied from [unreadAnnouncementCount].
@ProviderFor(unreadAnnouncementCount)
final unreadAnnouncementCountProvider = AutoDisposeFutureProvider<int>.internal(
  unreadAnnouncementCount,
  name: r'unreadAnnouncementCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$unreadAnnouncementCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UnreadAnnouncementCountRef = AutoDisposeFutureProviderRef<int>;
String _$announcementListHash() => r'2fb9950940ee6278d582e661287231efd915450b';

/// 공지사항 목록 Provider (무한 스크롤 지원)
///
/// Copied from [AnnouncementList].
@ProviderFor(AnnouncementList)
final announcementListProvider =
    AutoDisposeAsyncNotifierProvider<
      AnnouncementList,
      List<AnnouncementModel>
    >.internal(
      AnnouncementList.new,
      name: r'announcementListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$announcementListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AnnouncementList = AutoDisposeAsyncNotifier<List<AnnouncementModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
