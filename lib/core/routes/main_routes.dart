import 'package:go_router/go_router.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/home/presentation/screens/home_screen.dart';
import 'package:family_planner/features/main/child_points/presentation/screens/child_points_screen.dart';
import 'package:family_planner/features/main/child_points/presentation/screens/childcare_account_form_screen.dart';
import 'package:family_planner/features/main/child_points/presentation/screens/transaction_form_screen.dart';
import 'package:family_planner/features/main/assets/data/models/account_model.dart';
import 'package:family_planner/features/main/assets/presentation/screens/account_detail_screen.dart';
import 'package:family_planner/features/main/assets/presentation/screens/account_form_screen.dart';
import 'package:family_planner/features/main/assets/presentation/screens/asset_screen.dart';
import 'package:family_planner/features/main/assets/presentation/screens/asset_statistics_screen.dart';
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
import 'package:family_planner/features/main/investment/presentation/screens/indicator_detail_screen.dart';
import 'package:family_planner/features/main/investment/presentation/screens/investment_indicators_screen.dart';
import 'package:family_planner/features/memo/presentation/screens/memo_list_screen.dart';
import 'package:family_planner/features/minigame/presentation/screens/mini_games_screen.dart';
import 'package:family_planner/features/minigame/presentation/screens/ladder_game_screen.dart';
import 'package:family_planner/features/minigame/presentation/screens/roulette_game_screen.dart';

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

    // Investment Indicators Routes (투자지표)
    GoRoute(
      path: AppRoutes.investmentIndicators,
      name: 'investmentIndicators',
      builder: (context, state) => const InvestmentIndicatorsScreen(),
    ),
    GoRoute(
      path: AppRoutes.indicatorDetail,
      name: 'indicatorDetail',
      builder: (context, state) {
        final symbol = state.pathParameters['symbol']!;
        return IndicatorDetailScreen(symbol: symbol);
      },
    ),

    // Assets Routes (자산관리)
    GoRoute(
      path: AppRoutes.assets,
      name: 'assets',
      builder: (context, state) => const AssetScreen(),
    ),
    GoRoute(
      path: AppRoutes.assetAccountAdd,
      name: 'assetAccountAdd',
      builder: (context, state) {
        final extra = state.extra;
        String? groupId;
        AccountModel? account;
        if (extra is Map<String, dynamic>) {
          groupId = extra['groupId'] as String?;
          account = extra['account'] as AccountModel?;
        }
        return AccountFormScreen(groupId: groupId, account: account);
      },
    ),
    GoRoute(
      path: AppRoutes.assetAccountDetail,
      name: 'assetAccountDetail',
      builder: (context, state) {
        final account = state.extra as AccountModel;
        return AccountDetailScreen(account: account);
      },
    ),
    GoRoute(
      path: AppRoutes.assetStatistics,
      name: 'assetStatistics',
      builder: (context, state) => const AssetStatisticsScreen(),
    ),

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

    // Mini Games Routes (미니게임)
    GoRoute(
      path: AppRoutes.miniGames,
      name: 'miniGames',
      builder: (context, state) => const MiniGamesScreen(),
    ),
    GoRoute(
      path: AppRoutes.ladderGame,
      name: 'ladderGame',
      builder: (context, state) => const LadderGameScreen(),
    ),
    GoRoute(
      path: AppRoutes.rouletteGame,
      name: 'rouletteGame',
      builder: (context, state) => const RouletteGameScreen(),
    ),

    // Child Points Routes (육아포인트)
    GoRoute(
      path: AppRoutes.childPoints,
      name: 'childPoints',
      builder: (context, state) => const ChildPointsScreen(),
    ),
    GoRoute(
      path: AppRoutes.childPointsAccountForm,
      name: 'childPointsAccountForm',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final groupId = extra?['groupId'] as String? ?? '';
        return ChildcareAccountFormScreen(groupId: groupId);
      },
    ),
    GoRoute(
      path: AppRoutes.childPointsTransactionAdd,
      name: 'childPointsTransactionAdd',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final accountId = extra?['accountId'] as String? ?? '';
        return TransactionFormScreen(accountId: accountId);
      },
    ),
  ];
}
