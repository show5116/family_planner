package com.hmncorp.familyplanner.widget

import android.content.Context
import android.net.Uri
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.action.ActionParameters
import androidx.glance.action.actionParametersOf
import androidx.glance.action.clickable
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.GlanceAppWidgetManager
import androidx.glance.appwidget.SizeMode
import androidx.glance.appwidget.action.ActionCallback
import androidx.glance.appwidget.action.actionRunCallback
import androidx.glance.appwidget.provideContent
import androidx.glance.appwidget.updateAll
import androidx.glance.action.actionStartActivity as glanceActionStartActivity
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
        val widgetId = GlanceAppWidgetManager(context).getAppWidgetId(id)
        val filter = WidgetFilterStore.getFilter(context, widgetId)
        val offset = WidgetMonthOffsetStore.getOffset(context, widgetId)

        provideContent {
            val calendar = Calendar.getInstance()
            calendar.add(Calendar.MONTH, offset)
            val year = calendar.get(Calendar.YEAR)
            val month = calendar.get(Calendar.MONTH) + 1

            val monthData = ScheduleWidgetData.readMonth(context, year, month)
            val todayKey = dateKeyOf(Calendar.getInstance())
            val selectedDate = WidgetSelectedDateStore.getSelectedDate(context, widgetId) ?: todayKey
            val selectedItems = if (selectedDate == todayKey) {
                ScheduleWidgetData.readTodayTasks(context).applyFilter(filter)
            } else {
                monthData.itemsForDate(selectedDate, filter)
            }
            MonthCalendarContent(context, widgetId, year, month, monthData, selectedDate, selectedItems, filter)
        }
    }
}

private fun dateKeyOf(calendar: Calendar): String {
    val year = calendar.get(Calendar.YEAR)
    val month = calendar.get(Calendar.MONTH) + 1
    val day = calendar.get(Calendar.DAY_OF_MONTH)
    return "$year-${month.toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}"
}

@Composable
private fun MonthCalendarContent(
    context: Context,
    widgetId: Int,
    year: Int,
    month: Int,
    monthData: MonthScheduleData,
    selectedDate: String,
    selectedItems: List<ScheduleItem>,
    filter: WidgetFilter,
) {
    val markedDates = monthData.markedDates(filter)

    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(Color.White)
            .padding(16.dp),
    ) {
        Row(
            modifier = GlanceModifier.fillMaxWidth(),
            verticalAlignment = Alignment.Vertical.CenterVertically,
        ) {
            Text(
                "◀",
                modifier = GlanceModifier
                    .clickable(
                        onClick = actionRunCallback<ChangeMonthAction>(
                            actionParametersOf(ChangeMonthAction.deltaKey to -1, ChangeMonthAction.widgetIdKey to widgetId),
                        ),
                    )
                    .padding(horizontal = 6.dp),
                style = TextStyle(fontSize = 14.sp, color = solidColor(TextSecondary)),
            )
            Text(
                "${year}년 ${month}월",
                modifier = GlanceModifier
                    .defaultWeight()
                    .clickable(
                        onClick = actionStartActivity<MainActivity>(
                            context,
                            Uri.parse("familyplanner://widget/calendar"),
                        ),
                    ),
                style = TextStyle(fontSize = 16.sp, fontWeight = FontWeight.Bold, color = solidColor(TextPrimary)),
            )
            Text(
                "▶",
                modifier = GlanceModifier
                    .clickable(
                        onClick = actionRunCallback<ChangeMonthAction>(
                            actionParametersOf(ChangeMonthAction.deltaKey to 1, ChangeMonthAction.widgetIdKey to widgetId),
                        ),
                    )
                    .padding(horizontal = 6.dp),
                style = TextStyle(fontSize = 14.sp, color = solidColor(TextSecondary)),
            )
            Spacer(modifier = GlanceModifier.width(8.dp))
            Text(
                "+",
                modifier = GlanceModifier
                    .clickable(
                        onClick = actionStartActivity<MainActivity>(context, Uri.parse("familyplanner://widget/add")),
                    )
                    .padding(horizontal = 4.dp),
                style = TextStyle(fontSize = 16.sp, fontWeight = FontWeight.Bold, color = solidColor(Color(0xFF1A73E8))),
            )
            Spacer(modifier = GlanceModifier.width(4.dp))
            Text(
                "설정",
                modifier = GlanceModifier.clickable(
                    onClick = glanceActionStartActivity<WidgetSettingsActivity>(
                        parameters = actionParametersOf(
                            WidgetSettingsActivity.widgetIdParamKey to widgetId,
                        ),
                    ),
                ),
                style = TextStyle(fontSize = 12.sp, color = solidColor(TextSecondary)),
            )
        }
        Spacer(modifier = GlanceModifier.height(10.dp))
        CalendarGrid(context, widgetId, year, month, selectedDate, markedDates)
        Spacer(modifier = GlanceModifier.height(12.dp))
        Box(modifier = GlanceModifier.fillMaxWidth().height(1.dp).background(Divider)) {}
        Spacer(modifier = GlanceModifier.height(10.dp))
        Text(
            selectedDateLabel(selectedDate),
            style = TextStyle(fontSize = 13.sp, fontWeight = FontWeight.Bold, color = solidColor(TextPrimary)),
        )
        Spacer(modifier = GlanceModifier.height(6.dp))
        if (selectedItems.isEmpty()) {
            Text(
                "일정이 없습니다",
                style = TextStyle(fontSize = 12.sp, color = solidColor(TextSecondary)),
            )
        } else {
            selectedItems.take(3).forEach { item -> TodayItemRow(context, item) }
        }
    }
}

