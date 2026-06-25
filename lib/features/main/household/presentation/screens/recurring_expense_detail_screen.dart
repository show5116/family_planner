import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/main/household/data/models/expense_model.dart';
import 'package:family_planner/features/main/household/data/models/recurring_expense_model.dart';
import 'package:family_planner/features/main/household/presentation/widgets/expense_list_item.dart';
import 'package:family_planner/features/main/household/providers/household_provider.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

class RecurringExpenseDetailScreen extends ConsumerWidget {
  final RecurringExpenseModel item;
  final String? groupId;

  const RecurringExpenseDetailScreen({
    super.key,
    required this.item,
    this.groupId,
  });

  String _fmt(double amount) => NumberFormat('#,###').format(amount.toInt());

  Future<void> _onDelete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.household_delete_expense),
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
    if (confirmed != true || !context.mounted) return;

    final success = await ref
        .read(householdManagementProvider.notifier)
        .deleteRecurringExpense(item.id);

    if (!context.mounted) return;
    if (success) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.common_error)),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isIncome = item.type == TransactionType.income;

    final color = isIncome
        ? incomeCategoryColor(item.incomeCategory)
        : categoryColor(item.category);
    final icon = isIncome
        ? incomeCategoryIcon(item.incomeCategory)
        : categoryIcon(item.category);
    final label = isIncome
        ? incomeCategoryName(l10n, item.incomeCategory)
        : categoryName(l10n, item.category);
    final amountColor = isIncome ? Colors.green : colorScheme.error;
    final amountPrefix = isIncome ? '+₩' : '₩';

    final groupsAsync = ref.watch(myGroupsProvider);
    final effectiveGroupId = groupId ?? item.groupId;
    final groupName = groupsAsync.whenOrNull(
      data: (groups) => groups
          .where((g) => g.id == effectiveGroupId)
          .map((g) => g.name)
          .firstOrNull,
    );

    final hasDescription = item.description?.isNotEmpty == true;
    final hasMember = effectiveGroupId != null && item.memberId != null;
    final nonNullGroupId = effectiveGroupId ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.household_recurring_title),
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
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: l10n.common_edit,
            onPressed: () => context.push(
              AppRoutes.householdRecurringEdit,
              extra: {'item': item, 'groupId': groupId},
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: l10n.common_delete,
            onPressed: () => _onDelete(context, ref),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          children: [
            // ── 히어로 카드 ──
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
                          Text(
                            hasDescription ? item.description! : label,
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
                              if (!isIncome && item.paymentMethod != null) ...[
                                Text(' · ', style: Theme.of(context).textTheme.bodySmall),
                                Text(
                                  paymentMethodName(l10n, item.paymentMethod),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                              const SizedBox(width: AppSizes.spaceXS),
                              Icon(Icons.repeat, size: 12, color: colorScheme.secondary),
                              if (item.isVariable) ...[
                                const SizedBox(width: 4),
                                _Badge(
                                  label: '가변',
                                  color: colorScheme.tertiaryContainer,
                                  textColor: colorScheme.onTertiaryContainer,
                                ),
                              ],
                              if (!item.isActive) ...[
                                const SizedBox(width: 4),
                                _Badge(
                                  label: l10n.household_recurring_inactive,
                                  color: colorScheme.outline.withValues(alpha: 0.15),
                                  textColor: colorScheme.outline,
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSizes.spaceS),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$amountPrefix${_fmt(item.amount)}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: amountColor,
                              ),
                        ),
                        if (item.isVariable)
                          Text(
                            '예상금액',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: colorScheme.outline,
                                ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSizes.spaceM),

            // ── Key-Value 정보 카드 ──
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                side: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
              ),
              child: Column(
                children: [
                  _KvRow(label: '발생일', value: '매월 ${item.dayOfMonth}일'),
                  if (hasDescription) ...[
                    const Divider(height: 1, indent: AppSizes.spaceM),
                    _KvRow(label: l10n.household_description, value: item.description!),
                  ],
                  if (hasMember) ...[
                    const Divider(height: 1, indent: AppSizes.spaceM),
                    _MemberKvRow(
                      groupId: nonNullGroupId,
                      memberId: item.memberId!,
                      label: isIncome ? '받는 사람' : '결제하는 사람',
                    ),
                  ],
                ],
              ),
            ),

            // ── 적용 내역 섹션 (모든 고정지출) ──
            const SizedBox(height: AppSizes.spaceM),
            _HistorySection(
              recurringId: item.id,
              isVariable: item.isVariable,
              fmt: _fmt,
            ),

            const SizedBox(height: AppSizes.spaceXL),
          ],
        ),
      ),
    );
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

// ── Key-Value 행 ──────────────────────────────────────────────────────────────

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

// ── 멤버 KV 행 ────────────────────────────────────────────────────────────────

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

// ── 적용 내역 섹션 ───────────────────────────────────────────────────────────

class _HistorySection extends ConsumerWidget {
  final String recurringId;
  final bool isVariable;
  final String Function(double) fmt;

  const _HistorySection({
    required this.recurringId,
    required this.isVariable,
    required this.fmt,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final historyAsync = ref.watch(recurringExpenseHistoryProvider(recurringId));

    return historyAsync.when(
      data: (data) {
        final history = data.history;

        if (history.isEmpty) {
          return Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              side: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.spaceM),
              child: Row(
                children: [
                  Icon(Icons.history, size: 18, color: colorScheme.outline),
                  const SizedBox(width: AppSizes.spaceS),
                  Text(
                    '아직 적용된 내역이 없습니다',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 가변 항목 전용 통계 카드
            if (isVariable && data.averageAmount != null) ...[
              Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  side: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
                ),
                child: Column(
                  children: [
                    _KvRow(label: '확정 평균', value: '₩${fmt(data.averageAmount!)}'),
                    const Divider(height: 1, indent: AppSizes.spaceM),
                    _KvRow(
                      label: '최솟값',
                      value: data.minAmount != null ? '₩${fmt(data.minAmount!)}' : '-',
                    ),
                    const Divider(height: 1, indent: AppSizes.spaceM),
                    _KvRow(
                      label: '최댓값',
                      value: data.maxAmount != null ? '₩${fmt(data.maxAmount!)}' : '-',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.spaceM),
            ],

            // 적용 내역 목록 (최신순, 최대 6개)
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                side: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
              ),
              child: Column(
                children: history.take(6).toList().asMap().entries.map((entry) {
                  final i = entry.key;
                  final h = entry.value;
                  final dateStr = DateFormat('yyyy.MM.dd').format(h.date);
                  final label = h.isConfirmed ? dateStr : '$dateStr  미확정';
                  return Column(
                    children: [
                      if (i > 0) const Divider(height: 1, indent: AppSizes.spaceM),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.spaceM,
                          vertical: AppSizes.spaceM - 2,
                        ),
                        child: Row(
                          children: [
                            Text(
                              label,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: h.isConfirmed
                                        ? colorScheme.onSurfaceVariant
                                        : colorScheme.outline,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '₩${fmt(h.amount)}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: h.isConfirmed ? null : colorScheme.outline,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.spaceM),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
