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
import 'package:family_planner/features/settings/groups/models/group_member.dart';
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
  TaskType _taskType = TaskType.calendarOnly;
  TaskPriority _priority = TaskPriority.medium;
  RecurringRuleType? _recurringType;
  List<int> _selectedReminders = []; // 분 단위 오프셋

  CategoryModel? _selectedCategory;
  bool _isLoadingCategories = true;
  List<CategoryModel> _categories = [];

  // 참가자 관련
  List<String> _selectedParticipantIds = [];

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
    _taskType = task.type ?? TaskType.calendarOnly;
    _selectedCategory = task.category;

    // 참가자 설정
    if (task.participants.isNotEmpty) {
      _selectedParticipantIds = task.participants.map((p) => p.userId).toList();
    }

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

              // 일정 유형 선택
              _buildTaskTypeSection(l10n),
              const SizedBox(height: AppSizes.spaceL),

              // 우선순위 선택
              _buildPrioritySection(l10n),
              const SizedBox(height: AppSizes.spaceL),

              // 참가자 선택 (그룹 일정인 경우에만 표시)
              if (selectedGroupId != null) ...[
                _buildParticipantsSection(l10n, selectedGroupId),
                const SizedBox(height: AppSizes.spaceL),
              ],

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

  /// 일정 유형 선택 섹션
  Widget _buildTaskTypeSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.schedule_taskType,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppSizes.spaceM),
        Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          child: Column(
            children: [
              RadioListTile<TaskType>(
                title: Text(l10n.schedule_taskTypeCalendarOnly),
                subtitle: Text(
                  l10n.schedule_taskTypeCalendarOnlyDesc,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                value: TaskType.calendarOnly,
                groupValue: _taskType,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _taskType = value;
                    });
                  }
                },
                secondary: const Icon(Icons.calendar_today),
              ),
              const Divider(height: 1),
              RadioListTile<TaskType>(
                title: Text(l10n.schedule_taskTypeTodoLinked),
                subtitle: Text(
                  l10n.schedule_taskTypeTodoLinkedDesc,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                value: TaskType.todoLinked,
                groupValue: _taskType,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _taskType = value;
                    });
                  }
                },
                secondary: const Icon(Icons.checklist),
              ),
            ],
          ),
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
          l10n.schedule_priority,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppSizes.spaceM),
        SegmentedButton<TaskPriority>(
          segments: [
            ButtonSegment(
              value: TaskPriority.low,
              label: Text(l10n.schedule_priorityLow),
              icon: const Icon(Icons.arrow_downward, size: 16),
            ),
            ButtonSegment(
              value: TaskPriority.medium,
              label: Text(l10n.schedule_priorityMedium),
              icon: const Icon(Icons.remove, size: 16),
            ),
            ButtonSegment(
              value: TaskPriority.high,
              label: Text(l10n.schedule_priorityHigh),
              icon: const Icon(Icons.arrow_upward, size: 16),
            ),
            ButtonSegment(
              value: TaskPriority.urgent,
              label: Text(l10n.schedule_priorityUrgent),
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

  /// 참가자 선택 섹션 (그룹 일정 전용)
  Widget _buildParticipantsSection(AppLocalizations l10n, String groupId) {
    final membersAsync = ref.watch(groupMembersProvider(groupId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.schedule_participants,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            // 전체 선택/해제 버튼
            membersAsync.maybeWhen(
              data: (members) {
                if (members.isEmpty) return const SizedBox.shrink();

                final allSelected = members.every(
                  (m) => _selectedParticipantIds.contains(m.userId),
                );

                return TextButton.icon(
                  onPressed: () {
                    setState(() {
                      if (allSelected) {
                        // 전체 해제
                        _selectedParticipantIds.clear();
                      } else {
                        // 전체 선택
                        _selectedParticipantIds = members.map((m) => m.userId).toList();
                      }
                    });
                  },
                  icon: Icon(
                    allSelected ? Icons.deselect : Icons.select_all,
                    size: 18,
                  ),
                  label: Text(
                    allSelected
                        ? l10n.schedule_participantsDeselectAll
                        : l10n.schedule_participantsSelectAll,
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceS),
                    visualDensity: VisualDensity.compact,
                  ),
                );
              },
              orElse: () => const SizedBox.shrink(),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spaceS),
        Text(
          l10n.schedule_participantsHint,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: AppSizes.spaceM),
        membersAsync.when(
          data: (members) {
            if (members.isEmpty) {
              return Text(
                l10n.schedule_noMembers,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              );
            }

            return Wrap(
              spacing: AppSizes.spaceS,
              runSpacing: AppSizes.spaceS,
              children: members.map((member) {
                final isSelected = _selectedParticipantIds.contains(member.userId);
                final userName = member.user?.name ?? 'Unknown';

                return FilterChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : AppColors.textSecondary.withValues(alpha: 0.3),
                        child: Text(
                          userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSizes.spaceXS),
                      Text(userName),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedParticipantIds.add(member.userId);
                      } else {
                        _selectedParticipantIds.remove(member.userId);
                      }
                    });
                  },
                );
              }).toList(),
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSizes.spaceM),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, stack) => Text(
            l10n.schedule_participantsLoadError,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.error,
                ),
          ),
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
    // 미리 정의된 빠른 선택 옵션
    final quickOptions = [
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

        // 빠른 선택 칩 + 추가 버튼
        Wrap(
          spacing: AppSizes.spaceS,
          runSpacing: AppSizes.spaceS,
          children: [
            // 빠른 선택 칩들
            ...quickOptions.map((option) {
              final (minutes, label) = option;
              final isSelected = _selectedReminders.contains(minutes);

              return FilterChip(
                label: Text(label),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      if (!_selectedReminders.contains(minutes)) {
                        _selectedReminders.add(minutes);
                        _selectedReminders.sort();
                      }
                    } else {
                      _selectedReminders.remove(minutes);
                    }
                  });
                },
              );
            }),

            // 커스텀 시간 추가 버튼
            ActionChip(
              avatar: const Icon(Icons.add, size: 18),
              label: Text(l10n.schedule_reminderCustom),
              onPressed: () => _showCustomReminderPicker(l10n),
            ),
          ],
        ),

        // 선택된 알림 리스트
        if (_selectedReminders.isNotEmpty) ...[
          const SizedBox(height: AppSizes.spaceM),
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceS,
                vertical: AppSizes.spaceXS,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _selectedReminders.map((minutes) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceXS),
                    child: Row(
                      children: [
                        const Icon(Icons.notifications_outlined, size: 20),
                        const SizedBox(width: AppSizes.spaceS),
                        Expanded(
                          child: Text(
                            _formatReminderTime(minutes, l10n),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {
                            setState(() {
                              _selectedReminders.remove(minutes);
                            });
                          },
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// 알림 시간 포맷팅
  String _formatReminderTime(int minutes, AppLocalizations l10n) {
    if (minutes == 0) {
      return l10n.schedule_reminderAtTime;
    } else if (minutes < 60) {
      return l10n.schedule_reminderMinutesBefore(minutes);
    } else if (minutes < 1440) {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return l10n.schedule_reminderHoursBefore(hours);
      } else {
        return l10n.schedule_reminderHoursMinutesBefore(hours, remainingMinutes);
      }
    } else {
      final days = minutes ~/ 1440;
      final remainingHours = (minutes % 1440) ~/ 60;
      if (remainingHours == 0) {
        return l10n.schedule_reminderDaysBefore(days);
      } else {
        return l10n.schedule_reminderDaysHoursBefore(days, remainingHours);
      }
    }
  }

  /// 커스텀 알림 시간 선택 다이얼로그
  Future<void> _showCustomReminderPicker(AppLocalizations l10n) async {
    int selectedDays = 0;
    int selectedHours = 0;
    int selectedMinutes = 0;

    final result = await showDialog<int>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(l10n.schedule_reminderCustomTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.schedule_reminderCustomHint,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: AppSizes.spaceL),

                  // 시간 선택 휠
                  SizedBox(
                    height: 150,
                    child: Row(
                      children: [
                        // 일 선택
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                l10n.schedule_reminderDays,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              Expanded(
                                child: ListWheelScrollView.useDelegate(
                                  itemExtent: 40,
                                  perspective: 0.005,
                                  diameterRatio: 1.2,
                                  physics: const FixedExtentScrollPhysics(),
                                  onSelectedItemChanged: (index) {
                                    setDialogState(() {
                                      selectedDays = index;
                                    });
                                  },
                                  childDelegate: ListWheelChildBuilderDelegate(
                                    builder: (context, index) {
                                      if (index < 0 || index > 30) return null;
                                      return Center(
                                        child: Text(
                                          '$index',
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                fontWeight: index == selectedDays
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                        ),
                                      );
                                    },
                                    childCount: 31,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 시간 선택
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                l10n.schedule_reminderHours,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              Expanded(
                                child: ListWheelScrollView.useDelegate(
                                  itemExtent: 40,
                                  perspective: 0.005,
                                  diameterRatio: 1.2,
                                  physics: const FixedExtentScrollPhysics(),
                                  onSelectedItemChanged: (index) {
                                    setDialogState(() {
                                      selectedHours = index;
                                    });
                                  },
                                  childDelegate: ListWheelChildBuilderDelegate(
                                    builder: (context, index) {
                                      if (index < 0 || index > 23) return null;
                                      return Center(
                                        child: Text(
                                          '$index',
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                fontWeight: index == selectedHours
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                        ),
                                      );
                                    },
                                    childCount: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 분 선택
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                l10n.schedule_reminderMinutes,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              Expanded(
                                child: ListWheelScrollView.useDelegate(
                                  itemExtent: 40,
                                  perspective: 0.005,
                                  diameterRatio: 1.2,
                                  physics: const FixedExtentScrollPhysics(),
                                  onSelectedItemChanged: (index) {
                                    setDialogState(() {
                                      selectedMinutes = index * 5; // 5분 단위
                                    });
                                  },
                                  childDelegate: ListWheelChildBuilderDelegate(
                                    builder: (context, index) {
                                      if (index < 0 || index > 11) return null;
                                      final minutes = index * 5;
                                      return Center(
                                        child: Text(
                                          '$minutes',
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                fontWeight: minutes == selectedMinutes
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                        ),
                                      );
                                    },
                                    childCount: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSizes.spaceM),

                  // 선택된 시간 미리보기
                  Container(
                    padding: const EdgeInsets.all(AppSizes.spaceM),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.notifications_active, size: 20),
                        const SizedBox(width: AppSizes.spaceS),
                        Text(
                          _formatReminderTime(
                            selectedDays * 1440 + selectedHours * 60 + selectedMinutes,
                            l10n,
                          ),
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.common_cancel),
                ),
                FilledButton(
                  onPressed: () {
                    final totalMinutes = selectedDays * 1440 + selectedHours * 60 + selectedMinutes;
                    Navigator.pop(context, totalMinutes);
                  },
                  child: Text(l10n.common_add),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null && result > 0) {
      setState(() {
        if (!_selectedReminders.contains(result)) {
          _selectedReminders.add(result);
          _selectedReminders.sort();
        }
      });
    }
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
        type: _taskType,
        priority: _priority,
        categoryId: _selectedCategory!.id,
        groupId: groupId,
        scheduledAt: scheduledAt.toIso8601String(),
        dueAt: dueAt?.toIso8601String(),
        recurring: recurring,
        reminders: reminders,
        participantIds: groupId != null && _selectedParticipantIds.isNotEmpty
            ? _selectedParticipantIds
            : null,
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
          participantIds: dto.participantIds,
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
