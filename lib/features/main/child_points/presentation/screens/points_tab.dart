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
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.tertiaryContainer,
      child: ListTile(
        leading: Icon(Icons.savings_outlined,
            color: colorScheme.onTertiaryContainer),
        title: Text('적금 플랜 시작하기',
            style: TextStyle(
                color: colorScheme.onTertiaryContainer,
                fontWeight: FontWeight.w600)),
        subtitle: Text('매월 자동으로 적금이 납입돼요',
            style: TextStyle(color: colorScheme.onTertiaryContainer)),
        trailing:
            Icon(Icons.chevron_right, color: colorScheme.onTertiaryContainer),
        onTap: () => _showCreatePlanDialog(context, ref),
      ),
    );
  }

  Future<void> _showCreatePlanDialog(
      BuildContext context, WidgetRef ref) async {
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
    final colorScheme = Theme.of(context).colorScheme;
    final fmt = DateFormat('yyyy.MM.dd');
    final interestLabel =
        plan.interestType == SavingsInterestType.simple ? '단리' : '복리';
    final statusColor =
        matured ? colorScheme.secondary : colorScheme.tertiary;
    final statusLabel = matured ? '만기 완료' : '진행 중';

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
                Text('적금 플랜',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spaceS, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(statusLabel,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: statusColor, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceS),
            const Divider(height: 1),
            const SizedBox(height: AppSizes.spaceS),
            _InfoRow(label: '월 납입액', value: '${plan.monthlyAmount}P'),
            _InfoRow(
                label: '이자율',
                value: '${plan.interestRate}% ($interestLabel)'),
            _InfoRow(
                label: '기간',
                value:
                    '${fmt.format(plan.startDate)} ~ ${fmt.format(plan.endDate)}'),
            _InfoRow(
                label: '적금 잔액',
                value: '${account.savingsBalance.toInt()}P'),
            if (!matured) ...[
              const SizedBox(height: AppSizes.spaceM),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _confirmCancel(context, ref),
                  icon: const Icon(Icons.cancel_outlined,
                      size: AppSizes.iconSmall),
                  label: const Text('중도 해지'),
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('적금 중도 해지'),
        content: const Text('중도 해지 시 이자 없이 원금만 반환됩니다.\n정말 해지하시겠습니까?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('취소')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style:
                TextButton.styleFrom(foregroundColor: Theme.of(ctx).colorScheme.error),
            child: const Text('해지'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final ok = await ref
        .read(childcareManagementProvider.notifier)
        .cancelSavingsPlan(account.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ok ? '적금이 해지되었습니다' : '해지 중 오류가 발생했습니다')));
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
          Text(label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const Spacer(),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
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
  DateTime _endDate =
      DateTime(DateTime.now().year + 1, DateTime.now().month, DateTime.now().day);
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

    final months = (_endDate.year - _startDate.year) * 12 +
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
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('적금 플랜이 시작되었습니다')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('yyyy-MM-dd');
    final colorScheme = Theme.of(context).colorScheme;
    final preview = _preview;

    return AlertDialog(
      title: const Text('적금 플랜 만들기'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _monthlyCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: '월 납입 포인트', suffixText: 'P'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSizes.spaceS),
            TextField(
              controller: _rateCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: '연 이자율',
                suffixText: '%',
                helperText: _kr3yRate != null
                    ? '현재 국고채 3년물 금리(${_kr3yRate!.toStringAsFixed(1)}%)를 참고하여 기본값이 설정됩니다'
                    : '국고채 3년물 금리를 불러오는 중...',
                helperMaxLines: 2,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSizes.spaceS),
            Text('이자 유형', style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 4),
            SegmentedButton<SavingsInterestType>(
              segments: const [
                ButtonSegment(
                    value: SavingsInterestType.simple, label: Text('단리')),
                ButtonSegment(
                    value: SavingsInterestType.compound, label: Text('복리')),
              ],
              selected: {_interestType},
              onSelectionChanged: (s) =>
                  setState(() => _interestType = s.first),
            ),
            const SizedBox(height: AppSizes.spaceS),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('시작일'),
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
              title: const Text('만기일'),
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
                    _InfoRow(label: '총 납입', value: '${preview.totalDeposit}P'),
                    _InfoRow(label: '예상 이자', value: '${preview.interest}P'),
                    _InfoRow(label: '만기 수령', value: '${preview.total}P'),
                    _InfoRow(label: '기간', value: '${preview.months}개월'),
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
            child: const Text('취소')),
        FilledButton(
          onPressed: _submitting ? null : _handleCreate,
          child: _submitting
              ? const SizedBox(
                  height: 16, width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('시작'),
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
