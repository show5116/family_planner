import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/features/home/widgets/today_schedule_widget.dart';
import 'package:family_planner/features/home/widgets/investment_summary_widget.dart';
import 'package:family_planner/features/home/widgets/todo_summary_widget.dart';
import 'package:family_planner/features/home/widgets/asset_summary_widget.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/shared/widgets/responsive_navigation.dart';
import 'package:family_planner/core/utils/responsive.dart';
import 'package:family_planner/core/models/dashboard_widget_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// 메인 홈 화면
/// Bottom Navigation을 포함한 메인 레이아웃
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        _DashboardTab(key: ValueKey(_dashboardRefreshKey)),
        const _AssetsTab(),
        const _CalendarTab(),
        const _TodoTab(),
        const _MoreTab(),
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

// 대시보드 탭
class _DashboardTab extends StatelessWidget {
  const _DashboardTab({super.key});

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

// 대시보드 그리드 위젯
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

    // 활성화된 위젯만 표시
    final List<Widget> activeWidgets = [];

    if (_settings.showTodaySchedule) {
      activeWidgets.add(
        SizedBox(
          width: cardWidth,
          child: const TodayScheduleWidget(),
        ),
      );
    }

    if (_settings.showInvestmentSummary) {
      activeWidgets.add(
        SizedBox(
          width: cardWidth,
          child: const InvestmentSummaryWidget(),
        ),
      );
    }

    if (_settings.showTodoSummary) {
      activeWidgets.add(
        SizedBox(
          width: cardWidth,
          child: const TodoSummaryWidget(),
        ),
      );
    }

    if (_settings.showAssetSummary) {
      activeWidgets.add(
        SizedBox(
          width: cardWidth,
          child: const AssetSummaryWidget(),
        ),
      );
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

// 인사말 섹션
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

// 임시 자산 탭
class _AssetsTab extends StatelessWidget {
  const _AssetsTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('자산'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              '자산 관리',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            const Text('자산 관리 기능이 여기에 표시됩니다'),
          ],
        ),
      ),
    );
  }
}

// 임시 캘린더 탭
class _CalendarTab extends StatelessWidget {
  const _CalendarTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일정'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              '일정 관리',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            const Text('일정 관리 기능이 여기에 표시됩니다'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'calendar_fab',
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

// 임시 할일 탭
class _TodoTab extends StatelessWidget {
  const _TodoTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('할일'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_box,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'ToDoList',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            const Text('할일 관리 기능이 여기에 표시됩니다'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'todo_fab',
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

// 임시 더보기 탭
class _MoreTab extends StatelessWidget {
  const _MoreTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('더보기'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          // 프로필 영역
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: const Icon(Icons.person, size: 32, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '사용자',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'user@example.com',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 메뉴 리스트
          _buildMenuItem(context, Icons.credit_card, '가계관리'),
          _buildMenuItem(context, Icons.child_care, '육아포인트'),
          _buildMenuItem(context, Icons.note, '메모'),
          _buildMenuItem(context, Icons.games, '미니게임'),
          const Divider(),
          _buildMenuItem(
            context,
            Icons.settings,
            '설정',
            route: AppRoutes.settings,
          ),
          _buildMenuItem(
            context,
            Icons.logout,
            '로그아웃',
            isDestructive: true,
            route: AppRoutes.login,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title, {
    bool isDestructive = false,
    String? route,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Theme.of(context).colorScheme.error : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Theme.of(context).colorScheme.error : null,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        if (route != null) {
          // 로그아웃은 go를 사용 (스택 초기화), 나머지는 push 사용
          if (isDestructive) {
            context.go(route);
          } else {
            context.push(route);
          }
        }
      },
    );
  }
}
