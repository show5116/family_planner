import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/utils/thousands_formatter.dart';
import 'package:family_planner/features/main/assets/data/models/holding_record_model.dart';
import 'package:family_planner/features/main/assets/data/repositories/asset_repository.dart';
import 'package:family_planner/features/main/assets/providers/asset_provider.dart';

class HoldingRecordFormSheet extends ConsumerStatefulWidget {
  final String accountId;
  final String recordDate;
  final HoldingRecordModel? existing;

  const HoldingRecordFormSheet({
    super.key,
    required this.accountId,
    required this.recordDate,
    this.existing,
  });

  @override
  ConsumerState<HoldingRecordFormSheet> createState() =>
      _HoldingRecordFormSheetState();
}

class _HoldingRecordFormSheetState
    extends ConsumerState<HoldingRecordFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _tickerCtrl;
  late final TextEditingController _amountCtrl;
  List<({String name, String? ticker})> _nameSuggestions = [];
  bool _loading = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existing?.name ?? '');
    _tickerCtrl = TextEditingController(text: widget.existing?.ticker ?? '');
    final existingAmount = widget.existing?.amount.toInt();
    _amountCtrl = TextEditingController(
      text: existingAmount != null ? ThousandsFormatter.format(existingAmount) : '',
    );
    _loadNameSuggestions();
  }

  Future<void> _loadNameSuggestions() async {
    final groupId = ref.read(assetSelectedGroupIdProvider);
    if (groupId == null) return;
    final repo = ref.read(assetRepositoryProvider);
    final names = await repo.getHoldingRecordNames(groupId);
    if (mounted) setState(() => _nameSuggestions = names);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _tickerCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSizes.spaceM,
        right: AppSizes.spaceM,
        top: AppSizes.spaceM,
        bottom: MediaQuery.of(context).viewInsets.bottom +
            MediaQuery.of(context).viewPadding.bottom +
            AppSizes.spaceM,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _isEdit ? '종목 수정' : '종목 추가',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSizes.spaceXS),
              Text(
                _formatDateLabel(widget.recordDate),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
              const SizedBox(height: AppSizes.spaceM),

              // 종목명 (자동완성)
              Autocomplete<({String name, String? ticker})>(
                initialValue: TextEditingValue(text: _nameCtrl.text),
                displayStringForOption: (s) => s.name,
                optionsBuilder: (value) {
                  if (value.text.isEmpty) return _nameSuggestions;
                  return _nameSuggestions.where(
                    (s) => s.name.toLowerCase().contains(value.text.toLowerCase()),
                  );
                },
                onSelected: (s) {
                  _nameCtrl.text = s.name;
                  if (s.ticker != null) _tickerCtrl.text = s.ticker!;
                },
                fieldViewBuilder: (ctx, controller, focusNode, _) {
                  controller.addListener(() => _nameCtrl.text = controller.text);
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      labelText: '종목명',
                      hintText: '예: 나스닥 ETF, 삼성전자',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? '종목명을 입력해주세요' : null,
                  );
                },
                optionsViewBuilder: (ctx, onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: options.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (_, i) {
                            final option = options.elementAt(i);
                            return ListTile(
                              dense: true,
                              title: Text(option.name),
                              subtitle: option.ticker != null
                                  ? Text(option.ticker!,
                                      style: const TextStyle(fontSize: 12))
                                  : null,
                              onTap: () => onSelected(option),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSizes.spaceM),

              // 티커 (선택)
              TextFormField(
                controller: _tickerCtrl,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: '티커 (선택)',
                  hintText: '예: QQQ, 005930',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSizes.spaceM),

              // 금액
              TextFormField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [ThousandsFormatter()],
                decoration: const InputDecoration(
                  labelText: '금액',
                  hintText: '예: 2,000,000',
                  prefixText: '₩ ',
                  border: OutlineInputBorder(),
                  helperText: '비율은 잔액 기준으로 자동 계산됩니다',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return '금액을 입력해주세요';
                  final n = double.tryParse(v.trim().replaceAll(',', ''));
                  if (n == null || n <= 0) return '유효한 금액을 입력해주세요';
                  return null;
                },
              ),

              const SizedBox(height: AppSizes.spaceL),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48)),
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateLabel(String date) {
    final parts = date.split('-');
    return '${parts[0]}년 ${int.parse(parts[1])}월 ${int.parse(parts[2])}일';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final name = _nameCtrl.text.trim();
    final ticker = _tickerCtrl.text.trim();
    final amount = double.parse(_amountCtrl.text.trim().replaceAll(',', ''));
    final notifier = ref.read(
      holdingRecordsProvider(
              (accountId: widget.accountId, recordDate: widget.recordDate))
          .notifier,
    );

    try {
      if (_isEdit) {
        await notifier.update(
          widget.existing!.id,
          UpdateHoldingRecordDto(
            name: name,
            ticker: ticker.isEmpty ? null : ticker,
            amount: amount,
          ),
        );
      } else {
        await notifier.create(
          CreateHoldingRecordDto(
            recordDate: widget.recordDate,
            name: name,
            ticker: ticker.isEmpty ? null : ticker,
            amount: amount,
          ),
        );
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      }
    }
  }
}
