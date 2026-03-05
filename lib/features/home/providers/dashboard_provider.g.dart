// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dashboardTodayTasksHash() =>
    r'f8559c53ea2176665bfd4d45c04c66914c82c4d2';

/// 오늘의 일정 (대시보드 전용) - 그룹 상태와 무관하게 오늘 날짜 기준 조회
///
/// Copied from [dashboardTodayTasks].
@ProviderFor(dashboardTodayTasks)
final dashboardTodayTasksProvider =
    AutoDisposeFutureProvider<List<TaskModel>>.internal(
      dashboardTodayTasks,
      name: r'dashboardTodayTasksProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dashboardTodayTasksHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DashboardTodayTasksRef = AutoDisposeFutureProviderRef<List<TaskModel>>;
String _$dashboardTodoTasksHash() =>
    r'8983a4973687219561e0fcf03b4d637beadcb72a';

/// 대시보드 할일 요약 (대시보드 전용) - 할일 탭 UI 상태와 완전히 독립
///
/// Copied from [dashboardTodoTasks].
@ProviderFor(dashboardTodoTasks)
final dashboardTodoTasksProvider =
    AutoDisposeFutureProvider<List<TaskModel>>.internal(
      dashboardTodoTasks,
      name: r'dashboardTodoTasksProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dashboardTodoTasksHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DashboardTodoTasksRef = AutoDisposeFutureProviderRef<List<TaskModel>>;
String _$dashboardAssetStatisticsHash() =>
    r'1b9944d269d6f43ce0a5ee8ff3ea2c7c1a3e923e';

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
