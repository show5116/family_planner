package com.hmncorp.familyplanner.widget

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.glance.action.ActionParameters

/**
 * 위젯 내부의 "설정" 버튼을 탭했을 때 여는 화면 (일반 Activity 시작 경로).
 * `android:configure`로 등록된 [WidgetConfigurationActivity]와 달리
 * ACTION_APPWIDGET_CONFIGURE 계약을 따르지 않는 일반적인 화면 전환이다.
 */
class WidgetSettingsActivity : ComponentActivity() {

    companion object {
        val widgetIdParamKey = ActionParameters.Key<Int>("widgetId")
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val widgetId = intent.getIntExtra(widgetIdParamKey.name, -1)
        if (widgetId < 0) {
            finish()
            return
        }

        setupWidgetFilterEditor(this, widgetId) {
            finish()
        }
    }
}
