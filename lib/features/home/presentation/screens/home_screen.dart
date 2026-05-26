import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/shared/widgets/responsive_navigation.dart';
import 'package:family_planner/features/home/presentation/screens/dashboard_tab.dart';
import 'package:family_planner/features/main/assets/presentation/screens/asset_screen.dart';
import 'package:family_planner/features/main/calendar/presentation/screens/calendar_tab.dart';
import 'package:family_planner/features/main/todo/presentation/screens/todo_tab.dart';
import 'package:family_planner/features/main/child_points/presentation/screens/child_points_screen.dart';
import 'package:family_planner/features/main/household/presentation/screens/household_screen.dart';
import 'package:family_planner/features/main/investment/presentation/screens/investment_indicators_screen.dart';
import 'package:family_planner/features/memo/presentation/screens/memo_list_screen.dart';
import 'package:family_planner/features/main/savings/presentation/screens/savings_list_screen.dart';
import 'package:family_planner/features/main/fridge/presentation/screens/fridge_screen.dart';
import 'package:family_planner/features/main/shopping/presentation/screens/shopping_screen.dart';
import 'package:family_planner/features/minigame/presentation/screens/mini_games_screen.dart';
import 'package:family_planner/features/settings/common/presentation/screens/more_tab.dart';
import 'package:family_planner/features/onboarding/presentation/widgets/feature_coach_mark.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';
import 'package:family_planner/features/settings/common/providers/bottom_navigation_settings_provider.dart';
import 'package:family_planner/features/home/providers/dashboard_provider.dart';
import 'package:family_planner/features/notification/data/services/firebase_messaging_service.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/core/utils/navigation_label_helper.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

