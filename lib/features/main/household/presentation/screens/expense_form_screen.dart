import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/household/data/models/expense_model.dart';
import 'package:family_planner/features/main/household/presentation/widgets/expense_list_item.dart';
import 'package:family_planner/features/main/household/providers/household_provider.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

class ExpenseFormScreen extends ConsumerStatefulWidget {
  /// null이면 추가 모드, non-null이면 수정 모드
  final ExpenseModel? expense;
  final String? groupId;
  /// 추가 모드에서 고정 지출 기본값 (기본: false)
  final bool initialIsRecurring;

  const ExpenseFormScreen({
    super.key,
    this.expense,
    this.groupId,
    this.initialIsRecurring = false,
  });

  @override
  ConsumerState<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends ConsumerState<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  late DateTime _selectedDate;
  TransactionType _transactionType = TransactionType.expense;
  ExpenseCategory? _selectedCategory;
  PaymentMethod? _selectedPaymentMethod;
  bool _isRecurring = false;

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
      _isRecurring = e.isRecurring;
    } else {
      _selectedDate = DateTime.now();
      _isRecurring = widget.initialIsRecurring;
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
            Text(_isEditMode
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
                    _isRecurring = false;
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
                _RecurringToggle(
                  value: _isRecurring,
                  onChanged: (v) => setState(() => _isRecurring = v),
                  label: l10n.household_recurring,
                ),
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
        isRecurring: _transactionType == TransactionType.income ? false : _isRecurring,
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
        isRecurring: _transactionType == TransactionType.income ? false : _isRecurring,
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

    if (success) Navigator.of(context).pop();
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

// 고정 지출 토글
class _RecurringToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;

  const _RecurringToggle({
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: SwitchListTile(
        title: Text(label),
        subtitle: const Text('매월 자동으로 반영됩니다'),
        value: value,
        onChanged: onChanged,
        secondary: Icon(
          Icons.repeat,
          color: value ? Theme.of(context).colorScheme.primary : null,
        ),
      ),
    );
  }
}
