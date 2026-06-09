---
name: vibe-verify
description: 바이브코딩 파이프라인 검증 체크리스트를 실행합니다. 그룹 삭제 영향도, 로그아웃/계정 전환 캐시, 다국어 처리, 광고 적용, Android 하단 버튼 UI 겹침, UI Invalidate 누락을 점검할 때 사용하세요. 예: "vibe-verify 실행", "배포 전 검증해줘", "검증 체크리스트 돌려줘"
allowed-tools: Read, Grep, Glob, Bash(flutter:analyze)
---

# Vibe Verify Skill

배포 전 6개 영역을 자동 점검합니다.

## 검증 영역

1. **그룹 삭제 영향도** — 삭제 시 연관 Provider/State 초기화 누락 여부
2. **로그아웃/계정 전환 캐시** — 이전 계정 데이터가 남는 케이스 탐지
3. **다국어 처리** — ARB 키 누락, hardcoded 한국어 문자열
4. **광고 적용** — 데이터 생성/수정 완료 시 전면 광고(InterstitialAdMixin) 미적용 화면 탐지
5. **Android 하단 버튼 UI 겹침** — NavigationBar/시스템 제스처 영역 침범
6. **UI Invalidate 누락** — 생성/수정 완료 후 관련 Provider invalidate/refresh 누락 여부

---

## 워크플로우

### 1단계 — 그룹 삭제 영향도

**목적**: 그룹 삭제 후 다른 피처들의 `selectedGroupId` 가 초기화되지 않으면 API 에러 or 빈 화면이 발생합니다.

**점검 방법**:
```
1. lib/features/auth/providers/auth_provider.dart 의 _invalidateGroupProviders() 읽기
2. 아래 selectedGroupId Provider 목록과 비교:
   - assetSelectedGroupIdProvider
   - householdSelectedGroupIdProvider
   - savingsSelectedGroupIdProvider
   - childcareSelectedGroupIdProvider
   - voteSelectedGroupIdProvider
   - minigameSelectedGroupIdProvider
   - fridgeSelectedGroupIdProvider
   - selectedGroupIdProvider (task)
   - selectedGroupIdsProvider (dashboard)
3. lib/features/settings/groups/providers/group_provider.dart deleteGroup() 확인:
   - defaultGroupProvider.notifier.clear() 호출 여부
   - 삭제된 그룹이 selectedGroup이면 다른 그룹으로 전환하는 로직 여부
4. lib/features/settings/groups/providers/default_group_provider.dart 확인:
   - 삭제된 그룹 ID가 저장되어 있을 때 처리 로직 여부
```

**리포트 형식**:
```
### 그룹 삭제 영향도
✅ _invalidateGroupProviders — 모든 피처 selectedGroupId 초기화 확인
⚠️ deleteGroup() — defaultGroupProvider 초기화 미호출
❌ defaultGroupProvider — 삭제된 groupId persist 후 재로드 시 fallback 없음
```

---

### 2단계 — 로그아웃/계정 전환 캐시

**목적**: 로그아웃 후 다른 계정으로 로그인할 때 이전 계정 데이터(그룹, 자산, 가계부 등)가 보이면 심각한 버그입니다.

**점검 방법**:
```
1. auth_provider.dart _invalidateGroupProviders() 체크리스트:
   □ myGroupsProvider invalidate
   □ groupNotifierProvider invalidate
   □ 모든 피처별 selectedGroupId → null
   □ defaultGroupProvider.notifier.clear()
   □ dashboardWidgetSettingsProvider.notifier.clearGroupIds()
   □ keepAlive된 dashboard provider들 invalidate
   □ bookmarkedIndicatorsProvider invalidate
   □ notificationSettingsProvider invalidate

2. logout() vs login() 둘 다에서 _invalidateGroupProviders() 호출 여부 확인
   - login(): 이전 계정 캐시 정리 목적
   - logout(): 현재 계정 상태 초기화 목적

3. keepAlive Provider 탐지:
   - Grep 패턴: "keepAlive: true" or "ref.keepAlive()"
   - 발견된 provider가 _invalidateGroupProviders에서 invalidate되는지 확인

4. SharedPreferences/SecureStorage에 groupId 저장 여부:
   - Grep: "groupId" in lib/core/services/
   - persist된 groupId가 로그아웃 시 삭제되는지 확인
```

