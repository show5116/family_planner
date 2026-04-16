import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:family_planner/core/constants/app_sizes.dart';

/// 색상 선택 위젯
///
/// 기본 10가지 색상만 표시하고, "더 보기" 버튼을 누르면
/// 전체 팔레트 + RGB 입력 + 고급 팔레트가 펼쳐집니다.
///
/// Example:
/// ```dart
/// ColorPicker(
///   selectedColor: Colors.blue,
///   onColorSelected: (color) {
///     print('Selected color: $color');
///   },
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

  const ColorPicker({
    super.key,
    this.selectedColor,
    required this.onColorSelected,
    this.colorButtonSize = 40,
    this.spacing = AppSizes.spaceS,
    this.availableColors,
  });

  /// 기본으로 보이는 10가지 색상
  static const List<Color> defaultColors = [
    Color(0xFFEF4444), // red
    Color(0xFFF97316), // orange
    Color(0xFFEAB308), // yellow
    Color(0xFF22C55E), // green
    Color(0xFF14B8A6), // teal
    Color(0xFF3B82F6), // blue
    Color(0xFF6366F1), // indigo
    Color(0xFFA855F7), // purple
    Color(0xFFEC4899), // pink
    Color(0xFF78716C), // stone
  ];

  /// 확장 시 추가로 보이는 색상 (전체 팔레트)
  static const List<Color> extendedColors = [
    Color(0xFFEF4444), // red
    Color(0xFFDC2626), // red-dark
    Color(0xFFF97316), // orange
    Color(0xFFEA580C), // orange-dark
    Color(0xFFEAB308), // yellow
    Color(0xFFCA8A04), // yellow-dark
    Color(0xFF22C55E), // green
    Color(0xFF16A34A), // green-dark
    Color(0xFF14B8A6), // teal
    Color(0xFF0D9488), // teal-dark
    Color(0xFF06B6D4), // cyan
    Color(0xFF0891B2), // cyan-dark
    Color(0xFF3B82F6), // blue
    Color(0xFF2563EB), // blue-dark
    Color(0xFF6366F1), // indigo
    Color(0xFF4F46E5), // indigo-dark
    Color(0xFFA855F7), // purple
    Color(0xFF9333EA), // purple-dark
    Color(0xFFEC4899), // pink
    Color(0xFFDB2777), // pink-dark
    Color(0xFF78716C), // stone
    Color(0xFF44403C), // stone-dark
    Color(0xFF94A3B8), // slate
    Color(0xFF64748B), // slate-dark
  ];

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  bool _isExpanded = false;

  late TextEditingController _rController;
  late TextEditingController _gController;
  late TextEditingController _bController;

  @override
  void initState() {
    super.initState();
    final color = widget.selectedColor ?? Colors.blue;
    _rController = TextEditingController(text: _toInt(color.r).toString());
    _gController = TextEditingController(text: _toInt(color.g).toString());
    _bController = TextEditingController(text: _toInt(color.b).toString());
  }

  int _toInt(double value) => (value * 255.0).round().clamp(0, 255);

  @override
  void didUpdateWidget(ColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedColor != oldWidget.selectedColor &&
        widget.selectedColor != null) {
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
    _rController.text = _toInt(color.r).toString();
    _gController.text = _toInt(color.g).toString();
    _bController.text = _toInt(color.b).toString();
  }

  void _onColorTap(Color color) {
    widget.onColorSelected(color);
    _updateRgbControllers(color);
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
    final baseColors = widget.availableColors ?? ColorPicker.defaultColors;
    final allColors = widget.availableColors ?? ColorPicker.extendedColors;
    final currentColor = widget.selectedColor ?? Colors.blue;
    final displayColors = _isExpanded ? allColors : baseColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 기본/확장 색상 팔레트
        Wrap(
          spacing: widget.spacing,
          runSpacing: widget.spacing,
          children: [
            ...displayColors.map((color) {
              final isSelected = widget.selectedColor == color;
              return InkWell(
                onTap: () => _onColorTap(color),
                borderRadius: BorderRadius.circular(widget.colorButtonSize),
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
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 20)
                      : null,
                ),
              );
            }),
            // 더 보기 / 접기 버튼
            if (widget.availableColors == null)
              InkWell(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                borderRadius: BorderRadius.circular(widget.colorButtonSize),
                child: Container(
                  width: widget.colorButtonSize,
                  height: widget.colorButtonSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[400]!),
                    color: Colors.grey[100],
                  ),
                  child: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                ),
              ),
          ],
        ),

        // 확장 시 추가 UI
        if (_isExpanded) ...[
          const SizedBox(height: AppSizes.spaceM),

          // 현재 선택된 색상 미리보기
          Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              color: currentColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!, width: 2),
            ),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceM,
                  vertical: AppSizes.spaceXS,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'RGB(${_toInt(currentColor.r)}, ${_toInt(currentColor.g)}, ${_toInt(currentColor.b)})',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.spaceM),

          // RGB 입력 필드
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
          const SizedBox(height: AppSizes.spaceM),

          // 고급 색상 팔레트 버튼
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
    if (newValue.text.isEmpty) return newValue;
    final int? value = int.tryParse(newValue.text);
    if (value == null || value > 255) return oldValue;
    return newValue;
  }
}

/// 고급 색상 선택 다이얼로그 (HSV 슬라이더)
class _AdvancedColorPickerDialog extends StatefulWidget {
  final Color initialColor;

  const _AdvancedColorPickerDialog({required this.initialColor});

  @override
  State<_AdvancedColorPickerDialog> createState() =>
      _AdvancedColorPickerDialogState();
}

class _AdvancedColorPickerDialogState
    extends State<_AdvancedColorPickerDialog> {
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
      _selectedColor =
          HSVColor.fromAHSV(1.0, _hue, _saturation, _value).toColor();
    });
  }

  int _toInt(double v) => (v * 255).round().clamp(0, 255);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('색상 선택'),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: _selectedColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
            ),
            const SizedBox(height: AppSizes.spaceM),
            _ColorSlider(
              label: '색조',
              value: _hue,
              max: 360,
              onChanged: (v) {
                _hue = v;
                _updateColor();
              },
              gradientColors: List.generate(
                7,
                (i) => HSVColor.fromAHSV(1.0, i * 60.0, 1.0, 1.0).toColor(),
              ),
            ),
            const SizedBox(height: AppSizes.spaceS),
            _ColorSlider(
              label: '채도',
              value: _saturation,
              max: 1.0,
              onChanged: (v) {
                _saturation = v;
                _updateColor();
              },
              gradientColors: [
                HSVColor.fromAHSV(1.0, _hue, 0.0, _value).toColor(),
                HSVColor.fromAHSV(1.0, _hue, 1.0, _value).toColor(),
              ],
            ),
            const SizedBox(height: AppSizes.spaceS),
            _ColorSlider(
              label: '명도',
              value: _value,
              max: 1.0,
              onChanged: (v) {
                _value = v;
                _updateColor();
              },
              gradientColors: [
                Colors.black,
                HSVColor.fromAHSV(1.0, _hue, _saturation, 1.0).toColor(),
              ],
            ),
            const SizedBox(height: AppSizes.spaceM),
            Container(
              padding: const EdgeInsets.all(AppSizes.spaceS),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _RgbDisplay('R', _toInt(_selectedColor.r)),
                  _RgbDisplay('G', _toInt(_selectedColor.g)),
                  _RgbDisplay('B', _toInt(_selectedColor.b)),
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
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(value.toString(), style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}

/// 색상 선택 다이얼로그를 표시하는 헬퍼 함수
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
            setState(() => selectedColor = color);
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
