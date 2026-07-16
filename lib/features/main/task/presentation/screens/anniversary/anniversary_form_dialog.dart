import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/task/data/models/anniversary_model.dart';
import 'package:family_planner/features/main/task/providers/anniversary_provider.dart';
import 'package:family_planner/shared/widgets/emoji_picker_field.dart';

/// 기념일 생성/수정 다이얼로그
class AnniversaryFormDialog extends ConsumerStatefulWidget {
  final String groupId;
  final AnniversaryModel? anniversary;

  const AnniversaryFormDialog({
    super.key,
    required this.groupId,
    this.anniversary,
  });

  static Future<bool> show(
    BuildContext context, {
    required String groupId,
    AnniversaryModel? anniversary,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AnniversaryFormDialog(
        groupId: groupId,
        anniversary: anniversary,
      ),
    );
    return result ?? false;
  }

  @override
  ConsumerState<AnniversaryFormDialog> createState() =>
      _AnniversaryFormDialogState();
}

class _AnniversaryFormDialogState
    extends ConsumerState<AnniversaryFormDialog> {
  late final TextEditingController _titleController;
  late DateTime _selectedDate;
  String? _emoji;
  bool _every100Days = false;
  bool _everyYear = false;
  bool _isSubmitting = false;

  bool get isEditMode => widget.anniversary != null;

  @override
  void initState() {
    super.initState();
    final a = widget.anniversary;
    _titleController = TextEditingController(text: a?.title ?? '');
    _selectedDate = a?.date ?? DateTime.now();
    _emoji = a?.emoji;
    _every100Days = a?.milestoneConfig?.every100Days ?? false;
    _everyYear = a?.milestoneConfig?.everyYear ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('기념일 이름을 입력해 주세요')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final notifier =
        ref.read(anniversaryManagementProvider(widget.groupId).notifier);

    final milestoneConfig = (_every100Days || _everyYear)
        ? MilestoneConfig(every100Days: _every100Days, everyYear: _everyYear)
        : null;

    bool success;
    if (isEditMode) {
      final updated = await notifier.update(
        widget.anniversary!.id,
        title: title,
        date: _selectedDate,
        emoji: _emoji,
        milestoneConfig: milestoneConfig,
      );
      success = updated != null;
    } else {
      final created = await notifier.create(
        title: title,
        date: _selectedDate,
        emoji: _emoji,
        milestoneConfig: milestoneConfig,
      );
      success = created != null;
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isEditMode ? '수정에 실패했습니다' : '생성에 실패했습니다')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateStr =
        '${_selectedDate.year}.${_selectedDate.month.toString().padLeft(2, '0')}.${_selectedDate.day.toString().padLeft(2, '0')}';

    return AlertDialog(
      title: Text(isEditMode ? '기념일 수정' : '기념일 추가'),
      contentPadding: const EdgeInsets.fromLTRB(
        AppSizes.spaceL,
        AppSizes.spaceM,
        AppSizes.spaceL,
        0,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이모지 + 이름
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 이모지 버튼
                InkWell(
                  onTap: _pickEmoji,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _emoji ?? '🎂',
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.spaceM),
                // 이름
                Expanded(
                  child: TextField(
                    controller: _titleController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: '기념일 이름',
                      hintText: '예: 결혼기념일',
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceL),
            // 날짜 선택
            Text('날짜', style: theme.textTheme.labelMedium),
            const SizedBox(height: AppSizes.spaceXS),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceM,
                  vertical: AppSizes.spaceM,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.4),
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: AppSizes.spaceS),
                    Text(dateStr, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spaceM),
            // milestone 자동 생성 설정
            Text('기념일 알림 일정 자동 생성', style: theme.textTheme.labelMedium),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: const Text('100일 단위 (D+100, D+200…)'),
              value: _every100Days,
              onChanged: (v) => setState(() => _every100Days = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: const Text('매년 주년 (1주년, 2주년…)'),
              value: _everyYear,
              onChanged: (v) => setState(() => _everyYear = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: AppSizes.spaceS),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(false),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(isEditMode ? '수정' : '추가'),
        ),
      ],
    );
  }

  Future<void> _pickEmoji() async {
    final picked = await showEmojiPickerBottomSheet(context);
    if (picked != null) setState(() => _emoji = picked);
  }
}
