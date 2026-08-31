import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/data/repositories/routine_repository.dart';
import 'package:family_planner/features/main/routine/providers/routine_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 챌린지 생성/수정 바텀시트.
///
/// [challenge]가 있으면 수정, 없으면 생성이다.
Future<void> showRoutineChallengeFormSheet(
  BuildContext context, {
  required String groupId,
  RoutineChallenge? challenge,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSizes.radiusLarge),
      ),
    ),
    builder: (_) => _ChallengeFormSheet(groupId: groupId, challenge: challenge),
  );
}

class _ChallengeFormSheet extends ConsumerStatefulWidget {
  const _ChallengeFormSheet({required this.groupId, this.challenge});

  final String groupId;
  final RoutineChallenge? challenge;

  @override
  ConsumerState<_ChallengeFormSheet> createState() =>
      _ChallengeFormSheetState();
}

class _ChallengeFormSheetState extends ConsumerState<_ChallengeFormSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _rewardController = TextEditingController();

  late DateTime _startDate;
  late DateTime _endDate;
  int _targetCount = 3;
  bool _saving = false;

  bool get _isEditing => widget.challenge != null;

  @override
  void initState() {
    super.initState();
    final c = widget.challenge;
    if (c != null) {
      _titleController.text = c.title;
      _descriptionController.text = c.description ?? '';
      _rewardController.text = c.reward ?? '';
      _startDate = c.startDate;
      _endDate = c.endDate;
      _targetCount = c.targetCount;
    } else {
      // 기본값은 오늘부터 이번 주 일요일까지. 가장 흔한 "이번 주" 챌린지를
      // 바로 만들 수 있도록.
      final now = DateTime.now();
      _startDate = DateTime(now.year, now.month, now.day);
      final daysToSunday = DateTime.sunday - now.weekday;
      _endDate = _startDate.add(
        Duration(days: daysToSunday < 0 ? 6 : daysToSunday),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _rewardController.dispose();
    super.dispose();
  }

  static String _formatDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  Future<void> _pickDate({required bool isStart}) async {
    final initial = isStart ? _startDate : _endDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
        // 시작일이 종료일을 넘으면 종료일을 함께 민다.
        if (_endDate.isBefore(_startDate)) _endDate = _startDate;
      } else {
        _endDate = picked.isBefore(_startDate) ? _startDate : picked;
      }
    });
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    setState(() => _saving = true);
    final description = _descriptionController.text.trim();
    final reward = _rewardController.text.trim();
    // 빈 문자열도 그대로 보낸다 — 수정에서 내용을 지운 경우 서버에서도
    // 지워져야 하므로, 필드를 생략(null)하면 안 된다.
    final dto = RoutineChallengeDto(
      title: title,
      description: description,
      startDate: _formatDate(_startDate),
      endDate: _formatDate(_endDate),
      targetCount: _targetCount,
      reward: reward,
    );

    final notifier = ref.read(routineManagementProvider.notifier);
    final ok = _isEditing
        ? await notifier.updateChallenge(
            widget.groupId,
            widget.challenge!.id,
            dto,
          )
        : await notifier.createChallenge(widget.groupId, dto) != null;

    if (!mounted) return;
    setState(() => _saving = false);

    if (!ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.routine_error_generic)));
      return;
    }
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.routine_challenge_saved)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final canSave = _titleController.text.trim().isNotEmpty && !_saving;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.spaceL,
              AppSizes.spaceL,
              AppSizes.spaceL,
              AppSizes.spaceS,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _isEditing
                        ? l10n.routine_challenge_edit
                        : l10n.routine_challenge_create,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                TextButton(
                  onPressed: canSave ? _save : null,
                  child: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(MaterialLocalizations.of(context).saveButtonLabel),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(AppSizes.spaceL),
              children: [
                TextField(
                  controller: _titleController,
                  maxLength: 50,
                  autofocus: !_isEditing,
                  decoration: InputDecoration(
                    labelText: l10n.routine_challenge_field_title,
                    hintText: l10n.routine_challenge_field_title_hint,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: AppSizes.spaceS),
                TextField(
                  controller: _descriptionController,
                  maxLength: 200,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: l10n.routine_challenge_field_description,
                  ),
                ),
                const SizedBox(height: AppSizes.spaceM),
                Text(
                  l10n.routine_challenge_field_period,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: AppSizes.spaceS),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _pickDate(isStart: true),
                        child: Text(_formatDate(_startDate)),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.spaceS,
                      ),
                      child: Text('~'),
                    ),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _pickDate(isStart: false),
                        child: Text(_formatDate(_endDate)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spaceL),
                Text(
                  l10n.routine_challenge_field_target,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: AppSizes.spaceS),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: _targetCount.toDouble(),
                        min: 1,
                        max: 30,
                        divisions: 29,
                        label: '$_targetCount',
                        onChanged: (value) =>
                            setState(() => _targetCount = value.round()),
                      ),
                    ),
                    SizedBox(
                      width: 48,
                      child: Text(
                        '$_targetCount',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Text(
                  l10n.routine_challenge_field_target_desc(_targetCount),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSizes.spaceL),
                TextField(
                  controller: _rewardController,
                  maxLength: 100,
                  decoration: InputDecoration(
                    labelText: l10n.routine_challenge_field_reward,
                    hintText: l10n.routine_challenge_field_reward_hint,
                    prefixIcon: const Icon(Icons.card_giftcard_outlined),
                  ),
                ),
                SizedBox(height: MediaQuery.paddingOf(context).bottom),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
