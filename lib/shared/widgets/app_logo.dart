import 'package:flutter/material.dart';

/// Family Planner 앱 로고 위젯
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 120, this.showOnlySubtitle = false});

  final double size;
  final bool showOnlySubtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 로고 아이콘
        SizedBox(
          width: size,
          height: size,
          child: Image.asset(
            'assets/images/logos/logo.png',
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
