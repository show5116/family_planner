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
          // 인증 토큰 추가
          final token = await _getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
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
            // Refresh Token으로 재시도
            final refreshed = await _refreshToken();
            if (refreshed) {
              // 원래 요청 재시도
              final options = error.requestOptions;
              final token = await _getAccessToken();
              options.headers['Authorization'] = 'Bearer $token';

              try {
                final response = await _dio.fetch(options);
                return handler.resolve(response);
              } catch (e) {
                return handler.reject(error);
              }
            }
          }

          return handler.next(error);
        },
      ),
    );

    // 로깅 인터셉터 추가 (개발 환경)
    if (EnvironmentConfig.enableLogging) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        requestHeader: true,
        responseHeader: false,
      ));
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

  /// 토큰 갱신
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _dio.post(
        '/api/v1/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['accessToken'] as String?;
        final newRefreshToken = response.data['refreshToken'] as String?;

        if (newAccessToken != null) {
          await saveAccessToken(newAccessToken);
        }
        if (newRefreshToken != null) {
          await saveRefreshToken(newRefreshToken);
        }

        return true;
      }

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
