import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';

/// 알림 권한 상태 카드
class NotificationPermissionCard extends ConsumerStatefulWidget {
  const NotificationPermissionCard({super.key});

  @override
  ConsumerState<NotificationPermissionCard> createState() =>
      _NotificationPermissionCardState();
}

class _NotificationPermissionCardState
    extends ConsumerState<NotificationPermissionCard> {
  AuthorizationStatus? _permissionStatus;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final settings = await FirebaseMessaging.instance.getNotificationSettings();
    setState(() {
      _permissionStatus = settings.authorizationStatus;
    });
  }

  Future<void> _requestPermission() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    setState(() {
      _permissionStatus = settings.authorizationStatus;
    });

    if (mounted) {
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('알림 권한이 허용되었습니다')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('알림 권한이 거부되었습니다')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_permissionStatus == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.spaceM),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final isGranted = _permissionStatus == AuthorizationStatus.authorized;

    return Card(
      color: isGranted ? Colors.green[50] : Colors.orange[50],
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isGranted ? Icons.notifications_active : Icons.notifications_off,
                  color: isGranted ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: AppSizes.spaceS),
                Expanded(
                  child: Text(
                    '알림 권한',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spaceS,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isGranted ? Colors.green : Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isGranted ? '활성화됨' : '비활성화됨',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceM),
            Text(
              isGranted
                  ? '푸시 알림을 받을 수 있습니다.'
                  : '알림을 받으려면 권한을 허용해주세요.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (!isGranted) ...[
              const SizedBox(height: AppSizes.spaceM),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _requestPermission,
                  icon: const Icon(Icons.notifications_active),
                  label: const Text('권한 요청'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
