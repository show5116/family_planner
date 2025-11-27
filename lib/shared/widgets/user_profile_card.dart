import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// 사용자 프로필 카드
///
/// 프로필 이미지, 이름, 이메일, 관리자 뱃지를 표시합니다.
class UserProfileCard extends StatelessWidget {
  const UserProfileCard({
    super.key,
    this.name,
    this.email,
    this.profileImage,
    this.isAdmin = false,
  });

  final String? name;
  final String? email;
  final String? profileImage;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildProfileImage(context),
            const SizedBox(width: 16),
            Expanded(
              child: _buildProfileInfo(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    if (profileImage != null && profileImage!.isNotEmpty) {
      return CircleAvatar(
        radius: 32,
        backgroundImage: CachedNetworkImageProvider(profileImage!),
      );
    }

    return CircleAvatar(
      radius: 32,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: const Icon(Icons.person, size: 32, color: Colors.white),
    );
  }

  Widget _buildProfileInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNameWithBadge(context),
        const SizedBox(height: 4),
        Text(
          email ?? 'user@example.com',
          style: Theme.of(context).textTheme.bodyMedium,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildNameWithBadge(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            name ?? '사용자',
            style: Theme.of(context).textTheme.titleLarge,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (isAdmin) ...[
          const SizedBox(width: 8),
          _buildAdminBadge(),
        ],
      ],
    );
  }

  Widget _buildAdminBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
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
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
