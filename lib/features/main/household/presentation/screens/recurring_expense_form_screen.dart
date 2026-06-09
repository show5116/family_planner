import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/main/household/data/models/expense_model.dart';
import 'package:family_planner/features/main/household/data/models/merchant_model.dart';
import 'package:family_planner/features/main/household/data/models/recurring_expense_model.dart';
import 'package:family_planner/features/main/household/presentation/widgets/expense_list_item.dart';
import 'package:family_planner/features/main/household/providers/household_provider.dart';
import 'package:family_planner/features/main/household/providers/merchant_provider.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

class RecurringExpenseFormScreen extends ConsumerStatefulWidget {
  /// null이면 추가 모드, non-null이면 수정 모드
  final RecurringExpenseModel? recurringExpense;
  final String? groupId;

  const RecurringExpenseFormScreen({
    super.key,
    this.recurringExpense,
    this.groupId,
  });

  @override
  ConsumerState<RecurringExpenseFormScreen> createState() =>
      _RecurringExpenseFormScreenState();
}

class _RecurringExpenseFormScreenState
    extends ConsumerState<RecurringExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  TransactionType _transactionType = TransactionType.expense;
  ExpenseCategory? _selectedCategory;
  IncomeCategory? _selectedIncomeCategory;
  PaymentMethod? _selectedPaymentMethod;
  String? _selectedMerchantId;
  int _dayOfMonth = 1;
  bool _isVariable = false;

  bool get _isEditMode => widget.recurringExpense != null;

  @override
  void initState() {
    super.initState();
    final e = widget.recurringExpense;
    if (e != null) {
      _amountController.text = NumberFormat('#,###').format(e.amount.toInt());
      _descriptionController.text = e.description ?? '';
      _transactionType = e.type;
      _selectedCategory = e.category;
      _selectedIncomeCategory = e.incomeCategory;
      _selectedPaymentMethod = e.paymentMethod;
      _selectedMerchantId = e.merchantId;
      _dayOfMonth = e.dayOfMonth;
      _isVariable = e.isVariable;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final managementState = ref.watch(householdManagementProvider);
    final isLoading = managementState is AsyncLoading;
    final effectiveGroupId =
        widget.groupId ?? ref.watch(householdSelectedGroupIdProvider);
    final groupsAsync = ref.watch(myGroupsProvider);
    final groupName = groupsAsync.whenOrNull(
      data: (groups) => groups
          .where((g) => g.id == effectiveGroupId)
          .map((g) => g.name)
          .firstOrNull,
    );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_isEditMode
                ? l10n.household_recurring_edit_title
                : l10n.household_recurring_add_title),
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
          if (_isEditMode)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: l10n.common_delete,
              onPressed: isLoading ? null : () => _confirmDelete(context, l10n),
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppSizes.spaceM),
                  children: [
                    // 거래 유형
                    _TypeToggle(
                      value: _transactionType,
                      onChanged: (v) => setState(() {
                        _transactionType = v;
                        if (v == TransactionType.income) {
                          _selectedCategory = null;
                          _selectedPaymentMethod = null;
                        } else {
                          _selectedIncomeCategory = null;
                        }
                      }),
                      incomeLabel: l10n.household_revenue,
                      expenseLabel: l10n.household_expense,
                    ),
                    const SizedBox(height: AppSizes.spaceM),
                    _AmountField(
                      controller: _amountController,
                      label: _isVariable
                          ? l10n.household_recurring_amount_variable_label
                          : l10n.household_amount,
                      hint: l10n.household_amount_hint,
                      errorText: l10n.household_amount_required,
                    ),
                    _AmountHintBanner(isVariable: _isVariable),
                    if (_transactionType == TransactionType.income) ...[
                      const SizedBox(height: AppSizes.spaceM),
                      _IncomeCategoryBottomSheetSelector(
                        selected: _selectedIncomeCategory,
                        onChanged: (v) =>
                            setState(() => _selectedIncomeCategory = v),
                        label: l10n.household_income_category,
                      ),
                    ],
                    if (_transactionType == TransactionType.expense) ...[
                      const SizedBox(height: AppSizes.spaceM),
                      _CategoryBottomSheetSelector(
                        selected: _selectedCategory,
                        onChanged: (v) =>
                            setState(() => _selectedCategory = v),
                        label: l10n.household_category,
                      ),
                      const SizedBox(height: AppSizes.spaceM),
                      _PaymentMethodSelector(
                        selected: _selectedPaymentMethod,
                        onChanged: (v) =>
                            setState(() => _selectedPaymentMethod = v),
                        label: l10n.household_payment_method,
                      ),
                      const SizedBox(height: AppSizes.spaceM),
                      _MerchantSelector(
                        selectedId: _selectedMerchantId,
                        onChanged: (id) =>
                            setState(() => _selectedMerchantId = id),
                      ),
                    ],
                    const SizedBox(height: AppSizes.spaceM),
                    // 매달 발생 일 — 그리드 바텀시트
                    _DayOfMonthGridSelector(
                      value: _dayOfMonth,
                      onChanged: (v) => setState(() => _dayOfMonth = v),
                    ),
                    const SizedBox(height: AppSizes.spaceM),
                    _DescriptionField(
                      controller: _descriptionController,
                      label: l10n.household_description,
                      hint: l10n.household_description_hint,
                    ),
                    const SizedBox(height: AppSizes.spaceM),
                    _VariableToggle(
                      value: _isVariable,
                      onChanged: (v) => setState(() => _isVariable = v),
                    ),
                    const SizedBox(height: AppSizes.spaceM),
                  ],
                ),
              ),
              // 하단 고정 저장 버튼
              _BottomSaveButton(isLoading: isLoading, onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.household_delete_expense),
        content: Text(l10n.household_delete_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
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
        .deleteRecurringExpense(widget.recurringExpense!.id);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? l10n.household_delete_success : l10n.common_error)),
    );
    if (success) context.pop();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    final amount = double.parse(_amountController.text.replaceAll(',', ''));

    bool success;

    if (_isEditMode) {
      final dto = UpdateRecurringExpenseDto(
        amount: amount,
        isVariable: _isVariable,
        category:
            _transactionType == TransactionType.income ? null : _selectedCategory,
        incomeCategory: _transactionType == TransactionType.income
            ? _selectedIncomeCategory
            : null,
        paymentMethod: _transactionType == TransactionType.income
            ? null
            : _selectedPaymentMethod,
        merchantId: _transactionType == TransactionType.income
            ? null
            : _selectedMerchantId,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        dayOfMonth: _dayOfMonth,
      );
      final result = await ref
          .read(householdManagementProvider.notifier)
          .updateRecurringExpense(widget.recurringExpense!.id, dto);
      success = result != null;
    } else {
      final groupId =
          widget.groupId ?? ref.read(householdSelectedGroupIdProvider);
      final dto = CreateRecurringExpenseDto(
        groupId: groupId,
        type: _transactionType,
        amount: amount,
        isVariable: _isVariable,
        category:
            _transactionType == TransactionType.income ? null : _selectedCategory,
        incomeCategory: _transactionType == TransactionType.income
            ? _selectedIncomeCategory
            : null,
        paymentMethod: _transactionType == TransactionType.income
            ? null
            : _selectedPaymentMethod,
        merchantId: _transactionType == TransactionType.income
            ? null
            : _selectedMerchantId,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        dayOfMonth: _dayOfMonth,
      );
      final result = await ref
          .read(householdManagementProvider.notifier)
          .createRecurringExpense(dto);
      success = result != null;
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? l10n.household_save_success : l10n.common_error),
      ),
    );

    if (success && mounted) Navigator.of(context).pop();
  }
}

