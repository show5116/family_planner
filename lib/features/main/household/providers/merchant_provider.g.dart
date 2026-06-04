// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$merchantsHash() => r'25269e3ca81ea7556ed08362b808b1da7f53c7ef';

/// 소비처 목록 Provider
/// keepAlive는 MerchantsScreen이 마운트될 때 활성화되고 dispose 시 해제됩니다.
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
