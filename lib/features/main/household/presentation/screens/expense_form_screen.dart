import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/main/household/data/models/expense_model.dart';
import 'package:family_planner/features/main/household/data/models/merchant_model.dart';
import 'package:family_planner/features/main/household/presentation/widgets/expense_list_item.dart';
import 'package:family_planner/features/main/household/providers/household_provider.dart';
import 'package:family_planner/features/main/household/providers/merchant_provider.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
import 'package:family_planner/features/settings/groups/models/group_member.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/core/mixins/interstitial_ad_mixin.dart';
import 'package:family_planner/core/widgets/focus_dismiss_dropdown.dart';
import 'package:family_planner/shared/widgets/form_bottom_bar.dart';

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

  late DateTime _selectedDate;
  TransactionType _transactionType = TransactionType.expense;
  ExpenseCategory? _selectedCategory;
  PaymentMethod? _selectedPaymentMethod;
  String? _selectedMerchantId;
  IncomeCategory? _selectedIncomeCategory;
  String? _selectedMemberId; // 결제 주체 (그룹 모드 전용)
  ExpenseModel? _updatedExpense;

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
      _selectedMemberId = e.memberId;
    } else if (widget.refundedExpense != null) {
      // 환불 등록 모드: INCOME으로 고정, 금액·날짜·설명 기본값 채움
      final origin = widget.refundedExpense!;
      _amountController.text = NumberFormat(
        '#,###',
      ).format(origin.amount.toInt());
      _selectedDate = DateTime.now();
      _transactionType = TransactionType.income;
      _selectedIncomeCategory = IncomeCategory.otherIncome;
      _descriptionController.text = '환불';
    } else {
      _selectedDate = DateTime.now();
      // 추가 모드: 기본값은 본인 (그룹 모드에서 사용, 빌드 시 설정)
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 추가 모드에서 본인 userId를 기본 memberId로 설정
    if (!_isEditMode && _selectedMemberId == null) {
      final authState = ref.read(authProvider);
      if (authState.userId != null) {
        _selectedMemberId = authState.userId;
      }
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
    final effectiveGroupId =
        widget.groupId ?? ref.watch(householdSelectedGroupIdProvider);
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
            Text(
              widget.refundedExpense != null
                  ? l10n.household_refund
                  : _isEditMode
                  ? (_transactionType == TransactionType.income
                        ? l10n.household_income
                        : l10n.household_expense)
                  : (_transactionType == TransactionType.income
                        ? l10n.household_income
                        : l10n.household_add_expense),
            ),
            if (groupName != null)
              Text(
                groupName,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.white70),
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
          if (_isEditMode && widget.expense!.shoppingHistoryId != null)
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              tooltip: l10n.household_view_shopping_history,
              onPressed: () {
                final historyId = widget.expense!.shoppingHistoryId!;
                final groupId = widget.expense!.groupId;
                final path = AppRoutes.shoppingHistoryDetail.replaceFirst(
                  ':historyId',
                  historyId,
                );
                final query = groupId != null ? '?groupId=$groupId' : '';
                context.push('$path$query');
              },
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
                      label: l10n.household_amount,
                      hint: l10n.household_amount_hint,
                      errorText: l10n.household_amount_required,
                    ),
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
                        onChanged: (v) => setState(() => _selectedCategory = v),
                        label: l10n.household_category,
                      ),
                      const SizedBox(height: AppSizes.spaceM),
                      _PaymentMethodSelector(
                        selected: _selectedPaymentMethod,
                        onChanged: (v) =>
                            setState(() => _selectedPaymentMethod = v),
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
                        onChanged: (id) =>
                            setState(() => _selectedMerchantId = id),
                      ),
                      // 환불된 지출 — 연결된 환불 목록 표시
                      if (_isEditMode &&
                          widget.expense!.refunds.isNotEmpty) ...[
                        const SizedBox(height: AppSizes.spaceM),
                        _RefundLinksSection(
                          expense: widget.expense!,
                          groupId: widget.groupId,
                        ),
                      ],
                    ],
                    // 그룹 모드에서만 멤버 선택
                    if (effectiveGroupId != null) ...[
                      const SizedBox(height: AppSizes.spaceM),
                      _MemberSelector(
                        groupId: effectiveGroupId,
                        selectedUserId: _selectedMemberId,
                        transactionType: _transactionType,
                        onChanged: (userId) =>
                            setState(() => _selectedMemberId = userId),
                      ),
                    ],
                    // 환불 입금 — 원본 지출 연결 표시
                    if (_isEditMode &&
                        _transactionType == TransactionType.income &&
                        widget.expense!.refundedExpenseId != null) ...[
                      const SizedBox(height: AppSizes.spaceM),
                      _RefundOriginSection(
                        expense: widget.expense!,
                        groupId: widget.groupId,
                      ),
                    ],
                    const SizedBox(height: AppSizes.spaceM),
                  ],
                ),
              ),
              // 하단 고정 저장 버튼
              FormBottomBar(isLoading: isLoading, onPressed: _submit),
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
        category: _transactionType == TransactionType.income
            ? null
            : _selectedCategory,
        date: dateStr,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        paymentMethod: _transactionType == TransactionType.income
            ? null
            : _selectedPaymentMethod,
        merchantId: _transactionType == TransactionType.income
            ? null
            : _selectedMerchantId,
        merchantIdExplicitNull:
            _transactionType == TransactionType.expense &&
            _selectedMerchantId == null,
        incomeCategory: _transactionType == TransactionType.income
            ? _selectedIncomeCategory
            : null,
        memberId: _selectedMemberId,
      );
      final result = await ref
          .read(householdManagementProvider.notifier)
          .updateExpense(widget.expense!.id, dto);
      success = result != null;
      _updatedExpense = result;
    } else {
      final groupId =
          widget.groupId ?? ref.read(householdSelectedGroupIdProvider);

      final dto = CreateExpenseDto(
        groupId: groupId,
        type: _transactionType,
        amount: amount,
        category: _transactionType == TransactionType.income
            ? null
            : _selectedCategory,
        date: dateStr,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        paymentMethod: _transactionType == TransactionType.income
            ? null
            : _selectedPaymentMethod,
        merchantId: _transactionType == TransactionType.income
            ? null
            : _selectedMerchantId,
        incomeCategory: _transactionType == TransactionType.income
            ? _selectedIncomeCategory
            : null,
        refundedExpenseId: widget.refundedExpense?.id,
        memberId: groupId != null ? _selectedMemberId : null,
      );
      final result = await ref
          .read(householdManagementProvider.notifier)
          .createExpense(dto);
      success = result != null;
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? l10n.household_save_success : l10n.common_error,
        ),
      ),
    );

    if (success) {
      showInterstitialThenNavigate(() {
        if (mounted) Navigator.of(context).pop(_updatedExpense);
      });
    }
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