// ── 거래 유형 토글 ──────────────────────────────────────────────────────────
class _TypeToggle extends StatelessWidget {
  final TransactionType value;
  final ValueChanged<TransactionType> onChanged;
  final String incomeLabel;
  final String expenseLabel;

  const _TypeToggle({
    required this.value,
    required this.onChanged,
    required this.incomeLabel,
    required this.expenseLabel,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<TransactionType>(
      segments: [
        ButtonSegment(
          value: TransactionType.expense,
          label: Text(expenseLabel),
          icon: const Icon(Icons.arrow_upward),
        ),
        ButtonSegment(
          value: TransactionType.income,
          label: Text(incomeLabel),
          icon: const Icon(Icons.arrow_downward),
        ),
      ],
      selected: {value},
      onSelectionChanged: (s) => onChanged(s.first),
    );
  }
}

// ── 금액 입력 ──────────────────────────────────────────────────────────────
class _AmountField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String errorText;

  const _AmountField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.errorText,
  });

  @override
  State<_AmountField> createState() => _AmountFieldState();
}

class _AmountFieldState extends State<_AmountField> {
  final _formatter = NumberFormat('#,###');

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _ThousandsSeparatorFormatter(_formatter),
      ],
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixText: '₩ ',
        border: const OutlineInputBorder(),
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return widget.errorText;
        final raw = v.replaceAll(',', '');
        if (double.tryParse(raw) == null) return widget.errorText;
        return null;
      },
    );
  }
}

