import AppIntents
import WidgetKit

/// 표시 중인 월 오프셋 저장소.
/// 0 = 이번달, 1 = 다음달, -1 = 지난달. Flutter가 -1~+1 범위만 동기화하므로 이 범위로 제한한다.
///
/// iOS WidgetKit은 위젯 인스턴스를 앱 코드에서 식별할 표준 API가 없어(Android의 appWidgetId 같은
/// 개념 부재), Android처럼 인스턴스별로 오프셋을 분리 저장하지 못하고 위젯 종류(kind) 단위로
/// 전역 저장한다. 즉 동일 종류의 위젯을 여러 개 추가한 경우 모두 같은 월을 표시한다.
enum WidgetMonthOffsetStore {
    private static let key = "month_offset_global"
    private static let minOffset = -1
    private static let maxOffset = 1

    static func getOffset() -> Int {
        guard let defaults = UserDefaults(suiteName: widgetGroupId) else { return 0 }
        return defaults.integer(forKey: key)
    }

    @discardableResult
    static func changeOffset(delta: Int) -> Int {
        guard let defaults = UserDefaults(suiteName: widgetGroupId) else { return 0 }
        let current = defaults.integer(forKey: key)
        let next = min(max(current + delta, minOffset), maxOffset)
        defaults.set(next, forKey: key)
        return next
    }
}

/// 위젯 내 "◀"/"▶" 버튼(iOS 17+ 인터랙티브 위젯)을 눌렀을 때 표시 중인 월 오프셋을 변경한다.
struct ChangeMonthIntent: AppIntent {
    static var title: LocalizedStringResource = "월 이동"

    @Parameter(title: "delta")
    var delta: Int

    init() {
        self.delta = 0
    }

    init(delta: Int) {
        self.delta = delta
    }

    func perform() async throws -> some IntentResult {
        WidgetMonthOffsetStore.changeOffset(delta: delta)
        // 다른 달로 이동하면 이전에 선택해 둔 날짜는 더 이상 유효하지 않으므로 초기화한다
        WidgetSelectedDateStore.clearSelectedDate()
        MonthCalendarWidgetReloadHelper.reload()
        return .result()
    }
}

enum MonthCalendarWidgetReloadHelper {
    static func reload() {
        WidgetCenter.shared.reloadTimelines(ofKind: "MonthCalendarWidget")
    }
}
