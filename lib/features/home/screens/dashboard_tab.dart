import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/features/home/widgets/today_schedule_widget.dart';
import 'package:family_planner/features/home/widgets/investment_summary_widget.dart';
import 'package:family_planner/features/home/widgets/todo_summary_widget.dart';
import 'package:family_planner/features/home/widgets/asset_summary_widget.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/core/utils/responsive.dart';
import 'package:family_planner/core/models/dashboard_widget_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// 대시보드 탭
class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
            tooltip: '알림',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: 데이터 새로고침
          await Future.delayed(const Duration(seconds: 1));
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
class _DashboardGrid extends StatefulWidget {
  @override
  State<_DashboardGrid> createState() => _DashboardGridState();
}

class _DashboardGridState extends State<_DashboardGrid> {
  DashboardWidgetSettings _settings = DashboardWidgetSettings.defaultSettings();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString('dashboard_widget_settings');

    setState(() {
      if (settingsJson != null) {
        _settings = DashboardWidgetSettings.fromJson(
          json.decode(settingsJson) as Map<String, dynamic>,
        );
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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
    for (final widgetType in _settings.widgetOrder) {
      Widget? widget;

      switch (widgetType) {
        case 'todaySchedule':
          if (_settings.showTodaySchedule) {
            widget = const TodayScheduleWidget();
          }
          break;
        case 'investmentSummary':
          if (_settings.showInvestmentSummary) {
            widget = const InvestmentSummaryWidget();
          }
          break;
        case 'todoSummary':
          if (_settings.showTodoSummary) {
            widget = const TodoSummaryWidget();
          }
          break;
        case 'assetSummary':
          if (_settings.showAssetSummary) {
            widget = const AssetSummaryWidget();
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
