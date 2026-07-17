import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/features/main/task/providers/task_form_provider.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/features/settings/groups/providers/default_group_provider.dart';
import 'package:family_planner/features/onboarding/presentation/widgets/feature_coach_mark.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

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
import 'package:family_planner/core/mixins/interstitial_ad_mixin.dart';

/// 일정 추가/수정 화면
class TaskFormScreen extends ConsumerStatefulWidget {
  final String? taskId;
  final TaskModel? task;
  final DateTime? initialDate;
  final TaskType? initialTaskType;
  final bool isOnboarding;

  // 약식 생성창에서 넘어올 때 전달되는 초기값
  final String? initialTitle;
  final DateTime? initialEndTime;
  final String? initialGroupId;
  final bool hasInitialGroupId;
  final List<int>? initialReminders;

  const TaskFormScreen({
    super.key,
    this.taskId,
    this.task,
    this.initialDate,
    this.initialTaskType,
    this.isOnboarding = false,
    this.initialTitle,
    this.initialEndTime,
    this.initialGroupId,
    this.hasInitialGroupId = false,
    this.initialReminders,
  });

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen>
    with InterstitialAdMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _titleFocusNode = FocusNode();

  final _titleFieldKey = GlobalKey();
  final _dateTimeKey = GlobalKey();
  final _taskTypeKey = GlobalKey();
  final _participantsKey = GlobalKey();

  String? _previousGroupId;
  StateController<String?>? _groupIdNotifier;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description ?? '';
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _groupIdNotifier = ref.read(selectedGroupIdProvider.notifier);
      _previousGroupId = ref.read(selectedGroupIdProvider);
      if (widget.task != null) {
        // 수정 모드: task의 groupId로 초기화
        ref.read(selectedGroupIdProvider.notifier).state = widget.task!.groupId;
      } else if (widget.hasInitialGroupId) {
        // 약식 창에서 넘어온 경우: 선택된 그룹 그대로 사용
        ref.read(selectedGroupIdProvider.notifier).state =
            widget.initialGroupId;
      } else {
        // 신규 모드: 현재 필터에서 그룹 자동 선택
        final filterIds = ref.read(selectedGroupIdsProvider);
        final includePersonal = ref.read(includePersonalProvider);

        if (filterIds != null && filterIds.length == 1) {
          // 그룹 1개만 선택 → 해당 그룹
          ref.read(selectedGroupIdProvider.notifier).state = filterIds.first;
        } else if (filterIds != null && filterIds.isEmpty && includePersonal) {
          // 나만 보기만 선택 → 개인 일정 (null = 개인)
          ref.read(selectedGroupIdProvider.notifier).state = null;
        } else {
          // 전체 또는 여러 그룹 → 대표 그룹
          final defaultId = ref.read(defaultGroupProvider);
          if (defaultId != null) {
            ref.read(selectedGroupIdProvider.notifier).state = defaultId;
          }
        }
      }

      // 약식 창에서 넘어온 초기값 적용
      if (widget.initialTitle?.isNotEmpty == true) {
        _titleController.text = widget.initialTitle!;
      }
      if (widget.initialDate != null || widget.initialEndTime != null) {
        final notifier = ref.read(
          taskFormNotifierProvider(
            taskId: widget.taskId,
            task: widget.task,
            initialDate: widget.initialDate,
            initialTaskType: widget.initialTaskType,
          ).notifier,
        );
        if (widget.initialDate != null) {
          notifier.setStartTime(TimeOfDay.fromDateTime(widget.initialDate!));
        }
        if (widget.initialEndTime != null) {
          notifier.setHasDueDate(true);
          notifier.setDueDate(widget.initialEndTime!);
          notifier.setDueTime(TimeOfDay.fromDateTime(widget.initialEndTime!));
        }
        for (final minutes in widget.initialReminders ?? []) {
          notifier.addReminder(minutes);
        }
      } else if (widget.initialReminders?.isNotEmpty == true) {
        final notifier = ref.read(
          taskFormNotifierProvider(
            taskId: widget.taskId,
            task: widget.task,
            initialDate: widget.initialDate,
            initialTaskType: widget.initialTaskType,
          ).notifier,
        );
        for (final minutes in widget.initialReminders!) {
          notifier.addReminder(minutes);
        }
      }

