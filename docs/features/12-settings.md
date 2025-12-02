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
- ✅ 사용자별 권한 조회
- ✅ 관리자 권한 부여/회수 (UI만, API 연동 필요)

## API 연동
- ⬜ 프로필 조회/수정 API
- ⬜ 가족 관리 API
- ⬜ 알림 설정 API
- ⬜ 권한 관리 API (GET /permissions/users, PATCH /permissions/users/:userId)

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
- 권한 관리 API는 백엔드 구현 필요 (현재 임시 데모 데이터 사용)
- API 문서에 permissions 엔드포인트 추가 필요
