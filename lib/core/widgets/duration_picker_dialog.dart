import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/widgets/wheel_number_picker.dart';

/// 시간 간격 선택 다이얼로그
///
/// 일, 시간, 분 단위로 Duration을 선택할 수 있는 다이얼로그입니다.
/// 알림 시간, 타이머, 예약 시간 등에 활용할 수 있습니다.
///
/// ```dart
/// final duration = await DurationPickerDialog.show(
///   context: context,
///   title: '알림 시간 설정',
///   initialDuration: Duration(hours: 1),
/// );
/// ```
class DurationPickerDialog extends StatefulWidget {
  /// 다이얼로그 제목
  final String title;

  /// 부제목/설명 (선택)
  final String? subtitle;

  /// 초기 Duration 값
  final Duration initialDuration;

  /// 최대 선택 가능 일수 (기본: 30)
  final int maxDays;

  /// 분 단위 간격 (기본: 5분)
  final int minuteInterval;

  /// 확인 버튼 텍스트
  final String confirmText;

  /// 취소 버튼 텍스트
  final String cancelText;

  /// 미리보기 위젯 빌더 (선택)
  final Widget Function(Duration duration)? previewBuilder;

  const DurationPickerDialog({
    super.key,
    required this.title,
    this.subtitle,
    this.initialDuration = Duration.zero,
    this.maxDays = 30,
    this.minuteInterval = 5,
    this.confirmText = '추가',
    this.cancelText = '취소',
    this.previewBuilder,
  });

  /// 다이얼로그를 표시하고 선택된 Duration을 반환합니다.
  /// 취소하면 null을 반환합니다.
  static Future<Duration?> show({
    required BuildContext context,
    required String title,
    String? subtitle,
    Duration initialDuration = Duration.zero,
    int maxDays = 30,
    int minuteInterval = 5,
    String? confirmText,
    String? cancelText,
    Widget Function(Duration duration)? previewBuilder,
  }) {
    return showDialog<Duration>(
      context: context,
      builder: (context) => DurationPickerDialog(
        title: title,
        subtitle: subtitle,
        initialDuration: initialDuration,
        maxDays: maxDays,
        minuteInterval: minuteInterval,
        confirmText: confirmText ?? '추가',
        cancelText: cancelText ?? '취소',
        previewBuilder: previewBuilder,
      ),
    );
  }

  @override
  State<DurationPickerDialog> createState() => _DurationPickerDialogState();
}

class _DurationPickerDialogState extends State<DurationPickerDialog> {
  late int _days;
  late int _hours;
  late int _minutes;

  @override
  void initState() {
    super.initState();
    _initFromDuration(widget.initialDuration);
  }

  void _initFromDuration(Duration duration) {
    _days = duration.inDays;
    _hours = (duration.inHours % 24);
    _minutes = (duration.inMinutes % 60);
    // 분을 interval에 맞춰 반올림
    _minutes = (_minutes ~/ widget.minuteInterval) * widget.minuteInterval;
  }

  Duration get _currentDuration => Duration(
        days: _days,
        hours: _hours,
        minutes: _minutes,
      );

  int get _totalMinutes => _currentDuration.inMinutes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.subtitle != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.spaceL),
              child: Text(
                widget.subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          WheelPickerRow(
            height: 150,
            children: [
              WheelNumberPicker(
                label: '일',
                itemCount: widget.maxDays + 1,
                initialValue: _days,
                onChanged: (value) => setState(() => _days = value),
              ),
              WheelNumberPicker(
                label: '시간',
                itemCount: 24,
                initialValue: _hours,
                onChanged: (value) => setState(() => _hours = value),
              ),
              WheelNumberPicker(
                label: '분',
                itemCount: 60 ~/ widget.minuteInterval,
                initialValue: _minutes,
                displayMultiplier: widget.minuteInterval,
                onChanged: (value) => setState(() => _minutes = value),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceM),
          if (widget.previewBuilder != null)
            widget.previewBuilder!(_currentDuration)
          else
            _DefaultPreview(duration: _currentDuration),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(widget.cancelText),
        ),
        FilledButton(
          onPressed: _totalMinutes > 0 ? () => Navigator.pop(context, _currentDuration) : null,
          child: Text(widget.confirmText),
        ),
      ],
    );
  }
}

class _DefaultPreview extends StatelessWidget {
  final Duration duration;

  const _DefaultPreview({required this.duration});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: AppSizes.spaceS),
          Text(
            _formatDuration(duration),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration == Duration.zero) return '0분';

    final parts = <String>[];
    if (duration.inDays > 0) {
      parts.add('${duration.inDays}일');
    }
    final hours = duration.inHours % 24;
    if (hours > 0) {
      parts.add('$hours시간');
    }
    final minutes = duration.inMinutes % 60;
    if (minutes > 0) {
      parts.add('$minutes분');
    }
    return parts.join(' ');
  }
}

/// Duration을 분 단위로 포맷팅하는 유틸리티 함수
///
/// 알림 시간 등 분 단위 값을 사람이 읽기 쉬운 형태로 변환합니다.
String formatDurationMinutes(int totalMinutes) {
  if (totalMinutes == 0) return '0분';

  final days = totalMinutes ~/ 1440;
  final hours = (totalMinutes % 1440) ~/ 60;
  final minutes = totalMinutes % 60;

  final parts = <String>[];
  if (days > 0) parts.add('$days일');
  if (hours > 0) parts.add('$hours시간');
  if (minutes > 0) parts.add('$minutes분');

  return parts.join(' ');
}
