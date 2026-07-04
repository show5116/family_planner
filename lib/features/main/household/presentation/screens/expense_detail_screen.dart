import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/main/household/data/models/expense_model.dart';
import 'package:family_planner/features/main/household/presentation/widgets/expense_list_item.dart';
import 'package:family_planner/features/main/household/providers/household_provider.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/core/mixins/interstitial_ad_mixin.dart';

class ExpenseDetailScreen extends ConsumerStatefulWidget {
  final ExpenseModel expense;
  final String? groupId;

  const ExpenseDetailScreen({
    super.key,
    required this.expense,
    this.groupId,
  });

  @override
  ConsumerState<ExpenseDetailScreen> createState() => _ExpenseDetailScreenState();
}

class _ExpenseDetailScreenState extends ConsumerState<ExpenseDetailScreen>
    with InterstitialAdMixin {
  late ExpenseModel _expense;

  @override
  void initState() {
    super.initState();
    _expense = widget.expense;
  }

  String _fmt(double amount) => NumberFormat('#,###').format(amount.toInt());

  Future<void> _onDelete() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.common_delete),
        content: Text(l10n.household_delete_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              l10n.common_delete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final success = await ref
        .read(householdManagementProvider.notifier)
        .deleteExpense(_expense.id);

    if (!mounted) return;
    if (success) {
      showInterstitialThenNavigate(() {
        if (mounted) Navigator.of(context).pop();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.common_error)),
      );
    }
  }

  Future<void> _onEdit() async {
    final result = await context.push<ExpenseModel>(
      AppRoutes.householdEdit,
      extra: {'expense': _expense, 'groupId': widget.groupId},
    );
    if (result != null && mounted) {
      setState(() => _expense = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final e = _expense;
    final isIncome = e.type == TransactionType.income;

    final color = isIncome
        ? incomeCategoryColor(e.incomeCategory)
        : categoryColor(e.category);
    final icon = isIncome
        ? incomeCategoryIcon(e.incomeCategory)
        : categoryIcon(e.category);
    final label = isIncome
        ? incomeCategoryName(l10n, e.incomeCategory)
        : categoryName(l10n, e.category);
    final amountColor = isIncome ? Colors.green : colorScheme.error;
    final amountPrefix = isIncome ? '+₩' : '₩';

    final groupsAsync = ref.watch(myGroupsProvider);
    final effectiveGroupId = widget.groupId ?? e.groupId;
    final groupName = groupsAsync.whenOrNull(
      data: (groups) => groups
          .where((g) => g.id == effectiveGroupId)
          .map((g) => g.name)
          .firstOrNull,
    );

    // Key-Value 리스트에 표시할 항목 구성
    // (피드백 2) description은 사용자가 직접 입력한 경우에만 표시
    final hasDescription = e.description?.isNotEmpty == true;
    final hasMerchant = !isIncome && e.merchant != null;
    final hasMember = effectiveGroupId != null && e.memberId != null;
    final nonNullGroupId = effectiveGroupId ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isIncome ? l10n.household_income : l10n.household_expense),
            if (groupName != null)
              Text(
                groupName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
              ),
          ],
        ),
        actions: [
          if (!isIncome && e.refunds.isEmpty && e.refundedExpenseId == null)
            IconButton(
              icon: const Icon(Icons.undo),
              tooltip: l10n.household_refund,
              onPressed: () => context.push(
                AppRoutes.householdAdd,
                extra: {
                  'groupId': e.groupId ?? widget.groupId,
                  'refundedExpense': e,
                },
              ),
            ),
          if (e.shoppingHistoryId != null)
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              tooltip: l10n.household_view_shopping_history,
              onPressed: () {
                final path = AppRoutes.shoppingHistoryDetail
                    .replaceFirst(':historyId', e.shoppingHistoryId!);
                final query = e.groupId != null ? '?groupId=${e.groupId}' : '';
                context.push('$path$query');
              },
            ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: l10n.common_edit,
            onPressed: _onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: l10n.common_delete,
            onPressed: _onDelete,
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          children: [
            // ── 히어로 카드: 아이콘 + 타이틀 + 금액 ──
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                side: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceM,
                  vertical: AppSizes.spaceM,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                      ),
                      child: Icon(icon, color: color, size: 24),
                    ),
                    const SizedBox(width: AppSizes.spaceM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 타이틀: description이 있으면 표시, 없으면 카테고리명
                          Text(
                            hasDescription ? e.description! : label,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                label,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: color,
                                    ),
                              ),
                              if (!isIncome && e.paymentMethod != null) ...[
                                Text(' · ', style: Theme.of(context).textTheme.bodySmall),
                                Text(
                                  paymentMethodName(l10n, e.paymentMethod),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                              if (!isIncome && e.recurringExpenseId != null) ...[
                                const SizedBox(width: AppSizes.spaceXS),
                                Icon(Icons.repeat, size: 12, color: colorScheme.secondary),
                              ],
                              if (!e.isConfirmed) ...[
                                const SizedBox(width: 4),
                                _Badge(
                                  label: l10n.household_unconfirmed_badge,
                                  color: colorScheme.tertiaryContainer,
                                  textColor: colorScheme.onTertiaryContainer,
                                ),
                              ],
                              // (피드백 2) 환불됨 배지는 상단 카드에만, 중복 표시 없음
                              if (!isIncome && e.refunds.isNotEmpty) ...[
                                const SizedBox(width: 4),
                                _Badge(
                                  label: l10n.household_refund_badge,
                                  color: colorScheme.outline.withValues(alpha: 0.15),
                                  textColor: colorScheme.outline,
                                ),
                              ],
                              if (isIncome && e.refundedExpenseId != null) ...[
                                const SizedBox(width: 4),
                                _Badge(
                                  label: l10n.household_refund_origin_badge,
                                  color: Colors.teal.withValues(alpha: 0.12),
                                  textColor: Colors.teal,
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSizes.spaceS),
                    Text(
                      '$amountPrefix${_fmt(e.amount)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: e.refunds.isNotEmpty ? colorScheme.outline : amountColor,
                            decoration: e.refunds.isNotEmpty
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSizes.spaceM),

            // ── (피드백 1, 3) Key-Value 카드: 날짜 + 메모 + 소비처 + 멤버를 하나의 카드에 묶음 ──
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                side: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
              ),
              child: Column(
                children: [
                  _KvRow(
                    label: l10n.household_date,
                    value:
                        '${e.date.year}.${e.date.month.toString().padLeft(2, '0')}.${e.date.day.toString().padLeft(2, '0')} (${_weekdayLabel(e.date)})',
                  ),
                  // (피드백 2) 사용자가 직접 입력한 메모가 있을 때만 표시
                  if (hasDescription) ...[
                    const Divider(height: 1, indent: AppSizes.spaceM),
                    _KvRow(
                      label: l10n.household_description,
                      value: e.description!,
                    ),
                  ],
                  if (hasMerchant) ...[
                    const Divider(height: 1, indent: AppSizes.spaceM),
                    _KvRow(
                      label: l10n.household_merchant_select,
                      value: e.merchant!.name,
                    ),
                  ],
                  if (hasMember) ...[
                    const Divider(height: 1, indent: AppSizes.spaceM),
                    _MemberKvRow(
                      groupId: nonNullGroupId,
                      memberId: e.memberId!,
                      label: isIncome ? '받은 사람' : '결제한 사람',
                    ),
                  ],
                ],
              ),
            ),

            // ── (피드백 3) 환불 목록: 별도 독립 카드 불필요 → KV 카드 형태로 ──
            if (!isIncome && e.refunds.isNotEmpty) ...[
              const SizedBox(height: AppSizes.spaceM),
              Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  side: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
                ),
                child: Column(
                  children: e.refunds.asMap().entries.map((entry) {
                    final i = entry.key;
                    final refund = entry.value;
                    return Column(
                      children: [
                        if (i > 0) const Divider(height: 1, indent: AppSizes.spaceM),
                        _RefundRow(refund: refund, fmt: _fmt, l10n: l10n),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],

            // ── (피드백 3, 4) 원본 지출: 독립 카드로 강조, chevron 우측 끝 고정 ──
            if (isIncome && e.refundedExpenseId != null) ...[
              const SizedBox(height: AppSizes.spaceM),
              _RefundOriginCard(expense: e),
            ],

            const SizedBox(height: AppSizes.spaceXL),
          ],
        ),
      ),
    );
  }

  String _weekdayLabel(DateTime date) {
    const days = ['월', '화', '수', '목', '금', '토', '일'];
    return days[date.weekday - 1];
  }
}

