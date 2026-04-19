enum ScheduleViewMode { today, week, month }

/// 대시보드 위젯 설정 모델
class DashboardWidgetSettings {
  final bool showTodaySchedule;
  final bool showInvestmentSummary;
  final bool showTodoSummary;
  final bool showAssetSummary;
  final bool showMemoSummary;
  final bool showWeather;
  final List<String> widgetOrder;
  // 일정 위젯 필터
  final ScheduleViewMode scheduleViewMode;
  final List<String>? scheduleSelectedGroupIds; // null = 전체 그룹
  final bool scheduleIncludePersonal;
  // 할일 위젯 필터
  final ScheduleViewMode todoViewMode;
  final List<String>? todoSelectedGroupIds; // null = 전체 그룹
  final bool todoIncludePersonal;

  const DashboardWidgetSettings({
    this.showTodaySchedule = true,
    this.showInvestmentSummary = true,
    this.showTodoSummary = true,
    this.showAssetSummary = true,
    this.showMemoSummary = false,
    this.showWeather = true,
    this.scheduleViewMode = ScheduleViewMode.today,
    this.scheduleSelectedGroupIds,
    this.scheduleIncludePersonal = true,
    this.todoViewMode = ScheduleViewMode.today,
    this.todoSelectedGroupIds,
    this.todoIncludePersonal = true,
    this.widgetOrder = const [
      'weather',
      'todaySchedule',
      'investmentSummary',
      'todoSummary',
      'assetSummary',
      'memoSummary',
    ],
  });

  factory DashboardWidgetSettings.defaultSettings() {
    return const DashboardWidgetSettings();
  }

  factory DashboardWidgetSettings.fromJson(Map<String, dynamic> json) {
    const allWidgets = [
      'weather',
      'todaySchedule',
      'investmentSummary',
      'todoSummary',
      'assetSummary',
      'memoSummary',
    ];

    final savedOrder = (json['widgetOrder'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        List<String>.from(allWidgets);

    final mergedOrder = [
      ...savedOrder,
      ...allWidgets.where((w) => !savedOrder.contains(w)),
    ];

    ScheduleViewMode parseMode(String key) {
      final str = json[key] as String? ?? 'today';
      return ScheduleViewMode.values.firstWhere(
        (e) => e.name == str,
        orElse: () => ScheduleViewMode.today,
      );
    }

    List<String>? parseGroupIds(String key) {
      final raw = json[key];
      if (raw == null) return null;
      return (raw as List<dynamic>).map((e) => e as String).toList();
    }

    return DashboardWidgetSettings(
      showTodaySchedule: json['showTodaySchedule'] as bool? ?? true,
      showInvestmentSummary: json['showInvestmentSummary'] as bool? ?? true,
      showTodoSummary: json['showTodoSummary'] as bool? ?? true,
      showAssetSummary: json['showAssetSummary'] as bool? ?? true,
      showMemoSummary: json['showMemoSummary'] as bool? ?? false,
      showWeather: json['showWeather'] as bool? ?? true,
      scheduleViewMode: parseMode('scheduleViewMode'),
      scheduleSelectedGroupIds: parseGroupIds('scheduleSelectedGroupIds'),
      scheduleIncludePersonal: json['scheduleIncludePersonal'] as bool? ?? true,
      todoViewMode: parseMode('todoViewMode'),
      todoSelectedGroupIds: parseGroupIds('todoSelectedGroupIds'),
      todoIncludePersonal: json['todoIncludePersonal'] as bool? ?? true,
      widgetOrder: mergedOrder,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'showTodaySchedule': showTodaySchedule,
      'showInvestmentSummary': showInvestmentSummary,
      'showTodoSummary': showTodoSummary,
      'showAssetSummary': showAssetSummary,
      'showMemoSummary': showMemoSummary,
      'showWeather': showWeather,
      'scheduleViewMode': scheduleViewMode.name,
      'scheduleSelectedGroupIds': scheduleSelectedGroupIds,
      'scheduleIncludePersonal': scheduleIncludePersonal,
      'todoViewMode': todoViewMode.name,
      'todoSelectedGroupIds': todoSelectedGroupIds,
      'todoIncludePersonal': todoIncludePersonal,
      'widgetOrder': widgetOrder,
    };
  }

  DashboardWidgetSettings copyWith({
    bool? showTodaySchedule,
    bool? showInvestmentSummary,
    bool? showTodoSummary,
    bool? showAssetSummary,
    bool? showMemoSummary,
    bool? showWeather,
    ScheduleViewMode? scheduleViewMode,
    Object? scheduleSelectedGroupIds = _sentinel,
    bool? scheduleIncludePersonal,
    ScheduleViewMode? todoViewMode,
    Object? todoSelectedGroupIds = _sentinel,
    bool? todoIncludePersonal,
    List<String>? widgetOrder,
  }) {
    return DashboardWidgetSettings(
      showTodaySchedule: showTodaySchedule ?? this.showTodaySchedule,
      showInvestmentSummary: showInvestmentSummary ?? this.showInvestmentSummary,
      showTodoSummary: showTodoSummary ?? this.showTodoSummary,
      showAssetSummary: showAssetSummary ?? this.showAssetSummary,
      showMemoSummary: showMemoSummary ?? this.showMemoSummary,
      showWeather: showWeather ?? this.showWeather,
      scheduleViewMode: scheduleViewMode ?? this.scheduleViewMode,
      scheduleSelectedGroupIds: scheduleSelectedGroupIds == _sentinel
          ? this.scheduleSelectedGroupIds
          : scheduleSelectedGroupIds as List<String>?,
      scheduleIncludePersonal: scheduleIncludePersonal ?? this.scheduleIncludePersonal,
      todoViewMode: todoViewMode ?? this.todoViewMode,
      todoSelectedGroupIds: todoSelectedGroupIds == _sentinel
          ? this.todoSelectedGroupIds
          : todoSelectedGroupIds as List<String>?,
      todoIncludePersonal: todoIncludePersonal ?? this.todoIncludePersonal,
      widgetOrder: widgetOrder ?? this.widgetOrder,
    );
  }
}

const Object _sentinel = Object();
