import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/child_points/data/models/childcare_model.dart';
import 'package:family_planner/features/main/child_points/data/repositories/childcare_repository.dart';
import 'package:family_planner/features/main/child_points/providers/childcare_provider.dart';

/// 보너스 포인트 지급 화면 (부모만)
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
  bool _isSubmitting = false;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('보너스 지급'),
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
                        '아이에게 보너스 포인트를 지급합니다.\n규칙이나 상점 외에 특별히 칭찬하고 싶을 때 사용하세요.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
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
              decoration: const InputDecoration(
                labelText: '지급 포인트',
                prefixIcon: Icon(Icons.star_rounded),
                suffixText: 'P',
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return '포인트를 입력해주세요';
                final n = double.tryParse(v);
                if (n == null || n <= 0) return '올바른 포인트를 입력해주세요';
                return null;
              },
            ),
            const SizedBox(height: AppSizes.spaceM),
            // 설명 입력
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: '지급 이유',
                hintText: '예: 방 청소를 스스로 해서',
                prefixIcon: Icon(Icons.notes),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? '지급 이유를 입력해주세요' : null,
            ),
            const SizedBox(height: AppSizes.spaceXL),
            FilledButton.icon(
              onPressed: _isSubmitting ? null : _handleSubmit,
              icon: _isSubmitting
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.card_giftcard_outlined),
              label: const Text('보너스 지급'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('보너스가 지급되었습니다')),
      );
      context.pop();
    }
  }
}
