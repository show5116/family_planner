import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:family_planner/core/constants/app_sizes.dart';

/// 색상 선택 위젯
///
/// 미리 정의된 18가지 색상 팔레트에서 색상을 선택하거나,
/// RGB 값을 직접 입력하거나, 색상 팔레트를 열어서 자유롭게 선택할 수 있는 위젯입니다.
///
/// Example:
/// ```dart
/// ColorPicker(
///   selectedColor: Colors.blue,
///   onColorSelected: (color) {
///     print('Selected color: $color');
///   },
///   showRgbInput: true,
///   showAdvancedPicker: true,
/// )
/// ```
class ColorPicker extends StatefulWidget {
  /// 현재 선택된 색상
  final Color? selectedColor;

  /// 색상이 선택되었을 때 호출되는 콜백
  final ValueChanged<Color> onColorSelected;

  /// 색상 버튼의 크기 (기본값: 40)
  final double colorButtonSize;

  /// 색상 버튼 간격 (기본값: AppSizes.spaceS)
  final double spacing;

  /// 사용 가능한 색상 목록 (기본값: 미리 정의된 18가지 색상)
  final List<Color>? availableColors;

  /// RGB 입력 필드 표시 여부 (기본값: true)
  final bool showRgbInput;

  /// 고급 색상 팔레트 버튼 표시 여부 (기본값: true)
  final bool showAdvancedPicker;

  const ColorPicker({
    super.key,
    this.selectedColor,
    required this.onColorSelected,
    this.colorButtonSize = 40,
    this.spacing = AppSizes.spaceS,
    this.availableColors,
    this.showRgbInput = true,
    this.showAdvancedPicker = true,
  });

  /// 기본 색상 팔레트
  static const List<Color> defaultColors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
  ];

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late TextEditingController _rController;
  late TextEditingController _gController;
  late TextEditingController _bController;

  @override
  void initState() {
    super.initState();
    final color = widget.selectedColor ?? Colors.blue;
    _rController = TextEditingController(text: _getColorComponent(color.r).toString());
    _gController = TextEditingController(text: _getColorComponent(color.g).toString());
    _bController = TextEditingController(text: _getColorComponent(color.b).toString());
  }

  int _getColorComponent(double value) {
    return (value * 255.0).round().clamp(0, 255);
  }

  @override
  void didUpdateWidget(ColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedColor != oldWidget.selectedColor && widget.selectedColor != null) {
      _updateRgbControllers(widget.selectedColor!);
    }
  }

  @override
  void dispose() {
    _rController.dispose();
    _gController.dispose();
    _bController.dispose();
    super.dispose();
  }

  void _updateRgbControllers(Color color) {
    _rController.text = _getColorComponent(color.r).toString();
    _gController.text = _getColorComponent(color.g).toString();
    _bController.text = _getColorComponent(color.b).toString();
  }

  void _onRgbChanged() {
    final r = int.tryParse(_rController.text) ?? 0;
    final g = int.tryParse(_gController.text) ?? 0;
    final b = int.tryParse(_bController.text) ?? 0;

    if (r >= 0 && r <= 255 && g >= 0 && g <= 255 && b >= 0 && b <= 255) {
      widget.onColorSelected(Color.fromARGB(255, r, g, b));
    }
  }

  Future<void> _showAdvancedColorPicker() async {
    final Color? pickedColor = await showDialog<Color>(
      context: context,
      builder: (context) => _AdvancedColorPickerDialog(
        initialColor: widget.selectedColor ?? Colors.blue,
      ),
    );

    if (pickedColor != null) {
      widget.onColorSelected(pickedColor);
      _updateRgbControllers(pickedColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.availableColors ?? ColorPicker.defaultColors;
    final currentColor = widget.selectedColor ?? Colors.blue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 현재 선택된 색상 미리보기
        Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: currentColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!, width: 2),
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceM,
                vertical: AppSizes.spaceS,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'RGB(${_getColorComponent(currentColor.r)}, ${_getColorComponent(currentColor.g)}, ${_getColorComponent(currentColor.b)})',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSizes.spaceM),

        // 기본 색상 팔레트
        Wrap(
          spacing: widget.spacing,
          runSpacing: widget.spacing,
          children: colors.map((color) {
            final isSelected = widget.selectedColor == color;
            return InkWell(
              onTap: () {
                widget.onColorSelected(color);
                _updateRgbControllers(color);
              },
              child: Container(
                width: widget.colorButtonSize,
                height: widget.colorButtonSize,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: Colors.black, width: 3)
                      : Border.all(color: Colors.grey[300]!),
                ),
              ),
            );
          }).toList(),
        ),

        // RGB 입력 필드
        if (widget.showRgbInput) ...[
          const SizedBox(height: AppSizes.spaceM),
          const Divider(),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            'RGB 값 입력',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: AppSizes.spaceS),
          Row(
            children: [
              Expanded(
                child: _RgbTextField(
                  controller: _rController,
                  label: 'R',
                  color: Colors.red,
                  onChanged: (_) => _onRgbChanged(),
                ),
              ),
              const SizedBox(width: AppSizes.spaceS),
              Expanded(
                child: _RgbTextField(
                  controller: _gController,
                  label: 'G',
                  color: Colors.green,
                  onChanged: (_) => _onRgbChanged(),
                ),
              ),
              const SizedBox(width: AppSizes.spaceS),
              Expanded(
                child: _RgbTextField(
                  controller: _bController,
                  label: 'B',
                  color: Colors.blue,
                  onChanged: (_) => _onRgbChanged(),
                ),
              ),
            ],
          ),
        ],

        // 고급 색상 팔레트 버튼
        if (widget.showAdvancedPicker) ...[
          const SizedBox(height: AppSizes.spaceM),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _showAdvancedColorPicker,
              icon: const Icon(Icons.palette),
              label: const Text('더 많은 색상 선택'),
            ),
          ),
        ],
      ],
    );
  }
}

