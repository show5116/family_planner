import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/features/main/task/providers/task_form_provider.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

// 분리된 위젯 import
import 'package:family_planner/features/main/task/presentation/screens/task_form/group_selector.dart';
import 'package:family_planner/features/main/task/presentation/screens/task_form/date_time_section.dart';
import 'package:family_planner/features/main/task/presentation/screens/task_form/category_section.dart';
import 'package:family_planner/features/main/task/presentation/screens/task_form/task_type_section.dart';
import 'package:family_planner/features/main/task/presentation/screens/task_form/priority_section.dart';
import 'package:family_planner/features/main/task/presentation/screens/task_form/recurring_section.dart';
import 'package:family_planner/features/main/task/presentation/screens/task_form/participants_section.dart';
import 'package:family_planner/features/main/task/presentation/screens/task_form/reminder_section.dart';
import 'package:family_planner/features/main/task/presentation/screens/task_form/text_input_fields.dart';
import 'package:family_planner/features/main/task/presentation/screens/task_form/submit_button.dart';

/// 일정 추가/수정 화면
class TaskFormScreen extends ConsumerStatefulWidget {
  final String? taskId;
  final TaskModel? task;
  final DateTime? initialDate;
  final TaskType? initialTaskType;

  const TaskFormScreen({
    super.key,
    this.taskId,
    this.task,
    this.initialDate,
    this.initialTaskType,
  });

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _titleFocusNode = FocusNode();

