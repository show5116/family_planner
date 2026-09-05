import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/iap_product_ids.dart';
import 'package:family_planner/core/models/subscription_platform.dart';
import 'package:family_planner/core/models/subscription_tier.dart';
import 'package:family_planner/core/providers/subscription_provider.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/core/services/in_app_purchase_service.dart';
import 'package:family_planner/features/subscription/data/models/subscription_model.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 구독 관리 화면
///
/// 현재 구독 상태, 구매 가능한 상품 목록, 구독 복원 기능을 제공한다.
class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() =>
      _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  bool _isPurchasing = false;

  @override
  void initState() {
    super.initState();
    InAppPurchaseService.instance
        .initialize(onPurchaseUpdate: _handlePurchaseUpdate)
        .then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final subscriptionAsync = ref.watch(subscriptionProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.subscription_screen_title)),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        children: [
          subscriptionAsync.when(
            // 구매·복원 중이거나 실패했다고 해서 현재 플랜 카드가 사라지면
            // 안 된다. 직전 값이 남아 있으면 그대로 그린다.
            // (진행 표시는 버튼 비활성화, 실패 안내는 스낵바가 맡는다.)
            skipLoadingOnReload: true,
            skipError: true,
            data: (subscription) => _CurrentPlanCard(subscription: subscription),
            loading: () => const Center(child: CircularProgressIndicator()),
            // 최초 로드조차 못 한 경우만 여기 온다. subscriptionProvider는
            // 서버 실패 시 캐시 → free로 폴백하므로 사실상 도달하지 않는다.
            error: (e, st) => const SizedBox.shrink(),
          ),
          const SizedBox(height: AppSizes.spaceM),
          _PlanComparison(
            currentTier:
                subscriptionAsync.valueOrNull?.tier ?? SubscriptionTier.free,
            isTrial: subscriptionAsync.valueOrNull?.isTrial ?? false,
            isPurchasing: _isPurchasing,
            onPurchase: _onPurchase,
          ),
          const SizedBox(height: AppSizes.spaceM),
          _RestoreButton(onRestore: _onRestore),
          const SizedBox(height: AppSizes.spaceS),
          _ManageSubscriptionButton(onManage: _onManageSubscription),
          const SizedBox(height: AppSizes.spaceM),
          // App Store Guideline 3.1.2 필수 고지 3종:
          // 자동 갱신 조건 + 이용약관 + 개인정보 처리방침
          const _AutoRenewNotice(),
          const SizedBox(height: AppSizes.spaceS),
          const _LegalLinks(),
        ],
      ),
    );
  }

  /// 스토어 구독 관리 화면으로 이동 (해지 경로 제공 — 애플 심사 필수)
  Future<void> _onManageSubscription() async {
    final uri = Uri.parse(
      Platform.isIOS
          ? 'https://apps.apple.com/account/subscriptions'
          : 'https://play.google.com/store/account/subscriptions',
    );
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.subscription_manage_launch_failed)),
      );
    }
  }

  Future<void> _onPurchase(String productId) async {
    setState(() => _isPurchasing = true);
    try {
      await InAppPurchaseService.instance.purchaseSubscription(productId);
    } catch (_) {
      if (mounted) _showNetworkErrorSnackBar();
    } finally {
      if (mounted) setState(() => _isPurchasing = false);
    }
  }

  Future<void> _onRestore() async {
    setState(() => _isPurchasing = true);
    try {
      await InAppPurchaseService.instance.restorePurchases();
      await ref.read(subscriptionProvider.notifier).restore();
      if (mounted) _showRestoreSuccessSnackBar();
    } catch (_) {
      if (mounted) _showNetworkErrorSnackBar();
    } finally {
      if (mounted) setState(() => _isPurchasing = false);
    }
  }

  Future<void> _handlePurchaseUpdate(PurchaseDetails purchase) async {
    switch (purchase.status) {
      case PurchaseStatus.pending:
        break;
      case PurchaseStatus.purchased:
        await _verifyPurchase(purchase, showSuccessSnackBar: true);
      case PurchaseStatus.restored:
        // StoreKit은 구매 감시자를 새로 등록할 때(예: 화면 진입, 복원 버튼)마다
        // 과거 거래를 restored로 재전달한다. 이건 사용자가 방금 구매한 게
        // 아니므로 "구매 완료" 스낵바를 띄우면 안 된다 (복원 버튼 자체의
        // 성공 메시지는 _onRestore()가 따로 처리).
        await _verifyPurchase(purchase, showSuccessSnackBar: false);
      case PurchaseStatus.error:
        if (mounted) _showNetworkErrorSnackBar();
        await InAppPurchaseService.instance.completePurchase(purchase);
      case PurchaseStatus.canceled:
        break;
    }
  }

  Future<void> _verifyPurchase(
    PurchaseDetails purchase, {
    required bool showSuccessSnackBar,
  }) async {
    final platform = InAppPurchaseService.instance.currentPlatform;
    final token = purchase.verificationData.serverVerificationData;

    try {
      await ref.read(subscriptionProvider.notifier).verify(
            platform: platform,
            purchaseToken:
                platform == SubscriptionPlatform.android ? token : null,
            signedTransaction:
                platform == SubscriptionPlatform.ios ? token : null,
          );
      await InAppPurchaseService.instance.completePurchase(purchase);
      if (mounted && showSuccessSnackBar) _showPurchaseSuccessSnackBar();
    } on DioException catch (e) {
      if (!mounted) return;
      if (e.response?.statusCode == 422) {
        // completePurchase를 호출하지 않아 재시도 가능한 pending 상태로 남겨둔다.
        await _showVerifyFailedDialog();
      } else {
        _showNetworkErrorSnackBar();
      }
    }
  }

  Future<void> _showVerifyFailedDialog() async {
    final l10n = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.subscription_verify_failed_title),
        content: Text(l10n.subscription_verify_failed_message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.common_confirm),
          ),
        ],
      ),
    );
  }

  void _showPurchaseSuccessSnackBar() {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.subscription_purchase_success)),
    );
  }

  void _showRestoreSuccessSnackBar() {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.subscription_restore_success)),
    );
  }

  void _showNetworkErrorSnackBar() {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.subscription_verify_network_error),
        backgroundColor: AppColors.error,
      ),
    );
  }
}

