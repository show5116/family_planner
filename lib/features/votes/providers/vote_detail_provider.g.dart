// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vote_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$voteDetailHash() => r'291316f89a9a425cbb8e44c6e68e66749f65ade1';

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

abstract class _$VoteDetail
    extends BuildlessAutoDisposeAsyncNotifier<VoteModel> {
  late final String groupId;
  late final String voteId;

  FutureOr<VoteModel> build({required String groupId, required String voteId});
}

/// See also [VoteDetail].
@ProviderFor(VoteDetail)
const voteDetailProvider = VoteDetailFamily();

/// See also [VoteDetail].
class VoteDetailFamily extends Family<AsyncValue<VoteModel>> {
  /// See also [VoteDetail].
  const VoteDetailFamily();

  /// See also [VoteDetail].
  VoteDetailProvider call({required String groupId, required String voteId}) {
    return VoteDetailProvider(groupId: groupId, voteId: voteId);
  }

  @override
  VoteDetailProvider getProviderOverride(
    covariant VoteDetailProvider provider,
  ) {
    return call(groupId: provider.groupId, voteId: provider.voteId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'voteDetailProvider';
}

/// See also [VoteDetail].
class VoteDetailProvider
    extends AutoDisposeAsyncNotifierProviderImpl<VoteDetail, VoteModel> {
  /// See also [VoteDetail].
  VoteDetailProvider({required String groupId, required String voteId})
    : this._internal(
        () => VoteDetail()
          ..groupId = groupId
          ..voteId = voteId,
        from: voteDetailProvider,
        name: r'voteDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$voteDetailHash,
        dependencies: VoteDetailFamily._dependencies,
        allTransitiveDependencies: VoteDetailFamily._allTransitiveDependencies,
        groupId: groupId,
        voteId: voteId,
      );

  VoteDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.groupId,
    required this.voteId,
  }) : super.internal();

  final String groupId;
  final String voteId;

  @override
  FutureOr<VoteModel> runNotifierBuild(covariant VoteDetail notifier) {
    return notifier.build(groupId: groupId, voteId: voteId);
  }

  @override
  Override overrideWith(VoteDetail Function() create) {
    return ProviderOverride(
      origin: this,
      override: VoteDetailProvider._internal(
        () => create()
          ..groupId = groupId
          ..voteId = voteId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        groupId: groupId,
        voteId: voteId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<VoteDetail, VoteModel>
  createElement() {
    return _VoteDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VoteDetailProvider &&
        other.groupId == groupId &&
        other.voteId == voteId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);
    hash = _SystemHash.combine(hash, voteId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VoteDetailRef on AutoDisposeAsyncNotifierProviderRef<VoteModel> {
  /// The parameter `groupId` of this provider.
  String get groupId;

  /// The parameter `voteId` of this provider.
  String get voteId;
}

class _VoteDetailProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<VoteDetail, VoteModel>
    with VoteDetailRef {
  _VoteDetailProviderElement(super.provider);

  @override
  String get groupId => (origin as VoteDetailProvider).groupId;
  @override
  String get voteId => (origin as VoteDetailProvider).voteId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
