package com.hmncorp.familyplanner.widget

import android.content.Context
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONArray
import org.json.JSONObject

data class ScheduleItem(
    val title: String,
    val scheduledAt: String?,
    val allDay: Boolean,
    val colorHex: String,
    val isCompleted: Boolean,
)

data class MonthScheduleData(
    val year: Int,
    val month: Int,
    val markedDates: Set<String>,
)

/** Flutter의 HomeWidgetService가 저장한 JSON을 읽어 위젯이 쓰기 좋은 형태로 파싱 */
object ScheduleWidgetData {
    private const val KEY_TODAY_TASKS = "today_tasks"
    private const val KEY_MONTH_TASKS = "month_tasks"

    fun readTodayTasks(context: Context): List<ScheduleItem> {
        val raw = HomeWidgetPlugin.getData(context).getString(KEY_TODAY_TASKS, null) ?: return emptyList()
        return try {
            val array = JSONArray(raw)
            (0 until array.length()).map { i ->
                val obj = array.getJSONObject(i)
                ScheduleItem(
                    title = obj.optString("title", ""),
                    scheduledAt = obj.optString("scheduledAt", null),
                    allDay = obj.optBoolean("allDay", false),
                    colorHex = obj.optString("colorHex", "#2196F3"),
                    isCompleted = obj.optBoolean("isCompleted", false),
                )
            }
        } catch (e: Exception) {
            emptyList()
        }
    }

    fun readMonthTasks(context: Context): MonthScheduleData? {
        val raw = HomeWidgetPlugin.getData(context).getString(KEY_MONTH_TASKS, null) ?: return null
        return try {
            val obj = JSONObject(raw)
            val year = obj.optInt("year", -1)
            val month = obj.optInt("month", -1)
            if (year < 0 || month < 0) return null
            val marked = obj.optJSONArray("markedDates") ?: JSONArray()
            val markedSet = (0 until marked.length()).map { marked.getString(it) }.toSet()
            MonthScheduleData(year, month, markedSet)
        } catch (e: Exception) {
            null
        }
    }
}