**리포트 형식**:
```
### 로그아웃/계정 전환 캐시
✅ login() — _invalidateGroupProviders() 호출됨
✅ logout() — _invalidateGroupProviders() 호출됨
⚠️ keepAlive Provider 3개 발견 — dashboardTodayTasksProvider 등 invalidate 확인 필요
❌ SecureStorage에 lastGroupId persist — 로그아웃 시 미삭제
```

---

### 3단계 — 다국어 처리

**목적**: UI에 하드코딩된 한국어 문자열이 있거나 ARB 키가 4개 언어(ko/en/ja/zh) 모두에 없으면 특정 언어에서 앱이 깨집니다.

**점검 방법**:
```
1. 최근 변경된 dart 파일에서 한국어 하드코딩 탐지:
   - Grep 패턴: '[가-힣]+' in lib/features/ (최근 커밋 diff 기준)
   - 예외: debugPrint, comment, TODO

2. ARB 키 4개 언어 동기화 확인:
   - app_ko.arb 키 목록 추출
   - app_en.arb, app_ja.arb, app_zh.arb와 비교
   - 누락된 키 리스트 출력

3. AppLocalizations 사용 패턴 확인:
   - context.l10n.키이름 or AppLocalizations.of(context)! 사용 여부
   - 직접 String 리터럴로 한국어 사용 여부

4. 피처별 l10n 키 prefix 일관성:
   - 예: childcare_, household_, nav_ 등 prefix 사용 여부
```

**리포트 형식**:
```
### 다국어 처리
✅ 최근 변경 파일 — 하드코딩 한국어 없음
⚠️ app_zh.arb — 3개 키 누락 (childcare_points_title 등)
❌ household_screen.dart:89 — '이번 달 지출' 하드코딩
```

---

### 4단계 — 광고 적용

**목적**: 데이터를 저장하는 모든 Form 화면/Sheet는 저장 성공 직후 전면 광고(`InterstitialAdMixin`)를 표시해야 합니다. 누락 시 광고 수익 손실이 발생합니다.

**패턴 설명**:
- `InterstitialAdMixin`을 `ConsumerState`에 `with`로 믹스인
- `initState()`에서 자동 preload
- 저장 성공 콜백에서 `showInterstitialThenNavigate(() { context.pop(); })` 호출
- mixin 내부에서 `showAdsProvider`로 free 유저 여부 자동 체크 — 별도 조건 불필요

**점검 방법**:
```
1. 전체 Form 화면 목록 수집:
   - Glob 패턴: lib/**/*form_screen.dart
   - Glob 패턴: lib/**/*_sheet.dart (데이터 저장 기능이 있는 Sheet)

2. 각 파일에서 InterstitialAdMixin 적용 여부 확인:
   - Grep: "InterstitialAdMixin" — mixin 선언 여부
   - Grep: "showInterstitialThenNavigate" — 저장 완료 후 호출 여부

3. 미적용 화면 판별 기준 (아래 조건 모두 해당하면 적용 필요):
   □ 사용자가 데이터를 입력하고 저장(Create/Update)하는 화면인가?
   □ ConsumerStatefulWidget을 사용하는가?
   □ 저장 성공 후 pop()으로 화면을 닫는가?
   → 셋 다 해당하면 InterstitialAdMixin 미적용은 누락

4. 현재 적용된 화면 목록 (기준):
   - memo_form_screen.dart ✅
   - task_form_screen.dart ✅
   - savings_form_screen.dart ✅
   - expense_form_screen.dart ✅
   - account_form_screen.dart ✅

5. 미적용 화면 목록 (현재 확인된 누락):
   - announcement_form_screen.dart ❌
   - transaction_form_screen.dart (childcare) ❌
   - question_form_screen.dart (qna) ❌
   - child_profile_form_screen.dart ❌
   - add_withdrawal_sheet.dart ❌
   - add_asset_record_sheet.dart ❌

6. 신규 화면 탐지:
   - 위 기준 목록에 없는 새 *form_screen.dart, *_sheet.dart 발견 시 적용 여부 추가 확인
```