// 카테고리 바텀시트 그리드 선택
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
    final color = selected != null
        ? categoryColor(selected)
        : colorScheme.outline;
    final icon = selected != null
        ? categoryIcon(selected)
        : Icons.category_outlined;
    final name = selected != null
        ? categoryName(l10n, selected)
        : l10n.household_category;

    return InkWell(
      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      onTap: () async {
        FocusScope.of(context).unfocus();
        final result = await showModalBottomSheet<ExpenseCategory?>(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSizes.radiusLarge),
            ),
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
            Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: selected != null ? null : colorScheme.onSurfaceVariant,
              ),
            ),
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
          AppSizes.spaceM,
          AppSizes.spaceM,
          AppSizes.spaceM,
          AppSizes.spaceL,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceXS),
              child: Text(
                l10n.household_category,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
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
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  onTap: () => Navigator.of(ctx).pop(cat),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withValues(alpha: 0.15)
                          : colorScheme.surfaceContainerHighest.withValues(
                              alpha: 0.5,
                            ),
                      borderRadius: BorderRadius.circular(
                        AppSizes.radiusMedium,
                      ),
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
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
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
    return FocusDismissDropdown(
      child: InputDecorator(
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
        FocusScope.of(context).unfocus();
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
            return isIncome
                ? Colors.green
                : Theme.of(context).colorScheme.error;
          }
          return null;
        }),
      ),
    );
  }
}

