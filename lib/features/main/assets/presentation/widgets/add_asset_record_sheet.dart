import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/assets/data/models/account_model.dart';
import 'package:family_planner/features/main/assets/data/models/asset_record_model.dart';
import 'package:family_planner/features/main/assets/data/repositories/asset_repository.dart'
    show DuplicateRecordDateException, assetRepositoryProvider;
import 'package:family_planner/features/main/assets/providers/asset_provider.dart';
import 'package:family_planner/features/main/assets/utils/asset_utils.dart';
import 'package:family_planner/l10n/app_localizations.dart';

const double _gramsPerDon = 3.75;

/// 천 단위 콤마를 자동으로 표시하는 TextInputFormatter
class _ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(',', '');
    if (digits.isEmpty) return newValue.copyWith(text: '');

    final number = int.tryParse(digits);
    if (number == null) return oldValue;

    final formatted = _formatWithComma(number);
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _formatWithComma(int value) {
    final str = value.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write(',');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }
}

enum _GoldWeightUnit { gram, don }

/// 자산 기록 추가 바텀시트
class AddAssetRecordSheet extends ConsumerStatefulWidget {
  final AccountModel account;

  const AddAssetRecordSheet({super.key, required this.account});

  @override
  ConsumerState<AddAssetRecordSheet> createState() => _AddAssetRecordSheetState();
}

class _AddAssetRecordSheetState extends ConsumerState<AddAssetRecordSheet> {
  final _formKey = GlobalKey<FormState>();

  // manual
  final _balanceController = TextEditingController();
  final _manualPrincipalController = TextEditingController();
  final _profitController = TextEditingController();

  // auto
  final _currentBalanceController = TextEditingController();
  final _additionalPrincipalController = TextEditingController();

  // gold
  final _weightController = TextEditingController();
  final _goldPrincipalController = TextEditingController();
  _GoldWeightUnit _weightUnit = _GoldWeightUnit.gram;
  bool _principalUserEdited = false;

  final _noteController = TextEditingController();
  late DateTime _recordDate;
  RecordInputMode _inputMode = RecordInputMode.manual;
  bool _duplicateDateError = false;

  // GOLD 시세
  double? _goldPricePerGram;
  bool _goldPriceLoading = false;
  bool _goldPriceError = false;

  bool get _isGold => widget.account.type == AccountType.gold;

  /// 입력값 → 그램 변환
  double? get _gramsFromInput {
    final raw = double.tryParse(_weightController.text.trim());
    if (raw == null || raw <= 0) return null;
    return _weightUnit == _GoldWeightUnit.don ? raw * _gramsPerDon : raw;
  }

  double? get _autoEstimatedPrincipal {
    final grams = _gramsFromInput;
    if (_goldPricePerGram == null || grams == null) return null;
    return _goldPricePerGram! * grams;
  }

