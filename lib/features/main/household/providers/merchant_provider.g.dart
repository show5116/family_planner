// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$merchantsHash() => r'1f9eaeee9d44de68d15ec4f589470ae17f446477';

/// 소비처 목록 Provider
///
/// Copied from [Merchants].
@ProviderFor(Merchants)
final merchantsProvider =
    AutoDisposeAsyncNotifierProvider<Merchants, List<MerchantModel>>.internal(
      Merchants.new,
      name: r'merchantsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$merchantsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Merchants = AutoDisposeAsyncNotifier<List<MerchantModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