// 소비처 바텀시트 선택
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
            FocusScope.of(context).unfocus();
            final result = await showModalBottomSheet<String?>(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppSizes.radiusLarge),
                ),
              ),
              builder: (ctx) =>
                  _MerchantSheet(merchants: merchants, selectedId: selectedId),
            );
            if (!context.mounted) return;
            // sheet는 _sentinel 값을 반환해 "선택 없음"과 "닫기"를 구분
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
                Icon(
                  Icons.storefront_outlined,
                  size: 18,
                  color: selectedName != null
                      ? colorScheme.primary
                      : colorScheme.outline,
                ),
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

// "닫기(X 버튼)"와 "없음 선택"을 구분하기 위한 sentinel
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
        padding: const EdgeInsets.fromLTRB(
          0,
          AppSizes.spaceM,
          0,
          AppSizes.spaceL,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM),
              child: Row(
                children: [
                  Text(
                    l10n.household_merchant_select,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
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
              // "없음" 옵션
              ListTile(
                leading: Icon(
                  Icons.remove_circle_outline,
                  color: colorScheme.outline,
                  size: 20,
                ),
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
                  leading: Icon(
                    Icons.storefront,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
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

// 수입 카테고리 바텀시트 그리드 선택
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
    final color = selected != null
        ? incomeCategoryColor(selected)
        : colorScheme.outline;
    final icon = selected != null
        ? incomeCategoryIcon(selected)
        : Icons.account_balance_wallet_outlined;
    final name = selected != null
        ? incomeCategoryName(l10n, selected)
        : l10n.household_income_category;

    return InkWell(
      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      onTap: () async {
        FocusScope.of(context).unfocus();
        final result = await showModalBottomSheet<IncomeCategory?>(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSizes.radiusLarge),
            ),
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
            Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: selected != null ? null : colorScheme.onSurfaceVariant,
              ),
            ),
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
          AppSizes.spaceM,
          AppSizes.spaceM,
          AppSizes.spaceM,
          AppSizes.spaceL,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceXS),
              child: Text(
                l10n.household_income_category,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
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
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  onTap: () => Navigator.of(ctx).pop(cat),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withValues(alpha: 0.15)
                          : colorScheme.surfaceContainerHighest.withValues(
                              alpha: 0.5,
                            ),
                      borderRadius: BorderRadius.circular(
                        AppSizes.radiusMedium,
                      ),
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
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
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

// 지출 항목에 연결된 환불 목록 표시
class _RefundLinksSection extends StatelessWidget {
  final ExpenseModel expense;
  final String? groupId;

  const _RefundLinksSection({required this.expense, this.groupId});

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
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.undo, size: 16, color: colorScheme.outline),
                const SizedBox(width: AppSizes.spaceS),
                Text(
                  l10n.household_refund_total,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceS),
            ...expense.refunds.map(
              (refund) => _RefundRow(refund: refund, groupId: groupId),
            ),
          ],
        ),
      ),
    );
  }
}

// 환불 입금 항목에서 원본 지출 표시
class _RefundOriginSection extends ConsumerWidget {
  final ExpenseModel expense;
  final String? groupId;

