// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'household_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$householdMonthlyStatisticsHash() =>
    r'7fa7509c711da17e4479a1c01180be627de3d7b4';

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
    r'62c4e8e045f5c59483635094e97d57434d42cbe8';

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

/// 특정 월 통계 Provider (통계 화면 전용 - 환불/이월 항상 제외)
///
/// Copied from [householdMonthlyStatisticsByMonth].
@ProviderFor(householdMonthlyStatisticsByMonth)
const householdMonthlyStatisticsByMonthProvider =
    HouseholdMonthlyStatisticsByMonthFamily();

/// 특정 월 통계 Provider (통계 화면 전용 - 환불/이월 항상 제외)
///
/// Copied from [householdMonthlyStatisticsByMonth].
class HouseholdMonthlyStatisticsByMonthFamily
    extends Family<AsyncValue<MonthlyStatisticsModel>> {
  /// 특정 월 통계 Provider (통계 화면 전용 - 환불/이월 항상 제외)
  ///
  /// Copied from [householdMonthlyStatisticsByMonth].
  const HouseholdMonthlyStatisticsByMonthFamily();

  /// 특정 월 통계 Provider (통계 화면 전용 - 환불/이월 항상 제외)
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

/// 특정 월 통계 Provider (통계 화면 전용 - 환불/이월 항상 제외)
///
/// Copied from [householdMonthlyStatisticsByMonth].
class HouseholdMonthlyStatisticsByMonthProvider
    extends AutoDisposeFutureProvider<MonthlyStatisticsModel> {
  /// 특정 월 통계 Provider (통계 화면 전용 - 환불/이월 항상 제외)
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
    r'4a63eb3f359c036b8b25dafb6a32dc4d29e13ab6';

/// 연간 통계 Provider (통계 화면 전용 - 환불/이월 항상 제외)
///
/// Copied from [householdYearlyStatistics].
@ProviderFor(householdYearlyStatistics)
const householdYearlyStatisticsProvider = HouseholdYearlyStatisticsFamily();

/// 연간 통계 Provider (통계 화면 전용 - 환불/이월 항상 제외)
///
/// Copied from [householdYearlyStatistics].
class HouseholdYearlyStatisticsFamily
    extends Family<AsyncValue<YearlyStatisticsModel>> {
  /// 연간 통계 Provider (통계 화면 전용 - 환불/이월 항상 제외)
  ///
  /// Copied from [householdYearlyStatistics].
  const HouseholdYearlyStatisticsFamily();

  /// 연간 통계 Provider (통계 화면 전용 - 환불/이월 항상 제외)
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

/// 연간 통계 Provider (통계 화면 전용 - 환불/이월 항상 제외)
///
/// Copied from [householdYearlyStatistics].
class HouseholdYearlyStatisticsProvider
    extends AutoDisposeFutureProvider<YearlyStatisticsModel> {
  /// 연간 통계 Provider (통계 화면 전용 - 환불/이월 항상 제외)
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
    r'a72c6d4b63154792c599024da65de36969012315';

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
String _$householdBudgetsHash() => r'3a902a1686e5bc97fe834b6e437492b664158e86';

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
    r'd66dd9c9c5f2138ba453679e40eda915453ddefa';

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
    r'ccc9debee4245bbfbc36a70a72fae1c90ad2908c';

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
String _$householdExpensesHash() => r'5bbed8b4cb0e2764f022d998bac655b8f8d687e0';

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
    r'f537bdda80d450c619ea22dd75c1474eab77cb85';

/// 고정지출 목록 Provider
///
/// Copied from [HouseholdRecurringExpenses].
@ProviderFor(HouseholdRecurringExpenses)
final householdRecurringExpensesProvider =
    AutoDisposeAsyncNotifierProvider<
      HouseholdRecurringExpenses,
      List<RecurringExpenseModel>
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
    AutoDisposeAsyncNotifier<List<RecurringExpenseModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
