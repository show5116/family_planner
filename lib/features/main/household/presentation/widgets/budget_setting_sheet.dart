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

class _MonthlyBudgetTab extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  const _MonthlyBudgetTab({required this.scrollController});

  @override
  ConsumerState<_MonthlyBudgetTab> createState() => _MonthlyBudgetTabState();
}

class _MonthlyBudgetTabState extends ConsumerState<_MonthlyBudgetTab> {
  // 로컬 편집 상태: category → amount (null이면 미설정)
  double? _totalAmount;
  final Map<ExpenseCategory, double?> _categoryAmounts = {};
  bool _initialized = false;

  void _initFromData(GroupBudgetModel? groupBudget, List<BudgetModel> budgets) {
    if (_initialized) return;
    _totalAmount = groupBudget?.amount;
    for (final cat in ExpenseCategory.values) {
      try {
        _categoryAmounts[cat] = budgets.firstWhere((b) => b.category == cat).amount;
      } catch (_) {
        _categoryAmounts[cat] = null;
      }
    }
    _initialized = true;
  }

  double get _categorySum => _categoryAmounts.values
      .where((v) => v != null && v > 0)
      .fold(0, (sum, v) => sum + v!);

  bool get _isExceeding =>
      _totalAmount != null && _totalAmount! > 0 && _categorySum > _totalAmount!;

  Future<void> _saveAll(BuildContext context, AppLocalizations l10n) async {
    final groupId = ref.read(householdSelectedGroupIdProvider);
    final month = ref.read(householdSelectedMonthProvider);

    final categories = _categoryAmounts.entries
        .where((e) => e.value != null && e.value! > 0)
        .map((e) => CategoryBudgetItemDto(category: e.key, amount: e.value!))
        .toList();

    final dto = BulkSetBudgetDto(
      groupId: groupId,
      month: month,
      total: (_totalAmount != null && _totalAmount! > 0) ? _totalAmount : null,
      categories: categories,
    );

    final result =
        await ref.read(householdManagementProvider.notifier).setBudgetBulk(dto);

    if (!context.mounted) return;
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.household_budget_saved)),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.common_error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final budgetsAsync = ref.watch(householdBudgetsProvider);
    final groupBudgetAsync = ref.watch(householdGroupBudgetProvider);

    if (budgetsAsync.isLoading || groupBudgetAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (budgetsAsync.hasError) {
      return _ErrorView(onRetry: () => ref.invalidate(householdBudgetsProvider));
    }

    _initFromData(groupBudgetAsync.value, budgetsAsync.value ?? []);

    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: widget.scrollController,
            padding: const EdgeInsets.all(AppSizes.spaceM),
            children: [
              // 초과 경고 배너
              if (_isExceeding)
                Container(
                  padding: const EdgeInsets.all(AppSizes.spaceM),
                  margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          size: 18,
                          color: Theme.of(context).colorScheme.onErrorContainer),
                      const SizedBox(width: AppSizes.spaceS),
                      Expanded(
                        child: Text(
                          l10n.household_budget_category_sum_exceeds(
                            _formatAmount(_categorySum),
                            _formatAmount(_totalAmount!),
                          ),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onErrorContainer,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              // 전체 예산
              _SectionHeader(label: l10n.household_budget_total_label),
              const SizedBox(height: AppSizes.spaceS),
              _EditableBudgetItem(
                icon: Icons.account_balance_wallet,
                color: Theme.of(context).colorScheme.primary,
                label: l10n.household_budget_total_label,
                amount: _totalAmount,
                onChanged: (v) => setState(() => _totalAmount = v),
              ),
              const SizedBox(height: AppSizes.spaceL),
              // 카테고리별 예산
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SectionHeader(label: l10n.household_budget_category_label),
                  Text(
                    l10n.household_budget_category_sum(_formatAmount(_categorySum)),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _isExceeding
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceS),
              ...ExpenseCategory.values.map(
                (cat) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
                  child: _EditableBudgetItem(
                    icon: categoryIcon(cat),
                    color: categoryColor(cat),
                    label: categoryName(l10n, cat),
                    amount: _categoryAmounts[cat],
                    onChanged: (v) => setState(() => _categoryAmounts[cat] = v),
                  ),
                ),
              ),
            ],
          ),
        ),
        // 저장 버튼
        _SaveButton(onPressed: () => _saveAll(context, l10n)),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// 매월 자동 예산(템플릿) 탭
// ─────────────────────────────────────────────

class _TemplateTab extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  const _TemplateTab({required this.scrollController});

  @override
  ConsumerState<_TemplateTab> createState() => _TemplateTabState();
}

class _TemplateTabState extends ConsumerState<_TemplateTab> {
  double? _totalAmount;
  final Map<ExpenseCategory, double?> _categoryAmounts = {};
  bool _initialized = false;

