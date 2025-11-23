import 'package:flutter/material.dart';

/// 앱 시작 시 로딩 화면
///
/// 토큰 검증 중에 표시됩니다.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
