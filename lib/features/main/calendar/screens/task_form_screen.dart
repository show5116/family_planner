import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/main/calendar/data/models/task_model.dart';
import 'package:family_planner/features/main/calendar/data/repositories/task_repository.dart';
import 'package:family_planner/features/main/calendar/providers/task_provider.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 일정 추가/수정 화면
class TaskFormScreen extends ConsumerStatefulWidget {
  /// 수정할 Task ID (null이면 신규 작성)
  final String? taskId;

  /// 수정할 Task 데이터 (수정 모드)
  final TaskModel? task;

  /// 선택된 날짜 (신규 작성 시 기본값)
  final DateTime? initialDate;

  const TaskFormScreen({
    super.key,
    this.taskId,
    this.task,
    this.initialDate,
  });

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  late DateTime _startDate;
  DateTime? _dueDate;
  TimeOfDay? _startTime;
  TimeOfDay? _dueTime;
  bool _isAllDay = true;
  bool _hasDueDate = false;
  TaskPriority _priority = TaskPriority.medium;
  RecurringRuleType? _recurringType;
  List<int> _selectedReminders = []; // 분 단위 오프셋

  CategoryModel? _selectedCategory;
  bool _isLoadingCategories = true;
  List<CategoryModel> _categories = [];

  bool _isSubmitting = false;

  bool get _isEditMode => widget.task != null;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialDate ?? DateTime.now();

    if (_isEditMode) {
      _initEditMode();
    }