  String? _previousGroupId;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description ?? '';
      _locationController.text = widget.task!.location ?? '';
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _previousGroupId = ref.read(selectedGroupIdProvider);
      // 수정 모드: task의 groupId로 초기화
      if (widget.task != null) {
        ref.read(selectedGroupIdProvider.notifier).state = widget.task!.groupId;
      }
      // 상세 API 로드 (reminders + groupId 재확인)
      if (widget.taskId != null) {
        _loadDetail();
      }
    });
  }

  Future<void> _loadDetail() async {
    final taskId = widget.taskId;
    if (taskId == null) return;
    try {
      final detail = await ref.read(taskDetailProvider(taskId).future);
      if (!mounted) return;

      // task의 groupId로 그룹 선택 초기화
      ref.read(selectedGroupIdProvider.notifier).state = detail.task.groupId;

      // reminders 적용
      final reminders = detail.reminders
          .map((r) => r.offsetMinutes)
          .toSet()
          .toList()
        ..sort();
      final notifier = ref.read(taskFormNotifierProvider(
        taskId: widget.taskId,
        task: widget.task,
        initialDate: widget.initialDate,
        initialTaskType: widget.initialTaskType,
      ).notifier);
      for (final minutes in reminders) {
        notifier.addReminder(minutes);
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    // 이전 그룹 선택 상태 복구
    ref.read(selectedGroupIdProvider.notifier).state = _previousGroupId;
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedGroupId = ref.watch(selectedGroupIdProvider);

    final formState = ref.watch(taskFormNotifierProvider(
      taskId: widget.taskId,
      task: widget.task,
      initialDate: widget.initialDate,
      initialTaskType: widget.initialTaskType,
    ));
    final formNotifier = ref.read(taskFormNotifierProvider(
      taskId: widget.taskId,
      task: widget.task,
      initialDate: widget.initialDate,
      initialTaskType: widget.initialTaskType,
    ).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(formState.isEditMode ? l10n.schedule_edit : l10n.schedule_add),
        actions: [
          if (formState.isEditMode)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _handleDelete(formNotifier, formState, l10n),
              tooltip: l10n.schedule_delete,
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.spaceL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GroupSelector(formNotifier: formNotifier),
                const SizedBox(height: AppSizes.spaceL),
                TitleField(controller: _titleController, formNotifier: formNotifier, focusNode: _titleFocusNode),
                const SizedBox(height: AppSizes.spaceL),
                DateTimeSection(formState: formState, formNotifier: formNotifier),
                const SizedBox(height: AppSizes.spaceL),
                CategorySection(formState: formState, formNotifier: formNotifier),
                const SizedBox(height: AppSizes.spaceL),
                TaskTypeSection(formState: formState, formNotifier: formNotifier),
                const SizedBox(height: AppSizes.spaceL),
                PrioritySection(formState: formState, formNotifier: formNotifier),
                const SizedBox(height: AppSizes.spaceL),
                if (selectedGroupId != null) ...[
                  ParticipantsSection(groupId: selectedGroupId, formState: formState, formNotifier: formNotifier),
                  const SizedBox(height: AppSizes.spaceL),
                ],
                RecurringSection(formState: formState, formNotifier: formNotifier, readOnly: formState.isEditMode),
                const SizedBox(height: AppSizes.spaceL),
                ReminderSection(formState: formState, formNotifier: formNotifier),
                const SizedBox(height: AppSizes.spaceL),
                LocationField(controller: _locationController, formNotifier: formNotifier),
                const SizedBox(height: AppSizes.spaceL),
                DescriptionField(controller: _descriptionController, formNotifier: formNotifier),
                const SizedBox(height: AppSizes.spaceXL),
                SubmitButton(
                  formState: formState,
                  onPressed: () => _handleSubmit(formState, formNotifier, selectedGroupId, l10n),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit(
    TaskFormState formState,
    TaskFormNotifier formNotifier,
    String? groupId,
    AppLocalizations l10n,
  ) async {
    if (!_formKey.currentState!.validate()) {
      _titleFocusNode.requestFocus();
      return;
    }

    final validationError = formState.validate();
    if (validationError != null) {
      if (validationError == 'title_required') {
        _titleFocusNode.requestFocus();
      }
      final message = switch (validationError) {
        'title_required' => l10n.schedule_titleRequired,
        _ => validationError,
      };
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      return;
    }

    try {
      if (formState.isEditMode) {
        String? updateScope;
        if (formState.editingTask?.recurring != null) {
          updateScope = await _showRecurringUpdateDialog(l10n);
          if (updateScope == null) return; // 취소
        }
        await formNotifier.updateTask(groupId, updateScope: updateScope);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.schedule_updateSuccess)));
          context.pop();
        }
      } else {
        await formNotifier.createTask(groupId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.schedule_createSuccess)));
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(formState.isEditMode ? '${l10n.schedule_updateError}: $e' : '${l10n.schedule_createError}: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _handleDelete(TaskFormNotifier formNotifier, TaskFormState formState, AppLocalizations l10n) async {
    final isRecurring = formState.editingTask?.recurring != null;

    String? deleteScope;

    if (isRecurring) {
      deleteScope = await _showRecurringDeleteDialog(l10n);
      if (deleteScope == null) return; // 취소
    } else {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.schedule_deleteDialogTitle),
          content: Text(l10n.schedule_deleteDialogMessage),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.common_cancel)),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: Text(l10n.common_delete),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }

    if (!mounted) return;
    try {
      await formNotifier.deleteTask(deleteScope: deleteScope);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.schedule_deleteSuccess)));
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.schedule_deleteError}: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<String?> _showRecurringUpdateDialog(AppLocalizations l10n) async {
    String selected = 'current';

    return showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('반복 일정을 수정하시겠습니까?'),
          content: RadioGroup<String>(
            groupValue: selected,
            onChanged: (v) => setState(() => selected = v!),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: Text('이 일정만 수정'),
                  value: 'current',
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<String>(
                  title: Text('이 일정 및 이후 일정 모두 수정'),
                  value: 'future',
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: Text(l10n.common_cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, selected),
              child: Text(l10n.common_edit),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showRecurringDeleteDialog(AppLocalizations l10n) async {
    String selected = 'current';

    return showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('이 반복 일정을 삭제하시겠습니까?'),
          content: RadioGroup<String>(
            groupValue: selected,
            onChanged: (v) => setState(() => selected = v!),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: Text('이 일정만 삭제'),
                  value: 'current',
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<String>(
                  title: Text('이 일정 및 이후 일정 모두 삭제'),
                  value: 'future',
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<String>(
                  title: Text('모든 반복 일정 삭제'),
                  value: 'all',
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: Text(l10n.common_cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, selected),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: Text(l10n.common_delete),
            ),
          ],
        ),
      ),
    );
  }
}
