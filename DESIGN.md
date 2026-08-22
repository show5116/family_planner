# 디자인 가이드

Family Planner 앱의 UI/디자인 컨벤션. 코드 컨벤션은 [CODE_STYLE.md](CODE_STYLE.md)를 참고한다.

> 이 문서는 실제 화면 코드를 조사해 **현재 지켜지고 있는 규칙을 정리한 것**이다. 새로 만들어낸 규칙이 아니라 기존 코드의 다수 관행을 기준으로 삼았으며, 예외가 있는 항목은 그대로 표시했다.

---

## 1. 색상

### 1-1. 테마 색상은 반드시 `Theme.of(context)`에서 가져온다

이 앱은 사용자가 고르는 **5가지 테마 색상**(blue/green/purple/pink/teal)과 **라이트/다크 모드**를 지원한다. `AppColors.primary`는 파란색 고정값이라, 이걸 직접 쓰면 **사용자가 초록 테마를 골라도 파란색이 나온다.**

```dart
// ✅ 사용자 테마를 따름
color: Theme.of(context).colorScheme.primary
color: colorScheme.onSurfaceVariant

// ❌ 파란색 고정 (테마 무시)
color: AppColors.primary
```

> ⚠️ 현재 코드베이스에 `AppColors.primary` 직접 사용이 149곳 남아 있다(`colorScheme.primary`는 233곳). 신규 코드에서는 쓰지 말고, 기존 코드를 수정할 때 눈에 띄면 함께 고친다.

### 1-2. `AppColors`를 그대로 써도 되는 경우

**의미가 고정된 색**은 테마와 무관하게 항상 같아야 하므로 `AppColors`를 직접 쓴다.

| 상수 | 용도 |
|---|---|
| `AppColors.success` | 성공, 달성, 완료 |
| `AppColors.warning` | 주의, 보너스, 트로피 |
| `AppColors.error` | 실패, 삭제, 경고 |
| `AppColors.income` / `expense` | 수입(초록) / 지출(빨강) |
| `AppColors.asset` / `investment` / `childPoints` | 도메인 고정 색 |
| `AppColors.chartColors` | 차트 계열 색상 팔레트 |

에러 색은 `colorScheme.error`도 동일하므로 둘 다 허용한다.

### 1-3. 앱바 위의 액션 버튼 색상 ⚠️

**라이트 모드 앱바 배경이 `primary`색이라, 앱바 안의 버튼에 기본 `TextButton`을 쓰면 파란 배경에 파란 글씨가 되어 보이지 않는다.** (`textButtonTheme.foregroundColor`가 `primary`이기 때문)

`colorScheme.onPrimary`도 안전하지 않다 — 다크 모드에서 `onPrimary`는 거의 검정(`#212121`)인데 다크 앱바 배경도 어두워서 똑같이 안 보인다.

```dart
// ✅ 앱바 전경색을 따름 (라이트=흰색, 다크=흰색 모두 안전)
final appBarForeground = Theme.of(context).appBarTheme.foregroundColor ??
    Theme.of(context).colorScheme.onPrimary;

AppBar(
  actions: [
    TextButton(
      style: TextButton.styleFrom(foregroundColor: appBarForeground),
      onPressed: _save,
      child: Text(MaterialLocalizations.of(context).saveButtonLabel),
    ),
  ],
)

// ❌ 라이트 모드에서 안 보임
AppBar(actions: [TextButton(onPressed: _save, child: Text('저장'))])

// ❌ 다크 모드에서 안 보임
style: TextButton.styleFrom(foregroundColor: colorScheme.onPrimary)
```

앱바 안의 `IconButton`은 앱바 `foregroundColor`를 자동으로 상속하므로 별도 지정이 필요 없다.

### 1-4. 투명도

```dart
// ✅
color.withValues(alpha: 0.3)

// ❌ deprecated
color.withOpacity(0.3)
```

---

## 2. 간격 (Spacing)

`AppSizes.space*`만 사용한다. 이 규칙은 현재 잘 지켜지고 있다(상수 사용 2,774곳 vs raw 값 38곳).

| 상수 | 값 | 주 용도 |
|---|---|---|
| `spaceXS` | 4 | 아이콘-텍스트 사이, 미세 간격 |
| `spaceS` | 8 | 관련 요소 사이 |
| `spaceM` | 16 | **기본 화면 패딩**, 카드 내부 패딩, 섹션 내 간격 |
| `spaceL` | 24 | 섹션 사이 |
| `spaceXL` | 32 | 큰 구분 |
| `spaceXXL` | 48 | 거의 안 씀 |

```dart
// ✅
padding: const EdgeInsets.all(AppSizes.spaceM)
const SizedBox(height: AppSizes.spaceS)

// ❌
padding: const EdgeInsets.all(16.0)
const SizedBox(height: 8)
```

---

## 3. 아이콘 크기

| 상수 | 값 | 용도 |
|---|---|---|
| `AppSizes.iconSmall` | 16 | 목록 항목 내 보조 아이콘 |
| `AppSizes.iconMedium` | 24 | 기본 아이콘, 앱바/버튼 |
| `AppSizes.iconLarge` | 32 | 강조 아이콘 |
| `AppSizes.iconXLarge` | 48 | 빈 상태 일러스트 |

