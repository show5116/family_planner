import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/main/household/data/models/expense_model.dart';
import 'package:family_planner/features/main/household/presentation/widgets/expense_list_item.dart';
import 'package:family_planner/features/main/household/providers/household_provider.dart';
import 'package:family_planner/features/main/household/providers/merchant_provider.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/core/mixins/interstitial_ad_mixin.dart';

class ExpenseFormScreen extends ConsumerStatefulWidget {
  /// null이면 추가 모드, non-null이면 수정 모드
  final ExpenseModel? expense;
  final String? groupId;
  /// 추가 모드에서 고정 지출 기본값 (기본: false)
  final bool initialIsRecurring;
  /// non-null이면 이 지출에 대한 환불 등록 모드
  final ExpenseModel? refundedExpense;

  const ExpenseFormScreen({
    super.key,
    this.expense,
    this.groupId,
    this.initialIsRecurring = false,
    this.refundedExpense,
  });

  @override
  ConsumerState<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends ConsumerState<ExpenseFormScreen>
    with InterstitialAdMixin {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _estimatedAmountController = TextEditingController();

  late DateTime _selectedDate;
  TransactionType _transactionType = TransactionType.expense;
  ExpenseCategory? _selectedCategory;
  PaymentMethod? _selectedPaymentMethod;
  String? _selectedMerchantId;
  IncomeCategory? _selectedIncomeCategory;
  // none / fixed / variable
  _RecurringType _recurringType = _RecurringType.none;

  bool get _isEditMode => widget.expense != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      final e = widget.expense!;
      _amountController.text = NumberFormat('#,###').format(e.amount.toInt());
      _descriptionController.text = e.description ?? '';
      _selectedDate = e.date;
      _transactionType = e.type;
      _selectedCategory = e.category;
      _selectedPaymentMethod = e.paymentMethod;
      _selectedMerchantId = e.merchant?.id;
      _selectedIncomeCategory = e.incomeCategory;
      if (e.isRecurring) {
        if (e.estimatedAmount != null) {
          _recurringType = _RecurringType.variable;
          _estimatedAmountController.text =
              NumberFormat('#,###').format(e.estimatedAmount!.toInt());
        } else {
          _recurringType = _RecurringType.fixed;
        }
      } else {
        _recurringType = _RecurringType.none;
      }
    } else if (widget.refundedExpense != null) {
      // 환불 등록 모드: INCOME으로 고정, 금액·날짜·설명 기본값 채움
      final origin = widget.refundedExpense!;
      _amountController.text = NumberFormat('#,###').format(origin.amount.toInt());
      _selectedDate = DateTime.now();
      _transactionType = TransactionType.income;
      _selectedIncomeCategory = IncomeCategory.otherIncome;
      _descriptionController.text = '환불';
    } else {
      _selectedDate = DateTime.now();
      _recurringType = widget.initialIsRecurring ? _RecurringType.fixed : _RecurringType.none;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _estimatedAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final managementState = ref.watch(householdManagementProvider);
    final isLoading = managementState is AsyncLoading;
    final groupsAsync = ref.watch(myGroupsProvider);
    final effectiveGroupId = widget.groupId ?? ref.watch(householdSelectedGroupIdProvider);
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
            Text(widget.refundedExpense != null
                ? l10n.household_refund
                : _isEditMode
                    ? (_transactionType == TransactionType.income
                        ? l10n.household_income
                        : l10n.household_expense)
                    : (_transactionType == TransactionType.income
                        ? l10n.household_income
                        : l10n.household_add_expense)),
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
          // 수정 모드 + 지출 타입 + 아직 환불 없음 → 환불 버튼
          if (_isEditMode &&
              widget.expense!.type == TransactionType.expense &&
              widget.expense!.refunds.isEmpty &&
              widget.refundedExpense == null)
            IconButton(
              icon: const Icon(Icons.undo),
              tooltip: l10n.household_refund,
              onPressed: () => context.push(
                AppRoutes.householdAdd,
                extra: {
                  'groupId': widget.expense!.groupId ?? widget.groupId,
                  'refundedExpense': widget.expense,
                },
              ),
            ),
          if (_isEditMode &&
              widget.expense!.shoppingHistoryId != null)
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              tooltip: l10n.household_view_shopping_history,
              onPressed: () {
                final historyId = widget.expense!.shoppingHistoryId!;
                final groupId = widget.expense!.groupId;
                final path = AppRoutes.shoppingHistoryDetail.replaceFirst(':historyId', historyId);
                final query = groupId != null ? '?groupId=$groupId' : '';
                context.push('$path$query');
              },
            ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(AppSizes.spaceM),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            )
          else
            TextButton(
              onPressed: _submit,
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: Text(l10n.common_save),
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSizes.spaceM),
            children: [
              _TypeToggle(
                value: _transactionType,
                onChanged: (v) => setState(() {
                  _transactionType = v;
                  if (v == TransactionType.income) {
                    _selectedCategory = null;
                    _selectedPaymentMethod = null;
                    _recurringType = _RecurringType.none;
                  } else {
                    _selectedIncomeCategory = null;
                  }
                }),
                incomeLabel: l10n.household_income,
                expenseLabel: l10n.household_expense,
              ),
              const SizedBox(height: AppSizes.spaceM),
              _AmountField(
                controller: _amountController,
                label: l10n.household_amount,
                hint: l10n.household_amount_hint,
                errorText: l10n.household_amount_required,
              ),
              if (_transactionType == TransactionType.income) ...[
                const SizedBox(height: AppSizes.spaceM),
                _IncomeCategorySelector(
                  selected: _selectedIncomeCategory,
                  onChanged: (v) => setState(() => _selectedIncomeCategory = v),
                  label: l10n.household_income_category,
                ),
              ],
              if (_transactionType == TransactionType.expense) ...[
                const SizedBox(height: AppSizes.spaceM),
                _CategorySelector(
                  selected: _selectedCategory,
                  onChanged: (v) => setState(() => _selectedCategory = v),
                  label: l10n.household_category,
                ),
                const SizedBox(height: AppSizes.spaceM),
                _PaymentMethodSelector(
                  selected: _selectedPaymentMethod,
                  onChanged: (v) => setState(() => _selectedPaymentMethod = v),
                  label: l10n.household_payment_method,
                ),
              ],
              const SizedBox(height: AppSizes.spaceM),
              _DateSelector(
                selectedDate: _selectedDate,
                onChanged: (v) => setState(() => _selectedDate = v),
                label: l10n.household_date,
              ),
              const SizedBox(height: AppSizes.spaceM),
              _DescriptionField(
                controller: _descriptionController,
                label: l10n.household_description,
                hint: l10n.household_description_hint,
              ),
              if (_transactionType == TransactionType.expense) ...[
                const SizedBox(height: AppSizes.spaceM),
                _MerchantSelector(
                  selectedId: _selectedMerchantId,
                  onChanged: (id) => setState(() => _selectedMerchantId = id),
                ),
                const SizedBox(height: AppSizes.spaceM),
                _RecurringTypeSelector(
                  value: _recurringType,
                  onChanged: (v) => setState(() => _recurringType = v),
                ),
                if (_recurringType == _RecurringType.variable) ...[
                  const SizedBox(height: AppSizes.spaceM),
                  _AmountField(
                    controller: _estimatedAmountController,
                    label: l10n.household_estimated_amount,
                    hint: l10n.household_estimated_amount_hint,
                    errorText: l10n.household_estimated_amount_required,
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    final amount = double.parse(_amountController.text.replaceAll(',', ''));
    final dateStr =
        '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';

    bool success;

    if (_isEditMode) {
      final dto = UpdateExpenseDto(
        type: _transactionType,
        amount: amount,
        category: _transactionType == TransactionType.income ? null : _selectedCategory,
        date: dateStr,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        paymentMethod: _transactionType == TransactionType.income ? null : _selectedPaymentMethod,
        merchantId: _transactionType == TransactionType.income ? null : _selectedMerchantId,
        merchantIdExplicitNull: _transactionType == TransactionType.expense && _selectedMerchantId == null,
        isRecurring: _transactionType == TransactionType.income
            ? false
            : _recurringType != _RecurringType.none,
        estimatedAmount: (_transactionType == TransactionType.expense &&
                _recurringType == _RecurringType.variable)
            ? double.tryParse(
                _estimatedAmountController.text.replaceAll(',', ''))
            : null,
        estimatedAmountExplicitNull: _transactionType == TransactionType.expense &&
            _recurringType != _RecurringType.variable,
        incomeCategory: _transactionType == TransactionType.income
            ? _selectedIncomeCategory
            : null,
      );
      final result = await ref
          .read(householdManagementProvider.notifier)
          .updateExpense(widget.expense!.id, dto);
      success = result != null;
    } else {
      final groupId = widget.groupId ??
          ref.read(householdSelectedGroupIdProvider);

      final dto = CreateExpenseDto(
        groupId: groupId,
        type: _transactionType,
        amount: amount,
        category: _transactionType == TransactionType.income ? null : _selectedCategory,
        date: dateStr,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        paymentMethod: _transactionType == TransactionType.income ? null : _selectedPaymentMethod,
        merchantId: _transactionType == TransactionType.income ? null : _selectedMerchantId,
        isRecurring: _transactionType == TransactionType.income
            ? false
            : _recurringType != _RecurringType.none,
        estimatedAmount: (_transactionType == TransactionType.expense &&
                _recurringType == _RecurringType.variable)
            ? double.tryParse(
                _estimatedAmountController.text.replaceAll(',', ''))
            : null,
        incomeCategory: _transactionType == TransactionType.income
            ? _selectedIncomeCategory
            : null,
        refundedExpenseId: widget.refundedExpense?.id,
      );
      final result = await ref
          .read(householdManagementProvider.notifier)
          .createExpense(dto);
      success = result != null;
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? l10n.household_save_success : l10n.common_error),
      ),
    );

    if (success) showInterstitialThenNavigate(() { if (mounted) Navigator.of(context).pop(); });
  }
}

// 금액 입력
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
    widget.controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() => setState(() {});

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
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
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

// 카테고리 선택
class _CategorySelector extends StatelessWidget {
  final ExpenseCategory? selected;
  final ValueChanged<ExpenseCategory?> onChanged;
  final String label;

