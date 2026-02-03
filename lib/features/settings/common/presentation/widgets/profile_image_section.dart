import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:family_planner/core/constants/app_sizes.dart';

/// 프로필 이미지 섹션 위젯
class ProfileImageSection extends StatelessWidget {
  final String? profileImageUrl;
  final String? email;
  final bool isUploading;
  final VoidCallback onUploadTap;

  const ProfileImageSection({
    super.key,
    this.profileImageUrl,
    this.email,
    this.isUploading = false,
    required this.onUploadTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              _buildProfileImage(),
              if (isUploading) _buildLoadingOverlay(),
              _buildUploadButton(context),
            ],
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            email ?? '',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    if (profileImageUrl != null && profileImageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 60,
        backgroundImage: CachedNetworkImageProvider(profileImageUrl!),
      );
    }
    return CircleAvatar(
      radius: 60,
      child: Icon(
        Icons.person,
        size: 60,
        color: Colors.grey[400],
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return const Positioned.fill(
      child: CircleAvatar(
        radius: 60,
        backgroundColor: Colors.black54,
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  Widget _buildUploadButton(BuildContext context) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: IconButton(
          icon: const Icon(Icons.camera_alt, size: 20),
          color: Colors.white,
          onPressed: isUploading ? null : onUploadTap,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
