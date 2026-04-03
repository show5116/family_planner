import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/household/data/models/budget_model.dart';
import 'package:family_planner/features/main/household/data/models/expense_model.dart';
import 'package:family_planner/features/main/household/presentation/widgets/expense_list_item.dart';
import 'package:family_planner/features/main/household/providers/household_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

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

class BudgetSettingSheet extends ConsumerStatefulWidget {
  const BudgetSettingSheet({super.key});

  @override
  ConsumerState<BudgetSettingSheet> createState() => _BudgetSettingSheetState();
}

class _BudgetSettingSheetState extends ConsumerState<BudgetSettingSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
                AppSizes.spaceM, AppSizes.spaceXS, AppSizes.spaceS, AppSizes.spaceXS,
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
            // 탭
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: l10n.household_budget_tab_monthly),
                Tab(text: l10n.household_budget_tab_template),
              ],
            ),
            const Divider(height: 1),
            // 탭 내용
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _MonthlyBudgetTab(scrollController: scrollController),
                  _TemplateTab(scrollController: scrollController),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// 이번 달 예산 탭
// ─────────────────────────────────────────────

class _MonthlyBudgetTab extends ConsumerWidget {
  final ScrollController scrollController;
  const _MonthlyBudgetTab({required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final budgetsAsync = ref.watch(householdBudgetsProvider);
    final groupBudgetAsync = ref.watch(householdGroupBudgetProvider);

    // 두 provider가 모두 로드될 때까지 대기
    if (budgetsAsync.isLoading || groupBudgetAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (budgetsAsync.hasError) {
      return _ErrorView(onRetry: () => ref.invalidate(householdBudgetsProvider));
    }

    final budgets = budgetsAsync.value ?? [];
    final groupBudget = groupBudgetAsync.value;

    final categorySum = budgets.fold<double>(0, (sum, b) => sum + b.amount);
    final totalBudget = groupBudget?.amount;
    final isExceeding = totalBudget != null && totalBudget > 0 && categorySum > totalBudget;

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(AppSizes.spaceM),
      children: [
        // 초과 경고 배너
        if (isExceeding) ...[
          Container(
            padding: const EdgeInsets.all(AppSizes.spaceM),
            margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 18,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
                const SizedBox(width: AppSizes.spaceS),
                Expanded(
                  child: Text(
                    l10n.household_budget_category_sum_exceeds(
                      _formatAmount(categorySum),
                      _formatAmount(totalBudget),
                    ),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
        // 전체 예산
        _SectionHeader(label: l10n.household_budget_total_label),
        const SizedBox(height: AppSizes.spaceS),
        _BudgetItem(
          icon: Icons.account_balance_wallet,
          color: Theme.of(context).colorScheme.primary,
          label: l10n.household_budget_total_label,
          currentAmount: groupBudget?.amount,
          onSave: (amount) => _saveGroupBudget(ref, context, l10n, amount),
        ),
        const SizedBox(height: AppSizes.spaceL),
        // 카테고리별 예산
        _SectionHeader(label: l10n.household_budget_category_label),
        const SizedBox(height: AppSizes.spaceS),
        ...ExpenseCategory.values.map(
          (cat) => Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
            child: _BudgetItem(
              icon: categoryIcon(cat),
              color: categoryColor(cat),
              label: categoryName(l10n, cat),
              currentAmount: _findAmount(budgets, cat),
              onSave: (amount) => _saveBudget(ref, context, l10n, cat, amount),
            ),
          ),
        ),
      ],
    );
  }

  double? _findAmount(List<BudgetModel> budgets, ExpenseCategory category) {
    try {
      return budgets.firstWhere((b) => b.category == category).amount;
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveGroupBudget(
    WidgetRef ref,
    BuildContext context,
    AppLocalizations l10n,
    double amount,
  ) async {
    final groupId = ref.read(householdSelectedGroupIdProvider);
    final month = ref.read(householdSelectedMonthProvider);
    if (groupId == null) return;

    await ref.read(householdManagementProvider.notifier).setGroupBudget(
          SetGroupBudgetDto(groupId: groupId, amount: amount, month: month),
        );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.household_budget_saved)),
      );
    }
  }

  Future<void> _saveBudget(
    WidgetRef ref,
    BuildContext context,
    AppLocalizations l10n,
    ExpenseCategory category,
    double amount,
  ) async {
    final groupId = ref.read(householdSelectedGroupIdProvider);
    final month = ref.read(householdSelectedMonthProvider);
    if (groupId == null) return;

    await ref.read(householdManagementProvider.notifier).setBudget(
          SetBudgetDto(groupId: groupId, category: category, amount: amount, month: month),
        );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.household_budget_saved)),
      );
    }
  }
}

// ─────────────────────────────────────────────
// 매월 자동 예산(템플릿) 탭
// ─────────────────────────────────────────────

