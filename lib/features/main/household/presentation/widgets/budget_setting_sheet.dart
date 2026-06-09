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
  double? _totalAmount;
  final Map<ExpenseCategory, double?> _categoryAmounts = {};
  // 활성화된(추가된) 카테고리 목록
  final Set<ExpenseCategory> _activeCategories = {};
  // 서버에 저장된 적 있어서 저장 시 0으로 명시 삭제해야 하는 카테고리
  final Set<ExpenseCategory> _deletedCategories = {};
  bool _initialized = false;
  bool _saving = false;
  String? _errorMsg;

  // 초기 로드 시 서버에 저장된 카테고리 목록 (삭제 시 amount:0 전송 대상 추적용)
  final Set<ExpenseCategory> _serverSavedCategories = {};

  void _initFromData(GroupBudgetModel? groupBudget, List<BudgetModel> budgets) {
    if (_initialized) return;
    _totalAmount = groupBudget?.amount;
    for (final cat in ExpenseCategory.values) {
      try {
        final budget = budgets.firstWhere((b) => b.category == cat);
        _categoryAmounts[cat] = budget.amount;
        if (budget.amount > 0) {
          _activeCategories.add(cat);
          _serverSavedCategories.add(cat);
        }
      } catch (_) {
        _categoryAmounts[cat] = null;
      }
    }
    _initialized = true;
  }

  double get _categorySum => _activeCategories
      .map((cat) => _categoryAmounts[cat])
      .where((v) => v != null && v > 0)
      .fold(0, (sum, v) => sum + v!);

  bool get _isExceeding =>
      _totalAmount != null && _totalAmount! > 0 && _categorySum > _totalAmount!;

  Future<void> _pickCategory(BuildContext context) async {
    final cat = await showModalBottomSheet<ExpenseCategory>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLarge)),
      ),
      builder: (_) => _BudgetCategorySheet(excluded: _activeCategories),
    );
    if (cat == null) return;
    setState(() {
      _activeCategories.add(cat);
    });
    // 금액 바로 입력
    if (context.mounted) {
      final l10n = AppLocalizations.of(context)!;
      await _editAmount(context, l10n, cat);
    }
  }

  Future<void> _editAmount(
      BuildContext context, AppLocalizations l10n, ExpenseCategory cat) async {
    final current = _categoryAmounts[cat];
    final controller = TextEditingController(
      text: current?.toInt().toString() ?? '',
    );
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(categoryName(l10n, cat)),
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
    final parsed = double.tryParse(controller.text);
    if (parsed == null || parsed <= 0) {
      // 0 또는 빈 값 입력 = 카테고리 삭제 의도
      _removeCategory(cat);
    } else {
      setState(() => _categoryAmounts[cat] = parsed);
    }
  }

  void _removeCategory(ExpenseCategory cat) {
    setState(() {
      _activeCategories.remove(cat);
      _categoryAmounts[cat] = null;
      // 서버에 저장된 카테고리면 저장 시 amount:0으로 명시 삭제
      if (_serverSavedCategories.contains(cat)) {
        _deletedCategories.add(cat);
      }
    });
  }

  Future<void> _saveAll(BuildContext context, AppLocalizations l10n) async {
    setState(() { _saving = true; _errorMsg = null; });

    final groupId = ref.read(householdSelectedGroupIdProvider);
    final month = ref.read(householdSelectedMonthProvider);

    // 활성 카테고리 + 삭제된 카테고리(amount:0으로 초기화)
    final categories = [
      ..._activeCategories
          .where((cat) => _categoryAmounts[cat] != null && _categoryAmounts[cat]! > 0)
          .map((cat) => CategoryBudgetItemDto(category: cat, amount: _categoryAmounts[cat]!)),
      ..._deletedCategories
          .map((cat) => CategoryBudgetItemDto(category: cat, amount: 0)),
    ];

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
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.household_budget_saved)),
      );
    } else {
      setState(() { _saving = false; _errorMsg = l10n.common_error; });
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

    final sortedActive = ExpenseCategory.values
        .where((cat) => _activeCategories.contains(cat))
        .toList();

    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: widget.scrollController,
            padding: const EdgeInsets.all(AppSizes.spaceM),
            children: [
              // 초과 경고 배너
              if (_isExceeding)
                _ExceedBanner(
                  categorySum: _categorySum,
                  totalAmount: _totalAmount!,
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
              // 카테고리별 예산 헤더
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SectionHeader(label: l10n.household_budget_category_label),
                  if (_activeCategories.isNotEmpty)
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
              // 추가된 카테고리 카드들 (스와이프 삭제)
              ...sortedActive.map((cat) => _SwipeableBudgetItem(
                    key: ValueKey(cat),
                    icon: categoryIcon(cat),
                    color: categoryColor(cat),
                    label: categoryName(l10n, cat),
                    amount: _categoryAmounts[cat],
                    onEdit: () => _editAmount(context, l10n, cat),
                    onDelete: () => _removeCategory(cat),
                  )),
              // + 카테고리 추가 버튼
              _AddCategoryButton(
                onTap: () => _pickCategory(context),
              ),
            ],
          ),
        ),
        if (_errorMsg != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM),
            child: Text(
              _errorMsg!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
        _SaveButton(
          onPressed: _saving ? null : () => _saveAll(context, l10n),
        ),
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
  final Set<ExpenseCategory> _activeCategories = {};
  final Set<ExpenseCategory> _deletedCategories = {};
  final Set<ExpenseCategory> _serverSavedCategories = {};
  bool _initialized = false;
  bool _saving = false;
  String? _errorMsg;

  void _initFromData(
      GroupBudgetTemplateModel? groupTemplate, List<BudgetTemplateModel> templates) {
    if (_initialized) return;
    _totalAmount = groupTemplate?.amount;
    for (final cat in ExpenseCategory.values) {
      try {
        final t = templates.firstWhere((t) => t.category == cat);
        _categoryAmounts[cat] = t.amount;
        if (t.amount > 0) {
          _activeCategories.add(cat);
          _serverSavedCategories.add(cat);
        }
      } catch (_) {
        _categoryAmounts[cat] = null;
      }
    }
    _initialized = true;
  }

  double get _categorySum => _activeCategories
      .map((cat) => _categoryAmounts[cat])
      .where((v) => v != null && v > 0)
      .fold(0, (sum, v) => sum + v!);

  bool get _isExceeding =>
      _totalAmount != null && _totalAmount! > 0 && _categorySum > _totalAmount!;

  Future<void> _pickCategory(BuildContext context) async {
    final cat = await showModalBottomSheet<ExpenseCategory>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLarge)),
      ),
      builder: (_) => _BudgetCategorySheet(excluded: _activeCategories),
    );
    if (cat == null) return;
    setState(() => _activeCategories.add(cat));
    if (context.mounted) {
      final l10n = AppLocalizations.of(context)!;
      await _editAmount(context, l10n, cat);
    }
  }

  Future<void> _editAmount(
      BuildContext context, AppLocalizations l10n, ExpenseCategory cat) async {
    final current = _categoryAmounts[cat];
    final controller = TextEditingController(
      text: current?.toInt().toString() ?? '',
    );
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(categoryName(l10n, cat)),
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
    final parsed = double.tryParse(controller.text);
    if (parsed == null || parsed <= 0) {
      _removeCategory(cat);
    } else {
      setState(() => _categoryAmounts[cat] = parsed);
    }
  }

  void _removeCategory(ExpenseCategory cat) {
    setState(() {
      _activeCategories.remove(cat);
      _categoryAmounts[cat] = null;
      if (_serverSavedCategories.contains(cat)) {
        _deletedCategories.add(cat);
      }
    });
  }

  Future<void> _saveAll(BuildContext context, AppLocalizations l10n) async {
    setState(() { _saving = true; _errorMsg = null; });

    final groupId = ref.read(householdSelectedGroupIdProvider);

    // 삭제된 카테고리 템플릿 먼저 API로 삭제
    for (final cat in _deletedCategories) {
      try {
        await ref.read(householdManagementProvider.notifier)
            .deleteBudgetTemplate(groupId: groupId, category: cat);
      } catch (_) {}
    }

    final categories = _activeCategories
        .where((cat) => _categoryAmounts[cat] != null && _categoryAmounts[cat]! > 0)
        .map((cat) => CategoryTemplateItemDto(category: cat, amount: _categoryAmounts[cat]!))
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
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.household_budget_template_saved)),
      );
    } else {
      setState(() { _saving = false; _errorMsg = l10n.common_error; });
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

    final sortedActive = ExpenseCategory.values
        .where((cat) => _activeCategories.contains(cat))
        .toList();

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
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  border: Border.all(color: const Color(0xFFFFCC80), width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 18, color: Color(0xFF854D0E)),
                    const SizedBox(width: AppSizes.spaceS),
                    Expanded(
                      child: Text(
                        l10n.household_budget_template_info,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF854D0E),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              // 초과 경고 배너
              if (_isExceeding)
                _ExceedBanner(
                  categorySum: _categorySum,
                  totalAmount: _totalAmount!,
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
              // 카테고리별 예산 템플릿 헤더
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SectionHeader(label: l10n.household_budget_category_label),
                  if (_activeCategories.isNotEmpty)
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
              // 추가된 카테고리 카드들
              ...sortedActive.map((cat) => _SwipeableBudgetItem(
                    key: ValueKey(cat),
                    icon: categoryIcon(cat),
                    color: categoryColor(cat),
                    label: categoryName(l10n, cat),
                    amount: _categoryAmounts[cat],
                    onEdit: () => _editAmount(context, l10n, cat),
                    onDelete: () => _removeCategory(cat),
                  )),
              // + 카테고리 추가 버튼
              _AddCategoryButton(
                onTap: () => _pickCategory(context),
              ),
            ],
          ),
        ),
        if (_errorMsg != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM),
            child: Text(
              _errorMsg!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
        _SaveButton(
          onPressed: _saving ? null : () => _saveAll(context, l10n),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// 카테고리 선택 바텀시트 (4열 그리드)
// ─────────────────────────────────────────────

class _BudgetCategorySheet extends StatelessWidget {
  final Set<ExpenseCategory> excluded;
  const _BudgetCategorySheet({required this.excluded});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    // carryover는 예산 카테고리에서 제외
    final categories = ExpenseCategory.values
        .where((c) => c != ExpenseCategory.carryover)
        .toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSizes.spaceM, AppSizes.spaceM, AppSizes.spaceM, AppSizes.spaceL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceXS),
              child: Text(
                l10n.household_budget_category_label,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: AppSizes.spaceM),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: AppSizes.spaceS,
                crossAxisSpacing: AppSizes.spaceS,
                childAspectRatio: 0.9,
              ),
              itemCount: categories.length,
              itemBuilder: (ctx, i) {
                final cat = categories[i];
                final isAdded = excluded.contains(cat);
                final color = categoryColor(cat);
                return InkWell(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  onTap: isAdded ? null : () => Navigator.of(ctx).pop(cat),
                  child: Opacity(
                    opacity: isAdded ? 0.4 : 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isAdded
                            ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
                            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(categoryIcon(cat), color: color, size: 26),
                                const SizedBox(height: 4),
                                Text(
                                  categoryName(l10n, cat),
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: colorScheme.onSurface,
                                      ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          if (isAdded)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Icon(
                                Icons.check_circle,
                                size: 14,
                                color: colorScheme.primary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 스와이프 삭제 가능한 카테고리 예산 카드
// ─────────────────────────────────────────────

class _SwipeableBudgetItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final double? amount;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SwipeableBudgetItem({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.amount,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
      child: Dismissible(
        key: key!,
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) async {
          onDelete();
          return false;
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: AppSizes.spaceM),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          child: Icon(
            Icons.delete_outline,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
        ),
        child: Card(
          elevation: 0,
          margin: EdgeInsets.zero,
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
              amount != null && amount! > 0
                  ? '₩${_formatAmount(amount!)}'
                  : '미설정',
              style: TextStyle(
                color: amount != null && amount! > 0
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.outline,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: onEdit,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// + 카테고리 추가 버튼
// ─────────────────────────────────────────────

class _AddCategoryButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddCategoryButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.spaceXS),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
              width: 1.5,
              style: BorderStyle.none,
            ),
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                '예산 카테고리 추가',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 공통 위젯
// ─────────────────────────────────────────────

class _ExceedBanner extends StatelessWidget {
  final double categorySum;
  final double totalAmount;
  const _ExceedBanner({required this.categorySum, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
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
                _formatAmount(categorySum),
                _formatAmount(totalAmount),
              ),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
            ),
          ),
        ],
      ),
    );
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
  final VoidCallback? onPressed;
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

/// 전체 예산 편집 항목 (전체 예산 카드 전용)
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
    final parsed = double.tryParse(controller.text);
    onChanged(parsed != null && parsed > 0 ? parsed : null);
  }
}
