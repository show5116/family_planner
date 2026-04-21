// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dashboardTodayTasksHash() =>
    r'a5dcd9a8029c5b91b8be8b94b61d5e92d357713a';

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

/// 대시보드 일정 (대시보드 전용) - 모드/그룹 필터에 따라 조회
///
/// Copied from [dashboardTodayTasks].
@ProviderFor(dashboardTodayTasks)
const dashboardTodayTasksProvider = DashboardTodayTasksFamily();

/// 대시보드 일정 (대시보드 전용) - 모드/그룹 필터에 따라 조회
///
/// Copied from [dashboardTodayTasks].
class DashboardTodayTasksFamily extends Family<AsyncValue<List<TaskModel>>> {
  /// 대시보드 일정 (대시보드 전용) - 모드/그룹 필터에 따라 조회
  ///
  /// Copied from [dashboardTodayTasks].
  const DashboardTodayTasksFamily();

  /// 대시보드 일정 (대시보드 전용) - 모드/그룹 필터에 따라 조회
  ///
  /// Copied from [dashboardTodayTasks].
  DashboardTodayTasksProvider call({
    ScheduleViewMode mode = ScheduleViewMode.today,
    List<String>? selectedGroupIds,
    bool includePersonal = true,
  }) {
    return DashboardTodayTasksProvider(
      mode: mode,
      selectedGroupIds: selectedGroupIds,
      includePersonal: includePersonal,
    );
  }

  @override
  DashboardTodayTasksProvider getProviderOverride(
    covariant DashboardTodayTasksProvider provider,
  ) {
    return call(
      mode: provider.mode,
      selectedGroupIds: provider.selectedGroupIds,
      includePersonal: provider.includePersonal,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dashboardTodayTasksProvider';
}

/// 대시보드 일정 (대시보드 전용) - 모드/그룹 필터에 따라 조회
///
/// Copied from [dashboardTodayTasks].
class DashboardTodayTasksProvider
    extends AutoDisposeFutureProvider<List<TaskModel>> {
  /// 대시보드 일정 (대시보드 전용) - 모드/그룹 필터에 따라 조회
  ///
  /// Copied from [dashboardTodayTasks].
  DashboardTodayTasksProvider({
    ScheduleViewMode mode = ScheduleViewMode.today,
    List<String>? selectedGroupIds,
    bool includePersonal = true,
  }) : this._internal(
         (ref) => dashboardTodayTasks(
           ref as DashboardTodayTasksRef,
           mode: mode,
           selectedGroupIds: selectedGroupIds,
           includePersonal: includePersonal,
         ),
         from: dashboardTodayTasksProvider,
         name: r'dashboardTodayTasksProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$dashboardTodayTasksHash,
         dependencies: DashboardTodayTasksFamily._dependencies,
         allTransitiveDependencies:
             DashboardTodayTasksFamily._allTransitiveDependencies,
         mode: mode,
         selectedGroupIds: selectedGroupIds,
         includePersonal: includePersonal,
       );

  DashboardTodayTasksProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mode,
    required this.selectedGroupIds,
    required this.includePersonal,
  }) : super.internal();

  final ScheduleViewMode mode;
  final List<String>? selectedGroupIds;
  final bool includePersonal;

