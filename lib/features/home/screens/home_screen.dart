import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/shared/widgets/responsive_navigation.dart';
import 'package:family_planner/features/home/screens/dashboard_tab.dart';
import 'package:family_planner/features/main/assets/screens/assets_tab.dart';
import 'package:family_planner/features/main/calendar/screens/calendar_tab.dart';
import 'package:family_planner/features/main/todo/screens/todo_tab.dart';
import 'package:family_planner/features/settings/common/screens/more_tab.dart';
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

    // 화면 리스트 생성 (다국어 적용)
    final screens = displayedItems.map((item) => _getScreenForId(item.id, l10n)).toList();

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
          // 홈 탭으로 전환할 때 새로고침
          if (index < displayedItems.length && displayedItems[index].id == 'home') {
            _dashboardRefreshKey++;
          }
        });
      },
      destinations: destinations,
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
    );
  }
}
