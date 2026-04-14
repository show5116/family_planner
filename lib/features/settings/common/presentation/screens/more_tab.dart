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
import 'package:family_planner/features/onboarding/presentation/widgets/feature_coach_mark.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

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

  final _groupManagementKey = GlobalKey();
  final _settingsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showCoachMark());
  }

  Future<void> _showCoachMark() async {
    await FeatureCoachMark.show(
      context: context,
      featureKey: CoachMarkKeys.more,
      targets: [
        TargetFocus(
          identify: 'more_group',
          keyTarget: _groupManagementKey,
          shape: ShapeLightFocus.RRect,
          radius: 8,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (_, _) => FeatureCoachMark.buildContent(
                title: '그룹 관리',
                description: '가족, 연인, 친구 등 원하는 그룹을 만들고\n초대 코드로 구성원을 초대하세요.',
                icon: Icons.group_outlined,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: 'more_settings',
          keyTarget: _settingsKey,
          shape: ShapeLightFocus.RRect,
          radius: 8,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (_, _) => FeatureCoachMark.buildContent(
                title: '설정',
                description: '테마, 언어, 알림, 하단 탭 구성 등\n앱을 원하는 대로 커스터마이징하세요.',
                icon: Icons.settings,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
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
    ref.watch(bottomNavigationSettingsProvider);
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
                  onTap: () => context.push(AppRoutes.profile),
                ),
              ),
              // 그룹 관리 (상단 고정)
              MenuListTile(
                key: _groupManagementKey,
                icon: Icons.group_outlined,
                title: l10n.settings_groupManagementTitle,
                onTap: () => context.push(AppRoutes.groupManagement),
              ),
              const Divider(),
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
              MenuListTile(
                icon: Icons.how_to_vote_outlined,
                title: '투표',
                onTap: () => context.push(AppRoutes.votes),
              ),
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
                key: _settingsKey,
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
    switch (menuId) {
      case 'household':
        context.push(AppRoutes.household);
      case 'memo':
        context.push(AppRoutes.memo);
      case 'childPoints':
        context.push(AppRoutes.childPoints);
      case 'miniGames':
        context.push(AppRoutes.miniGames);
      case 'assets':
        context.push(AppRoutes.assets);
      case 'investmentIndicators':
        context.push(AppRoutes.investmentIndicators);
      case 'savings':
        context.push(AppRoutes.savings);
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.common_comingSoon)),
        );
    }
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
