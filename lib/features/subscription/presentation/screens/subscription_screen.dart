import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/iap_product_ids.dart';
import 'package:family_planner/core/models/subscription_platform.dart';
import 'package:family_planner/core/models/subscription_tier.dart';
import 'package:family_planner/core/providers/subscription_provider.dart';
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
    InAppPurchaseService.instance.initialize(
      onPurchaseUpdate: _handlePurchaseUpdate,
    );
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
            data: (subscription) => _CurrentPlanCard(subscription: subscription),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => const SizedBox.shrink(),
          ),
          const SizedBox(height: AppSizes.spaceM),
          _ProductsCard(
            isPurchasing: _isPurchasing,
            onPurchase: _onPurchase,
          ),
          const SizedBox(height: AppSizes.spaceM),
          _RestoreButton(onRestore: _onRestore),
        ],
      ),
    );
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
      case PurchaseStatus.restored:
        await _verifyPurchase(purchase);
      case PurchaseStatus.error:
        if (mounted) _showNetworkErrorSnackBar();
        await InAppPurchaseService.instance.completePurchase(purchase);
      case PurchaseStatus.canceled:
        break;
    }
  }

  Future<void> _verifyPurchase(PurchaseDetails purchase) async {
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
      if (mounted) _showPurchaseSuccessSnackBar();
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
        backgroundColor: Colors.red,
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
    final tier = subscription.tier;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.workspace_premium_outlined, color: tier.color),
                const SizedBox(width: AppSizes.spaceS),
                Text(
                  l10n.subscription_current_plan_label,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Spacer(),
                _TierBadge(tier: tier),
              ],
            ),
            const Divider(height: AppSizes.spaceL),
            _InfoRow(
              label: l10n.subscription_active_status_label,
              value: subscription.isActive
                  ? l10n.subscription_active
                  : l10n.subscription_inactive,
              valueColor: subscription.isActive ? Colors.green : null,
            ),
            if (subscription.expiresAt != null) ...[
              const SizedBox(height: AppSizes.spaceS),
              _InfoRow(
                label: l10n.subscription_expires_at_label,
                value: _formatDate(subscription.expiresAt!),
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

class _ProductsCard extends StatelessWidget {
  const _ProductsCard({required this.isPurchasing, required this.onPurchase});

  final bool isPurchasing;
  final void Function(String productId) onPurchase;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final products = InAppPurchaseService.instance.products;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.subscription_products_section_title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const Divider(height: AppSizes.spaceL),
            if (products.isEmpty)
              Text(
                l10n.subscription_product_not_found,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              )
            else
              ...products.map(
                (product) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
                  child: _ProductTile(
                    product: product,
                    isPurchasing: isPurchasing,
                    onPurchase: () => onPurchase(product.id),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({
    required this.product,
    required this.isPurchasing,
    required this.onPurchase,
  });

  final ProductDetails product;
  final bool isPurchasing;
  final VoidCallback onPurchase;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tier = IapProductIds.tierForProductId(product.id);

    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceS),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title, style: Theme.of(context).textTheme.bodyMedium),
                Text(
                  product.price,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: tier.color,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: isPurchasing ? null : onPurchase,
            child: Text(l10n.subscription_purchase_button),
          ),
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
  const _TierBadge({required this.tier});

  final SubscriptionTier tier;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: tier.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: tier.color.withValues(alpha: 0.4)),
      ),
      child: Text(
        tier.displayName,
        style: TextStyle(
          fontSize: 11,
          color: tier.color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
