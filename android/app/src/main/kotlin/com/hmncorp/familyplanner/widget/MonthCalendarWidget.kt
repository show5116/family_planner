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
import androidx.glance.appwidget.SizeMode
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.color.ColorProvider
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.RowScope
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.layout.width
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import com.hmncorp.familyplanner.MainActivity
import es.antonborri.home_widget.HomeWidgetGlanceStateDefinition
import es.antonborri.home_widget.HomeWidgetGlanceWidgetReceiver
import es.antonborri.home_widget.actionStartActivity
import java.util.Calendar

private fun solidColor(color: Color) = ColorProvider(day = color, night = color)

private val TextPrimary = Color(0xFF1C1B1F)
private val TextSecondary = Color(0xFF79747E)
private val TodayBg = Color(0xFF1A73E8)
private val TodayText = Color(0xFFFFFFFF)
private val DotColor = Color(0xFF1A73E8)
private val Divider = Color(0xFFE8EAED)

/** 이번달 미니 달력 + 오늘 일정 위젯 (큰 크기) */
class MonthCalendarWidget : GlanceAppWidget() {
    override val sizeMode = SizeMode.Exact
    override val stateDefinition = HomeWidgetGlanceStateDefinition()

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            val monthData = ScheduleWidgetData.readMonthTasks(context)
            val todayItems = ScheduleWidgetData.readTodayTasks(context)
            MonthCalendarContent(context, monthData, todayItems)
        }
    }
}

@Composable
private fun MonthCalendarContent(
    context: Context,
    monthData: MonthScheduleData?,
    todayItems: List<ScheduleItem>,
) {
    val now = Calendar.getInstance()
    val year = monthData?.year ?: now.get(Calendar.YEAR)
    val month = monthData?.month ?: (now.get(Calendar.MONTH) + 1)
    val markedDates = monthData?.markedDates ?: emptySet()

    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(Color.White)
            .clickable(
                onClick = actionStartActivity<MainActivity>(
                    context,
                    Uri.parse("familyplanner://widget/calendar"),
                ),
            )
            .padding(16.dp),
    ) {
        Text(
            "${year}년 ${month}월",
            style = TextStyle(fontSize = 16.sp, fontWeight = FontWeight.Bold, color = solidColor(TextPrimary)),
        )
        Spacer(modifier = GlanceModifier.height(10.dp))
        CalendarGrid(year, month, markedDates)
        Spacer(modifier = GlanceModifier.height(12.dp))
        Box(modifier = GlanceModifier.fillMaxWidth().height(1.dp).background(Divider)) {}
        Spacer(modifier = GlanceModifier.height(10.dp))
        Text(
            "오늘 일정",
            style = TextStyle(fontSize = 13.sp, fontWeight = FontWeight.Bold, color = solidColor(TextPrimary)),
        )
        Spacer(modifier = GlanceModifier.height(6.dp))
        if (todayItems.isEmpty()) {
            Text(
                "오늘 일정이 없습니다",
                style = TextStyle(fontSize = 12.sp, color = solidColor(TextSecondary)),
            )
        } else {
            todayItems.take(3).forEach { item -> TodayItemRow(item) }
        }
    }
}

@Composable
private fun TodayItemRow(item: ScheduleItem) {
    Row(
        modifier = GlanceModifier.fillMaxWidth().padding(vertical = 2.dp),
        verticalAlignment = Alignment.Vertical.CenterVertically,
    ) {
        val dotColor = try {
            Color(android.graphics.Color.parseColor(item.colorHex))
        } catch (e: Exception) {
            DotColor
        }
        Box(
            modifier = GlanceModifier.width(6.dp).height(6.dp).background(dotColor),
        ) {}
        Spacer(modifier = GlanceModifier.width(8.dp))
        Text(
            item.title,
            maxLines = 1,
            style = TextStyle(fontSize = 12.sp, color = solidColor(TextPrimary)),
        )
    }
}

