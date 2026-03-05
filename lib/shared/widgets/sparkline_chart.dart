import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 소형 스파크라인 차트 (투자 지표 목록용)
///
/// [points]가 2개 미만이면 빈 공간을 렌더링합니다.
class SparklineChart extends StatelessWidget {
  const SparklineChart({
    super.key,
    required this.points,
    required this.color,
    this.width = 60,
    this.height = 32,
    this.strokeWidth = 1.5,
  });

  final List<double> points;
  final Color color;
  final double width;
  final double height;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: points.length >= 2
          ? CustomPaint(
              painter: _SparklinePainter(
                points: points,
                color: color,
                strokeWidth: strokeWidth,
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  const _SparklinePainter({
    required this.points,
    required this.color,
    required this.strokeWidth,
  });

  final List<double> points;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final minY = points.reduce(math.min);
    final maxY = points.reduce(math.max);
    final rangeY = maxY - minY;

    double toX(int i) => i / (points.length - 1) * size.width;
    double toY(double v) => rangeY == 0
        ? size.height / 2
        : size.height - (v - minY) / rangeY * size.height;

    final path = Path()..moveTo(toX(0), toY(points[0]));
    for (var i = 1; i < points.length; i++) {
      path.lineTo(toX(i), toY(points[i]));
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_SparklinePainter old) =>
      old.points != points || old.color != color || old.strokeWidth != strokeWidth;
}
