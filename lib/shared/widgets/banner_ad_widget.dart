import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:family_planner/core/providers/subscription_provider.dart';
import 'package:family_planner/core/services/ad_service.dart';

/// 배너 광고 위젯 (free 유저 전용)
/// 웹에서는 렌더링하지 않음
class BannerAdWidget extends ConsumerStatefulWidget {
  const BannerAdWidget({super.key});

  @override
  ConsumerState<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends ConsumerState<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) return;
    _loadAd();
    ref.listenManual(useTestAdsProvider, (prev, next) {
      if (prev != next) _reloadAd();
    });
  }

  void _loadAd() {
    final ad = AdService.instance.createBannerAd();
    ad.load().then((_) {
      if (mounted) setState(() => _isLoaded = true);
    });
    _bannerAd = ad;
  }

  void _reloadAd() {
    _bannerAd?.dispose();
    _bannerAd = null;
    if (mounted) setState(() => _isLoaded = false);
    _loadAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || !_isLoaded || _bannerAd == null) return const SizedBox.shrink();

    return SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
