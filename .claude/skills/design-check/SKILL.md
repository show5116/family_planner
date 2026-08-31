---
name: design-check
description: DESIGN.md 기준으로 UI 코드의 디자인 컨벤션 준수를 점검합니다. 화면/위젯 작성 후 테마 색상, 앱바 버튼 가시성, 하드코딩 값, 상태 처리 누락을 확인할 때 사용하세요. 예: "routine_list_screen.dart 디자인 점검해줘", "design-check 실행", "디자인 가이드 맞는지 봐줘"
allowed-tools: Read, Grep, Glob, Bash(flutter:analyze)
---

# Design Check Skill

[DESIGN.md](../../../DESIGN.md) 기준으로 UI 코드를 점검합니다.

코드 컨벤션(import, 명명, Riverpod 패턴)은 `code-review` Skill이 담당하고, 이 Skill은 **화면에 보이는 것**만 다룹니다.

## 점검 대상

인자로 파일 경로가 주어지면 그 파일을, 없으면 **최근 변경된 UI 파일**(`git status` 기준 `presentation/` 하위)을 점검합니다.

---

## 1단계 — 테마 색상 (가장 중요)

이 앱은 테마 색상 5종(blue/green/purple/pink/teal) × 라이트/다크를 지원합니다. 색상을 잘못 쓰면 **특정 테마에서만 깨지므로 개발 중에는 발견되지 않습니다.**

### 1-1. `AppColors.primary` 직접 사용 (❌)

```bash
grep -n "AppColors\.primary\b\|AppColors\.primaryLight\b\|AppColors\.primaryDark\b" <파일>
```

`AppColors.primary`는 파란색 고정값입니다. 사용자가 초록 테마를 골라도 파란색이 나옵니다.

→ `Theme.of(context).colorScheme.primary`로 교체

**예외 없음.** 테마 색은 반드시 `colorScheme`에서 가져옵니다.

### 1-2. 의미 고정 색은 통과 (✅)

아래는 `AppColors` 직접 사용이 **정상**입니다. 테마와 무관하게 항상 같아야 하는 색입니다.

```
success, warning, error, info
income, expense, asset, investment, childPoints
chartColors, routineColorPresets
```

### 1-3. 앱바 액션 버튼 전경색 (❌ — 실제 가시성 버그)

```bash
grep -n -A 8 "appBar: AppBar(" <파일> | grep -A 4 "actions:"
```

`actions:` 안에 `TextButton`/`FilledButton`이 있는데 `foregroundColor`가 지정되지 않았으면 **라이트 모드에서 파란 배경에 파란 글씨가 되어 보이지 않습니다.**

`colorScheme.onPrimary`를 쓴 경우도 지적합니다 — 다크 모드에서 `onPrimary`는 거의 검정(`#212121`)인데 다크 앱바 배경도 어두워 똑같이 안 보입니다.

→ 올바른 형태:
```dart
final appBarForeground = Theme.of(context).appBarTheme.foregroundColor ??
    Theme.of(context).colorScheme.onPrimary;

TextButton(
  style: TextButton.styleFrom(foregroundColor: appBarForeground),
  ...
)
```

버튼 안의 `CircularProgressIndicator`에도 같은 색을 지정했는지 함께 확인합니다.

`IconButton`은 앱바 `foregroundColor`를 자동 상속하므로 지적하지 않습니다.

### 1-4. deprecated 투명도

```bash
grep -n "withOpacity(" <파일>
```

→ `withValues(alpha: N)`으로 교체

---

## 2단계 — 하드코딩 값

### 2-1. 간격 (❌)

```bash
grep -nE "EdgeInsets\.(all|symmetric|only)\([^)]*[0-9]+\.?[0-9]*[,)]" <파일> | grep -v "AppSizes\|MediaQuery\|zero"
grep -nE "SizedBox\((width|height): [0-9]" <파일>
```

간격은 예외 없이 `AppSizes.space*`를 씁니다(현재 상수 2,774곳 vs raw 38곳으로 잘 지켜지는 규칙).

> `SizedBox`가 스피너 크기(`width: 20, height: 20`)인 경우는 간격이 아니므로 제외합니다.

### 2-2. 모서리 (⚠️)

```bash
grep -nE "circular\([0-9]" <파일>
```

**4·8·16·24는 상수가 있으므로 반드시 교체**합니다(`radiusSmall/Medium/Large/XLarge`).
그 외 값(12, 20, 2 등)은 대응 상수가 없어 raw를 허용하되, 근거 주석을 권장합니다.
`circular(높이 / 2)` 형태의 pill 계산은 통과입니다.

### 2-3. 텍스트 크기 (⚠️)

```bash
grep -n "fontSize: [0-9]" <파일>
```

→ `Theme.of(context).textTheme.*` 사용

**예외**: 이모지 표시용(`Text('🔥', style: TextStyle(fontSize: 16))`)은 글립 크기를 물리적으로 맞춰야 해서 허용합니다. 다만 이 프로젝트는 **이모지를 문자열에 인라인**하는 관행이 있으니(`'🔥 $값'` + `textTheme` 스타일) 그쪽을 권장합니다.

### 2-4. 아이콘 크기 (지적하지 않음)

```bash
grep -n "size: [0-9]" <파일>
```

