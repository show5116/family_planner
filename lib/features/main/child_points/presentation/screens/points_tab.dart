import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
  const PointsTab({
    super.key,
    required this.selectedChildId,
    this.demoAccount,
    this.demoPlan,
    this.demoSavingsPlan,
    this.demoAccountCardKey,
    this.demoSavingsPlanKey,
  });

  final String? selectedChildId;
  final ChildcareAccount? demoAccount;
  final AllowancePlan? demoPlan;
  final ChildcareSavingsPlan? demoSavingsPlan;
  final GlobalKey? demoAccountCardKey;
  final GlobalKey? demoSavingsPlanKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    // 데모 모드: 샘플 데이터 직접 렌더링
    if (demoAccount != null) {
      return SingleChildScrollView(
        padding: EdgeInsets.only(
          left: AppSizes.spaceM,
          right: AppSizes.spaceM,
          top: AppSizes.spaceM,
          bottom: AppSizes.spaceM + MediaQuery.paddingOf(context).bottom,
        ),
        child: Column(
          children: [
            AccountSummaryCard(
              key: demoAccountCardKey,
              account: demoAccount!,
              plan: demoPlan,
            ),
            const SizedBox(height: AppSizes.spaceM),
            if (demoSavingsPlan != null)
              _DemoSavingsPlanCard(
                key: demoSavingsPlanKey,
                plan: demoSavingsPlan!,
                account: demoAccount!,
              ),
          ],
        ),
      );
    }

    final account = ref.watch(selectedChildAccountProvider);
    final accountsAsync = ref.watch(childcareAccountsProvider);
    final planAsync = ref.watch(childcareAllowancePlanProvider);

    if (selectedChildId == null) {
      final childrenAsync = ref.watch(childcareChildrenProvider);
      return childrenAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.childcare_no_child)),
        data: (_) => Center(child: Text(l10n.childcare_no_child)),
      );
    }

    return accountsAsync.when(
      data: (_) {
        if (account == null) {
          return AppEmptyState(
            icon: Icons.child_care,
            message: l10n.childcare_empty_accounts,
          );
        }

        final plan = planAsync.maybeWhen(data: (p) => p, orElse: () => null);

        return RefreshIndicator(
          onRefresh: () =>
              ref.read(childcareAccountsProvider.notifier).refresh(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(
              left: AppSizes.spaceM,
              right: AppSizes.spaceM,
              top: AppSizes.spaceM,
              bottom: AppSizes.spaceM + MediaQuery.paddingOf(context).bottom,
            ),
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
                ),
                const SizedBox(height: AppSizes.spaceM),
                _SavingsPlanSection(account: account),
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
              child: Text(l10n.common_retry),
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
    await showDialog<void>(
      context: context,
      builder: (ctx) => _CashoutDialog(account: account, plan: plan, ref: ref),
    );
  }
}

// ── 데모용 적금 플랜 카드 ──────────────────────────────────────────────────────

class _DemoSavingsPlanCard extends StatelessWidget {
  const _DemoSavingsPlanCard({
    super.key,
    required this.plan,
    required this.account,
  });

  final ChildcareSavingsPlan plan;
  final ChildcareAccount account;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final fmt = DateFormat('yyyy.MM.dd');
    final interestLabel = plan.interestType == SavingsInterestType.simple
        ? l10n.childcare_interest_simple
        : l10n.childcare_interest_compound;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.savings_rounded,
                  color: colorScheme.tertiary,
                  size: 20,
                ),
                const SizedBox(width: AppSizes.spaceS),
                Text(
                  l10n.childcare_savings_plan,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spaceS,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.tertiary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    l10n.childcare_savings_ongoing,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colorScheme.tertiary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceS),
            const Divider(height: 1),
            const SizedBox(height: AppSizes.spaceS),
            _InfoRow(label: l10n.childcare_monthly_deposit, value: '${plan.monthlyAmount}P'),
            _InfoRow(
              label: l10n.childcare_interest_rate,
              value: '${plan.interestRate}% ($interestLabel)',
            ),
            _InfoRow(
              label: l10n.childcare_period,
              value:
                  '${fmt.format(plan.startDate)} ~ ${fmt.format(plan.endDate)}',
            ),
            _InfoRow(
              label: l10n.childcare_savings_balance,
              value: '${account.savingsBalance.toInt()}P',
            ),
          ],
        ),
      ),
    );
  }
}

// ── 적금 플랜 섹션 ────────────────────────────────────────────────────────────

class _SavingsPlanSection extends ConsumerWidget {
  const _SavingsPlanSection({required this.account});

  final ChildcareAccount account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(childcareSavingsPlanProvider(account.id));

