---
name: manual-create
description: 특정 메뉴의 사용자 매뉴얼을 스크린샷과 함께 자동 생성합니다. 테스트 데이터 시딩 → 모바일 스크린샷 촬영 → 케이스별 가이드 문서 작성까지 처리합니다. 예 "가계부 매뉴얼 만들어줘", "루틴 사용법 문서 생성", "manual-create 실행"
allowed-tools: Read, Grep, Glob, Write, Edit, Bash
---

# Manual Create Skill

특정 메뉴의 **최종 사용자용 매뉴얼**을 스크린샷과 함께 생성합니다.
산출물은 웹사이트에서 2차 가공되므로, 사람이 읽을 문장 + 기계가 파싱할 메타데이터를 함께 갖춘 Markdown으로 씁니다.

## 산출물

```
docs/manual/<메뉴>/
├── index.md              # 매뉴얼 본문 (프론트매터 + 섹션)
└── screenshots/
    ├── 01-main.png       # 모바일 스크린샷 (iPhone 13, DPR 3)
    └── shots.json        # 파일명 ↔ 캡션 매핑
```

---

## 실행 순서

### 0단계 — 대상 파악

인자로 메뉴명이 주어지면 그 메뉴를, 없으면 사용자에게 묻습니다.

대상 메뉴의 화면 코드를 먼저 읽습니다. **작업 중인 메뉴 문서만** 읽으세요 (토큰 절약).

```bash
ls lib/features/main/<메뉴>/presentation/screens/
grep -n "<메뉴>" lib/core/routes/app_routes.dart
```

기능 문서가 있으면 함께 참고: `docs/features/NN-<메뉴>.md`

### 1단계 — 테스트 데이터 시딩

```bash
node .claude/skills/manual-create/scripts/seed-profile.mjs         # 계정·그룹 이름 (최초 1회)
node .claude/skills/manual-create/scripts/seed.mjs --dry-run       # 먼저 확인
node .claude/skills/manual-create/scripts/seed.mjs --group "김가네 가족"          # 가계부
node .claude/skills/manual-create/scripts/seed-dashboard.mjs --group "김가네 가족" # 대시보드 위젯
```

**촬영 전에는 `seed-all.mjs` 한 번이면 됩니다.**

```bash
node .claude/skills/manual-create/scripts/seed-all.mjs --group "김가네 가족"
node .claude/skills/manual-create/scripts/seed-all.mjs --group "김가네 가족" --refresh
```

시딩 스크립트 상당수가 **실행 시점 날짜**로 데이터를 만듭니다(오늘 일정, 이번 달 가계부,
이번 달 포인트 거래). 하루만 지나도 "오늘 일정이 없습니다" 같은 빈 화면이 찍히므로,
날짜가 바뀌었으면 `--refresh` 로 날짜 민감 데이터를 다시 만드세요.

개별 스크립트는 모두 **이름 기준 중복 가드**가 있어 재실행해도 늘지 않습니다.
다만 포인트 거래와 자녀 프로필은 삭제 API가 없어 `--cleanup` 으로도 되돌릴 수 없습니다.

**이름은 정감 있게.** 스크린샷에 계정 이름과 그룹 이름이 그대로 찍힙니다.
`seed-profile.mjs`가 테스트 계정을 아래처럼 바꿔둡니다.

| 계정 | 이름 | 역할 |
|---|---|---|
| test-owner | **김아빠** | 김가네 가족 그룹장 |
| test-member | **박엄마** | 멤버 |
| test-owner2 | **김아들** | 멤버 |

그룹은 **김가네 가족**, **김가네 이웃 모임** 입니다.
"테스트 그룹장", "테스트 가족 2" 같은 이름이 화면에 보이면 사용자 매뉴얼로 쓸 수 없습니다.

`--group "이름"` 으로 시딩 대상 그룹을 지정합니다. 생략하면 **내가 소유한** 그룹을 고릅니다
(소유자여야 예산 설정·초대 코드 관리 같은 관리자 기능이 화면에 나옵니다).

