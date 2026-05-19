import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// 테스트 계정 이메일 목록 (항상 테스트 광고 Unit ID 사용)
const testAdAccountEmails = {
  'test-owner@familyplanner.test',
  'test-member@familyplanner.test',
};

/// 광고 단위 ID
class _AdUnitIds {
  // Android 테스트 ID (Google 공식 데모)
  static const _androidTestBanner = 'ca-app-pub-3940256099942544/6300978111';
  static const _androidTestInterstitial = 'ca-app-pub-3940256099942544/1033173712';
  static const _androidTestRewarded = 'ca-app-pub-3940256099942544/5224354917';

  // iOS 테스트 ID (Google 공식 데모)
  static const _iosTestBanner = 'ca-app-pub-3940256099942544/2934735716';
  static const _iosTestInterstitial = 'ca-app-pub-3940256099942544/4411468910';
  static const _iosTestRewarded = 'ca-app-pub-3940256099942544/1712485313';

  // Android 실제 Unit ID (프로덕션)
  static const _androidBanner = 'ca-app-pub-XXXXXXXXXX/XXXXXXXXXX';
  static const _androidInterstitial = 'ca-app-pub-XXXXXXXXXX/XXXXXXXXXX';
  static const _androidRewarded = 'ca-app-pub-XXXXXXXXXX/XXXXXXXXXX';

  // iOS 실제 Unit ID (프로덕션)
  static const _iosBanner = 'ca-app-pub-XXXXXXXXXX/XXXXXXXXXX';
  static const _iosInterstitial = 'ca-app-pub-XXXXXXXXXX/XXXXXXXXXX';
  static const _iosRewarded = 'ca-app-pub-XXXXXXXXXX/XXXXXXXXXX';

  static bool get _isIos => defaultTargetPlatform == TargetPlatform.iOS;

  static String banner(bool useTest) => useTest
      ? (_isIos ? _iosTestBanner : _androidTestBanner)
      : (_isIos ? _iosBanner : _androidBanner);

  static String interstitial(bool useTest) => useTest
      ? (_isIos ? _iosTestInterstitial : _androidTestInterstitial)
      : (_isIos ? _iosInterstitial : _androidInterstitial);

  static String rewarded(bool useTest) => useTest
      ? (_isIos ? _iosTestRewarded : _androidTestRewarded)
      : (_isIos ? _iosRewarded : _androidRewarded);
}

class AdService {
  AdService._();
  static final AdService instance = AdService._();

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  bool _isInterstitialLoading = false;
  bool _isRewardedLoading = false;

  /// 개발 환경, 운영자 계정, 테스트 계정 여부 (로그인 후 subscription_provider에서 주입)
  bool useTestAds = kDebugMode;

  /// MobileAds SDK 초기화 (main.dart에서 호출)
  static Future<void> initialize() async {
    if (kIsWeb) return;
    await MobileAds.instance.initialize();
  }

  // ── 배너 광고 ─────────────────────────────────────────────

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: _AdUnitIds.banner(useTestAds),
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
      adUnitId: _AdUnitIds.interstitial(useTestAds),
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
      adUnitId: _AdUnitIds.rewarded(useTestAds),
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
