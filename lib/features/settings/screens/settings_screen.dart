import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';

/// 설정 메인 화면
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: ListView(
        children: [
          // 화면 설정 섹션
          _buildSectionHeader(context, '화면 설정'),
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
            onTap: () {
              // TODO: 프로필 설정 화면으로 이동
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
