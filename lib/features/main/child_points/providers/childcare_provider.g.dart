// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'childcare_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$childcareAccountDetailHash() =>
    r'9fb277f221201957d2ec4d85d570a7f88303408b';

/// 육아 계정 상세 Provider
///
/// Copied from [childcareAccountDetail].
@ProviderFor(childcareAccountDetail)
final childcareAccountDetailProvider =
    AutoDisposeFutureProvider<ChildcareAccount?>.internal(
      childcareAccountDetail,
      name: r'childcareAccountDetailProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$childcareAccountDetailHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChildcareAccountDetailRef =
    AutoDisposeFutureProviderRef<ChildcareAccount?>;
String _$childcareAccountsHash() => r'80a36117d3ead48b037557c53372a149c41a42c7';

/// 육아 계정 목록 Provider
///
/// Copied from [ChildcareAccounts].
@ProviderFor(ChildcareAccounts)
final childcareAccountsProvider =
    AutoDisposeAsyncNotifierProvider<
      ChildcareAccounts,
      List<ChildcareAccount>
    >.internal(
      ChildcareAccounts.new,
      name: r'childcareAccountsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$childcareAccountsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ChildcareAccounts = AutoDisposeAsyncNotifier<List<ChildcareAccount>>;
String _$childcareTransactionsHash() =>
    r'745c8ed8e6b51d730dcdafb0b13220ee4e3fd74c';

/// 거래 내역 Provider
///
/// Copied from [ChildcareTransactions].
@ProviderFor(ChildcareTransactions)
final childcareTransactionsProvider =
    AutoDisposeAsyncNotifierProvider<
      ChildcareTransactions,
      List<ChildcareTransaction>
    >.internal(
      ChildcareTransactions.new,
      name: r'childcareTransactionsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$childcareTransactionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ChildcareTransactions =
    AutoDisposeAsyncNotifier<List<ChildcareTransaction>>;
String _$childcareRewardsHash() => r'79a80f8495e035c3237eda1244faec96bad0ba5e';

/// 보상 목록 Provider
///
/// Copied from [ChildcareRewards].
@ProviderFor(ChildcareRewards)
final childcareRewardsProvider =
    AutoDisposeAsyncNotifierProvider<
      ChildcareRewards,
      List<ChildcareReward>
    >.internal(
      ChildcareRewards.new,
      name: r'childcareRewardsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$childcareRewardsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ChildcareRewards = AutoDisposeAsyncNotifier<List<ChildcareReward>>;
String _$childcareRulesHash() => r'4d4c7ffa8f38ff46c58362eb6bd89077e84b5310';

/// 규칙 목록 Provider
///
/// Copied from [ChildcareRules].
@ProviderFor(ChildcareRules)
final childcareRulesProvider =
    AutoDisposeAsyncNotifierProvider<
      ChildcareRules,
      List<ChildcareRule>
    >.internal(
      ChildcareRules.new,
      name: r'childcareRulesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$childcareRulesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ChildcareRules = AutoDisposeAsyncNotifier<List<ChildcareRule>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