class _ThousandsSeparatorFormatter extends TextInputFormatter {
  final NumberFormat _formatter;
  _ThousandsSeparatorFormatter(this._formatter);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    final number = int.tryParse(newValue.text.replaceAll(',', ''));
    if (number == null) return oldValue;
    final formatted = _formatter.format(number);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// ── 카테고리 바텀시트 그리드 선택 ──────────────────────────────────────────
class _CategoryBottomSheetSelector extends StatelessWidget {
  final ExpenseCategory? selected;
  final ValueChanged<ExpenseCategory?> onChanged;
  final String label;

  const _CategoryBottomSheetSelector({
    required this.selected,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final color = selected != null ? categoryColor(selected) : colorScheme.outline;
    final icon = selected != null ? categoryIcon(selected) : Icons.category_outlined;
    final name = selected != null
        ? categoryName(l10n, selected)
        : l10n.household_category;

    return InkWell(
      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      onTap: () async {
        final result = await showModalBottomSheet<ExpenseCategory?>(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppSizes.radiusLarge)),
          ),
          builder: (ctx) => _ExpenseCategorySheet(selected: selected),
        );
        if (!context.mounted) return;
        onChanged(result);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceM,
            vertical: AppSizes.spaceS + 2,
          ),
          suffixIcon: const Icon(Icons.expand_more),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: AppSizes.spaceS),
            Text(name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: selected != null ? null : colorScheme.onSurfaceVariant,
                    )),
          ],
        ),
      ),
    );
  }
}

class _ExpenseCategorySheet extends StatelessWidget {
  final ExpenseCategory? selected;
  const _ExpenseCategorySheet({this.selected});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final categories = ExpenseCategory.values;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSizes.spaceM, AppSizes.spaceM, AppSizes.spaceM, AppSizes.spaceL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSizes.spaceXS),
              child: Text(
                l10n.household_category,
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
                final isSelected = cat == selected;
                final color = categoryColor(cat);
                return InkWell(
                  borderRadius:
                      BorderRadius.circular(AppSizes.radiusMedium),
                  onTap: () => Navigator.of(ctx).pop(cat),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withValues(alpha: 0.15)
                          : colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.5),
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusMedium),
                      border: isSelected
                          ? Border.all(color: color, width: 1.5)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(categoryIcon(cat), color: color, size: 26),
                        const SizedBox(height: 4),
                        Text(
                          categoryName(l10n, cat),
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: isSelected
                                        ? color
                                        : colorScheme.onSurface,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
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

// ── 수입 카테고리 바텀시트 그리드 선택 ────────────────────────────────────
class _IncomeCategoryBottomSheetSelector extends StatelessWidget {
  final IncomeCategory? selected;
  final ValueChanged<IncomeCategory?> onChanged;
  final String label;

  const _IncomeCategoryBottomSheetSelector({
    required this.selected,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final color =
        selected != null ? incomeCategoryColor(selected) : colorScheme.outline;
    final icon = selected != null
        ? incomeCategoryIcon(selected)
        : Icons.account_balance_wallet_outlined;
    final name = selected != null
        ? incomeCategoryName(l10n, selected)
        : l10n.household_income_category;

    return InkWell(
      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      onTap: () async {
        final result = await showModalBottomSheet<IncomeCategory?>(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppSizes.radiusLarge)),
          ),
          builder: (ctx) => _IncomeCategorySheet(selected: selected),
        );
        if (!context.mounted) return;
        onChanged(result);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceM,
            vertical: AppSizes.spaceS + 2,
          ),
          suffixIcon: const Icon(Icons.expand_more),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: AppSizes.spaceS),
            Text(name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: selected != null
                          ? null
                          : colorScheme.onSurfaceVariant,
                    )),
          ],
        ),
      ),
    );
  }
}