**적용 방법** (누락 화면에 추가할 코드):
```dart
// 1. import 추가
import 'package:family_planner/core/mixins/interstitial_ad_mixin.dart';

// 2. State 클래스에 mixin 추가
class _XxxFormScreenState extends ConsumerState<XxxFormScreen>
    with InterstitialAdMixin {

// 3. 저장 성공 후 pop() 대신 교체
// Before:
if (mounted) context.pop();
// After:
showInterstitialThenNavigate(() { if (mounted) context.pop(); });
```

**리포트 형식**:
```
### 광고 적용 (전면 광고 누락 탐지)
✅ memo_form_screen.dart — InterstitialAdMixin 적용됨
✅ task_form_screen.dart — InterstitialAdMixin 적용됨
✅ expense_form_screen.dart — InterstitialAdMixin 적용됨
✅ savings_form_screen.dart — InterstitialAdMixin 적용됨
✅ account_form_screen.dart — InterstitialAdMixin 적용됨
❌ announcement_form_screen.dart — InterstitialAdMixin 미적용
❌ transaction_form_screen.dart — InterstitialAdMixin 미적용
❌ question_form_screen.dart — InterstitialAdMixin 미적용
❌ child_profile_form_screen.dart — InterstitialAdMixin 미적용
❌ add_withdrawal_sheet.dart — 저장 완료 후 광고 미표시
❌ add_asset_record_sheet.dart — 저장 완료 후 광고 미표시
```

---

### 5단계 — Android 하단 버튼 UI 겹침

**목적**: Android 하단 시스템 버튼(홈/뒤로/앱 전환) 또는 제스처 바 영역과 앱 UI(FAB, 버튼, 입력창)가 겹치면 사용 불가 상태가 됩니다.

**점검 방법**:
```
1. Scaffold의 resizeToAvoidBottomInset 사용 여부:
   - Grep: "resizeToAvoidBottomInset: false" — false로 설정된 화면에서 키보드 + 버튼 겹침 가능

2. FAB 및 하단 버튼 위치:
   - Grep: "FloatingActionButton" in lib/
   - floatingActionButtonLocation 확인 (기본값은 안전)
   - Positioned.fill or Stack으로 bottom에 배치된 버튼 확인

3. BottomSheet / ModalBottomSheet:
   - Grep: "showModalBottomSheet\|showBottomSheet" in lib/
   - isScrollControlled: true 사용 시 padding 처리:
     - MediaQuery.viewInsets.bottom 또는 SafeArea 감싸기 여부

4. SafeArea 누락 탐지:
   - 새로 추가된 화면/위젯에서 Scaffold body에 SafeArea 없이 바로 Column/ListView 시작하는 패턴
   - Grep 패턴: "body: Column\|body: ListView\|body: SingleChildScrollView" — SafeArea 누락 의심

5. 하단 고정 버튼 패턴:
   - Scaffold bottomNavigationBar 또는 bottomSheet에 버튼 배치 여부
   - Column의 마지막 child에 ElevatedButton 배치 시 padding 확인
```

**리포트 형식**:
```
### Android 하단 UI 겹침
✅ 주요 화면 — SafeArea 적용됨
⚠️ add_asset_record_sheet.dart — BottomSheet에 MediaQuery.viewInsets 처리 확인 필요
❌ child_points_screen.dart:142 — Stack bottom: 0 버튼, SafeArea 없음
```

---

### 6단계 — UI Invalidate 누락

**목적**: 생성/수정/삭제 완료 후 연관 Provider를 invalidate하지 않으면 이전 데이터가 화면에 그대로 남아 사용자가 새로고침 전까지 잘못된 정보를 보게 됩니다.

