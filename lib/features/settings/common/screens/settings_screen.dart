import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
import 'package:family_planner/core/services/secure_storage_service.dart';
import 'package:family_planner/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;

    final shouldSetupPassword = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.security, color: Colors.orange),
            const SizedBox(width: 8),
            Text(l10n.settings_passwordSetupRequired),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.settings_passwordSetupMessage1,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.settings_passwordSetupMessage2,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.settings_passwordSetupMessage3,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.settings_passwordSetupLater),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(Icons.arrow_forward),
            label: Text(l10n.settings_passwordSetupNow),
          ),
        ],
      ),
    );

    if (shouldSetupPassword == true && mounted) {
      // 비밀번호 설정 화면으로 이동 (setup=true 파라미터 및 이메일 전달)
      final email = _userInfo?['email'] as String? ?? '';
      context.push('${AppRoutes.forgotPassword}?setup=true&email=${Uri.encodeComponent(email)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings_title),
      ),
      body: ListView(
        children: [
          // 사용자 프로필 섹션
          _buildUserProfile(),
          const Divider(),
          // 화면 설정 섹션
          _buildSectionHeader(context, l10n.settings_screenSettings),
          _buildSettingTile(
            context,
            icon: Icons.navigation_outlined,
            title: l10n.settings_bottomNavigationTitle,
            subtitle: l10n.settings_bottomNavigationSubtitle,
            onTap: () => context.push(AppRoutes.bottomNavigationSettings),
          ),
          _buildSettingTile(
            context,
            icon: Icons.widgets_outlined,
            title: l10n.settings_homeWidgetsTitle,
            subtitle: l10n.settings_homeWidgetsSubtitle,
            onTap: () => context.push(AppRoutes.homeWidgetSettings),
          ),
          _buildSettingTile(
            context,
            icon: Icons.palette_outlined,
            title: l10n.settings_themeTitle,
            subtitle: l10n.settings_themeSubtitle,
            onTap: () => context.push(AppRoutes.theme),
          ),
          _buildSettingTile(
            context,
            icon: Icons.language_outlined,
            title: l10n.settings_languageTitle,
            subtitle: l10n.settings_languageSubtitle,
            onTap: () => context.push(AppRoutes.language),
          ),
          const Divider(),

          // 사용자 설정 섹션
          _buildSectionHeader(context, l10n.settings_userSettings),
          _buildSettingTile(
            context,
            icon: Icons.person_outlined,
            title: l10n.settings_profileTitle,
            subtitle: l10n.settings_profileSubtitle,
            onTap: () async {
              final hasPassword = _userInfo?['hasPassword'] as bool? ?? false;

              if (!hasPassword && mounted) {
                // 비밀번호가 없는 사용자 (소셜 로그인만 사용한 경우)
                await _showPasswordSetupGuideDialog();
              } else {
                // 프로필 설정 화면으로 이동
                if (mounted) {
                  context.push(AppRoutes.profile);
                }
              }
            },
          ),
          _buildSettingTile(
            context,
            icon: Icons.group_outlined,
            title: l10n.settings_groupManagementTitle,
            subtitle: l10n.settings_groupManagementSubtitle,
            onTap: () {
              // TODO: 그룹 관리 화면으로 이동
              context.push(AppRoutes.groupManagement);
            },
          ),
          const Divider(),

          // 알림 설정 섹션
          _buildSectionHeader(context, l10n.settings_notificationSettings),
          _buildSettingTile(
            context,
            icon: Icons.notifications_outlined,
            title: l10n.settings_notificationTitle,
            subtitle: l10n.settings_notificationSubtitle,
            onTap: () {
              // TODO: 알림 설정 화면으로 이동
            },
          ),
          const Divider(),

          // 운영자 전용 섹션 (관리자만 표시)
          if (_userInfo?['isAdmin'] as bool? ?? false) ...[
            _buildSectionHeader(context, l10n.settings_adminMenu),
            _buildSettingTile(
              context,
              icon: Icons.security_outlined,
              title: l10n.settings_permissionManagementTitle,
              subtitle: l10n.settings_permissionManagementSubtitle,
              onTap: () {
                context.push(AppRoutes.permissionManagement);
              },
            ),
            _buildSettingTile(
              context,
              icon: Icons.admin_panel_settings_outlined,
              title: '공통 역할 관리',
              subtitle: '시스템 전체에 적용되는 공통 역할 관리',
              onTap: () {
                context.push(AppRoutes.commonRoleManagement);
              },
            ),
            const Divider(),
          ],

          // 정보 섹션
          _buildSectionHeader(context, l10n.settings_information),
          _buildSettingTile(
            context,
            icon: Icons.info_outlined,
            title: l10n.settings_appInfoTitle,
            subtitle: l10n.settings_appInfoSubtitle,
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Family Planner',
                applicationVersion: '1.0.0',
                applicationIcon: const FlutterLogo(size: 48),
                children: [
                  Text(l10n.settings_appDescription),
                ],
              );
            },
          ),
          _buildSettingTile(
            context,
            icon: Icons.help_outline,
            title: l10n.settings_helpTitle,
            subtitle: l10n.settings_helpSubtitle,
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
    final profileImageUrl = _userInfo?['profileImageUrl'] as String?;
    final isAdmin = _userInfo?['isAdmin'] as bool? ?? false;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceL),
      child: Row(
        children: [
          // 프로필 이미지
          profileImageUrl != null && profileImageUrl.isNotEmpty
              ? CircleAvatar(
                  radius: 40,
                  backgroundImage: CachedNetworkImageProvider(profileImageUrl),
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
                      name ?? l10n.settings_user,
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
                  title: Text(l10n.settings_logoutConfirmTitle),
                  content: Text(l10n.settings_logoutConfirmMessage),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(l10n.common_cancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(l10n.settings_logout),
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
