import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/data/repositories/routine_repository.dart';
import 'package:family_planner/features/main/routine/providers/routine_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';

/// 루틴 생성/수정 폼 (routineId가 null이면 생성 모드)
class RoutineFormScreen extends ConsumerStatefulWidget {
  const RoutineFormScreen({super.key, this.routineId});

  final String? routineId;

  @override
  ConsumerState<RoutineFormScreen> createState() => _RoutineFormScreenState();
}

class _RoutineFormScreenState extends ConsumerState<RoutineFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _emojiController = TextEditingController();

  String? _selectedColor;
  int _targetCount = 3;
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  bool _initialized = false;
  bool _saving = false;

  bool get _isEditing => widget.routineId != null;

  @override
  void dispose() {
    _titleController.dispose();
    _emojiController.dispose();
    super.dispose();
  }

  void _initFromRoutine(Routine routine) {
    if (_initialized) return;
    _initialized = true;
    _titleController.text = routine.title;
    _emojiController.text = routine.emoji ?? '';
    _selectedColor = routine.color;
    _targetCount = routine.targetCount ?? 3;
    _startDate = routine.startDate;
    _endDate = routine.endDate;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate,
      firstDate: _startDate,
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _endDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final notifier = ref.read(routineManagementProvider.notifier);
    final title = _titleController.text.trim();
    final emoji = _emojiController.text.trim();

    if (_isEditing) {
      await notifier.updateRoutine(
        widget.routineId!,
        UpdateRoutineDto(
          title: title,
          emoji: emoji.isEmpty ? null : emoji,
          color: _selectedColor,
          targetCount: _targetCount,
          endDate: _endDate != null ? _formatDate(_endDate!) : null,
        ),
      );
    } else {
      await notifier.createRoutine(
        CreateRoutineDto(
          title: title,
          emoji: emoji.isEmpty ? null : emoji,
          color: _selectedColor,
          frequencyType: RoutineFrequencyType.weeklyCount,
          targetCount: _targetCount,
          startDate: _formatDate(_startDate),
          endDate: _endDate != null ? _formatDate(_endDate!) : null,
        ),
      );
    }

    if (!mounted) return;
    setState(() => _saving = false);

    final state = ref.read(routineManagementProvider);
    if (state.hasError) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.routine_error_generic)),
      );
      return;
    }

    if (mounted) Navigator.of(context).pop();
  }

  Widget _buildForm(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSizes.spaceM,
          AppSizes.spaceM,
          AppSizes.spaceM,
          AppSizes.spaceM + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          TextFormField(
            controller: _titleController,
            maxLength: 100,
            decoration: InputDecoration(
              labelText: l10n.routine_field_title,
              hintText: l10n.routine_field_title_hint,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.routine_field_title_required;
              }
              if (value.trim().length > 100) {
                return l10n.routine_field_title_too_long;
              }
              return null;
            },
          ),
          const SizedBox(height: AppSizes.spaceM),
          TextFormField(
            controller: _emojiController,
            maxLength: 4,
            decoration: InputDecoration(
              labelText: l10n.routine_field_emoji,
              helperText: l10n.routine_field_emoji_helper,
            ),
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(l10n.routine_field_color, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: AppSizes.spaceS),
          Wrap(
            spacing: AppSizes.spaceS,
            runSpacing: AppSizes.spaceS,
            children: AppColors.routineColorPresets.map((hex) {
              final color = AppColors.parseHex(hex);
              final selected = _selectedColor == hex;
              return InkWell(
                onTap: () => setState(() => _selectedColor = hex),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: selected
                        ? Border.all(
                            color: Theme.of(context).colorScheme.onSurface,
                            width: 2,
                          )
                        : null,
                  ),
                  child: selected
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : null,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSizes.spaceL),
          Text(
            l10n.routine_field_target_count,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          Row(
            children: [
              IconButton(
                onPressed: _targetCount > 1
                    ? () => setState(() => _targetCount -= 1)
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text(
                '$_targetCount',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                onPressed: _targetCount < 7
                    ? () => setState(() => _targetCount += 1)
                    : null,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceM),
          if (!_isEditing)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.routine_field_start_date),
              subtitle: Text(_formatDate(_startDate)),
              trailing: const Icon(Icons.calendar_today_outlined),
              onTap: _pickStartDate,
            ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.routine_field_end_date),
            subtitle: Text(
              _endDate != null
                  ? _formatDate(_endDate!)
                  : l10n.routine_field_end_date_none,
            ),
            trailing: _endDate != null
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() => _endDate = null),
                  )
                : const Icon(Icons.calendar_today_outlined),
            onTap: _pickEndDate,
          ),
          const SizedBox(height: AppSizes.spaceL),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.routine_save),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (!_isEditing) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.routine_add)),
        body: _buildForm(context),
      );
    }

    final detailAsync = ref.watch(routineDetailProvider(widget.routineId!));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.routine_edit)),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AppErrorState(
          error: error,
          title: l10n.routine_error_generic,
          onRetry: () =>
              ref.invalidate(routineDetailProvider(widget.routineId!)),
        ),
        data: (routine) {
          _initFromRoutine(routine);
          return _buildForm(context);
        },
      ),
    );
  }
}
