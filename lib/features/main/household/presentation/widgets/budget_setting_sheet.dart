import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/household/data/models/budget_model.dart';
import 'package:family_planner/features/main/household/data/models/expense_model.dart';
import 'package:family_planner/features/main/household/presentation/widgets/expense_list_item.dart';
import 'package:family_planner/features/main/household/providers/household_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 예산 설정 Bottom Sheet 진입점
void showBudgetSettingSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLarge)),
    ),
    builder: (_) => const BudgetSettingSheet(),
  );
}

class BudgetSettingSheet extends ConsumerWidget {
  const BudgetSettingSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final budgetsAsync = ref.watch(householdBudgetsProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // 핸들
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceS),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // 타이틀
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.spaceM, AppSizes.spaceXS, AppSizes.spaceS, AppSizes.spaceM,
              ),
              child: Row(
                children: [
                  Text(
                    l10n.household_budget_set,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // 내용
            Expanded(
              child: budgetsAsync.when(
                data: (budgets) => ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppSizes.spaceM),
                  children: [
                    // 전체 예산 섹션
                    _SectionHeader(label: l10n.household_budget_total_label),
                    const SizedBox(height: AppSizes.spaceS),
                    _BudgetItem(
                      category: null,
                      currentBudget: _findBudget(budgets, null),
                    ),
                    const SizedBox(height: AppSizes.spaceL),
                    // 카테고리별 예산 섹션
                    _SectionHeader(label: l10n.household_budget_category_label),
                    const SizedBox(height: AppSizes.spaceS),
                    ...ExpenseCategory.values.map(
                      (cat) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
                        child: _BudgetItem(
                          category: cat,
                          currentBudget: _findBudget(budgets, cat),
                        ),
                      ),
                    ),
                  ],
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(l10n.common_error),
                      const SizedBox(height: AppSizes.spaceS),
                      ElevatedButton(
                        onPressed: () => ref.invalidate(householdBudgetsProvider),
                        child: Text(l10n.common_retry),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  BudgetModel? _findBudget(List<BudgetModel> budgets, ExpenseCategory? category) {
    try {
      return budgets.firstWhere((b) => b.category == category);
    } catch (_) {
      return null;
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
    );
  }
}

/// 개별 예산 항목 (현재 예산 표시 + 수정 버튼)
class _BudgetItem extends ConsumerWidget {
  final ExpenseCategory? category;
  final BudgetModel? currentBudget;

  const _BudgetItem({
    required this.category,
    required this.currentBudget,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final icon = category == null ? Icons.account_balance_wallet : categoryIcon(category);
    final color = category == null
        ? Theme.of(context).colorScheme.primary
        : categoryColor(category);
    final label = category == null
        ? l10n.household_budget_total_label
        : categoryName(l10n, category);
    final hasAmount = currentBudget != null && currentBudget!.amount > 0;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 0.5,
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          hasAmount
              ? '₩${_formatAmount(currentBudget!.amount)}'
              : l10n.household_budget_not_set,
          style: TextStyle(
            color: hasAmount
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.outline,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () => _showEditDialog(context, ref, l10n, label),
        ),
      ),
    );
  }

  Future<void> _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String label,
  ) async {
    final controller = TextEditingController(
      text: currentBudget?.amount.toInt().toString() ?? '',
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(label),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          autofocus: true,
          decoration: InputDecoration(
            prefixText: '₩ ',
            hintText: '0',
            border: const OutlineInputBorder(),
            labelText: l10n.household_budget_set,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.common_save),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final amount = double.tryParse(controller.text);
    if (amount == null) return;

    final groupId = ref.read(householdSelectedGroupIdProvider);
    final month = ref.read(householdSelectedMonthProvider);
    if (groupId == null) return;

    final dto = SetBudgetDto(
      groupId: groupId,
      category: category,
      amount: amount,
      month: month,
    );

    await ref.read(householdManagementProvider.notifier).setBudget(dto);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.household_budget_saved)),
    );
  }

  String _formatAmount(double amount) {
    final intAmount = amount.toInt();
    final str = intAmount.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write(',');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }
}