      // 상세 API 로드 (reminders + groupId 재확인)
      if (widget.taskId != null) {
        _loadDetail();
      }
      if (widget.isOnboarding) {
        _showCoachMark();
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
      final reminders =
          detail.reminders.map((r) => r.offsetMinutes).toSet().toList()..sort();
      final notifier = ref.read(
        taskFormNotifierProvider(
          taskId: widget.taskId,
          task: widget.task,
          initialDate: widget.initialDate,
          initialTaskType: widget.initialTaskType,
        ).notifier,
      );
      for (final minutes in reminders) {
        notifier.addReminder(minutes);
      }
    } catch (_) {}
  }

  Future<void> _scrollToKey(GlobalKey key) async {
    final ctx = key.currentContext;
    if (ctx == null) return;
    await Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      alignment: 0.3,
    );
    await Future.delayed(const Duration(milliseconds: 150));
  }

  Future<void> _showCoachMark() async {
    if (!mounted) return;

    final selectedGroupId = ref.read(selectedGroupIdProvider);
    final targets = [
      TargetFocus(
        identify: 'form_title',
        keyTarget: _titleFieldKey,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '일정 제목',
              description: '일정의 이름을 입력하세요.\n짧고 명확하게 적을수록 좋아요.',
              icon: Icons.title,
              color: Colors.blue,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'form_datetime',
        keyTarget: _dateTimeKey,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '날짜 & 시간',
              description: '일정 시작일과 종료일,\n시간을 지정할 수 있어요.',
              icon: Icons.schedule,
              color: Colors.teal,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'form_task_type',
        keyTarget: _taskTypeKey,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '일정 유형',
              description: '일반 일정, 할 일, 또는 둘 다로\n유형을 선택할 수 있어요.',
              icon: Icons.category_outlined,
              color: Colors.orange,
            ),
          ),
        ],
      ),
      if (selectedGroupId != null)
        TargetFocus(
          identify: 'form_participants',
          keyTarget: _participantsKey,
          shape: ShapeLightFocus.RRect,
          radius: 8,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (_, _) => FeatureCoachMark.buildContent(
                title: '참가자',
                description: '그룹원을 이 일정에 초대할 수 있어요.\n참가자에게 알림이 전송돼요.',
                icon: Icons.group_outlined,
                color: Colors.purple,
              ),
            ),
          ],
        ),
    ];

    await FeatureCoachMark.waitForTargets(targets, context);
    if (!mounted) return;

    TutorialCoachMark(
      targets: FeatureCoachMark.refreshPositions(targets),
      colorShadow: const Color(0xFF212121),
      opacityShadow: 0.85,
      textSkip: '건너뛰기',
      alignSkip: Alignment.topRight,
      skipWidget: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white30),
        ),
        child: const Text(
          '건너뛰기',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      onFinish: () =>
          OnboardingService.completeCoachMark(CoachMarkKeys.calendarForm),
      onSkip: () {
        OnboardingService.completeCoachMark(CoachMarkKeys.calendarForm);
        return true;
      },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
      beforeFocus: (target) async {
        switch (target.identify) {
          case 'form_title':
            await _scrollToKey(_titleFieldKey);
          case 'form_datetime':
            await _scrollToKey(_dateTimeKey);
          case 'form_task_type':
            await _scrollToKey(_taskTypeKey);
          case 'form_participants':
            await _scrollToKey(_participantsKey);
        }
      },
    ).show(context: context);
  }

  @override
  void dispose() {
    // 이전 그룹 선택 상태 복구 — dispose 중 리스너 예외를 피하기 위해 다음 프레임에서 실행
    final notifier = _groupIdNotifier;
    final previousId = _previousGroupId;
    if (notifier != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifier.state = previousId;
      });
    }
    _titleController.dispose();
    _descriptionController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedGroupId = ref.watch(selectedGroupIdProvider);

    final formState = ref.watch(
      taskFormNotifierProvider(
        taskId: widget.taskId,
        task: widget.task,
        initialDate: widget.initialDate,
        initialTaskType: widget.initialTaskType,
      ),
    );
    final formNotifier = ref.read(
      taskFormNotifierProvider(
        taskId: widget.taskId,
        task: widget.task,
        initialDate: widget.initialDate,
        initialTaskType: widget.initialTaskType,
      ).notifier,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          formState.isEditMode ? l10n.schedule_edit : l10n.schedule_add,
        ),
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
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.spaceL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GroupSelector(
                        formNotifier: formNotifier,
                        isReadOnly: formState.isEditMode,
                      ),
                      const SizedBox(height: AppSizes.spaceL),
                      TitleField(
                        key: _titleFieldKey,
                        controller: _titleController,
                        formNotifier: formNotifier,
                        focusNode: _titleFocusNode,
                      ),
                      const SizedBox(height: AppSizes.spaceL),
                      DateTimeSection(
                        key: _dateTimeKey,
                        formState: formState,
                        formNotifier: formNotifier,
                      ),
                      const SizedBox(height: AppSizes.spaceL),
                      CategorySection(
                        formState: formState,
                        formNotifier: formNotifier,
                      ),
                      const SizedBox(height: AppSizes.spaceL),
                      TaskTypeSection(
                        key: _taskTypeKey,
                        formState: formState,
                        formNotifier: formNotifier,
                      ),
                      const SizedBox(height: AppSizes.spaceL),
                      PrioritySection(
                        formState: formState,
                        formNotifier: formNotifier,
                      ),
                      const SizedBox(height: AppSizes.spaceL),
                      if (selectedGroupId != null) ...[
                        ParticipantsSection(
                          key: _participantsKey,
                          groupId: selectedGroupId,
                          formState: formState,
                          formNotifier: formNotifier,
                        ),
                        const SizedBox(height: AppSizes.spaceL),
                      ],
                      RecurringSection(
                        formState: formState,
                        formNotifier: formNotifier,
                        readOnly: formState.isEditMode,
                      ),
                      const SizedBox(height: AppSizes.spaceL),
                      ReminderSection(
                        formState: formState,
                        formNotifier: formNotifier,
                      ),
                      const SizedBox(height: AppSizes.spaceL),
                      LocationField(
                        location: formState.location,
                        formNotifier: formNotifier,
                      ),
                      const SizedBox(height: AppSizes.spaceL),
                      DescriptionField(
                        controller: _descriptionController,
                        formNotifier: formNotifier,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                AppSizes.spaceL,
                AppSizes.spaceS,
                AppSizes.spaceL,
                AppSizes.spaceM + MediaQuery.paddingOf(context).bottom,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    width: 0.5,
                  ),
                ),
              ),
              child: SubmitButton(
                formState: formState,
                onPressed: () => _handleSubmit(
                  formState,
                  formNotifier,
                  selectedGroupId,
                  l10n,
                ),
              ),
            ),
          ],
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.schedule_updateSuccess)));
          showInterstitialThenNavigate(() {
            if (mounted) context.pop();
          });
        }
      } else {
        await formNotifier.createTask(groupId);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.schedule_createSuccess)));
          showInterstitialThenNavigate(() {
            if (mounted) context.pop();
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              formState.isEditMode
                  ? '${l10n.schedule_updateError}: $e'
                  : '${l10n.schedule_createError}: $e',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _handleDelete(
    TaskFormNotifier formNotifier,
    TaskFormState formState,
    AppLocalizations l10n,
  ) async {
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
      if (confirmed != true) return;
    }

    if (!mounted) return;
    try {
      await formNotifier.deleteTask(deleteScope: deleteScope);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.schedule_deleteSuccess)));
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
