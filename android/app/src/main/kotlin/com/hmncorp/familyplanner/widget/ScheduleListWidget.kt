package com.hmncorp.familyplanner.widget

import android.content.Context
import android.net.Uri
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.action.clickable
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.GlanceAppWidgetManager
import androidx.glance.appwidget.SizeMode
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.layout.width
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextDecoration
import androidx.glance.text.TextStyle
import androidx.glance.color.ColorProvider
import es.antonborri.home_widget.HomeWidgetGlanceStateDefinition
import es.antonborri.home_widget.HomeWidgetGlanceWidgetReceiver
import es.antonborri.home_widget.actionStartActivity
import com.hmncorp.familyplanner.MainActivity

/** 단일 색상을 라이트/다크 공통으로 사용하는 ColorProvider */
private fun solidColor(color: Color) = ColorProvider(day = color, night = color)

/** 오늘 일정 리스트 위젯 (작은/중간 크기) */
class ScheduleListWidget : GlanceAppWidget() {
    override val sizeMode = SizeMode.Exact
    override val stateDefinition = HomeWidgetGlanceStateDefinition()

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        val widgetId = GlanceAppWidgetManager(context).getAppWidgetId(id)
        val filter = WidgetFilterStore.getFilter(context, widgetId)

        provideContent {
            val items = ScheduleWidgetData.readTodayTasks(context).applyFilter(filter)
            ScheduleListContent(context, items)
        }
    }
}

@Composable
private fun ScheduleListContent(context: Context, items: List<ScheduleItem>) {
    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(Color.White)
            .padding(12.dp),
    ) {
        Row(
            modifier = GlanceModifier.fillMaxWidth(),
            verticalAlignment = Alignment.Vertical.CenterVertically,
        ) {
            Text(
                "오늘 일정",
                modifier = GlanceModifier
                    .defaultWeight()
                    .clickable(
                        onClick = actionStartActivity<MainActivity>(context, Uri.parse("familyplanner://widget/calendar")),
                    ),
                style = TextStyle(fontSize = 14.sp, fontWeight = FontWeight.Bold, color = solidColor(Color(0xFF212121))),
            )
            Text(
                "+",
                modifier = GlanceModifier.clickable(
                    onClick = actionStartActivity<MainActivity>(context, Uri.parse("familyplanner://widget/add")),
                ),
                style = TextStyle(fontSize = 16.sp, fontWeight = FontWeight.Bold, color = solidColor(Color(0xFF1A73E8))),
            )
        }
        Spacer(modifier = GlanceModifier.height(8.dp))

        if (items.isEmpty()) {
            Text(
                "오늘 일정이 없습니다",
                style = TextStyle(fontSize = 13.sp, color = solidColor(Color(0xFF9E9E9E))),
            )
        } else {
            items.take(5).forEach { item -> ScheduleRow(context, item) }
        }
    }
}

@Composable
private fun ScheduleRow(context: Context, item: ScheduleItem) {
    Row(
        modifier = GlanceModifier
            .fillMaxWidth()
            .padding(vertical = 4.dp)
            .clickable(
                onClick = actionStartActivity<MainActivity>(
                    context,
                    Uri.parse("familyplanner://widget/task?id=${item.id}"),
                ),
            ),
        verticalAlignment = Alignment.Vertical.CenterVertically,
    ) {
        val dotColor = try {
            Color(android.graphics.Color.parseColor(item.colorHex))
        } catch (e: Exception) {
            Color(0xFF2196F3)
        }

        Box(
            modifier = GlanceModifier
                .width(8.dp)
                .height(8.dp)
                .background(dotColor),
        ) {}

        Spacer(modifier = GlanceModifier.width(8.dp))

        Text(
            timeText(item),
            style = TextStyle(fontSize = 12.sp, color = solidColor(Color(0xFF757575))),
        )

        Spacer(modifier = GlanceModifier.width(8.dp))

        Text(
            item.title,
            maxLines = 1,
            style = TextStyle(
                fontSize = 13.sp,
                color = solidColor(Color(0xFF212121)),
                textDecoration = if (item.isCompleted) TextDecoration.LineThrough else TextDecoration.None,
            ),
        )
    }
}

private fun timeText(item: ScheduleItem): String {
    if (item.allDay) return "종일"
    val scheduledAt = item.scheduledAt ?: return "-"
    return try {
        // ISO-8601 문자열에서 시:분만 추출 (yyyy-MM-ddTHH:mm:ss...)
        val timePart = scheduledAt.substringAfter('T').take(5)
        timePart
    } catch (e: Exception) {
        "-"
    }
}

class ScheduleListWidgetReceiver : HomeWidgetGlanceWidgetReceiver<ScheduleListWidget>() {
    override val glanceAppWidget = ScheduleListWidget()
}