> ⚠️ **알려진 예외**: 실제 코드에서 가장 많이 쓰이는 아이콘 크기는 `18`(120곳)과 `20`(93곳)인데, `AppSizes`에 해당 상수가 없어 raw 값으로 들어가 있다. 이 두 크기를 써야 한다면 raw 값을 허용하되, **`AppSizes`에 상수를 추가하는 편이 낫다**고 판단되면 그렇게 하고 기존 코드도 함께 정리한다.

빈 상태 아이콘은 `AppEmptyState`가 64px를 쓴다(위젯 내부에 하드코딩).

---

## 4. 모서리 (Border Radius)

| 상수 | 값 | 용도 |
|---|---|---|
| `radiusSmall` | 4 | 배지, 작은 태그, 진행 바 |
| `radiusMedium` | 8 | **카드, 버튼, 입력 필드 (기본값)** |
| `radiusLarge` | 16 | 바텀시트, 큰 컨테이너 |
| `radiusXLarge` | 24 | 거의 안 씀 |

> ⚠️ raw `circular(N)` 사용이 175곳 남아 있다(`circular(4)` 41곳, `circular(12)` 31곳, `circular(20)` 30곳 등). 신규 코드는 상수를 쓰고, `12`/`20` 같은 중간값이 꼭 필요하면 근거를 주석으로 남긴다.

원형(pill) 모양은 `BorderRadius.circular(높이 / 2)`로 계산해도 된다.

---

## 5. 타이포그래피

`Theme.of(context).textTheme.*`만 사용하고 `fontSize`를 직접 쓰지 않는다.

| 스타일 | 주 용도 | 사용 빈도 |
|---|---|---|
| `bodySmall` | 보조 설명, 캡션 | 417곳 (최다) |
| `bodyMedium` | 본문 | 286곳 |
| `titleMedium` | 섹션 제목 | 138곳 |
| `labelSmall` | 배지, 미세 라벨 | 126곳 |
| `titleSmall` | 작은 제목 | 72곳 |
| `labelLarge` | 카드 헤더 | 24곳 |
| `headlineMedium` | 큰 수치 강조 | 9곳 |

```dart
// ✅
style: Theme.of(context).textTheme.titleMedium

// ✅ 색/굵기만 덧씌우기
style: Theme.of(context).textTheme.bodySmall?.copyWith(
  color: colorScheme.onSurfaceVariant,
)

// ❌
style: const TextStyle(fontSize: 14)
```

> ⚠️ 이모지 표시용 `Text('🔥', style: TextStyle(fontSize: 16))`처럼 **글립 크기를 물리적으로 맞춰야 하는 경우**는 예외로 허용한다(textTheme으로는 정확한 크기 제어가 어려움).

---

## 6. 화면 구조

### 6-1. 목록/조회 화면

```dart
Scaffold(
  appBar: AppBar(title: Text(l10n.xxx_title)),
  body: dataAsync.when(
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (error, _) => AppErrorState(
      error: error,
      title: l10n.xxx_error_generic,
      onRetry: () => ref.invalidate(xxxProvider),
    ),
    data: (items) {
      if (items.isEmpty) {
        return AppEmptyState(
          icon: Icons.xxx_outlined,
          message: l10n.xxx_empty,
          subtitle: l10n.xxx_empty_subtitle,
          action: FilledButton.icon(...),
        );
      }
      return ListView(padding: const EdgeInsets.all(AppSizes.spaceM), ...);
    },
  ),
  floatingActionButton: FloatingActionButton(...),
)
```

- 로딩/에러/빈 상태를 **모두** 처리한다. 셋 중 하나라도 빠지면 안 된다.
- 에러는 `AppErrorState`(24곳), 빈 상태는 `AppEmptyState`(14곳)를 쓴다.

### 6-2. 생성/수정 화면

저장 버튼은 **하단 고정 바**(`FormBottomBar`)를 쓴다(11곳).

```dart
Scaffold(
  appBar: AppBar(title: Text(l10n.xxx_add)),
  body: SafeArea(
    top: false,
    child: Column(
      children: [
        Expanded(child: _buildForm(context)),
        FormBottomBar(
          label: l10n.xxx_save,
          isLoading: _saving,
          onPressed: _save,
        ),
      ],
    ),
  ),
)
```

**설정 화면**처럼 폼이 아닌 경우에는 앱바 액션 버튼을 써도 된다. 단 이때 **§1-3의 색상 규칙을 반드시 지킨다.**

### 6-3. 앱바 액션 배치

자주 쓰는 기능은 아이콘 버튼으로 꺼내고, 나머지는 `AppBarMoreMenu`(⋮)에 넣는다.

```dart
actions: [
  IconButton(icon: Icon(...), tooltip: ..., onPressed: ...),  // 자주 쓰는 것
  AppBarMoreMenu(extraItems: [...]),                          // 나머지
]
```

