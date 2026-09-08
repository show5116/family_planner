import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/auth/services/auth_service.dart';
import 'package:family_planner/features/weather/providers/weather_provider.dart';

/// 위치 권한 상태 카드
///
/// 날씨 알림 발송에 사용되는 위치 정보 수집 목적을 안내하고
/// 권한 요청을 처리합니다.
class LocationPermissionCard extends ConsumerStatefulWidget {
  const LocationPermissionCard({super.key});

  @override
  ConsumerState<LocationPermissionCard> createState() =>
      _LocationPermissionCardState();
}

class _LocationPermissionCardState
    extends ConsumerState<LocationPermissionCard> {
  LocationPermission? _permission;
  bool _serviceEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    if (kIsWeb) {
      // 웹은 requestPermission API가 없으므로 항상 unknown 처리
      setState(() {
        _serviceEnabled = true;
        _permission = LocationPermission.whileInUse;
      });
      return;
    }
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    final permission = await Geolocator.checkPermission();
    if (mounted) {
      setState(() {
        _serviceEnabled = serviceEnabled;
        _permission = permission;
      });
    }
  }

  Future<void> _requestPermission() async {
    final l10n = AppLocalizations.of(context)!;
    if (kIsWeb) return;

    if (!_serviceEnabled) {
      await Geolocator.openLocationSettings();
      await _checkPermission();
      return;
    }

    if (_permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      await _checkPermission();
      return;
    }

    final permission = await Geolocator.requestPermission();
    if (mounted) {
      setState(() => _permission = permission);
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      // 권한 허용 즉시 서버에 위치 전송
      try {
        final latLon = await ref.read(locationProvider.future);
        if (!latLon.isFallback) {
          await AuthService().updateLocation(lat: latLon.lat, lon: latLon.lon);
        }
      } catch (_) {}

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.location_permission_granted)),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.location_permission_denied)),
        );
      }
    }
  }

  bool get _isGranted =>
      _permission == LocationPermission.always ||
      _permission == LocationPermission.whileInUse;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_permission == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.spaceM),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    // 웹에서는 브라우저가 권한을 관리하므로 카드 미표시
    if (kIsWeb) return const SizedBox.shrink();

    final isDeniedForever = _permission == LocationPermission.deniedForever;

    return Card(
      color: _isGranted ? Colors.blue[50] : Colors.orange[50],
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _isGranted ? Icons.location_on : Icons.location_off,
                  color: _isGranted ? Colors.blue : Colors.orange,
                ),
                const SizedBox(width: AppSizes.spaceS),
                Expanded(
                  child: Text(
                    l10n.location_permission,
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
                    color: _isGranted ? Colors.blue : Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _isGranted
                        ? l10n.notif_permission_on
                        : l10n.notif_permission_off,
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
              _isGranted
                  ? l10n.location_permission_on_desc
                  : l10n.location_permission_off_desc,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (!_isGranted) ...[
              const SizedBox(height: AppSizes.spaceM),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _requestPermission,
                  icon: const Icon(Icons.location_on),
                  label: Text(isDeniedForever
                      ? l10n.notif_permission_settings
                      : l10n.notif_permission_request),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
