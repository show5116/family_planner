import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/shared/widgets/responsive_navigation.dart';
import 'package:family_planner/features/home/screens/dashboard_tab.dart';
import 'package:family_planner/features/assets/screens/assets_tab.dart';
import 'package:family_planner/features/calendar/screens/calendar_tab.dart';
import 'package:family_planner/features/todo/screens/todo_tab.dart';
import 'package:family_planner/features/settings/screens/more_tab.dart';

/// 메인 홈 화면
///
/// Bottom Navigation을 포함한 메인 레이아웃
/// 5개 탭: 홈(대시보드), 자산, 일정, 할일, 더보기
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  int _dashboardRefreshKey = 0;

  // Bottom Navigation 아이템들
  final List<NavigationDestination> _destinations = const [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: '홈',
    ),
    NavigationDestination(
      icon: Icon(Icons.account_balance_wallet_outlined),
      selectedIcon: Icon(Icons.account_balance_wallet),
      label: '자산',
    ),
    NavigationDestination(
      icon: Icon(Icons.calendar_today_outlined),
      selectedIcon: Icon(Icons.calendar_today),
      label: '일정',
    ),
    NavigationDestination(
      icon: Icon(Icons.check_box_outlined),
      selectedIcon: Icon(Icons.check_box),
      label: '할일',
    ),
    NavigationDestination(
      icon: Icon(Icons.more_horiz),
      selectedIcon: Icon(Icons.more_horiz),
      label: '더보기',
    ),
  ];

  // 각 탭에 해당하는 화면들
  List<Widget> get _screens => [
        DashboardTab(key: ValueKey(_dashboardRefreshKey)),
        const AssetsTab(),
        const CalendarTab(),
        const TodoTab(),
        const MoreTab(),
      ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 화면이 다시 보일 때마다 홈 탭 새로고침
    if (_selectedIndex == 0) {
      setState(() {
        _dashboardRefreshKey++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveNavigation(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          _selectedIndex = index;
          // 홈 탭으로 전환할 때 새로고침
          if (index == 0) {
            _dashboardRefreshKey++;
          }
        });
      },
      destinations: _destinations,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
    );
  }
}