// ── 현재 구독 상태 카드 ──────────────────────────────────────────

class _CurrentPlanCard extends StatelessWidget {
  const _CurrentPlanCard({required this.subscription});

  final SubscriptionModel subscription;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final tier = subscription.tier;
    final isTrial = subscription.isTrial;
    final expiresAt = subscription.expiresAt;

    // 체험은 tier가 adFree라 tier만으로는 유료 구독과 구별되지 않는다.
    // 배지 색도 설정 화면과 맞춰 체험은 primary로 구분한다.
    final badgeColor = isTrial ? colorScheme.primary : tier.color;
    final badgeLabel = switch (tier) {
      SubscriptionTier.free => l10n.subscription_free_label,
      SubscriptionTier.adFree when isTrial => l10n.subscription_trial_label,
      SubscriptionTier.adFree => l10n.subscription_ad_free_label,
      SubscriptionTier.premium => l10n.subscription_premium_label,
    };

    // 유료로 이용 중인 구독. 체험은 tier가 adFree여도 결제 갱신이 아니라
    // 무료 플랜으로 전환되므로 갱신 안내 대상이 아니다.
    final isPaidActive = subscription.isActive && !isTrial;
    final autoRenewing = subscription.autoRenewing;

    // 같은 날짜라도 상황에 따라 의미가 다르다. 자동 갱신 중인 구독자에게
    // "만료일"이라고만 쓰면 서비스가 끊기는 날로 읽힌다.
    final dateLabel = !subscription.isActive
        ? l10n.subscription_expires_at_label
        : isTrial
        ? l10n.subscription_trial_ends_at_label
        : autoRenewing == true
        ? l10n.subscription_next_renewal_label
        : l10n.subscription_period_end_label;

    // 남은 기간은 서버가 준 daysLeft를 그대로 쓴다. 기기 시계로 다시 계산하면
    // 서버와 어긋난다. 만료·무료면 서버가 0을 주므로 활성일 때만 보여준다.
    final showDaysLeft = subscription.isActive && expiresAt != null;

