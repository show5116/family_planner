import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';

/// OAuth 콜백 화면
///
/// 백엔드로부터 리다이렉트된 URL에서 토큰을 추출하여 처리합니다.
/// 웹 전용 화면이며, 모바일에서는 Deep Link가 자동으로 처리합니다.
class OAuthCallbackScreen extends ConsumerStatefulWidget {
  const OAuthCallbackScreen({
    super.key,
    required this.accessToken,
    required this.refreshToken,
  });

  final String accessToken;
  final String refreshToken;

  @override
  ConsumerState<OAuthCallbackScreen> createState() =>
      _OAuthCallbackScreenState();
}

class _OAuthCallbackScreenState extends ConsumerState<OAuthCallbackScreen> {
  bool _isProcessing = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _processCallback();
  }

  Future<void> _processCallback() async {
    try {
      debugPrint('=== OAuthCallbackScreen: Processing callback ===');

      // AuthNotifier의 공개 메서드를 통해 OAuth 콜백 처리
      await ref.read(authProvider.notifier).handleWebOAuthCallback(
        accessToken: widget.accessToken,
        refreshToken: widget.refreshToken,
      );

      debugPrint('OAuth callback processed, waiting for navigation...');

      // 홈으로 이동
      if (mounted) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          debugPrint('Navigating to home...');
          context.go(AppRoutes.home);
        }
      }
    } catch (e) {
      debugPrint('Error in _processCallback: $e');
      setState(() {
        _isProcessing = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isProcessing
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    '로그인 처리 중...',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '로그인 실패',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _error ?? '알 수 없는 오류가 발생했습니다',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go(AppRoutes.login),
                    child: const Text('로그인 화면으로 돌아가기'),
                  ),
                ],
              ),
      ),
    );
  }
}
