import 'package:flutter/foundation.dart';
import 'package:family_planner/core/services/api_service_base.dart';
import 'package:family_planner/core/constants/api_constants.dart';

/// 인증 서비스
class AuthService extends ApiServiceBase {
  /// 로그인
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = handleResponse<Map<String, dynamic>>(response);

      // 토큰 저장
      if (data['accessToken'] != null) {
        await apiClient.saveAccessToken(data['accessToken'] as String);
      }
      if (data['refreshToken'] != null) {
        await apiClient.saveRefreshToken(data['refreshToken'] as String);
      }

      return data;
    } catch (e) {
      throw handleError(e);
    }
  }

  /// 회원가입
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.register,
        data: {
          'email': email,
          'password': password,
          'name': name,
        },
      );

      return handleResponse<Map<String, dynamic>>(response);
    } catch (e) {
      throw handleError(e);
    }
  }

  /// 로그아웃
  Future<void> logout() async {
    try {
      await apiClient.post(ApiConstants.logout);
    } catch (e) {
      // 로그아웃 실패해도 로컬 토큰은 삭제
      debugPrint('Logout API failed: $e');
    } finally {
      // 로컬 토큰 삭제
      await apiClient.clearTokens();
    }
  }

  /// 토큰 검증
  Future<bool> verifyToken() async {
    try {
      final response = await apiClient.get(ApiConstants.verifyToken);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// 토큰 갱신
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await apiClient.post(
        ApiConstants.refreshToken,
        data: {
          'refreshToken': refreshToken,
        },
      );

      final data = handleResponse<Map<String, dynamic>>(response);

      // 새 토큰 저장
      if (data['accessToken'] != null) {
        await apiClient.saveAccessToken(data['accessToken'] as String);
      }
      if (data['refreshToken'] != null) {
        await apiClient.saveRefreshToken(data['refreshToken'] as String);
      }

      return data;
    } catch (e) {
      throw handleError(e);
    }
  }

  /// 이메일 인증
  Future<Map<String, dynamic>> verifyEmail({
    required String code,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.verifyEmail,
        data: {
          'code': code,
        },
      );

      return handleResponse<Map<String, dynamic>>(response);
    } catch (e) {
      throw handleError(e);
    }
  }

  /// 인증 이메일 재전송
  Future<Map<String, dynamic>> resendVerification({
    required String email,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.resendVerification,
        data: {
          'email': email,
        },
      );

      return handleResponse<Map<String, dynamic>>(response);
    } catch (e) {
      throw handleError(e);
    }
  }
}
