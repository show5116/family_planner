import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 설정 메인 화면
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() => _appVersion = '${info.version} (${info.buildNumber})');
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
      final email = ref.read(authProvider).user?['email'] as String? ?? '';
      context.push('${AppRoutes.forgotPassword}?setup=true&email=${Uri.encodeComponent(email)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userInfo = ref.watch(authProvider).user;
    final isAdmin = userInfo?['isAdmin'] as bool? ?? false;
    final hasPassword = userInfo?['hasPassword'] as bool? ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings_title),
      ),
      body: ListView(
        children: [
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
              if (!hasPassword && mounted) {
                await _showPasswordSetupGuideDialog();
              } else {
                if (mounted) context.push(AppRoutes.profile);
              }
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
              context.push(AppRoutes.notifications);
            },
          ),
          const Divider(),

          // 운영자 전용 섹션 (관리자만 표시)
          if (isAdmin) ...[
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
            _buildSettingTile(
              context,
              icon: Icons.people_outlined,
              title: '사용자 관리',
              subtitle: '사용자 목록 조회 및 구독 정보 수정',
              onTap: () {
                context.push(AppRoutes.adminUserManagement);
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
            subtitle: _appVersion.isEmpty ? l10n.settings_appInfoSubtitle : _appVersion,
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Family Planner',
                applicationVersion: _appVersion,
                applicationIcon: const FlutterLogo(size: 48),
                children: [
                  Text(l10n.settings_appDescription),
                ],
              );
            },
          ),
          _buildSettingTile(
            context,
            icon: Icons.description_outlined,
            title: l10n.settings_termsOfServiceTitle,
            subtitle: l10n.settings_termsOfServiceSubtitle,
            onTap: () => context.push(AppRoutes.termsOfService),
          ),
          _buildSettingTile(
            context,
            icon: Icons.privacy_tip_outlined,
            title: l10n.settings_privacyPolicyTitle,
            subtitle: l10n.settings_privacyPolicySubtitle,
            onTap: () => context.push(AppRoutes.privacyPolicy),
          ),
          _buildSettingTile(
            context,
            icon: Icons.help_outline,
            title: l10n.settings_helpTitle,
            subtitle: l10n.settings_helpSubtitle,
            onTap: () => _showOnboardingResetDialog(),
          ),
        ],
      ),
    );
  }

  Future<void> _showOnboardingResetDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.replay_outlined),
            SizedBox(width: 8),
            Text('튜토리얼 다시 보기'),
          ],
        ),
        content: const Text(
          '앱 소개 슬라이드와 각 기능의 안내를\n처음부터 다시 볼 수 있습니다.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('다시 보기'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final messenger = ScaffoldMessenger.of(context);
      await OnboardingService.resetAll();
      messenger.showSnackBar(
        const SnackBar(content: Text('다음 앱 실행 시 튜토리얼이 표시됩니다.')),
      );
    }
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
