import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/widgets/reorderable_widgets.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_list_item.dart';

/// 편집(순서변경) 모드에서 루틴 하나를 드래그로 옮길 때 실어 나르는 페이로드.
/// [sourceGroupId]는 드래그 시작 시점의 소속(없으면 독립 습관)이라
/// 같은 섹션 위로 다시 드롭됐을 때 이동을 무시하는 데 쓰인다.
class RoutineDragPayload {
  const RoutineDragPayload({
    required this.routine,
    required this.sourceGroupId,
  });

  final Routine routine;
  final String? sourceGroupId;
}

/// 편집 모드의 루틴 한 행. 드래그 핸들을 잡고 끌면 같은 섹션 내 다른 행
/// 사이(순서변경) 또는 다른 섹션(소속 이동) 위로 드롭할 수 있다.
///
/// 판정 영역이 행 사이의 얇은 줄에만 국한되면 조준하기 어려우므로, 행
/// 전체를 드롭 타겟으로 삼아 포인터가 위쪽 절반이면 이 행 앞, 아래쪽
/// 절반이면 이 행 뒤에 삽입되도록 한다(관대한 판정). 대신 지금 포인터가
/// 어느 쪽으로 판정되고 있는지 행 위/아래에 얇은 삽입줄로 명확히 보여준다.
class DraggableRoutineRow extends StatefulWidget {
  const DraggableRoutineRow({
    super.key,
    required this.routine,
    required this.rowNumber,
    required this.groupId,
    required this.onTap,
    required this.onToggleCheck,
    required this.onDropBefore,
    required this.onDropAfter,
    this.periodProgress,
  });

  final Routine routine;
  final int rowNumber;
  final String? groupId;
  final VoidCallback onTap;
  final Future<void> Function({
    String? textValue,
    num? numericValue,
    String? timeValue,
  })
  onToggleCheck;

  /// 이 행 앞에 [payload]가 드롭됐을 때 호출된다.
  final void Function(RoutineDragPayload payload) onDropBefore;

  /// 이 행 뒤에 [payload]가 드롭됐을 때 호출된다.
  final void Function(RoutineDragPayload payload) onDropAfter;

  final RoutinePeriodProgress? periodProgress;

  @override
  State<DraggableRoutineRow> createState() => _DraggableRoutineRowState();
}

class _DraggableRoutineRowState extends State<DraggableRoutineRow> {
  /// 현재 드래그 중인 포인터가 이 행의 상단 절반 위에 있는지. null이면
  /// 이 행 위에 후보가 없다는 뜻.
  bool? _hoveringTop;

  bool _isTopHalf(Offset globalOffset) {
    final box = context.findRenderObject() as RenderBox;
    final localY = box.globalToLocal(globalOffset).dy;
    return localY < box.size.height / 2;
  }

  @override
  Widget build(BuildContext context) {
    final payload = RoutineDragPayload(
      routine: widget.routine,
      sourceGroupId: widget.groupId,
    );

    return DragTarget<RoutineDragPayload>(
      onWillAcceptWithDetails: (details) =>
          details.data.routine.id != widget.routine.id,
      onMove: (details) =>
          setState(() => _hoveringTop = _isTopHalf(details.offset)),
      onLeave: (_) => setState(() => _hoveringTop = null),
      onAcceptWithDetails: (details) {
        final isTop = _isTopHalf(details.offset);
        setState(() => _hoveringTop = null);
        if (isTop) {
          widget.onDropBefore(details.data);
        } else {
          widget.onDropAfter(details.data);
        }
      },
      builder: (context, candidateData, rejectedData) {
        final active = candidateData.isNotEmpty;
        final accent = Theme.of(context).colorScheme.primary;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _InsertionLine(visible: active && _hoveringTop == true),
            Container(
              decoration: BoxDecoration(
                color: active ? accent.withValues(alpha: 0.06) : null,
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
              ),
              child: RoutineListItem(
                routine: widget.routine,
                rowNumber: widget.rowNumber,
                isEditing: true,
                dragHandle: LongPressDraggable<RoutineDragPayload>(
                  data: payload,
                  dragAnchorStrategy: pointerDragAnchorStrategy,
                  feedback: _DragFeedback(routine: widget.routine),
                  childWhenDragging: const Opacity(
                    opacity: 0.3,
                    child: DragHandleIcon(),
                  ),
                  child: const DragHandleIcon(),
                ),
                onTap: widget.onTap,
                onToggleCheck: widget.onToggleCheck,
                periodProgress: widget.periodProgress,
              ),
            ),
            _InsertionLine(visible: active && _hoveringTop == false),
          ],
        );
      },
    );
  }
}

/// 드롭 대상 행의 위 또는 아래에 표시되는 얇은 삽입줄.
class _InsertionLine extends StatelessWidget {
  const _InsertionLine({required this.visible});

  final bool visible;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      height: visible ? 3 : 0,
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.spaceS),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
    );
  }
}

