import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/main/child_points/data/models/childcare_model.dart';
import 'package:family_planner/features/main/child_points/data/repositories/childcare_repository.dart';
import 'package:family_planner/features/main/child_points/presentation/widgets/account_summary_card.dart';
import 'package:family_planner/features/main/child_points/providers/childcare_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/app_empty_state.dart';

/// 포인트 탭 — 잔액 요약, 용돈 플랜 배너, 협상일 배너
class PointsTab extends ConsumerWidget {
  const PointsTab({super.key, required this.selectedChildId});

  final String? selectedChildId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final account = ref.watch(selectedChildAccountProvider);
    final accountsAsync = ref.watch(childcareAccountsProvider);
    final planAsync = ref.watch(childcareAllowancePlanProvider);

    if (selectedChildId == null) {
      return Center(child: Text(l10n.childcare_no_child));
    }

    return accountsAsync.when(
      data: (_) {
        if (account == null) {
          return AppEmptyState(
            icon: Icons.child_care,
            message: l10n.childcare_empty_accounts,
          );
        }

        final plan = planAsync.maybeWhen(
          data: (p) => p,
          orElse: () => null,
        );

        return RefreshIndicator(
          onRefresh: () =>
              ref.read(childcareAccountsProvider.notifier).refresh(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSizes.spaceM),
            child: Column(
              children: [
                AccountSummaryCard(
                  account: account,
                  plan: plan,
                  onAddTransaction: () => context.push(
                    AppRoutes.childPointsTransactionAdd,
                    extra: {'accountId': account.id},
                  ),
                  onCashout: plan != null
                      ? () => _showCashoutDialog(context, ref, account, plan)
                      : null,
                  onDepositSavings: () => _showSavingsDialog(
                    context,
                    ref,
                    account,
                    isDeposit: true,
                  ),
                  onWithdrawSavings: () => _showSavingsDialog(
                    context,
                    ref,
                    account,
                    isDeposit: false,
                  ),
                ),
                if (plan == null) ...[
                  const SizedBox(height: AppSizes.spaceM),
                  AllowancePlanBanner(childId: selectedChildId!),
                ],
                if (plan != null && plan.nextNegotiationDate != null) ...[
                  const SizedBox(height: AppSizes.spaceM),
                  NegotiationDateBanner(
                    childId: selectedChildId!,
                    negotiationDate: plan.nextNegotiationDate!,
                  ),
                ],
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.childcare_empty_accounts),
            const SizedBox(height: AppSizes.spaceS),
            ElevatedButton(
              onPressed: () =>
                  ref.read(childcareAccountsProvider.notifier).refresh(),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCashoutDialog(
    BuildContext context,
    WidgetRef ref,
    ChildcareAccount account,
    AllowancePlan plan,
  ) async {
    final controller = TextEditingController();
    final ratio = plan.pointToMoneyRatio;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          final points = int.tryParse(controller.text) ?? 0;
          final money = points * ratio;
          return AlertDialog(
            title: const Text('포인트 현금화'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1P = $ratio원 · 보유 ${account.balance.toInt()}P',
                  style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                        color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: '현금화할 포인트',
                    suffixText: 'P',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                if (money > 0) ...[
                  const SizedBox(height: 8),
                  Text(
                    '≈ $money원',
                    style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                          color: Theme.of(ctx).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('취소'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('현금화'),
              ),
            ],
          );
        },
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final points = double.tryParse(controller.text);
    if (points == null || points <= 0) return;

    await ref.read(childcareManagementProvider.notifier).addTransaction(
          account.id,
          CreateTransactionDto.direct(
            type: ChildcareTransactionType.cashout,
            amount: points,
            description: '포인트 현금화 (${points.toInt() * ratio}원)',
          ),
        );

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${points.toInt()}P → ${points.toInt() * ratio}원 현금화되었습니다')),
    );
  }

  Future<void> _showSavingsDialog(
    BuildContext context,
    WidgetRef ref,
    ChildcareAccount account, {
    required bool isDeposit,
  }) async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isDeposit ? '적금 입금' : '적금 출금'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: '금액', suffixText: 'P'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(isDeposit ? '입금' : '출금'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final amount = double.tryParse(controller.text);
    if (amount == null || amount <= 0) return;

    final dto = SavingsAmountDto(amount: amount);
    final notifier = ref.read(childcareManagementProvider.notifier);

    final result = isDeposit
        ? await notifier.savingsDeposit(account.id, dto)
        : await notifier.savingsWithdraw(account.id, dto);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result != null ? '완료되었습니다' : '오류가 발생했습니다')),
    );
  }
}

/// 용돈 플랜 미설정 시 안내 배너
class AllowancePlanBanner extends StatelessWidget {
  const AllowancePlanBanner({super.key, required this.childId});

  final String childId;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: ListTile(
        leading: const Icon(Icons.monetization_on_outlined),
        title: const Text('용돈 플랜이 설정되지 않았습니다'),
        subtitle: const Text('월 포인트, 지급일 등을 설정해보세요'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push(
          AppRoutes.childPointsAllowancePlan,
          extra: {'childId': childId},
        ),
      ),
    );
  }
}

/// 연봉 협상일 알림 배너 (D-7 이내 또는 지난 경우)
class NegotiationDateBanner extends StatelessWidget {
  const NegotiationDateBanner({
    super.key,
    required this.childId,
    required this.negotiationDate,
  });

  final String childId;
  final DateTime negotiationDate;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final diff = negotiationDate
        .difference(DateTime(today.year, today.month, today.day))
        .inDays;

    final bool isOverdue = diff < 0;
    final bool isUpcoming = diff >= 0 && diff <= 7;

    if (!isOverdue && !isUpcoming) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final color =
        isOverdue ? colorScheme.errorContainer : colorScheme.tertiaryContainer;
    final onColor = isOverdue
        ? colorScheme.onErrorContainer
        : colorScheme.onTertiaryContainer;

    final String title =
        isOverdue ? '연봉 협상일이 지났습니다' : '연봉 협상일이 다가오고 있습니다';
    final String subtitle = isOverdue
        ? '${-diff}일 전 (${_fmt(negotiationDate)})이었습니다. 용돈 플랜을 검토해보세요'
        : diff == 0
            ? '오늘이 연봉 협상일입니다! (${_fmt(negotiationDate)})'
            : 'D-$diff · ${_fmt(negotiationDate)}';

    return Card(
      color: color,
      child: ListTile(
        leading: Icon(
          isOverdue
              ? Icons.warning_amber_rounded
              : Icons.notifications_active_outlined,
          color: onColor,
        ),
        title: Text(title,
            style: TextStyle(color: onColor, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: TextStyle(color: onColor)),
        trailing: Icon(Icons.chevron_right, color: onColor),
        onTap: () => context.push(
          AppRoutes.childPointsAllowancePlan,
          extra: {'childId': childId},
        ),
      ),
    );
  }

  String _fmt(DateTime d) =>
      '${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}';
}
