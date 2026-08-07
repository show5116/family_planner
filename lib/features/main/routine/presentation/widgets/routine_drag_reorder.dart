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

/// 그룹 섹션 또는 독립 습관 섹션 전체를 감싸는 드롭 영역. 행 사이가 아닌
/// 섹션의 빈 공간(헤더 등)에 드롭되면 해당 섹션 맨 끝으로 이동시킨다.
class DroppableRoutineSection extends StatelessWidget {
  const DroppableRoutineSection({
    super.key,
    required this.groupId,
    required this.onDropToEnd,
    required this.child,
  });

  /// 이 섹션의 소속 그룹 id (null이면 독립 습관 섹션).
  final String? groupId;
  final void Function(RoutineDragPayload payload) onDropToEnd;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DragTarget<RoutineDragPayload>(
      onWillAcceptWithDetails: (details) =>
          details.data.sourceGroupId != groupId,
      onAcceptWithDetails: (details) => onDropToEnd(details.data),
      builder: (context, candidateData, rejectedData) {
        final active = candidateData.isNotEmpty;
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
