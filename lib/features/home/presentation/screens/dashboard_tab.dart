import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/features/home/presentation/widgets/today_schedule_widget.dart';
import 'package:family_planner/features/home/presentation/widgets/investment_summary_widget.dart';
import 'package:family_planner/features/home/presentation/widgets/todo_summary_widget.dart';
import 'package:family_planner/features/home/presentation/widgets/asset_summary_widget.dart';
import 'package:family_planner/features/home/presentation/widgets/memo_summary_widget.dart';
import 'package:family_planner/features/weather/presentation/widgets/weather_widget.dart';
import 'package:family_planner/features/ai_chat/presentation/widgets/ai_chat_icon_button.dart';
import 'package:family_planner/features/notification/presentation/widgets/notification_popup_card.dart';
import 'package:family_planner/features/notification/providers/unread_count_provider.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/providers/dashboard_widget_settings_provider.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/core/utils/responsive.dart';

/// 대시보드 탭
class DashboardTab extends ConsumerWidget {
  const DashboardTab({super.key});

  /// 알림 팝업 표시
  void _showNotificationPopup(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      items: [
        PopupMenuItem(
          padding: EdgeInsets.zero,
          child: const NotificationPopupCard(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCountAsync = ref.watch(unreadCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Planner'),
        actions: [
          const AiChatIconButton(),
          // 알림 아이콘 with 배지
          Builder(
            builder: (context) => IconButton(
              icon: Badge(
                label: unreadCountAsync.when(
                  data: (count) => count > 0 ? Text('$count') : null,
                  loading: () => null,
                  error: (_, _) => null,
                ),
                isLabelVisible: unreadCountAsync.maybeWhen(
                  data: (count) => count > 0,
                  orElse: () => false,
                ),
                child: const Icon(Icons.notifications_outlined),
              ),
              onPressed: () => _showNotificationPopup(context),
              tooltip: '알림',
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // 알림 새로고침
          ref.invalidate(unreadCountProvider);
        },
        child: _buildDashboardBody(context),
      ),
    );
  }

  Widget _buildDashboardBody(BuildContext context) {
    // 데스크톱에서는 최대 너비 제한
    final maxWidth = Responsive.isDesktop(context) ? 1200.0 : double.infinity;
    final horizontalPadding = ResponsivePadding.getHorizontalPadding(context);

    return CustomScrollView(
      slivers: [
        // 인사말 섹션
        SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: AppSizes.spaceM,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: AppSizes.spaceM),
                    _GreetingSection(),
                    const SizedBox(height: AppSizes.spaceL),
                  ],
                ),
              ),
            ),
          ),
        ),
        // 대시보드 그리드
        SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: _DashboardGrid(),
              ),
            ),
          ),
        ),
        // 하단 여백
        const SliverToBoxAdapter(
          child: SizedBox(height: AppSizes.spaceXL),
        ),
      ],
    );
  }
}

/// 대시보드 그리드 위젯
class _DashboardGrid extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(dashboardWidgetSettingsProvider);
    final settings = settingsAsync.valueOrNull;
    if (settings == null) return const SizedBox.shrink();

    // 화면 크기에 따른 카드 너비 계산
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = Responsive.isDesktop(context) ? 1200.0 : screenWidth;
    final horizontalPadding = ResponsivePadding.getHorizontalPadding(context);
    final availableWidth = maxWidth - (horizontalPadding * 2);

    // 컬럼 수에 따른 카드 너비 계산
    final columns = ResponsiveGridDelegate.getColumns(context);
    final spacing = AppSizes.spaceM;
    final cardWidth = (availableWidth - (spacing * (columns - 1))) / columns;

    // 활성화된 위젯을 순서대로 표시
    final List<Widget> activeWidgets = [];

    // 순서대로 위젯 추가
    for (final widgetType in settings.widgetOrder) {
      Widget? widget;

      switch (widgetType) {
        case 'todaySchedule':
          if (settings.showTodaySchedule) {
            widget = TodayScheduleWidget(
              viewMode: settings.scheduleViewMode,
              initialSelectedGroupIds: settings.scheduleSelectedGroupIds,
              initialIncludePersonal: settings.scheduleIncludePersonal,
            );
          }
          break;
        case 'investmentSummary':
          if (settings.showInvestmentSummary) {
            widget = const InvestmentSummaryWidget();
          }
          break;
        case 'todoSummary':
          if (settings.showTodoSummary) {
            widget = TodoSummaryWidget(
              viewMode: settings.todoViewMode,
              initialSelectedGroupIds: settings.todoSelectedGroupIds,
              initialIncludePersonal: settings.todoIncludePersonal,
            );
          }
          break;
        case 'assetSummary':
          if (settings.showAssetSummary) {
            widget = AssetSummaryWidget(
              initialSelectedGroupId: settings.assetSelectedGroupId,
            );
          }
          break;
        case 'memoSummary':
          if (settings.showMemoSummary) {
            widget = MemoSummaryWidget(
              initialSelectedGroupId: settings.memoSelectedGroupId,
              initialPersonalOnly: settings.memoPersonalOnly,
            );
          }
          break;
        case 'weather':
          if (settings.showWeather) {
            widget = const WeatherWidget();
          }
          break;
      }

      if (widget != null) {
        activeWidgets.add(SizedBox(width: cardWidth, child: widget));
      }
    }

    // 활성화된 위젯이 없으면 안내 메시지 표시
    if (activeWidgets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.widgets_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppSizes.spaceM),
            Text(
              '표시할 위젯이 없습니다',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppSizes.spaceS),
            Text(
              '설정에서 위젯을 활성화하세요',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppSizes.spaceL),
            ElevatedButton.icon(
              onPressed: () => context.push(AppRoutes.homeWidgetSettings),
              icon: const Icon(Icons.settings),
              label: const Text('위젯 설정'),
            ),
          ],
        ),
      );
    }

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: activeWidgets,
    );
  }
}

/// 인사말 섹션
class _GreetingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting;
    IconData icon;

    if (hour < 12) {
      greeting = '좋은 아침입니다';
      icon = Icons.wb_sunny;
    } else if (hour < 18) {
      greeting = '좋은 오후입니다';
      icon = Icons.wb_twilight;
    } else {
      greeting = '좋은 저녁입니다';
      icon = Icons.nights_stay;
    }

    return Row(
      children: [
        Icon(
          icon,
          size: 32,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: AppSizes.spaceM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                '오늘도 좋은 하루 되세요!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
