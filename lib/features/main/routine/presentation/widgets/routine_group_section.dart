import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_drag_reorder.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_list_item.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 루틴(습관 묶음) 섹션 - 접기/펼치기 + 오늘 진행률 pill + 소속 습관 표
///
/// 소속 습관을 번호|시간대|습관|체크 4컬럼의 표 형태로 보여준다.
/// [isEditing]이 true면 각 행에 드래그 핸들이 표시되고, 드래그로 같은
/// 그룹 내 순서를 바꾸거나 다른 그룹/독립 습관 섹션으로 옮길 수 있다
/// (평소엔 읽기 전용, 탭하면 체크/상세이동만 가능).
class RoutineGroupSection extends StatefulWidget {
  const RoutineGroupSection({
    super.key,
    required this.group,
    required this.routines,
    required this.onTapRoutine,
    required this.onToggleCheck,
    required this.onReorderRoutines,
    required this.onMoveRoutine,
    required this.onMoveStandaloneRoutine,
    required this.onEditGroup,
    required this.onDeleteGroup,
    this.onEditRoutine,
    this.onPauseRoutine,
    this.onResumeRoutine,
    this.isEditing = false,
    this.onDropSectionBefore,
    this.onDropSectionAfter,
  });

  final RoutineGroup group;
  final List<Routine> routines;
  final void Function(Routine) onTapRoutine;
  final Future<void> Function(
    Routine, {
    String? textValue,
    num? numericValue,
    String? timeValue,
  })
  onToggleCheck;
  final void Function(List<Routine>) onReorderRoutines;

  /// 다른 섹션에서 이 그룹으로 루틴이 드롭됐을 때 호출.
  /// [targetIndex]는 이 그룹 내에서 삽입될 위치(0-based).
  final void Function(RoutineDragPayload payload, int targetIndex)
  onMoveRoutine;

  /// 독립 습관 섹션(핸들)이 이 그룹 카드 위에 드롭됐을 때 호출. 그 습관을
  /// 이 그룹 맨 끝으로 편입시킨다.
  final void Function(RoutineSectionDragPayload payload)
  onMoveStandaloneRoutine;
  final VoidCallback onEditGroup;
  final VoidCallback onDeleteGroup;
  final void Function(Routine)? onEditRoutine;
  final void Function(Routine)? onPauseRoutine;
  final void Function(Routine)? onResumeRoutine;
  final bool isEditing;

  /// 다른 섹션이 이 섹션 앞/뒤에 드롭됐을 때 호출(섹션 자체의 순서 변경).
  final void Function(RoutineSectionDragPayload payload)? onDropSectionBefore;
  final void Function(RoutineSectionDragPayload payload)? onDropSectionAfter;

  @override
  State<RoutineGroupSection> createState() => _RoutineGroupSectionState();
}

class _RoutineGroupSectionState extends State<RoutineGroupSection> {
  bool _expanded = true;

  @override
  void didUpdateWidget(covariant RoutineGroupSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 편집(순서변경/이동) 모드에 들어가면 접혀 있던 그룹도 강제로 펼쳐서,
    // 습관 목록 영역(그룹으로 편입시키는 드롭 타겟)이 항상 보이게 한다.
    if (widget.isEditing && !oldWidget.isEditing) {
      _expanded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final accent = AppColors.parseHex(
      widget.group.color,
      fallback: colorScheme.primary,
    );
    // 서버가 내려주는 group.todayProgress는 그룹 전체 기준(오늘 고정)이라
    // 카테고리 필터나 날짜 선택이 적용된 현재 목록과 맞지 않을 수 있다.
    // 실제로 화면에 보이는 widget.routines 기준으로 다시 계산해 항상
    // 표시되는 항목 수와 일치하도록 한다.
    final checkedCount = widget.routines.where((r) => r.checkedToday).length;
    final totalCount = widget.routines.length;

    Widget header = InkWell(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceM,
          vertical: AppSizes.spaceS,
        ),
        child: Row(
          children: [
            if (widget.group.emoji != null) ...[
              Text(widget.group.emoji!, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: AppSizes.spaceS),
            ],
            Expanded(
              child: Text(
                widget.group.title,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$checkedCount/$totalCount',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (widget.isEditing) ...[
              const SizedBox(width: AppSizes.spaceS),
              GroupSectionDragHandle(groupId: widget.group.id),
            ],
            if (!widget.isEditing)
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
                onSelected: (value) {
                  if (value == 'edit') widget.onEditGroup();
                  if (value == 'delete') widget.onDeleteGroup();
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text(l10n.routine_group_edit),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(l10n.routine_group_delete),
                  ),
                ],
              ),
            Icon(
              _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );

    // 편집 모드에서는 헤더(제목 영역)만 "섹션 순서변경" 드래그 타겟이고,
    // 카드 몸통(습관 목록 영역)은 "이 그룹으로 습관 편입" 드롭 타겟이다.
    // 두 영역을 겹치지 않게 분리해야 카드 몸통 위에서 섹션 순서변경
    // 삽입줄이 카드에 가려 반응하지 않는 문제가 없다.
    if (widget.isEditing &&
        widget.onDropSectionBefore != null &&
        widget.onDropSectionAfter != null) {
      header = DraggableSection(
        sectionKey: widget.group.id,
        onDropBefore: widget.onDropSectionBefore!,
        onDropAfter: widget.onDropSectionAfter!,
        child: header,
      );
    }

    final body = _expanded
        ? Column(
            children: [
              Divider(height: 1, color: colorScheme.outlineVariant),
              if (widget.routines.isNotEmpty) buildRoutineTableHeader(context),
              widget.isEditing ? _buildEditList(context) : _buildTable(context),
            ],
          )
        : const SizedBox.shrink();

    final card = Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          if (widget.isEditing)
            DroppableRoutineSection(
              groupId: widget.group.id,
              onDropToEnd: (payload) =>
                  widget.onMoveRoutine(payload, widget.routines.length),
              onDropSectionToEnd: widget.onMoveStandaloneRoutine,
              child: body,
            )
          else
            body,
        ],
      ),
    );

