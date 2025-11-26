/// 대시보드 위젯 설정 모델
class DashboardWidgetSettings {
  final bool showTodaySchedule;
  final bool showInvestmentSummary;
  final bool showTodoSummary;
  final bool showAssetSummary;
  final List<String> widgetOrder;

  const DashboardWidgetSettings({
    this.showTodaySchedule = true,
    this.showInvestmentSummary = true,
    this.showTodoSummary = true,
    this.showAssetSummary = true,
    this.widgetOrder = const [
      'todaySchedule',
      'investmentSummary',
      'todoSummary',
      'assetSummary',
    ],
  });

  /// 기본 설정 (모든 위젯 표시)
  factory DashboardWidgetSettings.defaultSettings() {
    return const DashboardWidgetSettings();
  }

  /// JSON에서 변환
  factory DashboardWidgetSettings.fromJson(Map<String, dynamic> json) {
    return DashboardWidgetSettings(
      showTodaySchedule: json['showTodaySchedule'] as bool? ?? true,
      showInvestmentSummary: json['showInvestmentSummary'] as bool? ?? true,
      showTodoSummary: json['showTodoSummary'] as bool? ?? true,
      showAssetSummary: json['showAssetSummary'] as bool? ?? true,
      widgetOrder: (json['widgetOrder'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [
            'todaySchedule',
            'investmentSummary',
            'todoSummary',
            'assetSummary',
          ],
    );
  }

  /// JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'showTodaySchedule': showTodaySchedule,
      'showInvestmentSummary': showInvestmentSummary,
      'showTodoSummary': showTodoSummary,
      'showAssetSummary': showAssetSummary,
    };
  }

  /// 복사 생성자
  DashboardWidgetSettings copyWith({
    bool? showTodaySchedule,
    bool? showInvestmentSummary,
    bool? showTodoSummary,
    bool? showAssetSummary,
  }) {
    return DashboardWidgetSettings(
      showTodaySchedule: showTodaySchedule ?? this.showTodaySchedule,
      showInvestmentSummary: showInvestmentSummary ?? this.showInvestmentSummary,
      showTodoSummary: showTodoSummary ?? this.showTodoSummary,
      showAssetSummary: showAssetSummary ?? this.showAssetSummary,
    );
  }
}
