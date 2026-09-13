import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/models/subscription_tier.dart';
import 'package:family_planner/features/settings/groups/models/group_quota.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 한도 초과가 일어난 지점 — 같은 402라도 안내 문구가 달라진다
enum GroupQuotaAction { create, join }

/// 그룹 개수 한도(402) 안내 다이얼로그
///
/// 한도 초과는 "오류"가 아니라 "요금제 안내"다. 원시 예외 문자열을 스낵바로
/// 흘리는 대신, 서버가 준 [GroupQuota]로 지금 상태를 그대로 보여주고 다음
/// 행동(요금제 보기 / 다른 그룹에서 나오기)까지 이어준다.
class GroupQuotaDialog {
  const GroupQuotaDialog._();

  /// 업그레이드를 누르면 true를 돌려준다.
  ///
  /// 이동은 **호출부가** 한다 — 다이얼로그가 떠 있는 채로 라우트를 밀면
  /// imperative 다이얼로그 라우트가 새 화면 위에 그대로 남는다.
  static Future<bool> show(
    BuildContext context,
    GroupQuotaExceededException error, {
    required GroupQuotaAction action,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final canUpgrade = canUpgradeFrom(error);

    final goUpgrade = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(titleFor(l10n, action, error.isApplicant)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(bodyFor(l10n, error)),
            if (!canUpgrade && !error.isApplicant) ...[
              const SizedBox(height: AppSizes.spaceS),
              Text(
                l10n.groupQuota_leaveHint,
                style: Theme.of(dialogContext).textTheme.bodySmall?.copyWith(
                  color: Theme.of(dialogContext).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.common_close),
          ),
          if (canUpgrade)
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l10n.groupQuota_upgrade),
            ),
        ],
      ),
    );
    return goUpgrade ?? false;
  }

  /// 최상위 등급이면 올릴 요금제가 없다 — 결제 대신 다른 대안을 제시한다
  ///
  /// 승인 흐름(신청자 한도 초과)도 승인자가 대신 결제해 줄 수 없으므로 제외한다.
  static bool canUpgradeFrom(GroupQuotaExceededException error) =>
      !error.isApplicant && error.quota?.tier != SubscriptionTier.premium;

  static String titleFor(
    AppLocalizations l10n,
    GroupQuotaAction action,
    bool isApplicant,
  ) {
    if (isApplicant) return l10n.groupQuota_applicantTitle;
    return switch (action) {
      GroupQuotaAction.create => l10n.groupQuota_createTitle,
      GroupQuotaAction.join => l10n.groupQuota_joinTitle,
    };
  }

  static String bodyFor(
    AppLocalizations l10n,
    GroupQuotaExceededException error,
  ) {
    if (error.isApplicant) return l10n.groupQuota_applicantBody;

    final quota = error.quota;
    if (quota == null) return l10n.groupQuota_bodyUnknown;
    return l10n.groupQuota_body(
      quota.tier.displayName,
      quota.limit,
      quota.used,
    );
  }
}
