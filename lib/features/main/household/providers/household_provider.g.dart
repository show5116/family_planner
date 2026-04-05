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
String _$householdMonthlyStatisticsByMonthHash() =>
    r'b4d82dc25e0be8bf00c3e4e6e348c439580b788d';

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

/// 특정 월 통계 Provider (통계 화면 전용 - 독립 월 파라미터)
///
/// Copied from [householdMonthlyStatisticsByMonth].
@ProviderFor(householdMonthlyStatisticsByMonth)
const householdMonthlyStatisticsByMonthProvider =
    HouseholdMonthlyStatisticsByMonthFamily();

/// 특정 월 통계 Provider (통계 화면 전용 - 독립 월 파라미터)
///
/// Copied from [householdMonthlyStatisticsByMonth].
class HouseholdMonthlyStatisticsByMonthFamily
    extends Family<AsyncValue<MonthlyStatisticsModel>> {
  /// 특정 월 통계 Provider (통계 화면 전용 - 독립 월 파라미터)
  ///
  /// Copied from [householdMonthlyStatisticsByMonth].
  const HouseholdMonthlyStatisticsByMonthFamily();

  /// 특정 월 통계 Provider (통계 화면 전용 - 독립 월 파라미터)
  ///
  /// Copied from [householdMonthlyStatisticsByMonth].
  HouseholdMonthlyStatisticsByMonthProvider call(String month) {
    return HouseholdMonthlyStatisticsByMonthProvider(month);
  }

  @override
  HouseholdMonthlyStatisticsByMonthProvider getProviderOverride(
    covariant HouseholdMonthlyStatisticsByMonthProvider provider,
  ) {
    return call(provider.month);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'householdMonthlyStatisticsByMonthProvider';
}

/// 특정 월 통계 Provider (통계 화면 전용 - 독립 월 파라미터)
///
/// Copied from [householdMonthlyStatisticsByMonth].
class HouseholdMonthlyStatisticsByMonthProvider
    extends AutoDisposeFutureProvider<MonthlyStatisticsModel> {
  /// 특정 월 통계 Provider (통계 화면 전용 - 독립 월 파라미터)
  ///
  /// Copied from [householdMonthlyStatisticsByMonth].
  HouseholdMonthlyStatisticsByMonthProvider(String month)
    : this._internal(
        (ref) => householdMonthlyStatisticsByMonth(
          ref as HouseholdMonthlyStatisticsByMonthRef,
          month,
        ),
        from: householdMonthlyStatisticsByMonthProvider,
        name: r'householdMonthlyStatisticsByMonthProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$householdMonthlyStatisticsByMonthHash,
        dependencies: HouseholdMonthlyStatisticsByMonthFamily._dependencies,
        allTransitiveDependencies:
            HouseholdMonthlyStatisticsByMonthFamily._allTransitiveDependencies,
        month: month,
      );

  HouseholdMonthlyStatisticsByMonthProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.month,
  }) : super.internal();

  final String month;

  @override
  Override overrideWith(
    FutureOr<MonthlyStatisticsModel> Function(
      HouseholdMonthlyStatisticsByMonthRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HouseholdMonthlyStatisticsByMonthProvider._internal(
        (ref) => create(ref as HouseholdMonthlyStatisticsByMonthRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        month: month,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<MonthlyStatisticsModel> createElement() {
    return _HouseholdMonthlyStatisticsByMonthProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HouseholdMonthlyStatisticsByMonthProvider &&
        other.month == month;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, month.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HouseholdMonthlyStatisticsByMonthRef
    on AutoDisposeFutureProviderRef<MonthlyStatisticsModel> {
  /// The parameter `month` of this provider.
  String get month;
}

class _HouseholdMonthlyStatisticsByMonthProviderElement
    extends AutoDisposeFutureProviderElement<MonthlyStatisticsModel>
    with HouseholdMonthlyStatisticsByMonthRef {
  _HouseholdMonthlyStatisticsByMonthProviderElement(super.provider);

  @override
  String get month =>
      (origin as HouseholdMonthlyStatisticsByMonthProvider).month;
}

String _$householdYearlyStatisticsHash() =>
    r'2119a3c2848004c7a9e663eed631ba749b5ee23d';

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

String _$householdBudgetTemplatesHash() =>
    r'81876a64a3a4146ebe93855d029611a60bd78d73';

/// 예산 템플릿 목록 Provider
///
/// Copied from [householdBudgetTemplates].
@ProviderFor(householdBudgetTemplates)
final householdBudgetTemplatesProvider =
    AutoDisposeFutureProvider<List<BudgetTemplateModel>>.internal(
      householdBudgetTemplates,
      name: r'householdBudgetTemplatesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$householdBudgetTemplatesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HouseholdBudgetTemplatesRef =
    AutoDisposeFutureProviderRef<List<BudgetTemplateModel>>;
String _$householdBudgetsHash() => r'95f6ade3d310c67438bd66c888c5ae97c7781ab6';

/// 카테고리별 예산 목록 Provider
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
String _$householdGroupBudgetHash() =>
    r'820aaa5b5df64e89653546f7f8da8b63a6916682';

/// 그룹 전체 예산 Provider
///
/// Copied from [householdGroupBudget].
@ProviderFor(householdGroupBudget)
final householdGroupBudgetProvider =
    AutoDisposeFutureProvider<GroupBudgetModel?>.internal(
      householdGroupBudget,
      name: r'householdGroupBudgetProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$householdGroupBudgetHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HouseholdGroupBudgetRef =
    AutoDisposeFutureProviderRef<GroupBudgetModel?>;
String _$householdGroupBudgetTemplateHash() =>
    r'a6b2115ef0f7d856cb9865ec496a67597ad3f463';

/// 그룹 전체 예산 템플릿 Provider
///
/// Copied from [householdGroupBudgetTemplate].
@ProviderFor(householdGroupBudgetTemplate)
final householdGroupBudgetTemplateProvider =
    AutoDisposeFutureProvider<GroupBudgetTemplateModel?>.internal(
      householdGroupBudgetTemplate,
      name: r'householdGroupBudgetTemplateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$householdGroupBudgetTemplateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HouseholdGroupBudgetTemplateRef =
    AutoDisposeFutureProviderRef<GroupBudgetTemplateModel?>;
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
