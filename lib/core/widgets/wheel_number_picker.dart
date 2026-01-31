import 'package:flutter/material.dart';

/// 숫자 선택 휠 피커 위젯
///
/// 시간, 수량, 나이 등 숫자 값을 휠 형태로 선택할 때 사용합니다.
///
/// ```dart
/// WheelNumberPicker(
///   label: '시간',
///   itemCount: 24,
///   initialValue: 9,
///   onChanged: (value) => print(value),
/// )
/// ```
class WheelNumberPicker extends StatefulWidget {
  /// 피커 상단에 표시될 라벨
  final String? label;

  /// 선택 가능한 항목 수 (0부터 itemCount-1까지)
  final int itemCount;

  /// 초기 선택 값
  final int initialValue;

  /// 값 변경 콜백
  final ValueChanged<int> onChanged;

  /// 표시할 때 곱할 값 (예: 5분 단위면 displayMultiplier: 5)
  final int displayMultiplier;

  /// 각 항목의 높이
  final double itemExtent;

  /// 휠의 직경 비율
  final double diameterRatio;

  /// 원근감 (0에 가까울수록 평면적)
  final double perspective;

  /// 숫자 포맷터 (기본: 숫자 그대로 표시)
  final String Function(int value)? formatter;

  const WheelNumberPicker({
    super.key,
    this.label,
    required this.itemCount,
    this.initialValue = 0,
    required this.onChanged,
    this.displayMultiplier = 1,
    this.itemExtent = 40,
    this.diameterRatio = 1.2,
    this.perspective = 0.005,
    this.formatter,
  });

  @override
  State<WheelNumberPicker> createState() => _WheelNumberPickerState();
}

class _WheelNumberPickerState extends State<WheelNumberPicker> {
  late FixedExtentScrollController _controller;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.displayMultiplier > 1
        ? widget.initialValue ~/ widget.displayMultiplier
        : widget.initialValue;
    _controller = FixedExtentScrollController(initialItem: _selectedIndex);
  }

  @override
  void didUpdateWidget(WheelNumberPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _selectedIndex = widget.displayMultiplier > 1
          ? widget.initialValue ~/ widget.displayMultiplier
          : widget.initialValue;
      _controller.jumpToItem(_selectedIndex);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              widget.label!,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        Expanded(
          child: ListWheelScrollView.useDelegate(
            controller: _controller,
            itemExtent: widget.itemExtent,
            perspective: widget.perspective,
            diameterRatio: widget.diameterRatio,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              setState(() => _selectedIndex = index);
              widget.onChanged(index * widget.displayMultiplier);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                if (index < 0 || index >= widget.itemCount) return null;
                final displayValue = index * widget.displayMultiplier;
                final isSelected = index == _selectedIndex;

                return Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 150),
                    style: theme.textTheme.titleMedium!.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    child: Text(
                      widget.formatter?.call(displayValue) ?? '$displayValue',
                    ),
                  ),
                );
              },
              childCount: widget.itemCount,
            ),
          ),
        ),
      ],
    );
  }
}

/// 여러 휠 피커를 가로로 배치하는 컨테이너
///
/// ```dart
/// WheelPickerRow(
///   height: 150,
///   children: [
///     WheelNumberPicker(label: '일', itemCount: 31, ...),
///     WheelNumberPicker(label: '시간', itemCount: 24, ...),
///     WheelNumberPicker(label: '분', itemCount: 12, displayMultiplier: 5, ...),
///   ],
/// )
/// ```
class WheelPickerRow extends StatelessWidget {
  final double height;
  final List<Widget> children;
  final double spacing;

  const WheelPickerRow({
    super.key,
    this.height = 150,
    required this.children,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        children: children
            .expand((child) => [Expanded(child: child), SizedBox(width: spacing)])
            .toList()
          ..removeLast(),
      ),
    );
  }
}