/// RGB 입력 텍스트 필드
class _RgbTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Color color;
  final ValueChanged<String>? onChanged;

  const _RgbTextField({
    required this.controller,
    required this.label,
    required this.color,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceS,
          vertical: AppSizes.spaceS,
        ),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _RgbValueFormatter(),
      ],
      onChanged: onChanged,
    );
  }
}

/// RGB 값 입력 포매터 (0-255 범위 제한)
class _RgbValueFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final int? value = int.tryParse(newValue.text);
    if (value == null || value > 255) {
      return oldValue;
    }

    return newValue;
  }
}

/// 고급 색상 선택 다이얼로그
class _AdvancedColorPickerDialog extends StatefulWidget {
  final Color initialColor;

  const _AdvancedColorPickerDialog({
    required this.initialColor,
  });

  @override
  State<_AdvancedColorPickerDialog> createState() => _AdvancedColorPickerDialogState();
}

class _AdvancedColorPickerDialogState extends State<_AdvancedColorPickerDialog> {
  late Color _selectedColor;
  late double _hue;
  late double _saturation;
  late double _value;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
    final hsv = HSVColor.fromColor(_selectedColor);
    _hue = hsv.hue;
    _saturation = hsv.saturation;
    _value = hsv.value;
  }

  void _updateColor() {
    setState(() {
      _selectedColor = HSVColor.fromAHSV(1.0, _hue, _saturation, _value).toColor();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('색상 선택'),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 선택된 색상 미리보기
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: _selectedColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
            ),
            const SizedBox(height: AppSizes.spaceM),

            // 색조(Hue) 슬라이더
            _ColorSlider(
              label: '색조',
              value: _hue,
              max: 360,
              onChanged: (value) {
                setState(() {
                  _hue = value;
                  _updateColor();
                });
              },
              gradientColors: List.generate(
                7,
                (index) => HSVColor.fromAHSV(1.0, index * 60.0, 1.0, 1.0).toColor(),
              ),
            ),
            const SizedBox(height: AppSizes.spaceS),

            // 채도(Saturation) 슬라이더
            _ColorSlider(
              label: '채도',
              value: _saturation,
              max: 1.0,
              onChanged: (value) {
                setState(() {
                  _saturation = value;
                  _updateColor();
                });
              },
              gradientColors: [
                HSVColor.fromAHSV(1.0, _hue, 0.0, _value).toColor(),
                HSVColor.fromAHSV(1.0, _hue, 1.0, _value).toColor(),
              ],
            ),
            const SizedBox(height: AppSizes.spaceS),

            // 명도(Value) 슬라이더
            _ColorSlider(
              label: '명도',
              value: _value,
              max: 1.0,
              onChanged: (value) {
                setState(() {
                  _value = value;
                  _updateColor();
                });
              },
              gradientColors: [
                Colors.black,
                HSVColor.fromAHSV(1.0, _hue, _saturation, 1.0).toColor(),
              ],
            ),

            const SizedBox(height: AppSizes.spaceM),

            // RGB 값 표시
            Container(
              padding: const EdgeInsets.all(AppSizes.spaceS),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _RgbDisplay('R', (_selectedColor.r * 255.0).round().clamp(0, 255)),
                  _RgbDisplay('G', (_selectedColor.g * 255.0).round().clamp(0, 255)),
                  _RgbDisplay('B', (_selectedColor.b * 255.0).round().clamp(0, 255)),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _selectedColor),
          child: const Text('선택'),
        ),
      ],
    );
  }
}

/// 색상 슬라이더 위젯
class _ColorSlider extends StatelessWidget {
  final String label;
  final double value;
  final double max;
  final ValueChanged<double> onChanged;
  final List<Color> gradientColors;

  const _ColorSlider({
    required this.label,
    required this.value,
    required this.max,
    required this.onChanged,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ${value.toStringAsFixed(0)}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradientColors),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Slider(
            value: value,
            max: max,
            onChanged: onChanged,
            activeColor: Colors.transparent,
            inactiveColor: Colors.transparent,
          ),
        ),
      ],
    );
  }
}

/// RGB 값 표시 위젯
class _RgbDisplay extends StatelessWidget {
  final String label;
  final int value;

  const _RgbDisplay(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value.toString(),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

/// 색상 선택 다이얼로그를 표시하는 헬퍼 함수
///
/// [context]: BuildContext
/// [title]: 다이얼로그 제목
/// [initialColor]: 초기 선택 색상
/// [confirmText]: 확인 버튼 텍스트 (기본값: '저장')
/// [cancelText]: 취소 버튼 텍스트 (기본값: '취소')
/// [availableColors]: 사용 가능한 색상 목록 (기본값: ColorPicker.defaultColors)
///
/// Returns: 선택된 색상 또는 null (취소된 경우)
Future<Color?> showColorPickerDialog({
  required BuildContext context,
  required String title,
  Color? initialColor,
  String confirmText = '저장',
  String cancelText = '취소',
  List<Color>? availableColors,
}) async {
  Color? selectedColor = initialColor;

  return await showDialog<Color>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(title),
        content: ColorPicker(
          selectedColor: selectedColor,
          onColorSelected: (color) {
            setState(() {
              selectedColor = color;
            });
          },
          availableColors: availableColors,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, selectedColor),
            child: Text(confirmText),
          ),
        ],
      ),
    ),
  );
}
