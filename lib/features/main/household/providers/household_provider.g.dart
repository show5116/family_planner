// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'household_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$householdMonthlyStatisticsHash() =>
    r'6f8be5ac7b66884bf5afac7646084399d7b3f9e0';

/// 월간 통계 Provider
///
/// Copied from [householdMonthlyStatistics].
@ProviderFor(householdMonthlyStatistics)
final householdMonthlyStatisticsProvider =
    AutoDisposeFutureProvider<MonthlyStatisticsModel>.internal(
      householdMonthlyStatistics,
      name: r'householdMonthlyStatisticsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$householdMonthlyStatisticsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HouseholdMonthlyStatisticsRef =
    AutoDisposeFutureProviderRef<MonthlyStatisticsModel>;
String _$householdYearlyStatisticsHash() =>
    r'2119a3c2848004c7a9e663eed631ba749b5ee23d';

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

/// 연간 통계 Provider
///
/// Copied from [householdYearlyStatistics].
@ProviderFor(householdYearlyStatistics)
const householdYearlyStatisticsProvider = HouseholdYearlyStatisticsFamily();

/// 연간 통계 Provider
///
/// Copied from [householdYearlyStatistics].
class HouseholdYearlyStatisticsFamily
    extends Family<AsyncValue<YearlyStatisticsModel>> {
  /// 연간 통계 Provider
  ///
  /// Copied from [householdYearlyStatistics].
  const HouseholdYearlyStatisticsFamily();

  /// 연간 통계 Provider
  ///
  /// Copied from [householdYearlyStatistics].
  HouseholdYearlyStatisticsProvider call(String year) {
    return HouseholdYearlyStatisticsProvider(year);
  }

  @override
  HouseholdYearlyStatisticsProvider getProviderOverride(
    covariant HouseholdYearlyStatisticsProvider provider,
  ) {
    return call(provider.year);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'householdYearlyStatisticsProvider';
}

/// 연간 통계 Provider
///
/// Copied from [householdYearlyStatistics].
class HouseholdYearlyStatisticsProvider
    extends AutoDisposeFutureProvider<YearlyStatisticsModel> {
  /// 연간 통계 Provider
  ///
  /// Copied from [householdYearlyStatistics].
  HouseholdYearlyStatisticsProvider(String year)
    : this._internal(
        (ref) => householdYearlyStatistics(
          ref as HouseholdYearlyStatisticsRef,
          year,
        ),
        from: householdYearlyStatisticsProvider,
        name: r'householdYearlyStatisticsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$householdYearlyStatisticsHash,
        dependencies: HouseholdYearlyStatisticsFamily._dependencies,
        allTransitiveDependencies:
            HouseholdYearlyStatisticsFamily._allTransitiveDependencies,
        year: year,
      );

  HouseholdYearlyStatisticsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
  }) : super.internal();

  final String year;

  @override
  Override overrideWith(
    FutureOr<YearlyStatisticsModel> Function(
      HouseholdYearlyStatisticsRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HouseholdYearlyStatisticsProvider._internal(
        (ref) => create(ref as HouseholdYearlyStatisticsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        year: year,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<YearlyStatisticsModel> createElement() {
    return _HouseholdYearlyStatisticsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HouseholdYearlyStatisticsProvider && other.year == year;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HouseholdYearlyStatisticsRef
    on AutoDisposeFutureProviderRef<YearlyStatisticsModel> {
  /// The parameter `year` of this provider.
  String get year;
}

class _HouseholdYearlyStatisticsProviderElement
    extends AutoDisposeFutureProviderElement<YearlyStatisticsModel>
    with HouseholdYearlyStatisticsRef {
  _HouseholdYearlyStatisticsProviderElement(super.provider);

  @override
  String get year => (origin as HouseholdYearlyStatisticsProvider).year;
}

String _$householdBudgetsHash() => r'95f6ade3d310c67438bd66c888c5ae97c7781ab6';

/// 예산 목록 Provider
///
/// Copied from [householdBudgets].
@ProviderFor(householdBudgets)
final householdBudgetsProvider =
    AutoDisposeFutureProvider<List<BudgetModel>>.internal(
      householdBudgets,
      name: r'householdBudgetsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$householdBudgetsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HouseholdBudgetsRef = AutoDisposeFutureProviderRef<List<BudgetModel>>;
String _$householdExpensesHash() => r'8c40f095b53e03e2535eafb95d8a2f3b1cc66805';

/// 지출 목록 Provider
///
/// Copied from [HouseholdExpenses].
@ProviderFor(HouseholdExpenses)
final householdExpensesProvider =
    AutoDisposeAsyncNotifierProvider<
      HouseholdExpenses,
      List<ExpenseModel>
    >.internal(
      HouseholdExpenses.new,
      name: r'householdExpensesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$householdExpensesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$HouseholdExpenses = AutoDisposeAsyncNotifier<List<ExpenseModel>>;
String _$householdRecurringExpensesHash() =>
    r'a5e3c97ebc95a05afa1dec1612a0263f811ef157';

/// 고정 지출 목록 Provider (isRecurring=true)
///
/// Copied from [HouseholdRecurringExpenses].
@ProviderFor(HouseholdRecurringExpenses)
final householdRecurringExpensesProvider =
    AutoDisposeAsyncNotifierProvider<
      HouseholdRecurringExpenses,
      List<ExpenseModel>
    >.internal(
      HouseholdRecurringExpenses.new,
      name: r'householdRecurringExpensesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$householdRecurringExpensesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$HouseholdRecurringExpenses =
    AutoDisposeAsyncNotifier<List<ExpenseModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
