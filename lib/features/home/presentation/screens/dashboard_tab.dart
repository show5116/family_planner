import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/features/home/presentation/widgets/fridge_expiry_widget.dart';
import 'package:family_planner/features/home/presentation/widgets/today_schedule_widget.dart';
import 'package:family_planner/features/home/presentation/widgets/investment_summary_widget.dart';
import 'package:family_planner/features/home/presentation/widgets/todo_summary_widget.dart';
import 'package:family_planner/features/home/presentation/widgets/asset_summary_widget.dart';
import 'package:family_planner/features/home/presentation/widgets/memo_summary_widget.dart';
import 'package:family_planner/features/home/presentation/widgets/childcare_summary_widget.dart';
import 'package:family_planner/features/home/presentation/widgets/household_summary_widget.dart';
import 'package:family_planner/features/home/presentation/widgets/savings_summary_widget.dart';
import 'package:family_planner/features/weather/presentation/widgets/weather_widget.dart';
import 'package:family_planner/shared/widgets/app_bar_more_menu.dart';
import 'package:family_planner/features/notification/presentation/widgets/notification_popup_card.dart';
import 'package:family_planner/features/notification/providers/unread_count_provider.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/providers/dashboard_widget_settings_provider.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/core/utils/responsive.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/core/providers/subscription_provider.dart';
import 'package:family_planner/shared/widgets/banner_ad_widget.dart';

/// 대시보드 탭
class DashboardTab extends ConsumerWidget {
  const DashboardTab({super.key, this.onReplayOnboarding});

  final VoidCallback? onReplayOnboarding;

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
              tooltip: AppLocalizations.of(context)!.dashboard_notifications,
            ),
          ),
          AppBarMoreMenu(
            onReplayOnboarding: onReplayOnboarding,
            guideUrl: 'https://show5116.tistory.com/entry/Family-Planner-%EA%B0%80%EC%9D%B4%EB%93%9C-%EB%82%98%EB%A7%8C%EC%9D%98-%EB%A7%9E%EC%B6%A4%ED%98%95-%EB%AA%A8%EC%9E%84-%EB%8C%80%EC%8B%9C%EB%B3%B4%EB%93%9C-%ED%99%88-%EC%9C%84%EC%A0%AF-%EC%84%A4%EC%A0%95-%EB%B0%A9%EB%B2%95',
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
        // 2주 무료 체험 배너
        const SliverToBoxAdapter(child: _TrialBannerCard()),
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
        SliverToBoxAdapter(
          child: SizedBox(
            height: AppSizes.spaceXL + MediaQuery.paddingOf(context).bottom,
          ),
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

    final showAds = ref.watch(showAdsProvider);

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
        case 'fridgeSummary':
          if (settings.showFridgeSummary) {
            widget = FridgeExpiryWidget(
              initialSelectedGroupId: settings.fridgeExpirySelectedGroupId,
            );
          }
          break;
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
        case 'householdSummary':
          if (settings.showHouseholdSummary) {
            widget = HouseholdSummaryWidget(
              initialSelectedGroupId: settings.householdSelectedGroupId,
              viewMode: settings.householdViewMode,
            );
          }
          break;
        case 'weather':
          if (settings.showWeather) {
            widget = const WeatherWidget();
          }
          break;
        case 'childcareSummary':
          if (settings.showChildcareSummary) {
            widget = ChildcareSummaryWidget(
              initialSelectedGroupId: settings.childcareSelectedGroupId,
            );
          }
          break;
        case 'savingsSummary':
          if (settings.showSavingsSummary) {
            widget = SavingsSummaryWidget(
              initialSelectedGroupId: settings.savingsSelectedGroupId,
            );
          }
          break;
      }

      if (widget != null) {
        activeWidgets.add(SizedBox(width: cardWidth, child: widget));
      }
    }

    // 배너 광고: 2번째 위젯 뒤 삽입, 위젯이 2개 미만이면 맨 아래
    if (showAds && activeWidgets.isNotEmpty) {
      final bannerWidget = SizedBox(
        width: availableWidth,
        child: const Center(child: BannerAdWidget()),
      );
      final insertIndex = activeWidgets.length >= 2 ? 2 : activeWidgets.length;
      activeWidgets.insert(insertIndex, bannerWidget);
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
              AppLocalizations.of(context)!.dashboard_emptyWidgets,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppSizes.spaceS),
            Text(
              AppLocalizations.of(context)!.dashboard_emptyWidgetsHint,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppSizes.spaceL),
            ElevatedButton.icon(
              onPressed: () => context.push(AppRoutes.homeWidgetSettings),
              icon: const Icon(Icons.settings),
              label: Text(AppLocalizations.of(context)!.dashboard_widgetSettings),
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

/// 2주 무료 체험 배너 (체험 기간 중에만 표시)
class _TrialBannerCard extends ConsumerWidget {
  const _TrialBannerCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscription = ref.watch(subscriptionProvider).valueOrNull;
    if (subscription == null || !subscription.isTrial) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    final daysLeft = subscription.daysLeft;
    final colorScheme = Theme.of(context).colorScheme;
    final horizontalPadding = ResponsivePadding.getHorizontalPadding(context);
    final maxWidth = Responsive.isDesktop(context) ? 1200.0 : double.infinity;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            0,
            horizontalPadding,
            AppSizes.spaceM,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceM,
              vertical: AppSizes.spaceS,
            ),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
            child: Row(
              children: [
                Icon(Icons.card_giftcard_outlined, color: colorScheme.primary),
                const SizedBox(width: AppSizes.spaceS),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.dashboard_trial_banner_title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        daysLeft > 0 ? l10n.dashboard_trial_banner_sublabel_days(daysLeft) : l10n.dashboard_trial_banner_sublabel_today,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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

    final l10n = AppLocalizations.of(context)!;
    if (hour < 12) {
      greeting = l10n.dashboard_greetingMorning;
      icon = Icons.wb_sunny;
    } else if (hour < 18) {
      greeting = l10n.dashboard_greetingAfternoon;
      icon = Icons.wb_twilight;
    } else {
      greeting = l10n.dashboard_greetingEvening;
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
                l10n.dashboard_greetingSubtitle,
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