/** "2026-07-15" -> 오늘이면 "오늘 일정", 아니면 "7월 15일 일정" */
private fun selectedDateLabel(dateKey: String): String {
    val parts = dateKey.split("-")
    if (parts.size != 3) return "일정"
    val today = Calendar.getInstance()
    val todayKey = "${today.get(Calendar.YEAR)}-${(today.get(Calendar.MONTH) + 1).toString().padStart(2, '0')}-${today.get(Calendar.DAY_OF_MONTH).toString().padStart(2, '0')}"
    if (dateKey == todayKey) return "오늘 일정"
    val month = parts[1].toIntOrNull() ?: return "일정"
    val day = parts[2].toIntOrNull() ?: return "일정"
    return "${month}월 ${day}일 일정"
}

@Composable
private fun TodayItemRow(context: Context, item: ScheduleItem) {
    Row(
        modifier = GlanceModifier
            .fillMaxWidth()
            .padding(vertical = 2.dp)
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
private fun CalendarGrid(
    context: Context,
    widgetId: Int,
    year: Int,
    month: Int,
    selectedDate: String,
    markedDates: Set<String>,
) {
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
                            val isSelected = dateKey == selectedDate

                            DayCell(
                                widgetId = widgetId,
                                dateKey = dateKey,
                                day = currentDay,
                                isToday = isToday,
                                isSelected = isSelected,
                                hasSchedule = hasSchedule,
                            )
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
private fun DayCell(
    widgetId: Int,
    dateKey: String,
    day: Int,
    isToday: Boolean,
    isSelected: Boolean,
    hasSchedule: Boolean,
) {
    val background = when {
        isSelected -> TodayBg
        isToday -> TodayBg.copy(alpha = 0.35f)
        else -> Color.Transparent
    }
    Box(
        modifier = GlanceModifier
            .width(24.dp)
            .height(24.dp)
            .background(background)
            .clickable(
                onClick = actionRunCallback<SelectDateAction>(
                    actionParametersOf(
                        SelectDateAction.dateKeyKey to dateKey,
                        SelectDateAction.widgetIdKey to widgetId,
                    ),
                ),
            ),
        contentAlignment = Alignment.Center,
    ) {
        Column(horizontalAlignment = Alignment.Horizontal.CenterHorizontally) {
            Text(
                day.toString(),
                style = TextStyle(
                    fontSize = 12.sp,
                    color = solidColor(if (isSelected) TodayText else TextPrimary),
                    fontWeight = if (isToday || isSelected) FontWeight.Bold else FontWeight.Normal,
                ),
            )
            if (hasSchedule && !isSelected) {
                Box(modifier = GlanceModifier.width(4.dp).height(4.dp).background(DotColor)) {}
            }
        }
    }
}

class MonthCalendarWidgetReceiver : HomeWidgetGlanceWidgetReceiver<MonthCalendarWidget>() {
    override val glanceAppWidget = MonthCalendarWidget()
}

/** 위젯 내 "◀"/"▶" 버튼 클릭 시 표시 중인 월 오프셋을 변경하고 위젯을 다시 그린다 */
class ChangeMonthAction : ActionCallback {
    companion object {
        val deltaKey = ActionParameters.Key<Int>("delta")
        val widgetIdKey = ActionParameters.Key<Int>("widgetId")
    }

    override suspend fun onAction(
        context: Context,
        glanceId: GlanceId,
        parameters: ActionParameters,
    ) {
        val delta = parameters[deltaKey] ?: return
        val widgetId = parameters[widgetIdKey] ?: return
        WidgetMonthOffsetStore.changeOffset(context, widgetId, delta)
        // 다른 달로 이동하면 이전에 선택해 둔 날짜는 더 이상 유효하지 않으므로 초기화한다
        WidgetSelectedDateStore.clearSelectedDate(context, widgetId)
        MonthCalendarWidget().updateAll(context)
    }
}

/** 위젯 내 날짜 셀 클릭 시 해당 날짜를 선택 상태로 저장하고, 그 날짜의 일정 목록으로 위젯을 다시 그린다 */
class SelectDateAction : ActionCallback {
    companion object {
        val dateKeyKey = ActionParameters.Key<String>("dateKey")
        val widgetIdKey = ActionParameters.Key<Int>("widgetId")
    }

    override suspend fun onAction(
        context: Context,
        glanceId: GlanceId,
        parameters: ActionParameters,
    ) {
        val dateKey = parameters[dateKeyKey] ?: return
        val widgetId = parameters[widgetIdKey] ?: return
        WidgetSelectedDateStore.setSelectedDate(context, widgetId, dateKey)
        MonthCalendarWidget().updateAll(context)
    }
}
