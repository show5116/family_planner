import 'package:dio/dio.dart';
import 'package:family_planner/core/services/api_client.dart';

/// API 서비스 베이스 클래스
/// 모든 API 서비스는 이 클래스를 상속받아 사용
abstract class ApiServiceBase {
  final ApiClient _apiClient = ApiClient.instance;

  /// API 클라이언트 getter
  ApiClient get apiClient => _apiClient;

  /// Dio 인스턴스 getter
  Dio get dio => _apiClient.dio;

  /// API 응답 처리 헬퍼
  /// 성공 시 데이터 반환, 실패 시 예외 발생
  T handleResponse<T>(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data as T;
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: response.statusMessage ?? 'Unknown error',
      );
    }
  }

  /// API 에러 처리 헬퍼
  ApiException handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return ApiException(
            statusCode: 408,
            message: '요청 시간이 초과되었습니다',
            error: error,
          );
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message = _getErrorMessage(error.response?.data);
          return ApiException(
            statusCode: statusCode,
            message: message,
            error: error,
          );
        case DioExceptionType.cancel:
          return ApiException(
            statusCode: 0,
            message: '요청이 취소되었습니다',
            error: error,
          );
        case DioExceptionType.connectionError:
          return ApiException(
            statusCode: 0,
            message: '인터넷 연결을 확인해주세요',
            error: error,
          );
        default:
          return ApiException(
            statusCode: 0,
            message: '알 수 없는 오류가 발생했습니다',
            error: error,
          );
      }
    }

    return ApiException(
      statusCode: 0,
      message: error.toString(),
      error: error,
    );
  }

  /// 응답에서 에러 메시지 추출
  String _getErrorMessage(dynamic data) {
    if (data == null) return '오류가 발생했습니다';

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

    return '오류가 발생했습니다';
  }
}

/// API 예외 클래스
class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final dynamic error;

  ApiException({
    this.statusCode,
    required this.message,
    this.error,
  });

  @override
  String toString() {
    if (statusCode != null) {
      return 'ApiException($statusCode): $message';
    }
    return 'ApiException: $message';
  }

  /// HTTP 상태 코드별 사용자 친화적 메시지
  String get userFriendlyMessage {
    switch (statusCode) {
      case 400:
        return '잘못된 요청입니다';
      case 401:
        return '인증이 필요합니다. 다시 로그인해주세요';
      case 403:
        return '접근 권한이 없습니다';
      case 404:
        return '요청한 리소스를 찾을 수 없습니다';
      case 408:
        return '요청 시간이 초과되었습니다';
      case 409:
        return '데이터 충돌이 발생했습니다';
      case 422:
        return '입력값을 확인해주세요';
      case 429:
        return '너무 많은 요청을 보냈습니다. 잠시 후 다시 시도해주세요';
      case 500:
        return '서버 오류가 발생했습니다';
      case 502:
        return '서버 연결에 실패했습니다';
      case 503:
        return '서비스를 일시적으로 사용할 수 없습니다';
      default:
        return message;
    }
  }
}
