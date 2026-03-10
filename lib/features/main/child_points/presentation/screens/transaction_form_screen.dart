import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/child_points/data/models/childcare_model.dart';
import 'package:family_planner/features/main/child_points/data/repositories/childcare_repository.dart';
import 'package:family_planner/features/main/child_points/providers/childcare_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 포인트 거래 추가 화면 (부모만)
class TransactionFormScreen extends ConsumerStatefulWidget {
  const TransactionFormScreen({super.key, required this.accountId});

  final String accountId;

  @override
  ConsumerState<TransactionFormScreen> createState() =>
      _TransactionFormScreenState();
}

class _TransactionFormScreenState
    extends ConsumerState<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  ChildcareTransactionType _selectedType = ChildcareTransactionType.earn;
  bool _isSubmitting = false;

  static const _earnTypes = [
    ChildcareTransactionType.earn,
    ChildcareTransactionType.monthlyAllowance,
  ];

  static const _deductTypes = [
    ChildcareTransactionType.spend,
    ChildcareTransactionType.penalty,
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(l10n.childcare_add_transaction),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          children: [
            // 거래 유형 선택
            Text(
              l10n.childcare_transaction_type,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: AppSizes.spaceS),
            // 적립/차감 유형 선택
            RadioGroup<ChildcareTransactionType>(
              groupValue: _selectedType,
              onChanged: (v) => setState(() => _selectedType = v!),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: AppSizes.spaceS, top: AppSizes.spaceS),
                    child: Text('적립',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.green,
                            )),
                  ),
                  ..._earnTypes.map((type) =>
                      RadioListTile<ChildcareTransactionType>(
                        title: Text(_getTypeLabel(l10n, type)),
                        value: type,
                        dense: true,
                        activeColor: Colors.green,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: AppSizes.spaceS, top: AppSizes.spaceS),
                    child: Text('차감',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.red,
                            )),
                  ),
                  ..._deductTypes.map((type) =>
                      RadioListTile<ChildcareTransactionType>(
                        title: Text(_getTypeLabel(l10n, type)),
                        value: type,
                        dense: true,
                        activeColor: Colors.red,
                      )),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.spaceM),
            // 금액 입력
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.childcare_transaction_amount,
                prefixIcon: const Icon(Icons.star_rounded),
                suffixText: 'P',
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return '금액을 입력해주세요';
                final n = double.tryParse(v);
                if (n == null || n <= 0) return '올바른 금액을 입력해주세요';
                return null;
              },
            ),
            const SizedBox(height: AppSizes.spaceM),
            // 설명 입력
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: l10n.childcare_transaction_description,
                hintText: '예: 심부름 완료',
                prefixIcon: const Icon(Icons.notes),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? '설명을 입력해주세요' : null,
            ),
            const SizedBox(height: AppSizes.spaceXL),
            FilledButton(
              onPressed: _isSubmitting ? null : _handleSubmit,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.childcare_add_transaction),
            ),
          ],
        ),
      ),
    );
  }

  String _getTypeLabel(AppLocalizations l10n, ChildcareTransactionType type) {
    switch (type) {
      case ChildcareTransactionType.earn:
        return l10n.childcare_transaction_type_earn;
      case ChildcareTransactionType.spend:
        return l10n.childcare_transaction_type_spend;
      case ChildcareTransactionType.penalty:
        return l10n.childcare_transaction_type_penalty;
      case ChildcareTransactionType.monthlyAllowance:
        return l10n.childcare_transaction_type_monthly;
      case ChildcareTransactionType.savingsDeposit:
        return l10n.childcare_transaction_type_savings_deposit;
      case ChildcareTransactionType.savingsWithdraw:
        return l10n.childcare_transaction_type_savings_withdraw;
      case ChildcareTransactionType.interestPayment:
        return l10n.childcare_transaction_type_interest;
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final dto = CreateTransactionDto(
      type: _selectedType,
      amount: double.parse(_amountController.text),
      description: _descriptionController.text.trim(),
    );

    final result = await ref
        .read(childcareManagementProvider.notifier)
        .addTransaction(widget.accountId, dto);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('거래가 추가되었습니다')),
      );
      context.pop();
    }
  }
}
