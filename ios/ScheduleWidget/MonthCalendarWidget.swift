import AppIntents
import WidgetKit
import SwiftUI

struct MonthCalendarEntry: TimelineEntry {
    let date: Date
    let monthData: MonthScheduleData
    let selectedDate: String
    let selectedItems: [ScheduleItem]
    let filter: WidgetScheduleFilter
}

struct MonthCalendarProvider: AppIntentTimelineProvider {
    typealias Intent = ScheduleWidgetConfigurationIntent
    typealias Entry = MonthCalendarEntry

    func placeholder(in context: Context) -> MonthCalendarEntry {
        let now = Date()
        let calendar = Calendar.current
        let placeholderMonth = MonthScheduleData(
            year: calendar.component(.year, from: now),
            month: calendar.component(.month, from: now),
            entries: []
        )
        return MonthCalendarEntry(
            date: now,
            monthData: placeholderMonth,
            selectedDate: dateKey(now),
            selectedItems: [],
            filter: .all
        )
    }

    func snapshot(for configuration: ScheduleWidgetConfigurationIntent, in context: Context) async -> MonthCalendarEntry {
        currentEntry(configuration)
    }

    func timeline(for configuration: ScheduleWidgetConfigurationIntent, in context: Context) async -> Timeline<MonthCalendarEntry> {
        Timeline(entries: [currentEntry(configuration)], policy: .atEnd)
    }

    private func currentEntry(_ configuration: ScheduleWidgetConfigurationIntent) -> MonthCalendarEntry {
        let filter = configuration.resolvedFilter()
        let offset = WidgetMonthOffsetStore.getOffset()
        let calendar = Calendar.current
        let now = Date()
        let target = calendar.date(byAdding: .month, value: offset, to: now) ?? now
        let year = calendar.component(.year, from: target)
        let month = calendar.component(.month, from: target)

        let monthData = ScheduleWidgetData.readMonth(year: year, month: month)
        let todayKey = dateKey(now)
        let selectedDate = WidgetSelectedDateStore.getSelectedDate() ?? todayKey
        let selectedItems = selectedDate == todayKey
            ? ScheduleWidgetData.readTodayTasks().applyFilter(filter)
            : monthData.items(forDate: selectedDate, filter: filter)

        return MonthCalendarEntry(
            date: Date(),
            monthData: monthData,
            selectedDate: selectedDate,
            selectedItems: selectedItems,
            filter: filter
        )
    }
}

private func dateKey(_ date: Date) -> String {
    let calendar = Calendar.current
    let year = calendar.component(.year, from: date)
    let month = calendar.component(.month, from: date)
    let day = calendar.component(.day, from: date)
    return String(format: "%04d-%02d-%02d", year, month, day)
}

/// "2026-07-15" -> 오늘이면 "오늘 일정", 아니면 "7월 15일 일정"
private func selectedDateLabel(_ selected: String) -> String {
    let parts = selected.split(separator: "-")
    guard parts.count == 3 else { return "일정" }
    if selected == dateKey(Date()) {
        return "오늘 일정"
    }
    guard let month = Int(parts[1]), let day = Int(parts[2]) else { return "일정" }
    return "\(month)월 \(day)일 일정"
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
    private var year: Int { entry.monthData.year }
    private var month: Int { entry.monthData.month }
    private var markedDates: Set<String> { entry.monthData.markedDates(entry.filter) }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Button(intent: ChangeMonthIntent(delta: -1)) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(CalendarPalette.textSecondary)
                }
                .buttonStyle(.plain)

                Link(destination: URL(string: "familyplanner://widget/calendar")!) {
                    Text("\(String(year))년 \(month)월")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(CalendarPalette.textPrimary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Button(intent: ChangeMonthIntent(delta: 1)) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(CalendarPalette.textSecondary)
                }
                .buttonStyle(.plain)

                Link(destination: URL(string: "familyplanner://widget/add")!) {
                    Image(systemName: "plus")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.accentColor)
                }
                .padding(.leading, 4)
            }

            CalendarGridView(year: year, month: month, selectedDate: entry.selectedDate, markedDates: markedDates)

            Rectangle()
                .fill(CalendarPalette.divider)
                .frame(height: 1)

            Text(selectedDateLabel(entry.selectedDate))
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(CalendarPalette.textPrimary)

            if entry.selectedItems.isEmpty {
                Text("일정이 없습니다")
                    .font(.system(size: 12))
                    .foregroundColor(CalendarPalette.textSecondary)
            } else {
                ForEach(entry.selectedItems.prefix(3), id: \.id) { item in
                    Link(destination: URL(string: "familyplanner://widget/task?id=\(item.id)")!) {
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
    let selectedDate: String
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
                            Button(intent: SelectDateIntent(dateKey: dateKey(day))) {
                                DayCell(
                                    day: day,
                                    isToday: todayDay == day,
                                    isSelected: selectedDate == dateKey(day),
                                    hasSchedule: markedDates.contains(dateKey(day))
                                )
                            }
                            .buttonStyle(.plain)
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
    let isSelected: Bool
    let hasSchedule: Bool

    private var background: Color {
        if isSelected { return CalendarPalette.todayBg }
        if isToday { return CalendarPalette.todayBg.opacity(0.35) }
        return .clear
    }

    var body: some View {
        VStack(spacing: 1) {
            Text("\(day)")
                .font(.system(size: 12, weight: isToday || isSelected ? .bold : .regular))
                .foregroundColor(isSelected ? .white : CalendarPalette.textPrimary)
                .frame(width: 22, height: 22)
                .background(background)
                .clipShape(Circle())
            Circle()
                .fill(hasSchedule && !isSelected ? CalendarPalette.dot : Color.clear)
                .frame(width: 4, height: 4)
        }
        .frame(maxWidth: .infinity, minHeight: 26)
    }
}

struct MonthCalendarWidget: Widget {
    let kind: String = "MonthCalendarWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ScheduleWidgetConfigurationIntent.self,
            provider: MonthCalendarProvider()
        ) { entry in
            MonthCalendarEntryView(entry: entry)
        }
        .configurationDisplayName("이번달 달력")
        .description("이번달 일정을 달력으로 한눈에 확인하세요.")
        .supportedFamilies([.systemLarge])
    }
}
