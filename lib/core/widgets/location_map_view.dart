import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';

/// 저장된 장소를 지도로 표시하는 바텀시트
/// - 모바일: kakao_map_plugin 인앱 지도
/// - 웹: 네이버 지도 외부 링크 버튼 (kakao_map_plugin 웹 미지원)
void showLocationMapBottomSheet(BuildContext context, TaskLocation location) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => _LocationMapSheet(location: location),
  );
}

class _LocationMapSheet extends StatefulWidget {
  final TaskLocation location;

  const _LocationMapSheet({required this.location});

  @override
  State<_LocationMapSheet> createState() => _LocationMapSheetState();
}

class _LocationMapSheetState extends State<_LocationMapSheet> {
  LatLng get _latLng => LatLng(widget.location.lat, widget.location.lng);

  Future<void> _openKakaoMap() async {
    // 카카오맵 앱 또는 웹으로 열기
    final appUri = Uri.parse(
      'kakaomap://look?p=${widget.location.lat},${widget.location.lng}',
    );
    final webUri = Uri.parse(
      'https://map.kakao.com/link/map/${Uri.encodeComponent(widget.location.name)},${widget.location.lat},${widget.location.lng}',
    );

    if (await canLaunchUrl(appUri)) {
      await launchUrl(appUri);
    } else {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          // 핸들
          const SizedBox(height: AppSizes.spaceS),
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.spaceM),
          // 장소 정보
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: AppColors.primary),
                const SizedBox(width: AppSizes.spaceS),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.location.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.location.address,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.open_in_new, size: 16),
                  label: const Text('지도 앱'),
                  onPressed: _openKakaoMap,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.spaceS),
          // 지도 영역
          Expanded(
            child: kIsWeb ? _WebMapPlaceholder(location: widget.location) : _MobileMap(
              latLng: _latLng,
              name: widget.location.name,
              onMapCreated: (_) {},
            ),
          ),
        ],
      ),
    );
  }
}

/// 모바일 카카오 지도
class _MobileMap extends StatelessWidget {
  final LatLng latLng;
  final String name;
  final void Function(KakaoMapController) onMapCreated;

  const _MobileMap({
    required this.latLng,
    required this.name,
    required this.onMapCreated,
  });

  @override
  Widget build(BuildContext context) {
    return KakaoMap(
      center: latLng,
      markers: [
        Marker(
          markerId: 'place',
          latLng: latLng,
        ),
      ],
      onMapCreated: onMapCreated,
    );
  }
}

/// 웹 전용 — 지도 미지원 안내 + 외부 링크
class _WebMapPlaceholder extends StatelessWidget {
  final TaskLocation location;

  const _WebMapPlaceholder({required this.location});

  Future<void> _openMap() async {
    final uri = Uri.parse(
      'https://map.kakao.com/link/map/${Uri.encodeComponent(location.name)},${location.lat},${location.lng}',
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.map_outlined, size: 48, color: theme.colorScheme.outlineVariant),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            '웹에서는 지도를 직접 표시할 수 없습니다',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSizes.spaceM),
          FilledButton.icon(
            icon: const Icon(Icons.open_in_new),
            label: const Text('카카오맵에서 보기'),
            onPressed: _openMap,
          ),
        ],
      ),
    );
  }
}
