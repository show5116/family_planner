package com.hmncorp.familyplanner.widget

import android.content.Context

/**
 * 위젯 인스턴스(appWidgetId)별 "달력에서 선택한 날짜(yyyy-MM-dd)" 저장소.
 * 값이 없으면(null) 오늘 날짜를 기본 선택으로 간주한다.
 */
object WidgetSelectedDateStore {
    private const val PREFS_NAME = "widget_selected_date_prefs"
    private const val KEY_DATE_PREFIX = "selected_date_"

    fun getSelectedDate(context: Context, widgetId: Int): String? {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        return prefs.getString(KEY_DATE_PREFIX + widgetId, null)
    }

    fun setSelectedDate(context: Context, widgetId: Int, dateKey: String) {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        prefs.edit().putString(KEY_DATE_PREFIX + widgetId, dateKey).apply()
    }

    fun clearSelectedDate(context: Context, widgetId: Int) {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        prefs.edit().remove(KEY_DATE_PREFIX + widgetId).apply()
    }
}
