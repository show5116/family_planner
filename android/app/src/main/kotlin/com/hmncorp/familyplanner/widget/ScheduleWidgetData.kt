package com.hmncorp.familyplanner.widget

import android.content.Context
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONArray
import org.json.JSONObject

data class ScheduleItem(
    val id: String,
    val title: String,
    val scheduledAt: String?,
    val allDay: Boolean,
    val colorHex: String,
    val isCompleted: Boolean,
    val groupId: String?, // null = 개인 일정
)

data class MonthDateEntry(
    val date: String,
    val item: ScheduleItem,
) {
    val groupId: String? get() = item.groupId
}

data class MonthScheduleData(
    val year: Int,
    val month: Int,
    val entries: List<MonthDateEntry>,
)

data class WidgetGroup(
    val id: String,
    val name: String,
    val colorHex: String,
)

/** Flutter의 HomeWidgetService가 저장한 JSON을 읽어 위젯이 쓰기 좋은 형태로 파싱 */
object ScheduleWidgetData {
    private const val KEY_TODAY_TASKS = "today_tasks"
    private const val KEY_MONTH_TASKS = "month_tasks"
    private const val KEY_GROUPS = "widget_groups"

    fun readTodayTasks(context: Context): List<ScheduleItem> {
        val raw = HomeWidgetPlugin.getData(context).getString(KEY_TODAY_TASKS, null) ?: return emptyList()
        return try {
            val array = JSONArray(raw)
            (0 until array.length()).map { i ->
                val obj = array.getJSONObject(i)
                ScheduleItem(
                    id = obj.optString("id", ""),
                    title = obj.optString("title", ""),
                    scheduledAt = obj.optString("scheduledAt", null),
                    allDay = obj.optBoolean("allDay", false),
                    colorHex = obj.optString("colorHex", "#2196F3"),
                    isCompleted = obj.optBoolean("isCompleted", false),
                    groupId = if (obj.isNull("groupId")) null else obj.optString("groupId", null),
                )
            }
        } catch (e: Exception) {
            emptyList()
        }
    }

    /** 동기화된 지난달/이번달/다음달(-1~+1) 목록을 모두 읽는다 */
    fun readMonths(context: Context): List<MonthScheduleData> {
        val raw = HomeWidgetPlugin.getData(context).getString(KEY_MONTH_TASKS, null) ?: return emptyList()
        return try {
            val root = JSONObject(raw)
            val monthsArray = root.optJSONArray("months") ?: return emptyList()
            (0 until monthsArray.length()).mapNotNull { i ->
                val obj = monthsArray.getJSONObject(i)
                val year = obj.optInt("year", -1)
                val month = obj.optInt("month", -1)
                if (year < 0 || month < 0) return@mapNotNull null
                val rawEntries = obj.optJSONArray("entries") ?: JSONArray()
                val entries = (0 until rawEntries.length()).map { j ->
                    val entryObj = rawEntries.getJSONObject(j)
                    MonthDateEntry(
                        date = entryObj.optString("date", ""),
                        item = ScheduleItem(
                            id = entryObj.optString("id", ""),
                            title = entryObj.optString("title", ""),
                            scheduledAt = entryObj.optString("scheduledAt", null),
                            allDay = entryObj.optBoolean("allDay", false),
                            colorHex = entryObj.optString("colorHex", "#2196F3"),
                            isCompleted = entryObj.optBoolean("isCompleted", false),
                            groupId = if (entryObj.isNull("groupId")) null else entryObj.optString("groupId", null),
                        ),
                    )
                }
                MonthScheduleData(year, month, entries)
            }
        } catch (e: Exception) {
            emptyList()
        }
    }

    /** [readMonths] 결과에서 특정 연/월을 찾는다. 없으면 빈 entries를 가진 데이터를 반환한다. */
    fun readMonth(context: Context, year: Int, month: Int): MonthScheduleData {
        return readMonths(context).firstOrNull { it.year == year && it.month == month }
            ?: MonthScheduleData(year, month, emptyList())
    }

    fun readGroups(context: Context): List<WidgetGroup> {
        val raw = HomeWidgetPlugin.getData(context).getString(KEY_GROUPS, null) ?: return emptyList()
        return try {
            val array = JSONArray(raw)
            (0 until array.length()).map { i ->
                val obj = array.getJSONObject(i)
                WidgetGroup(
                    id = obj.optString("id", ""),
                    name = obj.optString("name", ""),
                    colorHex = obj.optString("colorHex", "#2196F3"),
                )
            }
        } catch (e: Exception) {
            emptyList()
        }
    }
}

/**
 * 위젯 인스턴스별 그룹 필터 설정.
 * [selectedGroupIds] null = 전체 그룹 포함(필터 없음), 빈 set = 그룹 전부 해제(개인만),
 * 값 있음 = 해당 그룹만 포함.
 * [includePersonal] 개인 일정 포함 여부
 */
data class WidgetFilter(
    val selectedGroupIds: Set<String>?,
    val includePersonal: Boolean,
) {
    fun matches(groupId: String?): Boolean {
        if (groupId == null) return includePersonal
        if (selectedGroupIds == null) return true
        return selectedGroupIds.contains(groupId)
    }

    companion object {
        val ALL = WidgetFilter(selectedGroupIds = null, includePersonal = true)
    }
}

fun List<ScheduleItem>.applyFilter(filter: WidgetFilter): List<ScheduleItem> =
    filter { filter.matches(it.groupId) }

fun MonthScheduleData.markedDates(filter: WidgetFilter): Set<String> =
    entries.filter { filter.matches(it.groupId) }.map { it.date }.toSet()

/** 특정 날짜(dateKey, "yyyy-MM-dd")의 일정 목록을 시간순으로 반환한다 */
fun MonthScheduleData.itemsForDate(dateKey: String, filter: WidgetFilter): List<ScheduleItem> =
    entries
        .filter { it.date == dateKey && filter.matches(it.groupId) }
        .map { it.item }
        .sortedWith(compareBy(nullsLast()) { it.scheduledAt })
