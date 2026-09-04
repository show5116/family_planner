import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/child_points/data/models/childcare_model.dart';
import 'package:family_planner/features/main/child_points/data/repositories/childcare_repository.dart';
import 'package:family_planner/features/main/child_points/providers/childcare_provider.dart';
import 'package:family_planner/shared/widgets/form_bottom_bar.dart';

/// 보너스 포인트 지급 화면 (부모만)
class TransactionFormScreen extends ConsumerStatefulWidget {
  const TransactionFormScreen({super.key, required this.accountId});

  final String accountId;

  @override
  ConsumerState<TransactionFormScreen> createState() =>
      _TransactionFormScreenState();
}

class _TransactionFormScreenState extends ConsumerState<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isSubmitting = false;

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
      appBar: AppBar(
        title: Text(l10n.childcare_bonus_give),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(AppSizes.spaceM),
                  children: [
                    // 안내 문구
                    Card(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSizes.spaceM),
                        child: Row(
                          children: [
                            Icon(
                              Icons.card_giftcard_outlined,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: AppSizes.spaceS),
                            Expanded(
                              child: Text(
                                l10n.childcare_bonus_desc,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimaryContainer,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceM),
                    // 금액 입력
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: l10n.childcare_bonus_points,
                        prefixIcon: const Icon(Icons.star_rounded),
                        suffixText: 'P',
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return l10n.childcare_bonus_points_required;
                        }
                        final n = double.tryParse(v);
                        if (n == null || n <= 0) {
                          return l10n.childcare_bonus_points_positive;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.spaceM),
                    // 설명 입력
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: l10n.childcare_bonus_reason,
                        hintText: l10n.childcare_bonus_reason_hint,
                        prefixIcon: const Icon(Icons.notes),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? l10n.childcare_bonus_reason_required
                          : null,
                    ),
                  ],
                ),
              ),
            ),
            FormBottomBar(
              label: l10n.childcare_bonus_give,
              icon: Icons.card_giftcard_outlined,
              isLoading: _isSubmitting,
              onPressed: _handleSubmit,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
          final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final result = await ref
        .read(childcareManagementProvider.notifier)
        .addTransaction(
          widget.accountId,
          CreateTransactionDto.direct(
            type: ChildcareTransactionType.bonus,
            amount: double.parse(_amountController.text),
            description: _descriptionController.text.trim(),
          ),
        );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (result != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.childcare_bonus_given)));
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.childcare_save_failed)),
      );
    }
  }
}
