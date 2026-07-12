enum ScheduleViewMode { today, week, month }

enum HouseholdWidgetViewMode { budget, category }

/// 모든 싱글톤 위젯 키 (widgetOrder에 1개까지만 허용)
const kSingletonWidgetKeys = {
  'weather',
  'fridgeSummary',
  'todaySchedule',
  'investmentSummary',
  'todoSummary',
  'assetSummary',
  'memoSummary',
  'householdSummary',
  'childcareSummary',
  'savingsSummary',
  'anniversary',
  'routineSummary',
};

/// 대시보드 위젯 설정 모델
class DashboardWidgetSettings {
  /// 활성화된 위젯의 순서 목록 (모두 싱글톤 키)
  final List<String> widgetOrder;

  // 기념일 위젯에서 표시할 기념일 ID 목록
  final List<String> anniversaryIds;

  // 일정 위젯 필터
  final ScheduleViewMode scheduleViewMode;
  final List<String>? scheduleSelectedGroupIds;
  final bool scheduleIncludePersonal;
  // 할일 위젯 필터
  final ScheduleViewMode todoViewMode;
  final List<String>? todoSelectedGroupIds;
  final bool todoIncludePersonal;
  // 자산 위젯 필터
  final String? assetSelectedGroupId;
  // 메모 위젯 필터
  final String? memoSelectedGroupId;
  final bool memoPersonalOnly;
  // 가계관리 위젯 필터
  final String? householdSelectedGroupId;
  final HouseholdWidgetViewMode householdViewMode;
  // 육아포인트 위젯
  final String? childcareSelectedGroupId;
  // 저금통 위젯
  final String? savingsSelectedGroupId;
  // 냉장고 유통기한 위젯
  final String? fridgeExpirySelectedGroupId;

  const DashboardWidgetSettings({
    this.widgetOrder = const [
      'weather',
      'todaySchedule',
      'householdSummary',
      'investmentSummary',
      'childcareSummary',
    ],
    this.anniversaryIds = const [],
    this.scheduleViewMode = ScheduleViewMode.today,
    this.scheduleSelectedGroupIds,
    this.scheduleIncludePersonal = true,
    this.todoViewMode = ScheduleViewMode.today,
    this.todoSelectedGroupIds,
    this.todoIncludePersonal = true,
    this.assetSelectedGroupId,
    this.memoSelectedGroupId,
    this.memoPersonalOnly = false,
    this.householdSelectedGroupId,
    this.householdViewMode = HouseholdWidgetViewMode.budget,
    this.childcareSelectedGroupId,
    this.savingsSelectedGroupId,
    this.fridgeExpirySelectedGroupId,
  });

  factory DashboardWidgetSettings.defaultSettings() {
    return const DashboardWidgetSettings();
  }

  bool isActive(String key) => widgetOrder.contains(key);