  void _initFromData(
      GroupBudgetTemplateModel? groupTemplate, List<BudgetTemplateModel> templates) {
    if (_initialized) return;
    _totalAmount = groupTemplate?.amount;
    for (final cat in ExpenseCategory.values) {
      try {
        _categoryAmounts[cat] = templates.firstWhere((t) => t.category == cat).amount;
      } catch (_) {
        _categoryAmounts[cat] = null;
      }
    }
    _initialized = true;
  }

  double get _categorySum => _categoryAmounts.values
      .where((v) => v != null && v > 0)
      .fold(0, (sum, v) => sum + v!);

  bool get _isExceeding =>
      _totalAmount != null && _totalAmount! > 0 && _categorySum > _totalAmount!;

  Future<void> _saveAll(BuildContext context, AppLocalizations l10n) async {
    final groupId = ref.read(householdSelectedGroupIdProvider);

    final categories = _categoryAmounts.entries
        .where((e) => e.value != null && e.value! > 0)
        .map((e) => CategoryTemplateItemDto(category: e.key, amount: e.value!))
        .toList();

    final dto = BulkSetBudgetTemplateDto(
      groupId: groupId,
      total: (_totalAmount != null && _totalAmount! > 0) ? _totalAmount : null,
      categories: categories,
    );

    final result =
        await ref.read(householdManagementProvider.notifier).setBudgetTemplateBulk(dto);

    if (!context.mounted) return;
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.household_budget_template_saved)),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.common_error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final templatesAsync = ref.watch(householdBudgetTemplatesProvider);
    final groupTemplateAsync = ref.watch(householdGroupBudgetTemplateProvider);

    if (templatesAsync.isLoading || groupTemplateAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (templatesAsync.hasError) {
      return _ErrorView(onRetry: () => ref.invalidate(householdBudgetTemplatesProvider));
    }

    _initFromData(groupTemplateAsync.value, templatesAsync.value ?? []);

    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: widget.scrollController,
            padding: const EdgeInsets.all(AppSizes.spaceM),
            children: [
              // 안내 배너
              Container(
                padding: const EdgeInsets.all(AppSizes.spaceM),
                margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        size: 18,
                        color: Theme.of(context).colorScheme.onSecondaryContainer),
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
              // 초과 경고 배너
              if (_isExceeding)
                Container(
                  padding: const EdgeInsets.all(AppSizes.spaceM),
                  margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          size: 18,
                          color: Theme.of(context).colorScheme.onErrorContainer),
                      const SizedBox(width: AppSizes.spaceS),
                      Expanded(
                        child: Text(
                          l10n.household_budget_category_sum_exceeds(
                            _formatAmount(_categorySum),
                            _formatAmount(_totalAmount!),
                          ),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onErrorContainer,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              // 전체 예산 템플릿
              _SectionHeader(label: l10n.household_budget_total_label),
              const SizedBox(height: AppSizes.spaceS),
              _EditableBudgetItem(
                icon: Icons.account_balance_wallet,
                color: Theme.of(context).colorScheme.primary,
                label: l10n.household_budget_total_label,
                amount: _totalAmount,
                onChanged: (v) => setState(() => _totalAmount = v),
              ),
              const SizedBox(height: AppSizes.spaceL),
              // 카테고리별 예산 템플릿
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SectionHeader(label: l10n.household_budget_category_label),
                  Text(
                    l10n.household_budget_category_sum(_formatAmount(_categorySum)),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _isExceeding
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceS),
              ...ExpenseCategory.values.map(
                (cat) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
                  child: _EditableBudgetItem(
                    icon: categoryIcon(cat),
                    color: categoryColor(cat),
                    label: categoryName(l10n, cat),
                    amount: _categoryAmounts[cat],
                    onChanged: (v) => setState(() => _categoryAmounts[cat] = v),
                  ),
                ),
              ),
            ],
          ),
        ),
        _SaveButton(onPressed: () => _saveAll(context, l10n)),
      ],
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

/// 하단 저장 버튼
class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _SaveButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.spaceM, AppSizes.spaceS, AppSizes.spaceM, AppSizes.spaceM,
        ),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: onPressed,
            child: Text(AppLocalizations.of(context)!.common_save),
          ),
        ),
      ),
    );
  }
}

/// 인라인 편집 가능한 예산 항목 (탭으로 금액 입력 → setState로 즉시 반영)
class _EditableBudgetItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final double? amount;
  final ValueChanged<double?> onChanged;

  const _EditableBudgetItem({
    required this.icon,
    required this.color,
    required this.label,
    required this.amount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasAmount = amount != null && amount! > 0;

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
          hasAmount ? '₩${_formatAmount(amount!)}' : l10n.household_budget_not_set,
          style: TextStyle(
            color: hasAmount
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.outline,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () => _showEditDialog(context, l10n),
        ),
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, AppLocalizations l10n) async {
    final controller = TextEditingController(
      text: amount?.toInt().toString() ?? '',
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
        title: Text(label),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          autofocus: true,
          onChanged: (_) => setDialogState(() {}),
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
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final parsed = double.tryParse(controller.text);
    onChanged(parsed != null && parsed > 0 ? parsed : null);
  }
}