/// 리스트 맨 끝(마지막 행 다음)에 두는 드롭 슬롯. 목록이 비어 있을 때도
/// 섹션 안에 드롭할 수 있도록 [DroppableRoutineSection]과 별개로 둔다.
class TrailingRoutineDropSlot extends StatelessWidget {
  const TrailingRoutineDropSlot({super.key, required this.onAccept});

  final void Function(RoutineDragPayload payload) onAccept;

  @override
  Widget build(BuildContext context) {
    return _RowDropSlot(onAccept: onAccept, currentRoutineId: null);
  }
}

class _RowDropSlot extends StatelessWidget {
  const _RowDropSlot({required this.onAccept, required this.currentRoutineId});

  final void Function(RoutineDragPayload payload) onAccept;

  /// 이 슬롯 바로 아래(또는, trailing이면 null) 행의 id. 자기 자신을
  /// 자기 바로 위로 드롭하는 무의미한 이동은 무시한다.
  final String? currentRoutineId;

  @override
  Widget build(BuildContext context) {
    return DragTarget<RoutineDragPayload>(
      onWillAcceptWithDetails: (details) =>
          details.data.routine.id != currentRoutineId,
      onAcceptWithDetails: (details) => onAccept(details.data),
      builder: (context, candidateData, rejectedData) {
        final active = candidateData.isNotEmpty;
        // 시각적으로는 얇은 줄이지만, 히트 영역(SizedBox 전체 높이)은
        // 넉넉하게 잡아 드롭 판정이 너무 좁지 않도록 한다.
        return SizedBox(
          height: 24,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              height: active ? 28 : 4,
              margin: const EdgeInsets.symmetric(horizontal: AppSizes.spaceS),
              decoration: BoxDecoration(
                color: active
                    ? Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                border: active
                    ? Border.all(color: Theme.of(context).colorScheme.primary)
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 그룹 섹션(카드) 전체를 감싸는 드롭 영역. 카드의 빈 공간(헤더 등)에
/// 드롭되면 이 그룹 맨 끝으로 습관을 편입시킨다. 습관 행의 드래그 핸들
/// ([RoutineDragPayload])뿐 아니라, 독립 습관 섹션의 드래그 핸들
/// ([RoutineSectionDragPayload.standaloneRoutine])도 동일하게 받아
/// 그룹으로 편입시킬 수 있다.
class DroppableRoutineSection extends StatelessWidget {
  const DroppableRoutineSection({
    super.key,
    required this.groupId,
    required this.onDropToEnd,
    required this.onDropSectionToEnd,
    required this.child,
  });

  /// 이 섹션의 소속 그룹 id (null이면 독립 습관 섹션 — 이 경우 습관 행
  /// 드래그로는 이 위젯을 쓰지 않으므로 [onDropToEnd]는 호출되지 않는다).
  final String? groupId;
  final void Function(RoutineDragPayload payload) onDropToEnd;

  /// 독립 습관 섹션(핸들)이 이 그룹 카드 위에 드롭됐을 때 호출된다.
  final void Function(RoutineSectionDragPayload payload) onDropSectionToEnd;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DragTarget<RoutineSectionDragPayload>(
      onWillAcceptWithDetails: (details) => !details.data.isGroup,
      onAcceptWithDetails: (details) => onDropSectionToEnd(details.data),
      builder: (context, sectionCandidates, _) {
        return DragTarget<RoutineDragPayload>(
          onWillAcceptWithDetails: (details) =>
              details.data.sourceGroupId != groupId,
          onAcceptWithDetails: (details) => onDropToEnd(details.data),
          builder: (context, candidateData, rejectedData) {
            final active =
                candidateData.isNotEmpty || sectionCandidates.isNotEmpty;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                border: active
                    ? Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      )
                    : null,
              ),
              child: child,
            );
          },
        );
      },
    );
  }
}

/// 편집 모드 최상위 목록에서 "섹션"(루틴 그룹 카드 또는 독립 습관 하나)의
/// 순서를 나타내는 항목. 그룹은 [groupId]에, 독립 습관은 [routine]에 값이
/// 들어있다(항상 정확히 하나만).
class RoutineSectionDragPayload {
  const RoutineSectionDragPayload.group(this.groupId) : routine = null;

  const RoutineSectionDragPayload.standaloneRoutine(this.routine)
    : groupId = null;

  final String? groupId;
  final Routine? routine;

  /// 이 섹션이 그룹 카드인지 여부. false면 독립 습관 행.
  bool get isGroup => groupId != null;

  /// 최상위 sectionOrder 문자열 표현. 그룹이면 그룹 id 그대로, 독립 습관
  /// 이면 [RoutineSectionOrderStore.encodeStandalone]로 인코딩된 값과
  /// 같은 규칙을 [encode]를 통해 만든다.
  String encode() => groupId ?? 'routine:${routine!.id}';
}

/// 섹션(그룹 카드 또는 독립 습관 행) 전체를 드래그로 순서 변경할 수 있게
/// 감싸는 래퍼. [child] 위/아래에 드롭하면 그 섹션 앞/뒤로 옮겨진다.
/// 드래그는 [child] 내부의 드래그 핸들(그룹 헤더 아이콘, 또는 독립 습관
/// 행의 핸들)을 잡았을 때만 시작된다(카드/행 전체가 아니라 핸들 하나).
class DraggableSection extends StatefulWidget {
  const DraggableSection({
    super.key,
    required this.sectionKey,
    required this.onDropBefore,
    required this.onDropAfter,
    required this.child,
  });

  /// 이 섹션의 sectionOrder 문자열 표현(자기 자신 위 드롭 무시용).
  final String sectionKey;

  /// 이 섹션 앞에 [payload]가 드롭됐을 때 호출된다.
  final void Function(RoutineSectionDragPayload payload) onDropBefore;

  /// 이 섹션 뒤에 [payload]가 드롭됐을 때 호출된다.
  final void Function(RoutineSectionDragPayload payload) onDropAfter;

  final Widget child;

  @override
  State<DraggableSection> createState() => _DraggableSectionState();
}

class _DraggableSectionState extends State<DraggableSection> {
  bool? _hoveringTop;

  bool _isTopHalf(Offset globalOffset) {
    final box = context.findRenderObject() as RenderBox;
    final localY = box.globalToLocal(globalOffset).dy;
    return localY < box.size.height / 2;
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<RoutineSectionDragPayload>(
      onWillAcceptWithDetails: (details) =>
          details.data.encode() != widget.sectionKey,
      onMove: (details) =>
          setState(() => _hoveringTop = _isTopHalf(details.offset)),
      onLeave: (_) => setState(() => _hoveringTop = null),
      onAcceptWithDetails: (details) {
        final isTop = _isTopHalf(details.offset);
        setState(() => _hoveringTop = null);
        if (isTop) {
          widget.onDropBefore(details.data);
        } else {
          widget.onDropAfter(details.data);
        }
      },
      builder: (context, candidateData, rejectedData) {
        final active = candidateData.isNotEmpty;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _InsertionLine(visible: active && _hoveringTop == true),
            widget.child,
            _InsertionLine(visible: active && _hoveringTop == false),
          ],
        );
      },
    );
  }
}

