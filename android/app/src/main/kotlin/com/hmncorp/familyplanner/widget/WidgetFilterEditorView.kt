package com.hmncorp.familyplanner.widget

import android.app.Activity
import android.widget.Button
import android.widget.CheckBox
import android.widget.LinearLayout
import androidx.glance.appwidget.updateAll
import androidx.lifecycle.lifecycleScope
import com.hmncorp.familyplanner.R
import kotlinx.coroutines.launch

/**
 * 그룹 필터 편집 UI를 [activity]의 contentView에 그리고, 저장 시 [onSaved]를 호출한다.
 * [WidgetConfigurationActivity](configure 진입)와 [WidgetSettingsActivity](위젯 내부 버튼 진입)가 공유한다.
 */
fun setupWidgetFilterEditor(
    activity: Activity,
    widgetId: Int,
    onSaved: () -> Unit,
) {
    activity.setContentView(R.layout.activity_widget_configuration)

    val groups = ScheduleWidgetData.readGroups(activity)
    val currentFilter = WidgetFilterStore.getFilter(activity, widgetId)

    val personalCheckbox = activity.findViewById<CheckBox>(R.id.checkbox_personal)
    personalCheckbox.isChecked = currentFilter.includePersonal

    val groupCheckboxes = mutableListOf<Pair<WidgetGroup, CheckBox>>()
    val container = activity.findViewById<LinearLayout>(R.id.group_checkbox_container)
    groups.forEach { group ->
        val checkbox = CheckBox(activity).apply {
            text = group.name
            textSize = 15f
            setPadding(0, 16, 0, 16)
            isChecked = currentFilter.selectedGroupIds?.contains(group.id) ?: true
        }
        container.addView(checkbox)
        groupCheckboxes.add(group to checkbox)
    }

    activity.findViewById<Button>(R.id.button_save).setOnClickListener {
        val allChecked = groupCheckboxes.all { it.second.isChecked }
        val selectedGroupIds = if (allChecked) {
            null // 전부 선택 = 필터 없음(전체 포함)으로 저장해 그룹이 추후 추가돼도 자동 포함
        } else {
            groupCheckboxes.filter { it.second.isChecked }.map { it.first.id }.toSet()
        }

        WidgetFilterStore.saveFilter(activity, widgetId, selectedGroupIds, personalCheckbox.isChecked)

        if (activity is androidx.lifecycle.LifecycleOwner) {
            activity.lifecycleScope.launch {
                MonthCalendarWidget().updateAll(activity)
                ScheduleListWidget().updateAll(activity)
            }
        }

        onSaved()
    }
}
