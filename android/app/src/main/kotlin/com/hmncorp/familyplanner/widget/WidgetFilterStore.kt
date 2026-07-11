package com.hmncorp.familyplanner.widget

import android.content.Context

/** 위젯 인스턴스(appWidgetId)별 그룹 필터 설정 저장소 */
object WidgetFilterStore {
    private const val PREFS_NAME = "widget_filter_prefs"
    private const val KEY_SELECTED_GROUP_IDS_PREFIX = "selected_group_ids_"
    private const val KEY_INCLUDE_PERSONAL_PREFIX = "include_personal_"
    private const val NONE_SELECTED_SENTINEL = "__none__"

    fun getFilter(context: Context, widgetId: Int): WidgetFilter {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val stored = prefs.getStringSet(KEY_SELECTED_GROUP_IDS_PREFIX + widgetId, null)
        val includePersonal = prefs.getBoolean(KEY_INCLUDE_PERSONAL_PREFIX + widgetId, true)

        val selectedGroupIds = when {
            stored == null -> null // 저장된 적 없음 = 전체 포함
            stored.size == 1 && stored.first() == NONE_SELECTED_SENTINEL -> emptySet()
            else -> stored
        }

        return WidgetFilter(selectedGroupIds = selectedGroupIds, includePersonal = includePersonal)
    }

    /**
     * [selectedGroupIds] null = 전체 포함, 빈 집합 = 그룹 전부 해제.
     * SharedPreferences의 putStringSet은 빈 set과 null을 구분하지 못하므로
     * 빈 집합은 sentinel 값으로 저장한다.
     */
    fun saveFilter(context: Context, widgetId: Int, selectedGroupIds: Set<String>?, includePersonal: Boolean) {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val toStore = when {
            selectedGroupIds == null -> null
            selectedGroupIds.isEmpty() -> setOf(NONE_SELECTED_SENTINEL)
            else -> selectedGroupIds
        }
        prefs.edit()
            .apply {
                if (toStore == null) {
                    remove(KEY_SELECTED_GROUP_IDS_PREFIX + widgetId)
                } else {
                    putStringSet(KEY_SELECTED_GROUP_IDS_PREFIX + widgetId, toStore)
                }
                putBoolean(KEY_INCLUDE_PERSONAL_PREFIX + widgetId, includePersonal)
            }
            .apply()
    }

    fun clearFilter(context: Context, widgetId: Int) {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        prefs.edit()
            .remove(KEY_SELECTED_GROUP_IDS_PREFIX + widgetId)
            .remove(KEY_INCLUDE_PERSONAL_PREFIX + widgetId)
            .apply()
    }
}
