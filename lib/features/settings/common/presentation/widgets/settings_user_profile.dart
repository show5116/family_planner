import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 설정 화면 사용자 프로필 위젯
class SettingsUserProfile extends StatelessWidget {
  final String? name;
  final String? email;
  final String? profileImageUrl;
  final bool isAdmin;
  final VoidCallback onLogout;

  const SettingsUserProfile({
    super.key,
    this.name,
    this.email,
    this.profileImageUrl,
    this.isAdmin = false,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceL),
      child: Row(
        children: [
          // 프로필 이미지
          _buildProfileImage(),
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
                      _buildAdminBadge(),
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
            onPressed: onLogout,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    if (profileImageUrl != null && profileImageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 40,
        backgroundImage: CachedNetworkImageProvider(profileImageUrl!),
      );
    }
    return CircleAvatar(
      radius: 40,
      child: Icon(
        Icons.person,
        size: 40,
        color: Colors.grey[400],
      ),
    );
  }

  Widget _buildAdminBadge() {
    return Container(
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
    );
  }
}
