import WidgetKit
import SwiftUI

struct MonthCalendarEntry: TimelineEntry {
    let date: Date
    let monthData: MonthScheduleData?
    let todayItems: [ScheduleItem]
}

struct MonthCalendarProvider: TimelineProvider {
    func placeholder(in context: Context) -> MonthCalendarEntry {
        MonthCalendarEntry(date: Date(), monthData: nil, todayItems: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (MonthCalendarEntry) -> Void) {
        completion(currentEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MonthCalendarEntry>) -> Void) {
        completion(Timeline(entries: [currentEntry()], policy: .atEnd))
    }

    private func currentEntry() -> MonthCalendarEntry {
        MonthCalendarEntry(
            date: Date(),
            monthData: ScheduleWidgetData.readMonthTasks(),
            todayItems: ScheduleWidgetData.readTodayTasks()
        )
    }
}

private enum CalendarPalette {
    static let textPrimary = Color(red: 0.11, green: 0.11, blue: 0.12)
    static let textSecondary = Color(red: 0.47, green: 0.45, blue: 0.49)
    static let todayBg = Color(red: 0.10, green: 0.45, blue: 0.91)
    static let dot = Color(red: 0.10, green: 0.45, blue: 0.91)
    static let divider = Color(red: 0.91, green: 0.92, blue: 0.92)
    static let sunday = Color(red: 0.90, green: 0.22, blue: 0.21)
}

struct MonthCalendarEntryView: View {
    var entry: MonthCalendarProvider.Entry

    private var calendar: Calendar { Calendar.current }
    private var year: Int { entry.monthData?.year ?? calendar.component(.year, from: Date()) }
    private var month: Int { entry.monthData?.month ?? calendar.component(.month, from: Date()) }
    private var markedDates: Set<String> { Set(entry.monthData?.markedDates ?? []) }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\(String(year))년 \(month)월")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(CalendarPalette.textPrimary)

            CalendarGridView(year: year, month: month, markedDates: markedDates)

            Rectangle()
                .fill(CalendarPalette.divider)
                .frame(height: 1)

            Text("오늘 일정")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(CalendarPalette.textPrimary)

            if entry.todayItems.isEmpty {
                Text("오늘 일정이 없습니다")
                    .font(.system(size: 12))
                    .foregroundColor(CalendarPalette.textSecondary)
            } else {
                ForEach(entry.todayItems.prefix(3), id: \.title) { item in
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color(hex: item.colorHex))
                            .frame(width: 6, height: 6)
                        Text(item.title)
                            .font(.system(size: 12))
                            .foregroundColor(CalendarPalette.textPrimary)
                            .lineLimit(1)
                    }
                }
            }
            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .widgetURL(URL(string: "familyplanner://widget/calendar"))
    }
}

private struct CalendarGridView: View {
    let year: Int
    let month: Int
    let markedDates: Set<String>

    private var calendar: Calendar { Calendar.current }
    private let weekLabels = ["일", "월", "화", "수", "목", "금", "토"]

    private var firstWeekday: Int {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        let firstDay = calendar.date(from: components) ?? Date()
        return calendar.component(.weekday, from: firstDay) - 1 // 0 = 일요일
    }

    private var daysInMonth: Int {
        var components = DateComponents()
        components.year = year
        components.month = month
        let date = calendar.date(from: components) ?? Date()
        return calendar.range(of: .day, in: .month, for: date)?.count ?? 30
    }

    private var todayDay: Int? {
        let today = Date()
        let isCurrentMonth = calendar.component(.year, from: today) == year
            && calendar.component(.month, from: today) == month
        return isCurrentMonth ? calendar.component(.day, from: today) : nil
    }

    private func dateKey(_ day: Int) -> String {
        String(format: "%04d-%02d-%02d", year, month, day)
    }

    private func weekdayColor(_ index: Int) -> Color {
        switch index {
        case 0: return CalendarPalette.sunday
        case 6: return CalendarPalette.todayBg
        default: return CalendarPalette.textSecondary
        }
    }

    var body: some View {
        let totalCells = firstWeekday + daysInMonth
        let totalRows = (totalCells + 6) / 7

        VStack(spacing: 4) {
            HStack(spacing: 0) {
                ForEach(Array(weekLabels.enumerated()), id: \.offset) { index, label in
                    Text(label)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(weekdayColor(index))
                        .frame(maxWidth: .infinity)
                }
            }

            ForEach(0..<totalRows, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<7, id: \.self) { col in
                        let cellIndex = row * 7 + col
                        let day = cellIndex - firstWeekday + 1
                        if day < 1 || day > daysInMonth {
                            Spacer().frame(maxWidth: .infinity, minHeight: 26)
                        } else {
                            DayCell(
                                day: day,
                                isToday: todayDay == day,
                                hasSchedule: markedDates.contains(dateKey(day))
                            )
                        }
                    }
                }
            }
        }
    }
}

private struct DayCell: View {
    let day: Int
    let isToday: Bool
    let hasSchedule: Bool

    var body: some View {
        VStack(spacing: 1) {
            Text("\(day)")
                .font(.system(size: 12, weight: isToday ? .bold : .regular))
                .foregroundColor(isToday ? .white : CalendarPalette.textPrimary)
                .frame(width: 22, height: 22)
                .background(isToday ? CalendarPalette.todayBg : Color.clear)
                .clipShape(Circle())
            Circle()
                .fill(hasSchedule && !isToday ? CalendarPalette.dot : Color.clear)
                .frame(width: 4, height: 4)
        }
        .frame(maxWidth: .infinity, minHeight: 26)
    }
}

struct MonthCalendarWidget: Widget {
    let kind: String = "MonthCalendarWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MonthCalendarProvider()) { entry in
            MonthCalendarEntryView(entry: entry)
        }
        .configurationDisplayName("이번달 달력")
        .description("이번달 일정을 달력으로 한눈에 확인하세요.")
        .supportedFamilies([.systemLarge])
    }
}
