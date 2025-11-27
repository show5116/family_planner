import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/core/services/secure_storage_service.dart';
import 'package:family_planner/shared/widgets/user_profile_card.dart';
import 'package:family_planner/shared/widgets/menu_list_tile.dart';

/// 더보기 탭
///
/// 사용자 프로필, 추가 기능 메뉴, 설정 메뉴를 표시합니다.
class MoreTab extends ConsumerStatefulWidget {
  const MoreTab({super.key});

  @override
  ConsumerState<MoreTab> createState() => _MoreTabState();
}

class _MoreTabState extends ConsumerState<MoreTab> {
  final _storage = SecureStorageService();
  Map<String, dynamic>? _userInfo;

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
    final email = _userInfo?['email'] as String?;
    final name = _userInfo?['name'] as String?;
    final profileImage = _userInfo?['profileImage'] as String?;
    final isAdmin = _userInfo?['isAdmin'] as bool? ?? false;

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
            child: UserProfileCard(
              name: name,
              email: email,
              profileImage: profileImage,
              isAdmin: isAdmin,
            ),
          ),
          // 메뉴 리스트
          MenuListTile(
            icon: Icons.credit_card,
            title: '가계관리',
            onTap: () {
              // TODO: 가계관리 화면으로 이동
            },
          ),
          MenuListTile(
            icon: Icons.child_care,
            title: '육아포인트',
            onTap: () {
              // TODO: 육아포인트 화면으로 이동
            },
          ),
          MenuListTile(
            icon: Icons.note,
            title: '메모',
            onTap: () {
              // TODO: 메모 화면으로 이동
            },
          ),
          MenuListTile(
            icon: Icons.games,
            title: '미니게임',
            onTap: () {
              // TODO: 미니게임 화면으로 이동
            },
          ),
          const Divider(),
          MenuListTile(
            icon: Icons.settings,
            title: '설정',
            onTap: () => context.push(AppRoutes.settings),
          ),
          MenuListTile(
            icon: Icons.logout,
            title: '로그아웃',
            isDestructive: true,
            onTap: () => _handleLogout(),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout() async {
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
            content: Text('로그아웃 실패: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
