package com.hmncorp.familyplanner.widget

import android.appwidget.AppWidgetManager
import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity

/**
 * 홈 화면에 위젯을 처음 추가할 때 시스템이 여는 Configuration 화면.
 *
 * `android:configure`로 매니페스트에 등록된 Activity는 반드시
 * ACTION_APPWIDGET_CONFIGURE 인텐트(EXTRA_APPWIDGET_ID 포함)로만 시작되어야 하며,
 * 종료 시 setResult(RESULT_OK/CANCELED)를 명시해야 위젯 배치가 완료/취소된다.
 * 위젯 내부 "설정" 버튼에서 재진입하는 경로는 [WidgetSettingsActivity]를 사용한다.
 */
class WidgetConfigurationActivity : ComponentActivity() {

    private var appWidgetId: Int = AppWidgetManager.INVALID_APPWIDGET_ID

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setResult(RESULT_CANCELED)

        appWidgetId = intent.getIntExtra(
            AppWidgetManager.EXTRA_APPWIDGET_ID,
            AppWidgetManager.INVALID_APPWIDGET_ID,
        )
        if (appWidgetId == AppWidgetManager.INVALID_APPWIDGET_ID) {
            finish()
            return
        }

        setupWidgetFilterEditor(this, appWidgetId) {
            val resultValue = Intent().putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            setResult(RESULT_OK, resultValue)
            finish()
        }
    }
}
