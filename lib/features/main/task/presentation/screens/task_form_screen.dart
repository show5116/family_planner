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

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description ?? '';
      _locationController.text = widget.task!.location ?? '';
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

    final formState = ref.watch(taskFormNotifierProvider(
      taskId: widget.taskId,
      task: widget.task,
      initialDate: widget.initialDate,
    ));
    final formNotifier = ref.read(taskFormNotifierProvider(
      taskId: widget.taskId,
      task: widget.task,
      initialDate: widget.initialDate,
    ).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(formState.isEditMode ? l10n.schedule_edit : l10n.schedule_add),
        actions: [
          if (formState.isEditMode)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _handleDelete(formNotifier, l10n),
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
              GroupSelector(formNotifier: formNotifier),
              const SizedBox(height: AppSizes.spaceL),
              TitleField(controller: _titleController, formNotifier: formNotifier),
              const SizedBox(height: AppSizes.spaceL),
              AllDaySwitch(formState: formState, formNotifier: formNotifier),
              const SizedBox(height: AppSizes.spaceM),
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
              RecurringSection(formState: formState, formNotifier: formNotifier),
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
    );
  }

  Future<void> _handleSubmit(
    TaskFormState formState,
    TaskFormNotifier formNotifier,
    String? groupId,
    AppLocalizations l10n,
  ) async {
    if (!_formKey.currentState!.validate()) return;

    final validationError = formState.validate();
    if (validationError != null) {
      final message = switch (validationError) {
        'title_required' => l10n.schedule_titleRequired,
        'category_required' => l10n.category_name,
        _ => validationError,
      };
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      return;
    }

    try {
      if (formState.isEditMode) {
        await formNotifier.updateTask(groupId);
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

  Future<void> _handleDelete(TaskFormNotifier formNotifier, AppLocalizations l10n) async {
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

    if (confirmed == true && mounted) {
      try {
        await formNotifier.deleteTask();
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
  }
}
