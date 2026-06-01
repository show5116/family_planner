# Vibe Verify — 실제 점검 예시

## 예시 1: 그룹 삭제 영향도 이슈

### 상황
`group_provider.dart`의 `deleteGroup()`에서 `loadGroups()`만 호출하고, `defaultGroupProvider`를 초기화하지 않음.

### 발견된 문제
```dart
// group_provider.dart — deleteGroup()
Future<void> deleteGroup(String groupId) async {
  await _groupService.deleteGroup(groupId);
  await loadGroups();  // ← 그룹 목록은 갱신되지만...
  // ❌ _ref.read(defaultGroupProvider.notifier).clear() 누락
  // ❌ 삭제된 그룹이 각 피처의 selectedGroupId였다면 초기화 안됨
}
```

### 수정 방법
```dart
Future<void> deleteGroup(String groupId) async {
  await _groupService.deleteGroup(groupId);
  await loadGroups();
  
  // 삭제된 그룹이 기본 그룹이었다면 초기화
  final defaultGroup = _ref.read(defaultGroupProvider);
  if (defaultGroup?.id == groupId) {
    _ref.read(defaultGroupProvider.notifier).clear();
  }
  
  // 각 피처의 selectedGroupId가 삭제된 그룹이면 초기화
  _clearDeletedGroupFromFeatures(groupId);
}
```

---

## 예시 2: 로그아웃 캐시 이슈

### 상황
`keepAlive: true`로 설정된 provider가 로그아웃 시 invalidate되지 않아 다음 계정에서 이전 데이터가 보임.

### Grep으로 발견
```
# keepAlive provider 탐지
Grep 패턴: "keepAlive" → lib/features/home/providers/dashboard_provider.dart:23
```

### 점검 결과
```dart
// dashboard_provider.dart
@riverpod
Future<List<Task>> dashboardTodayTasks(Ref ref) async {
  ref.keepAlive();  // ← keepAlive
  ...
}
```

```dart
// auth_provider.dart _invalidateGroupProviders()
_ref.invalidate(dashboardTodayTasksProvider);  // ✅ invalidate 존재 — 통과
```

---

## 예시 3: 다국어 누락 이슈

### Grep으로 발견된 하드코딩
```
lib/features/main/household/presentation/screens/household_screen.dart:89
Text('이번 달 지출')  // ❌ 하드코딩
```

### ARB 키 누락 예시
```
app_ko.arb: childcare_points_history ✅
app_en.arb: childcare_points_history ✅  
app_ja.arb: childcare_points_history ✅
app_zh.arb: childcare_points_history ❌ 누락
```

### 수정 방법
```dart
// 하드코딩 제거
Text(context.l10n.household_this_month_expense)

// app_zh.arb에 추가
"childcare_points_history": "积分历史"
```

---

## 예시 4: 전면 광고 누락

### 상황
새로 추가한 `announcement_form_screen.dart`에 `InterstitialAdMixin`이 없어 공지사항 저장 후 광고가 뜨지 않음.

### Grep으로 발견
```
Glob lib/**/*form_screen.dart →
  announcement_form_screen.dart 발견
Grep "InterstitialAdMixin" in announcement_form_screen.dart →
  No matches  ← ❌ 누락
```

### 수정 방법
```dart
// announcement_form_screen.dart

// 1. import 추가
import 'package:family_planner/core/mixins/interstitial_ad_mixin.dart';

// 2. mixin 추가
class _AnnouncementFormScreenState extends ConsumerState<AnnouncementFormScreen>
    with InterstitialAdMixin {   // ← 추가

// 3. 저장 성공 후 교체
// Before:
if (mounted) context.pop();
// After:
showInterstitialThenNavigate(() { if (mounted) context.pop(); });
```

### Sheet의 경우 (ConsumerStatefulWidget이 아닌 경우)
Sheet가 `StatefulWidget`만 사용하는 경우 mixin 적용 불가. 이 경우 `AdService.instance`를 직접 사용:
```dart
// add_withdrawal_sheet.dart — ConsumerStatefulWidget으로 변경 후 mixin 적용
// 또는 직접 호출:
AdService.instance.showInterstitial(onDismissed: () {
  if (mounted) Navigator.of(context).pop();
});
```

---

## 예시 5: Android 하단 겹침

### 발견된 문제
```dart
// add_withdrawal_sheet.dart (BottomSheet)
showModalBottomSheet(
  isScrollControlled: true,
  builder: (context) => Padding(
    padding: const EdgeInsets.all(16),  // ❌ viewInsets.bottom 미고려
    child: Column(...)
  )
);
```

### 수정 방법
```dart
showModalBottomSheet(
  isScrollControlled: true,
  builder: (context) => Padding(
    padding: EdgeInsets.only(
      left: 16, right: 16, top: 16,
      bottom: 16 + MediaQuery.viewInsetsOf(context).bottom,  // ✅ 키보드 높이 반영
    ),
    child: Column(...)
  )
);
```

### SafeArea 누락 패턴
```dart
// ❌ SafeArea 없이 body에 바로 Column
Scaffold(
  body: Column(
    children: [
      ...,
      ElevatedButton(...)  // ← 하단 버튼이 시스템 제스처 바에 겹칠 수 있음
    ]
  )
)

// ✅ SafeArea 적용
Scaffold(
  body: SafeArea(
    child: Column(
      children: [
        ...,
        ElevatedButton(...)
      ]
    )
  )
)
```
