import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/data/repositories/routine_repository.dart';
import 'package:family_planner/features/main/routine/data/routine_section_order_store.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_badge_celebration_dialog.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_daily_goal_bar.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_drag_reorder.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_goal_suggestion_dialog.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_group_form_dialog.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_group_section.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_list_item.dart';
import 'package:family_planner/features/main/routine/providers/routine_provider.dart';
import 'package:family_planner/features/onboarding/presentation/widgets/feature_coach_mark.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/app_bar_more_menu.dart';
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

  // 온보딩 코치마크가 가리킬 대상들. 데모 화면이 떠 있을 때만 유효하다.
  final _goalBarKey = GlobalKey();
  final _demoFlagKey = GlobalKey();
  final _demoCheckKey = GlobalKey();

  /// 온보딩 예시 목록을 보여주는 중인지. 신규 사용자는 습관이 없어 가리킬
  /// 대상이 없으므로, 온보딩 동안만 가짜 목록을 띄운다.
  ///
  /// 온보딩 로직이 extension에 있어 setState를 쓸 수 없으므로
  /// ValueNotifier로 관리한다(냉장고 온보딩과 동일한 방식).
  final _showOnboardingDemo = ValueNotifier<bool>(false);
  String? _selectedCategoryId;
  bool _isReordering = false;

  /// 오늘의 목표에 포함된 습관만 보여줄지 여부. 진행 바를 탭해 토글한다.
  bool _goalOnlyFilter = false;

  /// 편집(순서변경/소속이동) 모드 동안의 로컬 임시 목록. null이면 편집 중이
  /// 아니라는 뜻이며, 이 경우 서버 상태(routines)를 그대로 사용한다.
  /// 드래그는 이 목록만 바꾸고, "완료"를 눌러야 서버에 일괄 반영된다.
  List<Routine>? _draftRoutines;

  /// 편집 모드 동안의 로컬 임시 "섹션"(루틴 그룹 카드 + 독립 습관 각각)
  /// 순서. 항목은 그룹 id 또는 [RoutineSectionOrderStore.encodeStandalone]
  /// 로 인코딩된 값.
  List<String>? _draftSectionOrder;

  /// 편집 중이 아닐 때(읽기 모드) 화면에 쓰는 섹션 순서 캐시. 매 build마다
  /// SharedPreferences를 비동기로 읽을 수 없어 initState에서 한 번 로드해
  /// 둔다.
  List<String>? _cachedSectionOrder;
  bool _savingDraft = false;
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
    ref.read(selectedRoutineDateProvider.notifier).state = _selectedDateParam;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowOnboarding());
    _loadCachedSectionOrder();
    _scheduleGoalSuggestionCheck();
  }

  /// 목표 조정 제안은 설정과 최근 기록이 모두 로드된 뒤에야 판단할 수 있어,
  /// 두 provider의 future를 기다린 다음 실행한다.
  Future<void> _scheduleGoalSuggestionCheck() async {
    try {
      await Future.wait([
        ref.read(routineSettingsProvider.future),
        ref.read(routineDailyStreakProvider.future),
        ref.read(routineListProvider(null).future),
      ]);
    } catch (_) {
      // 통계 로드 실패는 제안을 건너뛰는 것으로 충분하다(사용자에게
      // 별도 에러를 띄울 성격의 기능이 아님).
      return;
    }
    if (!mounted) return;
    await _maybeSuggestGoalAdjustment();
  }

  @override
  void dispose() {
    _showOnboardingDemo.dispose();
    super.dispose();
  }

  Future<void> _loadCachedSectionOrder() async {
    final order = await RoutineSectionOrderStore.load();
    if (!mounted) return;
    setState(() => _cachedSectionOrder = order);
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

  /// 편집(순서변경/이동) 모드 진입. 서버 상태를 로컬 draft로 복사한다.
  Future<void> _enterReorderMode(
    List<Routine> routines,
    List<RoutineGroup> groups,
  ) async {
    final savedOrder = await RoutineSectionOrderStore.load();
    if (!mounted) return;
    final standaloneIds = routines
        .where((r) => r.routineGroupId == null)
        .map((r) => r.id)
        .toList();
    setState(() {
      _draftRoutines = [...routines];
      _draftSectionOrder = _resolveSectionOrder(
        savedOrder,
        groups,
        standaloneIds,
      );
      _isReordering = true;
      // 편집 모드에서는 필터로 숨겨진 루틴도 드래그 대상이 될 수 있어야
      // 하므로 진입 시 모든 필터를 해제한다.
      _selectedCategoryId = null;
      _goalOnlyFilter = false;
    });
  }

  /// 저장된 섹션 순서를 현재 그룹/독립 습관 목록과 맞춰 정리한다: 저장된
  /// 순서를 우선하되, 새로 생긴 그룹·독립 습관은 끝에 추가하고 삭제된
  /// 항목은 제거한다. 그룹 id와 독립 습관 항목([RoutineSectionOrderStore.
  /// encodeStandalone])이 자유롭게 섞여 순서를 이룬다.
  List<String> _resolveSectionOrder(
    List<String> savedOrder,
    List<RoutineGroup> groups,
    List<String> standaloneRoutineIds,
  ) {
    final groupIds = groups.map((g) => g.id).toSet();
    final standaloneItems = standaloneRoutineIds
        .map(RoutineSectionOrderStore.encodeStandalone)
        .toSet();
    final resolved = <String>[
      for (final id in savedOrder)
        if (groupIds.contains(id) || standaloneItems.contains(id)) id,
    ];
    final seen = resolved.toSet();
    for (final group in groups) {
      if (!seen.contains(group.id)) {
        resolved.add(group.id);
        seen.add(group.id);
      }
    }
    for (final item in standaloneItems) {
      if (!seen.contains(item)) {
        resolved.add(item);
        seen.add(item);
      }
    }
    return resolved;
  }

  /// draft를 버리고 편집 모드를 나간다(서버 상태는 그대로).
  void _cancelReorderMode() {
    setState(() {
      _draftRoutines = null;
      _draftSectionOrder = null;
      _isReordering = false;
    });
  }

  /// draft와 서버 상태를 비교해 바뀐 부분(소속 이동 / 순서 / 섹션 순서)만
  /// 서버·로컬에 일괄 반영한 뒤 편집 모드를 나간다.
  Future<void> _commitDraft(
    BuildContext context,
    List<RoutineGroup> groups,
  ) async {
    final draft = _draftRoutines;
    final sectionOrder = _draftSectionOrder;
    if (draft == null || sectionOrder == null) return;
    final original =
        ref.read(routineListProvider(_selectedDateParam)).valueOrNull ?? [];
    final originalById = {for (final r in original) r.id: r};

    setState(() => _savingDraft = true);
    final notifier = ref.read(routineManagementProvider.notifier);

    // 1) 소속(그룹) 이동
    for (final routine in draft) {
      final before = originalById[routine.id];
      if (before == null || before.routineGroupId == routine.routineGroupId) {
        continue;
      }
      await notifier.updateRoutine(
        routine.id,
        UpdateRoutineDto(
          routineGroupId: routine.routineGroupId,
          clearRoutineGroupId: routine.routineGroupId == null,
        ),
      );
    }

    // 2) 순서: 그룹별(그리고 독립 습관)로 나눠 최종 순서를 그대로 반영.
    // draft는 이동 직후에도 정렬 순서를 유지하고 있으므로 그룹별로 필터링한
    // 부분 리스트를 그대로 넘기면 된다.
    final scopeIds = <String?>{for (final r in draft) r.routineGroupId};
    for (final scopeId in scopeIds) {
      final scoped = draft.where((r) => r.routineGroupId == scopeId).toList();
      await notifier.reorder(scoped);
    }

    // 3) 섹션 순서: 서버에는 그룹끼리의 순서만 반영하고, 독립 습관 각각이
    // 그 사이 어디에 오는지는 서버 개념이 없으므로 기기 로컬에 저장한다.
    final groupOrderIds = sectionOrder.where(
      (id) => RoutineSectionOrderStore.decodeStandaloneRoutineId(id) == null,
    );
    final groupById = {for (final g in groups) g.id: g};
    final reorderedGroups = [
      for (final id in groupOrderIds)
        if (groupById[id] != null) groupById[id]!,
    ];
    if (reorderedGroups.length > 1) {
      await ref
          .read(routineGroupManagementProvider.notifier)
          .reorderGroups(reorderedGroups);
    }
    await RoutineSectionOrderStore.save(sectionOrder);

    if (!context.mounted) return;
    setState(() {
      _savingDraft = false;
      _draftRoutines = null;
      _draftSectionOrder = null;
      _cachedSectionOrder = sectionOrder;
      _isReordering = false;
    });
  }

  /// [payload]의 루틴을 draft 안에서 [targetGroupId] 그룹으로 옮긴다
  /// (null이면 독립 습관으로), [targetIndex] 위치(그 스코프 내 0-based)에 삽입.
  void _moveRoutineInDraft(
    RoutineDragPayload payload,
    String? targetGroupId,
    int targetIndex,
  ) {
    final draft = _draftRoutines;
    if (draft == null) return;
    final oldIndex = draft.indexWhere((r) => r.id == payload.routine.id);
    if (oldIndex == -1) return;

    // targetIndex는 이동 전(자기 자신이 아직 그 스코프에 남아 있는 상태)
    // 기준으로 계산된 위치다. 같은 스코프 내에서 자기 자신보다 뒤로
    // 옮기는 경우, 제거로 인해 한 칸씩 당겨지므로 보정이 필요하다.
    final sameScope = payload.sourceGroupId == targetGroupId;
    final scopedOldIndex = sameScope
        ? draft
              .where((r) => r.routineGroupId == targetGroupId)
              .toList()
              .indexWhere((r) => r.id == payload.routine.id)
        : -1;
    final adjustedTargetIndex = (sameScope && scopedOldIndex < targetIndex)
        ? targetIndex - 1
        : targetIndex;

    setState(() {
      final updated = [...draft];
      final moved = updated
          .removeAt(oldIndex)
          .copyWith(
            routineGroupId: targetGroupId,
            clearRoutineGroupId: targetGroupId == null,
          );

      // adjustedTargetIndex는 대상 스코프(같은 routineGroupId) 내에서의
      // 위치이므로, 전체 리스트에서 그 스코프의 해당 항목 앞에 삽입한다.
      final scoped = updated
          .where((r) => r.routineGroupId == targetGroupId)
          .toList();
      if (adjustedTargetIndex >= scoped.length) {
        updated.add(moved);
      } else {
        final insertBefore = scoped[adjustedTargetIndex];
        final insertAt = updated.indexWhere((r) => r.id == insertBefore.id);
        updated.insert(insertAt, moved);
      }
      _draftRoutines = updated;
    });
  }

  /// [reorderedScope]는 같은 스코프(그룹 또는 독립 습관) 안에서 순서만 바뀐
  /// 부분 리스트. draft 전체에서 그 id들의 위치에 새 순서를 채워 넣는다.
  void _reorderInDraft(List<Routine> reorderedScope) {
    final draft = _draftRoutines;
    if (draft == null) return;
    setState(() {
      final ids = reorderedScope.map((r) => r.id).toSet();
      final queue = [...reorderedScope];
      _draftRoutines = draft
          .map((r) => ids.contains(r.id) ? queue.removeAt(0) : r)
          .toList();
    });
  }

  /// 최상위 목록에서 그룹 카드 또는 독립 습관 행([payload])을
  /// [targetIndex] 위치(0-based, 이동 전 순서 기준)로 옮긴다. 독립 습관을
  /// 다른 그룹 안에서 이 화면으로 처음 끌어왔다면(sectionOrder에 아직 없는
  /// 경우) 새로 끼워 넣는다.
  void _moveSectionInDraft(RoutineSectionDragPayload payload, int targetIndex) {
    final order = _draftSectionOrder;
    if (order == null) return;
    final key = payload.encode();
    final oldIndex = order.indexOf(key);
    final adjustedTargetIndex = (oldIndex != -1 && oldIndex < targetIndex)
        ? targetIndex - 1
        : targetIndex;
    setState(() {
      final updated = [...order];
      if (oldIndex != -1) updated.removeAt(oldIndex);
      updated.insert(adjustedTargetIndex.clamp(0, updated.length), key);
      _draftSectionOrder = updated;
      // 독립 습관 섹션 핸들로 그룹에서 끄집어내 다른 위치로 옮긴 경우,
      // 그 습관의 routineGroupId도 함께 독립으로 갱신한다.
      if (!payload.isGroup) {
        final draft = _draftRoutines;
        if (draft == null) return;
        _draftRoutines = draft
            .map(
              (r) => r.id == payload.routine!.id
                  ? r.copyWith(clearRoutineGroupId: true)
                  : r,
            )
            .toList();
      }
    });
  }

  /// 독립 습관 섹션(핸들)이 [targetGroupId] 그룹 카드 위에 드롭됐을 때,
  /// 그 습관을 이 그룹으로 편입시키고 sectionOrder에서 제거한다.
  void _moveStandaloneToGroup(
    RoutineSectionDragPayload payload,
    String targetGroupId,
  ) {
    final draft = _draftRoutines;
    final order = _draftSectionOrder;
    if (draft == null || order == null || payload.routine == null) return;
    setState(() {
      _draftRoutines = draft
          .map(
            (r) => r.id == payload.routine!.id
                ? r.copyWith(routineGroupId: targetGroupId)
                : r,
          )
          .toList();
      _draftSectionOrder = order.where((id) => id != payload.encode()).toList();
    });
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

  /// sectionOrder의 [index]번째 항목([sectionKey])을 그룹 카드 또는 독립
  /// 습관 행으로 렌더링한다. 편집 모드가 아니면 드래그 없이 읽기 전용으로
  /// 표시된다.
  Widget _buildSectionItem(
    BuildContext context,
    String sectionKey,
    int index,
    List<String> sectionOrder,
    Map<String, RoutineGroup> groupById,
    Map<String, Routine> standaloneById,
    List<Routine> filteredRoutines,
    Map<String, RoutinePeriodProgress> progressByRoutineId,
  ) {
    final routineId = RoutineSectionOrderStore.decodeStandaloneRoutineId(
      sectionKey,
    );
    if (routineId != null) {
      final routine = standaloneById[routineId];
      if (routine == null) return const SizedBox.shrink();
      final rowNumber = sectionOrder
          .take(index + 1)
          .where(
            (id) =>
                RoutineSectionOrderStore.decodeStandaloneRoutineId(id) != null,
          )
          .length;
      if (!_isReordering) {
        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
          ),
          child: RoutineListItem(
            key: ValueKey(routine.id),
            routine: routine,
            rowNumber: rowNumber,
            onTap: () => context.push(
              AppRoutes.routineDetail,
              extra: {'routineId': routine.id},
            ),
            onToggleCheck: ({textValue, numericValue, timeValue}) =>
                _toggleCheck(
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
            onDelete: () => _confirmDelete(context, ref, routine),
            periodProgress: progressByRoutineId[routine.id],
          ),
        );
      }
      return _buildStandaloneRoutineSection(
        context,
        routine,
        rowNumber,
        sectionOrder,
        progressByRoutineId[routine.id],
      );
    }

    final group = groupById[sectionKey];
    if (group == null) return const SizedBox.shrink();
    final groupRoutines = filteredRoutines
        .where((r) => r.routineGroupId == sectionKey)
        .toList();
    if (!_isReordering && groupRoutines.isEmpty) return const SizedBox.shrink();

    return RoutineGroupSection(
      key: ValueKey(sectionKey),
      group: group,
      routines: groupRoutines,
      onTapRoutine: (routine) => context.push(
        AppRoutes.routineDetail,
        extra: {'routineId': routine.id},
      ),
      onToggleCheck: (routine, {textValue, numericValue, timeValue}) =>
          _toggleCheck(
            context,
            ref,
            routine,
            textValue: textValue,
            numericValue: numericValue,
            timeValue: timeValue,
          ),
      onReorderRoutines: (reordered) => _reorderInDraft(reordered),
      onMoveRoutine: (payload, targetIndex) =>
          _moveRoutineInDraft(payload, sectionKey, targetIndex),
      onMoveStandaloneRoutine: (payload) =>
          _moveStandaloneToGroup(payload, sectionKey),
      onEditGroup: () => _showGroupForm(context, group: group),
      onDeleteGroup: () => _confirmDeleteGroup(context, ref, group),
      onEditRoutine: (routine) =>
          context.push(AppRoutes.routineEdit, extra: {'routineId': routine.id}),
      onPauseRoutine: (routine) => _pauseRoutine(context, ref, routine),
      onResumeRoutine: (routine) => _resumeRoutine(context, ref, routine),
      isEditing: _isReordering,
      onDropSectionBefore: _isReordering
          ? (payload) => _moveSectionInDraft(payload, index)
          : null,
      onDropSectionAfter: _isReordering
          ? (payload) => _moveSectionInDraft(payload, index + 1)
          : null,
      progressByRoutineId: progressByRoutineId,
    );
  }

  /// 편집 모드의 독립 습관 행 하나. 그룹 카드와 동급인 최상위 섹션으로
  /// 취급되어, [DraggableSection]으로 감싸 다른 그룹/독립 습관 사이 어디로
  ///든 옮기거나 그룹으로 편입시킬 수 있다.
  Widget _buildStandaloneRoutineSection(
    BuildContext context,
    Routine routine,
    int rowNumber,
    List<String> sectionOrder,
    RoutinePeriodProgress? periodProgress,
  ) {
    final payload = RoutineSectionDragPayload.standaloneRoutine(routine);
    final key = payload.encode();
    return DraggableSection(
      sectionKey: key,
      onDropBefore: (dropped) =>
          _moveSectionInDraft(dropped, sectionOrder.indexOf(key)),
      onDropAfter: (dropped) =>
          _moveSectionInDraft(dropped, sectionOrder.indexOf(key) + 1),
      child: StandaloneRoutineRow(
        key: ValueKey(routine.id),
        routine: routine,
        rowNumber: rowNumber,
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
        periodProgress: periodProgress,
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

  /// 오늘의 목표 진행 바. 설정이 없거나 오늘 대상 습관이 0개면 아무것도
  /// 그리지 않는다(위젯 내부에서 판단).
  Widget _buildDailyGoalBar() {
    final streak = ref.watch(routineDailyStreakProvider).valueOrNull;
    if (streak == null) return const SizedBox.shrink();
    return RoutineDailyGoalBar(
      streak: streak,
      filterActive: _goalOnlyFilter,
      onTap: () => setState(() => _goalOnlyFilter = !_goalOnlyFilter),
    );
  }

  /// 최근 기록을 보고 목표 상향/하향을 제안한다. 사용자가 설정 화면을
  /// 스스로 찾아가지 않아도 목표가 현실에 맞게 조정되도록 하는 장치다.
  Future<void> _maybeSuggestGoalAdjustment() async {
    if (!await RoutineGoalSuggestionCooldown.canShow()) return;
    if (!mounted) return;

    final settings = ref.read(routineSettingsProvider).valueOrNull;
    final streak = ref.read(routineDailyStreakProvider).valueOrNull;
    final routines = ref.read(routineListProvider(null)).valueOrNull;
    if (settings == null || streak == null) return;

    final suggestion = evaluateGoalSuggestion(
      settings: settings,
      streak: streak,
      includedRoutines:
          routines?.where((r) => r.includeInDailyGoal).length ?? 0,
    );
    if (suggestion == null || !mounted) return;

    await RoutineGoalSuggestionCooldown.markShown();
    if (!mounted) return;
    final accepted = await showRoutineGoalSuggestionDialog(context, suggestion);
    if (accepted == null || !mounted) return;

    await ref
        .read(routineManagementProvider.notifier)
        .updateSettings(
          UpdateRoutineSettingsDto(
            dailyGoalMode: RoutineDailyGoalMode.count,
            dailyGoalCount: accepted,
          ),
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.routine_daily_goal_saved),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final routinesAsync = ref.watch(routineListProvider(_selectedDateParam));
    final groupsAsync = ref.watch(routineGroupListProvider);
    final categoriesAsync = ref.watch(routineCategoryListProvider);
    // 주간/월간 목표(targetCount) 진행 상황. 습관명 아래 보조텍스트로 표시.
    final summaryItems = ref.watch(routineSummaryProvider).valueOrNull ?? [];
    final progressByRoutineId = <String, RoutinePeriodProgress>{
      for (final item in summaryItems)
        if (item.thisWeekProgress != null || item.thisMonthProgress != null)
          item.routineId: (item.thisWeekProgress ?? item.thisMonthProgress)!,
    };

    return ValueListenableBuilder<bool>(
      valueListenable: _showOnboardingDemo,
      builder: (context, isDemo, _) => Scaffold(
        appBar: AppBar(
          title: Text(l10n.routine_title),
          actions: [
            if (_isReordering)
              IconButton(
                icon: const Icon(Icons.close),
                tooltip: MaterialLocalizations.of(context).cancelButtonLabel,
                onPressed: _savingDraft ? null : _cancelReorderMode,
              ),
            IconButton(
              icon: _savingDraft
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(_isReordering ? Icons.check : Icons.swap_vert),
              tooltip: _isReordering
                  ? l10n.routine_reorder_done
                  : l10n.routine_reorder,
              onPressed: _savingDraft
                  ? null
                  : () => _isReordering
                        ? _commitDraft(context, groupsAsync.valueOrNull ?? [])
                        : _enterReorderMode(
                            routinesAsync.valueOrNull ?? [],
                            groupsAsync.valueOrNull ?? [],
                          ),
            ),
            if (!_isReordering)
              IconButton(
                icon: const Icon(Icons.flag_outlined),
                tooltip: l10n.routine_daily_goal_setting,
                onPressed: () => context.push(AppRoutes.routineDailyGoal),
              ),
            if (!_isReordering)
              IconButton(
                icon: const Icon(Icons.bar_chart_outlined),
                tooltip: l10n.routine_overview_title,
                onPressed: () => context.push(AppRoutes.routineOverview),
              ),
            if (!_isReordering)
              AppBarMoreMenu(
                onReplayOnboarding: _showCoachMark,
                extraItems: [
                  // 그룹원 현황·랭킹·공유 설정이 모두 이 화면에 모여 있다.
                  MoreMenuItem(
                    id: 'together',
                    icon: Icons.groups_outlined,
                    label: l10n.routine_together_title,
                    onTap: (ctx) => ctx.push(AppRoutes.routineTogether),
                  ),
                ],
              ),
          ],
        ),
        floatingActionButton: _isReordering
            ? null
            : FloatingActionButton(
                key: _addButtonKey,
                // 온보딩 중에는 코치마크가 이 버튼을 가리키기만 하므로
                // 실제 생성 화면이 열리지 않게 막는다.
                onPressed: isDemo ? null : () => _showAddPicker(context),
                child: const Icon(Icons.add),
              ),
        body: isDemo
            ? _OnboardingRoutineDemo(
                goalBarKey: _goalBarKey,
                flagKey: _demoFlagKey,
                checkKey: _demoCheckKey,
              )
            : Stack(
                children: [
                  Column(
                    children: [
                      _buildDateNavigator(context, l10n),
                      // 일일 목표 진행 바는 "오늘"을 보고 있을 때만 의미가 있다.
                      // 과거 날짜를 조회 중일 때는 오늘의 진행을 띄우면 혼란스럽다.
                      if (_isToday && !_isReordering) _buildDailyGoalBar(),
                      _buildCategoryFilterRow(
                        context,
                        l10n,
                        categoriesAsync.valueOrNull ?? [],
                      ),
                      Expanded(
                        child: routinesAsync.when(
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (error, _) => AppErrorState(
                            error: error,
                            title: l10n.routine_error_generic,
                            onRetry: () => ref
                                .read(
                                  routineListProvider(
                                    _selectedDateParam,
                                  ).notifier,
                                )
                                .refresh(),
                          ),
                          data: (routines) {
                            final groups = groupsAsync.valueOrNull ?? [];
                            // 편집(순서변경/이동) 모드 중에는 로컬 draft를 화면에 반영하고,
                            // "완료"를 눌러야 서버에 일괄 커밋한다.
                            final effectiveRoutines = _isReordering
                                ? (_draftRoutines ?? routines)
                                : routines;
                            var filteredRoutines = _selectedCategoryId == null
                                ? effectiveRoutines
                                : effectiveRoutines
                                      .where(
                                        (r) => r.categoryIds.contains(
                                          _selectedCategoryId,
                                        ),
                                      )
                                      .toList();
                            // 진행 바를 탭해 켜는 "목표 습관만 보기" 필터.
                            if (_goalOnlyFilter) {
                              filteredRoutines = filteredRoutines
                                  .where((r) => r.includeInDailyGoal)
                                  .toList();
                            }
                            final standaloneRoutines = filteredRoutines
                                .where((r) => r.routineGroupId == null)
                                .toList();
                            final groupById = {for (final g in groups) g.id: g};
                            final standaloneById = {
                              for (final r in standaloneRoutines) r.id: r,
                            };
                            // 편집 모드에서는 draft 섹션 순서를, 평소엔 캐시된 순서를
                            // 쓴다(RoutineListScreen이 최초 빌드 때 로드해 둔다).
                            final baseOrder = _isReordering
                                ? (_draftSectionOrder ?? const <String>[])
                                : (_cachedSectionOrder ?? const <String>[]);
                            final sectionOrder = _resolveSectionOrder(
                              baseOrder,
                              groups,
                              standaloneRoutines.map((r) => r.id).toList(),
                            );

                            if (routines.isEmpty && groups.isEmpty) {
                              return AppEmptyState(
                                icon: Icons.checklist_outlined,
                                message: l10n.routine_list_empty,
                                subtitle: l10n.routine_list_empty_subtitle,
                                action: FilledButton.icon(
                                  onPressed: () =>
                                      context.push(AppRoutes.routineAdd),
                                  icon: const Icon(Icons.add),
                                  label: Text(l10n.routine_add),
                                ),
                              );
                            }

                            return RefreshIndicator(
                              onRefresh: () async {
                                await ref
                                    .read(
                                      routineListProvider(
                                        _selectedDateParam,
                                      ).notifier,
                                    )
                                    .refresh();
                                await ref
                                    .read(routineGroupListProvider.notifier)
                                    .refresh();
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
                                  for (var i = 0; i < sectionOrder.length; i++)
                                    _buildSectionItem(
                                      context,
                                      sectionOrder[i],
                                      i,
                                      sectionOrder,
                                      groupById,
                                      standaloneById,
                                      filteredRoutines,
                                      progressByRoutineId,
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  if (_savingDraft)
                    const Positioned.fill(
                      child: ColoredBox(
                        color: Colors.black26,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
