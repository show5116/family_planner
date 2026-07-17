import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/data/repositories/routine_repository.dart';
import 'package:family_planner/features/main/routine/providers/routine_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';
import 'package:family_planner/shared/widgets/color_picker_row.dart';
import 'package:family_planner/shared/widgets/emoji_picker_field.dart';
import 'package:family_planner/shared/widgets/form_bottom_bar.dart';

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
  final _memoController = TextEditingController();

  String? _emoji = '✅';
  String? _selectedColor;
  RoutineFrequencyType _frequencyType = RoutineFrequencyType.weekly;
  RoutineWeeklyMode? _weeklyMode = RoutineWeeklyMode.countOnly;
  int _targetCount = 3;
  Set<int> _targetDays = {};
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  String? _selectedGroupId;
  String? _selectedCategoryId;
  RoutineImportance _importance = RoutineImportance.medium;
  RoutineTimeFilter? _timeFilter;
  RoutineRecordType _recordType = RoutineRecordType.boolean_;
  bool _initialized = false;
  bool _saving = false;
  String? _frequencyError;

  bool get _isEditing => widget.routineId != null;

  @override
  void dispose() {
    _titleController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  void _initFromRoutine(Routine routine) {
    if (_initialized) return;
    _initialized = true;
    _titleController.text = routine.title;
    _emoji = routine.emoji;
    _memoController.text = routine.memo ?? '';
    _selectedColor = routine.color;
    _frequencyType = routine.frequencyType;
    _weeklyMode = routine.weeklyMode;
    _targetCount = routine.targetCount ?? 3;
    _targetDays = routine.targetDays?.toSet() ?? {};
    _startDate = routine.startDate;
    _endDate = routine.endDate;
    _selectedGroupId = routine.routineGroupId;
    _selectedCategoryId = routine.categoryId;
    _importance = routine.importance;
    _timeFilter = routine.timeFilter;
    _recordType = routine.recordType;
  }

  void _onFrequencyTypeChanged(RoutineFrequencyType type) {
    setState(() {
      _frequencyType = type;
      _frequencyError = null;
      switch (type) {
        case RoutineFrequencyType.daily:
          _weeklyMode = null;
          _targetDays = {};
        case RoutineFrequencyType.weekly:
          _weeklyMode = RoutineWeeklyMode.countOnly;
          _targetCount = 3;
          _targetDays = {};
        case RoutineFrequencyType.monthly:
          _weeklyMode = null;
          _targetDays = {};
          _targetCount = 1;
      }
    });
  }

  void _onWeeklyModeChanged(RoutineWeeklyMode mode) {
    setState(() {
      _weeklyMode = mode;
      _frequencyError = null;
      if (mode == RoutineWeeklyMode.countOnly) {
        _targetCount = 3;
        _targetDays = {};
      } else {
        _targetDays = {};
      }
    });
  }

  /// 백엔드 validateFrequencyCombo와 동일한 조합 검증
  String? _validateFrequencyCombo(AppLocalizations l10n) {
    switch (_frequencyType) {
      case RoutineFrequencyType.daily:
        return null;
      case RoutineFrequencyType.weekly:
        if (_weeklyMode == null) {
          return l10n.routine_error_weekly_mode_required;
        }
        if (_weeklyMode == RoutineWeeklyMode.countOnly) {
          if (_targetCount < 1) {
            return l10n.routine_error_weekly_target_required;
          }
        } else {
          if (_targetDays.isEmpty) {
            return l10n.routine_error_fixed_days_required;
          }
        }
        return null;
      case RoutineFrequencyType.monthly:
        if (_targetCount < 1) {
          return l10n.routine_error_monthly_target_required;
        }
        return null;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _recordTypeLabel(AppLocalizations l10n, RoutineRecordType type) {
    switch (type) {
      case RoutineRecordType.boolean_:
        return l10n.routine_record_type_boolean;
      case RoutineRecordType.text:
        return l10n.routine_record_type_text;
      case RoutineRecordType.time:
        return l10n.routine_record_type_time;
      case RoutineRecordType.numeric:
        return l10n.routine_record_type_numeric;
    }
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

  /// 반복주기 조합에 맞는 필드만 골라 반환 (백엔드 검증 규칙과 정확히 대응)
  ({RoutineWeeklyMode? weeklyMode, int? targetCount, List<int>? targetDays})
  _buildFrequencyFields() {
    switch (_frequencyType) {
      case RoutineFrequencyType.daily:
        return (weeklyMode: null, targetCount: null, targetDays: null);
      case RoutineFrequencyType.weekly:
        if (_weeklyMode == RoutineWeeklyMode.fixedDays) {
          return (
            weeklyMode: RoutineWeeklyMode.fixedDays,
            targetCount: null,
            targetDays: _targetDays.toList()..sort(),
          );
        }
        return (
          weeklyMode: RoutineWeeklyMode.countOnly,
          targetCount: _targetCount,
          targetDays: null,
        );
      case RoutineFrequencyType.monthly:
        return (weeklyMode: null, targetCount: _targetCount, targetDays: null);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    final frequencyError = _validateFrequencyCombo(l10n);
    if (frequencyError != null) {
      setState(() => _frequencyError = frequencyError);
      return;
    }

    setState(() {
      _frequencyError = null;
      _saving = true;
    });

    final notifier = ref.read(routineManagementProvider.notifier);
    final title = _titleController.text.trim();
    final emoji = _emoji;
    final memo = _memoController.text.trim();
    final frequencyFields = _buildFrequencyFields();

    if (_isEditing) {
      await notifier.updateRoutine(
        widget.routineId!,
        UpdateRoutineDto(
          title: title,
          emoji: (emoji == null || emoji.isEmpty) ? null : emoji,
          color: _selectedColor,
          memo: memo.isEmpty ? null : memo,
          importance: _importance,
          timeFilter: _timeFilter,
          frequencyType: _frequencyType,
          weeklyMode: frequencyFields.weeklyMode,
          targetCount: frequencyFields.targetCount,
          targetDays: frequencyFields.targetDays,
          endDate: _endDate != null ? _formatDate(_endDate!) : null,
          routineGroupId: _selectedGroupId,
          clearRoutineGroupId: _selectedGroupId == null,
          categoryId: _selectedCategoryId,
          clearCategoryId: _selectedCategoryId == null,
        ),
      );
    } else {
      await notifier.createRoutine(
        CreateRoutineDto(
          title: title,
          emoji: (emoji == null || emoji.isEmpty) ? null : emoji,
          color: _selectedColor,
          memo: memo.isEmpty ? null : memo,
          importance: _importance,
          timeFilter: _timeFilter,
          categoryId: _selectedCategoryId,
          recordType: _recordType,
          frequencyType: _frequencyType,
          weeklyMode: frequencyFields.weeklyMode,
          targetCount: frequencyFields.targetCount,
          targetDays: frequencyFields.targetDays,
          startDate: _formatDate(_startDate),
          endDate: _endDate != null ? _formatDate(_endDate!) : null,
          routineGroupId: _selectedGroupId,
        ),
      );
    }

    if (!mounted) return;
    setState(() => _saving = false);

    final state = ref.read(routineManagementProvider);
    if (state.hasError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.routine_error_generic)));
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
          EmojiPickerField(
            selectedEmoji: _emoji,
            onEmojiChanged: (emoji) => setState(() => _emoji = emoji),
            controller: _titleController,
            maxLength: 100,
            labelText: l10n.routine_field_title,
            hintText: l10n.routine_field_title_hint,
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
          const SizedBox(height: AppSizes.spaceS),
          ColorPickerRow(
            label: l10n.routine_field_color,
            selectedColor: AppColors.parseHex(_selectedColor),
            availableColors: AppColors.routineColorPresets
                .map((hex) => AppColors.parseHex(hex))
                .toList(),
            onColorSelected: (color) =>
                setState(() => _selectedColor = AppColors.toHex(color)),
          ),
          const SizedBox(height: AppSizes.spaceL),
          SegmentedButton<RoutineFrequencyType>(
            segments: [
              ButtonSegment(
                value: RoutineFrequencyType.daily,
                label: Text(l10n.routine_frequency_type_daily),
              ),
              ButtonSegment(
                value: RoutineFrequencyType.weekly,
                label: Text(l10n.routine_frequency_type_weekly),
              ),
              ButtonSegment(
                value: RoutineFrequencyType.monthly,
                label: Text(l10n.routine_frequency_type_monthly),
              ),
            ],
            selected: {_frequencyType},
            onSelectionChanged: (s) => _onFrequencyTypeChanged(s.first),
          ),
          if (_frequencyType == RoutineFrequencyType.weekly) ...[
            const SizedBox(height: AppSizes.spaceS),
            SegmentedButton<RoutineWeeklyMode>(
              segments: [
                ButtonSegment(
                  value: RoutineWeeklyMode.countOnly,
                  label: Text(l10n.routine_weekly_mode_count_only),
                ),
                ButtonSegment(
                  value: RoutineWeeklyMode.fixedDays,
                  label: Text(l10n.routine_weekly_mode_fixed_days),
                ),
              ],
              selected: {_weeklyMode ?? RoutineWeeklyMode.countOnly},
              onSelectionChanged: (s) => _onWeeklyModeChanged(s.first),
            ),
          ],
          const SizedBox(height: AppSizes.spaceM),
          if (_frequencyType == RoutineFrequencyType.monthly ||
              (_frequencyType == RoutineFrequencyType.weekly &&
                  _weeklyMode == RoutineWeeklyMode.countOnly)) ...[
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
                  onPressed:
                      _targetCount <
                          (_frequencyType == RoutineFrequencyType.monthly
                              ? 31
                              : 7)
                      ? () => setState(() => _targetCount += 1)
                      : null,
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
          ],
          if (_frequencyType == RoutineFrequencyType.weekly &&
              _weeklyMode == RoutineWeeklyMode.fixedDays) ...[
            Text(
              l10n.routine_field_target_days,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: AppSizes.spaceS),
            Wrap(
              spacing: AppSizes.spaceS,
              children:
                  [
                    (0, l10n.routine_day_sun),
                    (1, l10n.routine_day_mon),
                    (2, l10n.routine_day_tue),
                    (3, l10n.routine_day_wed),
                    (4, l10n.routine_day_thu),
                    (5, l10n.routine_day_fri),
                    (6, l10n.routine_day_sat),
                  ].map((entry) {
                    final (day, label) = entry;
                    final selected = _targetDays.contains(day);
                    return FilterChip(
                      label: Text(label),
                      selected: selected,
                      onSelected: (value) => setState(() {
                        if (value) {
                          _targetDays.add(day);
                        } else {
                          _targetDays.remove(day);
                        }
                      }),
                    );
                  }).toList(),
            ),
          ],
          if (_frequencyError != null) ...[
            const SizedBox(height: AppSizes.spaceS),
            Text(
              _frequencyError!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: AppSizes.spaceL),
          TextFormField(
            controller: _memoController,
            maxLines: 3,
            maxLength: 500,
            decoration: InputDecoration(
              labelText: l10n.routine_field_memo,
              hintText: l10n.routine_field_memo_hint,
            ),
          ),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            l10n.routine_field_importance,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: AppSizes.spaceS),
          SegmentedButton<RoutineImportance>(
            segments: [
              ButtonSegment(
                value: RoutineImportance.low,
                label: Text(l10n.routine_importance_low),
              ),
              ButtonSegment(
                value: RoutineImportance.medium,
                label: Text(l10n.routine_importance_medium),
              ),
              ButtonSegment(
                value: RoutineImportance.high,
                label: Text(l10n.routine_importance_high),
              ),
            ],
            selected: {_importance},
            onSelectionChanged: (s) => setState(() => _importance = s.first),
          ),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            l10n.routine_field_time_filter,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: AppSizes.spaceS),
          Wrap(
            spacing: AppSizes.spaceS,
            children:
                [
                  (null, l10n.routine_time_filter_none),
                  (RoutineTimeFilter.morning, l10n.routine_time_filter_morning),
                  (
                    RoutineTimeFilter.afternoon,
                    l10n.routine_time_filter_afternoon,
                  ),
                  (RoutineTimeFilter.evening, l10n.routine_time_filter_evening),
                ].map((entry) {
                  final (value, label) = entry;
                  return ChoiceChip(
                    label: Text(label),
                    selected: _timeFilter == value,
                    onSelected: (_) => setState(() => _timeFilter = value),
                  );
                }).toList(),
          ),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            l10n.routine_field_record_type,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: AppSizes.spaceS),
          if (!_isEditing)
            SegmentedButton<RoutineRecordType>(
              segments: [
                ButtonSegment(
                  value: RoutineRecordType.boolean_,
                  label: Text(l10n.routine_record_type_boolean),
                ),
                ButtonSegment(
                  value: RoutineRecordType.text,
                  label: Text(l10n.routine_record_type_text),
                ),
                ButtonSegment(
                  value: RoutineRecordType.time,
                  label: Text(l10n.routine_record_type_time),
                ),
                ButtonSegment(
                  value: RoutineRecordType.numeric,
                  label: Text(l10n.routine_record_type_numeric),
                ),
              ],
              selected: {_recordType},
              onSelectionChanged: (s) => setState(() => _recordType = s.first),
            )
          else ...[
            Text(_recordTypeLabel(l10n, _recordType)),
            const SizedBox(height: 4),
            Text(
              l10n.routine_record_type_readonly_hint,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
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
          const SizedBox(height: AppSizes.spaceM),
          Consumer(
            builder: (context, ref, _) {
              final groupsAsync = ref.watch(routineGroupListProvider);
              return groupsAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
                data: (groups) {
                  final validGroupId =
                      groups.any((g) => g.id == _selectedGroupId)
                      ? _selectedGroupId
                      : null;
                  return DropdownButtonFormField<String?>(
                    initialValue: validGroupId,
                    decoration: InputDecoration(
                      labelText: l10n.routine_field_group,
                    ),
                    items: [
                      DropdownMenuItem<String?>(
                        value: null,
                        child: Text(l10n.routine_field_group_none),
                      ),
                      ...groups.map(
                        (group) => DropdownMenuItem<String?>(
                          value: group.id,
                          child: Text(
                            '${group.emoji ?? ''} ${group.title}'.trim(),
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) =>
                        setState(() => _selectedGroupId = value),
                  );
                },
              );
            },
          ),
          const SizedBox(height: AppSizes.spaceM),
          Consumer(
            builder: (context, ref, _) {
              final categoriesAsync = ref.watch(routineCategoryListProvider);
              return categoriesAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
                data: (categories) {
                  final validCategoryId =
                      categories.any((c) => c.id == _selectedCategoryId)
                      ? _selectedCategoryId
                      : null;
                  return DropdownButtonFormField<String?>(
                    initialValue: validCategoryId,
                    decoration: InputDecoration(
                      labelText: l10n.routine_field_category,
                    ),
                    items: [
                      DropdownMenuItem<String?>(
                        value: null,
                        child: Text(l10n.routine_field_category_none),
                      ),
                      ...categories.map(
                        (category) => DropdownMenuItem<String?>(
                          value: category.id,
                          child: Text(
                            '${category.emoji ?? ''} ${category.title}'.trim(),
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) =>
                        setState(() => _selectedCategoryId = value),
                  );
                },
              );
            },
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
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(child: _buildForm(context)),
              FormBottomBar(
                label: l10n.routine_save,
                isLoading: _saving,
                onPressed: _save,
              ),
            ],
          ),
        ),
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
          return SafeArea(
            top: false,
            child: Column(
              children: [
                Expanded(child: _buildForm(context)),
                FormBottomBar(
                  label: l10n.routine_save,
                  isLoading: _saving,
                  onPressed: _save,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