#### 유지해야 하는 상태 — 가입 대기중

그룹 매뉴얼의 "가입 신청 승인하기" 화면은 **승인 대기 중인 신청이 실제로 있어야**
승인/거부 버튼이 찍힙니다. 없으면 빈 화면만 나옵니다.

그래서 **김아들(test-owner2)을 김가네 가족에 PENDING 상태로 남겨두었습니다.**

> ⚠️ **이 가입 신청을 승인하지 마세요.** 승인하면 촬영용 상태가 사라집니다.
> 김가네 가족이 2명(김아빠·박엄마)인 것은 의도된 상태입니다.

상태가 깨졌다면 복구합니다 (이미 대기중이면 아무것도 하지 않습니다):

```bash
node .claude/skills/manual-create/scripts/seed-pending.mjs --status  # 확인만
node .claude/skills/manual-create/scripts/seed-pending.mjs           # 복구
```

**안전 규칙 (반드시 지킬 것)**
- 개발 백엔드(`API_BASE_URL_DEV`)에만 씁니다. **프로덕션 금지.**
- 기존 데이터를 수정·삭제하지 않고 **추가만** 합니다.
- 생성한 ID는 `seed-manifest.json`에 기록됩니다. 되돌리기: `--cleanup`
- 시딩 데이터 삭제는 **사용자가 명시적으로 요청할 때만** 실행합니다.

새 메뉴를 다룰 때는 `seed.mjs`의 데이터 상수를 그 메뉴에 맞게 추가하세요.
데이터는 **매뉴얼에서 설명할 케이스를 모두 덮도록** 설계합니다
(정상 케이스, 분류별 다양성, 특수 케이스 — 예: 환불, 가변 고정지출).

⚠️ 스크린샷은 **이번 달** 화면을 찍으므로 날짜는 반드시 현재 월로 생성합니다.

### 2단계 — 앱 빌드 & 서버 기동

```bash
flutter build web --release --dart-define=ENVIRONMENT=development
node .claude/skills/manual-create/scripts/serve.mjs
```

**반드시 release 빌드.** debug 빌드(`flutter run`)는 DDC가 1865개 모듈을
로드하면서 헤드리스 브라우저에서 Flutter 엔진이 기동하지 않습니다.
(검증됨: debug는 150초 대기해도 `flutter-view` 미생성, release는 15초 내 렌더)

**반드시 `localhost:3001`.** 백엔드 CORS 허용 목록에 `http://localhost:3001`만
있어서 `127.0.0.1`로 접속하면 로그인이 CORS로 차단됩니다.

첫 실행이라면 Playwright를 먼저 설치합니다.

```bash
cd .claude/skills/manual-create/scripts && npm install && npx playwright install chromium
```

**위치 권한은 기본으로 허용됩니다** (서울시청 좌표). 권한이 없으면 날씨 위젯이
"현재 위치를 가져오지 못해 …"를 빨간 글씨로 띄워 매뉴얼에 쓸 수 없습니다.
권한 없는 상태를 일부러 찍으려면 플로우에 `"geolocation": null` 을 넣으세요.

### 3단계 — 스크린샷 촬영

플로우 정의를 만들고 실행합니다.

```bash
node .claude/skills/manual-create/scripts/capture.mjs .claude/skills/manual-create/flows/<메뉴>.json
```

플로우 파일은 `flows/household.json`을 템플릿으로 삼으세요.

**핵심 규칙 — 화면 이동은 앱 내 탭으로**

`/household/recurring` 같은 하위 경로로 직접 `goto`하면 **그룹 컨텍스트가
초기화되어 목록이 비어 보입니다.** (검증됨: API에는 4건이 있는데 화면은 "고정 지출이 없습니다")
진입점 화면까지만 `goto`하고, 이후는 `tap`으로 이동하세요.

사용 가능한 action:

