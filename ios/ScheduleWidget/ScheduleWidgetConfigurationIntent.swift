import AppIntents
import WidgetKit

/// 위젯 인스턴스 편집(길게 눌러 "위젯 편집") 시 표시할 그룹을 선택하는 App Intent.
/// iOS 17+에서만 동작한다. iOS 16 이하는 항상 전체 그룹 + 개인 일정을 표시한다(필터 없음).
struct GroupFilterEntity: AppEntity, Identifiable {
    let id: String
    let name: String

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "그룹"
    static var defaultQuery = GroupFilterQuery()

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
}

struct GroupFilterQuery: EntityQuery {
    func entities(for identifiers: [GroupFilterEntity.ID]) async throws -> [GroupFilterEntity] {
        allEntities().filter { identifiers.contains($0.id) }
    }

    func suggestedEntities() async throws -> [GroupFilterEntity] {
        allEntities()
    }

    private func allEntities() -> [GroupFilterEntity] {
        ScheduleWidgetData.readGroups().map { GroupFilterEntity(id: $0.id, name: $0.name) }
    }
}

struct ScheduleWidgetConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "위젯에 표시할 그룹"
    static var description = IntentDescription("선택한 그룹의 일정만 이 위젯에 표시됩니다.")

    @Parameter(title: "표시할 그룹", default: [])
    var selectedGroups: [GroupFilterEntity]

    @Parameter(title: "개인 일정 포함", default: true)
    var includePersonal: Bool

    /// selectedGroups가 비어 있으면 "전체 포함"(필터 없음)으로 해석한다.
    func resolvedFilter() -> WidgetScheduleFilter {
        if selectedGroups.isEmpty {
            return WidgetScheduleFilter(selectedGroupIds: nil, includePersonal: includePersonal)
        }
        return WidgetScheduleFilter(
            selectedGroupIds: Set(selectedGroups.map { $0.id }),
            includePersonal: includePersonal
        )
    }
}
