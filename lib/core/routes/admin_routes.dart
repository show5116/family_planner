import 'package:go_router/go_router.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/settings/permissions/screens/permission_management_screen.dart';
import 'package:family_planner/features/settings/roles/screens/common_role_list_screen.dart';
import 'package:family_planner/features/settings/roles/screens/common_role_permissions_screen.dart';

/// 관리자 전용 라우트 목록
///
/// 포함되는 화면:
/// - Permission Management (권한 관리)
/// - Common Role Management (공통 역할 관리)
List<RouteBase> getAdminRoutes() {
  return [
    GoRoute(
      path: AppRoutes.permissionManagement,
      name: 'permissionManagement',
      builder: (context, state) => const PermissionManagementScreen(),
    ),
    GoRoute(
      path: AppRoutes.commonRoleManagement,
      name: 'commonRoleManagement',
      builder: (context, state) => const CommonRoleListScreen(),
    ),
    GoRoute(
      path: AppRoutes.commonRolePermissions,
      name: 'commonRolePermissions',
      builder: (context, state) {
        final roleId = state.pathParameters['id']!;
        return CommonRolePermissionsScreen(roleId: roleId);
      },
    ),
  ];
}