    return planAsync.when(
      data: (plan) {
        if (plan == null || plan.status == SavingsPlanStatus.cancelled) {
          return _SavingsStartBanner(account: account);
        }
        if (plan.status == SavingsPlanStatus.matured) {
          return _SavingsPlanCard(account: account, plan: plan, matured: true);
        }
        return _SavingsPlanCard(account: account, plan: plan, matured: false);
      },
      loading: () => const SizedBox.shrink(),
      error: (e, _) => _SavingsStartBanner(account: account),
    );
  }
}

/// 적금 플랜 미설정 시 배너
class _SavingsStartBanner extends ConsumerWidget {
  const _SavingsStartBanner({required this.account});

  final ChildcareAccount account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.tertiaryContainer,
      child: ListTile(
        leading: Icon(
          Icons.savings_outlined,
          color: colorScheme.onTertiaryContainer,
        ),
        title: Text(
          l10n.childcare_savings_start,
          style: TextStyle(
            color: colorScheme.onTertiaryContainer,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          l10n.childcare_savings_start_desc,
          style: TextStyle(color: colorScheme.onTertiaryContainer),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: colorScheme.onTertiaryContainer,
        ),
        onTap: () => _showCreatePlanDialog(context, ref),
      ),
    );
  }

  Future<void> _showCreatePlanDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => _SavingsPlanFormDialog(account: account, ref: ref),
    );
  }
}

/// 적금 플랜 현황 카드
class _SavingsPlanCard extends ConsumerWidget {
  const _SavingsPlanCard({
    required this.account,
    required this.plan,
    required this.matured,
  });

