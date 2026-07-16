import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 체크 시 함께 보낼 기록 값
class RoutineCheckValue {
  final String? textValue;
  final num? numericValue;
  final String? timeValue;

  const RoutineCheckValue({this.textValue, this.numericValue, this.timeValue});
}

/// recordType(TEXT/NUMERIC/TIME)에 맞는 값을 입력받는 다이얼로그.
/// 사용자가 취소하면 null을 반환한다.
Future<RoutineCheckValue?> showRoutineCheckValueDialog(
  BuildContext context,
  RoutineRecordType recordType,
) {
  return showDialog<RoutineCheckValue>(
    context: context,
    builder: (context) => _RoutineCheckValueDialog(recordType: recordType),
  );
}

class _RoutineCheckValueDialog extends StatefulWidget {
  const _RoutineCheckValueDialog({required this.recordType});

  final RoutineRecordType recordType;

  @override
  State<_RoutineCheckValueDialog> createState() =>
      _RoutineCheckValueDialogState();
}

class _RoutineCheckValueDialogState extends State<_RoutineCheckValueDialog> {
  final _textController = TextEditingController();
  final _numericController = TextEditingController();
  TimeOfDay? _time;

  @override
  void dispose() {
    _textController.dispose();
    _numericController.dispose();
    super.dispose();
  }

  bool get _isValid {
    switch (widget.recordType) {
      case RoutineRecordType.text:
        return _textController.text.trim().isNotEmpty;
      case RoutineRecordType.numeric:
        return num.tryParse(_numericController.text.trim()) != null;
      case RoutineRecordType.time:
        return _time != null;
      case RoutineRecordType.boolean_:
        return true;
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _time = picked);
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _confirm() {
    final RoutineCheckValue value;
    switch (widget.recordType) {
      case RoutineRecordType.text:
        value = RoutineCheckValue(textValue: _textController.text.trim());
      case RoutineRecordType.numeric:
        value = RoutineCheckValue(
          numericValue: num.tryParse(_numericController.text.trim()),
        );
      case RoutineRecordType.time:
        value = RoutineCheckValue(timeValue: _formatTime(_time!));
      case RoutineRecordType.boolean_:
        value = const RoutineCheckValue();
    }
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    Widget content;
    switch (widget.recordType) {
      case RoutineRecordType.text:
        content = TextField(
          controller: _textController,
          maxLength: 500,
          autofocus: true,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: l10n.routine_check_dialog_text_label,
          ),
        );
      case RoutineRecordType.numeric:
        content = TextField(
          controller: _numericController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          autofocus: true,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: l10n.routine_check_dialog_numeric_label,
          ),
        );
      case RoutineRecordType.time:
        content = ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.routine_check_dialog_time_label),
          subtitle: Text(_time != null ? _formatTime(_time!) : '--:--'),
          trailing: const Icon(Icons.access_time),
          onTap: _pickTime,
        );
      case RoutineRecordType.boolean_:
        content = const SizedBox.shrink();
    }

    return AlertDialog(
      title: Text(l10n.routine_check_dialog_title),
      content: content,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.routine_check_dialog_cancel),
        ),
        FilledButton(
          onPressed: _isValid ? _confirm : null,
          child: Text(l10n.routine_check_dialog_confirm),
        ),
      ],
    );
  }
}
