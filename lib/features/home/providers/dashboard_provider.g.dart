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
    r'4fccd6bd6109d42c7c1ec7ba78a800abf8edb301';

/// 대시보드 자산 통계 (대시보드 전용) - 자산 탭 그룹 선택 상태와 독립
///
/// [selectedGroupId] null = 첫 번째 그룹 자동 선택
///
/// Copied from [dashboardAssetStatistics].
@ProviderFor(dashboardAssetStatistics)
const dashboardAssetStatisticsProvider = DashboardAssetStatisticsFamily();

/// 대시보드 자산 통계 (대시보드 전용) - 자산 탭 그룹 선택 상태와 독립
///
/// [selectedGroupId] null = 첫 번째 그룹 자동 선택
///
/// Copied from [dashboardAssetStatistics].
class DashboardAssetStatisticsFamily
    extends Family<AsyncValue<AssetStatisticsModel>> {
  /// 대시보드 자산 통계 (대시보드 전용) - 자산 탭 그룹 선택 상태와 독립
  ///
  /// [selectedGroupId] null = 첫 번째 그룹 자동 선택
  ///
  /// Copied from [dashboardAssetStatistics].
  const DashboardAssetStatisticsFamily();

  /// 대시보드 자산 통계 (대시보드 전용) - 자산 탭 그룹 선택 상태와 독립
  ///
  /// [selectedGroupId] null = 첫 번째 그룹 자동 선택
  ///
  /// Copied from [dashboardAssetStatistics].
  DashboardAssetStatisticsProvider call({String? selectedGroupId}) {
    return DashboardAssetStatisticsProvider(selectedGroupId: selectedGroupId);
  }

  @override
  DashboardAssetStatisticsProvider getProviderOverride(
    covariant DashboardAssetStatisticsProvider provider,
  ) {
    return call(selectedGroupId: provider.selectedGroupId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dashboardAssetStatisticsProvider';
}

/// 대시보드 자산 통계 (대시보드 전용) - 자산 탭 그룹 선택 상태와 독립
///
/// [selectedGroupId] null = 첫 번째 그룹 자동 선택
///
/// Copied from [dashboardAssetStatistics].
class DashboardAssetStatisticsProvider
    extends AutoDisposeFutureProvider<AssetStatisticsModel> {
  /// 대시보드 자산 통계 (대시보드 전용) - 자산 탭 그룹 선택 상태와 독립
  ///
  /// [selectedGroupId] null = 첫 번째 그룹 자동 선택
  ///
  /// Copied from [dashboardAssetStatistics].
  DashboardAssetStatisticsProvider({String? selectedGroupId})
    : this._internal(
        (ref) => dashboardAssetStatistics(
          ref as DashboardAssetStatisticsRef,
          selectedGroupId: selectedGroupId,
        ),
        from: dashboardAssetStatisticsProvider,
        name: r'dashboardAssetStatisticsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$dashboardAssetStatisticsHash,
        dependencies: DashboardAssetStatisticsFamily._dependencies,
        allTransitiveDependencies:
            DashboardAssetStatisticsFamily._allTransitiveDependencies,
        selectedGroupId: selectedGroupId,
      );

  DashboardAssetStatisticsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.selectedGroupId,
  }) : super.internal();

  final String? selectedGroupId;

  @override
  Override overrideWith(
    FutureOr<AssetStatisticsModel> Function(
      DashboardAssetStatisticsRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DashboardAssetStatisticsProvider._internal(
        (ref) => create(ref as DashboardAssetStatisticsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        selectedGroupId: selectedGroupId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AssetStatisticsModel> createElement() {
    return _DashboardAssetStatisticsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DashboardAssetStatisticsProvider &&
        other.selectedGroupId == selectedGroupId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, selectedGroupId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DashboardAssetStatisticsRef
    on AutoDisposeFutureProviderRef<AssetStatisticsModel> {
  /// The parameter `selectedGroupId` of this provider.
  String? get selectedGroupId;
}

class _DashboardAssetStatisticsProviderElement
    extends AutoDisposeFutureProviderElement<AssetStatisticsModel>
    with DashboardAssetStatisticsRef {
  _DashboardAssetStatisticsProviderElement(super.provider);

  @override
  String? get selectedGroupId =>
      (origin as DashboardAssetStatisticsProvider).selectedGroupId;
}

String _$dashboardMemosHash() => r'286363aaa844785258f55027272858bb57a6e839';

/// 대시보드 메모 요약 - 핀된 메모 목록 위임
///
/// [selectedGroupId] null = 전체 그룹
///
/// Copied from [dashboardMemos].
@ProviderFor(dashboardMemos)
const dashboardMemosProvider = DashboardMemosFamily();

/// 대시보드 메모 요약 - 핀된 메모 목록 위임
///
/// [selectedGroupId] null = 전체 그룹
///
/// Copied from [dashboardMemos].
class DashboardMemosFamily extends Family<AsyncValue<List<MemoModel>>> {
  /// 대시보드 메모 요약 - 핀된 메모 목록 위임
  ///
  /// [selectedGroupId] null = 전체 그룹
  ///
  /// Copied from [dashboardMemos].
  const DashboardMemosFamily();

  /// 대시보드 메모 요약 - 핀된 메모 목록 위임
  ///
  /// [selectedGroupId] null = 전체 그룹
  ///
  /// Copied from [dashboardMemos].
  DashboardMemosProvider call({
    String? selectedGroupId,
    bool personalOnly = false,
  }) {
    return DashboardMemosProvider(
      selectedGroupId: selectedGroupId,
      personalOnly: personalOnly,
    );
  }

  @override
  DashboardMemosProvider getProviderOverride(
    covariant DashboardMemosProvider provider,
  ) {
    return call(
      selectedGroupId: provider.selectedGroupId,
      personalOnly: provider.personalOnly,
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
  String? get name => r'dashboardMemosProvider';
}

/// 대시보드 메모 요약 - 핀된 메모 목록 위임
///
/// [selectedGroupId] null = 전체 그룹
///
/// Copied from [dashboardMemos].
class DashboardMemosProvider
    extends AutoDisposeFutureProvider<List<MemoModel>> {
  /// 대시보드 메모 요약 - 핀된 메모 목록 위임
  ///
  /// [selectedGroupId] null = 전체 그룹
  ///
  /// Copied from [dashboardMemos].
  DashboardMemosProvider({String? selectedGroupId, bool personalOnly = false})
    : this._internal(
        (ref) => dashboardMemos(
          ref as DashboardMemosRef,
          selectedGroupId: selectedGroupId,
          personalOnly: personalOnly,
        ),
        from: dashboardMemosProvider,
        name: r'dashboardMemosProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$dashboardMemosHash,
        dependencies: DashboardMemosFamily._dependencies,
        allTransitiveDependencies:
            DashboardMemosFamily._allTransitiveDependencies,
        selectedGroupId: selectedGroupId,
        personalOnly: personalOnly,
      );

  DashboardMemosProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.selectedGroupId,
    required this.personalOnly,
  }) : super.internal();

  final String? selectedGroupId;
  final bool personalOnly;

  @override
  Override overrideWith(
    FutureOr<List<MemoModel>> Function(DashboardMemosRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DashboardMemosProvider._internal(
        (ref) => create(ref as DashboardMemosRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        selectedGroupId: selectedGroupId,
        personalOnly: personalOnly,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<MemoModel>> createElement() {
    return _DashboardMemosProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DashboardMemosProvider &&
        other.selectedGroupId == selectedGroupId &&
        other.personalOnly == personalOnly;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, selectedGroupId.hashCode);
    hash = _SystemHash.combine(hash, personalOnly.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DashboardMemosRef on AutoDisposeFutureProviderRef<List<MemoModel>> {
  /// The parameter `selectedGroupId` of this provider.
  String? get selectedGroupId;

  /// The parameter `personalOnly` of this provider.
  bool get personalOnly;
}

class _DashboardMemosProviderElement
    extends AutoDisposeFutureProviderElement<List<MemoModel>>
    with DashboardMemosRef {
  _DashboardMemosProviderElement(super.provider);

  @override
  String? get selectedGroupId =>
      (origin as DashboardMemosProvider).selectedGroupId;
  @override
  bool get personalOnly => (origin as DashboardMemosProvider).personalOnly;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
