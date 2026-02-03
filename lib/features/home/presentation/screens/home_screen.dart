import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/shared/widgets/responsive_navigation.dart';
import 'package:family_planner/features/home/presentation/screens/dashboard_tab.dart';
import 'package:family_planner/features/main/assets/presentation/screens/assets_tab.dart';
import 'package:family_planner/features/main/calendar/presentation/screens/calendar_tab.dart';
import 'package:family_planner/features/main/todo/presentation/screens/todo_tab.dart';
import 'package:family_planner/features/settings/common/presentation/screens/more_tab.dart';
import 'package:family_planner/features/settings/common/providers/bottom_navigation_settings_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/core/utils/navigation_label_helper.dart';

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
  int _dashboardRefreshKey = 0;

  // 방문한 탭 ID를 추적 (Lazy Loading용)
  final Set<String> _visitedTabs = {'home'}; // 홈은 기본으로 방문

  // 각 탭 ID에 해당하는 화면 매핑
  Widget _getScreenForId(String id, AppLocalizations l10n) {
    switch (id) {
      case 'home':
        return DashboardTab(key: ValueKey(_dashboardRefreshKey));
      case 'assets':
        return const AssetsTab();
      case 'calendar':
        return const CalendarTab();
      case 'todo':
        return const TodoTab();
      case 'household':
        // TODO: 가계관리 탭 구현
        return Center(child: Text('${l10n.nav_household} (${l10n.common_comingSoon})'));
      case 'childPoints':
        // TODO: 육아포인트 탭 구현
        return Center(child: Text('${l10n.nav_childPoints} (${l10n.common_comingSoon})'));
      case 'memo':
        // TODO: 메모 탭 구현
        return Center(child: Text('${l10n.nav_memo} (${l10n.common_comingSoon})'));
      case 'miniGames':
        // TODO: 미니게임 탭 구현
        return Center(child: Text('${l10n.nav_miniGames} (${l10n.common_comingSoon})'));
      case 'more':
        return const MoreTab();
      default:
        return DashboardTab(key: ValueKey(_dashboardRefreshKey));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 화면이 다시 보일 때마다 현재 탭이 홈이면 새로고침
    final notifier = ref.read(bottomNavigationSettingsProvider.notifier);
    final displayedItems = notifier.displayedItems;

    if (_selectedIndex < displayedItems.length &&
        displayedItems[_selectedIndex].id == 'home') {
      setState(() {
        _dashboardRefreshKey++;
      });
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

    return ResponsiveNavigation(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          _selectedIndex = index;
          // 방문한 탭으로 기록
          if (index < displayedItems.length) {
            _visitedTabs.add(displayedItems[index].id);
          }
          // 홈 탭으로 전환할 때 새로고침
          if (index < displayedItems.length && displayedItems[index].id == 'home') {
            _dashboardRefreshKey++;
          }
        });
      },
      destinations: destinations,
      body: _buildLazyBody(displayedItems, l10n),
    );
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
            child: _getScreenForId(item.id, l10n),
          ),
        );
      }),
    );
  }
}