    _loadCategories();
  }

  void _initEditMode() {
    final task = widget.task!;
    _titleController.text = task.title;
    _descriptionController.text = task.description ?? '';
    _locationController.text = task.location ?? '';

    if (task.scheduledAt != null) {
      _startDate = task.scheduledAt!;
      _isAllDay = task.isAllDay;
      if (!_isAllDay) {
        _startTime = TimeOfDay.fromDateTime(task.scheduledAt!);
      }
    }

    // 마감 날짜 설정
    if (task.dueAt != null) {
      _hasDueDate = true;
      _dueDate = task.dueAt!;
      if (!_isAllDay) {
        _dueTime = TimeOfDay.fromDateTime(task.dueAt!);
      }
    }

    _priority = task.priority ?? TaskPriority.medium;
    _selectedCategory = task.category;

    if (task.recurring != null) {
      _recurringType = _parseRecurringType(task.recurring!.ruleType);
    }
  }

  RecurringRuleType? _parseRecurringType(String ruleType) {
    switch (ruleType.toUpperCase()) {
      case 'DAILY':
        return RecurringRuleType.daily;
      case 'WEEKLY':
        return RecurringRuleType.weekly;
      case 'MONTHLY':
        return RecurringRuleType.monthly;
      case 'YEARLY':
        return RecurringRuleType.yearly;
      default:
        return null;
    }
  }

  Future<void> _loadCategories() async {
    try {
      final repository = ref.read(taskRepositoryProvider);
      final groupId = ref.read(selectedGroupIdProvider);
      final categories = await repository.getCategories(groupId: groupId);
      if (mounted) {
        setState(() {
          _categories = categories;
          _isLoadingCategories = false;
          // 첫 번째 카테고리를 기본값으로
          if (_selectedCategory == null && categories.isNotEmpty) {
            _selectedCategory = categories.first;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingCategories = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedGroupId = ref.watch(selectedGroupIdProvider);
    final groupsAsync = ref.watch(myGroupsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? l10n.schedule_edit : l10n.schedule_add),
        actions: [
          if (_isEditMode)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _handleDelete,
              tooltip: l10n.schedule_delete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 그룹 선택
              _buildGroupSelector(l10n, selectedGroupId, groupsAsync),
              const SizedBox(height: AppSizes.spaceL),

              // 제목 입력
              _buildTitleField(l10n),
              const SizedBox(height: AppSizes.spaceL),

              // 종일 스위치
              _buildAllDaySwitch(l10n),
              const SizedBox(height: AppSizes.spaceM),

              // 날짜/시간 선택
              _buildDateTimeSection(l10n),
              const SizedBox(height: AppSizes.spaceL),

              // 카테고리 선택
              _buildCategorySection(l10n),
              const SizedBox(height: AppSizes.spaceL),

              // 우선순위 선택
              _buildPrioritySection(l10n),
              const SizedBox(height: AppSizes.spaceL),

              // 반복 설정
              _buildRecurringSection(l10n),
              const SizedBox(height: AppSizes.spaceL),

              // 알림 설정
              _buildReminderSection(l10n),
              const SizedBox(height: AppSizes.spaceL),

              // 장소 입력
              _buildLocationField(l10n),
              const SizedBox(height: AppSizes.spaceL),

              // 설명 입력
              _buildDescriptionField(l10n),
              const SizedBox(height: AppSizes.spaceXL),

              // 저장 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.spaceM),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            _isEditMode ? l10n.common_save : l10n.schedule_add,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 그룹 선택 섹션
  Widget _buildGroupSelector(
    AppLocalizations l10n,
    String? selectedGroupId,
    AsyncValue<List<Group>> groupsAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.schedule_group,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppSizes.spaceS),
        Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          child: groupsAsync.when(
            data: (groups) {
              // 개인 + 그룹 목록
              final items = <DropdownMenuItem<String?>>[];

              // 개인 일정 옵션
              items.add(
                DropdownMenuItem<String?>(
                  value: null,
                  child: Row(
                    children: [
                      const Icon(Icons.person, size: 20),
                      const SizedBox(width: AppSizes.spaceS),
                      Text(l10n.schedule_personal),
                    ],
                  ),
                ),
              );

              // 그룹 옵션들
              for (final group in groups) {
                items.add(
                  DropdownMenuItem<String?>(
                    value: group.id,
                    child: Row(
                      children: [
                        Icon(
                          Icons.group,
                          size: 20,
                          color: group.defaultColor != null
                              ? Color(int.parse('FF${group.defaultColor!.replaceFirst('#', '')}', radix: 16))
                              : null,
                        ),
                        const SizedBox(width: AppSizes.spaceS),
                        Expanded(
                          child: Text(
                            group.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceM,
                  vertical: AppSizes.spaceS,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String?>(
                    value: selectedGroupId,
                    items: items,
                    onChanged: (value) {
                      ref.read(selectedGroupIdProvider.notifier).state = value;
                      // 그룹 변경 시 카테고리 다시 로드
                      _selectedCategory = null;
                      _loadCategories();
                    },
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down),
                  ),
                ),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(AppSizes.spaceM),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => Padding(
              padding: const EdgeInsets.all(AppSizes.spaceM),
              child: Text(
                l10n.schedule_personal,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 제목 입력 필드
  Widget _buildTitleField(AppLocalizations l10n) {
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: l10n.schedule_title,
        hintText: l10n.schedule_titleHint,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.title),
      ),
      textInputAction: TextInputAction.next,
      maxLength: 100,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return l10n.schedule_titleRequired;
        }
        return null;
      },
    );
  }

  /// 종일 스위치
  Widget _buildAllDaySwitch(AppLocalizations l10n) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      child: SwitchListTile(
        title: Text(l10n.schedule_allDay),
        secondary: const Icon(Icons.wb_sunny_outlined),
        value: _isAllDay,
        onChanged: (value) {
          setState(() {
            _isAllDay = value;
            if (value) {
              _startTime = null;
              _dueTime = null;
            }
          });
        },
      ),
    );
  }

  /// 날짜/시간 선택 섹션
  Widget _buildDateTimeSection(AppLocalizations l10n) {
    final dateFormat = DateFormat.yMMMEd(Localizations.localeOf(context).toString());
    final timeFormat = DateFormat.jm(Localizations.localeOf(context).toString());

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          children: [
            // 시작 날짜 선택
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(l10n.schedule_startDate),
              subtitle: Text(dateFormat.format(_startDate)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _selectDate(isStart: true),
              contentPadding: EdgeInsets.zero,
            ),

            if (!_isAllDay) ...[
              const Divider(),
              // 시작 시간
              ListTile(
                leading: const Icon(Icons.access_time),
                title: Text(l10n.schedule_startTime),
                subtitle: Text(_startTime != null
                    ? timeFormat.format(DateTime(2000, 1, 1, _startTime!.hour, _startTime!.minute))
                    : '-'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _selectTime(isStart: true),
                contentPadding: EdgeInsets.zero,
              ),
            ],

            const Divider(),

            // 마감일 토글
            SwitchListTile(
              title: Text(l10n.schedule_dueDate),
              secondary: const Icon(Icons.event_available),
              value: _hasDueDate,
              onChanged: (value) {
                setState(() {
                  _hasDueDate = value;
                  if (value && _dueDate == null) {
                    _dueDate = _startDate;
                  }
                });
              },
              contentPadding: EdgeInsets.zero,
            ),

            if (_hasDueDate) ...[
              const Divider(),
              // 마감 날짜 선택
              ListTile(
                leading: const Icon(Icons.calendar_month),
                title: Text(l10n.schedule_dueDateSelect),
                subtitle: Text(_dueDate != null ? dateFormat.format(_dueDate!) : '-'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _selectDate(isStart: false),
                contentPadding: EdgeInsets.zero,
              ),

              if (!_isAllDay) ...[
                const Divider(),
                // 마감 시간
                ListTile(
                  leading: const Icon(Icons.access_time_filled),
                  title: Text(l10n.schedule_dueTime),
                  subtitle: Text(_dueTime != null
                      ? timeFormat.format(DateTime(2000, 1, 1, _dueTime!.hour, _dueTime!.minute))
                      : '-'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _selectTime(isStart: false),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  /// 카테고리 선택 섹션
  Widget _buildCategorySection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.category_management.split(' ').first, // "카테고리"
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton.icon(
              onPressed: () async {
                await context.push('/calendar/categories');
                // 카테고리 관리 화면에서 돌아오면 다시 로드
                _loadCategories();
              },
              icon: const Icon(Icons.settings, size: 18),
              label: Text(l10n.category_management),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceS),
                visualDensity: VisualDensity.compact,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spaceM),
        if (_isLoadingCategories)
          const Center(child: CircularProgressIndicator())
        else if (_categories.isEmpty)
          Center(
            child: Column(
              children: [
                Text(
                  l10n.category_empty,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: AppSizes.spaceS),
                TextButton.icon(
                  onPressed: () async {
                    await context.push('/calendar/categories');
                    _loadCategories();
                  },
                  icon: const Icon(Icons.add),
                  label: Text(l10n.category_add),
                ),
              ],
            ),
          )
        else
          Wrap(
            spacing: AppSizes.spaceS,
            runSpacing: AppSizes.spaceS,
            children: _categories.map((category) {
              final isSelected = _selectedCategory?.id == category.id;
              final color = category.color != null
                  ? Color(int.parse('FF${category.color!.replaceFirst('#', '')}', radix: 16))
                  : AppColors.primary;

              return ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (category.emoji != null) ...[
                      Text(category.emoji!, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: AppSizes.spaceXS),
                    ],
                    Text(category.name),
                  ],
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  }
                },
                selectedColor: color.withValues(alpha: 0.3),
                labelStyle: TextStyle(
                  color: isSelected ? color : null,
                  fontWeight: isSelected ? FontWeight.bold : null,
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  /// 우선순위 선택 섹션
  Widget _buildPrioritySection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '우선순위',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppSizes.spaceM),
        SegmentedButton<TaskPriority>(
          segments: [
            ButtonSegment(
              value: TaskPriority.low,
              label: const Text('낮음'),
              icon: const Icon(Icons.arrow_downward, size: 16),
            ),
            ButtonSegment(
              value: TaskPriority.medium,
              label: const Text('보통'),
              icon: const Icon(Icons.remove, size: 16),
            ),
            ButtonSegment(
              value: TaskPriority.high,
              label: const Text('높음'),
              icon: const Icon(Icons.arrow_upward, size: 16),
            ),
            ButtonSegment(
              value: TaskPriority.urgent,
              label: const Text('긴급'),
              icon: const Icon(Icons.priority_high, size: 16),
            ),
          ],
          selected: {_priority},
          onSelectionChanged: (selected) {
            setState(() {
              _priority = selected.first;
            });
          },
        ),
      ],
    );
  }

  /// 반복 설정 섹션
  Widget _buildRecurringSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.schedule_recurrence,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppSizes.spaceM),
        Wrap(
          spacing: AppSizes.spaceS,
          runSpacing: AppSizes.spaceS,
          children: [
            ChoiceChip(
              label: Text(l10n.schedule_recurrenceNone),
              selected: _recurringType == null,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _recurringType = null;
                  });
                }
              },
            ),
            ChoiceChip(
              label: Text(l10n.schedule_recurrenceDaily),
              selected: _recurringType == RecurringRuleType.daily,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _recurringType = RecurringRuleType.daily;
                  });
                }
              },
            ),
            ChoiceChip(
              label: Text(l10n.schedule_recurrenceWeekly),
              selected: _recurringType == RecurringRuleType.weekly,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _recurringType = RecurringRuleType.weekly;
                  });
                }
              },
            ),
            ChoiceChip(
              label: Text(l10n.schedule_recurrenceMonthly),
              selected: _recurringType == RecurringRuleType.monthly,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _recurringType = RecurringRuleType.monthly;
                  });
                }
              },
            ),
            ChoiceChip(
              label: Text(l10n.schedule_recurrenceYearly),
              selected: _recurringType == RecurringRuleType.yearly,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _recurringType = RecurringRuleType.yearly;
                  });
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  /// 알림 설정 섹션
  Widget _buildReminderSection(AppLocalizations l10n) {
    final reminderOptions = [
      (0, l10n.schedule_reminderAtTime),
      (5, l10n.schedule_reminder5Min),
      (15, l10n.schedule_reminder15Min),
      (30, l10n.schedule_reminder30Min),
      (60, l10n.schedule_reminder1Hour),
      (1440, l10n.schedule_reminder1Day),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.schedule_reminder,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppSizes.spaceM),
        Wrap(
          spacing: AppSizes.spaceS,
          runSpacing: AppSizes.spaceS,
          children: reminderOptions.map((option) {
            final (minutes, label) = option;
            final isSelected = _selectedReminders.contains(minutes);

            return FilterChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedReminders.add(minutes);
                  } else {
                    _selectedReminders.remove(minutes);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  /// 장소 입력 필드
  Widget _buildLocationField(AppLocalizations l10n) {
    return TextFormField(
      controller: _locationController,
      decoration: InputDecoration(
        labelText: l10n.schedule_location,
        hintText: l10n.schedule_locationHint,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.location_on_outlined),
      ),
      textInputAction: TextInputAction.next,
    );
  }

  /// 설명 입력 필드
  Widget _buildDescriptionField(AppLocalizations l10n) {
    return TextFormField(
      controller: _descriptionController,
      decoration: InputDecoration(
        labelText: l10n.schedule_description,
        hintText: l10n.schedule_descriptionHint,
        border: const OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      maxLines: 4,
      textInputAction: TextInputAction.done,
    );
  }

  /// 날짜 선택
  Future<void> _selectDate({required bool isStart}) async {
    final initialDate = isStart ? _startDate : (_dueDate ?? _startDate);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: isStart ? DateTime(2020) : _startDate,
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          // 시작일이 마감일보다 늦으면 마감일 조정
          if (_dueDate != null && picked.isAfter(_dueDate!)) {
            _dueDate = picked;
          }
        } else {
          _dueDate = picked;
        }
      });
    }
  }

  /// 시간 선택
  Future<void> _selectTime({required bool isStart}) async {
    final initialTime = isStart
        ? (_startTime ?? const TimeOfDay(hour: 9, minute: 0))
        : (_dueTime ?? const TimeOfDay(hour: 18, minute: 0));

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _dueTime = picked;
        }
      });
    }
  }

  /// 삭제 처리
  Future<void> _handleDelete() async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.schedule_deleteDialogTitle),
        content: Text(l10n.schedule_deleteDialogMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.common_delete),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(taskManagementProvider.notifier).deleteTask(
              widget.taskId!,
              widget.task!.scheduledAt ?? DateTime.now(),
            );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.schedule_deleteSuccess)),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n.schedule_deleteError}: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  /// 제출 처리
  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('카테고리를 선택해주세요')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final l10n = AppLocalizations.of(context)!;

    try {
      // scheduledAt 계산
      DateTime scheduledAt;
      DateTime? dueAt;

      if (_isAllDay) {
        scheduledAt = DateTime(_startDate.year, _startDate.month, _startDate.day);
        // 마감일 설정
        if (_hasDueDate && _dueDate != null) {
          dueAt = DateTime(_dueDate!.year, _dueDate!.month, _dueDate!.day, 23, 59, 59);
        }
      } else {
        final startHour = _startTime?.hour ?? 9;
        final startMinute = _startTime?.minute ?? 0;
        scheduledAt = DateTime(
          _startDate.year,
          _startDate.month,
          _startDate.day,
          startHour,
          startMinute,
        );

        // 마감일/시간 설정
        if (_hasDueDate && _dueDate != null) {
          final dueHour = _dueTime?.hour ?? 18;
          final dueMinute = _dueTime?.minute ?? 0;
          dueAt = DateTime(
            _dueDate!.year,
            _dueDate!.month,
            _dueDate!.day,
            dueHour,
            dueMinute,
          );
        }
      }

      // 반복 설정
      RecurringRuleDto? recurring;
      if (_recurringType != null) {
        recurring = RecurringRuleDto(
          ruleType: _recurringType!,
          generationType: RecurringGenerationType.autoScheduler,
        );
      }

      // 알림 설정
      List<TaskReminderDto>? reminders;
      if (_selectedReminders.isNotEmpty) {
        reminders = _selectedReminders
            .map((minutes) => TaskReminderDto(
                  reminderType: TaskReminderType.beforeStart,
                  offsetMinutes: minutes,
                ))
            .toList();
      }

      // 현재 선택된 그룹 ID
      final groupId = ref.read(selectedGroupIdProvider);

      final dto = CreateTaskDto(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        location: _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
        type: TaskType.schedule,
        priority: _priority,
        categoryId: _selectedCategory!.id,
        groupId: groupId,
        scheduledAt: scheduledAt.toIso8601String(),
        dueAt: dueAt?.toIso8601String(),
        recurring: recurring,
        reminders: reminders,
      );

      if (_isEditMode) {
        // 수정
        final updateDto = UpdateTaskDto(
          title: dto.title,
          description: dto.description,
          location: dto.location,
          type: dto.type,
          priority: dto.priority,
          scheduledAt: dto.scheduledAt,
          dueAt: dto.dueAt,
        );

        await ref.read(taskManagementProvider.notifier).updateTask(
              widget.taskId!,
              updateDto,
              originalDate: widget.task?.scheduledAt,
            );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.schedule_updateSuccess)),
          );
          context.pop();
        }
      } else {
        // 신규 작성
        await ref.read(taskManagementProvider.notifier).createTask(dto);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.schedule_createSuccess)),
          );
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditMode
                ? '${l10n.schedule_updateError}: $e'
                : '${l10n.schedule_createError}: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