// ── 배지 ──────────────────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  const _Badge({required this.label, required this.color, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: textColor,
              fontSize: 10,
            ),
      ),
    );
  }
}

// ── (피드백 1) Key-Value 행: 라벨 좌측, 값 우측 정렬 ─────────────────────────

class _KvRow extends StatelessWidget {
  final String label;
  final String value;

  const _KvRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceM - 2,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(width: AppSizes.spaceM),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

// ── 멤버 KV 행 (아바타 포함) ──────────────────────────────────────────────────

class _MemberKvRow extends ConsumerWidget {
  final String groupId;
  final String memberId;
  final String label;

  const _MemberKvRow({
    required this.groupId,
    required this.memberId,
    required this.label,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return ref.watch(groupMembersProvider(groupId)).when(
          data: (members) {
            final member = members.where((m) => m.user?.id == memberId).firstOrNull;
            if (member == null) return const SizedBox.shrink();
            final name = member.user?.name ?? '';
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceM,
                vertical: AppSizes.spaceS,
              ),
              child: Row(
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const Spacer(),
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: colorScheme.primaryContainer,
                    child: Text(
                      name.isNotEmpty ? name[0] : '?',
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.spaceXS),
                  Text(
                    name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
        );
  }
}

// ── 환불 항목 행 (카드 내부) ──────────────────────────────────────────────────

class _RefundRow extends StatelessWidget {
  final ExpenseModel refund;
  final String Function(double) fmt;
  final AppLocalizations l10n;

  const _RefundRow({
    required this.refund,
    required this.fmt,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final date = '${refund.date.month}/${refund.date.day}';
    final title = refund.description?.isNotEmpty == true
        ? refund.description!
        : l10n.household_refund_origin_badge;

    return InkWell(
      onTap: () => context.push(AppRoutes.householdDetail, extra: refund),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceM,
          vertical: AppSizes.spaceM - 2,
        ),
        child: Row(
          children: [
            Text(
              l10n.household_refund_total,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(width: AppSizes.spaceM),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                textAlign: TextAlign.end,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSizes.spaceXS),
            Text(
              '$date  +₩${fmt(refund.amount)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.teal,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            // (피드백 4) chevron은 항상 우측 끝
            const SizedBox(width: AppSizes.spaceXS),
            Icon(Icons.chevron_right, size: 16, color: colorScheme.outline),
          ],
        ),
      ),
    );
  }
}

// ── (피드백 3, 4) 원본 지출 독립 카드 ────────────────────────────────────────

class _RefundOriginCard extends ConsumerWidget {
  final ExpenseModel expense;

  const _RefundOriginCard({required this.expense});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return ref.watch(expenseByIdProvider(expense.refundedExpenseId!)).when(
          data: (origin) {
            final catLabel = categoryName(l10n, origin.category);
            final title = origin.description?.isNotEmpty == true
                ? origin.description!
                : catLabel;
            final color = categoryColor(origin.category);
            final icon = categoryIcon(origin.category);
            final fmtAmt = NumberFormat('#,###').format(origin.amount.toInt());
            final dateStr =
                '${origin.date.year}.${origin.date.month.toString().padLeft(2, '0')}.${origin.date.day.toString().padLeft(2, '0')}';

            return Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                side: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
              ),
              child: InkWell(
                onTap: () => context.push(AppRoutes.householdDetail, extra: origin),
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spaceM,
                    vertical: AppSizes.spaceM,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                        ),
                        child: Icon(icon, color: color, size: 20),
                      ),
                      const SizedBox(width: AppSizes.spaceM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$dateStr · $catLabel',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: colorScheme.outline,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      // (피드백 4) 금액과 chevron 사이 Spacer 없이, Row 끝에 고정
                      Text(
                        '₩$fmtAmt',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.error,
                              decoration: TextDecoration.lineThrough,
                            ),
                      ),
                      const SizedBox(width: AppSizes.spaceXS),
                      Icon(Icons.chevron_right, size: 18, color: colorScheme.outline),
                    ],
                  ),
                ),
              ),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
        );
  }
}