  const _CategorySelector({
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
        child: DropdownButton<ExpenseCategory?>(
          value: selected,
          isExpanded: true,
          isDense: true,
          hint: Text(l10n.household_category),
          items: [
            ...ExpenseCategory.values.map(
              (c) => DropdownMenuItem(
                value: c,
                child: Row(
                  children: [
                    Icon(categoryIcon(c), size: 18, color: categoryColor(c)),
                    const SizedBox(width: AppSizes.spaceS),
                    Text(categoryName(l10n, c)),
                  ],
                ),
              ),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// 결제 수단 선택
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
            DropdownMenuItem(
              value: null,
              child: Text(l10n.household_payment_other),
            ),
            ...PaymentMethod.values.map(
              (m) => DropdownMenuItem(
                value: m,
                child: Text(paymentMethodName(l10n, m)),
              ),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// 날짜 선택
class _DateSelector extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onChanged;
  final String label;

  const _DateSelector({
    required this.selectedDate,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) onChanged(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          '${selectedDate.year}.${selectedDate.month.toString().padLeft(2, '0')}.${selectedDate.day.toString().padLeft(2, '0')}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}

// 내용 입력
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

// 거래 유형 토글 (입금 / 지출)
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
      style: ButtonStyle(
        iconColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            final isIncome = value == TransactionType.income;
            return isIncome ? Colors.green : Theme.of(context).colorScheme.error;
          }
          return null;
        }),
      ),
    );
  }
}

// 소비처 선택
class _MerchantSelector extends ConsumerWidget {
  final String? selectedId;
  final ValueChanged<String?> onChanged;

  const _MerchantSelector({
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final merchantsAsync = ref.watch(merchantsProvider);

    return merchantsAsync.when(
      data: (merchants) => InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.household_merchant_select,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceM,
            vertical: AppSizes.spaceS,
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.storefront_outlined, size: 18),
            tooltip: l10n.household_merchants,
            onPressed: () => context.push(AppRoutes.householdMerchants),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String?>(
            value: merchants.any((m) => m.id == selectedId) ? selectedId : null,
            isExpanded: true,
            isDense: true,
            hint: Text(
              merchants.isEmpty ? l10n.household_merchants_empty : l10n.household_merchant_none,
            ),
            items: [
              DropdownMenuItem(
                value: null,
                child: Text(l10n.household_merchant_none),
              ),
              ...merchants.map(
                (m) => DropdownMenuItem(
                  value: m.id,
                  child: Text(m.name),
                ),
              ),
            ],
            onChanged: merchants.isEmpty ? null : onChanged,
          ),
        ),
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

enum _RecurringType { none, fixed, variable }

// 입금 카테고리 선택
class _IncomeCategorySelector extends StatelessWidget {
  final IncomeCategory? selected;
  final ValueChanged<IncomeCategory?> onChanged;
  final String label;

  const _IncomeCategorySelector({
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
        child: DropdownButton<IncomeCategory?>(
          value: selected,
          isExpanded: true,
          isDense: true,
          hint: Text(label),
          items: [
            DropdownMenuItem(
              value: null,
              child: Text(l10n.household_income_category_other),
            ),
            ...IncomeCategory.values.map(
              (c) => DropdownMenuItem(
                value: c,
                child: Row(
                  children: [
                    Icon(incomeCategoryIcon(c), size: 18,
                        color: incomeCategoryColor(c)),
                    const SizedBox(width: AppSizes.spaceS),
                    Text(incomeCategoryName(l10n, c)),
                  ],
                ),
              ),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// 고정 지출 유형 선택 (없음 / 고정 금액 / 가변 금액)
class _RecurringTypeSelector extends StatelessWidget {
  final _RecurringType value;
  final ValueChanged<_RecurringType> onChanged;

  const _RecurringTypeSelector({
    required this.value,
    required this.onChanged,
  });

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
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceM,
          vertical: AppSizes.spaceS,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.repeat,
                    size: 18,
                    color: value != _RecurringType.none
                        ? colorScheme.primary
                        : colorScheme.outline),
                const SizedBox(width: AppSizes.spaceS),
                Text(
                  l10n.household_recurring_type_label,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceS),
            SegmentedButton<_RecurringType>(
              segments: [
                ButtonSegment(
                  value: _RecurringType.none,
                  label: Text(l10n.household_recurring_type_none),
                ),
                ButtonSegment(
                  value: _RecurringType.fixed,
                  label: Text(l10n.household_recurring_type_fixed),
                  icon: const Icon(Icons.lock_outline, size: 14),
                ),
                ButtonSegment(
                  value: _RecurringType.variable,
                  label: Text(l10n.household_recurring_type_variable),
                  icon: const Icon(Icons.tune, size: 14),
                ),
              ],
              selected: {value},
              onSelectionChanged: (s) => onChanged(s.first),
              style: const ButtonStyle(
                visualDensity: VisualDensity.compact,
              ),
            ),
            const SizedBox(height: AppSizes.spaceXS),
            if (value == _RecurringType.fixed)
              Text(
                l10n.household_recurring_type_fixed_desc,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              )
            else if (value == _RecurringType.variable)
              Text(
                l10n.household_recurring_type_variable_desc,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
          ],
        ),
      ),
    );
  }
}
