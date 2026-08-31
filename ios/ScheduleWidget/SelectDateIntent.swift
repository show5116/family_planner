import AppIntents
import WidgetKit

/// 달력에서 선택한 날짜(yyyy-MM-dd) 저장소.
/// iOS는 위젯 인스턴스를 식별할 표준 API가 없어(Android의 appWidgetId 같은 개념 부재)
/// [WidgetMonthOffsetStore]와 마찬가지로 위젯 종류(kind) 단위 전역으로 저장한다.
/// 값이 없으면(nil) 오늘 날짜를 기본 선택으로 간주한다.
enum WidgetSelectedDateStore {
    private static let key = "selected_date_global"

    static func getSelectedDate() -> String? {
        guard let defaults = UserDefaults(suiteName: widgetGroupId) else { return nil }
        return defaults.string(forKey: key)
    }

    static func setSelectedDate(_ dateKey: String) {
        guard let defaults = UserDefaults(suiteName: widgetGroupId) else { return }
        defaults.set(dateKey, forKey: key)
    }

    static func clearSelectedDate() {
        guard let defaults = UserDefaults(suiteName: widgetGroupId) else { return }
        defaults.removeObject(forKey: key)
    }
}

/// 위젯 내 날짜 셀(iOS 17+ 인터랙티브 위젯)을 눌렀을 때 해당 날짜를 선택 상태로 저장하고
/// 그 날짜의 일정 목록으로 위젯을 다시 그린다.
struct SelectDateIntent: AppIntent {
    static var title: LocalizedStringResource = "날짜 선택"

    @Parameter(title: "dateKey")
    var dateKey: String

    init() {
        self.dateKey = ""
    }

    init(dateKey: String) {
        self.dateKey = dateKey
    }

    func perform() async throws -> some IntentResult {
        WidgetSelectedDateStore.setSelectedDate(dateKey)
        MonthCalendarWidgetReloadHelper.reload()
        return .result()
    }
}
