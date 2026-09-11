# 12. 설정 메뉴 ✅

## 상태
✅ 완료

---

## UI 구현

### 설정 메인 화면
- ✅ 설정 메인 화면
  - ✅ 테마 설정 메뉴
  - ✅ 홈 위젯 설정 메뉴
  - ✅ 대시보드 인사말 설정 메뉴
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

### 대시보드 인사말 설정 화면
- ✅ 내 인사말 사용 on/off (끄면 시간대별 인사말)
- ✅ 기본 제공 문구 팩 14종 개별 on/off (총 296문구), 묶음별 소제목으로 구분
  - 아이 나이대별: 아기(0~12개월) / 걸음마(1~3세) / 유아(3~5세) / 초등(6~12세) / 청소년(13세~)
  - 마음 챙기기: 부모 마음 / 명언과 속담 / 응원 한마디
  - 집안일: 주방과 식품 / 세탁과 옷 / 청소와 곰팡이
  - 영어 한 문장: 생활 회화 / 여행과 외식 / 직장과 이메일
- ✅ 기본 문구 출처 안내 표기 (CDC·AAP·USDA·ACI·EPA·아동권리보장원)
- ✅ 내 문구 추가·수정·삭제 (최대 100개, 1건 200자, 중복 차단)
- ✅ 오늘 표시될 문구 미리보기
- ✅ 설정 저장 (SharedPreferences) — `GreetingSettings`

### 프로필 설정 화면
- ✅ 프로필 설정 화면
- ✅ 프로필 정보 수정 (이름, 전화번호)
- ✅ 프로필 이미지 업로드
- ✅ 개인 색상 선택 (일정·할일에서 나를 나타내는 색)
- ✅ 비밀번호 변경 (현재 비밀번호 확인 + 6자 이상 검증)
- ✅ 비밀번호 미설정 계정(소셜 로그인) 안내 다이얼로그

### 계정 관리 (프로필 화면 하단)
- ✅ 내 데이터 내보내기 — 등록된 이메일로 사본 발송
- ✅ 계정 삭제 예약 — 7일 유예 후 영구 삭제
- ✅ 계정 삭제 예약 취소 — 유예 기간 중에만 노출

### 알림 설정 화면
- ✅ 알림 설정 화면
- ✅ 알림 권한 설정
- ✅ 알림 종류별 On/Off
- ✅ 알림 시간 설정

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

### 운영자 전용 - 공통 역할 관리
- ✅ 공통 역할 목록 화면 (CommonRoleListScreen) — 시스템 전체 공통 역할 CRUD
- ✅ 역할별 권한 편집 화면 (CommonRolePermissionsScreen)

### 운영자 전용 - 사용자 및 계정 관리
- ✅ 사용자 목록 화면 (AdminUserListScreen) — 검색·필터
- ✅ 사용자 상세 화면 (AdminUserDetailScreen)
- ✅ 구독 등급 수동 변경
- ✅ 계정 삭제 예약 조회 및 처리

### 운영자 전용 - 신고 관리
- ✅ 그룹원 신고 접수·처리 → [12-groups.md](12-groups.md#신고)

### 더보기 메뉴 (앱바 ⋮)
- ✅ 튜토리얼 다시 보기
- ✅ 사용 가이드 홈페이지 열기
- 🟨 AI 어시스턴트 — 운영자에게만 열려 있고 일반 사용자에게는 준비 중 안내

## API 연동

### 프로필 설정
- ✅ 프로필 조회 (`GET /auth/me`, 캐시는 SecureStorageService.getUserInfo)
- ✅ 프로필 수정 (`PATCH /auth/update-profile`)
  - 이름, 전화번호, 개인 색상, 프로필 이미지 URL
  - 비밀번호 변경 (현재 비밀번호 확인 후)
- ✅ 프로필 이미지 업로드 (`POST /auth/upload-profile-photo`)

### 알림 설정
- ✅ 알림 설정 조회 (`GET /notifications/settings`)
- ✅ 알림 설정 수정 (`PUT /notifications/settings`)

### 계정 관리
- ✅ 데이터 내보내기 (`POST /auth/me/export`)
- ✅ 계정 삭제 예약 (`DELETE /auth/me`)
- ✅ 삭제 예약 취소 (`POST /auth/me/cancel-delete`)

### 운영자
- ✅ 공통 역할 관리 ([docs/api/roles.md](../api/roles.md))
- ✅ 사용자·구독 관리 ([docs/api/subscription-admin.md](../api/subscription-admin.md))

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

### 대시보드 인사말
- ✅ `greetingSettingsProvider` (AsyncNotifier + SharedPreferences)
- ✅ `greetingRotationProvider` — 새로고침 시 다음 문구로 넘기는 인메모리 오프셋

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

### 대시보드 인사말 설정
- `lib/features/settings/common/presentation/screens/greeting_settings_screen.dart`
- `lib/core/providers/greeting_settings_provider.dart`
- `lib/core/models/greeting_settings.dart`
- `lib/core/constants/greeting_presets.dart`
- `lib/core/constants/greeting_presets/` (언어별 문구 데이터)

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

---

## API 문서
- [docs/api/permissions.md](../api/permissions.md) — 권한
- [docs/api/roles.md](../api/roles.md) — 공통 역할
- [docs/api/subscription-admin.md](../api/subscription-admin.md) — 운영자 구독·계정 관리
- [docs/api/notifications.md](../api/notifications.md) — 알림 설정
