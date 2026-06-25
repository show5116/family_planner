import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/features/settings/groups/providers/default_group_provider.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';

/// 타임테이블 빈 영역 탭 시 나타나는 간편 일정 생성 시트
void showQuickTaskSheet(BuildContext context, DateTime initialDateTime) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius:
          BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLarge)),
    ),
    builder: (ctx) => _QuickTaskSheet(initialDateTime: initialDateTime),
  );
}

class _QuickTaskSheet extends ConsumerStatefulWidget {
  final DateTime initialDateTime;

  const _QuickTaskSheet({required this.initialDateTime});

  @override
  ConsumerState<_QuickTaskSheet> createState() => _QuickTaskSheetState();
}

class _QuickTaskSheetState extends ConsumerState<_QuickTaskSheet> {
  final _titleController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isSubmitting = false;

  late DateTime _startTime;
  late DateTime _endTime;

  TaskType _taskType = TaskType.calendarOnly;
  String? _groupId; // null = 개인
  final List<int> _selectedMinutes = [];

  // 알림 퀵옵션 (분 단위)
  static const _reminderOptions = [
    (5, '5분 전'),
    (15, '15분 전'),
    (30, '30분 전'),
    (60, '1시간 전'),
    (1440, '1일 전'),
  ];

  @override
  void initState() {
    super.initState();
    _startTime = widget.initialDateTime;
    _endTime = widget.initialDateTime.add(const Duration(hours: 1));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 기본 그룹 설정
      _groupId = ref.read(defaultGroupProvider);
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _formatTime(DateTime dt) =>
      DateFormat('HH:mm').format(dt);

  String _formatDate(DateTime dt) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat('M/d (E)', locale).format(dt);
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      _focusNode.requestFocus();
      return;
    }
    setState(() => _isSubmitting = true);

    final dto = CreateTaskDto(
      title: title,
      type: _taskType,
      priority: TaskPriority.medium,
      groupId: _groupId,
      allDay: false,
      scheduledAt: _startTime.toUtc().toIso8601String(),
      dueAt: _endTime.toUtc().toIso8601String(),
      reminders: _selectedMinutes.isEmpty
          ? null
          : _selectedMinutes
              .map((m) => TaskReminderDto(
                    reminderType: TaskReminderType.beforeStart,
                    offsetMinutes: m,
                  ))
              .toList(),
    );

    final task = await ref
        .read(taskManagementProvider.notifier)
        .createTask(dto);

    if (mounted) {
      Navigator.pop(context);
      if (task != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('일정이 추가되었습니다.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _openFullForm() {
    Navigator.pop(context);
    context.push('/calendar/add', extra: {
      'date': _startTime,
      'title': _titleController.text.trim(),
      'endTime': _endTime,
      'taskType': _taskType,
      'groupId': _groupId,
      'hasGroupId': true,
      'reminders': List<int>.from(_selectedMinutes),
    });
  }

  Future<void> _pickTime(bool isStart) async {
    final initial = isStart ? _startTime : _endTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startTime = DateTime(
          _startTime.year, _startTime.month, _startTime.day,
          picked.hour, picked.minute,
        );
        if (!_endTime.isAfter(_startTime)) {
          _endTime = _startTime.add(const Duration(hours: 1));
        }
      } else {
        _endTime = DateTime(
          _endTime.year, _endTime.month, _endTime.day,
          picked.hour, picked.minute,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final groups = ref.watch(myGroupsProvider).valueOrNull ?? [];

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── 드래그 핸들 ───────────────────────────────────────
            const SizedBox(height: 8),
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── 제목 입력 ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceL),
              child: TextField(
                controller: _titleController,
                focusNode: _focusNode,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
                style: theme.textTheme.titleMedium,
                decoration: InputDecoration(
                  hintText: '일정 제목',
                  border: InputBorder.none,
                  hintStyle: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ),

            const Divider(height: 1),

            // ── 시간 행 ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceL, vertical: 10),
              child: Row(
                children: [
                  const Icon(Icons.access_time, size: 18),
                  const SizedBox(width: 8),
                  Text(_formatDate(_startTime),
                      style: theme.textTheme.bodyMedium),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () => _pickTime(true),
                    child: Text(
                      _formatTime(_startTime),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text('~',
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant)),
                  ),
                  GestureDetector(
                    onTap: () => _pickTime(false),
                    child: Text(
                      _formatTime(_endTime),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // ── 그룹 선택 ─────────────────────────────────────────
            _SectionRow(
              icon: Icons.group_outlined,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // 개인
                    _ChoiceChip(
                      label: '개인',
                      selected: _groupId == null,
                      onTap: () => setState(() => _groupId = null),
                    ),
                    const SizedBox(width: 6),
                    ...groups.map((g) => Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: _ChoiceChip(
                        label: g.name,
                        selected: _groupId == g.id,
                        onTap: () => setState(() => _groupId = g.id),
                      ),
                    )),
                  ],
                ),
              ),
            ),

            const Divider(height: 1),

            // ── 일정 유형 ─────────────────────────────────────────
            _SectionRow(
              icon: Icons.category_outlined,
              child: Row(
                children: [
                  _ChoiceChip(
                    label: '일정',
                    selected: _taskType == TaskType.calendarOnly,
                    onTap: () => setState(() => _taskType = TaskType.calendarOnly),
                  ),
                  const SizedBox(width: 6),
                  _ChoiceChip(
                    label: '할일',
                    selected: _taskType == TaskType.todoOnly,
                    onTap: () => setState(() => _taskType = TaskType.todoOnly),
                  ),
                  const SizedBox(width: 6),
                  _ChoiceChip(
                    label: '일정+할일',
                    selected: _taskType == TaskType.todoLinked,
                    onTap: () => setState(() => _taskType = TaskType.todoLinked),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // ── 알림 ─────────────────────────────────────────────
            _SectionRow(
              icon: Icons.notifications_outlined,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _reminderOptions.map((opt) {
                    final (minutes, label) = opt;
                    final selected = _selectedMinutes.contains(minutes);
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: FilterChip(
                        label: Text(label,
                            style: theme.textTheme.labelSmall),
                        selected: selected,
                        visualDensity: VisualDensity.compact,
                        onSelected: (_) => setState(() {
                          selected
                              ? _selectedMinutes.remove(minutes)
                              : _selectedMinutes.add(minutes);
                        }),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const Divider(height: 1),

            // ── 액션 버튼 ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceM, vertical: AppSizes.spaceS),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: _openFullForm,
                    icon: const Icon(Icons.open_in_full, size: 16),
                    label: const Text('더 보기'),
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('저장'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 공통 섹션 행
// ─────────────────────────────────────────────────────────────────────────────

class _SectionRow extends StatelessWidget {
  final IconData icon;
  final Widget child;

  const _SectionRow({required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceL, vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 18,
              color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(child: child),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 선택 칩
// ─────────────────────────────────────────────────────────────────────────────

class _ChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected
                ? theme.colorScheme.onPrimaryContainer
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