- 액션 아이콘은 3개 이하로 유지한다.
- **모든 `IconButton`에 `tooltip`을 단다** (접근성 + 웹 hover).
- 편집 모드처럼 특수 상태에서는 무관한 액션을 `if (!_isEditing)`으로 숨긴다.

---

## 7. 카드와 목록

- 카드는 `Card`를 그대로 쓴다(테마에 `cardTheme`이 설정돼 있음). 342곳에서 사용.
- 카드 내부 패딩은 `EdgeInsets.all(AppSizes.spaceM)`.
- 목록 항목에서 텍스트는 반드시 넘침 처리한다.

```dart
Text(
  title,
  overflow: TextOverflow.ellipsis,
  maxLines: 1,
)
```

---

## 8. 다이얼로그와 바텀시트

| 상황 | 위젯 | 사용 빈도 |
|---|---|---|
| 확인/경고, 짧은 선택 | `AlertDialog` | 123곳 |
| 목록 선택, 긴 콘텐츠 | `showModalBottomSheet` | 61곳 |

`AlertDialog` 버튼 순서는 **취소(왼쪽) → 실행(오른쪽)**:

```dart
actions: [
  TextButton(
    onPressed: () => Navigator.pop(context),
    child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
  ),
  FilledButton(onPressed: ..., child: Text(l10n.xxx_confirm)),
]
```

삭제처럼 되돌릴 수 없는 동작은 실행 버튼을 `colorScheme.error` 색으로 표시한다.

---

## 9. 사용자 피드백

- 작업 성공/실패는 `SnackBar`로 알린다(282곳).
- 실패 메시지는 l10n 키를 쓰고, 원문 에러를 그대로 노출하지 않는다.
- 오래 걸리는 작업은 버튼 자리에 `CircularProgressIndicator(strokeWidth: 2)`를 20×20 크기로 넣고 버튼을 비활성화한다.

```dart
TextButton(
  onPressed: _saving ? null : _save,
  child: _saving
      ? const SizedBox(
          width: 20, height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        )
      : Text(l10n.xxx_save),
)
```

> 앱바 안에서는 이 스피너에도 §1-3의 전경색을 지정해야 보인다.

---

## 10. 다국어 (l10n)

- **화면에 보이는 모든 문자열은 l10n 키로 만든다.** 하드코딩 금지.
- ARB 파일 4개를 **모두** 채운다: `app_ko.arb`, `app_en.arb`, `app_ja.arb`, `app_zh.arb`.
- 키는 피처별 prefix를 붙인다: `routine_`, `household_`, `childcare_` 등.
- 추가 후 `flutter gen-l10n` 실행.
- 표준 버튼 문구(취소/저장/확인)는 `MaterialLocalizations.of(context)`를 활용할 수 있다.

---

## 11. 접근성 · 반응형

- 터치 대상은 최소 48×48(`AppSizes.minTouchTarget`).
- `IconButton`에는 `tooltip` 필수.
- 하단 고정 요소는 `SafeArea` 또는 `MediaQuery.paddingOf(context).bottom`으로 시스템 영역을 피한다.
- 넓은 화면 대응이 필요하면 `AppSizes.breakpointMobile`(600) / `breakpointTablet`(1024)을 쓴다.
- 폼은 `ScrollableFormBody`로 최대 너비를 600으로 제한할 수 있다.

---

## 12. 레이아웃 안정성

값이 나타났다 사라지는 UI에서 주변 요소가 밀리지 않게 한다.

```dart
// ✅ 안 보여도 자리를 차지
Visibility(
  visible: !isCurrent,
  maintainSize: true,
  maintainAnimation: true,
  maintainState: true,
  child: TextButton(...),
)
```

비동기 갱신 시 화면 전체가 스피너로 바뀌는 깜빡임도 피한다. 이전 데이터를 유지한 채 얇은 로딩 표시만 얹는다.

```dart
// family provider는 파라미터가 바뀌면 다른 인스턴스라 이전 값을 잃는다.
// 화면 State에 마지막 성공 데이터를 캐싱해 깜빡임을 막는다.
if (async.hasValue) _lastData = async.value;
final data = _lastData;
```

---

## 체크리스트

새 화면/위젯 작성 시:

- [ ] 테마 색상은 `Theme.of(context).colorScheme.*` (§1-1)
- [ ] 의미 고정 색만 `AppColors.*` (§1-2)
- [ ] 앱바 액션 버튼에 전경색 지정 (§1-3)
- [ ] 간격은 `AppSizes.space*` (§2)
- [ ] 모서리는 `AppSizes.radius*` (§4)
- [ ] 텍스트는 `textTheme.*`, `fontSize` 직접 지정 금지 (§5)
- [ ] 로딩·에러·빈 상태 3종 모두 처리 (§6-1)
- [ ] 생성/수정 화면은 `FormBottomBar` (§6-2)
- [ ] `IconButton`에 `tooltip` (§6-3, §11)
- [ ] 목록 텍스트에 `overflow: TextOverflow.ellipsis` (§7)
- [ ] 문자열은 l10n 4개 언어 모두 (§10)
- [ ] 다크 모드에서 확인

---

**마지막 업데이트**: 2026-08-21
