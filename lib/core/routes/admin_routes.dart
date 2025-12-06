import 'package:go_router/go_router.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/settings/screens/permission_management_screen.dart';

/// 관리자 전용 라우트 목록
///
/// 포함되는 화면:
/// - Permission Management (권한 관리)
List<RouteBase> getAdminRoutes() {
  return [
    GoRoute(
      path: AppRoutes.permissionManagement,
      name: 'permissionManagement',
      builder: (context, state) => const PermissionManagementScreen(),
    ),
  ];
}
