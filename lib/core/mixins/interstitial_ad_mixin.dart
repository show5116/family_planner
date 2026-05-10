import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/services/ad_service.dart';
import 'package:family_planner/core/providers/subscription_provider.dart';

/// 생성/수정 완료 후 전면 광고를 표시하는 mixin
/// ConsumerState에서 사용
mixin InterstitialAdMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  @override
  void initState() {
    super.initState();
    if (ref.read(showAdsProvider)) {
      AdService.instance.preloadInterstitial();
    }
  }

  /// 저장 완료 후 광고 표시 → 광고 닫히면 [onDismissed] 실행
  void showInterstitialThenNavigate(VoidCallback onDismissed) {
    if (!ref.read(showAdsProvider)) {
      onDismissed();
      return;
    }
    AdService.instance.showInterstitial(onDismissed: onDismissed);
  }
}
