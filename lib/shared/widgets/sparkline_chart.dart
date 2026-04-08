import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 소형 스파크라인 차트 (투자 지표 목록용)
///
/// [points]가 2개 미만이면 빈 공간을 렌더링합니다.
/// [prevPrice]가 주어지면 전일 종가 기준으로 Y축 범위를 고정하여
/// 변동폭이 작을수록 선이 평평하게, 클수록 가파르게 보입니다.
class SparklineChart extends StatelessWidget {
  const SparklineChart({
    super.key,
    required this.points,
    required this.color,
    this.prevPrice,
    this.width = 60,
    this.height = 32,
    this.strokeWidth = 1.5,
  });

  final List<double> points;
  final Color color;
  final double? prevPrice;
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
                prevPrice: prevPrice,
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
    this.prevPrice,
  });

  final List<double> points;
  final Color color;
  final double strokeWidth;
  final double? prevPrice;

  @override
  void paint(Canvas canvas, Size size) {
    final dataMin = points.reduce(math.min);
    final dataMax = points.reduce(math.max);

    final double minY;
    final double maxY;

    if (prevPrice != null) {
      final ref = prevPrice!;
      final distFromRef = math.max((dataMax - ref).abs(), (dataMin - ref).abs());
      final halfRange = math.max(distFromRef * 1.1, ref * 0.005);
      minY = ref - halfRange;
      maxY = ref + halfRange;
    } else {
      minY = dataMin;
      maxY = dataMax;
    }

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
      old.points != points ||
      old.color != color ||
      old.strokeWidth != strokeWidth ||
      old.prevPrice != prevPrice;
}