    // 갱신 안내는 서버가 준 autoRenewing에 따라 셋으로 갈린다.
    // - false: 해지된 상태다. 만료일에 끝난다고 분명히 알린다.
    // - true : 라벨이 이미 "다음 갱신일"이라 문구를 더 붙이지 않는다.
    // - null : 구버전 서버라 단정할 수 없다. "해지하지 않으면" 조건절로 쓴다.
    final renewHint = !isPaidActive || expiresAt == null
        ? null
        : autoRenewing == false
        ? l10n.subscription_canceled_hint
        : autoRenewing == null
        ? l10n.subscription_auto_renew_hint
        : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.workspace_premium_outlined, color: badgeColor),
                const SizedBox(width: AppSizes.spaceS),
                Text(
                  l10n.subscription_current_plan_label,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Spacer(),
                _TierBadge(label: badgeLabel, color: badgeColor),
              ],
            ),
            const Divider(height: AppSizes.spaceL),
            _InfoRow(
              label: l10n.subscription_active_status_label,
              value: subscription.isActive
                  ? l10n.subscription_active
                  : l10n.subscription_inactive,
              valueColor: subscription.isActive ? AppColors.success : null,
            ),
            if (expiresAt != null) ...[
              const SizedBox(height: AppSizes.spaceS),
              _InfoRow(label: dateLabel, value: _formatDate(expiresAt)),
            ],
            if (showDaysLeft) ...[
              const SizedBox(height: AppSizes.spaceS),
              _InfoRow(
                label: l10n.subscription_days_left_label,
                value: subscription.daysLeft > 0
                    ? l10n.subscription_days_left_value(subscription.daysLeft)
                    : l10n.subscription_days_left_today,
              ),
            ],
            if (renewHint != null) ...[
              const SizedBox(height: AppSizes.spaceS),
              Text(
                renewHint,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      // 해지 상태는 놓치면 안 되는 정보라 강조한다.
                      color: autoRenewing == false
                          ? AppColors.warning
                          : colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}.${dt.month.toString().padLeft(2, '0')}.${dt.day.toString().padLeft(2, '0')}';
  }
}

// ── 구독 상품 카드 ────────────────────────────────────────────
// ── 플랜 비교 카드 ────────────────────────────────────────────

/// 무료 플랜과 구독 상품을 나란히 비교해 보여준다.
///
/// 상품 하나만 덩그러니 두면 "왜 결제해야 하는지"가 드러나지 않아,
/// 현재 쓰는 무료 플랜과 혜택을 나란히 놓고 차이를 보이게 했다.
class _PlanComparison extends StatelessWidget {
  const _PlanComparison({
    required this.currentTier,
    required this.isTrial,
    required this.isPurchasing,
    required this.onPurchase,
  });

  final SubscriptionTier currentTier;

  /// 결제 없이 서버가 부여한 무료 체험인지 여부.
  final bool isTrial;

