import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/child_points/data/repositories/childcare_repository.dart';
import 'package:family_planner/features/main/child_points/providers/childcare_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 육아 계정 생성 화면 (부모만)
class ChildcareAccountFormScreen extends ConsumerStatefulWidget {
  const ChildcareAccountFormScreen({super.key, required this.groupId});

  final String groupId;

  @override
  ConsumerState<ChildcareAccountFormScreen> createState() =>
      _ChildcareAccountFormScreenState();
}

class _ChildcareAccountFormScreenState
    extends ConsumerState<ChildcareAccountFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _childUserIdController = TextEditingController();
  final _monthlyAllowanceController = TextEditingController();
  final _savingsRateController = TextEditingController(text: '2.50');
  bool _isSubmitting = false;

  @override
  void dispose() {
    _childUserIdController.dispose();
    _monthlyAllowanceController.dispose();
    _savingsRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.childcare_add_account),
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
            TextFormField(
              controller: _childUserIdController,
              decoration: InputDecoration(
                labelText: l10n.childcare_account_child_id,
                hintText: '자녀의 사용자 ID를 입력하세요',
                prefixIcon: const Icon(Icons.child_care),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? '자녀 ID를 입력해주세요' : null,
            ),
            const SizedBox(height: AppSizes.spaceM),
            TextFormField(
              controller: _monthlyAllowanceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.childcare_account_monthly_allowance,
                hintText: '예: 100',
                prefixIcon: const Icon(Icons.calendar_month),
                suffixText: 'P',
              ),
            ),
            const SizedBox(height: AppSizes.spaceM),
            TextFormField(
              controller: _savingsRateController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l10n.childcare_account_savings_rate,
                hintText: '예: 2.50',
                prefixIcon: const Icon(Icons.savings),
                suffixText: '%',
              ),
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
                  : Text(l10n.childcare_add_account),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final dto = CreateChildcareAccountDto(
      groupId: widget.groupId,
      childUserId: _childUserIdController.text.trim(),
      monthlyAllowance: double.tryParse(_monthlyAllowanceController.text),
      savingsInterestRate: _savingsRateController.text.trim().isEmpty
          ? null
          : _savingsRateController.text.trim(),
    );

    final result = await ref
        .read(childcareManagementProvider.notifier)
        .createAccount(dto);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('계정이 생성되었습니다')),
      );
      context.pop();
    }
  }
}
