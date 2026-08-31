import AppIntents
import WidgetKit
import SwiftUI

struct ScheduleListEntry: TimelineEntry {
    let date: Date
    let items: [ScheduleItem]
}

struct ScheduleListProvider: AppIntentTimelineProvider {
    typealias Intent = ScheduleWidgetConfigurationIntent
    typealias Entry = ScheduleListEntry

    func placeholder(in context: Context) -> ScheduleListEntry {
        ScheduleListEntry(date: Date(), items: [])
    }

    func snapshot(for configuration: ScheduleWidgetConfigurationIntent, in context: Context) async -> ScheduleListEntry {
        currentEntry(configuration)
    }

    func timeline(for configuration: ScheduleWidgetConfigurationIntent, in context: Context) async -> Timeline<ScheduleListEntry> {
        Timeline(entries: [currentEntry(configuration)], policy: .atEnd)
    }

    private func currentEntry(_ configuration: ScheduleWidgetConfigurationIntent) -> ScheduleListEntry {
        let items = ScheduleWidgetData.readTodayTasks().applyFilter(configuration.resolvedFilter())
        return ScheduleListEntry(date: Date(), items: items)
    }
}

struct ScheduleListEntryView: View {
    var entry: ScheduleListProvider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Link(destination: URL(string: "familyplanner://widget/calendar")!) {
                    Text("오늘 일정")
                        .font(.system(size: 13, weight: .bold))
                }
                Spacer()
                Link(destination: URL(string: "familyplanner://widget/add")!) {
                    Image(systemName: "plus")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.accentColor)
                }
            }

            if entry.items.isEmpty {
                Text("오늘 일정이 없습니다")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            } else {
                ForEach(entry.items.prefix(5), id: \.id) { item in
                    Link(destination: URL(string: "familyplanner://widget/task?id=\(item.id)")!) {
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Color(hex: item.colorHex))
                                .frame(width: 6, height: 6)
                            Text(item.timeText)
                                .font(.system(size: 11))
                                .foregroundColor(.secondary)
                            Text(item.title)
                                .font(.system(size: 12))
                                .strikethrough(item.isCompleted)
                                .lineLimit(1)
                        }
                    }
                }
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .widgetURL(URL(string: "familyplanner://widget/calendar"))
    }
}

struct ScheduleListWidget: Widget {
    let kind: String = "ScheduleListWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ScheduleWidgetConfigurationIntent.self,
            provider: ScheduleListProvider()
        ) { entry in
            ScheduleListEntryView(entry: entry)
        }
        .configurationDisplayName("오늘 일정")
        .description("오늘의 일정을 홈 화면에서 바로 확인하세요.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
