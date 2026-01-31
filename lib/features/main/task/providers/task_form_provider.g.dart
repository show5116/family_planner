// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$taskFormNotifierHash() => r'efefcdee4d6671ce7c318dae49cff92793e2cfe4';

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

abstract class _$TaskFormNotifier
    extends BuildlessAutoDisposeNotifier<TaskFormState> {
  late final String? taskId;
  late final TaskModel? task;
  late final DateTime? initialDate;

  TaskFormState build({String? taskId, TaskModel? task, DateTime? initialDate});
}

/// Task Form Notifier
/// - 비즈니스 로직만 담당
/// - Categories는 별도 Provider 사용 (Riverpod 패턴 준수)
///
/// Copied from [TaskFormNotifier].
@ProviderFor(TaskFormNotifier)
const taskFormNotifierProvider = TaskFormNotifierFamily();

/// Task Form Notifier
/// - 비즈니스 로직만 담당
/// - Categories는 별도 Provider 사용 (Riverpod 패턴 준수)
///
/// Copied from [TaskFormNotifier].
class TaskFormNotifierFamily extends Family<TaskFormState> {
  /// Task Form Notifier
  /// - 비즈니스 로직만 담당
  /// - Categories는 별도 Provider 사용 (Riverpod 패턴 준수)
  ///
  /// Copied from [TaskFormNotifier].
  const TaskFormNotifierFamily();

  /// Task Form Notifier
  /// - 비즈니스 로직만 담당
  /// - Categories는 별도 Provider 사용 (Riverpod 패턴 준수)
  ///
  /// Copied from [TaskFormNotifier].
  TaskFormNotifierProvider call({
    String? taskId,
    TaskModel? task,
    DateTime? initialDate,
  }) {
    return TaskFormNotifierProvider(
      taskId: taskId,
      task: task,
      initialDate: initialDate,
    );
  }

  @override
  TaskFormNotifierProvider getProviderOverride(
    covariant TaskFormNotifierProvider provider,
  ) {
    return call(
      taskId: provider.taskId,
      task: provider.task,
      initialDate: provider.initialDate,
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
  String? get name => r'taskFormNotifierProvider';
}

/// Task Form Notifier
/// - 비즈니스 로직만 담당
/// - Categories는 별도 Provider 사용 (Riverpod 패턴 준수)
///
/// Copied from [TaskFormNotifier].
class TaskFormNotifierProvider
    extends AutoDisposeNotifierProviderImpl<TaskFormNotifier, TaskFormState> {
  /// Task Form Notifier
  /// - 비즈니스 로직만 담당
  /// - Categories는 별도 Provider 사용 (Riverpod 패턴 준수)
  ///
  /// Copied from [TaskFormNotifier].
  TaskFormNotifierProvider({
    String? taskId,
    TaskModel? task,
    DateTime? initialDate,
  }) : this._internal(
         () => TaskFormNotifier()
           ..taskId = taskId
           ..task = task
           ..initialDate = initialDate,
         from: taskFormNotifierProvider,
         name: r'taskFormNotifierProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$taskFormNotifierHash,
         dependencies: TaskFormNotifierFamily._dependencies,
         allTransitiveDependencies:
             TaskFormNotifierFamily._allTransitiveDependencies,
         taskId: taskId,
         task: task,
         initialDate: initialDate,
       );

  TaskFormNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.taskId,
    required this.task,
    required this.initialDate,
  }) : super.internal();

  final String? taskId;
  final TaskModel? task;
  final DateTime? initialDate;

  @override
  TaskFormState runNotifierBuild(covariant TaskFormNotifier notifier) {
    return notifier.build(taskId: taskId, task: task, initialDate: initialDate);
  }

  @override
  Override overrideWith(TaskFormNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: TaskFormNotifierProvider._internal(
        () => create()
          ..taskId = taskId
          ..task = task
          ..initialDate = initialDate,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        taskId: taskId,
        task: task,
        initialDate: initialDate,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<TaskFormNotifier, TaskFormState>
  createElement() {
    return _TaskFormNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskFormNotifierProvider &&
        other.taskId == taskId &&
        other.task == task &&
        other.initialDate == initialDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, taskId.hashCode);
    hash = _SystemHash.combine(hash, task.hashCode);
    hash = _SystemHash.combine(hash, initialDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TaskFormNotifierRef on AutoDisposeNotifierProviderRef<TaskFormState> {
  /// The parameter `taskId` of this provider.
  String? get taskId;

  /// The parameter `task` of this provider.
  TaskModel? get task;

  /// The parameter `initialDate` of this provider.
  DateTime? get initialDate;
}

class _TaskFormNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<TaskFormNotifier, TaskFormState>
    with TaskFormNotifierRef {
  _TaskFormNotifierProviderElement(super.provider);

  @override
  String? get taskId => (origin as TaskFormNotifierProvider).taskId;
  @override
  TaskModel? get task => (origin as TaskFormNotifierProvider).task;
  @override
  DateTime? get initialDate => (origin as TaskFormNotifierProvider).initialDate;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
