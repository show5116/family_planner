import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/assets/data/models/withdrawal_model.dart';
import 'package:family_planner/features/main/assets/providers/asset_provider.dart';

// ─── 천 단위 콤마 포매터 ──────────────────────────────────────────────────────
class _ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue old, TextEditingValue nw) {
    final digits = nw.text.replaceAll(',', '');
    if (digits.isEmpty) return nw.copyWith(text: '');
    final n = int.tryParse(digits);
    if (n == null) return old;
    final formatted = _fmt(n);
    return nw.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _fmt(int v) {
    final s = v.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

// ─── 출금 추가 바텀시트 ────────────────────────────────────────────────────────
class AddWithdrawalSheet extends ConsumerStatefulWidget {
  final String accountId;

  const AddWithdrawalSheet({super.key, required this.accountId});

  @override
  ConsumerState<AddWithdrawalSheet> createState() => _AddWithdrawalSheetState();
}

class _AddWithdrawalSheetState extends ConsumerState<AddWithdrawalSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  WithdrawalType? _type = WithdrawalType.principal;
  bool _typeError = false;
  late DateTime _date;
  bool _loading = false;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _date = DateTime.now();
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  String get _dateStr =>
      '${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSizes.spaceM,
        right: AppSizes.spaceM,
        top: AppSizes.spaceM,
        bottom: MediaQuery.of(context).viewInsets.bottom +
            MediaQuery.of(context).padding.bottom +
            AppSizes.spaceM,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('출금 기록', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSizes.spaceM),

              // 날짜 선택
              OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today, size: 16),
                label: Text('출금 날짜: $_dateStr'),
              ),
              const SizedBox(height: AppSizes.spaceM),

              // 출금 유형
              Row(
                children: [
                  Text('출금 유형', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(width: 4),
                  Text(
                    '(필수)',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '출금한 금액이 원금에서 나간 것인지, 수익에서 나간 것인지 선택해 주세요.\n잔액 기록 시 원금과 수익을 자동으로 재계산하는 데 사용됩니다.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
              const SizedBox(height: AppSizes.spaceS),
              _WithdrawalTypeSelector(
                selected: _type,
                onChanged: (t) => setState(() { _type = t; _typeError = false; }),
              ),
              if (_typeError) ...[
                const SizedBox(height: 4),
                Text(
                  '출금 유형을 선택해 주세요',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
              ],
              const SizedBox(height: AppSizes.spaceM),

              // 금액
              TextFormField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [_ThousandsFormatter()],
                decoration: const InputDecoration(
                  labelText: '출금 금액',
                  prefixText: '₩ ',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return '금액을 입력해주세요';
                  final n = double.tryParse(v.replaceAll(',', ''));
                  if (n == null || n <= 0) return '유효한 금액을 입력해주세요';
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.spaceM),

              // 메모
              TextFormField(
                controller: _noteCtrl,
                decoration: const InputDecoration(
                  labelText: '메모 (선택)',
                  hintText: '예: 생활비, 수익 실현',
                  border: OutlineInputBorder(),
                ),
              ),

              if (_errorMsg != null) ...[
                const SizedBox(height: AppSizes.spaceS),
                Text(_errorMsg!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ],

              const SizedBox(height: AppSizes.spaceL),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                child: _loading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _submit() async {
    if (_type == null) {
      setState(() => _typeError = true);
    }
    if (!_formKey.currentState!.validate() || _type == null) return;
    setState(() { _loading = true; _errorMsg = null; });

    final amount = double.parse(_amountCtrl.text.replaceAll(',', ''));
    final note = _noteCtrl.text.trim();

    final dto = CreateWithdrawalDto(
      withdrawalDate: _dateStr,
      amount: amount,
      type: _type!,
      note: note.isEmpty ? null : note,
    );

    try {
      final result = await ref
          .read(assetManagementProvider.notifier)
          .createWithdrawal(widget.accountId, dto);

      if (!mounted) return;
      if (result != null) {
        ref.read(assetWithdrawalsProvider(widget.accountId).notifier)
            .addWithdrawal(result);
        Navigator.of(context).pop();
      } else {
        setState(() { _loading = false; _errorMsg = '저장에 실패했습니다.'; });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMsg = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }
}

// ─── 출금 유형 선택 위젯 ──────────────────────────────────────────────────────
class _WithdrawalTypeSelector extends StatelessWidget {
  final WithdrawalType? selected;
  final ValueChanged<WithdrawalType> onChanged;

  const _WithdrawalTypeSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TypeTile(
          type: WithdrawalType.principal,
          selected: selected == WithdrawalType.principal,
          onTap: () => onChanged(WithdrawalType.principal),
        ),
        const SizedBox(height: AppSizes.spaceXS),
        _TypeTile(
          type: WithdrawalType.profit,
          selected: selected == WithdrawalType.profit,
          onTap: () => onChanged(WithdrawalType.profit),
        ),
      ],
    );
  }
}

class _TypeTile extends StatelessWidget {
  final WithdrawalType type;
  final bool selected;
  final VoidCallback onTap;

  const _TypeTile({required this.type, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isPrincipal = type == WithdrawalType.principal;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM, vertical: AppSizes.spaceS),
        decoration: BoxDecoration(
          color: selected ? colorScheme.primaryContainer : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          border: Border.all(
            color: selected ? colorScheme.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isPrincipal ? Icons.savings_outlined : Icons.trending_up,
              size: 20,
              color: selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSizes.spaceS),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    withdrawalTypeLabel(type),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: selected ? colorScheme.primary : colorScheme.onSurface,
                        ),
                  ),
                  Text(
                    isPrincipal ? '원금에서 차감 (생활비, 계좌 이동 등)' : '수익에서 차감 (세금, 수익 인출 등)',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.outline,
                        ),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(Icons.check_circle, size: 18, color: colorScheme.primary),
          ],
        ),
      ),
    );
  }
}

