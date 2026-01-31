// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_form_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TaskFormState {
  // 기본 정보
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError; // 날짜/시간
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime? get dueDate => throw _privateConstructorUsedError;
  TimeOfDay? get startTime => throw _privateConstructorUsedError;
  TimeOfDay? get dueTime => throw _privateConstructorUsedError;
  bool get isAllDay => throw _privateConstructorUsedError;
  bool get hasDueDate => throw _privateConstructorUsedError; // 일정 속성
  TaskType get taskType => throw _privateConstructorUsedError;
  TaskPriority get priority => throw _privateConstructorUsedError;
  RecurringRuleType? get recurringType =>
      throw _privateConstructorUsedError; // 알림 (분 단위)
  List<int> get selectedReminders =>
      throw _privateConstructorUsedError; // 카테고리 (Provider에서 로드된 목록에서 선택)
  CategoryModel? get selectedCategory =>
      throw _privateConstructorUsedError; // 참가자
  List<String> get selectedParticipantIds =>
      throw _privateConstructorUsedError; // 제출 상태
  bool get isSubmitting => throw _privateConstructorUsedError; // 수정 모드
  TaskModel? get editingTask => throw _privateConstructorUsedError;
  String? get editingTaskId => throw _privateConstructorUsedError;

  /// Create a copy of TaskFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskFormStateCopyWith<TaskFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskFormStateCopyWith<$Res> {
  factory $TaskFormStateCopyWith(
    TaskFormState value,
    $Res Function(TaskFormState) then,
  ) = _$TaskFormStateCopyWithImpl<$Res, TaskFormState>;
  @useResult
  $Res call({
    String title,
    String description,
    String location,
    DateTime startDate,
    DateTime? dueDate,
    TimeOfDay? startTime,
    TimeOfDay? dueTime,
    bool isAllDay,
    bool hasDueDate,
    TaskType taskType,
    TaskPriority priority,
    RecurringRuleType? recurringType,
    List<int> selectedReminders,
    CategoryModel? selectedCategory,
    List<String> selectedParticipantIds,
    bool isSubmitting,
    TaskModel? editingTask,
    String? editingTaskId,
  });

  $CategoryModelCopyWith<$Res>? get selectedCategory;
  $TaskModelCopyWith<$Res>? get editingTask;
}

