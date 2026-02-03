import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/core/services/secure_storage_service.dart';
import 'package:family_planner/shared/widgets/user_profile_card.dart';
import 'package:family_planner/shared/widgets/menu_list_tile.dart';
import 'package:family_planner/features/settings/common/providers/bottom_navigation_settings_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/core/utils/navigation_label_helper.dart';
import 'package:family_planner/core/utils/user_utils.dart';

/// 더보기 탭
///
/// 사용자 프로필, 추가 기능 메뉴, 설정 메뉴를 표시합니다.
/// 하단 네비게이션에 표시되지 않는 메뉴만 동적으로 표시합니다.
class MoreTab extends ConsumerStatefulWidget {
  const MoreTab({super.key});

  @override
  ConsumerState<MoreTab> createState() => _MoreTabState();
}

class _MoreTabState extends ConsumerState<MoreTab> {
  final _storage = SecureStorageService();
  Map<String, dynamic>? _userInfo;
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final userInfo = await _storage.getUserInfo();
    if (mounted) {
      setState(() {
        _userInfo = userInfo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final email = _userInfo?['email'] as String?;
    final name = _userInfo?['name'] as String?;
    final profileImageUrl = _userInfo?['profileImageUrl'] as String?;
    final isAdmin = isUserAdmin(_userInfo);

    // 하단 네비게이션에 표시되지 않는 메뉴 ID 가져오기
    final notifier = ref.read(bottomNavigationSettingsProvider.notifier);
    final nonDisplayedMenuIds = notifier.nonDisplayedMenuIds;
    final availableItems = notifier.availableItems;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(l10n.nav_more),
          ),
          body: ListView(
            children: [
              const SizedBox(height: 16),
              // 프로필 영역
              Padding(
                padding: const EdgeInsets.all(16),
                child: UserProfileCard(
                  name: name,
                  email: email,
                  profileImageUrl: profileImageUrl,
                  isAdmin: isAdmin,
                ),
              ),
              // 하단 네비게이션에 표시되지 않는 메뉴들 (다국어 적용)
              ...nonDisplayedMenuIds.map((menuId) {
                final item = availableItems[menuId];
                if (item == null) return const SizedBox.shrink();

                return MenuListTile(
                  icon: item.icon,
                  title: NavigationLabelHelper.getLabel(l10n, menuId),
                  onTap: () {
                    _handleMenuTap(context, menuId);
                  },
                );
              }),
              const Divider(),
              // 고정 메뉴: 공지사항, QnA
              MenuListTile(
                icon: Icons.campaign,
                title: l10n.announcement_title,
                onTap: () => context.push(AppRoutes.announcements),
              ),
              MenuListTile(
                icon: Icons.question_answer,
                title: l10n.qna_title,
                onTap: () => context.push(AppRoutes.questions),
              ),
              const Divider(),
              // 고정 메뉴: 설정, 로그아웃
              MenuListTile(
                icon: Icons.settings,
                title: l10n.settings_title,
                onTap: () => context.push(AppRoutes.settings),
              ),
              MenuListTile(
                icon: Icons.logout,
                title: l10n.auth_logout,
                isDestructive: true,
                onTap: () => _handleLogout(),
              ),
            ],
          ),
        ),
        // 로그아웃 진행 중 로딩 오버레이
        if (_isLoggingOut)
          Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  /// 메뉴 탭 처리
  void _handleMenuTap(BuildContext context, String menuId) {
    final l10n = AppLocalizations.of(context)!;
    // TODO: 각 메뉴에 맞는 라우트로 이동
    // 현재는 모든 메뉴가 준비 중 상태
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.common_comingSoon)),
    );
  }

  Future<void> _handleLogout() async {
    if (_isLoggingOut) return; // 중복 클릭 방지

    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isLoggingOut = true;
    });

    try {
      // 로그아웃 실행
      await ref.read(authProvider.notifier).logout();

      if (mounted) {
        // 로그인 화면으로 이동 (스택 초기화)
        context.go(AppRoutes.login);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.common_logoutFailed}: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }
}
