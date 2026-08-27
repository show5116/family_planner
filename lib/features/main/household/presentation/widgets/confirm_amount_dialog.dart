import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/utils/thousands_formatter.dart';
import 'package:family_planner/features/main/household/data/models/expense_model.dart';
import 'package:family_planner/features/main/household/providers/household_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 미확정(예상 금액) 지출의 실제 금액을 바로 확정하는 다이얼로그를 띄운다.
///
/// 상세 → 수정 화면을 거치지 않고 금액만 고쳐 확정할 수 있게 하는 진입점.
/// 확정에 성공하면 갱신된 지출을, 취소하면 null을 반환한다.
Future<ExpenseModel?> showConfirmAmountDialog(
  BuildContext context,
  ExpenseModel expense,
) {
  return showDialog<ExpenseModel>(
    context: context,
    builder: (_) => ConfirmAmountDialog(expense: expense),
  );
}

class ConfirmAmountDialog extends ConsumerStatefulWidget {
  final ExpenseModel expense;

  const ConfirmAmountDialog({super.key, required this.expense});

  @override
  ConsumerState<ConfirmAmountDialog> createState() =>
      _ConfirmAmountDialogState();
}

class _ConfirmAmountDialogState extends ConsumerState<ConfirmAmountDialog> {
  late final TextEditingController _controller;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ThousandsFormatter.format(widget.expense.amount.toInt()),
    );
    // 예상 금액을 그대로 덮어쓸 수 있도록 전체 선택 상태로 시작
    _controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _controller.text.length,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final raw = _controller.text.replaceAll(',', '');
    final amount = double.tryParse(raw);
    if (amount == null || amount <= 0) return;

    setState(() => _saving = true);
    final l10n = AppLocalizations.of(context)!;
    final result = await ref
        .read(householdManagementProvider.notifier)
        .updateExpense(
          widget.expense.id,
          UpdateExpenseDto(amount: amount, isConfirmed: true),
        );
    if (!mounted) return;

    if (result == null) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.common_error)),
      );
      return;
    }

    // 확정 금액이 바뀌었으므로 고정지출 통계(평균/최소/최대) 캐시 무효화
    final recurringId = widget.expense.recurringExpenseId;
    if (recurringId != null) {
      ref.invalidate(recurringExpenseHistoryProvider(recurringId));
    }

    Navigator.of(context).pop(result);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.household_confirm_amount_success)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final title = widget.expense.description?.isNotEmpty == true
        ? widget.expense.description!
        : l10n.household_confirm_amount_title;

    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(height: AppSizes.spaceXS),
          Text(
            l10n.household_confirm_amount_estimated(
              ThousandsFormatter.format(widget.expense.amount.toInt()),
            ),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.household_confirm_amount_desc,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: AppSizes.spaceM),
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              ThousandsFormatter(),
            ],
            decoration: InputDecoration(
              labelText: l10n.household_amount,
              hintText: l10n.household_amount_hint,
              prefixText: '₩ ',
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) => _saving ? null : _submit(),
          ),
          _HistoryHintChips(
            expense: widget.expense,
            onSelected: (amount) {
              _controller.text = ThousandsFormatter.format(amount);
              _controller.selection = TextSelection.collapsed(
                offset: _controller.text.length,
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.household_confirm_amount_later),
        ),
        FilledButton(
          onPressed: _saving ? null : _submit,
          child: _saving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.household_confirm_amount_submit),
        ),
      ],
    );
  }
}

/// 과거 확정 금액을 한 번에 입력할 수 있는 힌트 칩 (가변 고정지출 항목에만 표시)
class _HistoryHintChips extends ConsumerWidget {
  final ExpenseModel expense;
  final ValueChanged<int> onSelected;

  const _HistoryHintChips({required this.expense, required this.onSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recurringId = expense.recurringExpenseId;
    if (recurringId == null) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    final history =
        ref.watch(recurringExpenseHistoryProvider(recurringId)).valueOrNull;
    if (history == null) return const SizedBox.shrink();

    // 이번 달 미확정 항목은 제외하고, 실제로 확정된 금액만 참고값으로 쓴다
    final confirmed = history.history
        .where((h) => h.isConfirmed && h.id != expense.id)
        .toList();

    final average = history.averageAmount?.toInt();
    final recent = confirmed.isNotEmpty ? confirmed.first.amount.toInt() : null;

    final chips = <Widget>[
      if (average != null && average > 0)
        _HintChip(
          label: l10n.household_confirm_amount_average,
          amount: average,
          onTap: () => onSelected(average),
        ),
      if (recent != null && recent > 0 && recent != average)
        _HintChip(
          label: l10n.household_confirm_amount_recent,
          amount: recent,
          onTap: () => onSelected(recent),
        ),
    ];
    if (chips.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.spaceS),
      child: Wrap(
        spacing: AppSizes.spaceS,
        runSpacing: AppSizes.spaceXS,
        children: chips,
      ),
    );
  }
}

class _HintChip extends StatelessWidget {
  final String label;
  final int amount;
  final VoidCallback onTap;

  const _HintChip({
    required this.label,
    required this.amount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ActionChip(
      onPressed: onTap,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      label: Text(
        '$label ${ThousandsFormatter.format(amount)}',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }
}