/// @nodoc
class _$TaskFormStateCopyWithImpl<$Res, $Val extends TaskFormState>
    implements $TaskFormStateCopyWith<$Res> {
  _$TaskFormStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? location = null,
    Object? startDate = null,
    Object? dueDate = freezed,
    Object? startTime = freezed,
    Object? dueTime = freezed,
    Object? isAllDay = null,
    Object? hasDueDate = null,
    Object? taskType = null,
    Object? priority = null,
    Object? recurringType = freezed,
    Object? selectedReminders = null,
    Object? selectedCategory = freezed,
    Object? selectedParticipantIds = null,
    Object? isSubmitting = null,
    Object? editingTask = freezed,
    Object? editingTaskId = freezed,
  }) {
    return _then(
      _value.copyWith(
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            dueDate: freezed == dueDate
                ? _value.dueDate
                : dueDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            startTime: freezed == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as TimeOfDay?,
            dueTime: freezed == dueTime
                ? _value.dueTime
                : dueTime // ignore: cast_nullable_to_non_nullable
                      as TimeOfDay?,
            isAllDay: null == isAllDay
                ? _value.isAllDay
                : isAllDay // ignore: cast_nullable_to_non_nullable
                      as bool,
            hasDueDate: null == hasDueDate
                ? _value.hasDueDate
                : hasDueDate // ignore: cast_nullable_to_non_nullable
                      as bool,
            taskType: null == taskType
                ? _value.taskType
                : taskType // ignore: cast_nullable_to_non_nullable
                      as TaskType,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as TaskPriority,
            recurringType: freezed == recurringType
                ? _value.recurringType
                : recurringType // ignore: cast_nullable_to_non_nullable
                      as RecurringRuleType?,
            selectedReminders: null == selectedReminders
                ? _value.selectedReminders
                : selectedReminders // ignore: cast_nullable_to_non_nullable
                      as List<int>,
            selectedCategory: freezed == selectedCategory
                ? _value.selectedCategory
                : selectedCategory // ignore: cast_nullable_to_non_nullable
                      as CategoryModel?,
            selectedParticipantIds: null == selectedParticipantIds
                ? _value.selectedParticipantIds
                : selectedParticipantIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isSubmitting: null == isSubmitting
                ? _value.isSubmitting
                : isSubmitting // ignore: cast_nullable_to_non_nullable
                      as bool,
            editingTask: freezed == editingTask
                ? _value.editingTask
                : editingTask // ignore: cast_nullable_to_non_nullable
                      as TaskModel?,
            editingTaskId: freezed == editingTaskId
                ? _value.editingTaskId
                : editingTaskId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of TaskFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryModelCopyWith<$Res>? get selectedCategory {
    if (_value.selectedCategory == null) {
      return null;
    }

    return $CategoryModelCopyWith<$Res>(_value.selectedCategory!, (value) {
      return _then(_value.copyWith(selectedCategory: value) as $Val);
    });
  }

  /// Create a copy of TaskFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TaskModelCopyWith<$Res>? get editingTask {
    if (_value.editingTask == null) {
      return null;
    }

    return $TaskModelCopyWith<$Res>(_value.editingTask!, (value) {
      return _then(_value.copyWith(editingTask: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TaskFormStateImplCopyWith<$Res>
    implements $TaskFormStateCopyWith<$Res> {
  factory _$$TaskFormStateImplCopyWith(
    _$TaskFormStateImpl value,
    $Res Function(_$TaskFormStateImpl) then,
  ) = __$$TaskFormStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String title,
    String description,
    String location,
    DateTime startDate,
    DateTime? dueDate,
    TimeOfDay? startTime,
    TimeOfDay? dueTime,
    bool isAllDay,
    bool hasDueDate,
    TaskType taskType,
    TaskPriority priority,
    RecurringRuleType? recurringType,
    List<int> selectedReminders,
    CategoryModel? selectedCategory,
    List<String> selectedParticipantIds,
    bool isSubmitting,
    TaskModel? editingTask,
    String? editingTaskId,
  });

  @override
  $CategoryModelCopyWith<$Res>? get selectedCategory;
  @override
  $TaskModelCopyWith<$Res>? get editingTask;
}

/// @nodoc
class __$$TaskFormStateImplCopyWithImpl<$Res>
    extends _$TaskFormStateCopyWithImpl<$Res, _$TaskFormStateImpl>
    implements _$$TaskFormStateImplCopyWith<$Res> {
  __$$TaskFormStateImplCopyWithImpl(
    _$TaskFormStateImpl _value,
    $Res Function(_$TaskFormStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? location = null,
    Object? startDate = null,
    Object? dueDate = freezed,
    Object? startTime = freezed,
    Object? dueTime = freezed,
    Object? isAllDay = null,
    Object? hasDueDate = null,
    Object? taskType = null,
    Object? priority = null,
    Object? recurringType = freezed,
    Object? selectedReminders = null,
    Object? selectedCategory = freezed,
    Object? selectedParticipantIds = null,
    Object? isSubmitting = null,
    Object? editingTask = freezed,
    Object? editingTaskId = freezed,
  }) {
    return _then(
      _$TaskFormStateImpl(
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        dueDate: freezed == dueDate
            ? _value.dueDate
            : dueDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        startTime: freezed == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as TimeOfDay?,
        dueTime: freezed == dueTime
            ? _value.dueTime
            : dueTime // ignore: cast_nullable_to_non_nullable
                  as TimeOfDay?,
        isAllDay: null == isAllDay
            ? _value.isAllDay
            : isAllDay // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasDueDate: null == hasDueDate
            ? _value.hasDueDate
            : hasDueDate // ignore: cast_nullable_to_non_nullable
                  as bool,
        taskType: null == taskType
            ? _value.taskType
            : taskType // ignore: cast_nullable_to_non_nullable
                  as TaskType,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as TaskPriority,
        recurringType: freezed == recurringType
            ? _value.recurringType
            : recurringType // ignore: cast_nullable_to_non_nullable
                  as RecurringRuleType?,
        selectedReminders: null == selectedReminders
            ? _value._selectedReminders
            : selectedReminders // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        selectedCategory: freezed == selectedCategory
            ? _value.selectedCategory
            : selectedCategory // ignore: cast_nullable_to_non_nullable
                  as CategoryModel?,
        selectedParticipantIds: null == selectedParticipantIds
            ? _value._selectedParticipantIds
            : selectedParticipantIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isSubmitting: null == isSubmitting
            ? _value.isSubmitting
            : isSubmitting // ignore: cast_nullable_to_non_nullable
                  as bool,
        editingTask: freezed == editingTask
            ? _value.editingTask
            : editingTask // ignore: cast_nullable_to_non_nullable
                  as TaskModel?,
        editingTaskId: freezed == editingTaskId
            ? _value.editingTaskId
            : editingTaskId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$TaskFormStateImpl extends _TaskFormState {
  const _$TaskFormStateImpl({
    this.title = '',
    this.description = '',
    this.location = '',
    required this.startDate,
    this.dueDate,
    this.startTime,
    this.dueTime,
    this.isAllDay = true,
    this.hasDueDate = false,
    this.taskType = TaskType.calendarOnly,
    this.priority = TaskPriority.medium,
    this.recurringType,
    final List<int> selectedReminders = const [],
    this.selectedCategory,
    final List<String> selectedParticipantIds = const [],
    this.isSubmitting = false,
    this.editingTask,
    this.editingTaskId,
  }) : _selectedReminders = selectedReminders,
       _selectedParticipantIds = selectedParticipantIds,
       super._();

  // 기본 정보
  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final String location;
  // 날짜/시간
  @override
  final DateTime startDate;
  @override
  final DateTime? dueDate;
  @override
  final TimeOfDay? startTime;
  @override
  final TimeOfDay? dueTime;
  @override
  @JsonKey()
  final bool isAllDay;
  @override
  @JsonKey()
  final bool hasDueDate;
  // 일정 속성
  @override
  @JsonKey()
  final TaskType taskType;
  @override
  @JsonKey()
  final TaskPriority priority;
  @override
  final RecurringRuleType? recurringType;
  // 알림 (분 단위)
  final List<int> _selectedReminders;
  // 알림 (분 단위)
  @override
  @JsonKey()
  List<int> get selectedReminders {
    if (_selectedReminders is EqualUnmodifiableListView)
      return _selectedReminders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedReminders);
  }

  // 카테고리 (Provider에서 로드된 목록에서 선택)
  @override
  final CategoryModel? selectedCategory;
  // 참가자
  final List<String> _selectedParticipantIds;
  // 참가자
  @override
  @JsonKey()
  List<String> get selectedParticipantIds {
    if (_selectedParticipantIds is EqualUnmodifiableListView)
      return _selectedParticipantIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedParticipantIds);
  }

  // 제출 상태
  @override
  @JsonKey()
  final bool isSubmitting;
  // 수정 모드
  @override
  final TaskModel? editingTask;
  @override
  final String? editingTaskId;

  @override
  String toString() {
    return 'TaskFormState(title: $title, description: $description, location: $location, startDate: $startDate, dueDate: $dueDate, startTime: $startTime, dueTime: $dueTime, isAllDay: $isAllDay, hasDueDate: $hasDueDate, taskType: $taskType, priority: $priority, recurringType: $recurringType, selectedReminders: $selectedReminders, selectedCategory: $selectedCategory, selectedParticipantIds: $selectedParticipantIds, isSubmitting: $isSubmitting, editingTask: $editingTask, editingTaskId: $editingTaskId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskFormStateImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.dueTime, dueTime) || other.dueTime == dueTime) &&
            (identical(other.isAllDay, isAllDay) ||
                other.isAllDay == isAllDay) &&
            (identical(other.hasDueDate, hasDueDate) ||
                other.hasDueDate == hasDueDate) &&
            (identical(other.taskType, taskType) ||
                other.taskType == taskType) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.recurringType, recurringType) ||
                other.recurringType == recurringType) &&
            const DeepCollectionEquality().equals(
              other._selectedReminders,
              _selectedReminders,
            ) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            const DeepCollectionEquality().equals(
              other._selectedParticipantIds,
              _selectedParticipantIds,
            ) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.editingTask, editingTask) ||
                other.editingTask == editingTask) &&
            (identical(other.editingTaskId, editingTaskId) ||
                other.editingTaskId == editingTaskId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    title,
    description,
    location,
    startDate,
    dueDate,
    startTime,
    dueTime,
    isAllDay,
    hasDueDate,
    taskType,
    priority,
    recurringType,
    const DeepCollectionEquality().hash(_selectedReminders),
    selectedCategory,
    const DeepCollectionEquality().hash(_selectedParticipantIds),
    isSubmitting,
    editingTask,
    editingTaskId,
  );

  /// Create a copy of TaskFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskFormStateImplCopyWith<_$TaskFormStateImpl> get copyWith =>
      __$$TaskFormStateImplCopyWithImpl<_$TaskFormStateImpl>(this, _$identity);
}

abstract class _TaskFormState extends TaskFormState {
  const factory _TaskFormState({
    final String title,
    final String description,
    final String location,
    required final DateTime startDate,
    final DateTime? dueDate,
    final TimeOfDay? startTime,
    final TimeOfDay? dueTime,
    final bool isAllDay,
    final bool hasDueDate,
    final TaskType taskType,
    final TaskPriority priority,
    final RecurringRuleType? recurringType,
    final List<int> selectedReminders,
    final CategoryModel? selectedCategory,
    final List<String> selectedParticipantIds,
    final bool isSubmitting,
    final TaskModel? editingTask,
    final String? editingTaskId,
  }) = _$TaskFormStateImpl;
  const _TaskFormState._() : super._();

  // 기본 정보
  @override
  String get title;
  @override
  String get description;
  @override
  String get location; // 날짜/시간
  @override
  DateTime get startDate;
  @override
  DateTime? get dueDate;
  @override
  TimeOfDay? get startTime;
  @override
  TimeOfDay? get dueTime;
  @override
  bool get isAllDay;
  @override
  bool get hasDueDate; // 일정 속성
  @override
  TaskType get taskType;
  @override
  TaskPriority get priority;
  @override
  RecurringRuleType? get recurringType; // 알림 (분 단위)
  @override
  List<int> get selectedReminders; // 카테고리 (Provider에서 로드된 목록에서 선택)
  @override
  CategoryModel? get selectedCategory; // 참가자
  @override
  List<String> get selectedParticipantIds; // 제출 상태
  @override
  bool get isSubmitting; // 수정 모드
  @override
  TaskModel? get editingTask;
  @override
  String? get editingTaskId;

  /// Create a copy of TaskFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskFormStateImplCopyWith<_$TaskFormStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
