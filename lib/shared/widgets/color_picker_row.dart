import 'package:flutter/material.dart';

import 'package:family_planner/core/widgets/color_picker.dart' as color_picker;

/// 라벨 + 원형 색상 스와치 한 줄로 된 색상 선택 UI.
/// 스와치를 탭하면 색상 선택 다이얼로그가 열린다. (프로필 설정 화면과 동일한 패턴)
class ColorPickerRow extends StatelessWidget {
  const ColorPickerRow({
    super.key,
    required this.label,
    required this.selectedColor,
    required this.onColorSelected,
    this.availableColors,
    this.dialogTitle,
  });

  final String label;
  final Color? selectedColor;
  final ValueChanged<Color> onColorSelected;
  final List<Color>? availableColors;
  final String? dialogTitle;

  @override
  Widget build(BuildContext context) {
    final displayColor = selectedColor ?? Colors.grey;

    return Row(
      children: [
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.labelLarge),
        ),
        GestureDetector(
          onTap: () async {
            final picked = await color_picker.showColorPickerDialog(
              context: context,
              title: dialogTitle ?? label,
              initialColor: selectedColor,
              availableColors: availableColors,
            );
            if (picked != null) onColorSelected(picked);
          },
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: displayColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }
}
