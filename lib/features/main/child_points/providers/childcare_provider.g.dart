// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'childcare_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$childcareChildrenHash() => r'f1346b2fa2f6ac3ee915d0fa7435b480d1edc690';

/// 자녀 프로필 목록 Provider
///
/// Copied from [ChildcareChildren].
@ProviderFor(ChildcareChildren)
final childcareChildrenProvider =
    AutoDisposeAsyncNotifierProvider<
      ChildcareChildren,
      List<ChildcareChild>
    >.internal(
      ChildcareChildren.new,
      name: r'childcareChildrenProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$childcareChildrenHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ChildcareChildren = AutoDisposeAsyncNotifier<List<ChildcareChild>>;
String _$childcareAccountsHash() => r'db333b291b8c3b085a7af0ad6fe9c0d7cc5c0bac';

/// 포인트 계정 목록 Provider (그룹 기준)
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
    r'701a87090f5f4d156da9d92a82f22edf2da71370';

/// 거래 내역 Provider (월별 또는 연도별)
///
/// Copied from [ChildcareTransactions].
@ProviderFor(ChildcareTransactions)
final childcareTransactionsProvider =
    AutoDisposeAsyncNotifierProvider<
      ChildcareTransactions,
      TransactionResult
    >.internal(
      ChildcareTransactions.new,
      name: r'childcareTransactionsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$childcareTransactionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ChildcareTransactions = AutoDisposeAsyncNotifier<TransactionResult>;
String _$childcareShopItemsHash() =>
    r'1822bfd3eca1e8be7687da8dcbf9ff16012fbb3d';

/// 포인트 상점 아이템 목록 Provider
///
/// Copied from [ChildcareShopItems].
@ProviderFor(ChildcareShopItems)
final childcareShopItemsProvider =
    AutoDisposeAsyncNotifierProvider<
      ChildcareShopItems,
      List<ChildcareShopItem>
    >.internal(
      ChildcareShopItems.new,
      name: r'childcareShopItemsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$childcareShopItemsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ChildcareShopItems =
    AutoDisposeAsyncNotifier<List<ChildcareShopItem>>;
String _$childcareRulesHash() => r'99a7f6abf9052ea2a2f25df599b247d4bc6d2e04';

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
