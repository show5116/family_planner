# 12. 설정 메뉴

## 상태
🟨 진행 중

---

## UI 구현

### 설정 메인 화면
- ✅ 설정 메인 화면
  - ✅ 테마 설정 메뉴
  - ✅ 홈 위젯 설정 메뉴
  - ✅ 프로필 설정 메뉴
  - ✅ 그룹 관리 메뉴 (→ [12-groups.md](12-groups.md) 참고)
  - ✅ 알림 설정 메뉴
  - ✅ 운영자 전용 메뉴 (관리자만 표시)

### 테마 설정 화면
- ✅ 라이트/다크/시스템 테마 선택
- ✅ 테마 모드 전환
- ✅ 테마 설정 저장 (SharedPreferences)

### 홈 위젯 설정 화면
- ✅ 홈 위젯 활성화/비활성화
- ✅ 홈 위젯 설정 저장

### 프로필 설정 화면
- ✅ 프로필 설정 화면
- ✅ 프로필 정보 수정 (이름, 이메일 등)
- ✅ 프로필 이미지 업로드

### 알림 설정 화면
- ⬜ 알림 설정 화면
- ⬜ 알림 권한 설정
- ⬜ 알림 종류별 On/Off
- ⬜ 알림 시간 설정

### 운영자 전용 - 권한 관리 화면
- ✅ 권한 관리 화면
- ✅ 관리자 권한 확인 (is_admin)
- ✅ 권한 목록 조회 (카테고리 필터)
- ✅ 권한 검색 (코드, 이름, 설명)
- ✅ 권한 상세 조회
- ✅ 권한 생성 다이얼로그 (API 연동 완료)
- ✅ 권한 수정 다이얼로그 (API 연동 완료)
- ✅ 권한 소프트/하드 삭제 (API 연동 완료)
- ✅ 권한 생성/수정 시 실시간 UI 반영
- ✅ 카테고리 필터 (전체 버튼 포함)

## API 연동

### 프로필 설정
- ✅ 프로필 조회 API (SecureStorageService.getUserInfo)
- ✅ 프로필 수정 API (PATCH /users/profile)
  - 이름, 전화번호, 프로필 이미지 URL 수정
  - 비밀번호 변경 (현재 비밀번호 확인 후)
- ✅ 프로필 이미지 업로드 API (파일 업로드)

### 알림 설정
- ⬜ 알림 설정 조회 API
- ⬜ 알림 설정 수정 API

### 권한 관리
- ✅ 권한 관리 API (완료)
  - ✅ GET /permissions?category={category} - 권한 목록 조회
  - ✅ POST /permissions - 권한 생성
  - ✅ PATCH /permissions/{id} - 권한 수정
  - ✅ DELETE /permissions/{id} - 권한 소프트 삭제
  - ✅ DELETE /permissions/{id}/hard - 권한 하드 삭제

## 상태 관리

### 테마 설정
- ✅ Theme Mode Provider 구현

### 프로필 설정
- ✅ Auth Provider의 updateProfile 메서드 활용
- ✅ SecureStorageService로 로컬 사용자 정보 관리

### 권한 관리
- ✅ Permission Management Provider 구현 (완료)
  - ✅ 권한 목록 상태 관리
  - ✅ 생성/수정/삭제 시 로컬 상태 즉시 업데이트
  - ✅ 검색 및 카테고리 필터링

---

## 관련 디렉토리

### 설정 기능
- `lib/features/settings/screens/` - 설정 관련 화면들
- `lib/features/settings/widgets/` - 설정 관련 위젯들
- `lib/features/settings/providers/` - 설정 관련 상태 관리
- `lib/features/settings/services/` - 설정 관련 API 서비스
- `lib/features/settings/models/` - 설정 관련 데이터 모델

### 테마 설정
- `lib/core/providers/theme_provider.dart`
- `lib/core/theme/app_theme.dart`

### 프로필 설정
- `lib/features/settings/screens/profile_settings_screen.dart` (484줄)
- `lib/features/auth/providers/auth_provider.dart` (updateProfile 메서드)
- `lib/features/auth/services/auth_service.dart` (updateProfile API)
- `lib/core/services/secure_storage_service.dart` (getUserInfo)

### 권한 관리
- `lib/features/settings/screens/permission_management_screen.dart` (270줄, 리팩토링됨)
- `lib/features/settings/providers/permission_management_provider.dart` (138줄)
- `lib/features/settings/widgets/permission_card.dart` (107줄)
- `lib/features/settings/widgets/permission_dialogs.dart` (485줄)
- `lib/features/settings/services/permission_service.dart`
- `lib/features/settings/models/permission.dart`

## 노트

### 그룹 관리
- 그룹 관리 기능은 별도 문서 [12-groups.md](12-groups.md)에서 관리됨

### 프로필 설정
- ✅ 프로필 조회/수정 API 연동 완료
- ✅ 이름, 전화번호, 프로필 이미지 URL 수정 가능
- ✅ 비밀번호 변경 기능 (현재 비밀번호 확인 후)
- ✅ 전화번호 자동 포맷팅 (010-1234-5678)
- ✅ 소셜 로그인 사용자는 hasPassword=false로 비밀번호 입력 생략
- ✅ 프로필 이미지 업로드 (파일 선택 및 압축 처리 구현 완료)

### 권한 관리
- 권한 관리는 is_admin이 true인 사용자만 접근 가능
- Permission은 Role에 할당할 수 있는 권한 종류(상수)를 정의
  - 예: GROUP_UPDATE, MEMBER_INVITE, SCHEDULE_CREATE 등