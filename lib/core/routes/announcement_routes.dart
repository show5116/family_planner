import 'package:go_router/go_router.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/announcements/presentation/screens/announcement_list_screen.dart';
import 'package:family_planner/features/announcements/presentation/screens/announcement_detail_screen.dart';
import 'package:family_planner/features/announcements/presentation/screens/announcement_form_screen.dart';

/// 공지사항 관련 라우트 목록
///
/// 포함되는 화면:
/// - Announcements (공지사항 목록)
/// - Announcement Detail (공지사항 상세)
/// - Announcement Create (공지사항 작성 - ADMIN 전용)
/// - Announcement Edit (공지사항 수정 - ADMIN 전용)
List<RouteBase> getAnnouncementRoutes() {
  return [
    // 공지사항 목록
    GoRoute(
      path: AppRoutes.announcements,
      name: 'announcements',
      builder: (context, state) => const AnnouncementListScreen(),
    ),

    // 공지사항 작성 (ADMIN 전용)
    GoRoute(
      path: AppRoutes.announcementCreate,
      name: 'announcementCreate',
      builder: (context, state) => const AnnouncementFormScreen(),
    ),

    // 공지사항 상세
    GoRoute(
      path: AppRoutes.announcementDetail,
      name: 'announcementDetail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return AnnouncementDetailScreen(announcementId: id);
      },
    ),

    // 공지사항 수정 (ADMIN 전용)
    GoRoute(
      path: AppRoutes.announcementEdit,
      name: 'announcementEdit',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return AnnouncementFormScreen(announcementId: id);
      },
    ),
  ];
}
