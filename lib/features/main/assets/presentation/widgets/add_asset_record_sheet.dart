import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/assets/data/models/asset_record_model.dart';
import 'package:family_planner/features/main/assets/providers/asset_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 자산 기록 추가 바텀시트
class AddAssetRecordSheet extends ConsumerStatefulWidget {
  final String accountId;

  const AddAssetRecordSheet({super.key, required this.accountId});

  @override
  ConsumerState<AddAssetRecordSheet> createState() => _AddAssetRecordSheetState();
}

class _AddAssetRecordSheetState extends ConsumerState<AddAssetRecordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _balanceController = TextEditingController();
  final _principalController = TextEditingController();
  final _profitController = TextEditingController();
  final _noteController = TextEditingController();
  late DateTime _recordDate;

  @override
  void initState() {
    super.initState();
    _recordDate = DateTime.now();
  }

  @override
  void dispose() {
    _balanceController.dispose();
    _principalController.dispose();
    _profitController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final managementState = ref.watch(assetManagementProvider);
    final dateStr =
        '${_recordDate.year}-${_recordDate.month.toString().padLeft(2, '0')}-${_recordDate.day.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.asset_add_record,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSizes.spaceM),

              // 날짜 선택
              OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _recordDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => _recordDate = picked);
                },
                icon: const Icon(Icons.calendar_today, size: 16),
                label: Text('${l10n.asset_record_date}: $dateStr'),
              ),
              const SizedBox(height: AppSizes.spaceM),

              // 잔액
              TextFormField(
                controller: _balanceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.asset_balance,
                  hintText: l10n.asset_amount_hint,
                  prefixText: '₩ ',
                  border: const OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l10n.asset_amount_required : null,
              ),
              const SizedBox(height: AppSizes.spaceS),

              // 원금
              TextFormField(
                controller: _principalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.asset_principal,
                  hintText: l10n.asset_amount_hint,
                  prefixText: '₩ ',
                  border: const OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l10n.asset_amount_required : null,
              ),
              const SizedBox(height: AppSizes.spaceS),

              // 수익금
              TextFormField(
                controller: _profitController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.asset_profit,
                  hintText: l10n.asset_amount_hint,
                  prefixText: '₩ ',
                  border: const OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l10n.asset_amount_required : null,
              ),
              const SizedBox(height: AppSizes.spaceS),

              // 메모
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: l10n.asset_note,
                  hintText: l10n.asset_note_hint,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSizes.spaceM),

              ElevatedButton(
                onPressed: managementState.isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: managementState.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.common_save),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    final balance = double.tryParse(_balanceController.text.trim()) ?? 0;
    final principal = double.tryParse(_principalController.text.trim()) ?? 0;
    final profit = double.tryParse(_profitController.text.trim()) ?? 0;
    final note = _noteController.text.trim();
    final dateStr =
        '${_recordDate.year}-${_recordDate.month.toString().padLeft(2, '0')}-${_recordDate.day.toString().padLeft(2, '0')}';

    final result = await ref.read(assetManagementProvider.notifier).createRecord(
          widget.accountId,
          CreateAssetRecordDto(
            recordDate: dateStr,
            balance: balance,
            principal: principal,
            profit: profit,
            note: note.isEmpty ? null : note,
          ),
        );

    if (!mounted) return;

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.asset_record_save_success)),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.common_error)),
      );
    }
  }
}
