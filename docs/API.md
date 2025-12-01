# API 문서

백엔드 API 엔드포인트 상세 명세

## 기본 정보

### 환경별 URL
- **개발**: `http://localhost:3000`
- **프로덕션**: `https://familyplannerbackend-production.up.railway.app`
- **API 문서**: `http://localhost:3000/api` (Swagger)

### 환경 자동 전환
- Debug 모드 → 개발 환경
- Release 모드 → 프로덕션 환경

## 인증 API

### 기본 인증

#### 회원가입
```
POST /auth/signup
```
**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123",
  "name": "홍길동"
}
```

#### 로그인
```
POST /auth/login
```
**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```
**Response:**
```json
{
  "accessToken": "jwt_access_token",
  "refreshToken": "jwt_refresh_token"
}
```

#### 토큰 갱신
```
POST /auth/refresh
```
**Headers:**
```
Authorization: Bearer {refreshToken}
```

#### 로그아웃
```
POST /auth/logout
```

#### 이메일 인증
```
POST /auth/verify-email
```
**Request Body:**
```json
{
  "code": "123456"
}
```

#### 인증 이메일 재전송
```
POST /auth/resend-verification
```
**Request Body:**
```json
{
  "email": "user@example.com"
}
```

#### 현재 사용자 정보 조회
```
GET /auth/me
```
**Headers:**
```
Authorization: Bearer {accessToken}
```

#### 비밀번호 재설정 요청
```
POST /auth/request-password-reset
```
**Request Body:**
```json
{
  "email": "user@example.com"
}
```

#### 비밀번호 재설정
```
POST /auth/reset-password
```
**Request Body:**
```json
{
  "email": "user@example.com",
  "code": "123456",
  "newPassword": "newpassword123"
}
```

### 소셜 로그인

#### 플랫폼별 구현 방식

**웹 (Web):**
- **방식**: OAuth URL 리다이렉트
- **플로우**:
  1. 사용자가 소셜 로그인 버튼 클릭
  2. 백엔드 OAuth URL로 리다이렉트 (`/auth/google`, `/auth/kakao`)
  3. 백엔드가 OAuth 인증 페이지로 리다이렉트
  4. 사용자 인증 완료 후 백엔드가 토큰 검증
  5. 백엔드가 프론트엔드로 리다이렉트 (토큰 포함)
  6. 토큰 저장 및 로그인 완료

**모바일 (Android/iOS):**
- **방식**: SDK 방식
- **플로우**:
  1. 사용자가 소셜 로그인 버튼 클릭
  2. SDK로 인증 (Google Sign-In / Kakao Flutter SDK)
  3. Access Token / ID Token 획득
  4. 백엔드에 토큰 전송하여 검증 요청
  5. 백엔드가 JWT 토큰 발급
  6. 토큰 저장 및 로그인 완료

#### Google 로그인

**웹용 (OAuth URL 방식):**
```
GET /auth/google
GET /auth/google/callback
```

**모바일용 (SDK 방식):**
```
POST /auth/google/token
```
**Request Body:**
```json
{
  "accessToken": "ya29.a0AfH6SMBx...",
  "idToken": "eyJhbGciOiJSUzI1NiIs..."
}
```
**Response:**
```json
{
  "accessToken": "jwt_access_token",
  "refreshToken": "jwt_refresh_token",
  "user": {
    "id": "user_id",
    "email": "user@example.com",
    "name": "User Name"
  }
}
```

**⚠️ 현재 상태:**
- 웹용 엔드포인트만 구현됨
- 모바일은 임시로 웹용 엔드포인트 사용 중
- `POST /auth/google/token` 백엔드 추가 필요

#### Kakao 로그인

**웹용 (OAuth URL 방식):**
```
GET /auth/kakao
GET /auth/kakao/callback
```

**모바일용 (SDK 방식):**
```
POST /auth/kakao/token
```
**Request Body:**
```json
{
  "accessToken": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}
```
**Response:**
```json
{
  "accessToken": "jwt_access_token",
  "refreshToken": "jwt_refresh_token",
  "user": {
    "id": "user_id",
    "email": "user@example.com",
    "name": "User Name"
  }
}
```

**⚠️ 현재 상태:**
- 웹용 엔드포인트만 구현됨
- 모바일은 임시로 웹용 엔드포인트 사용 중
- `POST /auth/kakao/token` 백엔드 추가 필요

## 그룹 API

### 그룹 목록 조회
```
GET /groups
```
**Headers:**
```
Authorization: Bearer {accessToken}
```

### 그룹 생성
```
POST /groups
```
**Request Body:**
```json
{
  "name": "우리 가족",
  "description": "사랑하는 우리 가족",
  "defaultColor": "#6366F1"
}
```

### 그룹 참가
```
POST /groups/join
```
**Request Body:**
```json
{
  "inviteCode": "ABC123XY"
}
```

### 그룹 상세 조회
```
GET /groups/{groupId}
```

### 그룹 수정
```
PATCH /groups/{groupId}
```

### 그룹 삭제
```
DELETE /groups/{groupId}
```

### 그룹 나가기
```
POST /groups/{groupId}/leave
```

## 사용자 프로필 API

### 프로필 조회
```
GET /users/me
```

### 프로필 수정
```
PATCH /users/me
```
**Request Body:**
```json
{
  "name": "홍길동",
  "phoneNumber": "010-1234-5678",
  "profileImage": "https://example.com/profile.jpg",
  "currentPassword": "currentpass",
  "newPassword": "newpass"
}
```

## 에러 응답 형식

```json
{
  "statusCode": 400,
  "message": "에러 메시지",
  "error": "Bad Request"
}
```

## 인증 헤더

인증이 필요한 API는 다음 헤더를 포함해야 합니다:
```
Authorization: Bearer {accessToken}
```