  @override
  Override overrideWith(
    FutureOr<List<TaskModel>> Function(DashboardTodayTasksRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DashboardTodayTasksProvider._internal(
        (ref) => create(ref as DashboardTodayTasksRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mode: mode,
        selectedGroupIds: selectedGroupIds,
        includePersonal: includePersonal,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<TaskModel>> createElement() {
    return _DashboardTodayTasksProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DashboardTodayTasksProvider &&
        other.mode == mode &&
        other.selectedGroupIds == selectedGroupIds &&
        other.includePersonal == includePersonal;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mode.hashCode);
    hash = _SystemHash.combine(hash, selectedGroupIds.hashCode);
    hash = _SystemHash.combine(hash, includePersonal.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DashboardTodayTasksRef on AutoDisposeFutureProviderRef<List<TaskModel>> {
  /// The parameter `mode` of this provider.
  ScheduleViewMode get mode;

  /// The parameter `selectedGroupIds` of this provider.
  List<String>? get selectedGroupIds;

  /// The parameter `includePersonal` of this provider.
  bool get includePersonal;
}

class _DashboardTodayTasksProviderElement
    extends AutoDisposeFutureProviderElement<List<TaskModel>>
    with DashboardTodayTasksRef {
  _DashboardTodayTasksProviderElement(super.provider);

  @override
  ScheduleViewMode get mode => (origin as DashboardTodayTasksProvider).mode;
  @override
  List<String>? get selectedGroupIds =>
      (origin as DashboardTodayTasksProvider).selectedGroupIds;
  @override
  bool get includePersonal =>
      (origin as DashboardTodayTasksProvider).includePersonal;
}

String _$dashboardTodoTasksHash() =>
    r'0a3822b4c1321fa74b9c71c3ae6d4a5f09626cd4';

/// 대시보드 할일 요약 (대시보드 전용) - 모드/그룹 필터에 따라 조회
///
/// Copied from [dashboardTodoTasks].
@ProviderFor(dashboardTodoTasks)
const dashboardTodoTasksProvider = DashboardTodoTasksFamily();

/// 대시보드 할일 요약 (대시보드 전용) - 모드/그룹 필터에 따라 조회
///
/// Copied from [dashboardTodoTasks].
class DashboardTodoTasksFamily extends Family<AsyncValue<List<TaskModel>>> {
  /// 대시보드 할일 요약 (대시보드 전용) - 모드/그룹 필터에 따라 조회
  ///
  /// Copied from [dashboardTodoTasks].
  const DashboardTodoTasksFamily();

  /// 대시보드 할일 요약 (대시보드 전용) - 모드/그룹 필터에 따라 조회
  ///
  /// Copied from [dashboardTodoTasks].
  DashboardTodoTasksProvider call({
    ScheduleViewMode mode = ScheduleViewMode.today,
    List<String>? selectedGroupIds,
    bool includePersonal = true,
  }) {
    return DashboardTodoTasksProvider(
      mode: mode,
      selectedGroupIds: selectedGroupIds,
      includePersonal: includePersonal,
    );
  }

  @override
  DashboardTodoTasksProvider getProviderOverride(
    covariant DashboardTodoTasksProvider provider,
  ) {
    return call(
      mode: provider.mode,
      selectedGroupIds: provider.selectedGroupIds,
      includePersonal: provider.includePersonal,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dashboardTodoTasksProvider';
}

/// 대시보드 할일 요약 (대시보드 전용) - 모드/그룹 필터에 따라 조회
///
/// Copied from [dashboardTodoTasks].
class DashboardTodoTasksProvider
    extends AutoDisposeFutureProvider<List<TaskModel>> {
  /// 대시보드 할일 요약 (대시보드 전용) - 모드/그룹 필터에 따라 조회
  ///
  /// Copied from [dashboardTodoTasks].
  DashboardTodoTasksProvider({
    ScheduleViewMode mode = ScheduleViewMode.today,
    List<String>? selectedGroupIds,
    bool includePersonal = true,
  }) : this._internal(
         (ref) => dashboardTodoTasks(
           ref as DashboardTodoTasksRef,
           mode: mode,
           selectedGroupIds: selectedGroupIds,
           includePersonal: includePersonal,
         ),
         from: dashboardTodoTasksProvider,
         name: r'dashboardTodoTasksProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$dashboardTodoTasksHash,
         dependencies: DashboardTodoTasksFamily._dependencies,
         allTransitiveDependencies:
             DashboardTodoTasksFamily._allTransitiveDependencies,
         mode: mode,
         selectedGroupIds: selectedGroupIds,
         includePersonal: includePersonal,
       );

  DashboardTodoTasksProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mode,
    required this.selectedGroupIds,
    required this.includePersonal,
  }) : super.internal();

  final ScheduleViewMode mode;
  final List<String>? selectedGroupIds;
  final bool includePersonal;

  @override
  Override overrideWith(
    FutureOr<List<TaskModel>> Function(DashboardTodoTasksRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DashboardTodoTasksProvider._internal(
        (ref) => create(ref as DashboardTodoTasksRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mode: mode,
        selectedGroupIds: selectedGroupIds,
        includePersonal: includePersonal,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<TaskModel>> createElement() {
    return _DashboardTodoTasksProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DashboardTodoTasksProvider &&
        other.mode == mode &&
        other.selectedGroupIds == selectedGroupIds &&
        other.includePersonal == includePersonal;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mode.hashCode);
    hash = _SystemHash.combine(hash, selectedGroupIds.hashCode);
    hash = _SystemHash.combine(hash, includePersonal.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DashboardTodoTasksRef on AutoDisposeFutureProviderRef<List<TaskModel>> {
  /// The parameter `mode` of this provider.
  ScheduleViewMode get mode;

  /// The parameter `selectedGroupIds` of this provider.
  List<String>? get selectedGroupIds;

  /// The parameter `includePersonal` of this provider.
  bool get includePersonal;
}

class _DashboardTodoTasksProviderElement
    extends AutoDisposeFutureProviderElement<List<TaskModel>>
    with DashboardTodoTasksRef {
  _DashboardTodoTasksProviderElement(super.provider);

  @override
  ScheduleViewMode get mode => (origin as DashboardTodoTasksProvider).mode;
  @override
  List<String>? get selectedGroupIds =>
      (origin as DashboardTodoTasksProvider).selectedGroupIds;
  @override
  bool get includePersonal =>
      (origin as DashboardTodoTasksProvider).includePersonal;
}

String _$dashboardAssetStatisticsHash() =>
    r'78d741c9bdc65621e737891a354d4ae4924fcac0';

/// 대시보드 자산 통계 (대시보드 전용) - 자산 탭 그룹 선택 상태와 독립
///
/// Copied from [dashboardAssetStatistics].
@ProviderFor(dashboardAssetStatistics)
final dashboardAssetStatisticsProvider =
    AutoDisposeFutureProvider<AssetStatisticsModel>.internal(
      dashboardAssetStatistics,
      name: r'dashboardAssetStatisticsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dashboardAssetStatisticsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DashboardAssetStatisticsRef =
    AutoDisposeFutureProviderRef<AssetStatisticsModel>;
String _$dashboardMemosHash() => r'70952519d520b7df6315fb598899f69eca20b68f';

/// 대시보드 메모 요약 - 핀된 메모 목록 위임
///
/// Copied from [dashboardMemos].
@ProviderFor(dashboardMemos)
final dashboardMemosProvider =
    AutoDisposeFutureProvider<List<MemoModel>>.internal(
      dashboardMemos,
      name: r'dashboardMemosProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dashboardMemosHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DashboardMemosRef = AutoDisposeFutureProviderRef<List<MemoModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