class _IncomeCategorySheet extends StatelessWidget {
  final IncomeCategory? selected;
  const _IncomeCategorySheet({this.selected});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final categories = IncomeCategory.values;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSizes.spaceM, AppSizes.spaceM, AppSizes.spaceM, AppSizes.spaceL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSizes.spaceXS),
              child: Text(
                l10n.household_income_category,
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
                final isSelected = cat == selected;
                final color = incomeCategoryColor(cat);
                return InkWell(
                  borderRadius:
                      BorderRadius.circular(AppSizes.radiusMedium),
                  onTap: () => Navigator.of(ctx).pop(cat),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withValues(alpha: 0.15)
                          : colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.5),
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusMedium),
                      border: isSelected
                          ? Border.all(color: color, width: 1.5)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(incomeCategoryIcon(cat), color: color, size: 26),
                        const SizedBox(height: 4),
                        Text(
                          incomeCategoryName(l10n, cat),
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: isSelected
                                        ? color
                                        : colorScheme.onSurface,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
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

// ── 결제 수단 선택 ─────────────────────────────────────────────────────────
class _PaymentMethodSelector extends StatelessWidget {
  final PaymentMethod? selected;
  final ValueChanged<PaymentMethod?> onChanged;
  final String label;

  const _PaymentMethodSelector({
    required this.selected,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceM,
          vertical: AppSizes.spaceS,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<PaymentMethod?>(
          value: selected,
          isExpanded: true,
          isDense: true,
          hint: Text(l10n.household_payment_other),
          items: [
            DropdownMenuItem(value: null, child: Text(l10n.household_payment_other)),
            ...PaymentMethod.values.map((m) => DropdownMenuItem(
                  value: m,
                  child: Text(paymentMethodName(l10n, m)),
                )),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// ── 소비처 바텀시트 선택 ───────────────────────────────────────────────────
class _MerchantSelector extends ConsumerWidget {
  final String? selectedId;
  final ValueChanged<String?> onChanged;

  const _MerchantSelector({required this.selectedId, required this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final merchantsAsync = ref.watch(merchantsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return merchantsAsync.when(
      data: (merchants) {
        final selectedName = merchants
            .where((m) => m.id == selectedId)
            .map((m) => m.name)
            .firstOrNull;

        return InkWell(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          onTap: () async {
            final result = await showModalBottomSheet<String?>(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppSizes.radiusLarge)),
              ),
              builder: (ctx) => _MerchantSheet(
                merchants: merchants,
                selectedId: selectedId,
              ),
            );
            if (!context.mounted) return;
            if (result != _merchantSheetClosed) onChanged(result);
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: l10n.household_merchant_select,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceM,
                vertical: AppSizes.spaceS + 2,
              ),
              suffixIcon: const Icon(Icons.expand_more),
            ),
            child: Row(
              children: [
                Icon(Icons.storefront_outlined,
                    size: 18,
                    color: selectedName != null
                        ? colorScheme.primary
                        : colorScheme.outline),
                const SizedBox(width: AppSizes.spaceS),
                Expanded(
                  child: Text(
                    selectedName ?? l10n.household_merchant_none,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: selectedName != null
                              ? null
                              : colorScheme.onSurfaceVariant,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

const _merchantSheetClosed = '__closed__';

class _MerchantSheet extends StatelessWidget {
  final List<MerchantModel> merchants;
  final String? selectedId;

  const _MerchantSheet({required this.merchants, this.selectedId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, AppSizes.spaceM, 0, AppSizes.spaceL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM),
              child: Row(
                children: [
                  Text(
                    l10n.household_merchant_select,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.storefront_outlined, size: 20),
                    tooltip: l10n.household_merchants,
                    onPressed: () {
                      Navigator.of(context).pop(_merchantSheetClosed);
                      context.push(AppRoutes.householdMerchants);
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            if (merchants.isEmpty)
              Padding(
                padding: const EdgeInsets.all(AppSizes.spaceL),
                child: Text(
                  l10n.household_merchants_empty,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
              )
            else ...[
              ListTile(
                leading: Icon(Icons.remove_circle_outline,
                    color: colorScheme.outline, size: 20),
                title: Text(l10n.household_merchant_none),
                trailing: selectedId == null
                    ? Icon(Icons.check, color: colorScheme.primary, size: 20)
                    : null,
                onTap: () => Navigator.of(context).pop(null),
              ),
              const Divider(height: 1, indent: AppSizes.spaceM),
              ...merchants.map((m) {
                final isSelected = m.id == selectedId;
                return ListTile(
                  leading: Icon(Icons.storefront,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                      size: 20),
                  title: Text(m.name),
                  trailing: isSelected
                      ? Icon(Icons.check, color: colorScheme.primary, size: 20)
                      : null,
                  onTap: () => Navigator.of(context).pop(m.id),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}

// ── 매달 발생 일 선택 — 캘린더형 그리드 바텀시트 ────────────────────────
class _DayOfMonthGridSelector extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _DayOfMonthGridSelector(
      {required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      onTap: () async {
        final result = await showModalBottomSheet<int>(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppSizes.radiusLarge)),
          ),
          builder: (ctx) => _DayOfMonthSheet(selected: value),
        );
        if (result != null) onChanged(result);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.household_recurring_day_of_month,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceM,
            vertical: AppSizes.spaceS + 2,
          ),
          suffixIcon: const Icon(Icons.calendar_month_outlined),
        ),
        child: Row(
          children: [
            Icon(Icons.event_repeat,
                size: 18, color: colorScheme.primary),
            const SizedBox(width: AppSizes.spaceS),
            Text(
              l10n.household_recurring_day_of_month_value(value),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayOfMonthSheet extends StatelessWidget {
  final int selected;
  const _DayOfMonthSheet({required this.selected});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSizes.spaceM, AppSizes.spaceM, AppSizes.spaceM, AppSizes.spaceL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSizes.spaceXS),
              child: Text(
                l10n.household_recurring_day_of_month,
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
                crossAxisCount: 7,
                mainAxisSpacing: AppSizes.spaceXS,
                crossAxisSpacing: AppSizes.spaceXS,
                childAspectRatio: 1,
              ),
              itemCount: 31,
              itemBuilder: (ctx, i) {
                final day = i + 1;
                final isSelected = day == selected;
                final isLate = day > 28;
                return InkWell(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  onTap: () => Navigator.of(ctx).pop(day),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primary
                          : isLate
                              ? colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.4)
                              : colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.6),
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusSmall),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$day',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isSelected
                                ? colorScheme.onPrimary
                                : isLate
                                    ? colorScheme.outline
                                    : colorScheme.onSurface,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSizes.spaceS),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSizes.spaceXS),
              child: Text(
                '* 29~31일은 해당 월에 없으면 말일 처리됩니다',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.outline,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 금액 안내 배너 ─────────────────────────────────────────────────────────
class _AmountHintBanner extends StatelessWidget {
  final bool isVariable;
  const _AmountHintBanner({required this.isVariable});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final (icon, color, text) = isVariable
        ? (
            Icons.info_outline,
            colorScheme.tertiary,
            l10n.household_recurring_amount_variable_hint,
          )
        : (
            Icons.check_circle_outline,
            colorScheme.primary,
            l10n.household_recurring_amount_fixed_hint,
          );

    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.spaceS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: AppSizes.spaceXS),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 가변 고정지출 토글 ─────────────────────────────────────────────────────
class _VariableToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _VariableToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        title: Text(
          l10n.household_recurring_type_variable,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        subtitle: Text(
          value
              ? l10n.household_recurring_type_variable_desc
              : l10n.household_recurring_type_fixed_desc,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
        ),
        secondary: Icon(
          Icons.tune,
          color: value ? colorScheme.primary : colorScheme.outline,
        ),
      ),
    );
  }
}

// ── 내용 입력 ──────────────────────────────────────────────────────────────
class _DescriptionField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;

  const _DescriptionField({
    required this.controller,
    required this.label,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
      maxLines: 2,
    );
  }
}

// ── 하단 고정 저장 버튼 ────────────────────────────────────────────────────
class _BottomSaveButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _BottomSaveButton(
      {required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSizes.spaceM,
        AppSizes.spaceS,
        AppSizes.spaceM,
        AppSizes.spaceM + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
              color: colorScheme.outlineVariant, width: 0.5),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton(
          onPressed: isLoading ? null : onPressed,
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : Text(l10n.common_save,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
