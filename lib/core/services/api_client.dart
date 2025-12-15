import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:family_planner/core/config/environment.dart';
import 'package:family_planner/core/services/secure_storage_service.dart';

/// API 클라이언트 (Dio 기반)
///
/// **인증 방식:**
/// - AccessToken: 모든 플랫폼에서 SecureStorage에 저장 및 Authorization 헤더로 전송
/// - RefreshToken:
///   - 웹: HTTP Only Cookie 사용 (백엔드에서 자동으로 쿠키 설정/전송)
///   - 모바일: SecureStorage에 저장 및 요청 body로 전송
class ApiClient {
  late final Dio _dio;
  static ApiClient? _instance;
  final SecureStorageService _secureStorage = SecureStorageService();

  // 토큰 갱신 중복 방지를 위한 Future
  Future<bool>? _refreshTokenFuture;

  // 401 에러 시 호출될 콜백 (로그아웃 처리)
  void Function()? onUnauthorized;

  // API 에러 시 호출될 콜백 (에러 메시지 표시) - 401, 500 제외
  void Function(String message)? onError;

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
        // 웹 환경에서 쿠키 자동 전송 활성화 (RefreshToken용)
        extra: {
          'withCredentials': kIsWeb,
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
          // 웹 환경에서 쿠키 자동 전송 활성화 (RefreshToken용)
          if (kIsWeb) {
            options.extra['withCredentials'] = true;
          }

          // 모든 플랫폼에서 AccessToken을 Authorization 헤더에 추가
          // retry 플래그가 있으면 토큰 재설정을 건너뜀 (이미 설정됨)
          if (options.extra['retry_with_new_token'] != true) {
            final token = await _getAccessToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }

          // 로그 출력 (개발 환경)
          if (EnvironmentConfig.enableLogging) {
            debugPrint('┌── Request ────────────────────────────────────');
            debugPrint('│ ${options.method} ${options.uri}');
            debugPrint('│ Platform: ${kIsWeb ? "Web" : "Mobile"}');
            debugPrint('│ Auth: AccessToken in Header${kIsWeb ? " + RefreshToken in Cookie" : " + RefreshToken in Storage"}');
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

          final statusCode = error.response?.statusCode;

          // 401 에러 처리 (토큰 만료)
          if (statusCode == 401) {
            final requestPath = error.requestOptions.path;

            // /auth/refresh 요청 자체가 실패한 경우 재시도하지 않음 (무한 루프 방지)
            if (requestPath.contains('/auth/refresh')) {
              debugPrint('Refresh token request failed - clearing tokens');
              await clearTokens();

              // 로그아웃 콜백 호출
              if (onUnauthorized != null) {
                debugPrint('Calling onUnauthorized callback');
                onUnauthorized!();
              }
              return handler.next(error);
            }

            // Refresh Token으로 재시도
            debugPrint('Attempting token refresh...');
            final refreshed = await _refreshToken();
            if (refreshed) {
              debugPrint('Token refresh successful - retrying original request');
              // 원래 요청 재시도
              final options = error.requestOptions;

              // 모든 플랫폼에서 새 AccessToken으로 Authorization 헤더 업데이트
              final token = await _getAccessToken();
              if (token != null) {
                options.headers['Authorization'] = 'Bearer $token';
                // retry 플래그를 설정하여 onRequest에서 토큰을 다시 설정하지 않도록 함
                options.extra['retry_with_new_token'] = true;
                debugPrint('Updated Authorization header with new AccessToken');
                debugPrint('Token value: ${token.substring(0, 20)}...');
              } else {
                debugPrint('Warning: New access token is null');
              }

              try {
                // 재시도
                final response = await _dio.fetch(options);
                return handler.resolve(response);
              } catch (e) {
                debugPrint('Retry request failed: $e');
                return handler.reject(error);
              }
            } else {
              // Refresh 실패 시 토큰 삭제 및 로그아웃 콜백 호출
              debugPrint('Token refresh failed - clearing tokens and triggering logout');
              await clearTokens();

              // 로그아웃 콜백 호출 (로그인 화면으로 리다이렉트)
              if (onUnauthorized != null) {
                debugPrint('Calling onUnauthorized callback');
                onUnauthorized!();
              }
            }
          }

          // 401 (인증 실패, 이미 처리됨), 500 (서버 내부 오류) 제외한 에러 메시지 표시
          if (statusCode != null && statusCode != 401 && statusCode != 500) {
            final errorMessage = _extractErrorMessage(error.response?.data);
            if (errorMessage != null && onError != null) {
              onError!(errorMessage);
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

  /// 에러 응답에서 메시지 추출
  String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;

    if (data is Map) {
      // 일반적인 에러 응답 형식들
      if (data['message'] != null) {
        return data['message'] as String;
      }
      if (data['error'] != null) {
        if (data['error'] is String) {
          return data['error'] as String;
        }
        if (data['error'] is Map && data['error']['message'] != null) {
          return data['error']['message'] as String;
        }
      }
      if (data['msg'] != null) {
        return data['msg'] as String;
      }
    }

    return null;
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
      debugPrint('Sending refresh token request...');
      debugPrint('Platform: ${kIsWeb ? "Web (RefreshToken via Cookie)" : "Mobile (RefreshToken via Body)"}');

      Response response;

      if (kIsWeb) {
        // 웹: 쿠키로 refreshToken이 자동 전송됨
        response = await _dio.post(
          '/auth/refresh',
          options: Options(
            headers: {
              'Authorization': null, // Authorization 헤더 제거
            },
            extra: {
              'withCredentials': true, // 쿠키 자동 전송 (RefreshToken)
            },
            // validateStatus를 설정하지 않으면 Dio가 200-299만 성공으로 간주
            // 401 등은 자동으로 DioException이 되어 catch 블록으로 이동
          ),
        );
      } else {
        // 모바일: refreshToken을 body에 담아 전송
        final refreshToken = await _getRefreshToken();
        if (refreshToken == null) {
          debugPrint('No refresh token available');
          return false;
        }

        response = await _dio.post(
          '/auth/refresh',
          data: {'refreshToken': refreshToken},
          options: Options(
            headers: {
              'Authorization': null, // Authorization 헤더 제거
            },
          ),
        );
      }

      debugPrint('Refresh token response status: ${response.statusCode}');
      debugPrint('Refresh token response data: ${response.data}');

      // 200-299 상태 코드는 성공 (Dio 기본 동작)
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {

        // 응답 데이터가 없거나 accessToken이 없으면 실패
        if (response.data == null) {
          debugPrint('Refresh token response has no data');
          return false;
        }

        // 모든 플랫폼에서 새 AccessToken 저장
        final newAccessToken = response.data['accessToken'] as String?;
        debugPrint('New access token: ${newAccessToken != null ? "present (${newAccessToken.length} chars)" : "null"}');

        if (newAccessToken == null || newAccessToken.isEmpty) {
          debugPrint('No access token in refresh response');
          return false;
        }

        await saveAccessToken(newAccessToken);
        debugPrint('New access token saved to storage');

        // RefreshToken 처리
        if (kIsWeb) {
          // 웹: RefreshToken은 HTTP Only Cookie로 관리 (백엔드에서 자동 설정)
          debugPrint('Web: RefreshToken managed via HTTP Only Cookie');
        } else {
          // 모바일: RefreshToken을 Storage에 저장
          final newRefreshToken = response.data['refreshToken'] as String?;
          debugPrint('New refresh token: ${newRefreshToken != null ? "present (${newRefreshToken.length} chars)" : "null"}');

          if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
            await saveRefreshToken(newRefreshToken);
            debugPrint('Mobile: New refresh token saved to storage');
          }
        }

        return true;
      }

      debugPrint('Unexpected refresh token response status: ${response.statusCode}');
      return false;
    } catch (e) {
      debugPrint('Token refresh failed: $e');
      if (e is DioException) {
        debugPrint('DioException type: ${e.type}');
        debugPrint('Response status: ${e.response?.statusCode}');
        debugPrint('Response data: ${e.response?.data}');
      }
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
