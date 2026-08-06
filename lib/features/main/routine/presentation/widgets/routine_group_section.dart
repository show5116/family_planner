import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/widgets/reorderable_widgets.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_list_item.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 루틴(습관 묶음) 섹션 - 접기/펼치기 + 오늘 진행률 pill + 소속 습관 표
///
/// 소속 습관을 번호|시간대|습관|체크 4컬럼의 표 형태로 보여준다.
/// [isEditing]이 true면 각 행에 드래그 핸들이 표시되고 드래그로
/// 순서를 바꿀 수 있다(평소엔 읽기 전용, 탭하면 체크/상세이동만 가능).
class RoutineGroupSection extends StatefulWidget {
  const RoutineGroupSection({
    super.key,
    required this.group,
    required this.routines,
    required this.onTapRoutine,
    required this.onToggleCheck,
    required this.onReorderRoutines,
    required this.onEditGroup,
    required this.onDeleteGroup,
    this.onEditRoutine,
    this.onPauseRoutine,
    this.onResumeRoutine,
    this.isEditing = false,
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
  final VoidCallback onEditGroup;
  final VoidCallback onDeleteGroup;
  final void Function(Routine)? onEditRoutine;
  final void Function(Routine)? onPauseRoutine;
  final void Function(Routine)? onResumeRoutine;
  final bool isEditing;

  @override
  State<RoutineGroupSection> createState() => _RoutineGroupSectionState();
}

class _RoutineGroupSectionState extends State<RoutineGroupSection> {
  bool _expanded = true;

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

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceM,
                vertical: AppSizes.spaceS,
              ),
              child: Row(
                children: [
                  if (widget.group.emoji != null) ...[
                    Text(
                      widget.group.emoji!,
                      style: const TextStyle(fontSize: 18),
                    ),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
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
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            Divider(height: 1, color: colorScheme.outlineVariant),
            if (widget.routines.isNotEmpty) buildRoutineTableHeader(context),
            widget.isEditing ? _buildEditList(context) : _buildTable(context),
          ],
        ],
      ),
    );
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
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      buildDefaultDragHandles: false,
      proxyDecorator: buildReorderableProxyDecorator,
      itemCount: widget.routines.length,
      onReorderItem: (oldIndex, newIndex) {
        final updated = [...widget.routines];
        final moved = updated.removeAt(oldIndex);
        updated.insert(newIndex, moved);
        widget.onReorderRoutines(updated);
      },
      itemBuilder: (context, index) {
        final routine = widget.routines[index];
        return Container(
          key: ValueKey(routine.id),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
          ),
          child: RoutineListItem(
            routine: routine,
            rowNumber: index + 1,
            isEditing: true,
            dragHandle: ReorderableDragStartListener(
              index: index,
              child: const DragHandleIcon(),
            ),
            onTap: () => widget.onTapRoutine(routine),
            onToggleCheck: ({textValue, numericValue, timeValue}) =>
                widget.onToggleCheck(
                  routine,
                  textValue: textValue,
                  numericValue: numericValue,
                  timeValue: timeValue,
                ),
          ),
        );
      },
    );
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
