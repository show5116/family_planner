import 'package:flutter/material.dart';
import 'package:family_planner/core/services/api_service_base.dart';

/// API 에러 처리 유틸리티
class ErrorHandler {
  /// API 에러를 처리하고 화면에 에러 메시지를 표시합니다.
  ///
  /// [context] - BuildContext
  /// [error] - 발생한 에러 객체
  /// [onRetry] - 재시도 콜백 함수 (선택사항)
  static void showErrorSnackBar(
    BuildContext context,
    dynamic error, {
    VoidCallback? onRetry,
  }) {
    final errorMessage = _getErrorMessage(error);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        action: onRetry != null
            ? SnackBarAction(
                label: '재시도',
                textColor: Colors.white,
                onPressed: onRetry,
              )
            : null,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// API 에러를 처리하고 다이얼로그로 에러 메시지를 표시합니다.
  ///
  /// [context] - BuildContext
  /// [error] - 발생한 에러 객체
  /// [title] - 다이얼로그 제목 (기본값: '오류')
  /// [onRetry] - 재시도 콜백 함수 (선택사항)
  static void showErrorDialog(
    BuildContext context,
    dynamic error, {
    String title = '오류',
    VoidCallback? onRetry,
  }) {
    final errorMessage = _getErrorMessage(error);

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(errorMessage),
        actions: [
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry();
              },
              child: const Text('재시도'),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  /// 에러 객체에서 사용자 친화적인 에러 메시지를 추출합니다.
  ///
  /// [error] - 발생한 에러 객체
  /// 반환값: 사용자에게 표시할 에러 메시지
  static String _getErrorMessage(dynamic error) {
    // ApiException인 경우 메시지 추출
    if (error is ApiException) {
      return error.message;
    }

    // Exception인 경우 toString()에서 메시지 추출
    if (error is Exception) {
      final errorString = error.toString();
      // "Exception: " 접두사 제거
      if (errorString.startsWith('Exception: ')) {
        return errorString.substring(11);
      }
      return errorString;
    }

    // 그 외의 경우 toString()
    return error.toString();
  }

  /// 에러 메시지를 추출합니다 (public 메서드)
  static String getErrorMessage(dynamic error) {
    return _getErrorMessage(error);
  }
}