**아이콘 크기는 raw 값을 허용합니다.** 실제 값이 19종으로 흩어져 있고(`18` 120곳, `20` 93곳 …), `iconSmall`(16)과 `iconMedium`(24) 사이를 부를 이름이 없습니다. 억지로 상수를 만들지 않습니다.

단, **상수와 정확히 같은 값을 raw로 쓴 경우만** 지적합니다: `size: 16` → `AppSizes.iconSmall`, `size: 24` → `iconMedium`, `size: 32` → `iconLarge`, `size: 48` → `iconXLarge`.

---

## 3단계 — 화면 구조

### 3-1. 상태 3종 처리 (❌)

`.when(` 또는 `AsyncValue`를 쓰는 화면에서:

```
□ loading: → CircularProgressIndicator
□ error:   → AppErrorState (onRetry 포함)
□ 빈 목록  → AppEmptyState
```

셋 중 하나라도 빠지면 지적합니다. 특히 **빈 상태 처리 누락**이 가장 흔합니다 — `data:`에서 `items.isEmpty` 분기가 있는지 확인하세요.

### 3-2. 생성/수정 화면의 저장 버튼 (⚠️)

폼 화면(`_form_screen.dart`, `Form(` 포함)이면 `FormBottomBar`를 쓰는지 확인합니다.

설정 화면처럼 폼이 아니면 앱바 액션 버튼도 허용하되, **§1-3 색상 규칙을 반드시 지켰는지** 확인합니다.

### 3-3. 목록 텍스트 넘침 (⚠️)

목록 항목의 제목 `Text`에 `overflow: TextOverflow.ellipsis`가 있는지 확인합니다. 긴 제목이 레이아웃을 깨뜨립니다.

### 3-4. IconButton tooltip (⚠️)

```bash
grep -n -A 4 "IconButton(" <파일> | grep -B 3 "onPressed"
```

`tooltip`이 없는 `IconButton`을 찾습니다. 접근성 + 웹 hover에 필요합니다.

---

## 4단계 — 다국어

```bash
grep -nE "Text\('[가-힣]|Text\(\"[가-힣]|: '[가-힣]" <파일>
```

화면에 보이는 한글 문자열이 하드코딩됐는지 확인합니다. l10n 키를 쓰지 않으면 다른 언어에서 한국어가 그대로 노출됩니다.

발견 시 **4개 ARB 파일 모두**(`app_ko/en/ja/zh.arb`) 추가가 필요하다고 안내합니다.

> `debugPrint`, 주석, 로그 문자열은 제외합니다.

---

## 5단계 — 레이아웃 안정성 (⚠️)

- **밀림**: 조건부로 나타나는 버튼/배지 때문에 주변 요소가 밀리는지 확인. 필요 시 `Visibility(maintainSize: true, ...)`
- **깜빡임**: family provider(`xxxProvider(param)`)를 watch하면서 `.when(loading:)`으로 화면 전체를 스피너로 교체하는 패턴. 파라미터가 바뀌면 다른 provider 인스턴스가 되어 이전 데이터를 잃으므로, State에 마지막 성공값을 캐싱해야 합니다.

---

## 리포트 형식

```markdown
# Design Check Report

**대상**: `lib/features/.../xxx_screen.dart`
**결과**: ✅ 통과 / ⚠️ 개선 필요 / ❌ 수정 필요

## 요약

| 항목 | 상태 | 건수 |
|---|---|---|
| 테마 색상 | ✅/⚠️/❌ | N |
| 하드코딩 값 | ✅/⚠️/❌ | N |
| 화면 구조 | ✅/⚠️/❌ | N |
| 다국어 | ✅/⚠️/❌ | N |
| 레이아웃 안정성 | ✅/⚠️/❌ | N |

## ❌ 즉시 수정

### 앱바 저장 버튼이 보이지 않음 (L138)
라이트 모드에서 앱바 배경(primary)과 버튼 글씨(primary)가 같은 색입니다.
```dart
// 현재
TextButton(onPressed: _save, child: Text('저장'))
// 수정
TextButton(
  style: TextButton.styleFrom(foregroundColor: appBarForeground),
  ...
)
```

## ⚠️ 권장 개선

### 목록 텍스트 넘침 처리 없음 (L204)
...

## ✅ 통과
- 간격: 전부 AppSizes.space* 사용
- 상태 3종 처리 완료
```

---

## 심각도 기준

- **❌ 즉시 수정**: 특정 테마/모드에서 **안 보이거나 깨지는** 것, 상태 처리 누락, 한글 하드코딩
- **⚠️ 권장 개선**: 값 하드코딩, tooltip 누락, 레이아웃 밀림
- **✅ 통과**: 문제 없음

> ❌는 "사용자가 실제로 겪는 문제"만 넣습니다. 하드코딩은 대부분 ⚠️입니다.

---

## 주의

1. **주변 코드와의 일관성이 문서보다 우선일 수 있습니다.** 같은 피처의 다른 파일이 특정 방식을 쓰고 있다면, 그 관행을 먼저 확인하고 판단하세요. 혼자만 다른 게 문제이지, raw 값 자체가 문제인 게 아닌 경우가 많습니다.
2. **지적 전에 반드시 근거를 확인하세요.** "다른 화면은 어떻게 하는지" grep으로 확인한 뒤 지적합니다.
3. DESIGN.md에 명시된 **허용 예외**(이모지 fontSize, 아이콘 raw 크기)를 지적하지 마세요.

상세 규칙: [DESIGN.md](../../../DESIGN.md)
