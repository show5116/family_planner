import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
import 'package:family_planner/core/services/secure_storage_service.dart';

/// 설정 메인 화면
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with WidgetsBindingObserver {
  final _storage = SecureStorageService();
  Map<String, dynamic>? _userInfo;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadUserInfo();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 앱이 다시 활성화될 때 사용자 정보 재로드
    if (state == AppLifecycleState.resumed) {
      _loadUserInfo();
    }
  }

  Future<void> _loadUserInfo() async {
    final userInfo = await _storage.getUserInfo();
    if (mounted) {
      setState(() {
        _userInfo = userInfo;
      });
    }
  }

  /// 비밀번호 설정 안내 다이얼로그
  Future<void> _showPasswordSetupGuideDialog() async {
    final shouldSetupPassword = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.security, color: Colors.orange),
            SizedBox(width: 8),
            Text('비밀번호 설정이 필요합니다'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '소셜 로그인으로만 가입하셔서 아직 비밀번호가 설정되지 않았습니다.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              '프로필을 수정하거나 계정 보안을 강화하려면 비밀번호를 설정하는 것을 권장합니다.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(
              '비밀번호 설정 화면으로 이동하시겠습니까?',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('나중에'),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(Icons.arrow_forward),
            label: const Text('비밀번호 설정하기'),
          ),
        ],
      ),
    );

    if (shouldSetupPassword == true && mounted) {
      // 비밀번호 설정 화면으로 이동 (setup=true 파라미터 추가)
      context.push('${AppRoutes.forgotPassword}?setup=true');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: ListView(
        children: [
          // 사용자 프로필 섹션
          _buildUserProfile(),
          const Divider(),
          // 화면 설정 섹션
          _buildSectionHeader(context, '화면 설정'),
          _buildSettingTile(
            context,
            icon: Icons.navigation_outlined,
            title: '하단 네비게이션 설정',
            subtitle: '하단 메뉴 순서와 표시/숨김을 설정하세요',
            onTap: () => context.push(AppRoutes.bottomNavigationSettings),
          ),
          _buildSettingTile(
            context,
            icon: Icons.widgets_outlined,
            title: '홈 위젯 설정',
            subtitle: '홈 화면에 표시할 위젯을 선택하세요',
            onTap: () => context.push(AppRoutes.homeWidgetSettings),
          ),
          _buildSettingTile(
            context,
            icon: Icons.palette_outlined,
            title: '테마 설정',
            subtitle: '라이트/다크 모드를 변경하세요',
            onTap: () => context.push(AppRoutes.theme),
          ),
          _buildSettingTile(
            context,
            icon: Icons.language_outlined,
            title: '언어 설정',
            subtitle: '앱에서 사용할 언어를 변경하세요',
            onTap: () => context.push(AppRoutes.language),
          ),
          const Divider(),

          // 사용자 설정 섹션
          _buildSectionHeader(context, '사용자 설정'),
          _buildSettingTile(
            context,
            icon: Icons.person_outlined,
            title: '프로필 설정',
            subtitle: '프로필 정보를 수정하세요',
            onTap: () async {
              final hasPassword = _userInfo?['hasPassword'] as bool? ?? false;

              if (!hasPassword && mounted) {
                // 비밀번호가 없는 사용자 (소셜 로그인만 사용한 경우)
                await _showPasswordSetupGuideDialog();
              } else {
                // TODO: 프로필 설정 화면으로 이동
              }
            },
          ),
          _buildSettingTile(
            context,
            icon: Icons.group_outlined,
            title: '가족 관리',
            subtitle: '가족 구성원을 관리하세요',
            onTap: () {
              // TODO: 가족 관리 화면으로 이동
            },
          ),
          const Divider(),

          // 알림 설정 섹션
          _buildSectionHeader(context, '알림 설정'),
          _buildSettingTile(
            context,
            icon: Icons.notifications_outlined,
            title: '알림 설정',
            subtitle: '알림 수신 설정을 변경하세요',
            onTap: () {
              // TODO: 알림 설정 화면으로 이동
            },
          ),
          const Divider(),

          // 정보 섹션
          _buildSectionHeader(context, '정보'),
          _buildSettingTile(
            context,
            icon: Icons.info_outlined,
            title: '앱 정보',
            subtitle: '버전 1.0.0',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Family Planner',
                applicationVersion: '1.0.0',
                applicationIcon: const FlutterLogo(size: 48),
                children: [
                  const Text('가족과 함께하는 일상 플래너'),
                ],
              );
            },
          ),
          _buildSettingTile(
            context,
            icon: Icons.help_outline,
            title: '도움말',
            subtitle: '사용법을 확인하세요',
            onTap: () {
              // TODO: 도움말 화면으로 이동
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile() {
    final email = _userInfo?['email'] as String?;
    final name = _userInfo?['name'] as String?;
    final profileImage = _userInfo?['profileImage'] as String?;
    final isAdmin = _userInfo?['isAdmin'] as bool? ?? false;

    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceL),
      child: Row(
        children: [
          // 프로필 이미지
          profileImage != null && profileImage.isNotEmpty
              ? CircleAvatar(
                  radius: 40,
                  backgroundImage: CachedNetworkImageProvider(profileImage),
                )
              : CircleAvatar(
                  radius: 40,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.grey[400],
                  ),
                ),
          const SizedBox(width: AppSizes.spaceM),
          // 사용자 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name ?? '사용자',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (isAdmin) ...[
                      const SizedBox(width: AppSizes.spaceS),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.spaceS,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'ADMIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSizes.spaceXS),
                Text(
                  email ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
          // 로그아웃 버튼
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('로그아웃'),
                  content: const Text('로그아웃 하시겠습니까?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('로그아웃'),
                    ),
                  ],
                ),
              );

              if (shouldLogout == true && mounted) {
                await ref.read(authProvider.notifier).logout();
                if (mounted) {
                  context.go('/login');
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.spaceM,
        AppSizes.spaceL,
        AppSizes.spaceM,
        AppSizes.spaceS,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