  factory DashboardWidgetSettings.fromJson(Map<String, dynamic> json) {
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

    const legacyAll = [
      'weather',
      'fridgeSummary',
      'todaySchedule',
      'investmentSummary',
      'todoSummary',
      'assetSummary',
      'memoSummary',
      'householdSummary',
      'childcareSummary',
      'savingsSummary',
    ];

    List<String> widgetOrder;
    List<String> anniversaryIds;

    // anniversaryIds 파싱: 신규 필드 또는 구 anniversary:: 키에서 마이그레이션
    final rawAnniversaryIds = json['anniversaryIds'];
    if (rawAnniversaryIds != null) {
      anniversaryIds = (rawAnniversaryIds as List<dynamic>)
          .map((e) => e as String)
          .toList();
    } else {
      // 구 포맷: widgetOrder 안의 anniversary::{id} 키에서 추출
      final savedOrder = json['widgetOrder'] as List<dynamic>? ?? [];
      anniversaryIds = savedOrder
          .map((e) => e as String)
          .where((k) => k.startsWith('anniversary::'))
          .map((k) => k.substring('anniversary::'.length))
          .toList();
    }

    if (json['widgetOrder'] != null) {
      final saved = (json['widgetOrder'] as List<dynamic>)
          .map((e) => e as String)
          .toList();

      // anniversary:: 다중 키 → 단일 'anniversary' 키로 교체 (중복 제거)
      // 구버전 'anniversarySummary' 키도 제거
      List<String> normalized = [];
      bool anniversaryInserted = false;
      for (final k in saved) {
        if (k.startsWith('anniversary::')) {
          if (!anniversaryInserted) {
            normalized.add('anniversary');
            anniversaryInserted = true;
          }
        } else if (k != 'anniversarySummary') {
          normalized.add(k);
        }
      }

      // 구버전 show* 플래그로 저장된 포맷 마이그레이션
      final hasLegacyFlags = json.keys.any((k) => k.startsWith('show'));
      if (hasLegacyFlags) {
        // 레거시 포맷: widgetOrder가 없고 show* 플래그로만 관리되던 시절의 데이터
        // normalized가 비어있을 수 있으므로 legacyAll 전체에서 show 플래그로 필터링
        final merged = [
          ...normalized,
          ...legacyAll.where((w) => !normalized.contains(w)),
        ];
        final showFlags = <String, bool>{
          'weather': json['showWeather'] as bool? ?? true,
          'fridgeSummary': json['showFridgeSummary'] as bool? ?? true,
          'todaySchedule': json['showTodaySchedule'] as bool? ?? true,
          'investmentSummary': json['showInvestmentSummary'] as bool? ?? true,
          'todoSummary': json['showTodoSummary'] as bool? ?? true,
          'assetSummary': json['showAssetSummary'] as bool? ?? true,
          'memoSummary': json['showMemoSummary'] as bool? ?? false,
          'householdSummary': json['showHouseholdSummary'] as bool? ?? false,
          'childcareSummary': json['showChildcareSummary'] as bool? ?? false,
          'savingsSummary': json['showSavingsSummary'] as bool? ?? false,
        };
        widgetOrder = merged
            .where((k) => !showFlags.containsKey(k) || (showFlags[k] ?? true))
            .toList();
      } else {
        // 현재 포맷: widgetOrder 그대로 사용
        widgetOrder = normalized;
      }
    } else {
      widgetOrder = const [
        'weather',
        'todaySchedule',
        'householdSummary',
        'investmentSummary',
        'childcareSummary',
      ];
    }

    return DashboardWidgetSettings(
      widgetOrder: widgetOrder,
      anniversaryIds: anniversaryIds,
      scheduleViewMode: parseMode('scheduleViewMode'),
      scheduleSelectedGroupIds: parseGroupIds('scheduleSelectedGroupIds'),
      scheduleIncludePersonal:
          json['scheduleIncludePersonal'] as bool? ?? true,
      todoViewMode: parseMode('todoViewMode'),
      todoSelectedGroupIds: parseGroupIds('todoSelectedGroupIds'),
      todoIncludePersonal: json['todoIncludePersonal'] as bool? ?? true,
      assetSelectedGroupId: json['assetSelectedGroupId'] as String?,
      memoSelectedGroupId: json['memoSelectedGroupId'] as String?,
      memoPersonalOnly: json['memoPersonalOnly'] as bool? ?? false,
      householdSelectedGroupId: json['householdSelectedGroupId'] as String?,
      householdViewMode: HouseholdWidgetViewMode.values.firstWhere(
        (e) => e.name == (json['householdViewMode'] as String? ?? ''),
        orElse: () => HouseholdWidgetViewMode.budget,
      ),
      childcareSelectedGroupId: json['childcareSelectedGroupId'] as String?,
      savingsSelectedGroupId: json['savingsSelectedGroupId'] as String?,
      fridgeExpirySelectedGroupId:
          json['fridgeExpirySelectedGroupId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'widgetOrder': widgetOrder,
      'anniversaryIds': anniversaryIds,
      'scheduleViewMode': scheduleViewMode.name,
      'scheduleSelectedGroupIds': scheduleSelectedGroupIds,
      'scheduleIncludePersonal': scheduleIncludePersonal,
      'todoViewMode': todoViewMode.name,
      'todoSelectedGroupIds': todoSelectedGroupIds,
      'todoIncludePersonal': todoIncludePersonal,
      'assetSelectedGroupId': assetSelectedGroupId,
      'memoSelectedGroupId': memoSelectedGroupId,
      'memoPersonalOnly': memoPersonalOnly,
      'householdSelectedGroupId': householdSelectedGroupId,
      'householdViewMode': householdViewMode.name,
      'childcareSelectedGroupId': childcareSelectedGroupId,
      'savingsSelectedGroupId': savingsSelectedGroupId,
      'fridgeExpirySelectedGroupId': fridgeExpirySelectedGroupId,
    };
  }

  DashboardWidgetSettings copyWith({
    List<String>? widgetOrder,
    Object? anniversaryIds = _sentinel,
    ScheduleViewMode? scheduleViewMode,
    Object? scheduleSelectedGroupIds = _sentinel,
    bool? scheduleIncludePersonal,
    ScheduleViewMode? todoViewMode,
    Object? todoSelectedGroupIds = _sentinel,
    bool? todoIncludePersonal,
    Object? assetSelectedGroupId = _sentinel,
    Object? memoSelectedGroupId = _sentinel,
    bool? memoPersonalOnly,
    Object? householdSelectedGroupId = _sentinel,
    HouseholdWidgetViewMode? householdViewMode,
    Object? childcareSelectedGroupId = _sentinel,
    Object? savingsSelectedGroupId = _sentinel,
    Object? fridgeExpirySelectedGroupId = _sentinel,
  }) {
    return DashboardWidgetSettings(
      widgetOrder: widgetOrder ?? this.widgetOrder,
      anniversaryIds: anniversaryIds == _sentinel
          ? this.anniversaryIds
          : anniversaryIds as List<String>,
      scheduleViewMode: scheduleViewMode ?? this.scheduleViewMode,
      scheduleSelectedGroupIds: scheduleSelectedGroupIds == _sentinel
          ? this.scheduleSelectedGroupIds
          : scheduleSelectedGroupIds as List<String>?,
      scheduleIncludePersonal:
          scheduleIncludePersonal ?? this.scheduleIncludePersonal,
      todoViewMode: todoViewMode ?? this.todoViewMode,
      todoSelectedGroupIds: todoSelectedGroupIds == _sentinel
          ? this.todoSelectedGroupIds
          : todoSelectedGroupIds as List<String>?,
      todoIncludePersonal: todoIncludePersonal ?? this.todoIncludePersonal,
      assetSelectedGroupId: assetSelectedGroupId == _sentinel
          ? this.assetSelectedGroupId
          : assetSelectedGroupId as String?,
      memoSelectedGroupId: memoSelectedGroupId == _sentinel
          ? this.memoSelectedGroupId
          : memoSelectedGroupId as String?,
      memoPersonalOnly: memoPersonalOnly ?? this.memoPersonalOnly,
      householdSelectedGroupId: householdSelectedGroupId == _sentinel
          ? this.householdSelectedGroupId
          : householdSelectedGroupId as String?,
      householdViewMode: householdViewMode ?? this.householdViewMode,
      childcareSelectedGroupId: childcareSelectedGroupId == _sentinel
          ? this.childcareSelectedGroupId
          : childcareSelectedGroupId as String?,
      savingsSelectedGroupId: savingsSelectedGroupId == _sentinel
          ? this.savingsSelectedGroupId
          : savingsSelectedGroupId as String?,
      fridgeExpirySelectedGroupId: fridgeExpirySelectedGroupId == _sentinel
          ? this.fridgeExpirySelectedGroupId
          : fridgeExpirySelectedGroupId as String?,
    );
  }
}

const Object _sentinel = Object();
