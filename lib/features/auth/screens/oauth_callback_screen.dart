import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
import 'package:family_planner/features/auth/services/oauth_popup_helper_web.dart';

/// OAuth 콜백 화면
///
/// 백엔드로부터 리다이렉트된 URL에서 토큰을 추출하여 처리합니다.
///
/// **토큰 전달 방식:**
/// - 웹: accessToken은 쿼리 파라미터, refreshToken은 HTTP Only Cookie
/// - 모바일: accessToken, refreshToken 모두 쿼리 파라미터
class OAuthCallbackScreen extends ConsumerStatefulWidget {
  const OAuthCallbackScreen({
    super.key,
    required this.accessToken,
    this.refreshToken, // 웹에서는 null (쿠키로 관리)
  });

  final String accessToken;
  final String? refreshToken;

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

    // 팝업인 경우 즉시 메시지 전송하고 종료
    if (kIsWeb && OAuthPopupHelper.isPopup()) {
      debugPrint('=== OAuthCallbackScreen: Popup detected (initState) ===');
      debugPrint('Sending message to parent and closing popup...');

      // 웹 팝업: accessToken만 전송 (refreshToken은 쿠키로 관리)
      final message = <String, String>{
        'accessToken': widget.accessToken,
      };

      // 모바일의 경우 refreshToken도 포함 (혹시 쿼리에 있다면)
      if (widget.refreshToken != null) {
        message['refreshToken'] = widget.refreshToken!;
      }

      OAuthPopupHelper.sendMessageToParent(message);
      // 창이 닫히므로 더 이상 진행하지 않음
      return;
    }

    // 팝업이 아닌 경우에만 콜백 처리
    _processCallback();
  }

  Future<void> _processCallback() async {
    try {
      debugPrint('=== OAuthCallbackScreen: Processing callback (not popup) ===');
      debugPrint('Platform: ${kIsWeb ? "Web" : "Mobile"}');
      debugPrint('RefreshToken in query: ${widget.refreshToken != null}');

      // 팝업이 아닌 경우 (일반 페이지 리다이렉트): 기존 로직 실행
      debugPrint('Not a popup, processing callback normally');

      // AuthNotifier의 공개 메서드를 통해 OAuth 콜백 처리
      // 웹: accessToken만 전달 (refreshToken은 쿠키로 관리)
      // 모바일: accessToken, refreshToken 모두 전달
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
    // 팝업인 경우 간단한 메시지만 표시
    if (kIsWeb && OAuthPopupHelper.isPopup()) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('로그인 처리 중...'),
              SizedBox(height: 8),
              Text(
                '잠시만 기다려주세요.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

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
