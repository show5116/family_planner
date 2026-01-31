import 'package:go_router/go_router.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/home/screens/home_screen.dart';
import 'package:family_planner/features/main/task/screens/task_form_screen.dart';
import 'package:family_planner/features/main/task/screens/category_management_screen.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';

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

    // Calendar Routes
    GoRoute(
      path: AppRoutes.calendarAdd,
      name: 'calendarAdd',
      builder: (context, state) {
        final extra = state.extra;
        DateTime? initialDate;
        if (extra is DateTime) {
          initialDate = extra;
        }
        return TaskFormScreen(initialDate: initialDate);
      },
    ),
    GoRoute(
      path: AppRoutes.calendarDetail,
      name: 'calendarDetail',
      builder: (context, state) {
        final extra = state.extra;
        if (extra is Map<String, dynamic>) {
          return TaskFormScreen(
            taskId: extra['taskId'] as String?,
            task: extra['task'] as TaskModel?,
          );
        }
        return const TaskFormScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.categoryManagement,
      name: 'categoryManagement',
      builder: (context, state) => const CategoryManagementScreen(),
    ),

    // Todo Routes (추후 구현)
    // GoRoute(
    //   path: AppRoutes.todo,
    //   name: 'todo',
    //   builder: (context, state) => const TodoScreen(),
    // ),
  ];
}
