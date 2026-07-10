import Foundation

let widgetGroupId = "group.com.hmncorp.familyplanner"

struct ScheduleItem: Decodable {
    let title: String
    let scheduledAt: String?
    let allDay: Bool
    let colorHex: String
    let isCompleted: Bool

    var timeText: String {
        if allDay { return "종일" }
        guard let scheduledAt = scheduledAt, let tIndex = scheduledAt.firstIndex(of: "T") else {
            return "-"
        }
        let timePart = scheduledAt[scheduledAt.index(after: tIndex)...]
        return String(timePart.prefix(5))
    }
}

struct MonthScheduleData: Decodable {
    let year: Int
    let month: Int
    let markedDates: [String]
}

enum ScheduleWidgetData {
    private static let todayTasksKey = "today_tasks"
    private static let monthTasksKey = "month_tasks"

    static func readTodayTasks() -> [ScheduleItem] {
        guard let defaults = UserDefaults(suiteName: widgetGroupId),
            let raw = defaults.string(forKey: todayTasksKey),
            let data = raw.data(using: .utf8)
        else { return [] }

        return (try? JSONDecoder().decode([ScheduleItem].self, from: data)) ?? []
    }

    static func readMonthTasks() -> MonthScheduleData? {
        guard let defaults = UserDefaults(suiteName: widgetGroupId),
            let raw = defaults.string(forKey: monthTasksKey),
            let data = raw.data(using: .utf8)
        else { return nil }

        return try? JSONDecoder().decode(MonthScheduleData.self, from: data)
    }
}
