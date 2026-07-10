# iOS 홈 화면 위젯 Xcode 설정 가이드

Android 쪽은 코드만으로 완결되어 이미 동작 확인이 끝났습니다. iOS는 Xcode의 "Widget Extension" 타겟을 **Mac에서 직접** 추가해야 합니다(Windows에서는 불가능). Swift 소스는 이미 `ios/ScheduleWidget/`에 준비되어 있으니, 아래 순서대로 Xcode에서 타겟만 연결하면 됩니다.

## 사전 준비물
- Mac + Xcode (최신 버전)
- Apple Developer 계정 (App Group 사용에 필요)

## 1. Widget Extension 타겟 추가
1. `ios/Runner.xcworkspace`를 Xcode로 엽니다.
2. File → New → Target
3. "Widget Extension" 선택 → Next
4. Product Name: `ScheduleWidget` (반드시 이 이름으로 — Info.plist, 코드가 이 이름 기준으로 준비됨)
5. "Include Configuration Intent" 체크 해제 (우리는 `StaticConfiguration`을 씀)
6. Finish → "Activate ScheduleWidget scheme?" 물으면 Cancel (Runner 스킴 유지)
7. Xcode가 자동 생성한 `ScheduleWidget/` 폴더의 기본 템플릿 파일들(`ScheduleWidget.swift`, `ScheduleWidgetBundle.swift` 등 자동생성본)은 **모두 삭제**하고, 이미 준비된 다음 파일들을 타겟 멤버십에 추가합니다 (Xcode 프로젝트 네비게이터에서 우클릭 → Add Files to "Runner"):
   - `ios/ScheduleWidget/ScheduleWidgetBundle.swift`
   - `ios/ScheduleWidget/ScheduleWidgetData.swift`
   - `ios/ScheduleWidget/ScheduleListWidget.swift`
   - `ios/ScheduleWidget/MonthCalendarWidget.swift`
   - 추가 시 "ScheduleWidget" 타겟에 체크되어 있는지 확인 (Runner 타겟에는 체크 안 함)
8. 자동 생성된 `Info.plist`는 이미 준비된 `ios/ScheduleWidget/Info.plist`로 교체합니다.

## 2. App Group 설정 (Runner ↔ ScheduleWidget 데이터 공유)
1. Xcode에서 **Runner** 타겟 선택 → Signing & Capabilities → "+ Capability" → "App Groups" 추가
2. `group.com.hmncorp.familyplanner` 그룹을 추가 (Apple Developer 콘솔에 없으면 Xcode가 자동 생성 제안, 승인)
3. **ScheduleWidget** 타겟 선택 → 동일하게 Signing & Capabilities → App Groups 추가 → 같은 `group.com.hmncorp.familyplanner` 체크
4. `ios/Runner/Runner.entitlements`, `ios/Runner/RunnerRelease.entitlements`에는 이미 이 App Group이 추가되어 있음(코드에서 미리 반영). `ios/ScheduleWidget/ScheduleWidget.entitlements`도 준비되어 있으니, ScheduleWidget 타겟의 Build Settings → "Code Signing Entitlements"에 이 경로가 지정되어 있는지 확인 (Xcode가 Capability 추가 시 자동으로 만들어주는 entitlements 파일과 병합될 수 있음 — 이 경우 자동 생성된 파일에 App Group만 들어있는지 확인하면 충분)

## 3. Deployment Target 확인
- ScheduleWidget 타겟의 Deployment Target을 **iOS 14.0 이상**으로 설정 (WidgetKit 최소 요구사항)
- Runner 타겟은 기존 13.0 유지 가능

## 4. 빌드 및 확인
1. Runner 스킴으로 시뮬레이터 실행 (앱이 정상적으로 켜지는지 먼저 확인)
2. 앱에서 로그인 후 대시보드 화면 진입 (오늘 일정이 동기화됨)
3. 시뮬레이터 홈 화면에서 길게 눌러 위젯 추가 → "패밀리플래너" 검색 → "오늘 일정"(Small/Medium), "이번달 달력"(Large) 두 위젯이 보이는지 확인
4. 위젯을 추가해 실제 일정 데이터가 표시되는지 확인

## 참고
- 위젯은 앱이 마지막으로 동기화한 캐시 데이터만 표시합니다 (앱을 열 때마다 갱신). 실시간 백그라운드 갱신은 1차 범위에 포함되지 않습니다.
- 로그아웃 시 위젯 데이터가 자동으로 비워집니다 (`HomeWidgetService.clear()` — `auth_provider.dart`의 `logout()`에서 호출).
- 문제가 생기면 Xcode 콘솔에서 `ScheduleWidget` 프로세스 로그를 확인하세요 (Debug → Attach to Process → ScheduleWidgetExtension).
