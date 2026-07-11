package com.hmncorp.familyplanner.widget

import android.content.Context

/**
 * 위젯 인스턴스(appWidgetId)별 "이번달 기준 몇 달 이동했는지" 오프셋 저장소.
 * 0 = 이번달, 1 = 다음달, -1 = 지난달 ...
 *
 * 실제 연/월 데이터(entries)는 Flutter가 항상 "이번달" 것만 동기화하므로,
 * 오프셋이 0이 아닌 달을 보려면 위젯이 별도로 그 달의 markedDates를 계산할 수 없다.
 * 따라서 월 이동은 Flutter가 사전 동기화해 둔 범위(이번달 -1 ~ +1) 내에서만 지원한다.
 */
object WidgetMonthOffsetStore {
    private const val PREFS_NAME = "widget_month_offset_prefs"
    private const val KEY_OFFSET_PREFIX = "month_offset_"
    private const val MIN_OFFSET = -1
    private const val MAX_OFFSET = 1

    fun getOffset(context: Context, widgetId: Int): Int {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        return prefs.getInt(KEY_OFFSET_PREFIX + widgetId, 0)
    }

    fun changeOffset(context: Context, widgetId: Int, delta: Int): Int {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val current = prefs.getInt(KEY_OFFSET_PREFIX + widgetId, 0)
        val next = (current + delta).coerceIn(MIN_OFFSET, MAX_OFFSET)
        prefs.edit().putInt(KEY_OFFSET_PREFIX + widgetId, next).apply()
        return next
    }

    fun resetOffset(context: Context, widgetId: Int) {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        prefs.edit().remove(KEY_OFFSET_PREFIX + widgetId).apply()
    }
}
