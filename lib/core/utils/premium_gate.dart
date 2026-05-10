import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/services/ad_service.dart';
import 'package:family_planner/core/providers/subscription_provider.dart';

/// 프리미엄 기능 진입 시 구독 여부 확인 후:
/// - premium/adFree 유저 → 즉시 [onGranted] 실행
/// - free 유저 → 보상형 광고 다이얼로그 표시 후 광고 시청 시 [onGranted] 실행
Future<void> requirePremiumOrAd(
  BuildContext context,
  WidgetRef ref, {
  required String featureName,
  required VoidCallback onGranted,
}) async {
  if (!ref.read(showAdsProvider)) {
    onGranted();
    return;
  }

  // 보상형 광고 미리 로드
  AdService.instance.preloadRewarded();

  if (!context.mounted) return;

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('프리미엄 기능'),
      content: Text('$featureName은(는) 프리미엄 기능입니다.\n'
          '광고를 시청하면 일시적으로 사용할 수 있습니다.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('광고 시청'),
        ),
      ],
    ),
  );

  if (confirmed != true) return;

  await AdService.instance.showRewarded(
    onRewarded: onGranted,
    onDismissedWithoutReward: () {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('광고를 끝까지 시청해야 사용할 수 있습니다.')),
        );
      }
    },
  );
}