/// 메인 홈 화면
///
/// Bottom Navigation을 포함한 메인 레이아웃
/// 하단 네비게이션은 설정에 따라 동적으로 변경됩니다.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  // 방문한 탭 ID를 추적 (Lazy Loading용)
  final Set<String> _visitedTabs = {'home'}; // 홈은 기본으로 방문


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showCoachMark();
      FirebaseMessagingService.handlePendingNavigation();
    });
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void _handleTabNavigation(String? tabId, List<NavigationItem> displayedItems) {
    if (tabId == null) return;
    final index = displayedItems.indexWhere((item) => item.id == tabId);
    if (index >= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          _selectedIndex = index;
          _visitedTabs.add(tabId);
        });
        ref.read(homeTabNavigationProvider.notifier).state = null;
      });
    } else {
      // 하단 네비게이션에 없는 탭은 push로 이동
      final route = _routeForTabId(tabId);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (route != null) context.push(route);
        ref.read(homeTabNavigationProvider.notifier).state = null;
      });
    }
  }

  String? _routeForTabId(String tabId) {
    switch (tabId) {
      case 'calendar':
        return AppRoutes.calendar;
      case 'todo':
        return AppRoutes.todo;
      case 'assets':
        return AppRoutes.assets;
      case 'household':
        return AppRoutes.household;
      case 'childPoints':
        return AppRoutes.childPoints;
      case 'memo':
        return AppRoutes.memo;
      case 'miniGames':
        return AppRoutes.miniGames;
      case 'investmentIndicators':
        return AppRoutes.investmentIndicators;
      case 'savings':
        return AppRoutes.savings;
      case 'fridge':
        return AppRoutes.fridge;
      case 'shopping':
        return AppRoutes.shopping;
      default:
        return null;
    }
  }

  void _replayHomeOnboarding() {
    OnboardingService.resetCoachMark(CoachMarkKeys.home).then((_) {
      if (mounted) _showCoachMark();
    });
  }

  Future<void> _showCoachMark() async {
    final mq = MediaQuery.of(context);
    final screenWidth = mq.size.width;
    final screenHeight = mq.size.height;
    // 안드로이드 시스템 바(제스처 바 등) 높이를 제외해야 실제 네비게이션 바 위치와 일치
    final bottomPadding = mq.padding.bottom;

    // 설정에서 표시할 네비게이션 아이템 가져오기 (코치마크 위치 계산용)
    final notifier = ref.read(bottomNavigationSettingsProvider.notifier);
    final displayedItems = notifier.displayedItems;
    final itemCount = displayedItems.length;

    // 네비게이션 바 높이 (Material 3 기본값)
    const navBarHeight = 80.0;
    final navBarTop = screenHeight - navBarHeight - bottomPadding;
    final itemWidth = screenWidth / itemCount;

    // "더보기" 탭 위치 (마지막 아이템)
    final moreTabOffset = Offset(itemWidth * (itemCount - 1), navBarTop);

    // 더보기 탭 인덱스
    final moreTabIndex = displayedItems.indexWhere((item) => item.id == 'more');

    await FeatureCoachMark.show(
      context: context,
      featureKey: CoachMarkKeys.home,
      alignSkip: Alignment.topRight,
      onClickTarget: (target) {
        // 더보기 탭 클릭 시 실제 더보기 탭으로 이동
        if (target.identify == 'home_more' && moreTabIndex >= 0 && mounted) {
          setState(() {
            _selectedIndex = moreTabIndex;
            _visitedTabs.add('more');
          });
        }
      },
      targets: [
        TargetFocus(
          identify: 'home_more',
          targetPosition: TargetPosition(
            Size(itemWidth, navBarHeight),
            moreTabOffset,
          ),
          shape: ShapeLightFocus.RRect,
          radius: 12,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (_, _) => _buildMoreTabCoachContent(),
            ),
          ],
        ),
      ],
    );
  }

  /// 더보기 탭 코치마크 콘텐츠 — 3가지 안내를 한 번에 표시
  Widget _buildMoreTabCoachContent() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '더보기 탭에서 시작하세요',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildCoachItem(
            icon: Icons.group_outlined,
            color: Colors.blue,
            title: '그룹 관리',
            description: '가족, 연인, 친구 등 원하는 그룹을 만들고\n초대 코드로 구성원을 초대하세요.',
          ),
          const SizedBox(height: 10),
          _buildCoachItem(
            icon: Icons.widgets_outlined,
            color: Colors.purple,
            title: '대시보드 위젯 커스터마이징',
            description: '설정 → 홈 위젯 설정에서\n원하는 위젯만 골라 대시보드를 꾸미세요.',
          ),
          const SizedBox(height: 10),
          _buildCoachItem(
            icon: Icons.navigation_outlined,
            color: Colors.orange,
            title: '하단 탭 커스터마이징',
            description: '설정 → 하단 네비게이션 설정에서\n자주 쓰는 메뉴로 자유롭게 바꾸세요.',
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.touch_app, color: Colors.white54, size: 14),
              const SizedBox(width: 4),
              const Text(
                '탭을 눌러 더보기로 이동',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoachItem({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 각 탭 ID에 해당하는 화면 매핑
  Widget _getScreenForId(String id, AppLocalizations l10n) {
    switch (id) {
      case 'home':
        return DashboardTab(onReplayOnboarding: _replayHomeOnboarding);
      case 'assets':
        return const AssetScreen();
      case 'calendar':
        return const CalendarTab();
      case 'todo':
        return const TodoTab();
      case 'household':
        return const HouseholdScreen();
      case 'childPoints':
        return const ChildPointsScreen();
      case 'memo':
        return const MemoListScreen();
      case 'miniGames':
        return const MiniGamesScreen();
      case 'investmentIndicators':
        return const InvestmentIndicatorsScreen();
      case 'savings':
        return const SavingsListScreen();
      case 'fridge':
        return const FridgeScreen();
      case 'shopping':
        return const ShoppingScreen();
      case 'more':
        return const MoreTab();
      default:
        return const DashboardTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // 설정 변경을 감지하기 위해 watch
    ref.watch(bottomNavigationSettingsProvider);
    // 설정에서 표시할 네비게이션 아이템 가져오기
    final notifier = ref.read(bottomNavigationSettingsProvider.notifier);
    final displayedItems = notifier.displayedItems;

    // 탭 전환 요청 처리
    final tabNavRequest = ref.watch(homeTabNavigationProvider);
    if (tabNavRequest != null) {
      _handleTabNavigation(tabNavRequest, displayedItems);
    }

    // NavigationDestination 리스트 생성 (다국어 적용)
    final destinations = displayedItems.map((item) {
      return NavigationDestination(
        icon: Icon(item.icon),
        selectedIcon: Icon(item.selectedIcon),
        label: NavigationLabelHelper.getLabel(l10n, item.id),
      );
    }).toList();

    // _selectedIndex가 범위를 벗어나면 0으로 초기화
    if (_selectedIndex >= displayedItems.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _selectedIndex = 0;
          });
        }
      });
    }

    return PopScope(
      canPop: _selectedIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
        }
      },
      child: ResponsiveNavigation(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
            if (index < displayedItems.length) {
              _visitedTabs.add(displayedItems[index].id);
            }
          });
        },
        destinations: destinations,
        body: _buildLazyBody(displayedItems, l10n),
      ),
    );
  }

  /// 탭 콘텐츠 빌드
  Widget _buildTabContent(String id, AppLocalizations l10n) {
    return _getScreenForId(id, l10n);
  }

  /// Lazy Loading 방식의 탭 body 빌드
  /// 방문한 탭만 빌드하고, 이미 빌드된 탭은 Offstage로 숨겨서 상태 유지
  Widget _buildLazyBody(List<NavigationItem> displayedItems, AppLocalizations l10n) {
    return Stack(
      children: List.generate(displayedItems.length, (index) {
        final item = displayedItems[index];
        final isSelected = index == _selectedIndex;
        final hasVisited = _visitedTabs.contains(item.id);

        // 방문하지 않은 탭은 빌드하지 않음
        if (!hasVisited) {
          return const SizedBox.shrink();
        }

        // 방문한 탭은 Offstage로 숨기거나 표시
        return Offstage(
          offstage: !isSelected,
          child: TickerMode(
            enabled: isSelected, // 비활성 탭의 애니메이션 중지
            child: _buildTabContent(item.id, l10n),
          ),
        );
      }),
    );
  }
}