  String _formatWithComma(int value) {
    final s = value.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  void _syncPrincipalIfNeeded() {
    if (_principalUserEdited) return;
    final estimated = _autoEstimatedPrincipal;
    if (estimated == null) {
      _goldPrincipalController.text = '';
    } else {
      _goldPrincipalController.text = _formatWithComma(estimated.toInt());
    }
  }

  @override
  void initState() {
    super.initState();
    _recordDate = DateTime.now();
    if (_isGold) {
      final existing = widget.account.gramWeight;
      if (existing != null) {
        _weightController.text = existing.toString();
      }
      WidgetsBinding.instance.addPostFrameCallback((_) => _fetchGoldPrice());
    }
  }

  @override
  void dispose() {
    _balanceController.dispose();
    _manualPrincipalController.dispose();
    _profitController.dispose();
    _currentBalanceController.dispose();
    _additionalPrincipalController.dispose();
    _weightController.dispose();
    _goldPrincipalController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _fetchGoldPrice() async {
    setState(() {
      _goldPriceLoading = true;
      _goldPriceError = false;
    });
    try {
      final price = await ref.read(assetRepositoryProvider).getGoldCurrentPrice();
      if (!mounted) return;
      setState(() {
        _goldPricePerGram = price;
        _goldPriceLoading = false;
        _syncPrincipalIfNeeded();
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _goldPriceLoading = false;
        _goldPriceError = true;
      });
    }
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

              if (_isGold) ...[
                ..._buildGoldFields(l10n),
              ] else ...[
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
              ],

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

  List<Widget> _buildGoldFields(AppLocalizations l10n) {
    final grams = _gramsFromInput;
    final showGramConverted =
        _weightUnit == _GoldWeightUnit.don && grams != null;

    return [
      // 단위 토글
      SegmentedButton<_GoldWeightUnit>(
        segments: [
          ButtonSegment(
            value: _GoldWeightUnit.gram,
            label: Text(l10n.asset_gold_unit_gram),
          ),
          ButtonSegment(
            value: _GoldWeightUnit.don,
            label: Text(l10n.asset_gold_unit_don),
          ),
        ],
        selected: {_weightUnit},
        onSelectionChanged: (s) {
          setState(() {
            _weightUnit = s.first;
            _weightController.clear();
            if (!_principalUserEdited) _goldPrincipalController.clear();
          });
        },
      ),
      const SizedBox(height: AppSizes.spaceM),

      // 보유 중량 입력
      TextFormField(
        controller: _weightController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: l10n.asset_gold_gram_weight,
          hintText: _weightUnit == _GoldWeightUnit.gram
              ? l10n.asset_gold_gram_weight_hint
              : l10n.asset_gold_don_hint,
          suffixText: _weightUnit == _GoldWeightUnit.gram ? 'g' : '돈',
          border: const OutlineInputBorder(),
          // 돈 입력 시 g 환산값 helper로 표시
          helperText: showGramConverted
              ? '${l10n.asset_gold_gram_converted}: ${grams.toStringAsFixed(2)}g'
              : null,
        ),
        onChanged: (_) {
          setState(() {
            _syncPrincipalIfNeeded();
          });
        },
        validator: (v) {
          if (v == null || v.trim().isEmpty) return l10n.asset_gold_gram_weight_required;
          if (double.tryParse(v.trim()) == null) return l10n.asset_gold_gram_weight_invalid;
          return null;
        },
      ),
      const SizedBox(height: AppSizes.spaceM),

      // 금 시세 정보 카드
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(120),
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: _goldPriceLoading
            ? Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: AppSizes.spaceS),
                  Text(l10n.asset_gold_price_loading,
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              )
            : _goldPriceError
                ? Row(
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          size: 18, color: Theme.of(context).colorScheme.error),
                      const SizedBox(width: AppSizes.spaceS),
                      Expanded(
                        child: Text(
                          l10n.asset_gold_price_error,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                        ),
                      ),
                      TextButton(onPressed: _fetchGoldPrice, child: const Text('재시도')),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.asset_gold_current_price_label,
                          style: Theme.of(context).textTheme.bodySmall),
                      Text(
                        _goldPricePerGram != null
                            ? '${formatAssetAmount(_goldPricePerGram!)}원/g'
                            : '-',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
      ),
      const SizedBox(height: AppSizes.spaceM),

      // 예상 원금 (편집 가능)
      TextFormField(
        controller: _goldPrincipalController,
        keyboardType: TextInputType.number,
        inputFormatters: [_ThousandsFormatter()],
        decoration: InputDecoration(
          labelText: l10n.asset_gold_estimated_principal,
          prefixText: '₩ ',
          border: const OutlineInputBorder(),
          suffixIcon: _principalUserEdited
              ? IconButton(
                  icon: const Icon(Icons.refresh, size: 18),
                  tooltip: '자동 계산으로 되돌리기',
                  onPressed: () => setState(() {
                    _principalUserEdited = false;
                    _syncPrincipalIfNeeded();
                  }),
                )
              : null,
        ),
        onChanged: (v) {
          // 자동 계산값과 다르면 사용자 편집으로 표시
          final auto = _autoEstimatedPrincipal;
          final parsed = double.tryParse(v.replaceAll(',', ''));
          final isAutoValue = auto != null && parsed == auto.toInt().toDouble();
          if (!isAutoValue) {
            _principalUserEdited = true;
          }
        },
        validator: (v) =>
            (v == null || v.trim().isEmpty) ? l10n.asset_amount_required : null,
      ),
      const SizedBox(height: AppSizes.spaceM),
    ];
  }

  List<Widget> _buildManualFields(AppLocalizations l10n) {
    return [
      TextFormField(
        controller: _balanceController,
        keyboardType: TextInputType.number,
        inputFormatters: [_ThousandsFormatter()],
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
        controller: _manualPrincipalController,
        keyboardType: TextInputType.number,
        inputFormatters: [_ThousandsFormatter()],
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
        inputFormatters: [_ThousandsFormatter()],
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
        inputFormatters: [_ThousandsFormatter()],
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
        inputFormatters: [_ThousandsFormatter()],
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

    if (_isGold) {
      final grams = _gramsFromInput ?? 0;
      final principal =
          double.tryParse(_goldPrincipalController.text.replaceAll(',', '')) ??
              _autoEstimatedPrincipal ??
              0;
      dto = CreateAssetRecordDto(
        recordDate: dateStr,
        inputMode: RecordInputMode.auto,
        currentBalance: principal,
        additionalPrincipal: principal,
        note: note.isEmpty ? null : note,
      );

      final result = await ref.read(assetManagementProvider.notifier).createRecord(
            widget.account.id,
            dto,
          );

      if (!mounted) return;
      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.common_error)),
        );
        return;
      }

      // gramWeight 변경 시 계좌 업데이트
      if (grams != widget.account.gramWeight) {
        await ref.read(assetManagementProvider.notifier).updateAccount(
              widget.account.id,
              UpdateAccountDto(gramWeight: grams),
            );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.asset_record_save_success)),
      );
      Navigator.of(context).pop();
      return;
    }

    if (_inputMode == RecordInputMode.manual) {
      dto = CreateAssetRecordDto(
        recordDate: dateStr,
        inputMode: RecordInputMode.manual,
        balance: double.tryParse(_balanceController.text.replaceAll(',', '')) ?? 0,
        principal: double.tryParse(_manualPrincipalController.text.replaceAll(',', '')) ?? 0,
        profit: double.tryParse(_profitController.text.replaceAll(',', '')) ?? 0,
        note: note.isEmpty ? null : note,
      );
    } else {
      dto = CreateAssetRecordDto(
        recordDate: dateStr,
        inputMode: RecordInputMode.auto,
        currentBalance:
            double.tryParse(_currentBalanceController.text.replaceAll(',', '')) ?? 0,
        additionalPrincipal:
            double.tryParse(_additionalPrincipalController.text.replaceAll(',', '')) ?? 0,
        note: note.isEmpty ? null : note,
      );
    }

    try {
      final result = await ref.read(assetManagementProvider.notifier).createRecord(
            widget.account.id,
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
