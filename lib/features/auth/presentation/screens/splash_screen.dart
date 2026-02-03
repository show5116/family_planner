import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/shared/widgets/app_logo.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';

/// 앱 시작 시 로딩 화면
///
/// 토큰 검증 중에 표시됩니다.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // 페이드 아웃 애니메이션 초기화
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    // 인증 상태 확인 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).checkAuthStatus();
    });

    // 인증 상태 변화 감지
    ref.listenManual<AuthState>(authProvider, (previous, next) {
      // 인증 상태가 확정되면 (null이 아니면) 페이드 아웃 시작
      if (next.isAuthenticated != null && mounted) {
        _fadeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          color: Colors.white,
          child: const Center(child: AppLogo(size: 600)),
        ),
      ),
    );
  }
}