| action | 용도 | 주요 필드 |
|---|---|---|
| `goto` | 진입점 이동 | `path`, `wait` |
| `login` | 테스트 계정 로그인 | `as`: `owner`\|`member` |
| `tap` | 라벨 정확 일치 탭 | `label` |
| `tapNth` | 부분 일치 N번째 탭 | `contains`, `index` |
| `tapFab` | 오른쪽 아래 ＋ 버튼 | — |
| `scroll` | 스크롤 | `dy` (음수는 위로) |
| `back` | 뒤로가기 | — |
| `tapContains` | 부분 일치 탭 (가장 작은 노드) | `contains` |
| `tapRole` | 역할로 탭 (스위치·체크박스) | `role`, `index` |
| `shot` | 스크린샷 | `name`, `caption`, `fullPage` |
| `wait` | 대기 | `wait` |

**`tap`은 세 단계로 넓혀가며 찾습니다** — aria-label 완전일치 → 텍스트 첫 줄 일치 →
부분 포함. 그래서 대부분 **화면에 보이는 제목만 적으면** 됩니다.

- ListTile: 시맨틱 텍스트가 `제목\n부제목`으로 합쳐져도 제목만으로 잡힙니다
- 일정 카드: aria-label이 `제목\n오전 10:30`이어도 제목만으로 잡힙니다
- 기념일처럼 이모지·D-day가 붙어도(`💍결혼기념일10/12 · D+3976`) 잡힙니다

`tapContains`는 명시적으로 부분일치만 쓰고 싶을 때, `tapRole`(`role: "switch"`)은
라벨이 아예 없는 스위치·체크박스에 씁니다.

**아이콘 버튼은 `tooltip` 문구로 찾습니다.** 추측하지 말고 코드에서 확인하세요.
(자산 화면 통계 아이콘의 tooltip은 "자산 통계"가 아니라 **"통계"** 입니다.)

```bash
grep -n "tooltip:" lib/features/<메뉴>/presentation/screens/<화면>.dart
grep -n '"<키>"' lib/l10n/app_ko.arb    # l10n 키라면 실제 값 확인
```

tooltip이 아예 없으면 시맨틱스에 라벨이 남지 않아 찾을 수 없습니다.
그런 버튼을 만나면 **앱에 tooltip을 추가하는 편이 낫습니다** — 접근성에도 필요합니다.

**FAB은 `tapFab`을 쓰세요.** 대부분 tooltip이 없어 라벨로는 찾지 못하고,
`tapFab`이 "오른쪽 아래 정사각형 버튼"을 좌표로 추론해 누릅니다.

**다이얼로그는 Escape로 닫히지 않습니다.** `취소` 버튼을 탭하세요.

**상세 화면에서 `back`은 목록을 건너뛸 수 있습니다.** 라우트를 push로 열면
브라우저 뒤로가기가 홈까지 가버립니다. 목록으로 확실히 돌아가려면 `goto`를 쓰세요.

위젯은 **한국어 라벨**로 찾습니다 (좌표 클릭 아님). Flutter 시맨틱스를 켜서
`flt-semantics` 노드의 aria-label을 매칭하므로, 레이아웃이 바뀌어도 잘 버팁니다.

라벨을 모를 때는 탐색 스니펫으로 실제 라벨 목록을 먼저 뽑으세요:

```js
[...document.querySelectorAll('flt-semantics')]
  .map(n => (n.getAttribute('aria-label') || n.textContent || '').trim())
  .filter(t => t && t.length < 25)
```

촬영이 실패하면 출력 폴더에 두 가지가 남습니다.

- `_failure.png` — 실패 시점 화면
- `_failure-labels.txt` — 그 화면의 시맨틱 라벨 전체 목록

**라벨을 못 찾아 실패했다면 `_failure-labels.txt` 부터 보세요.** 실제로 어떤 라벨이
있었는지 바로 알 수 있어, 별도 프로브 스크립트를 만들 필요가 없습니다.

