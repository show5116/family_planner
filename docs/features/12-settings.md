# 12. 설정 메뉴

## 상태
🟨 진행 중

---

## UI 구현
- ✅ 설정 메인 화면
- ✅ 테마 설정 화면 (라이트/다크/시스템)
- ✅ 홈 위젯 설정 화면
- ⬜ 프로필 설정 화면
- ⬜ 가족 관리 화면
- ⬜ 알림 설정 화면
- ✅ 운영자 전용 메뉴 (관리자만 표시)
- ✅ 권한 관리 화면

## 기능 구현
- ✅ 테마 모드 전환 (라이트/다크/시스템)
- ✅ 테마 설정 저장 (SharedPreferences)
- ✅ 홈 위젯 활성화/비활성화
- ✅ 홈 위젯 설정 저장
- ⬜ 프로필 정보 수정
- ⬜ 프로필 이미지 업로드
- ⬜ 가족 구성원 초대
- ⬜ 가족 구성원 관리
- ⬜ 알림 권한 설정
- ⬜ 알림 종류별 On/Off
- ⬜ 알림 시간 설정
- ✅ 관리자 권한 확인 (is_admin)
- ✅ 권한 목록 조회 (카테고리 필터)
- ✅ 권한 검색 (코드, 이름, 설명)
- ✅ 권한 상세 조회
- ✅ 권한 소프트/하드 삭제 (UI만, API 연동 필요)
- ⬜ 권한 생성 다이얼로그
- ⬜ 권한 수정 다이얼로그

## API 연동
- ⬜ 프로필 조회/수정 API
- ⬜ 가족 관리 API
- ⬜ 알림 설정 API
- ⬜ 권한 관리 API
  - GET /permissions?category={category} - 권한 목록 조회
  - POST /permissions - 권한 생성
  - PATCH /permissions/{id} - 권한 수정
  - DELETE /permissions/{id} - 권한 소프트 삭제
  - DELETE /permissions/{id}/hard - 권한 하드 삭제

## 상태 관리
- ✅ Theme Mode Provider 구현
- ⬜ User Profile Provider 구현
- ⬜ Family Provider 구현
- ✅ Permission Management Provider 구현

---

## 관련 파일
- `lib/features/settings/`
- `lib/core/providers/theme_provider.dart`
- `lib/features/settings/screens/permission_management_screen.dart`
- `lib/core/routes/app_routes.dart` - permissionManagement 라우트 추가

## 노트
- 프로필 이미지 업로드는 파일 선택 및 압축 처리 필요
- 권한 관리는 is_admin이 true인 사용자만 접근 가능
- Permission은 Role에 할당할 수 있는 권한 종류(상수)를 정의
  - 예: GROUP_UPDATE, MEMBER_INVITE, SCHEDULE_CREATE 등
- 현재 임시 데모 데이터 사용 중 (API 연동 필요)
- 권한 생성/수정 다이얼로그는 추후 구현 예정
