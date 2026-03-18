/// 대시보드 위젯 설정 모델
class DashboardWidgetSettings {
  final bool showTodaySchedule;
  final bool showInvestmentSummary;
  final bool showTodoSummary;
  final bool showAssetSummary;
  final bool showMemoSummary;
  final bool showWeather;
  final List<String> widgetOrder;

  const DashboardWidgetSettings({
    this.showTodaySchedule = true,
    this.showInvestmentSummary = true,
    this.showTodoSummary = true,
    this.showAssetSummary = true,
    this.showMemoSummary = false,
    this.showWeather = true,
    this.widgetOrder = const [
      'weather',
      'todaySchedule',
      'investmentSummary',
      'todoSummary',
      'assetSummary',
      'memoSummary',
    ],
  });

  /// 기본 설정 (모든 위젯 표시)
  factory DashboardWidgetSettings.defaultSettings() {
    return const DashboardWidgetSettings();
  }

  /// JSON에서 변환
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

    // 저장된 목록에 없는 신규 위젯을 뒤에 추가
    final mergedOrder = [
      ...savedOrder,
      ...allWidgets.where((w) => !savedOrder.contains(w)),
    ];

    return DashboardWidgetSettings(
      showTodaySchedule: json['showTodaySchedule'] as bool? ?? true,
      showInvestmentSummary: json['showInvestmentSummary'] as bool? ?? true,
      showTodoSummary: json['showTodoSummary'] as bool? ?? true,
      showAssetSummary: json['showAssetSummary'] as bool? ?? true,
      showMemoSummary: json['showMemoSummary'] as bool? ?? false,
      showWeather: json['showWeather'] as bool? ?? true,
      widgetOrder: mergedOrder,
    );
  }

  /// JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'showTodaySchedule': showTodaySchedule,
      'showInvestmentSummary': showInvestmentSummary,
      'showTodoSummary': showTodoSummary,
      'showAssetSummary': showAssetSummary,
      'showMemoSummary': showMemoSummary,
      'showWeather': showWeather,
      'widgetOrder': widgetOrder,
    };
  }

  /// 복사 생성자
  DashboardWidgetSettings copyWith({
    bool? showTodaySchedule,
    bool? showInvestmentSummary,
    bool? showTodoSummary,
    bool? showAssetSummary,
    bool? showMemoSummary,
    bool? showWeather,
    List<String>? widgetOrder,
  }) {
    return DashboardWidgetSettings(
      showTodaySchedule: showTodaySchedule ?? this.showTodaySchedule,
      showInvestmentSummary: showInvestmentSummary ?? this.showInvestmentSummary,
      showTodoSummary: showTodoSummary ?? this.showTodoSummary,
      showAssetSummary: showAssetSummary ?? this.showAssetSummary,
      showMemoSummary: showMemoSummary ?? this.showMemoSummary,
      showWeather: showWeather ?? this.showWeather,
      widgetOrder: widgetOrder ?? this.widgetOrder,
    );
  }
}
