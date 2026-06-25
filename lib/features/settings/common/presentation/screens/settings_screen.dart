import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/models/subscription_tier.dart';
import 'package:family_planner/core/providers/subscription_provider.dart';
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
          // 구독 상태 카드
          _SubscriptionCard(),
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

          // 신고 내역 섹션 (일반 유저)
          _buildSectionHeader(context, '신고'),
          _buildSettingTile(
            context,
            icon: Icons.flag_outlined,
            title: '내 신고 내역',
            subtitle: '내가 신고한 목록을 확인합니다',
            onTap: () => context.push(AppRoutes.myGroupReports),
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
              icon: Icons.manage_accounts_outlined,
              title: '사용자 및 계정 관리',
              subtitle: '구독 수정, 계정 삭제 예약 및 처리',
              onTap: () {
                context.push(AppRoutes.adminUserManagement);
              },
            ),
            _buildSettingTile(
              context,
              icon: Icons.report_outlined,
              title: '신고 관리',
              subtitle: '그룹원 신고 접수 및 처리',
              onTap: () => context.push(AppRoutes.adminGroupReports),
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

class _SubscriptionCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionAsync = ref.watch(subscriptionProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return subscriptionAsync.when(
      skipLoadingOnReload: true,
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (subscription) {
        final l10n = AppLocalizations.of(context)!;
        final tier = subscription.tier;
        final isTrial = subscription.isTrial;
        final daysLeft = subscription.daysLeft;
        final expiresAt = subscription.expiresAt;

        String formatDate(DateTime dt) =>
            '${dt.year}.${dt.month.toString().padLeft(2, '0')}.${dt.day.toString().padLeft(2, '0')}';

        final (IconData icon, Color color, String label, String sublabel) = switch (tier) {
          SubscriptionTier.free => (
              Icons.sentiment_neutral_outlined,
              Colors.grey,
              l10n.subscription_free_label,
              l10n.subscription_free_sublabel,
            ),
          SubscriptionTier.adFree when isTrial => (
              Icons.card_giftcard_outlined,
              colorScheme.primary,
              l10n.subscription_trial_label,
              daysLeft > 0
                  ? l10n.subscription_trial_sublabel_days(daysLeft)
                  : l10n.subscription_trial_sublabel_today,
            ),
          SubscriptionTier.adFree => (
              Icons.block_outlined,
              Colors.blue,
              l10n.subscription_ad_free_label,
              expiresAt != null
                  ? l10n.subscription_ad_free_sublabel_expires(formatDate(expiresAt))
                  : l10n.subscription_ad_free_sublabel_active,
            ),
          SubscriptionTier.premium => (
              Icons.workspace_premium_outlined,
              const Color(0xFFFF9800),
              l10n.subscription_premium_label,
              expiresAt != null
                  ? l10n.subscription_premium_sublabel_expires(formatDate(expiresAt))
                  : l10n.subscription_premium_sublabel_active,
            ),
        };

        return Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.spaceM,
            AppSizes.spaceL,
            AppSizes.spaceM,
            AppSizes.spaceS,
          ),
          child: Container(
            padding: const EdgeInsets.all(AppSizes.spaceM),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              border: Border.all(color: color.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 32),
                const SizedBox(width: AppSizes.spaceM),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      sublabel,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