/** 균일한 폭의 7열 달력 그리드. 각 셀은 fillMaxWidth 후 weight 대신 동일 padding으로 정렬한다. */
@Composable
private fun CalendarGrid(year: Int, month: Int, markedDates: Set<String>) {
    val calendar = Calendar.getInstance()
    calendar.set(year, month - 1, 1, 0, 0, 0)
    calendar.set(Calendar.MILLISECOND, 0)
    val firstDayOfWeek = calendar.get(Calendar.DAY_OF_WEEK) - 1 // 0=일요일
    val daysInMonth = calendar.getActualMaximum(Calendar.DAY_OF_MONTH)

    val today = Calendar.getInstance()
    val isCurrentMonth = today.get(Calendar.YEAR) == year && today.get(Calendar.MONTH) == month - 1
    val todayDay = today.get(Calendar.DAY_OF_MONTH)

    val weekLabels = listOf("일", "월", "화", "수", "목", "금", "토")
    val totalCells = firstDayOfWeek + daysInMonth
    val totalRows = (totalCells + 6) / 7

    Column(modifier = GlanceModifier.fillMaxWidth()) {
        Row(modifier = GlanceModifier.fillMaxWidth()) {
            weekLabels.forEachIndexed { index, label ->
                CalendarCell {
                    Text(
                        label,
                        style = TextStyle(
                            fontSize = 11.sp,
                            fontWeight = FontWeight.Medium,
                            color = solidColor(
                                when (index) {
                                    0 -> Color(0xFFE53935)
                                    6 -> Color(0xFF1A73E8)
                                    else -> TextSecondary
                                },
                            ),
                        ),
                    )
                }
            }
        }

        var day = 1
        for (row in 0 until totalRows) {
            Row(modifier = GlanceModifier.fillMaxWidth().padding(top = 4.dp)) {
                for (col in 0 until 7) {
                    val cellIndex = row * 7 + col
                    CalendarCell {
                        if (cellIndex >= firstDayOfWeek && day <= daysInMonth) {
                            val currentDay = day
                            val dateKey = "$year-${month.toString().padStart(2, '0')}-${currentDay.toString().padStart(2, '0')}"
                            val hasSchedule = markedDates.contains(dateKey)
                            val isToday = isCurrentMonth && currentDay == todayDay

                            DayCell(day = currentDay, isToday = isToday, hasSchedule = hasSchedule)
                            day++
                        }
                    }
                }
            }
        }
    }
}

/** 7분할 그리드에서 각 셀이 동일한 폭을 갖도록 감싸는 컨테이너 (RowScope 필요) */
@Composable
private fun RowScope.CalendarCell(content: @Composable () -> Unit) {
    Box(
        modifier = GlanceModifier.defaultWeight().height(30.dp),
        contentAlignment = Alignment.Center,
    ) {
        content()
    }
}

@Composable
private fun DayCell(day: Int, isToday: Boolean, hasSchedule: Boolean) {
    Box(
        modifier = GlanceModifier
            .width(24.dp)
            .height(24.dp)
            .background(if (isToday) TodayBg else Color.Transparent),
        contentAlignment = Alignment.Center,
    ) {
        Column(horizontalAlignment = Alignment.Horizontal.CenterHorizontally) {
            Text(
                day.toString(),
                style = TextStyle(
                    fontSize = 12.sp,
                    color = solidColor(if (isToday) TodayText else TextPrimary),
                    fontWeight = if (isToday) FontWeight.Bold else FontWeight.Normal,
                ),
            )
            if (hasSchedule && !isToday) {
                Box(modifier = GlanceModifier.width(4.dp).height(4.dp).background(DotColor)) {}
            }
        }
    }
}

class MonthCalendarWidgetReceiver : HomeWidgetGlanceWidgetReceiver<MonthCalendarWidget>() {
    override val glanceAppWidget = MonthCalendarWidget()
}
