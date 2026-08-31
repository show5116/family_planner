import Foundation

let widgetGroupId = "group.com.hmncorp.familyplanner"

struct ScheduleItem: Decodable {
    let id: String
    let title: String
    let scheduledAt: String?
    let allDay: Bool
    let colorHex: String
    let isCompleted: Bool
    let groupId: String? // nil = 개인 일정

    var timeText: String {
        if allDay { return "종일" }
        guard let scheduledAt = scheduledAt, let tIndex = scheduledAt.firstIndex(of: "T") else {
            return "-"
        }
        let timePart = scheduledAt[scheduledAt.index(after: tIndex)...]
        return String(timePart.prefix(5))
    }
}

/// 월간 데이터의 날짜별 항목. 일정 상세(item)를 함께 들고 있어
/// 위젯이 특정 날짜를 탭했을 때 서버 호출 없이 그 날짜의 일정 목록을 그릴 수 있다.
struct MonthDateEntry: Decodable {
    let date: String
    let item: ScheduleItem

    var groupId: String? { item.groupId }

    private enum CodingKeys: String, CodingKey {
        case date
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(String.self, forKey: .date)
        item = try ScheduleItem(from: decoder)
    }
}

struct MonthScheduleData: Decodable {
    let year: Int
    let month: Int
    let entries: [MonthDateEntry]
}

struct WidgetGroup: Decodable, Identifiable, Hashable {
    let id: String
    let name: String
    let colorHex: String
}

enum ScheduleWidgetData {
    private static let todayTasksKey = "today_tasks"
    private static let monthTasksKey = "month_tasks"
    private static let groupsKey = "widget_groups"

    static func readTodayTasks() -> [ScheduleItem] {
        guard let defaults = UserDefaults(suiteName: widgetGroupId),
            let raw = defaults.string(forKey: todayTasksKey),
            let data = raw.data(using: .utf8)
        else { return [] }

        return (try? JSONDecoder().decode([ScheduleItem].self, from: data)) ?? []
    }

    /// 동기화된 지난달/이번달/다음달(-1~+1) 목록을 모두 읽는다
    static func readMonths() -> [MonthScheduleData] {
        guard let defaults = UserDefaults(suiteName: widgetGroupId),
            let raw = defaults.string(forKey: monthTasksKey),
            let data = raw.data(using: .utf8)
        else { return [] }

        struct Root: Decodable { let months: [MonthScheduleData] }
        return (try? JSONDecoder().decode(Root.self, from: data))?.months ?? []
    }

    /// [readMonths] 결과에서 특정 연/월을 찾는다. 없으면 빈 entries를 가진 데이터를 반환한다.
    static func readMonth(year: Int, month: Int) -> MonthScheduleData {
        readMonths().first { $0.year == year && $0.month == month }
            ?? MonthScheduleData(year: year, month: month, entries: [])
    }

    static func readGroups() -> [WidgetGroup] {
        guard let defaults = UserDefaults(suiteName: widgetGroupId),
            let raw = defaults.string(forKey: groupsKey),
            let data = raw.data(using: .utf8)
        else { return [] }

        return (try? JSONDecoder().decode([WidgetGroup].self, from: data)) ?? []
    }
}

/// 위젯 인스턴스별 그룹 필터. selectedGroupIds가 nil이면 전체 포함(필터 없음).
struct WidgetScheduleFilter {
    let selectedGroupIds: Set<String>?
    let includePersonal: Bool

    static let all = WidgetScheduleFilter(selectedGroupIds: nil, includePersonal: true)

    func matches(groupId: String?) -> Bool {
        guard let groupId = groupId else { return includePersonal }
        guard let selectedGroupIds = selectedGroupIds else { return true }
        return selectedGroupIds.contains(groupId)
    }
}

extension Array where Element == ScheduleItem {
    func applyFilter(_ filter: WidgetScheduleFilter) -> [ScheduleItem] {
        self.filter { filter.matches($0.groupId) }
    }
}

extension MonthScheduleData {
    func markedDates(_ filter: WidgetScheduleFilter) -> Set<String> {
        Set(entries.filter { filter.matches($0.groupId) }.map { $0.date })
    }

    /// 특정 날짜(dateKey, "yyyy-MM-dd")의 일정 목록을 시간순으로 반환한다
    func items(forDate dateKey: String, filter: WidgetScheduleFilter) -> [ScheduleItem] {
        entries
            .filter { $0.date == dateKey && filter.matches($0.groupId) }
            .map { $0.item }
            .sorted { ($0.scheduledAt ?? "") < ($1.scheduledAt ?? "") }
    }
}
