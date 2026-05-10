import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// 광고 단위 ID (테스트용)
/// 프로덕션 배포 시 실제 ID로 교체 필요
class _AdUnitIds {
  // Android 테스트 ID
  static const _androidBanner = 'ca-app-pub-3940256099942544/6300978111';
  static const _androidInterstitial = 'ca-app-pub-3940256099942544/1033173712';
  static const _androidRewarded = 'ca-app-pub-3940256099942544/5224354917';

  // iOS 테스트 ID
  static const _iosBanner = 'ca-app-pub-3940256099942544/2934735716';
  static const _iosInterstitial = 'ca-app-pub-3940256099942544/4411468910';
  static const _iosRewarded = 'ca-app-pub-3940256099942544/1712485313';

  static String get banner => defaultTargetPlatform == TargetPlatform.iOS ? _iosBanner : _androidBanner;
  static String get interstitial => defaultTargetPlatform == TargetPlatform.iOS ? _iosInterstitial : _androidInterstitial;
  static String get rewarded => defaultTargetPlatform == TargetPlatform.iOS ? _iosRewarded : _androidRewarded;
}

class AdService {
  AdService._();
  static final AdService instance = AdService._();

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  bool _isInterstitialLoading = false;
  bool _isRewardedLoading = false;

  /// MobileAds SDK 초기화 (main.dart에서 호출)
  static Future<void> initialize() async {
    if (kIsWeb) return;
    await MobileAds.instance.initialize();
  }

  // ── 배너 광고 ─────────────────────────────────────────────

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: _AdUnitIds.banner,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    );
  }

  // ── 전면 광고 ─────────────────────────────────────────────

  void preloadInterstitial() {
    if (kIsWeb || _isInterstitialLoading || _interstitialAd != null) return;
    _isInterstitialLoading = true;

    InterstitialAd.load(
      adUnitId: _AdUnitIds.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialLoading = false;
          ad.setImmersiveMode(true);
        },
        onAdFailedToLoad: (error) {
          _isInterstitialLoading = false;
        },
      ),
    );
  }

  Future<void> showInterstitial({VoidCallback? onDismissed}) async {
    if (kIsWeb) {
      onDismissed?.call();
      return;
    }

    if (_interstitialAd == null) {
      onDismissed?.call();
      preloadInterstitial();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        onDismissed?.call();
        preloadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        onDismissed?.call();
        preloadInterstitial();
      },
    );

    await _interstitialAd!.show();
  }

  // ── 보상형 광고 ───────────────────────────────────────────

  void preloadRewarded() {
    if (kIsWeb || _isRewardedLoading || _rewardedAd != null) return;
    _isRewardedLoading = true;

    RewardedAd.load(
      adUnitId: _AdUnitIds.rewarded,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedLoading = false;
          ad.setImmersiveMode(true);
        },
        onAdFailedToLoad: (error) {
          _isRewardedLoading = false;
        },
      ),
    );
  }

  /// 보상형 광고 표시
  /// [onRewarded]: 광고를 끝까지 시청했을 때 콜백 (기능 허용)
  /// [onDismissedWithoutReward]: 광고를 건너뛰었을 때 콜백
  Future<void> showRewarded({
    required VoidCallback onRewarded,
    VoidCallback? onDismissedWithoutReward,
  }) async {
    if (kIsWeb) {
      onRewarded();
      return;
    }

    if (_rewardedAd == null) {
      onDismissedWithoutReward?.call();
      preloadRewarded();
      return;
    }

    bool rewarded = false;

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        if (!rewarded) onDismissedWithoutReward?.call();
        preloadRewarded();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        onDismissedWithoutReward?.call();
        preloadRewarded();
      },
    );

    await _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        rewarded = true;
        onRewarded();
      },
    );
  }

  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }
}
