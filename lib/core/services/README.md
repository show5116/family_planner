# API Services

백엔드 서비스 연동을 위한 API 클라이언트 및 서비스 레이어입니다.

## 환경 설정

### 자동 환경 감지
앱은 빌드 모드에 따라 자동으로 환경을 선택합니다:

- **개발 환경** (Debug/Profile 모드): `http://localhost:3000`
- **프로덕션 환경** (Release 모드): `https://familyplannerbackend-production.up.railway.app`

### 수동 환경 설정
필요한 경우 main.dart에서 수동으로 환경을 설정할 수 있습니다:

```dart
import 'package:family_planner/core/config/environment.dart';

void main() {
  // 프로덕션 환경 강제 설정
  EnvironmentConfig.setEnvironment(Environment.production);

  runApp(MyApp());
}
```

## API 클라이언트 사용법

### 1. 기본 사용 (직접 호출)

```dart
import 'package:family_planner/core/services/api_client.dart';

final apiClient = ApiClient.instance;

// GET 요청
final response = await apiClient.get('/api/v1/users/profile');

// POST 요청
final response = await apiClient.post(
  '/api/v1/users',
  data: {'name': 'John', 'email': 'john@example.com'},
);

// PUT 요청
final response = await apiClient.put(
  '/api/v1/users/123',
  data: {'name': 'Jane'},
);

// DELETE 요청
final response = await apiClient.delete('/api/v1/users/123');
```

### 2. Service 클래스 사용 (권장)

서비스 클래스를 만들어 API 호출을 캡슐화하는 것이 권장됩니다.

```dart
import 'package:family_planner/core/services/api_service_base.dart';
import 'package:family_planner/core/constants/api_constants.dart';

class UserService extends ApiServiceBase {
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await apiClient.get(ApiConstants.userProfile);
      return handleResponse<Map<String, dynamic>>(response);
    } catch (e) {
      throw handleError(e);
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await apiClient.put(
        ApiConstants.updateProfile,
        data: data,
      );
      handleResponse(response);
    } catch (e) {
      throw handleError(e);
    }
  }
}
```

### 3. 인증 서비스 사용

```dart
import 'package:family_planner/core/services/auth_service.dart';

final authService = AuthService();

// 로그인
try {
  final result = await authService.login(
    email: 'user@example.com',
    password: 'password123',
  );

  print('Login success: ${result['user']}');
  // 토큰은 자동으로 저장됨
} on ApiException catch (e) {
  print('Login failed: ${e.userFriendlyMessage}');
}

// 로그아웃
await authService.logout();
```

## 인증 토큰 관리

API 클라이언트는 자동으로 인증 토큰을 관리합니다:

1. **자동 토큰 추가**: 모든 요청에 자동으로 Access Token을 헤더에 추가
2. **자동 토큰 갱신**: 401 에러 발생 시 Refresh Token으로 자동 갱신 시도
3. **토큰 저장**: SharedPreferences에 안전하게 저장

### 토큰 수동 관리

```dart
final apiClient = ApiClient.instance;

// 토큰 저장
await apiClient.saveAccessToken('your_access_token');
await apiClient.saveRefreshToken('your_refresh_token');

// 토큰 삭제 (로그아웃 시)
await apiClient.clearTokens();
```

## 에러 처리

### ApiException
모든 API 에러는 `ApiException`으로 처리됩니다:

```dart
try {
  final result = await authService.login(email: email, password: password);
} on ApiException catch (e) {
  // 상태 코드
  print('Status: ${e.statusCode}');

  // 원본 메시지
  print('Message: ${e.message}');

  // 사용자 친화적 메시지
  print('User message: ${e.userFriendlyMessage}');
}
```

### HTTP 상태 코드별 메시지

| 코드 | 메시지 |
|------|--------|
| 400 | 잘못된 요청입니다 |
| 401 | 인증이 필요합니다. 다시 로그인해주세요 |
| 403 | 접근 권한이 없습니다 |
| 404 | 요청한 리소스를 찾을 수 없습니다 |
| 408 | 요청 시간이 초과되었습니다 |
| 422 | 입력값을 확인해주세요 |
| 429 | 너무 많은 요청을 보냈습니다 |
| 500 | 서버 오류가 발생했습니다 |
| 502 | 서버 연결에 실패했습니다 |
| 503 | 서비스를 일시적으로 사용할 수 없습니다 |

## API 엔드포인트

모든 API 엔드포인트는 `ApiConstants` 클래스에 정의되어 있습니다:

```dart
import 'package:family_planner/core/constants/api_constants.dart';

// 예시
ApiConstants.login              // /api/v1/auth/login
ApiConstants.userProfile         // /api/v1/users/profile
ApiConstants.assets              // /api/v1/assets
ApiConstants.todos               // /api/v1/todos
```

## 로깅

개발 환경에서는 자동으로 모든 API 요청/응답이 콘솔에 로깅됩니다:

```
┌── Request ────────────────────────────────────
│ POST http://localhost:3000/api/v1/auth/login
│ Headers: {Content-Type: application/json, ...}
│ Body: {email: user@example.com, password: ***}
└───────────────────────────────────────────────

┌── Response ───────────────────────────────────
│ Status: 200
│ Data: {accessToken: ..., user: {...}}
└───────────────────────────────────────────────
```

프로덕션 환경에서는 로깅이 자동으로 비활성화됩니다.

## 새로운 서비스 추가하기

1. `ApiServiceBase`를 상속받는 서비스 클래스 생성
2. 필요한 메서드 구현
3. 에러 처리 추가

```dart
import 'package:family_planner/core/services/api_service_base.dart';
import 'package:family_planner/core/constants/api_constants.dart';

class TodoService extends ApiServiceBase {
  Future<List<dynamic>> getTodos() async {
    try {
      final response = await apiClient.get(ApiConstants.todos);
      return handleResponse<List<dynamic>>(response);
    } catch (e) {
      throw handleError(e);
    }
  }

  Future<Map<String, dynamic>> createTodo(Map<String, dynamic> data) async {
    try {
      final response = await apiClient.post(
        ApiConstants.todos,
        data: data,
      );
      return handleResponse<Map<String, dynamic>>(response);
    } catch (e) {
      throw handleError(e);
    }
  }
}
```

## 테스트

### 로컬 서버 연결 테스트

```bash
# 개발 모드로 실행 (localhost:3000)
flutter run

# 프로덕션 모드로 실행 (Railway 서버)
flutter run --release
```

### 환경 확인

앱 실행 시 콘솔에 현재 환경이 출력됩니다:

```
🚀 Environment: Environment.development
🌐 API Base URL: http://localhost:3000
```
