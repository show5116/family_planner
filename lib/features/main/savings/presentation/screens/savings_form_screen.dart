import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/savings/data/models/savings_model.dart';
import 'package:family_planner/features/main/savings/data/repositories/savings_repository.dart';

class SavingsFormScreen extends ConsumerStatefulWidget {
  const SavingsFormScreen({super.key, this.groupId, this.goal});

  /// 생성 시 필수
  final String? groupId;

  /// 수정 시 전달
  final SavingsGoalModel? goal;

  @override
  ConsumerState<SavingsFormScreen> createState() => _SavingsFormScreenState();
}

class _SavingsFormScreenState extends ConsumerState<SavingsFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _targetCtrl;
  late final TextEditingController _monthlyCtrl;
  late bool _autoDeposit;
  bool _loading = false;

  bool get _isEdit => widget.goal != null;

  @override
  void initState() {
    super.initState();
    final g = widget.goal;
    _nameCtrl = TextEditingController(text: g?.name ?? '');
    _descCtrl = TextEditingController(text: g?.description ?? '');
    _targetCtrl = TextEditingController(
      text: g?.targetAmount != null ? g!.targetAmount!.toInt().toString() : '',
    );
    _monthlyCtrl = TextEditingController(
      text: g?.monthlyAmount != null ? g!.monthlyAmount!.toInt().toString() : '',
    );
    _autoDeposit = g?.autoDeposit ?? false;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _targetCtrl.dispose();
    _monthlyCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final repo = ref.read(savingsRepositoryProvider);
      final name = _nameCtrl.text.trim();
      final desc = _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim();
      final target = _targetCtrl.text.trim().isEmpty
          ? null
          : double.tryParse(_targetCtrl.text.trim().replaceAll(',', ''));
      final monthly = _autoDeposit && _monthlyCtrl.text.trim().isNotEmpty
          ? double.tryParse(_monthlyCtrl.text.trim().replaceAll(',', ''))
          : null;

      SavingsGoalModel result;
      if (_isEdit) {
        result = await repo.updateGoal(
          widget.goal!.id,
          name: name,
          description: desc,
          targetAmount: target,
          autoDeposit: _autoDeposit,
          monthlyAmount: monthly,
        );
      } else {
        result = await repo.createGoal(
          groupId: widget.groupId!,
          name: name,
          description: desc,
          targetAmount: target,
          autoDeposit: _autoDeposit,
          monthlyAmount: monthly,
        );
      }

      if (mounted) Navigator.pop(context, result);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('저장 실패: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? '적립 목표 수정' : '적립 목표 추가'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          children: [
            // 이름
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: '목표 이름 *',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? '목표 이름을 입력해 주세요' : null,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSizes.spaceM),

            // 설명
            TextFormField(
              controller: _descCtrl,
              decoration: const InputDecoration(
                labelText: '설명 (선택)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSizes.spaceM),

            // 목표 금액
            TextFormField(
              controller: _targetCtrl,
              decoration: const InputDecoration(
                labelText: '목표 금액 (선택, 원)',
                border: OutlineInputBorder(),
                hintText: '예: 1000000',
              ),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return null;
                final parsed = double.tryParse(v.trim().replaceAll(',', ''));
                if (parsed == null || parsed <= 0) return '올바른 금액을 입력해 주세요';
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSizes.spaceM),

            // 자동 적립 스위치
            Card(
              margin: EdgeInsets.zero,
              child: SwitchListTile(
                title: const Text('자동 적립'),
                subtitle: const Text('매월 자동으로 적립합니다'),
                value: _autoDeposit,
                activeThumbColor: AppColors.investment,
                onChanged: (v) => setState(() => _autoDeposit = v),
              ),
            ),
            const SizedBox(height: AppSizes.spaceM),

            // 월 적립금 (autoDeposit=true 시만 표시)
            AnimatedCrossFade(
              firstChild: TextFormField(
                controller: _monthlyCtrl,
                decoration: const InputDecoration(
                  labelText: '월 적립금 (원)',
                  border: OutlineInputBorder(),
                  hintText: '예: 100000',
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (!_autoDeposit) return null;
                  if (v == null || v.trim().isEmpty) return '월 적립금을 입력해 주세요';
                  final parsed = double.tryParse(v.trim().replaceAll(',', ''));
                  if (parsed == null || parsed <= 0) return '올바른 금액을 입력해 주세요';
                  return null;
                },
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
              ),
              secondChild: const SizedBox.shrink(),
              crossFadeState: _autoDeposit
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 200),
            ),

            const SizedBox(height: AppSizes.spaceXL),

            // 저장 버튼
            SizedBox(
              height: AppSizes.buttonHeightLarge,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.investment,
                  foregroundColor: Colors.white,
                ),
                child: _loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : Text(_isEdit ? '수정 완료' : '목표 추가'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
