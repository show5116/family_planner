import 'package:go_router/go_router.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/home/screens/home_screen.dart';

/// 메인 기능 라우트 목록
///
/// 포함되는 화면:
/// - Home (메인 대시보드)
/// - Assets (자산관리) - 추후 구현
/// - Calendar (일정관리) - 추후 구현
/// - Todo (할일목록) - 추후 구현
List<RouteBase> getMainRoutes() {
  return [
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),

    // Assets Routes (추후 구현)
    // GoRoute(
    //   path: AppRoutes.assets,
    //   name: 'assets',
    //   builder: (context, state) => const AssetsScreen(),
    // ),

    // Calendar Routes (추후 구현)
    // GoRoute(
    //   path: AppRoutes.calendar,
    //   name: 'calendar',
    //   builder: (context, state) => const CalendarScreen(),
    // ),

    // Todo Routes (추후 구현)
    // GoRoute(
    //   path: AppRoutes.todo,
    //   name: 'todo',
    //   builder: (context, state) => const TodoScreen(),
    // ),
  ];
}
