// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedDateTasksHash() => r'467c6c95bc14110e97e3263b46029ce35d671a94';

/// 선택된 날짜의 Task Provider
///
/// Copied from [selectedDateTasks].
@ProviderFor(selectedDateTasks)
final selectedDateTasksProvider =
    AutoDisposeFutureProvider<List<TaskModel>>.internal(
      selectedDateTasks,
      name: r'selectedDateTasksProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedDateTasksHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedDateTasksRef = AutoDisposeFutureProviderRef<List<TaskModel>>;
String _$taskCountByDateHash() => r'8eaaf1623e16e7279e6b9a50988bd816f704e28d';

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

/// 날짜별 Task 개수 Provider (캘린더 마커용)
///
/// Copied from [taskCountByDate].
@ProviderFor(taskCountByDate)
const taskCountByDateProvider = TaskCountByDateFamily();

/// 날짜별 Task 개수 Provider (캘린더 마커용)
///
/// Copied from [taskCountByDate].
class TaskCountByDateFamily extends Family<Map<DateTime, int>> {
  /// 날짜별 Task 개수 Provider (캘린더 마커용)
  ///
  /// Copied from [taskCountByDate].
  const TaskCountByDateFamily();

  /// 날짜별 Task 개수 Provider (캘린더 마커용)
  ///
  /// Copied from [taskCountByDate].
  TaskCountByDateProvider call(int year, int month) {
    return TaskCountByDateProvider(year, month);
  }

  @override
  TaskCountByDateProvider getProviderOverride(
    covariant TaskCountByDateProvider provider,
  ) {
    return call(provider.year, provider.month);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'taskCountByDateProvider';
}

/// 날짜별 Task 개수 Provider (캘린더 마커용)
///
/// Copied from [taskCountByDate].
class TaskCountByDateProvider extends AutoDisposeProvider<Map<DateTime, int>> {
  /// 날짜별 Task 개수 Provider (캘린더 마커용)
  ///
  /// Copied from [taskCountByDate].
  TaskCountByDateProvider(int year, int month)
    : this._internal(
        (ref) => taskCountByDate(ref as TaskCountByDateRef, year, month),
        from: taskCountByDateProvider,
        name: r'taskCountByDateProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$taskCountByDateHash,
        dependencies: TaskCountByDateFamily._dependencies,
        allTransitiveDependencies:
            TaskCountByDateFamily._allTransitiveDependencies,
        year: year,
        month: month,
      );

  TaskCountByDateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
    required this.month,
  }) : super.internal();

  final int year;
  final int month;

  @override
  Override overrideWith(
    Map<DateTime, int> Function(TaskCountByDateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TaskCountByDateProvider._internal(
        (ref) => create(ref as TaskCountByDateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        year: year,
        month: month,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Map<DateTime, int>> createElement() {
    return _TaskCountByDateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskCountByDateProvider &&
        other.year == year &&
        other.month == month;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);
    hash = _SystemHash.combine(hash, month.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TaskCountByDateRef on AutoDisposeProviderRef<Map<DateTime, int>> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _TaskCountByDateProviderElement
    extends AutoDisposeProviderElement<Map<DateTime, int>>
    with TaskCountByDateRef {
  _TaskCountByDateProviderElement(super.provider);

  @override
  int get year => (origin as TaskCountByDateProvider).year;
  @override
  int get month => (origin as TaskCountByDateProvider).month;
}

String _$taskDetailHash() => r'1abb5635d0913b733ab3d6fe15dfe508e61959f3';

/// Task 상세 Provider
///
/// Copied from [taskDetail].
@ProviderFor(taskDetail)
const taskDetailProvider = TaskDetailFamily();

/// Task 상세 Provider
///
/// Copied from [taskDetail].
class TaskDetailFamily extends Family<AsyncValue<TaskDetailModel>> {
  /// Task 상세 Provider
  ///
  /// Copied from [taskDetail].
  const TaskDetailFamily();

  /// Task 상세 Provider
  ///
  /// Copied from [taskDetail].
  TaskDetailProvider call(String id) {
    return TaskDetailProvider(id);
  }

  @override
  TaskDetailProvider getProviderOverride(
    covariant TaskDetailProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'taskDetailProvider';
}

/// Task 상세 Provider
///
/// Copied from [taskDetail].
class TaskDetailProvider extends AutoDisposeFutureProvider<TaskDetailModel> {
  /// Task 상세 Provider
  ///
  /// Copied from [taskDetail].
  TaskDetailProvider(String id)
    : this._internal(
        (ref) => taskDetail(ref as TaskDetailRef, id),
        from: taskDetailProvider,
        name: r'taskDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$taskDetailHash,
        dependencies: TaskDetailFamily._dependencies,
        allTransitiveDependencies: TaskDetailFamily._allTransitiveDependencies,
        id: id,
      );

  TaskDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<TaskDetailModel> Function(TaskDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TaskDetailProvider._internal(
        (ref) => create(ref as TaskDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TaskDetailModel> createElement() {
    return _TaskDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TaskDetailRef on AutoDisposeFutureProviderRef<TaskDetailModel> {
  /// The parameter `id` of this provider.
  String get id;
}

class _TaskDetailProviderElement
    extends AutoDisposeFutureProviderElement<TaskDetailModel>
    with TaskDetailRef {
  _TaskDetailProviderElement(super.provider);

  @override
  String get id => (origin as TaskDetailProvider).id;
}

String _$todoSelectedDateTasksHash() =>
    r'd9fd00a091988e48338e35fc310ec4edb56afdc8';

/// 선택된 날짜의 할일 목록 Provider (시작일~마감일 사이에 해당 날짜가 포함된 경우)
///
/// Copied from [todoSelectedDateTasks].
@ProviderFor(todoSelectedDateTasks)
final todoSelectedDateTasksProvider =
    AutoDisposeFutureProvider<List<TaskModel>>.internal(
      todoSelectedDateTasks,
      name: r'todoSelectedDateTasksProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$todoSelectedDateTasksHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodoSelectedDateTasksRef =
    AutoDisposeFutureProviderRef<List<TaskModel>>;
String _$todoCountByDateHash() => r'ee7302cc1eaf2ba50bef0d1f591dfafbcec568fd';

/// 주간 날짜별 할일 개수 Provider (캘린더 마커용)
///
/// Copied from [todoCountByDate].
@ProviderFor(todoCountByDate)
final todoCountByDateProvider =
    AutoDisposeProvider<Map<DateTime, int>>.internal(
      todoCountByDate,
      name: r'todoCountByDateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$todoCountByDateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodoCountByDateRef = AutoDisposeProviderRef<Map<DateTime, int>>;
String _$categoriesHash() => r'64b6e78fe81e55e84168f6136a92eef20189a259';

/// 카테고리 목록 Provider (groupId 파라미터 지원)
///
/// Copied from [categories].
@ProviderFor(categories)
const categoriesProvider = CategoriesFamily();

/// 카테고리 목록 Provider (groupId 파라미터 지원)
///
/// Copied from [categories].
class CategoriesFamily extends Family<AsyncValue<List<CategoryModel>>> {
  /// 카테고리 목록 Provider (groupId 파라미터 지원)
  ///
  /// Copied from [categories].
  const CategoriesFamily();

  /// 카테고리 목록 Provider (groupId 파라미터 지원)
  ///
  /// Copied from [categories].
  CategoriesProvider call({String? groupId}) {
    return CategoriesProvider(groupId: groupId);
  }

  @override
  CategoriesProvider getProviderOverride(
    covariant CategoriesProvider provider,
  ) {
    return call(groupId: provider.groupId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'categoriesProvider';
}

/// 카테고리 목록 Provider (groupId 파라미터 지원)
///
/// Copied from [categories].
class CategoriesProvider
    extends AutoDisposeFutureProvider<List<CategoryModel>> {
  /// 카테고리 목록 Provider (groupId 파라미터 지원)
  ///
  /// Copied from [categories].
  CategoriesProvider({String? groupId})
    : this._internal(
        (ref) => categories(ref as CategoriesRef, groupId: groupId),
        from: categoriesProvider,
        name: r'categoriesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$categoriesHash,
        dependencies: CategoriesFamily._dependencies,
        allTransitiveDependencies: CategoriesFamily._allTransitiveDependencies,
        groupId: groupId,
      );

  CategoriesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.groupId,
  }) : super.internal();

  final String? groupId;

  @override
  Override overrideWith(
    FutureOr<List<CategoryModel>> Function(CategoriesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CategoriesProvider._internal(
        (ref) => create(ref as CategoriesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        groupId: groupId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CategoryModel>> createElement() {
    return _CategoriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoriesProvider && other.groupId == groupId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CategoriesRef on AutoDisposeFutureProviderRef<List<CategoryModel>> {
  /// The parameter `groupId` of this provider.
  String? get groupId;
}

class _CategoriesProviderElement
    extends AutoDisposeFutureProviderElement<List<CategoryModel>>
    with CategoriesRef {
  _CategoriesProviderElement(super.provider);

  @override
  String? get groupId => (origin as CategoriesProvider).groupId;
}

String _$selectedGroupCategoriesHash() =>
    r'477219df0000b5fed9e4134e78e4cfa8613ad75d';

/// 현재 선택된 그룹의 카테고리 목록 Provider
///
/// Copied from [selectedGroupCategories].
@ProviderFor(selectedGroupCategories)
final selectedGroupCategoriesProvider =
    AutoDisposeFutureProvider<List<CategoryModel>>.internal(
      selectedGroupCategories,
      name: r'selectedGroupCategoriesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedGroupCategoriesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedGroupCategoriesRef =
    AutoDisposeFutureProviderRef<List<CategoryModel>>;
String _$monthlyTasksHash() => r'438eb7be2cab042ddff723a76942d98f4ef9e05e';

abstract class _$MonthlyTasks
    extends BuildlessAutoDisposeAsyncNotifier<List<TaskModel>> {
  late final int year;
  late final int month;

  FutureOr<List<TaskModel>> build(int year, int month);
}

/// 월간 Task Provider (캘린더 뷰용) - 그룹/카테고리 필터 지원
///
/// Copied from [MonthlyTasks].
@ProviderFor(MonthlyTasks)
const monthlyTasksProvider = MonthlyTasksFamily();

/// 월간 Task Provider (캘린더 뷰용) - 그룹/카테고리 필터 지원
///
/// Copied from [MonthlyTasks].
class MonthlyTasksFamily extends Family<AsyncValue<List<TaskModel>>> {
  /// 월간 Task Provider (캘린더 뷰용) - 그룹/카테고리 필터 지원
  ///
  /// Copied from [MonthlyTasks].
  const MonthlyTasksFamily();

  /// 월간 Task Provider (캘린더 뷰용) - 그룹/카테고리 필터 지원
  ///
  /// Copied from [MonthlyTasks].
  MonthlyTasksProvider call(int year, int month) {
    return MonthlyTasksProvider(year, month);
  }

  @override
  MonthlyTasksProvider getProviderOverride(
    covariant MonthlyTasksProvider provider,
  ) {
    return call(provider.year, provider.month);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'monthlyTasksProvider';
}

/// 월간 Task Provider (캘린더 뷰용) - 그룹/카테고리 필터 지원
///
/// Copied from [MonthlyTasks].
class MonthlyTasksProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<MonthlyTasks, List<TaskModel>> {
  /// 월간 Task Provider (캘린더 뷰용) - 그룹/카테고리 필터 지원
  ///
  /// Copied from [MonthlyTasks].
  MonthlyTasksProvider(int year, int month)
    : this._internal(
        () => MonthlyTasks()
          ..year = year
          ..month = month,
        from: monthlyTasksProvider,
        name: r'monthlyTasksProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$monthlyTasksHash,
        dependencies: MonthlyTasksFamily._dependencies,
        allTransitiveDependencies:
            MonthlyTasksFamily._allTransitiveDependencies,
        year: year,
        month: month,
      );

  MonthlyTasksProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
    required this.month,
  }) : super.internal();

  final int year;
  final int month;

  @override
  FutureOr<List<TaskModel>> runNotifierBuild(covariant MonthlyTasks notifier) {
    return notifier.build(year, month);
  }

  @override
  Override overrideWith(MonthlyTasks Function() create) {
    return ProviderOverride(
      origin: this,
      override: MonthlyTasksProvider._internal(
        () => create()
          ..year = year
          ..month = month,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        year: year,
        month: month,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<MonthlyTasks, List<TaskModel>>
  createElement() {
    return _MonthlyTasksProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyTasksProvider &&
        other.year == year &&
        other.month == month;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);
    hash = _SystemHash.combine(hash, month.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MonthlyTasksRef on AutoDisposeAsyncNotifierProviderRef<List<TaskModel>> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _MonthlyTasksProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<MonthlyTasks, List<TaskModel>>
    with MonthlyTasksRef {
  _MonthlyTasksProviderElement(super.provider);

  @override
  int get year => (origin as MonthlyTasksProvider).year;
  @override
  int get month => (origin as MonthlyTasksProvider).month;
}

String _$todoTasksHash() => r'a4b87f1a51519f4f6536f786f6f39373ae702010';

abstract class _$TodoTasks
    extends BuildlessAutoDisposeAsyncNotifier<TaskListResponse> {
  late final int page;

  FutureOr<TaskListResponse> build({int page = 1});
}

/// Todo 목록 Provider (할일 뷰용) - 주간 날짜 범위 기반 조회
///
/// Copied from [TodoTasks].
@ProviderFor(TodoTasks)
const todoTasksProvider = TodoTasksFamily();

/// Todo 목록 Provider (할일 뷰용) - 주간 날짜 범위 기반 조회
///
/// Copied from [TodoTasks].
class TodoTasksFamily extends Family<AsyncValue<TaskListResponse>> {
  /// Todo 목록 Provider (할일 뷰용) - 주간 날짜 범위 기반 조회
  ///
  /// Copied from [TodoTasks].
  const TodoTasksFamily();

  /// Todo 목록 Provider (할일 뷰용) - 주간 날짜 범위 기반 조회
  ///
  /// Copied from [TodoTasks].
  TodoTasksProvider call({int page = 1}) {
    return TodoTasksProvider(page: page);
  }

  @override
  TodoTasksProvider getProviderOverride(covariant TodoTasksProvider provider) {
    return call(page: provider.page);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'todoTasksProvider';
}

/// Todo 목록 Provider (할일 뷰용) - 주간 날짜 범위 기반 조회
///
/// Copied from [TodoTasks].
class TodoTasksProvider
    extends AutoDisposeAsyncNotifierProviderImpl<TodoTasks, TaskListResponse> {
  /// Todo 목록 Provider (할일 뷰용) - 주간 날짜 범위 기반 조회
  ///
  /// Copied from [TodoTasks].
  TodoTasksProvider({int page = 1})
    : this._internal(
        () => TodoTasks()..page = page,
        from: todoTasksProvider,
        name: r'todoTasksProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$todoTasksHash,
        dependencies: TodoTasksFamily._dependencies,
        allTransitiveDependencies: TodoTasksFamily._allTransitiveDependencies,
        page: page,
      );

  TodoTasksProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
  }) : super.internal();

  final int page;

  @override
  FutureOr<TaskListResponse> runNotifierBuild(covariant TodoTasks notifier) {
    return notifier.build(page: page);
  }

  @override
  Override overrideWith(TodoTasks Function() create) {
    return ProviderOverride(
      origin: this,
      override: TodoTasksProvider._internal(
        () => create()..page = page,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<TodoTasks, TaskListResponse>
  createElement() {
    return _TodoTasksProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TodoTasksProvider && other.page == page;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TodoTasksRef on AutoDisposeAsyncNotifierProviderRef<TaskListResponse> {
  /// The parameter `page` of this provider.
  int get page;
}

class _TodoTasksProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<TodoTasks, TaskListResponse>
    with TodoTasksRef {
  _TodoTasksProviderElement(super.provider);

  @override
  int get page => (origin as TodoTasksProvider).page;
}

String _$todoOverviewTasksHash() => r'ce5834c8aa79c59add03cb47def0695f2bc14ac5';

/// 모아 보기용 전체 할일 목록 Provider (날짜 제한 없이 조회)
///
/// Copied from [TodoOverviewTasks].
@ProviderFor(TodoOverviewTasks)
final todoOverviewTasksProvider =
    AutoDisposeAsyncNotifierProvider<
      TodoOverviewTasks,
      TaskListResponse
    >.internal(
      TodoOverviewTasks.new,
      name: r'todoOverviewTasksProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$todoOverviewTasksHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TodoOverviewTasks = AutoDisposeAsyncNotifier<TaskListResponse>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
