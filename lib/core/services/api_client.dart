import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:family_planner/core/config/environment.dart';
import 'package:family_planner/core/services/secure_storage_service.dart';

/// API 클라이언트 (Dio 기반)
/// 토큰은 FlutterSecureStorage에 암호화되어 저장됩니다.
class ApiClient {
  late final Dio _dio;
  static ApiClient? _instance;
  final SecureStorageService _secureStorage = SecureStorageService();

  // 토큰 갱신 중복 방지를 위한 Future
  Future<bool>? _refreshTokenFuture;

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: EnvironmentConfig.apiBaseUrl,
        connectTimeout: Duration(milliseconds: EnvironmentConfig.apiTimeout),
        receiveTimeout: Duration(milliseconds: EnvironmentConfig.apiTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  /// 싱글톤 인스턴스
  static ApiClient get instance {
    _instance ??= ApiClient._internal();
    return _instance!;
  }

  /// Dio 인스턴스 getter
  Dio get dio => _dio;

  /// 인터셉터 설정
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // retry 플래그가 있으면 토큰 재설정을 건너뜀 (이미 설정됨)
          if (options.extra['retry_with_new_token'] != true) {
            // 인증 토큰 추가
            final token = await _getAccessToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }

          // 로그 출력 (개발 환경)
          if (EnvironmentConfig.enableLogging) {
            debugPrint('┌── Request ────────────────────────────────────');
            debugPrint('│ ${options.method} ${options.uri}');
            debugPrint('│ Headers: ${options.headers}');
            if (options.data != null) {
              debugPrint('│ Body: ${options.data}');
            }
            debugPrint('└───────────────────────────────────────────────');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          // 로그 출력 (개발 환경)
          if (EnvironmentConfig.enableLogging) {
            debugPrint('┌── Response ───────────────────────────────────');
            debugPrint('│ Status: ${response.statusCode}');
            debugPrint('│ Data: ${response.data}');
            debugPrint('└───────────────────────────────────────────────');
          }

          return handler.next(response);
        },
        onError: (error, handler) async {
          // 로그 출력
          if (EnvironmentConfig.enableLogging) {
            debugPrint('┌── Error ──────────────────────────────────────');
            debugPrint('│ ${error.message}');
            debugPrint('│ ${error.response?.data}');
            debugPrint('└───────────────────────────────────────────────');
          }

          // 401 에러 처리 (토큰 만료)
          if (error.response?.statusCode == 401) {
            final requestPath = error.requestOptions.path;

            // /auth/refresh 요청 자체가 실패한 경우 재시도하지 않음 (무한 루프 방지)
            if (requestPath.contains('/auth/refresh')) {
              debugPrint('Refresh token request failed - clearing tokens');
              await clearTokens();
              return handler.next(error);
            }

            // Refresh Token으로 재시도
            debugPrint('Attempting token refresh...');
            final refreshed = await _refreshToken();
            if (refreshed) {
              debugPrint('Token refresh successful - retrying original request');
              // 원래 요청 재시도
              final options = error.requestOptions;
              final token = await _getAccessToken();

              if (token != null) {
                options.headers['Authorization'] = 'Bearer $token';
                // retry 플래그를 설정하여 onRequest에서 토큰을 다시 설정하지 않도록 함
                options.extra['retry_with_new_token'] = true;
                debugPrint('Updated Authorization header with new token');
                debugPrint('Token value: ${token.substring(0, 20)}...');
              } else {
                debugPrint('Warning: New access token is null');
              }

              try {
                // 재시도 (onRequest에서 retry 플래그를 확인하여 토큰 재설정을 건너뜀)
                final response = await _dio.fetch(options);
                return handler.resolve(response);
              } catch (e) {
                debugPrint('Retry request failed: $e');
                return handler.reject(error);
              }
            } else {
              // Refresh 실패 시 토큰 삭제
              debugPrint('Token refresh failed - clearing tokens');
              await clearTokens();
            }
          }

          return handler.next(error);
        },
      ),
    );

    // 로깅 인터셉터 추가 (개발 환경)
    if (EnvironmentConfig.enableLogging) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
          requestHeader: true,
          responseHeader: false,
        ),
      );
    }
  }

  /// Access Token 가져오기
  Future<String?> _getAccessToken() async {
    return await _secureStorage.getAccessToken();
  }

  /// Access Token 저장
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.saveAccessToken(token);
  }

  /// Refresh Token 가져오기
  Future<String?> _getRefreshToken() async {
    return await _secureStorage.getRefreshToken();
  }

  /// Refresh Token 저장
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.saveRefreshToken(token);
  }

  /// 토큰 갱신 (중복 호출 방지)
  Future<bool> _refreshToken() async {
    // 이미 토큰 갱신이 진행 중이면 해당 Future를 재사용
    if (_refreshTokenFuture != null) {
      debugPrint('Token refresh already in progress, waiting...');
      return await _refreshTokenFuture!;
    }

    // 새로운 토큰 갱신 작업 시작
    _refreshTokenFuture = _performRefreshToken();

    try {
      final result = await _refreshTokenFuture!;
      return result;
    } finally {
      // 완료 후 Future 초기화
      _refreshTokenFuture = null;
    }
  }

  /// 실제 토큰 갱신 로직
  Future<bool> _performRefreshToken() async {
    try {
      final refreshToken = await _getRefreshToken();
      if (refreshToken == null) {
        debugPrint('No refresh token available');
        return false;
      }

      debugPrint('Sending refresh token request...');
      // Options를 사용하여 Authorization 헤더를 명시적으로 제거
      final response = await _dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
        options: Options(
          headers: {
            'Authorization': null, // Authorization 헤더 제거
          },
        ),
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['accessToken'] as String?;
        final newRefreshToken = response.data['refreshToken'] as String?;

        debugPrint('Refresh token response received');
        debugPrint('New access token: ${newAccessToken != null ? "present" : "null"}');
        debugPrint('New refresh token: ${newRefreshToken != null ? "present" : "null"}');

        if (newAccessToken != null) {
          await saveAccessToken(newAccessToken);
          debugPrint('New access token saved to storage');
        }
        if (newRefreshToken != null) {
          await saveRefreshToken(newRefreshToken);
          debugPrint('New refresh token saved to storage');
        }

        return true;
      }

      debugPrint('Refresh token response status: ${response.statusCode}');
      return false;
    } catch (e) {
      debugPrint('Token refresh failed: $e');
      return false;
    }
  }

  /// 모든 토큰 삭제 (로그아웃 시)
  Future<void> clearTokens() async {
    await _secureStorage.clearTokens();
    debugPrint('All tokens cleared from SecureStorage');
  }

  /// 토큰 존재 여부 확인
  Future<bool> hasValidToken() async {
    final accessToken = await _getAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }

  /// Access Token 가져오기 (Public)
  Future<String?> getAccessToken() async {
    return await _getAccessToken();
  }

  /// Refresh Token 가져오기 (Public)
  Future<String?> getRefreshToken() async {
    return await _getRefreshToken();
  }

  // HTTP Methods

  /// GET 요청
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// POST 요청
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// PUT 요청
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// PATCH 요청
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// DELETE 요청
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
