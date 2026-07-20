import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/widgets/reorderable_widgets.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_list_item.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 루틴(습관 묶음) 섹션 - 접기/펼치기 + 오늘 진행률 pill + 소속 습관 드래그 정렬
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
            Padding(
              padding: const EdgeInsets.all(AppSizes.spaceS),
              child: ReorderableListView.builder(
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
                  return Padding(
                    key: ValueKey(routine.id),
                    padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
                    child: RoutineListItem(
                      routine: routine,
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
                      onEdit: widget.onEditRoutine != null
                          ? () => widget.onEditRoutine!(routine)
                          : null,
                      onPause: widget.onPauseRoutine != null
                          ? () => widget.onPauseRoutine!(routine)
                          : null,
                      onResume: widget.onResumeRoutine != null
                          ? () => widget.onResumeRoutine!(routine)
                          : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
