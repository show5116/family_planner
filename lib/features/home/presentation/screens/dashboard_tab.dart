import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/constants/guide_links.dart';
import 'package:family_planner/features/home/presentation/widgets/anniversary_summary_widget.dart';
import 'package:family_planner/features/home/providers/dashboard_provider.dart';
import 'package:family_planner/features/home/presentation/widgets/fridge_expiry_widget.dart';
import 'package:family_planner/features/home/presentation/widgets/today_schedule_widget.dart';
import 'package:family_planner/features/home/presentation/widgets/investment_summary_widget.dart';
import 'package:family_planner/features/home/presentation/widgets/todo_summary_widget.dart';
import 'package:family_planner/features/home/presentation/widgets/asset_summary_widget.dart';
import 'package:family_planner/features/home/presentation/widgets/memo_summary_widget.dart';
import 'package:family_planner/features/home/presentation/widgets/childcare_summary_widget.dart';
import 'package:family_planner/features/home/presentation/widgets/household_summary_widget.dart';
import 'package:family_planner/features/home/presentation/widgets/routine_summary_widget.dart';
import 'package:family_planner/features/home/presentation/widgets/routine_family_widget.dart';
import 'package:family_planner/features/home/presentation/widgets/savings_summary_widget.dart';
import 'package:family_planner/features/weather/presentation/widgets/weather_widget.dart';
import 'package:family_planner/shared/widgets/app_bar_more_menu.dart';
import 'package:family_planner/features/notification/presentation/widgets/notification_popup_card.dart';
import 'package:family_planner/features/notification/providers/unread_count_provider.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/greeting_presets.dart';
import 'package:family_planner/core/providers/dashboard_widget_settings_provider.dart';
import 'package:family_planner/core/providers/greeting_settings_provider.dart';
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
    // 홈 화면(OS) 위젯 데이터 동기화 (대시보드 진입 시 1회, keepAlive 없어 재진입마다 실행)
    ref.watch(dashboardWidgetSyncProvider);

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
            guideUrl: GuideLinks.dashboard,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // 알림 새로고침
          ref.invalidate(unreadCountProvider);
          // 오늘의 한마디를 다음 문구로 넘김
          ref.read(greetingRotationProvider.notifier).next();
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

      if (widgetType == 'anniversary') {
        widget = AnniversarySummaryWidget(
          key: const ValueKey('anniversary'),
          anniversaryIds: settings.anniversaryIds,
        );
      } else {
        switch (widgetType) {
          case 'fridgeSummary':
            widget = FridgeExpiryWidget(
              initialSelectedGroupId: settings.fridgeExpirySelectedGroupId,
            );
            break;
          case 'todaySchedule':
            widget = TodayScheduleWidget(
              viewMode: settings.scheduleViewMode,
              initialSelectedGroupIds: settings.scheduleSelectedGroupIds,
              initialIncludePersonal: settings.scheduleIncludePersonal,
            );
            break;
          case 'investmentSummary':
            widget = const InvestmentSummaryWidget();
            break;
          case 'todoSummary':
            widget = TodoSummaryWidget(
              viewMode: settings.todoViewMode,
              initialSelectedGroupIds: settings.todoSelectedGroupIds,
              initialIncludePersonal: settings.todoIncludePersonal,
            );
            break;
          case 'assetSummary':
            widget = AssetSummaryWidget(
              initialSelectedGroupId: settings.assetSelectedGroupId,
            );
            break;
          case 'memoSummary':
            widget = MemoSummaryWidget(
              initialSelectedGroupId: settings.memoSelectedGroupId,
              initialPersonalOnly: settings.memoPersonalOnly,
            );
            break;
          case 'householdSummary':
            widget = HouseholdSummaryWidget(
              initialSelectedGroupId: settings.householdSelectedGroupId,
              viewMode: settings.householdViewMode,
            );
            break;
          case 'weather':
            widget = const WeatherWidget();
            break;
          case 'childcareSummary':
            widget = ChildcareSummaryWidget(
              initialSelectedGroupId: settings.childcareSelectedGroupId,
            );
            break;
          case 'savingsSummary':
            widget = SavingsSummaryWidget(
              initialSelectedGroupId: settings.savingsSelectedGroupId,
            );
            break;
          case 'routineSummary':
            widget = RoutineSummaryWidget(
              viewMode: settings.routineViewMode,
            );
            break;
          case 'routineFamily':
            widget = RoutineFamilyWidget(
              initialSelectedGroupId: settings.routineFamilySelectedGroupId,
            );
            break;
        }
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
    final l10n = AppLocalizations.of(context)!;
    final subscription = ref.watch(subscriptionProvider).valueOrNull;
    if (subscription == null || !subscription.isTrial) return const SizedBox.shrink();

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
          // 체험 종료가 임박했다고 알리면서 구독 경로를 주지 않으면 전환
          // 기회를 그대로 버리게 되므로 배너 자체를 진입점으로 만든다.
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.push(AppRoutes.subscription),
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
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
                    Icon(Icons.card_giftcard_outlined,
                        color: colorScheme.primary),
                    const SizedBox(width: AppSizes.spaceS),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.dashboard_trial_banner_title,
                            style:
                                Theme.of(context).textTheme.titleSmall?.copyWith(
                                      color: colorScheme.onPrimaryContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          Text(
                            daysLeft > 0 ? l10n.dashboard_trial_banner_sublabel_days(daysLeft) : l10n.dashboard_trial_banner_sublabel_today,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onPrimaryContainer,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 인사말 섹션
///
/// 사용자가 등록한 문구(기본 팩 + 내 문구)가 있으면 "오늘의 한마디"를 보여주고,
/// 없거나 기능을 꺼두면 기존 시간대별 인사말로 되돌아간다.
class _GreetingSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(greetingSettingsProvider).valueOrNull;
    final rotation = ref.watch(greetingRotationProvider);

    final message = settings == null
        ? null
        : GreetingPresets.pickMessage(
            GreetingPresets.buildPool(
              Localizations.localeOf(context).languageCode,
              settings,
            ),
            date: DateTime.now(),
            rotation: rotation,
          );

    if (message != null) {
      return _GreetingLayout(
        icon: Icons.format_quote,
        title: message,
        titleStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
        subtitle: l10n.greeting_todayLabel,
      );
    }

    final hour = DateTime.now().hour;
    final String greeting;
    final IconData icon;

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

    return _GreetingLayout(
      icon: icon,
      title: greeting,
      titleStyle: Theme.of(context).textTheme.headlineSmall,
      subtitle: l10n.dashboard_greetingSubtitle,
    );
  }
}

/// 인사말 섹션 공통 레이아웃 (아이콘 + 본문 + 보조 문구)
class _GreetingLayout extends StatelessWidget {
  const _GreetingLayout({
    required this.icon,
    required this.title,
    required this.titleStyle,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final TextStyle? titleStyle;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: AppSizes.iconLarge,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: AppSizes.spaceM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 사용자 문구가 길어도 대시보드 상단 높이가 크게 흔들리지 않게 제한
              Text(
                title,
                style: titleStyle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSizes.spaceXS),
              Text(
                subtitle,
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
