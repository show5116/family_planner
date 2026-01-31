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
      throw _privateConstructorUsedError; // 반복 상세 설정
  int get recurringInterval =>
      throw _privateConstructorUsedError; // 반복 간격 (1 = 매번, 2 = 격일/격주 등)
  RecurringEndType get recurringEndType => throw _privateConstructorUsedError;
  DateTime? get recurringEndDate =>
      throw _privateConstructorUsedError; // endType이 date일 때
  int get recurringCount =>
      throw _privateConstructorUsedError; // endType이 count일 때
  List<int> get recurringDaysOfWeek =>
      throw _privateConstructorUsedError; // weekly: 요일 선택 (0=일 ~ 6=토)
  MonthlyType get monthlyType => throw _privateConstructorUsedError;
  int get monthlyDayOfMonth => throw _privateConstructorUsedError; // 1-31
  int get monthlyWeekOfMonth =>
      throw _privateConstructorUsedError; // 1-5 (5=마지막 주)
  int get monthlyDayOfWeek => throw _privateConstructorUsedError; // 0-6
  YearlyType get yearlyType => throw _privateConstructorUsedError;
  int get yearlyMonth => throw _privateConstructorUsedError; // 1-12
  int get yearlyDayOfMonth => throw _privateConstructorUsedError; // 1-31
  int get yearlyWeekOfMonth => throw _privateConstructorUsedError; // 1-5
  int get yearlyDayOfWeek => throw _privateConstructorUsedError; // 0-6
  // 알림 (분 단위)
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
    int recurringInterval,
    RecurringEndType recurringEndType,
    DateTime? recurringEndDate,
    int recurringCount,
    List<int> recurringDaysOfWeek,
    MonthlyType monthlyType,
    int monthlyDayOfMonth,
    int monthlyWeekOfMonth,
    int monthlyDayOfWeek,
    YearlyType yearlyType,
    int yearlyMonth,
    int yearlyDayOfMonth,
    int yearlyWeekOfMonth,
    int yearlyDayOfWeek,
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
    Object? recurringInterval = null,
    Object? recurringEndType = null,
    Object? recurringEndDate = freezed,
    Object? recurringCount = null,
    Object? recurringDaysOfWeek = null,
    Object? monthlyType = null,
    Object? monthlyDayOfMonth = null,
    Object? monthlyWeekOfMonth = null,
    Object? monthlyDayOfWeek = null,
    Object? yearlyType = null,
    Object? yearlyMonth = null,
    Object? yearlyDayOfMonth = null,
    Object? yearlyWeekOfMonth = null,
    Object? yearlyDayOfWeek = null,
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
            recurringInterval: null == recurringInterval
                ? _value.recurringInterval
                : recurringInterval // ignore: cast_nullable_to_non_nullable
                      as int,
            recurringEndType: null == recurringEndType
                ? _value.recurringEndType
                : recurringEndType // ignore: cast_nullable_to_non_nullable
                      as RecurringEndType,
            recurringEndDate: freezed == recurringEndDate
                ? _value.recurringEndDate
                : recurringEndDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            recurringCount: null == recurringCount
                ? _value.recurringCount
                : recurringCount // ignore: cast_nullable_to_non_nullable
                      as int,
            recurringDaysOfWeek: null == recurringDaysOfWeek
                ? _value.recurringDaysOfWeek
                : recurringDaysOfWeek // ignore: cast_nullable_to_non_nullable
                      as List<int>,
            monthlyType: null == monthlyType
                ? _value.monthlyType
                : monthlyType // ignore: cast_nullable_to_non_nullable
                      as MonthlyType,
            monthlyDayOfMonth: null == monthlyDayOfMonth
                ? _value.monthlyDayOfMonth
                : monthlyDayOfMonth // ignore: cast_nullable_to_non_nullable
                      as int,
            monthlyWeekOfMonth: null == monthlyWeekOfMonth
                ? _value.monthlyWeekOfMonth
                : monthlyWeekOfMonth // ignore: cast_nullable_to_non_nullable
                      as int,
            monthlyDayOfWeek: null == monthlyDayOfWeek
                ? _value.monthlyDayOfWeek
                : monthlyDayOfWeek // ignore: cast_nullable_to_non_nullable
                      as int,
            yearlyType: null == yearlyType
                ? _value.yearlyType
                : yearlyType // ignore: cast_nullable_to_non_nullable
                      as YearlyType,
            yearlyMonth: null == yearlyMonth
                ? _value.yearlyMonth
                : yearlyMonth // ignore: cast_nullable_to_non_nullable
                      as int,
            yearlyDayOfMonth: null == yearlyDayOfMonth
                ? _value.yearlyDayOfMonth
                : yearlyDayOfMonth // ignore: cast_nullable_to_non_nullable
                      as int,
            yearlyWeekOfMonth: null == yearlyWeekOfMonth
                ? _value.yearlyWeekOfMonth
                : yearlyWeekOfMonth // ignore: cast_nullable_to_non_nullable
                      as int,
            yearlyDayOfWeek: null == yearlyDayOfWeek
                ? _value.yearlyDayOfWeek
                : yearlyDayOfWeek // ignore: cast_nullable_to_non_nullable
                      as int,
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
    int recurringInterval,
    RecurringEndType recurringEndType,
    DateTime? recurringEndDate,
    int recurringCount,
    List<int> recurringDaysOfWeek,
    MonthlyType monthlyType,
    int monthlyDayOfMonth,
    int monthlyWeekOfMonth,
    int monthlyDayOfWeek,
    YearlyType yearlyType,
    int yearlyMonth,
    int yearlyDayOfMonth,
    int yearlyWeekOfMonth,
    int yearlyDayOfWeek,
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
    Object? recurringInterval = null,
    Object? recurringEndType = null,
    Object? recurringEndDate = freezed,
    Object? recurringCount = null,
    Object? recurringDaysOfWeek = null,
    Object? monthlyType = null,
    Object? monthlyDayOfMonth = null,
    Object? monthlyWeekOfMonth = null,
    Object? monthlyDayOfWeek = null,
    Object? yearlyType = null,
    Object? yearlyMonth = null,
    Object? yearlyDayOfMonth = null,
    Object? yearlyWeekOfMonth = null,
    Object? yearlyDayOfWeek = null,
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
        recurringInterval: null == recurringInterval
            ? _value.recurringInterval
            : recurringInterval // ignore: cast_nullable_to_non_nullable
                  as int,
        recurringEndType: null == recurringEndType
            ? _value.recurringEndType
            : recurringEndType // ignore: cast_nullable_to_non_nullable
                  as RecurringEndType,
        recurringEndDate: freezed == recurringEndDate
            ? _value.recurringEndDate
            : recurringEndDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        recurringCount: null == recurringCount
            ? _value.recurringCount
            : recurringCount // ignore: cast_nullable_to_non_nullable
                  as int,
        recurringDaysOfWeek: null == recurringDaysOfWeek
            ? _value._recurringDaysOfWeek
            : recurringDaysOfWeek // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        monthlyType: null == monthlyType
            ? _value.monthlyType
            : monthlyType // ignore: cast_nullable_to_non_nullable
                  as MonthlyType,
        monthlyDayOfMonth: null == monthlyDayOfMonth
            ? _value.monthlyDayOfMonth
            : monthlyDayOfMonth // ignore: cast_nullable_to_non_nullable
                  as int,
        monthlyWeekOfMonth: null == monthlyWeekOfMonth
            ? _value.monthlyWeekOfMonth
            : monthlyWeekOfMonth // ignore: cast_nullable_to_non_nullable
                  as int,
        monthlyDayOfWeek: null == monthlyDayOfWeek
            ? _value.monthlyDayOfWeek
            : monthlyDayOfWeek // ignore: cast_nullable_to_non_nullable
                  as int,
        yearlyType: null == yearlyType
            ? _value.yearlyType
            : yearlyType // ignore: cast_nullable_to_non_nullable
                  as YearlyType,
        yearlyMonth: null == yearlyMonth
            ? _value.yearlyMonth
            : yearlyMonth // ignore: cast_nullable_to_non_nullable
                  as int,
        yearlyDayOfMonth: null == yearlyDayOfMonth
            ? _value.yearlyDayOfMonth
            : yearlyDayOfMonth // ignore: cast_nullable_to_non_nullable
                  as int,
        yearlyWeekOfMonth: null == yearlyWeekOfMonth
            ? _value.yearlyWeekOfMonth
            : yearlyWeekOfMonth // ignore: cast_nullable_to_non_nullable
                  as int,
        yearlyDayOfWeek: null == yearlyDayOfWeek
            ? _value.yearlyDayOfWeek
            : yearlyDayOfWeek // ignore: cast_nullable_to_non_nullable
                  as int,
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
    this.recurringInterval = 1,
    this.recurringEndType = RecurringEndType.never,
    this.recurringEndDate,
    this.recurringCount = 10,
    final List<int> recurringDaysOfWeek = const [],
    this.monthlyType = MonthlyType.dayOfMonth,
    this.monthlyDayOfMonth = 1,
    this.monthlyWeekOfMonth = 1,
    this.monthlyDayOfWeek = 1,
    this.yearlyType = YearlyType.dayOfMonth,
    this.yearlyMonth = 1,
    this.yearlyDayOfMonth = 1,
    this.yearlyWeekOfMonth = 1,
    this.yearlyDayOfWeek = 1,
    final List<int> selectedReminders = const [],
    this.selectedCategory,
    final List<String> selectedParticipantIds = const [],
    this.isSubmitting = false,
    this.editingTask,
    this.editingTaskId,
  }) : _recurringDaysOfWeek = recurringDaysOfWeek,
       _selectedReminders = selectedReminders,
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
  // 반복 상세 설정
  @override
  @JsonKey()
  final int recurringInterval;
  // 반복 간격 (1 = 매번, 2 = 격일/격주 등)
  @override
  @JsonKey()
  final RecurringEndType recurringEndType;
  @override
  final DateTime? recurringEndDate;
  // endType이 date일 때
  @override
  @JsonKey()
  final int recurringCount;
  // endType이 count일 때
  final List<int> _recurringDaysOfWeek;
  // endType이 count일 때
  @override
  @JsonKey()
  List<int> get recurringDaysOfWeek {
    if (_recurringDaysOfWeek is EqualUnmodifiableListView)
      return _recurringDaysOfWeek;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recurringDaysOfWeek);
  }

  // weekly: 요일 선택 (0=일 ~ 6=토)
  @override
  @JsonKey()
  final MonthlyType monthlyType;
  @override
  @JsonKey()
  final int monthlyDayOfMonth;
  // 1-31
  @override
  @JsonKey()
  final int monthlyWeekOfMonth;
  // 1-5 (5=마지막 주)
  @override
  @JsonKey()
  final int monthlyDayOfWeek;
  // 0-6
  @override
  @JsonKey()
  final YearlyType yearlyType;
  @override
  @JsonKey()
  final int yearlyMonth;
  // 1-12
  @override
  @JsonKey()
  final int yearlyDayOfMonth;
  // 1-31
  @override
  @JsonKey()
  final int yearlyWeekOfMonth;
  // 1-5
  @override
  @JsonKey()
  final int yearlyDayOfWeek;
  // 0-6
  // 알림 (분 단위)
  final List<int> _selectedReminders;
  // 0-6
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
    return 'TaskFormState(title: $title, description: $description, location: $location, startDate: $startDate, dueDate: $dueDate, startTime: $startTime, dueTime: $dueTime, isAllDay: $isAllDay, hasDueDate: $hasDueDate, taskType: $taskType, priority: $priority, recurringType: $recurringType, recurringInterval: $recurringInterval, recurringEndType: $recurringEndType, recurringEndDate: $recurringEndDate, recurringCount: $recurringCount, recurringDaysOfWeek: $recurringDaysOfWeek, monthlyType: $monthlyType, monthlyDayOfMonth: $monthlyDayOfMonth, monthlyWeekOfMonth: $monthlyWeekOfMonth, monthlyDayOfWeek: $monthlyDayOfWeek, yearlyType: $yearlyType, yearlyMonth: $yearlyMonth, yearlyDayOfMonth: $yearlyDayOfMonth, yearlyWeekOfMonth: $yearlyWeekOfMonth, yearlyDayOfWeek: $yearlyDayOfWeek, selectedReminders: $selectedReminders, selectedCategory: $selectedCategory, selectedParticipantIds: $selectedParticipantIds, isSubmitting: $isSubmitting, editingTask: $editingTask, editingTaskId: $editingTaskId)';
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
            (identical(other.recurringInterval, recurringInterval) ||
                other.recurringInterval == recurringInterval) &&
            (identical(other.recurringEndType, recurringEndType) ||
                other.recurringEndType == recurringEndType) &&
            (identical(other.recurringEndDate, recurringEndDate) ||
                other.recurringEndDate == recurringEndDate) &&
            (identical(other.recurringCount, recurringCount) ||
                other.recurringCount == recurringCount) &&
            const DeepCollectionEquality().equals(
              other._recurringDaysOfWeek,
              _recurringDaysOfWeek,
            ) &&
            (identical(other.monthlyType, monthlyType) ||
                other.monthlyType == monthlyType) &&
            (identical(other.monthlyDayOfMonth, monthlyDayOfMonth) ||
                other.monthlyDayOfMonth == monthlyDayOfMonth) &&
            (identical(other.monthlyWeekOfMonth, monthlyWeekOfMonth) ||
                other.monthlyWeekOfMonth == monthlyWeekOfMonth) &&
            (identical(other.monthlyDayOfWeek, monthlyDayOfWeek) ||
                other.monthlyDayOfWeek == monthlyDayOfWeek) &&
            (identical(other.yearlyType, yearlyType) ||
                other.yearlyType == yearlyType) &&
            (identical(other.yearlyMonth, yearlyMonth) ||
                other.yearlyMonth == yearlyMonth) &&
            (identical(other.yearlyDayOfMonth, yearlyDayOfMonth) ||
                other.yearlyDayOfMonth == yearlyDayOfMonth) &&
            (identical(other.yearlyWeekOfMonth, yearlyWeekOfMonth) ||
                other.yearlyWeekOfMonth == yearlyWeekOfMonth) &&
            (identical(other.yearlyDayOfWeek, yearlyDayOfWeek) ||
                other.yearlyDayOfWeek == yearlyDayOfWeek) &&
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
  int get hashCode => Object.hashAll([
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
    recurringInterval,
    recurringEndType,
    recurringEndDate,
    recurringCount,
    const DeepCollectionEquality().hash(_recurringDaysOfWeek),
    monthlyType,
    monthlyDayOfMonth,
    monthlyWeekOfMonth,
    monthlyDayOfWeek,
    yearlyType,
    yearlyMonth,
    yearlyDayOfMonth,
    yearlyWeekOfMonth,
    yearlyDayOfWeek,
    const DeepCollectionEquality().hash(_selectedReminders),
    selectedCategory,
    const DeepCollectionEquality().hash(_selectedParticipantIds),
    isSubmitting,
    editingTask,
    editingTaskId,
  ]);

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
    final int recurringInterval,
    final RecurringEndType recurringEndType,
    final DateTime? recurringEndDate,
    final int recurringCount,
    final List<int> recurringDaysOfWeek,
    final MonthlyType monthlyType,
    final int monthlyDayOfMonth,
    final int monthlyWeekOfMonth,
    final int monthlyDayOfWeek,
    final YearlyType yearlyType,
    final int yearlyMonth,
    final int yearlyDayOfMonth,
    final int yearlyWeekOfMonth,
    final int yearlyDayOfWeek,
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
  RecurringRuleType? get recurringType; // 반복 상세 설정
  @override
  int get recurringInterval; // 반복 간격 (1 = 매번, 2 = 격일/격주 등)
  @override
  RecurringEndType get recurringEndType;
  @override
  DateTime? get recurringEndDate; // endType이 date일 때
  @override
  int get recurringCount; // endType이 count일 때
  @override
  List<int> get recurringDaysOfWeek; // weekly: 요일 선택 (0=일 ~ 6=토)
  @override
  MonthlyType get monthlyType;
  @override
  int get monthlyDayOfMonth; // 1-31
  @override
  int get monthlyWeekOfMonth; // 1-5 (5=마지막 주)
  @override
  int get monthlyDayOfWeek; // 0-6
  @override
  YearlyType get yearlyType;
  @override
  int get yearlyMonth; // 1-12
  @override
  int get yearlyDayOfMonth; // 1-31
  @override
  int get yearlyWeekOfMonth; // 1-5
  @override
  int get yearlyDayOfWeek; // 0-6
  // 알림 (분 단위)
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