  const _RefundOriginSection({required this.expense, this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final originAsync = ref.watch(
      expenseByIdProvider(expense.refundedExpenseId!),
    );

    return originAsync.when(
      data: (origin) => Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
        child: InkWell(
          onTap: () => context.push(AppRoutes.householdDetail, extra: origin),
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.receipt_outlined,
                      size: 16,
                      color: colorScheme.outline,
                    ),
                    const SizedBox(width: AppSizes.spaceS),
                    Text(
                      l10n.household_refund_origin_label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: colorScheme.outline,
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spaceS),
                Row(
                  children: [
                    const SizedBox(width: 22),
                    Expanded(
                      child: Text(
                        origin.description?.isNotEmpty == true
                            ? origin.description!
                            : categoryName(l10n, origin.category),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '₩${_fmt(origin.amount)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.error,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 22, top: 2),
                  child: Text(
                    '${origin.date.year}.${origin.date.month.toString().padLeft(2, '0')}.${origin.date.day.toString().padLeft(2, '0')}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: colorScheme.outline),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  String _fmt(double amount) {
    final str = amount.toInt().toString();
    final buf = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write(',');
      buf.write(str[i]);
    }
    return buf.toString();
  }
}

// 멤버 선택 (그룹 모드 전용)
class _MemberSelector extends ConsumerWidget {
  final String groupId;
  final String? selectedUserId;
  final TransactionType transactionType;
  final ValueChanged<String?> onChanged;

  const _MemberSelector({
    required this.groupId,
    required this.selectedUserId,
    required this.transactionType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(groupMembersProvider(groupId));
    final colorScheme = Theme.of(context).colorScheme;
    final label = transactionType == TransactionType.income
        ? '받은 사람'
        : '결제한 사람';

    return membersAsync.when(
      data: (members) {
        if (members.isEmpty) return const SizedBox.shrink();

        final selected = members
            .where((m) => m.user?.id == selectedUserId)
            .firstOrNull;
        final displayName = selected?.user?.name ?? '선택 안함';

        return InkWell(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          onTap: () async {
            FocusScope.of(context).unfocus();
            final result = await showModalBottomSheet<String?>(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppSizes.radiusLarge),
                ),
              ),
              builder: (ctx) => _MemberSheet(
                members: members,
                selectedUserId: selectedUserId,
                title: label,
              ),
            );
            if (!context.mounted) return;
            if (result != _memberSheetClosed) onChanged(result);
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
                Icon(
                  Icons.person_outline,
                  size: 20,
                  color: selected != null
                      ? colorScheme.primary
                      : colorScheme.outline,
                ),
                const SizedBox(width: AppSizes.spaceS),
                Text(
                  displayName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: selected != null
                        ? null
                        : colorScheme.onSurfaceVariant,
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

const _memberSheetClosed = '__member_closed__';

class _MemberSheet extends StatelessWidget {
  final List<GroupMember> members;
  final String? selectedUserId;
  final String title;

  const _MemberSheet({
    required this.members,
    this.selectedUserId,
    this.title = '멤버 선택',
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          0,
          AppSizes.spaceM,
          0,
          AppSizes.spaceL,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM),
              child: Row(
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () =>
                        Navigator.of(context).pop(_memberSheetClosed),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ...members.map((m) {
              final isSelected = m.user?.id == selectedUserId;
              final name = m.user?.name ?? '알 수 없음';
              return ListTile(
                leading: CircleAvatar(
                  radius: 16,
                  backgroundColor: colorScheme.primaryContainer,
                  child: Text(
                    name.isNotEmpty ? name[0] : '?',
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                title: Text(name),
                trailing: isSelected
                    ? Icon(Icons.check, color: colorScheme.primary, size: 20)
                    : null,
                onTap: () => Navigator.of(context).pop(m.user?.id),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// 환불 항목 한 줄 표시
class _RefundRow extends StatelessWidget {
  final ExpenseModel refund;
  final String? groupId;

  const _RefundRow({required this.refund, this.groupId});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final date = '${refund.date.month}/${refund.date.day}';
    final amount = _fmt(refund.amount);

    return InkWell(
      onTap: () => context.push(AppRoutes.householdDetail, extra: refund),
      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(Icons.arrow_back, size: 14, color: Colors.teal),
            const SizedBox(width: AppSizes.spaceS),
            Text(
              refund.description?.isNotEmpty == true
                  ? refund.description!
                  : AppLocalizations.of(context)!.household_refund_origin_badge,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Spacer(),
            Text(
              '$date  +₩$amount',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.teal,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, size: 14, color: colorScheme.outline),
          ],
        ),
      ),
    );
  }

  String _fmt(double amount) {
    final str = amount.toInt().toString();
    final buf = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write(',');
      buf.write(str[i]);
    }
    return buf.toString();
  }
}