class _TemplateTab extends ConsumerWidget {
  final ScrollController scrollController;
  const _TemplateTab({required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final templatesAsync = ref.watch(householdBudgetTemplatesProvider);
    final groupTemplateAsync = ref.watch(householdGroupBudgetTemplateProvider);

    if (templatesAsync.isLoading || groupTemplateAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (templatesAsync.hasError) {
      return _ErrorView(onRetry: () => ref.invalidate(householdBudgetTemplatesProvider));
    }

    final templates = templatesAsync.value ?? [];
    final groupTemplate = groupTemplateAsync.value;

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(AppSizes.spaceM),
      children: [
        // 안내 배너
        Container(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          margin: const EdgeInsets.only(bottom: AppSizes.spaceL),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 18,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
              const SizedBox(width: AppSizes.spaceS),
              Expanded(
                child: Text(
                  l10n.household_budget_template_info,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                ),
              ),
            ],
          ),
        ),
        // 전체 예산 템플릿
        _SectionHeader(label: l10n.household_budget_total_label),
        const SizedBox(height: AppSizes.spaceS),
        _BudgetItem(
          icon: Icons.account_balance_wallet,
          color: Theme.of(context).colorScheme.primary,
          label: l10n.household_budget_total_label,
          currentAmount: groupTemplate?.amount,
          showDeleteButton: groupTemplate != null,
          onSave: (amount) => _saveGroupTemplate(ref, context, l10n, amount),
          onDelete: () => _deleteGroupTemplate(ref, context, l10n),
        ),
        const SizedBox(height: AppSizes.spaceL),
        // 카테고리별 예산 템플릿
        _SectionHeader(label: l10n.household_budget_category_label),
        const SizedBox(height: AppSizes.spaceS),
        ...ExpenseCategory.values.map(
          (cat) => Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
            child: _BudgetItem(
              icon: categoryIcon(cat),
              color: categoryColor(cat),
              label: categoryName(l10n, cat),
              currentAmount: _findTemplateAmount(templates, cat),
              showDeleteButton: _findTemplateAmount(templates, cat) != null,
              onSave: (amount) => _saveTemplate(ref, context, l10n, cat, amount),
              onDelete: () => _deleteTemplate(ref, context, l10n, cat),
            ),
          ),
        ),
      ],
    );
  }

  double? _findTemplateAmount(List<BudgetTemplateModel> templates, ExpenseCategory category) {
    try {
      return templates.firstWhere((t) => t.category == category).amount;
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveGroupTemplate(
    WidgetRef ref,
    BuildContext context,
    AppLocalizations l10n,
    double amount,
  ) async {
    final groupId = ref.read(householdSelectedGroupIdProvider);
    if (groupId == null) return;

    await ref.read(householdManagementProvider.notifier).setGroupBudgetTemplate(
          SetGroupBudgetTemplateDto(groupId: groupId, amount: amount),
        );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.household_budget_template_saved)),
      );
    }
  }

  Future<void> _deleteGroupTemplate(
    WidgetRef ref,
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final groupId = ref.read(householdSelectedGroupIdProvider);
    if (groupId == null) return;

    final confirmed = await _showDeleteConfirmDialog(context, l10n);
    if (confirmed != true) return;

    await ref
        .read(householdManagementProvider.notifier)
        .deleteGroupBudgetTemplate(groupId: groupId);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.household_budget_template_deleted)),
      );
    }
  }

  Future<void> _saveTemplate(
    WidgetRef ref,
    BuildContext context,
    AppLocalizations l10n,
    ExpenseCategory category,
    double amount,
  ) async {
    final groupId = ref.read(householdSelectedGroupIdProvider);
    if (groupId == null) return;

    await ref.read(householdManagementProvider.notifier).setBudgetTemplate(
          SetBudgetTemplateDto(groupId: groupId, category: category, amount: amount),
        );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.household_budget_template_saved)),
      );
    }
  }

  Future<void> _deleteTemplate(
    WidgetRef ref,
    BuildContext context,
    AppLocalizations l10n,
    ExpenseCategory category,
  ) async {
    final groupId = ref.read(householdSelectedGroupIdProvider);
    if (groupId == null) return;

    final confirmed = await _showDeleteConfirmDialog(context, l10n);
    if (confirmed != true) return;

    await ref.read(householdManagementProvider.notifier).deleteBudgetTemplate(
          groupId: groupId,
          category: category,
        );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.household_budget_template_deleted)),
      );
    }
  }

  Future<bool?> _showDeleteConfirmDialog(BuildContext context, AppLocalizations l10n) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.household_budget_template_delete_title),
        content: Text(l10n.household_budget_template_delete_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.common_delete),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 공통 위젯
// ─────────────────────────────────────────────

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

class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(l10n.common_error),
          const SizedBox(height: AppSizes.spaceS),
          ElevatedButton(onPressed: onRetry, child: Text(l10n.common_retry)),
        ],
      ),
    );
  }
}

/// 개별 예산/템플릿 항목
class _BudgetItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final double? currentAmount;
  final bool showDeleteButton;
  final Future<void> Function(double amount) onSave;
  final VoidCallback? onDelete;

  const _BudgetItem({
    required this.icon,
    required this.color,
    required this.label,
    required this.currentAmount,
    required this.onSave,
    this.showDeleteButton = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasAmount = currentAmount != null && currentAmount! > 0;

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
          hasAmount ? '₩${_formatAmount(currentAmount!)}' : l10n.household_budget_not_set,
          style: TextStyle(
            color: hasAmount
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.outline,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showDeleteButton && onDelete != null)
              IconButton(
                icon: Icon(Icons.delete_outline,
                    color: Theme.of(context).colorScheme.error),
                onPressed: onDelete,
              ),
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => _showEditDialog(context, l10n),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, AppLocalizations l10n) async {
    final controller = TextEditingController(
      text: currentAmount?.toInt().toString() ?? '',
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
    if (amount == null || amount <= 0) return;

    await onSave(amount);
  }

}