/// 그룹 카드 헤더에 붙이는 드래그 핸들(6점 아이콘). 이걸 잡고 끌면 그룹
/// 섹션 전체(카드)가 다른 그룹/독립 습관 사이로 이동한다.
class GroupSectionDragHandle extends StatelessWidget {
  const GroupSectionDragHandle({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<RoutineSectionDragPayload>(
      data: RoutineSectionDragPayload.group(groupId),
      axis: Axis.vertical,
      feedback: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: const Padding(
          padding: EdgeInsets.all(AppSizes.spaceS),
          child: Icon(Icons.drag_indicator),
        ),
      ),
      childWhenDragging: const Opacity(
        opacity: 0.3,
        child: Icon(Icons.drag_indicator),
      ),
      child: const Icon(Icons.drag_indicator),
    );
  }
}

/// 편집 모드에서 그룹에 속하지 않은 독립 습관 하나를 나타내는 행. 카드
/// 없이 다른 그룹 카드들과 동급으로 최상위 목록에 섞여 렌더링되며, 오른쪽
/// 끝의 섹션 드래그 핸들을 잡으면 이 습관 하나가 그룹들/다른 독립 습관
/// 사이 어디로든 옮겨지거나 특정 그룹으로 편입될 수 있다.
class StandaloneRoutineRow extends StatelessWidget {
  const StandaloneRoutineRow({
    super.key,
    required this.routine,
    required this.rowNumber,
    required this.onTap,
    required this.onToggleCheck,
    this.periodProgress,
  });

  final Routine routine;
  final int rowNumber;
  final VoidCallback onTap;
  final Future<void> Function({
    String? textValue,
    num? numericValue,
    String? timeValue,
  })
  onToggleCheck;
  final RoutinePeriodProgress? periodProgress;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: RoutineListItem(
              routine: routine,
              rowNumber: rowNumber,
              isEditing: true,
              onTap: onTap,
              onToggleCheck: onToggleCheck,
              periodProgress: periodProgress,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppSizes.spaceS),
            child: LongPressDraggable<RoutineSectionDragPayload>(
              data: RoutineSectionDragPayload.standaloneRoutine(routine),
              axis: Axis.vertical,
              feedback: _DragFeedback(routine: routine),
              childWhenDragging: const Opacity(
                opacity: 0.3,
                child: Icon(Icons.drag_indicator),
              ),
              child: const Icon(Icons.drag_indicator),
            ),
          ),
        ],
      ),
    );
  }
}

class _DragFeedback extends StatelessWidget {
  const _DragFeedback({required this.routine});

  final Routine routine;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceM,
          vertical: AppSizes.spaceS,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (routine.emoji != null && routine.emoji!.isNotEmpty) ...[
              Text(routine.emoji!, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: AppSizes.spaceXS),
            ],
            Text(routine.title, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