**점검 방법**:
```
1. 저장 성공 직후 코드 패턴 탐지:
   - Grep 패턴: "await.*notifier.*create\|await.*notifier.*update\|await.*notifier.*delete\|await.*repository.*create\|await.*repository.*update"
   - 해당 블록 이후에 ref.invalidate / ref.refresh / state = 갱신이 있는지 확인

2. 피처별 연관 Provider 체크리스트:
   □ 목록 Provider: 생성/삭제 후 목록이 갱신되는가?
     - 예: expenseProvider 생성 후 → householdStatisticsProvider invalidate 필요
   □ 상세 Provider: 수정 후 상세 화면이 갱신되는가?
     - 예: memoProvider 수정 후 → memoDetailProvider invalidate 필요
   □ 집계/통계 Provider: CRUD 후 대시보드·통계가 갱신되는가?
     - 예: 가계부 지출 추가 후 → dashboardHouseholdStatisticsProvider invalidate 필요
   □ 연관 피처 Provider: 한 피처 변경이 다른 피처에 영향을 주는가?
     - 예: 냉장고 이관 후 → storagesWithItemsProvider invalidate 필요

3. 낙관적 업데이트(Optimistic Update) 패턴 확인:
   - state를 로컬에서 먼저 바꾼 뒤 API 실패 시 롤백하는지 확인
   - API 성공 후에도 서버 응답으로 state를 교체하는지 확인 (로컬값과 서버값 불일치 방지)

4. 점검 기준 — 아래 중 하나라도 누락이면 이슈:
   □ 생성 후: 목록 Provider에 새 항목이 나타나는가?
   □ 수정 후: 상세 화면과 목록 모두 최신값을 보여주는가?
   □ 삭제 후: 목록에서 해당 항목이 즉시 사라지는가?
   □ 연관 집계: 통계/합계/카운트가 즉시 반영되는가?

5. 피처별 알려진 연관관계 (점검 시 참고):
   - 가계부 지출 CRUD → householdStatisticsProvider, dashboardHouseholdStatisticsProvider
   - 냉장고 이관 완료 → storagesWithItemsProvider, shoppingHistoryProvider
   - 장보기 완료 → cartProvider (re-fetch), storagesWithItemsProvider, shoppingHistoryProvider
   - 저금통 입출금 → savingsGoalDetailProvider, savingsTransactionsProvider, assetStatisticsProvider
   - 육아포인트 거래 → childcareAccountProvider, childcareTransactionsProvider
   - 메모 핀 토글 → pinnedMemosProvider, dashboardMemosProvider
```

**리포트 형식**:
```
### UI Invalidate 누락
✅ expense_form_screen.dart — 저장 후 householdStatisticsProvider invalidate 확인
⚠️ memo_form_screen.dart — 수정 후 pinnedMemosProvider invalidate 누락 (핀 메모 목록 미갱신)
❌ savings_form_screen.dart — 생성 후 assetStatisticsProvider invalidate 누락 (자산 합계 미반영)
```

---

## 최종 리포트 형식

```markdown
# Vibe Verify Report
**실행 일시**: YYYY-MM-DD
**점검 범위**: [범위 명시]

## 요약
| 영역 | 상태 | 이슈 수 |
|------|------|---------|
| 그룹 삭제 영향도 | ✅/⚠️/❌ | N |
| 로그아웃/계정 전환 캐시 | ✅/⚠️/❌ | N |
| 다국어 처리 | ✅/⚠️/❌ | N |
| 광고 적용 | ✅/⚠️/❌ | N |
| Android 하단 UI 겹침 | ✅/⚠️/❌ | N |
| UI Invalidate 누락 | ✅/⚠️/❌ | N |

## 상세 이슈

### [영역별 상세]

## 즉시 수정 필요 (❌)
1. ...

## 권장 개선 (⚠️)
1. ...
```

---

## 심각도 기준

- **❌ 즉시 수정**: 프로덕션 버그, 데이터 오염, 정책 위반, 사용 불가 UI
- **⚠️ 권장 개선**: 잠재적 버그, UX 저하, 누락 가능성
- **✅ 통과**: 문제 없음

---

상세 예시: [EXAMPLES.md](EXAMPLES.md)