    return card;
  }

  Widget _buildTable(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceXS),
      itemCount: widget.routines.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final routine = widget.routines[index];
        return RoutineListItem(
          key: ValueKey(routine.id),
          routine: routine,
          rowNumber: index + 1,
          onTap: () => widget.onTapRoutine(routine),
          onToggleCheck: ({textValue, numericValue, timeValue}) =>
              widget.onToggleCheck(
                routine,
                textValue: textValue,
                numericValue: numericValue,
                timeValue: timeValue,
              ),
          onEdit: widget.onEditRoutine != null
              ? () => widget.onEditRoutine!(routine)
              : null,
          onPause: widget.onPauseRoutine != null
              ? () => widget.onPauseRoutine!(routine)
              : null,
          onResume: widget.onResumeRoutine != null
              ? () => widget.onResumeRoutine!(routine)
              : null,
        );
      },
    );
  }

  Widget _buildEditList(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 0; index < widget.routines.length; index++)
          DraggableRoutineRow(
            key: ValueKey(widget.routines[index].id),
            routine: widget.routines[index],
            rowNumber: index + 1,
            groupId: widget.group.id,
            onTap: () => widget.onTapRoutine(widget.routines[index]),
            onToggleCheck: ({textValue, numericValue, timeValue}) =>
                widget.onToggleCheck(
                  widget.routines[index],
                  textValue: textValue,
                  numericValue: numericValue,
                  timeValue: timeValue,
                ),
            onDropBefore: (payload) => _handleDrop(payload, index),
            onDropAfter: (payload) => _handleDrop(payload, index + 1),
          ),
        TrailingRoutineDropSlot(
          onAccept: (payload) => _handleDrop(payload, widget.routines.length),
        ),
      ],
    );
  }

  /// [targetIndex] 위치(0-based, 삽입될 자리)에 [payload]를 놓는다.
  /// 같은 그룹 내에서 온 것이면 순서변경, 다른 섹션에서 온 것이면 이 그룹으로
  /// 이동시키되 이동 직후 목표 위치로 재정렬한다.
  void _handleDrop(RoutineDragPayload payload, int targetIndex) {
    if (payload.sourceGroupId == widget.group.id) {
      final oldIndex = widget.routines.indexWhere(
        (r) => r.id == payload.routine.id,
      );
      if (oldIndex == -1) return;
      final updated = [...widget.routines];
      final moved = updated.removeAt(oldIndex);
      final insertAt = oldIndex < targetIndex ? targetIndex - 1 : targetIndex;
      updated.insert(insertAt, moved);
      widget.onReorderRoutines(updated);
    } else {
      widget.onMoveRoutine(payload, targetIndex);
    }
  }
}

/// 번호|시간대|습관|체크 표 헤더. 그룹 섹션과 독립 습관 섹션에서 공용으로 사용.
Widget buildRoutineTableHeader(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final colorScheme = Theme.of(context).colorScheme;
  final labelStyle = Theme.of(
    context,
  ).textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant);

  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSizes.spaceS,
      vertical: AppSizes.spaceXS,
    ),
    child: Row(
      children: [
        SizedBox(
          width: 24,
          child: Text(
            l10n.routine_table_header_number,
            textAlign: TextAlign.center,
            style: labelStyle,
          ),
        ),
        const SizedBox(width: AppSizes.spaceXS),
        SizedBox(
          width: 44,
          child: Text(
            l10n.routine_field_time_filter,
            textAlign: TextAlign.center,
            style: labelStyle,
          ),
        ),
        const SizedBox(width: AppSizes.spaceXS),
        const SizedBox(width: 28),
        const SizedBox(width: AppSizes.spaceS),
        Expanded(
          child: Text(l10n.routine_table_header_habit, style: labelStyle),
        ),
        Text(l10n.routine_table_header_check, style: labelStyle),
      ],
    ),
  );
}
