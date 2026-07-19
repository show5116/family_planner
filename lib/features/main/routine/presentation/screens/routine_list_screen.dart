import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/core/widgets/reorderable_widgets.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_badge_celebration_dialog.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_group_form_dialog.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_group_section.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_list_item.dart';
import 'package:family_planner/features/main/routine/providers/routine_provider.dart';
import 'package:family_planner/features/onboarding/presentation/widgets/feature_coach_mark.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/app_empty_state.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';

part '_routine_list_onboarding.dart';

/// 루틴 목록 화면 (오늘 체크 리스트)
class RoutineListScreen extends ConsumerStatefulWidget {
  const RoutineListScreen({super.key});

  @override
  ConsumerState<RoutineListScreen> createState() => _RoutineListScreenState();
}

class _RoutineListScreenState extends ConsumerState<RoutineListScreen> {
  final _addButtonKey = GlobalKey();
  String? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();
  late DateTime _visibleMonth = DateTime(
    _selectedDate.year,
    _selectedDate.month,
  );

  bool get _isToday => _isSameDay(_selectedDate, DateTime.now());

  String? get _selectedDateParam =>
      _isToday ? null : _formatDate(_selectedDate);

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static String _formatDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  /// 선택된 날짜가 속한 주의 월요일
  DateTime get _weekStart {
    final weekday = _selectedDate.weekday; // 1=월 ~ 7=일
    return DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    ).subtract(Duration(days: weekday - 1));
  }

  void _setSelectedDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      _visibleMonth = DateTime(date.year, date.month);
    });
    Future.microtask(() {
      if (!mounted) return;
      ref.read(selectedRoutineDateProvider.notifier).state = _selectedDateParam;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowOnboarding());
  }

  Future<void> _toggleCheck(
    BuildContext context,
    WidgetRef ref,
    Routine routine, {
    String? textValue,
    num? numericValue,
    String? timeValue,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await ref
        .read(routineManagementProvider.notifier)
        .toggleCheck(
          routine.id,
          routine.checkedToday,
          textValue: textValue,
          numericValue: numericValue,
          timeValue: timeValue,
        );
    if (!context.mounted) return;

    if (!result.success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.routine_check_error)));
    } else if (result.newlyEarnedBadges.isNotEmpty) {
      await showRoutineBadgeCelebration(context, result.newlyEarnedBadges);
    } else if (result.streakIncreased && result.currentStreakDays != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.routine_streak_celebration(result.currentStreakDays!),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Routine routine,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.routine_end),
        content: Text(l10n.routine_end_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.routine_end),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final success = await ref
        .read(routineManagementProvider.notifier)
        .deleteRoutine(routine.id);
    if (!success && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.routine_error_generic)));
    }
  }

  Future<void> _pauseRoutine(
    BuildContext context,
    WidgetRef ref,
    Routine routine,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await ref
        .read(routineManagementProvider.notifier)
        .pauseRoutine(routine.id);
    if (result == null && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.routine_pause_error)));
    }
  }

  Future<void> _resumeRoutine(
    BuildContext context,
    WidgetRef ref,
    Routine routine,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await ref
        .read(routineManagementProvider.notifier)
        .resumeRoutine(routine.id);
    if (result != null && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.routine_resume_success)));
    } else if (result == null && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.routine_resume_error)));
    }
  }

  Future<void> _showAddPicker(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    final buttonBox =
        _addButtonKey.currentContext!.findRenderObject() as RenderBox;
    final overlayBox =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final buttonTopLeft = buttonBox.localToGlobal(
      Offset.zero,
      ancestor: overlayBox,
    );
    final position = RelativeRect.fromLTRB(
      buttonTopLeft.dx,
      buttonTopLeft.dy - AppSizes.spaceS,
      overlayBox.size.width - buttonTopLeft.dx - buttonBox.size.width,
      overlayBox.size.height - buttonTopLeft.dy,
    );

    final selected = await showMenu<String>(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          value: 'routine',
          child: ListTile(
            leading: const Icon(Icons.check_circle_outline),
            title: Text(l10n.routine_add),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        PopupMenuItem(
          value: 'group',
          child: ListTile(
            leading: const Icon(Icons.playlist_add),
            title: Text(l10n.routine_group_add),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );

    if (!context.mounted || selected == null) return;
    if (selected == 'routine') {
      context.push(AppRoutes.routineAdd);
    } else {
      _showGroupForm(context);
    }
  }

  Future<void> _showGroupForm(
    BuildContext context, {
    RoutineGroup? group,
  }) async {
    await showDialog<RoutineGroup>(
      context: context,
      builder: (context) => RoutineGroupFormDialog(group: group),
    );
  }

  Future<void> _confirmDeleteGroup(
    BuildContext context,
    WidgetRef ref,
    RoutineGroup group,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.routine_group_delete),
        content: Text(l10n.routine_group_delete_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.routine_group_delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final success = await ref
        .read(routineGroupManagementProvider.notifier)
        .deleteRoutineGroup(group.id);
    if (!success && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.routine_group_error_generic)));
    }
  }

  Future<void> _showSharedGroupPicker(
    BuildContext context,
    List<Group> groups,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusMedium),
        ),
      ),
      builder: (sheetContext) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (ctx, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.spaceL,
                AppSizes.spaceM,
                AppSizes.spaceL,
                AppSizes.spaceS,
              ),
              child: Text(
                l10n.routine_shared_group_select,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: groups.isEmpty
                  ? Center(child: Text(l10n.routine_shared_group_empty))
                  : ListView(
                      controller: scrollController,
                      children: groups.map((group) {
                        return ListTile(
                          leading: const Icon(Icons.group_outlined),
                          title: Text(group.name),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.pop(sheetContext);
                            context.push(
                              AppRoutes.routineGroupMembers.replaceFirst(
                                ':groupId',
                                group.id,
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStandaloneItem(
    BuildContext context,
    List<Routine> standaloneRoutines,
    int index,
  ) {
    final routine = standaloneRoutines[index];
    return Dismissible(
      key: ValueKey(routine.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        await _confirmDelete(context, ref, routine);
        return false;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSizes.spaceL),
        margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        child: Icon(
          Icons.delete_outline,
          color: Theme.of(context).colorScheme.onErrorContainer,
        ),
      ),
      child: RoutineListItem(
        key: ValueKey('${routine.id}_content'),
        routine: routine,
        dragHandle: ReorderableDragStartListener(
          index: index,
          child: const DragHandleIcon(),
        ),
        onTap: () => context.push(
          AppRoutes.routineDetail,
          extra: {'routineId': routine.id},
        ),
        onToggleCheck: ({textValue, numericValue, timeValue}) => _toggleCheck(
          context,
          ref,
          routine,
          textValue: textValue,
          numericValue: numericValue,
          timeValue: timeValue,
        ),
        onEdit: () => context.push(
          AppRoutes.routineEdit,
          extra: {'routineId': routine.id},
        ),
        onPause: () => _pauseRoutine(context, ref, routine),
        onResume: () => _resumeRoutine(context, ref, routine),
      ),
    );
  }

  Widget _buildDateNavigator(BuildContext context, AppLocalizations l10n) {
    final locale = Localizations.localeOf(context).toString();
    final monthLabel = DateFormat.yMMMM(locale).format(_visibleMonth);
    final weekDays = List.generate(7, (i) => _weekStart.add(Duration(days: i)));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceM,
            vertical: AppSizes.spaceXS,
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                visualDensity: VisualDensity.compact,
                onPressed: () => _setSelectedDate(
                  DateTime(_visibleMonth.year, _visibleMonth.month - 1, 1),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    monthLabel,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                visualDensity: VisualDensity.compact,
                onPressed: () => _setSelectedDate(
                  DateTime(_visibleMonth.year, _visibleMonth.month + 1, 1),
                ),
              ),
              if (!_isToday)
                TextButton(
                  onPressed: () => _setSelectedDate(DateTime.now()),
                  child: Text(l10n.routine_date_today),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceS),
          child: Row(
            children: weekDays.map((day) {
              final selected = _isSameDay(day, _selectedDate);
              final isTodayMarker = _isSameDay(day, DateTime.now());
              return Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  onTap: () => _setSelectedDate(day),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: AppSizes.spaceXS,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSizes.spaceXS,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(
                        AppSizes.radiusMedium,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          DateFormat.E(locale).format(day),
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: selected
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${day.day}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: selected
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : (isTodayMarker
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                          : null),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildCategoryFilterRow(
    BuildContext context,
    AppLocalizations l10n,
    List<RoutineCategory> categories,
  ) {
    // 선택된 필터가 삭제된 카테고리를 가리키면 무효화한다(다른 화면의
    // 카테고리 편집 바텀시트에서 삭제된 경우 대비).
    if (_selectedCategoryId != null &&
        !categories.any((c) => c.id == _selectedCategoryId)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _selectedCategoryId = null);
      });
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceS,
      ),
      child: Row(
        children: [
          ChoiceChip(
            label: Text(l10n.routine_category_filter_all),
            selected: _selectedCategoryId == null,
            onSelected: (_) => setState(() => _selectedCategoryId = null),
          ),
          const SizedBox(width: AppSizes.spaceS),
          ...categories.expand(
            (category) => [
              ChoiceChip(
                label: Text('${category.emoji ?? ''} ${category.title}'.trim()),
                selected: _selectedCategoryId == category.id,
                onSelected: (_) =>
                    setState(() => _selectedCategoryId = category.id),
              ),
              const SizedBox(width: AppSizes.spaceS),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final routinesAsync = ref.watch(routineListProvider(_selectedDateParam));
    final groupsAsync = ref.watch(routineGroupListProvider);
    final categoriesAsync = ref.watch(routineCategoryListProvider);
    final myGroups = ref.watch(myGroupsProvider).valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.routine_title),
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events_outlined),
            tooltip: l10n.routine_badges_title,
            onPressed: () => context.push(AppRoutes.routineBadges),
          ),
          IconButton(
            icon: const Icon(Icons.groups_outlined),
            tooltip: l10n.routine_shared_group_select,
            onPressed: () => _showSharedGroupPicker(context, myGroups),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: _addButtonKey,
        onPressed: () => _showAddPicker(context),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          _buildDateNavigator(context, l10n),
          _buildCategoryFilterRow(
            context,
            l10n,
            categoriesAsync.valueOrNull ?? [],
          ),
          Expanded(
            child: routinesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => AppErrorState(
                error: error,
                title: l10n.routine_error_generic,
                onRetry: () => ref
                    .read(routineListProvider(_selectedDateParam).notifier)
                    .refresh(),
              ),
              data: (routines) {
                final groups = groupsAsync.valueOrNull ?? [];
                final filteredRoutines = _selectedCategoryId == null
                    ? routines
                    : routines
                          .where(
                            (r) => r.categoryIds.contains(_selectedCategoryId),
                          )
                          .toList();
                final standaloneRoutines = filteredRoutines
                    .where((r) => r.routineGroupId == null)
                    .toList();

                if (routines.isEmpty && groups.isEmpty) {
                  return AppEmptyState(
                    icon: Icons.checklist_outlined,
                    message: l10n.routine_list_empty,
                    subtitle: l10n.routine_list_empty_subtitle,
                    action: FilledButton.icon(
                      onPressed: () => context.push(AppRoutes.routineAdd),
                      icon: const Icon(Icons.add),
                      label: Text(l10n.routine_add),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await ref
                        .read(routineListProvider(_selectedDateParam).notifier)
                        .refresh();
                    await ref.read(routineGroupListProvider.notifier).refresh();
                  },
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(
                      AppSizes.spaceM,
                      AppSizes.spaceM,
                      AppSizes.spaceM,
                      AppSizes.spaceM +
                          MediaQuery.paddingOf(context).bottom +
                          72,
                    ),
                    children: [
                      for (final group in groups)
                        if (routines
                            .where((r) => r.routineGroupId == group.id)
                            .isNotEmpty)
                          RoutineGroupSection(
                            key: ValueKey(group.id),
                            group: group,
                            routines: filteredRoutines
                                .where((r) => r.routineGroupId == group.id)
                                .toList(),
                            onTapRoutine: (routine) => context.push(
                              AppRoutes.routineDetail,
                              extra: {'routineId': routine.id},
                            ),
                            onToggleCheck:
                                (
                                  routine, {
                                  textValue,
                                  numericValue,
                                  timeValue,
                                }) => _toggleCheck(
                                  context,
                                  ref,
                                  routine,
                                  textValue: textValue,
                                  numericValue: numericValue,
                                  timeValue: timeValue,
                                ),
                            onReorderRoutines: (reordered) => ref
                                .read(routineManagementProvider.notifier)
                                .reorder(reordered),
                            onEditGroup: () =>
                                _showGroupForm(context, group: group),
                            onDeleteGroup: () =>
                                _confirmDeleteGroup(context, ref, group),
                            onEditRoutine: (routine) => context.push(
                              AppRoutes.routineEdit,
                              extra: {'routineId': routine.id},
                            ),
                            onPauseRoutine: (routine) =>
                                _pauseRoutine(context, ref, routine),
                            onResumeRoutine: (routine) =>
                                _resumeRoutine(context, ref, routine),
                          ),
                      if (standaloneRoutines.isNotEmpty) ...[
                        if (groups.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSizes.spaceS,
                            ),
                            child: Text(
                              l10n.routine_group_standalone_section_title,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        ReorderableListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          buildDefaultDragHandles: false,
                          proxyDecorator: buildReorderableProxyDecorator,
                          itemCount: standaloneRoutines.length,
                          onReorderItem: (oldIndex, newIndex) {
                            final reordered = [...standaloneRoutines];
                            final item = reordered.removeAt(oldIndex);
                            reordered.insert(newIndex, item);
                            ref
                                .read(routineManagementProvider.notifier)
                                .reorder(reordered);
                          },
                          itemBuilder: (context, index) => Padding(
                            key: ValueKey(
                              '${standaloneRoutines[index].id}_wrap',
                            ),
                            padding: const EdgeInsets.only(
                              bottom: AppSizes.spaceM,
                            ),
                            child: _buildStandaloneItem(
                              context,
                              standaloneRoutines,
                              index,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