  final ChildcareAccount account;
  final ChildcareSavingsPlan plan;
  final bool matured;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final fmt = DateFormat('yyyy.MM.dd');
    final interestLabel = plan.interestType == SavingsInterestType.simple
        ? l10n.childcare_interest_simple
        : l10n.childcare_interest_compound;
    final statusColor = matured ? colorScheme.secondary : colorScheme.tertiary;
    final statusLabel = matured
        ? l10n.childcare_savings_matured
        : l10n.childcare_savings_ongoing;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.savings_rounded, color: statusColor, size: 20),
                const SizedBox(width: AppSizes.spaceS),
                Text(
                  l10n.childcare_savings_plan,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spaceS,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    statusLabel,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceS),
            const Divider(height: 1),
            const SizedBox(height: AppSizes.spaceS),
            _InfoRow(label: l10n.childcare_monthly_deposit, value: '${plan.monthlyAmount}P'),
            _InfoRow(
              label: l10n.childcare_interest_rate,
              value: '${plan.interestRate}% ($interestLabel)',
            ),
            _InfoRow(
              label: l10n.childcare_period,
              value:
                  '${fmt.format(plan.startDate)} ~ ${fmt.format(plan.endDate)}',
            ),
            _InfoRow(
              label: l10n.childcare_savings_balance,
              value: '${account.savingsBalance.toInt()}P',
            ),
            if (!matured) ...[
              const SizedBox(height: AppSizes.spaceM),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _confirmCancel(context, ref),
                  icon: const Icon(
                    Icons.cancel_outlined,
                    size: AppSizes.iconSmall,
                  ),
                  label: Text(l10n.childcare_savings_cancel),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.error,
                    side: BorderSide(color: colorScheme.error),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _confirmCancel(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.childcare_savings_cancel_title),
        content: Text(l10n.childcare_savings_cancel_message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: Text(l10n.childcare_savings_cancel_confirm),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final ok = await ref
        .read(childcareManagementProvider.notifier)
        .cancelSavingsPlan(account.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok
            ? l10n.childcare_savings_canceled
            : l10n.childcare_savings_cancel_failed),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// ── 적금 플랜 생성 다이얼로그 ─────────────────────────────────────────────────

class _SavingsPlanFormDialog extends StatefulWidget {
  const _SavingsPlanFormDialog({required this.account, required this.ref});

  final ChildcareAccount account;
  final WidgetRef ref;

  @override
  State<_SavingsPlanFormDialog> createState() => _SavingsPlanFormDialogState();
}

class _SavingsPlanFormDialogState extends State<_SavingsPlanFormDialog> {
  final _monthlyCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();
  SavingsInterestType _interestType = SavingsInterestType.simple;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime(
    DateTime.now().year + 1,
    DateTime.now().month,
    DateTime.now().day,
  );
  double? _kr3yRate;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _loadKr3yRate();
  }

  Future<void> _loadKr3yRate() async {
    try {
      final repo = widget.ref.read(childcareRepositoryProvider);
      final rawRate = await repo.getKr3yRate(widget.account.id);
      if (!mounted) return;
      if (rawRate != null && rawRate > 0) {
        // 소수점 첫째 자리까지만 (예: 3.57 → 3.6)
        final rate = double.parse(rawRate.toStringAsFixed(1));
        setState(() {
          _kr3yRate = rate;
          _rateCtrl.text = rate.toStringAsFixed(1);
        });
      } else {
        setState(() => _rateCtrl.text = '3.0');
      }
    } catch (e) {
      debugPrint('⚠️ [SavingsPlan] 국고채 금리 조회 실패: $e');
      if (mounted) setState(() => _rateCtrl.text = '3.0');
    }
  }

  @override
  void dispose() {
    _monthlyCtrl.dispose();
    _rateCtrl.dispose();
    super.dispose();
  }

  /// 단리/복리 예상 이자 UI 직접 계산
  ({int totalDeposit, int interest, int total, int months})? get _preview {
    final monthly = int.tryParse(_monthlyCtrl.text.trim()) ?? 0;
    final rate = double.tryParse(_rateCtrl.text.trim()) ?? 0;
    if (monthly <= 0 || rate <= 0) return null;
    if (!_endDate.isAfter(_startDate)) return null;

    final months =
        (_endDate.year - _startDate.year) * 12 +
        (_endDate.month - _startDate.month);
    if (months <= 0) return null;

    final totalDeposit = monthly * months;
    final annualRate = rate / 100;

    final int interest;
    if (_interestType == SavingsInterestType.simple) {
      // 단리: i번째 납입은 (months - i + 1)개월치 이자 (납입 당월 포함)
      // 이자 = monthly × (months - i + 1) / 12 × annualRate
      double acc = 0;
      for (int i = 1; i <= months; i++) {
        acc += monthly * (months - i + 1) / 12 * annualRate;
      }
      interest = acc.round();
    } else {
      // 복리: i번째 납입은 (months - i + 1)개월 복리 운용 (납입 당월 포함)
      // 만기금액 = Σ monthly × (1 + annualRate/12)^(months - i + 1)
      final monthlyRate = annualRate / 12;
      double maturity = 0;
      for (int i = 1; i <= months; i++) {
        maturity += monthly * pow(1 + monthlyRate, months - i + 1);
      }
      interest = (maturity - totalDeposit).round();
    }

    return (
      totalDeposit: totalDeposit,
      interest: interest.clamp(0, 999999),
      total: totalDeposit + interest.clamp(0, 999999),
      months: months,
    );
  }

  CreateSavingsPlanDto get _dto => CreateSavingsPlanDto(
    monthlyAmount: int.tryParse(_monthlyCtrl.text.trim()) ?? 0,
    interestRate: double.tryParse(_rateCtrl.text.trim()) ?? 0,
    interestType: _interestType,
    startDate: DateFormat('yyyy-MM-dd').format(_startDate),
    endDate: DateFormat('yyyy-MM-dd').format(_endDate),
  );

  Future<void> _handleCreate() async {
    final l10n = AppLocalizations.of(context)!;
    final monthly = int.tryParse(_monthlyCtrl.text.trim()) ?? 0;
    final rate = double.tryParse(_rateCtrl.text.trim()) ?? 0;
    if (monthly <= 0 || rate <= 0) return;
    if (_endDate.isBefore(_startDate)) return;

    setState(() => _submitting = true);
    final plan = await widget.ref
        .read(childcareManagementProvider.notifier)
        .createSavingsPlan(widget.account.id, _dto);
    if (!mounted) return;
    setState(() => _submitting = false);
    if (plan != null) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.childcare_savings_started)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fmt = DateFormat('yyyy-MM-dd');
    final colorScheme = Theme.of(context).colorScheme;
    final preview = _preview;

    return AlertDialog(
      title: Text(l10n.childcare_savings_create_title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _monthlyCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.childcare_savings_monthly_points,
                suffixText: 'P',
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSizes.spaceS),
            TextField(
              controller: _rateCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: l10n.childcare_savings_annual_rate,
                suffixText: '%',
                helperText: _kr3yRate != null
                    ? l10n.childcare_savings_rate_helper(
                        _kr3yRate!.toStringAsFixed(1))
                    : l10n.childcare_savings_rate_loading,
                helperMaxLines: 2,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSizes.spaceS),
            Text(l10n.childcare_interest_type,
                style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 4),
            SegmentedButton<SavingsInterestType>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: SavingsInterestType.simple,
                  label: Text(l10n.childcare_interest_simple),
                ),
                ButtonSegment(
                  value: SavingsInterestType.compound,
                  label: Text(l10n.childcare_interest_compound),
                ),
              ],
              selected: {_interestType},
              onSelectionChanged: (s) =>
                  setState(() => _interestType = s.first),
            ),
            const SizedBox(height: AppSizes.spaceS),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.childcare_start_date),
              subtitle: Text(fmt.format(_startDate)),
              trailing: const Icon(Icons.calendar_today, size: 18),
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: _startDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (d != null) setState(() => _startDate = d);
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.childcare_maturity_date),
              subtitle: Text(fmt.format(_endDate)),
              trailing: const Icon(Icons.calendar_today, size: 18),
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: _endDate,
                  firstDate: _startDate.add(const Duration(days: 30)),
                  lastDate: DateTime(2100),
                );
                if (d != null) setState(() => _endDate = d);
              },
            ),
            if (preview != null) ...[
              const SizedBox(height: AppSizes.spaceS),
              Container(
                padding: const EdgeInsets.all(AppSizes.spaceS),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _InfoRow(label: l10n.childcare_total_deposit, value: '${preview.totalDeposit}P'),
                    _InfoRow(label: l10n.childcare_expected_interest, value: '${preview.interest}P'),
                    _InfoRow(label: l10n.childcare_maturity_amount, value: '${preview.total}P'),
                    _InfoRow(
                        label: l10n.childcare_period,
                        value: l10n.childcare_months(preview.months)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.common_cancel),
        ),
        FilledButton(
          onPressed: _submitting ? null : _handleCreate,
          child: _submitting
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.childcare_start),
        ),
      ],
    );
  }
}

