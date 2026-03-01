import 'package:go_router/go_router.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/home/presentation/screens/home_screen.dart';
import 'package:family_planner/features/main/household/data/models/expense_model.dart';
import 'package:family_planner/features/main/household/presentation/screens/expense_form_screen.dart';
import 'package:family_planner/features/main/household/presentation/screens/household_screen.dart';
import 'package:family_planner/features/main/household/presentation/screens/household_statistics_screen.dart';
import 'package:family_planner/features/main/household/presentation/screens/recurring_expenses_screen.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/features/main/task/presentation/screens/category_management_screen.dart';
import 'package:family_planner/features/main/task/presentation/screens/task_form_screen.dart';
import 'package:family_planner/features/memo/presentation/screens/memo_detail_screen.dart';
import 'package:family_planner/features/memo/presentation/screens/memo_form_screen.dart';
import 'package:family_planner/features/memo/presentation/screens/memo_list_screen.dart';

/// 메인 기능 라우트 목록
///
/// 포함되는 화면:
/// - Home (메인 대시보드)
/// - Calendar (일정관리)
/// - Todo (할일목록)
/// - Memo (메모)
/// - Household (가계부)
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

    // Todo Routes
    GoRoute(
      path: AppRoutes.todoAdd,
      name: 'todoAdd',
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
      path: AppRoutes.todoDetail,
      name: 'todoDetail',
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

    // Household Routes (가계부)
    GoRoute(
      path: AppRoutes.household,
      name: 'household',
      builder: (context, state) => const HouseholdScreen(),
    ),
    GoRoute(
      path: AppRoutes.householdAdd,
      name: 'householdAdd',
      builder: (context, state) {
        final extra = state.extra;
        String? groupId;
        bool initialIsRecurring = false;
        if (extra is Map<String, dynamic>) {
          groupId = extra['groupId'] as String?;
          initialIsRecurring = extra['initialIsRecurring'] as bool? ?? false;
        }
        return ExpenseFormScreen(
          groupId: groupId,
          initialIsRecurring: initialIsRecurring,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.householdDetail,
      name: 'householdDetail',
      builder: (context, state) {
        final extra = state.extra;
        ExpenseModel? expense;
        String? groupId;
        if (extra is ExpenseModel) {
          expense = extra;
        } else if (extra is Map<String, dynamic>) {
          expense = extra['expense'] as ExpenseModel?;
          groupId = extra['groupId'] as String?;
        }
        return ExpenseFormScreen(expense: expense, groupId: groupId);
      },
    ),
    GoRoute(
      path: AppRoutes.householdStatistics,
      name: 'householdStatistics',
      builder: (context, state) => const HouseholdStatisticsScreen(),
    ),
    GoRoute(
      path: AppRoutes.householdRecurring,
      name: 'householdRecurring',
      builder: (context, state) => const RecurringExpensesScreen(),
    ),

    // Memo Routes (메모)
    GoRoute(
      path: AppRoutes.memo,
      name: 'memoList',
      builder: (context, state) => const MemoListScreen(),
    ),
    GoRoute(
      path: AppRoutes.memoAdd,
      name: 'memoCreate',
      builder: (context, state) => const MemoFormScreen(),
    ),
    GoRoute(
      path: AppRoutes.memoDetail,
      name: 'memoDetail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return MemoDetailScreen(memoId: id);
      },
    ),
    GoRoute(
      path: AppRoutes.memoEdit,
      name: 'memoEdit',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return MemoFormScreen(memoId: id);
      },
    ),
  ];
}
