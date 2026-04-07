import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/assets/data/models/asset_record_model.dart';
import 'package:family_planner/features/main/assets/data/repositories/asset_repository.dart'
    show DuplicateRecordDateException;
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

  // manual
  final _balanceController = TextEditingController();
  final _principalController = TextEditingController();
  final _profitController = TextEditingController();

  // auto
  final _currentBalanceController = TextEditingController();
  final _additionalPrincipalController = TextEditingController();

  final _noteController = TextEditingController();
  late DateTime _recordDate;
  RecordInputMode _inputMode = RecordInputMode.manual;
  bool _duplicateDateError = false;

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
    _currentBalanceController.dispose();
    _additionalPrincipalController.dispose();
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
      padding: EdgeInsets.only(
        left: AppSizes.spaceM,
        right: AppSizes.spaceM,
        top: AppSizes.spaceM,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.spaceM,
      ),
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
                  if (picked != null) {
                    setState(() {
                      _recordDate = picked;
                      _duplicateDateError = false;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_today, size: 16),
                label: Text('${l10n.asset_record_date}: $dateStr'),
              ),
              if (_duplicateDateError) ...[
                const SizedBox(height: AppSizes.spaceXS),
                Text(
                  l10n.asset_duplicate_date_error,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
              ],
              const SizedBox(height: AppSizes.spaceM),

              // 입력 방식 선택
              Text(l10n.asset_input_mode, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: AppSizes.spaceXS),
              SegmentedButton<RecordInputMode>(
                segments: [
                  ButtonSegment(
                    value: RecordInputMode.manual,
                    label: Text(l10n.asset_input_mode_manual),
                  ),
                  ButtonSegment(
                    value: RecordInputMode.auto,
                    label: Text(l10n.asset_input_mode_auto),
                  ),
                ],
                selected: {_inputMode},
                onSelectionChanged: (s) => setState(() => _inputMode = s.first),
              ),
              const SizedBox(height: AppSizes.spaceM),

              if (_inputMode == RecordInputMode.manual) ..._buildManualFields(l10n),
              if (_inputMode == RecordInputMode.auto) ..._buildAutoFields(l10n),

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

  List<Widget> _buildManualFields(AppLocalizations l10n) {
    return [
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
    ];
  }

  List<Widget> _buildAutoFields(AppLocalizations l10n) {
    return [
      TextFormField(
        controller: _additionalPrincipalController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: l10n.asset_additional_principal,
          hintText: l10n.asset_amount_hint,
          prefixText: '₩ ',
          border: const OutlineInputBorder(),
          helperText: l10n.asset_additional_principal_hint,
        ),
        validator: (v) =>
            (v == null || v.trim().isEmpty) ? l10n.asset_amount_required : null,
      ),
      const SizedBox(height: AppSizes.spaceS),
      TextFormField(
        controller: _currentBalanceController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: l10n.asset_current_balance,
          hintText: l10n.asset_amount_hint,
          prefixText: '₩ ',
          border: const OutlineInputBorder(),
        ),
        validator: (v) =>
            (v == null || v.trim().isEmpty) ? l10n.asset_amount_required : null,
      ),
      const SizedBox(height: AppSizes.spaceS),
    ];
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    final note = _noteController.text.trim();
    final dateStr =
        '${_recordDate.year}-${_recordDate.month.toString().padLeft(2, '0')}-${_recordDate.day.toString().padLeft(2, '0')}';

    final CreateAssetRecordDto dto;
    if (_inputMode == RecordInputMode.manual) {
      dto = CreateAssetRecordDto(
        recordDate: dateStr,
        inputMode: RecordInputMode.manual,
        balance: double.tryParse(_balanceController.text.trim()) ?? 0,
        principal: double.tryParse(_principalController.text.trim()) ?? 0,
        profit: double.tryParse(_profitController.text.trim()) ?? 0,
        note: note.isEmpty ? null : note,
      );
    } else {
      dto = CreateAssetRecordDto(
        recordDate: dateStr,
        inputMode: RecordInputMode.auto,
        currentBalance: double.tryParse(_currentBalanceController.text.trim()) ?? 0,
        additionalPrincipal: double.tryParse(_additionalPrincipalController.text.trim()) ?? 0,
        note: note.isEmpty ? null : note,
      );
    }

    try {
      final result = await ref.read(assetManagementProvider.notifier).createRecord(
            widget.accountId,
            dto,
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
    } on DuplicateRecordDateException {
      if (!mounted) return;
      setState(() => _duplicateDateError = true);
    }
  }
}