  final bool isPurchasing;
  final void Function(String productId) onPurchase;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final products = InAppPurchaseService.instance.products;
    final adFreeProduct =
        products.where((p) => p.id == IapProductIds.adFreeMonthly).firstOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.subscription_compare_title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: AppSizes.spaceS),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _PlanCard(
                  title: l10n.subscription_free_label,
                  price: l10n.subscription_free_plan_price,
                  accent: Theme.of(context).colorScheme.outline,
                  isCurrent: currentTier == SubscriptionTier.free,
                  benefits: [
                    (true, l10n.subscription_benefit_all_features),
                    (false, l10n.subscription_benefit_ads_shown),
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.spaceS),
              Expanded(
                child: _PlanCard(
                  title: l10n.subscription_ad_free_label,
                  // 스토어에서 상품을 아직 못 받아왔으면 가격 자리를 비운다.
                  price: adFreeProduct == null
                      ? null
                      : '${adFreeProduct.price} / ${l10n.subscription_period_monthly}',
                  accent: SubscriptionTier.adFree.color,
                  isCurrent: currentTier == SubscriptionTier.adFree,
                  highlighted: true,
                  benefits: [
                    (true, l10n.subscription_benefit_all_features),
                    (true, l10n.subscription_benefit_no_ads),
                    (true, l10n.subscription_benefit_no_reward_ads),
                    (true, l10n.subscription_benefit_cancel_anytime),
                  ],
                  // 이미 결제로 구독 중이면 카드 상단 "현재 플랜" 배지로 충분히
                  // 드러나므로 구매 버튼을 숨긴다. 다만 무료 체험은 tier가
                  // adFree여도 결제 수단이 없는 상태라, 체험이 끝나기 전에
                  // 구독할 길을 남겨둬야 한다 (심사에서도 이 화면으로 결제
                  // 플로우를 확인한다).
                  action: currentTier == SubscriptionTier.adFree && !isTrial
                      ? null
                      : adFreeProduct == null
                          ? Text(
                              l10n.subscription_product_not_found,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            )
                          : SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                onPressed: isPurchasing
                                    ? null
                                    : () => onPurchase(adFreeProduct.id),
                                child: Text(l10n.subscription_purchase_button),
                              ),
                            ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.title,
    required this.price,
    required this.accent,
    required this.isCurrent,
    required this.benefits,
    this.highlighted = false,
    this.action,
  });

  final String title;
  final String? price;
  final Color accent;
  final bool isCurrent;

  /// (포함 여부, 문구) — false면 이 플랜에 없는 항목으로 표시한다.
  final List<(bool, String)> benefits;
  final bool highlighted;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      decoration: BoxDecoration(
        color: highlighted ? accent.withValues(alpha: 0.06) : null,
        border: Border.all(
          color: highlighted
              ? accent.withValues(alpha: 0.5)
              : colorScheme.outlineVariant,
          width: highlighted ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: accent,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              if (isCurrent)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spaceS,
                    vertical: AppSizes.spaceXS,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  ),
                  child: Text(
                    l10n.subscription_plan_current,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceXS),
          if (price != null)
            Text(
              price!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          const SizedBox(height: AppSizes.spaceM),
          ...benefits.map(
            (benefit) => Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.spaceXS),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    benefit.$1 ? Icons.check : Icons.close,
                    size: AppSizes.iconSmall,
                    color: benefit.$1 ? accent : colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSizes.spaceXS),
                  Expanded(
                    child: Text(
                      benefit.$2,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: benefit.$1
                                ? colorScheme.onSurface
                                : colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (action != null) ...[
            const Spacer(),
            const SizedBox(height: AppSizes.spaceS),
            action!,
          ],
        ],
      ),
    );
  }
}
// ── 구독 복원 버튼 ────────────────────────────────────────────

class _RestoreButton extends StatelessWidget {
  const _RestoreButton({required this.onRestore});

  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onRestore,
        icon: const Icon(Icons.restore_outlined),
        label: Text(l10n.subscription_restore_button),
      ),
    );
  }
}

// ── 스토어 구독 관리 버튼 ──────────────────────────────────────

class _ManageSubscriptionButton extends StatelessWidget {
  const _ManageSubscriptionButton({required this.onManage});

  final VoidCallback onManage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: onManage,
        icon: const Icon(Icons.open_in_new_outlined),
        label: Text(l10n.subscription_manage_subscription_button),
      ),
    );
  }
}

// ── 자동 갱신 고지 ────────────────────────────────────────────

/// 구독 기간·자동 갱신·해지 방법 고지.
///
/// App Store Guideline 3.1.2가 구독 화면에 요구하는 필수 항목이라 상품
/// 유무와 관계없이 항상 노출한다.
class _AutoRenewNotice extends StatelessWidget {
  const _AutoRenewNotice();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Text(
      l10n.subscription_auto_renew_notice,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    );
  }
}

// ── 약관 / 개인정보 링크 ──────────────────────────────────────

class _LegalLinks extends StatelessWidget {
  const _LegalLinks();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () => context.push(AppRoutes.termsOfService),
          child: Text(l10n.subscription_terms_button),
        ),
        Text(
          '·',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        TextButton(
          onPressed: () => context.push(AppRoutes.privacyPolicy),
          child: Text(l10n.subscription_privacy_button),
        ),
      ],
    );
  }
}

// ── 공통 위젯 ────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: valueColor,
                fontWeight: valueColor != null ? FontWeight.bold : null,
              ),
        ),
      ],
    );
  }
}

class _TierBadge extends StatelessWidget {
  // tier를 그대로 받으면 `tier.displayName`(한국어 하드코딩)이 찍히고,
  // 체험과 유료 광고 제거가 같은 문구로 보인다. 라벨과 색을 받아 쓴다.
  const _TierBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceS,
        vertical: AppSizes.spaceXS,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
