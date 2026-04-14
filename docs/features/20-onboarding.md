# 20. 온보딩 & 튜토리얼 ✅

> 상태: ✅ 완료 | 우선순위: P1

## 진행 상황: 100%

---

## 구현 위치

| 레이어 | 경로 |
|--------|------|
| 서비스 | `lib/features/onboarding/services/onboarding_service.dart` |
| Provider | `lib/features/onboarding/providers/onboarding_provider.dart` |
| 슬라이드 화면 | `lib/features/onboarding/presentation/screens/onboarding_screen.dart` |
| 슬라이드 미리보기 위젯 | `lib/features/onboarding/presentation/widgets/onboarding_slide_preview.dart` |
| 코치마크 헬퍼 | `lib/features/onboarding/presentation/widgets/feature_coach_mark.dart` |
| 라우트 상수 | `lib/core/routes/app_routes.dart` (`/onboarding`) |
| 라우팅 로직 | `lib/core/routes/router_redirect.dart` |

---

## 기능 구현

### 1. 온보딩 슬라이드 (최초 1회)

- 로그인 성공 후 `onboardingProvider.load()`로 완료 여부 확인
- 미완료 시 `/onboarding` 라우트로 자동 리다이렉트
- 5장 슬라이드 (실제 앱 UI 미리보기 + 설명)
- 우상단 "건너뛰기" 버튼으로 즉시 넘길 수 있음
- `shared_preferences`에 완료 여부 저장 (`onboarding_completed`)

| 슬라이드 | 제목 | 내용 |
|----------|------|------|
| 1 | 우리만의 플래너 | 가족·연인·친구·팀 등 다양한 그룹 소개 |
| 2 | 일정을 함께 | 공유 캘린더 UI 미리보기 |
| 3 | 할 일 관리 | 공동 TodoList UI 미리보기 |
| 4 | 가계를 한눈에 | 공동 가계부 UI 미리보기 |
| 5 | 그 외 다양한 기능 | 자산·메모·적금·투표 등 그리드 미리보기 |

### 2. 기능별 코치마크 (각 기능 첫 진입 시 1회)

- `tutorial_coach_mark` 패키지 사용
- 각 기능 화면 `initState` → `addPostFrameCallback`에서 자동 표시
- 완료 여부를 기능 키별로 `shared_preferences`에 저장 (`coach_mark_{key}`)
- "건너뛰기" 버튼으로 전체 코치마크 스킵 가능

| 기능 키 | 화면 | 안내 대상 |
|---------|------|-----------|
| `calendar` | 캘린더 탭 | 캘린더 영역, + 버튼 |
| `todo` | 할일 탭 | 주간 바, + 버튼 |
| `group_management` | 그룹 목록 화면 | 그룹 만들기, 참여하기 버튼 |
| `household` | 가계부 화면 | + 버튼 |
| `assets` | 자산 화면 | 그룹 선택 바, + 버튼 |
| `more` | 더보기 탭 | 그룹관리, 설정 메뉴 |

### 3. 다시 보기

- **설정 → 도움말** 탭에서 튜토리얼 다시 보기 가능
- 확인 다이얼로그 → `OnboardingService.resetAll()` 호출
- 온보딩 슬라이드 + 모든 코치마크 완료 기록 초기화
- 앱 재실행 시 슬라이드부터 다시 표시

---

## 데이터 저장

| 키 | 타입 | 설명 |
|----|------|------|
| `onboarding_completed` | bool | 온보딩 슬라이드 완료 여부 |
| `coach_mark_calendar` | bool | 캘린더 코치마크 완료 여부 |
| `coach_mark_todo` | bool | 할일 코치마크 완료 여부 |
| `coach_mark_group_management` | bool | 그룹관리 코치마크 완료 여부 |
| `coach_mark_household` | bool | 가계부 코치마크 완료 여부 |
| `coach_mark_assets` | bool | 자산 코치마크 완료 여부 |
| `coach_mark_more` | bool | 더보기 코치마크 완료 여부 |
