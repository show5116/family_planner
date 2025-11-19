import 'package:flutter/material.dart';
import 'package:family_planner/core/constants/app_colors.dart';

/// Family Planner 앱 로고 위젯
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 120,
    this.showText = true,
  });

  final double size;
  final bool showText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 로고 아이콘
        _LogoIcon(size: size),
        if (showText) ...[
          SizedBox(height: size * 0.15),
          // 앱 이름
          Text(
            'Family Planner',
            style: TextStyle(
              fontSize: size * 0.25,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: size * 0.05),
          Text(
            '가족과 함께하는 일상',
            style: TextStyle(
              fontSize: size * 0.12,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ],
    );
  }
}

/// 로고 아이콘 부분
class _LogoIcon extends StatelessWidget {
  const _LogoIcon({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 배경 원 (그라디언트)
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primaryDark,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: size * 0.15,
                  offset: Offset(0, size * 0.08),
                ),
              ],
            ),
          ),
          // 집 모양 (흰색)
          CustomPaint(
            size: Size(size * 0.6, size * 0.6),
            painter: _HousePainter(color: Colors.white),
          ),
          // 체크마크 (오렌지)
          Positioned(
            right: size * 0.1,
            top: size * 0.1,
            child: Container(
              width: size * 0.35,
              height: size * 0.35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary,
                border: Border.all(
                  color: Colors.white,
                  width: size * 0.03,
                ),
              ),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: size * 0.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 집 모양을 그리는 CustomPainter
class _HousePainter extends CustomPainter {
  _HousePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    // 지붕 (삼각형)
    path.moveTo(size.width * 0.5, size.height * 0.15); // 꼭대기
    path.lineTo(size.width * 0.05, size.height * 0.5); // 왼쪽 끝
    path.lineTo(size.width * 0.95, size.height * 0.5); // 오른쪽 끝
    path.close();

    // 벽 (사각형)
    path.addRect(Rect.fromLTWH(
      size.width * 0.15,
      size.height * 0.45,
      size.width * 0.7,
      size.height * 0.5,
    ));

    // 문 (작은 사각형)
    final doorPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.4,
        size.height * 0.65,
        size.width * 0.2,
        size.height * 0.3,
      ),
      doorPaint,
    );

    // 지붕과 벽 그리기
    canvas.drawPath(path, paint);

    // 창문 (좌측)
    final windowPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.22,
        size.height * 0.55,
        size.width * 0.12,
        size.height * 0.12,
      ),
      windowPaint,
    );

    // 창문 (우측)
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.66,
        size.height * 0.55,
        size.width * 0.12,
        size.height * 0.12,
      ),
      windowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 간단한 아이콘 버전 로고 (앱바용)
class AppLogoIcon extends StatelessWidget {
  const AppLogoIcon({
    super.key,
    this.size = 32,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
          ],
        ),
      ),
      child: Icon(
        Icons.home_outlined,
        color: Colors.white,
        size: size * 0.6,
      ),
    );
  }
}