/// 용돈 플랜 미설정 시 안내 배너
class AllowancePlanBanner extends StatelessWidget {
  const AllowancePlanBanner({super.key, required this.childId});

  final String childId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: ListTile(
        leading: const Icon(Icons.monetization_on_outlined),
        title: Text(l10n.childcare_allowance_missing),
        subtitle: Text(l10n.childcare_allowance_missing_desc),
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
    final l10n = AppLocalizations.of(context)!;
    final today = DateTime.now();
    final diff = negotiationDate
        .difference(DateTime(today.year, today.month, today.day))
        .inDays;

    final bool isOverdue = diff < 0;
    final bool isUpcoming = diff >= 0 && diff <= 7;

    if (!isOverdue && !isUpcoming) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final color = isOverdue
        ? colorScheme.errorContainer
        : colorScheme.tertiaryContainer;
    final onColor = isOverdue
        ? colorScheme.onErrorContainer
        : colorScheme.onTertiaryContainer;

    final String title = isOverdue
        ? l10n.childcare_negotiation_passed
        : l10n.childcare_negotiation_upcoming;
    final String subtitle = isOverdue
        ? l10n.childcare_negotiation_passed_desc(-diff, _fmt(negotiationDate))
        : diff == 0
        ? l10n.childcare_negotiation_today(_fmt(negotiationDate))
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
        title: Text(
          title,
          style: TextStyle(color: onColor, fontWeight: FontWeight.w600),
        ),
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

// ── 현금화 다이얼로그 ─────────────────────────────────────────────────────────

class _CashoutDialog extends StatefulWidget {
  const _CashoutDialog({
    required this.account,
    required this.plan,
    required this.ref,
  });

  final ChildcareAccount account;
  final AllowancePlan plan;
  final WidgetRef ref;

  @override
  State<_CashoutDialog> createState() => _CashoutDialogState();
}

class _CashoutDialogState extends State<_CashoutDialog> {
  final _controller = TextEditingController();
  bool _isSaving = false;
  String? _errorMsg;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final l10n = AppLocalizations.of(context)!;
    final points = double.tryParse(_controller.text);
    if (points == null || points <= 0) return;

    setState(() {
      _isSaving = true;
      _errorMsg = null;
    });

    final ratio = widget.plan.pointToMoneyRatio;
    final result = await widget.ref
        .read(childcareManagementProvider.notifier)
        .addTransaction(
          widget.account.id,
          CreateTransactionDto.direct(
            type: ChildcareTransactionType.cashout,
            amount: points,
            description: l10n.childcare_cashout_description(
                '${points.toInt() * ratio}'),
          ),
        );

    if (!mounted) return;

    if (result == null) {
      setState(() {
        _isSaving = false;
        _errorMsg = l10n.childcare_cashout_failed;
      });
      return;
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.childcare_cashout_done(
            '${points.toInt()}',
            '${points.toInt() * widget.plan.pointToMoneyRatio}',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ratio = widget.plan.pointToMoneyRatio;
    final points = int.tryParse(_controller.text) ?? 0;
    final money = points * ratio;

    return AlertDialog(
      title: Text(l10n.childcare_cashout),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.childcare_cashout_rate(
                '$ratio', '${widget.account.balance.toInt()}'),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: InputDecoration(
              labelText: l10n.childcare_cashout_points,
              suffixText: 'P',
            ),
            onChanged: (_) => setState(() {}),
          ),
          if (money > 0) ...[
            const SizedBox(height: 8),
            Text(
              l10n.childcare_cashout_approx('$money'),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          if (_errorMsg != null) ...[
            const SizedBox(height: AppSizes.spaceS),
            Text(
              _errorMsg!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: Text(l10n.common_cancel),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _handleSubmit,
          child: Text(l10n.childcare_cashout_button),
        ),
      ],
    );
  }
}