**빈 목록이 보이면 데이터가 없는 게 아니라 파싱이 깨진 것일 수 있습니다.**
위젯 상당수가 `error:`를 빈 상태와 **똑같은 화면**으로 그려서 둘을 구분할 수 없습니다.
(실제 사례: `TaskLocation.fromJson`이 `address`·`lat`·`lng`를 필수로 읽어서,
장소명만 있는 일정 하나 때문에 일정 목록 전체가 "오늘 일정이 없습니다"로 보였습니다.)
API를 직접 호출해 건수를 확인한 뒤, 값이 있는데 화면이 비었다면 모델 파싱을 의심하세요.

**스크롤 뒤 곧바로 탭해도 됩니다.** Flutter 웹은 스크롤 직후 시맨틱 트리를 바로
갱신하지 않아 "화면에는 보이는데 탭이 실패"하는 일이 있었는데, `scroll` 액션이
트리가 실제로 바뀔 때까지(최대 4초) 기다리도록 고쳤습니다. 플로우에 수동 `wait`를
넣을 필요가 없습니다.

**목록이 길면 정렬 순서를 확인하세요.** 예를 들어 저금통 목표 카드는 이름 가나다순이라,
뒤쪽 이름을 탭하려면 먼저 스크롤해야 합니다.

**코치마크(반투명 안내 오버레이)가 화면을 가리면** 스크린샷을 못 씁니다.
`capture.mjs`가 localStorage에 완료 플래그를 미리 심어 막습니다.
그룹 상세 코치마크는 키에 그룹 ID가 들어가므로(`coach_mark_group_detail_<id>`)
API로 그룹 목록을 받아 키를 만들어 넣습니다. **새로 만든 그룹이 있으면 자동으로 처리됩니다.**
SharedPreferences는 앱 시작 시 캐시하므로 `getItem`을 가로채는 방식은 통하지 않습니다.

### 4단계 — 매뉴얼 작성

화면 코드를 읽고 **케이스를 빠짐없이** 추출해 문서를 씁니다.
코드에서 뽑아야 할 것:

- 버튼·메뉴 항목과 각각의 동작
- 분기 조건 (권한별, 상태별, 빈 목록/에러)
- 다이얼로그·확인창·스낵바 문구
- 입력 폼의 필수/선택 항목과 검증 규칙
- 특수 상태 배지 (예: `가변`, `미확정`)

l10n ARB의 실제 문구를 인용하면 화면과 문서가 일치합니다:

```bash
grep -n "\"<메뉴>_" lib/l10n/app_ko.arb
```

#### 문체 규칙 (사용자용)

- **독자는 개발자가 아닙니다.** 코드·API·모델명을 쓰지 마세요.
- 화면에 실제로 보이는 한국어 명칭을 그대로 씁니다.
- 동작은 "~하세요" 명령형, 설명은 "~합니다" 평서형.
- 한 항목 = 한 동작. 여러 단계는 번호 목록으로.
- 스크린샷은 설명 **뒤**에 배치하고 캡션을 답니다.

#### 문서 구조

```markdown
---
title: 가계부
menu: household
order: 5
updated: 2026-08-30
screenshots: 5
---

# 가계부

한 문단으로 이 메뉴가 무엇을 하는 곳인지 설명합니다.

## 화면 구성
## 지출 등록하기
## 고정 지출 관리
## 통계 보기
## 자주 묻는 질문
```

프론트매터는 웹 2차 가공에서 목차·정렬에 쓰이므로 반드시 넣습니다.
이미지는 상대경로(`screenshots/01-main.png`)로 참조합니다.

---

## 검증

문서를 다 쓴 뒤 확인합니다.

- [ ] 스크린샷이 모두 존재하고 문서에서 참조되는가
- [ ] 코드에 있는 기능 중 문서에서 빠진 것이 없는가
- [ ] 화면 명칭이 실제 앱 문구와 일치하는가
- [ ] 개발 용어가 섞이지 않았는가

## 알려진 제약

웹 브라우저 렌더링이라 **네이티브 전용 요소는 다르게 보이거나 안 보입니다**:
광고 배너, 인앱결제 시트, 푸시 권한 팝업.
구독·결제 화면 매뉴얼이 필요하면 그 부분만 실기기에서 수동 촬영해 보완하세요.
