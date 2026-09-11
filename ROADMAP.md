# Family Planner - Project Roadmap

> 전체 프로젝트 진행 상황 및 로드맵
>
> 상태 아이콘: ⬜ 시작 안함 | 🟨 진행 중 | ✅ 완료 | ⏸️ 보류 | ❌ 취소

---

## 📊 Progress Overview

- **완료**: 24/27 기능 (89%)
- **진행 중**: 3/27 기능 (11%)
- **미시작**: 0/27 기능 (0%)

**마지막 업데이트**: 2026-09-10

---

## 🗺️ Feature Roadmap

### Phase 1: 기반 구조 및 인증 (Foundation & Auth)

| 기능 | 상태 | 문서 | 우선순위 |
|------|------|------|----------|
| 프로젝트 초기 설정 | ✅ 완료 | [00-setup.md](docs/features/00-setup.md) | P0 |
| 회원 가입 및 로그인 | ✅ 완료 | [01-auth.md](docs/features/01-auth.md) | P0 |
| 그룹 관리 | ✅ 완료 | [12-groups.md](docs/features/12-groups.md) | P0 |

### Phase 2: 핵심 기능 (Core Features)

| 기능 | 상태 | 문서 | 우선순위 |
|------|------|------|----------|
| 메인화면 (대시보드) | ✅ 완료 | [02-dashboard.md](docs/features/02-dashboard.md) | P1 |
| 일정 관리 | ✅ 완료 | [06-schedule.md](docs/features/06-schedule.md) | P1 |
| ToDoList | ✅ 완료 | [07-todo.md](docs/features/07-todo.md) | P1 |
| 메모 | ✅ 완료 | [09-memo.md](docs/features/09-memo.md) | P2 |

### Phase 3: 자산 및 금융 (Finance & Assets)

| 기능 | 상태 | 문서 | 우선순위 |
|------|------|------|----------|
| 자산관리 | ✅ 완료 | [03-assets.md](docs/features/03-assets.md) | P2 |
| 투자지표 | ✅ 완료 | [04-investment.md](docs/features/04-investment.md) | P2 |
| 가계관리 | ✅ 완료 | [05-household.md](docs/features/05-household.md) | P2 |
| 적립금 관리 | ✅ 완료 | [19-savings.md](docs/features/19-savings.md) | P2 |

### Phase 4: 가족 기능 (Family Features)

| 기능 | 상태 | 문서 | 우선순위 |
|------|------|------|----------|
| 육아 포인트 | ✅ 완료 | [08-childcare.md](docs/features/08-childcare.md) | P3 |
| 미니게임 | ✅ 완료 | [10-minigame.md](docs/features/10-minigame.md) | P3 |
| 투표 | ✅ 완료 | [18-votes.md](docs/features/18-votes.md) | P2 |
| 루틴(습관) 관리 | ✅ 완료 | [23-routine.md](docs/features/23-routine.md) | P2 |
| 다이어리(일기) | 🟨 진행 중 | [24-diary.md](docs/features/24-diary.md) | P2 |

### Phase 6: 스마트 장보기 (Smart Shopping)

| 기능 | 상태 | 문서 | 우선순위 |
|------|------|------|----------|
| 스마트 장보기 | ✅ 완료 | [22-shopping.md](docs/features/22-shopping.md) | P1 |
| 냉장고 관리 | ✅ 완료 | [21-fridge.md](docs/features/21-fridge.md) | P1 |

### Phase 5: 개선 및 확장 (Enhancement & Expansion)

| 기능 | 상태 | 문서 | 우선순위 |
|------|------|------|----------|
| 다국어 지원 | ✅ 완료 | [11-i18n.md](docs/features/11-i18n.md) | P1 |
| 설정 메뉴 | ✅ 완료 | [12-settings.md](docs/features/12-settings.md) | P1 |
| 알림 시스템 | 🟨 진행 중 | [14-notification.md](docs/features/14-notification.md) | P1 |
| 공지사항 | ✅ 완료 | [15-announcements.md](docs/features/15-announcements.md) | P1 |
| Q&A (문의하기) | ✅ 완료 | [16-qna.md](docs/features/16-qna.md) | P1 |
| 온보딩 & 튜토리얼 | ✅ 완료 | [20-onboarding.md](docs/features/20-onboarding.md) | P1 |
| 날씨 기능 | ✅ 완료 | [17-weather.md](docs/features/17-weather.md) | P2 |
| 공통 기능 | 🟨 진행 중 | [13-common.md](docs/features/13-common.md) | P2 |

### Phase 7: 수익화 (Monetization)

| 기능 | 상태 | 문서 | 우선순위 |
|------|------|------|----------|
| 구독 & 광고 | ✅ 완료 | [subscription.md](docs/features/subscription.md) | P1 |

**참고**: 설정 메뉴는 프로필 설정, 테마 설정, 홈 위젯 설정을 포함하며, 그룹 관리([12-groups.md](docs/features/12-groups.md))와 권한 관리는 별도 관리됩니다.

**남은 🟨 2건**
- **알림 시스템**: 네이티브(Android/iOS) FCM 수신·라우팅·설정·히스토리는 완료. **웹 푸시만 미구현** (`web/firebase-messaging-sw.js` 부재)
- **공통 기능**: 푸시 알림은 [14-notification.md](docs/features/14-notification.md)로 이관 완료. 통합 검색(일정·할일·메모)과 오프라인 로컬 DB는 미착수

---

## 🎯 Milestone Plan

### Milestone 1: MVP Launch (목표: Phase 1-2 완료) ✅
- [x] 프로젝트 기반 구조
- [x] 회원 인증 시스템 완성
- [x] 그룹 관리 완성
- [x] 대시보드 데이터 연동
- [x] 일정 관리 기본 기능
- [x] ToDoList 기본 기능

### Milestone 2: Finance Features (목표: Phase 3 완료) ✅
- [x] 자산관리 시스템
- [x] 투자지표 대시보드
- [x] 가계부 기능

### Milestone 3: Family Features (목표: Phase 4 완료) ✅
- [x] 육아 포인트 시스템
- [x] 미니게임 기능

### Milestone 4: Polish & Scale (목표: Phase 5 완료) 🟨
- [x] 다국어 완전 지원
- [x] 푸시 알림 시스템 (네이티브)
- [ ] 웹 푸시 알림
- [ ] 통합 검색 (일정·할일·메모)
- [ ] 오프라인 지원
- [ ] 성능 최적화

---

## 📈 최근 완료된 기능

### 2026-09-10
- ✅ **루틴 대시보드 위젯 — 백엔드 신규 API 3건 반영** ([23-routine.md](docs/features/23-routine.md))
  - 요청서(`docs/requests/2026-09-10-routine-dashboard-widgets.md`)로 넘긴 3건이 모두 반영되어
    프론트를 맞춤. 셋 다 기존 필드를 건드리지 않는 추가라 배포 순서 제약 없음
  - `daily-streak`에 `totalAchievedDays`/`perfectWeeksCount` 추가 → **배지 9종 전부**가
    "다음 배지까지" 대상이 됨 (기존에는 연속 달성 기준 3종만 가능)
    - 기준별 단위가 달라(일/주) 비교는 일수 환산, 표시는 원래 단위로 분기
  - `GET /routines/challenges/me` 신설 → 가족 루틴 보드가 **선택된 그룹이 아니라 모든 그룹**의
    임박 챌린지를 노출. 다른 그룹 것이면 그룹명을 함께 표시
  - `stats/summary`에 `timeFilter`/`recordType` 추가 → 모델은 맞췄지만 '오늘' 뷰는 계속
    `GET /routines`를 사용. 인라인 체크의 낙관적 업데이트가 `routineListProvider`를 통해서만
    동작하고, summary에는 우선순위 3순위 기준인 `importance`가 없기 때문
  - 체크 시 `routineOverviewProvider` 무효화 누락 수정 — '이번 주' 뷰와 통합 통계 화면의
    히트맵·달성률이 오늘 체크를 반영하지 못하던 문제
  - 유닛 테스트 6건 추가 (전체 그룹 챌린지 2건, daily-streak 신규 필드 2건, summary 신규 필드 2건)

### 2026-09-10
- ✅ **루틴 대시보드 위젯 재설계 + 가족 루틴 보드 신설** ([02-dashboard.md](docs/features/02-dashboard.md), [23-routine.md](docs/features/23-routine.md))
  - 기존 `routineSummary` 위젯은 1차 구현 그대로라 일일 목표·시간대·기록방식·일시정지 등
    이후 추가된 기능이 전혀 반영되지 않았고, 습관 전체를 개수 제한 없이 나열하고 있었음
  - **내 루틴** 위젯: 한 키에 오늘 ⇄ 이번 주 두 뷰를 토글 (`routineViewMode`로 저장)
    - 오늘 — 일일 목표 진행 링 + 미체크/현재 시간대/중요도 우선 최대 3개 인라인 체크
    - BOOLEAN이 아닌 기록 방식은 체크 전 값 입력 다이얼로그를 거치도록 수정 (기존에는
      빈 값으로 체크되던 문제), 일시정지 습관은 후보에서 제외
    - 18시 이후 목표 미달성 + 스트릭 보유 시 끊김 경고, 목표 달성 시 축하 상태로 전환
    - 이번 주 — 7칸 히트맵 + 달성률 + 다음 "연속 달성 N일" 배지까지 남은 일수
  - **가족 루틴 보드** 위젯 신설: 그룹원별 오늘 진행률·오늘 기준 내 순위·진행 중 챌린지 D-day
    - 3뎁스 안쪽(루틴 → 그룹원 현황 → 챌린지 탭)에 묻혀 있던 기능을 대시보드로 노출
    - 그룹 선택은 `routineFamilySelectedGroupId`로 저장, 공유 루틴이 없으면 공유 설정 CTA
  - 기본 위젯 목록에 **내 루틴** 추가 (가족 루틴 보드는 선택 노출)
  - 기존 API만으로 구현 — 백엔드 변경 없음

### 2026-09-10
- ✅ **인사말 팩에 집안일 팁과 영어 회화 추가** ([02-dashboard.md](docs/features/02-dashboard.md))
  - 집안일 3팩 — 주방과 식품(USDA FSIS/FoodSafety.gov) / 세탁과 옷(American Cleaning Institute) /
    청소와 곰팡이(CDC·EPA). 냉장 온도·2시간 규칙·세제 양·락스 혼합 금지처럼 근거가 있는 것만
  - 영어 한 문장 3팩 — 생활 회화 / 여행과 외식 / 직장과 이메일.
    "Let's call it a day. — 오늘은 여기까지 하죠"처럼 문장 뒤에 뜻을 붙이고,
    영어 로케일에서는 뜻 대신 쓰는 상황을 붙임
  - 팩이 14종이 되어 설정 화면을 묶음별 소제목(아이 나이대별·마음 챙기기·집안일·영어)으로 정리
  - 총 296문구 × 4개 국어

- ✅ **대시보드 인사말을 "오늘의 한마디"로 교체** ([02-dashboard.md](docs/features/02-dashboard.md))
  - 시간대별 고정 문구(좋은 아침/오후/저녁 + 항상 같은 부제)는 정보량이 없어
    사용자가 고른 문구를 보여주는 방식으로 바꿈
  - 기본 제공 팩 8종, 총 172문구 × 4개 국어 (688개 문자열)
    - 나이대별 육아: 아기(0~12개월) / 걸음마(1~3세) / 유아(3~5세) /
      초등(6~12세) / 청소년(13세~) — 나이대마다 필요한 내용이 완전히 달라 팩을 분리
    - 연령 무관: 부모 마음(긍정양육 129 원칙) / 명언과 속담 / 응원 한마디
    - CDC Positive Parenting Tips, AAP HealthyChildren.org,
      아동권리보장원 공개 가이드를 한 줄로 요약 (원문 인용 아님)
    - 문구 데이터는 ARB가 아니라 `lib/core/constants/greeting_presets/`의
      언어별 상수 파일 — ARB에 넣으면 생성 코드가 수천 줄 늘어남
  - 내 문구 직접 등록 (최대 100개, 1건 200자, 중복 차단)
  - 날짜를 시드로 뽑아 **하루 동안 같은 문구**, 당겨서 새로고침하면 다음 문구로
  - 표시할 문구가 없거나 기능을 끄면 기존 시간대 인사말로 폴백
  - 저장은 기기 로컬(SharedPreferences)이라 백엔드 변경 없음
  - 설정 > 대시보드 인사말 (`/settings/greeting`)

### 2026-09-09
- ✅ **다이어리 Phase 2 — 사진 첨부 + 용량 한도** ([24-diary.md](docs/features/24-diary.md))
  - presigned 직접 업로드(reserve → R2 PUT → confirm) 전 구간 연결, 진행률·취소·재시도
  - 압축 선택 시트 — 예상치가 아니라 **실제로 압축해본 결과**를 보여주고 고르게 함
  - 사진 우선 카드 · 사진 그리드 뷰 · 전체화면 뷰어(핀치 줌) · 저장 공간 관리 화면
  - 빠른 기록 바에서 사진만 던지기 (텍스트 없이도 append)
  - 구독 화면에 **서버가 내려주는** 등급별 용량 한도표 (`/subscription/quota-plans`)
  - EXIF 촬영일이 오늘과 다르면 어느 날 일기에 넣을지 물어봄 (`exif` 패키지 추가)
  - [백엔드 요청서](docs/api-proposals/2026-09-09-diary-media-flashback-video.md)
    1~4번 반영 완료 — 회고 카드에 사진·다국어 라벨, 썸네일 병렬 업로드,
    업로드 실패 사유별 안내
  - 이미지 형식을 **파일명이 아니라 바이트(매직 넘버)로** 판정하도록 정리 —
    HEIC 업로드 실패의 근본 원인이었고, 공용 에디터 경로도 함께 고침
    (`lib/core/utils/image_format.dart`, 단위 테스트 13종)
  - 남은 것: 영상 + 프리미엄 판매 (Phase 3)
- ✅ **투자 지표 매뉴얼에 AI 시황 브리핑 화면 추가** (7샷)
  - 프로덕션에서 브리핑 카드를 펼친 화면을 찍어, 지수 등락뿐 아니라
    "왜 그렇게 움직였는지"까지 요약해 준다는 점이 드러나게 했습니다
  - 매크로 카드는 본문이 오류 메시지로 저장돼 있어 국내 시장 카드를 폈습니다
    (별도 이슈로 04-investment.md에 기록)

### 2026-09-08
- ✅ **구독 사용자 매뉴얼** ([docs/manual/subscription/](docs/manual/subscription/))
  - 2샷 — 더보기 탭 진입 경로(웹), 구독 관리 화면(실기기 캡처)
  - 가격·구독 버튼은 스토어 상품 정보로 그려서 웹에서는 안 나옵니다.
    실기기 캡처 원본을 `device/`에 보관하고 `_crop.mjs`로 상태바를 잘라 씁니다
- ✅ **Q&A 사용자 매뉴얼** ([docs/manual/qna/](docs/manual/qna/))
  - 7샷 — 목록·상태 탭, 답변 있음/없음 상세, 내 질문만, 질문 작성 2장
  - 시딩 스크립트 `seed-qna.mjs` (공개/비공개 · 카테고리 5종 · 대기/답변완료/해결완료)
  - 답변은 운영자만 달 수 있어, 개발 DB에서 테스트 계정을 잠깐 운영자로 올린 뒤
    되돌리는 방식으로 시딩합니다 (`_admin_toggle.mjs`)
- ⏭️ **공지사항 매뉴얼은 건너뜀** — 사용자는 읽기만 하는 화면이라 분량이 얇고,
  작성·고정·마크다운 가져오기는 운영자 전용이라 사용자 매뉴얼에 넣을 내용이 아닙니다
- ✅ **투표 사용자 매뉴얼** ([docs/manual/vote/](docs/manual/vote/))
  - 6샷 — 목록·필터, 투표 전/후 상세, 새 투표 만들기
  - 시딩 스크립트 `seed-vote.mjs` (진행중·종료·복수선택·익명 4종, 두 계정으로 득표 생성)
  - 종료된 투표는 마감 뒤 표를 넣을 수 없어, 곧 마감되도록 만들고 표를 넣은 뒤 대기합니다
- ✅ **미니게임 사용자 매뉴얼** ([docs/manual/minigame/](docs/manual/minigame/))
  - 6샷 — 메인·이력, 사다리타기 3단계(설정→타기→결과), 룰렛 설정·결과
  - 시딩 스크립트 `seed-minigame.mjs` (사다리 2건 + 룰렛 1건으로 두 요약 형식 커버)
  - 촬영 파이프라인에 `type`의 `index`와 `dump --fields` 추가 —
    라벨 없이 hintText만 있는 입력칸을 순번으로 지정합니다

### 2026-09-07
- ✅ **투자 지표 사용자 매뉴얼** ([docs/manual/investment/](docs/manual/investment/))
  - 6샷 — AI 시황 브리핑·즐겨찾기 목록, 지표 상세와 기간 칩, 금 (국내) 이격률과 추이 차트
  - **프로덕션 화면으로 촬영** — 개발 서버는 지표 수집 크론이 꺼져 있어 시세가 5월에 멈춰 있고
    AI 브리핑도 비어 있습니다. 촬영 파이프라인에 `origin`(배포된 웹앱 직접 접속),
    `key`, `type`의 `focused` 옵션을 추가해 대응했습니다
- ✅ **투자 지표 백엔드 3건 수정** (프로덕션 데이터 점검 중 발견 · 백엔드 레포 `3600391`)
  - 금 이격률 시계열이 90일 이상에서 아예 안 내려오던 문제 (계산 경로 자체가 없었음)
  - 7일 이하에서 버킷 형식 불일치로 데이터의 1/5만 남던 문제
  - 러셀 2000·천연가스·밀이 5~6개월째 수집되지 않던 문제 (`INDICATORS` 상수 누락)
- ✅ **지표 상세 기간 칩 줄바꿈 수정** — 좁은 화면에서 `180일`이 두 줄로 깨지던 문제
- ✅ **장보기 사용자 매뉴얼** ([docs/manual/shopping/](docs/manual/shopping/))
  - 9샷 — 장바구니·자주 사는 것·구매 이력 3탭, 장보기 완료 2단계
  - 시딩 스크립트 `seed-shopping.mjs` — 구매 이력은 만드는 API가 없어
    장바구니를 채우고 완료 처리하는 방식으로 생성합니다 (냉장고 시딩 뒤에 실행)
- ✅ **냉장고 사용자 매뉴얼** ([docs/manual/fridge/](docs/manual/fridge/))
  - 7샷 — 보관소 관리, 품목 추가·수정, 유통기한 자동 추천, 프리셋 관리
  - 시딩 스크립트 `seed-fridge.mjs` 추가 (보관소 3종 + 품목 12건, D-Day 뱃지 4색 전부 커버)
  - 촬영 파이프라인에 `type` 액션 추가 — 입력해야만 보이는 UI(추천 칩) 촬영 가능
- ✅ **냉장고 버그 2건 수정** (매뉴얼 작성 중 발견)
  - 유통기한 D-Day 하루 밀림 — 날짜 값에 `toLocal()`을 태워 타임존만큼 밀렸습니다.
    어제 지난 품목이 `D-Day`로 보이던 문제를 날짜만 파싱하도록 고쳤습니다
  - 보관소 추가/수정 창의 이름 칸 라벨이 `품목명`으로 표시되던 문제 (`fridge_storage_name` 키 신규 · 4개 언어)

### 2026-08-31
- ✅ **문서 정합성 전면 정리** — 실제 구현과 대조해 상태 재산정
  - 코드 검증 결과 ⬜/🟨로 남아 있던 12건이 실제로는 완료 상태였습니다
  - ⬜ → ✅: 가계관리(소비처 관리·통계 차트), 미니게임(사다리·룰렛), 날씨(위젯·상세·프리셋 15개 항목 전부)
  - 🟨 → ✅: 회원 인증(애플/구글 소셜), 대시보드, 일정 관리(월/주/타임테이블·검색), ToDoList(필터·정렬), 다국어(4개 언어), 투표, 스마트 장보기
  - Feature Roadmap 테이블에 누락돼 있던 **냉장고 관리**·**구독 & 광고** 추가
  - 남은 🟨 2건: 알림 시스템(웹 푸시), 공통 기능(통합 검색·오프라인 DB)
- ✅ **대시보드·사용자 설정 사용자 매뉴얼** ([docs/manual/](docs/manual/))
  - 대시보드 10샷, 사용자 설정 11샷 — 스크린샷 자동 촬영 파이프라인으로 생성
- ✅ **루틴(습관) 관리 완료** ([23-routine.md](docs/features/23-routine.md))
  - 2차 UX 고도화, 게이미피케이션(배지/랭킹보드/알림), 그룹 챌린지, 온보딩까지 마무리
- ✅ **구독 결제(IAP) 도입** ([subscription.md](docs/features/subscription.md))
  - 광고 제거 구독(월 ₩1,900) — StoreKit2 / Play Billing 연동, 서버 영수증 검증, 웹훅 기반 상태 동기화
  - 무료 vs 광고 제거 플랜 비교 카드, 구독 복원, 스토어 구독 관리 진입
  - 오프라인 대비 구독 상태 로컬 캐시
- ✅ **홈 화면(OS) 위젯**
  - Android/iOS 오늘 일정 리스트 + 이번달 달력 위젯, 그룹 필터·월 이동·일정 추가 지원

### 2026-07-13
- 🟨 **루틴(습관) 관리 1차 구현** ([23-routine.md](docs/features/23-routine.md))
  - 루틴 목록(오늘 체크 리스트, 드래그 순서 변경), 생성/수정 폼, 상세 화면(히트맵/통계/공유 3탭)
  - 그룹원별 공유 루틴 현황 화면, 홈 대시보드 위젯(인라인 체크 토글 포함)
  - 체크/체크취소 낙관적 업데이트, 순서 변경 낙관적 반영 + 실패 시 롤백
  - 히트맵 캘린더는 신규 패키지 추가 없이 table_calendar 재사용
  - 4개 언어(한/영/일/중) l10n 키 추가

### 2026-06-08
- 🟨 **스마트 장보기 UX 대규모 개선** ([22-shopping.md](docs/features/22-shopping.md))
  - 장보기 완료 폼 DraggableScrollableSheet 풀스크린 전환, 항목 제외(excludes) 기능
  - 완료 후 서버 re-fetch로 제외 항목 UI 즉시 반영
  - 냉장고 이관 Step2: 유통기한 추천 자동 매칭, 아코디언 자동 닫힘, 금액 입력 제거
  - 가계부 등록에 소비처(merchant) 선택 추가 (코스트코 포함)
  - 자주 사는 것 폼 AlertDialog → DraggableScrollableSheet 바텀시트 전환
  - 자동 추가 토글에 라벨 + 색상 연동
  - 구매 이력 상세: 개별/전체 장바구니 다시 담기(가격 포함), 삭제 확인 다이얼로그 개선
  - 가격 null '가격 미입력' 표시, 냉장고 이관 체크 아이콘 툴팁으로 대체
  - 무한 로딩 버그 수정(400 에러), Android SafeArea 처리

### 2026-04-14
- ✅ **온보딩 & 튜토리얼** ([20-onboarding.md](docs/features/20-onboarding.md))
  - 최초 로그인 시 5장 슬라이드 온보딩 (실제 앱 UI 미리보기 포함)
  - 그룹(가족·연인·친구·팀), 캘린더, 할일, 가계부, 기타 기능 소개
  - 기능별 코치마크: 캘린더, 할일, 그룹관리, 가계부, 자산, 더보기 탭
  - SharedPreferences 기반 완료 여부 관리 (슬라이드/코치마크 각각)
  - 설정 → 도움말에서 튜토리얼 다시 보기 지원
  - 더보기 탭 상단에 그룹 관리 메뉴 이동 (설정에서 제거)

### 2026-04-02
- ✅ **자산관리 기능 완료** ([03-assets.md](docs/features/03-assets.md))
  - AssetStatisticsModel에 savingsTotal, savingsGoals 필드 추가 (API 완전 파싱)
  - 자산 통계 화면에 저금통 합계 및 연동 저금통 목록 표시
  - 자산 대시보드 계좌 목록 하단에 연동 저금통 섹션 추가 (탭으로 이동 가능)
  - l10n 키 추가: asset_savings_total, asset_savings_goals (한/영/일)

- ✅ **적립금 관리 기능 완료** ([19-savings.md](docs/features/19-savings.md))
  - 목표 목록/상세/생성/수정/삭제 전체 구현
  - 수동 입금/출금, 자동 적립 일시중지/재개
  - 거래 내역 화면 (타입/월 필터, 무한 스크롤)
  - includeInAssets 설정으로 자산 탭과 연동

### 2026-03-30
- ✅ **육아 포인트 기능 완료** ([08-childcare.md](docs/features/08-childcare.md))
  - 적금 플랜 재설계: 생성/조회/해지 API 연동, 단리/복리 이자 미리보기 (로컬 계산)
  - 국고채 3년물 금리 참고 helperText (GET /savings/kr3y-rate)
  - TransactionResult 래퍼 도입 (closingBalance 포함)
  - 히스토리 탭 시각화: 월별/연도별 토글, 잔액 라인 차트, 유형별 도넛 차트, 연간 막대 차트
  - 규칙 탭 타입별 섹션(_RuleSection), 드래그 순서 변경 수정
  - 용돈 플랜 협상일 X버튼 suffixIcon 방식으로 수정
  - 상점 탭 드래그앤드롭 Material 래퍼 추가 (No Material 에러 수정)

### 2026-03-18
- 🟨 **투표 기능 진행 중** ([18-votes.md](docs/features/18-votes.md))
  - Model, Repository, Provider (목록/상세/투표/관리) 구현
  - 투표 목록 화면 (그룹 선택, 상태 필터, 투표 카드)
  - 투표 상세 화면 (선택지 UI, 결과 바, 투표/취소 버튼, 삭제)
  - 투표 생성 화면 (선택지 동적 추가, 복수·익명 토글, 마감 시각)
  - 라우트 등록 및 더보기 탭 메뉴 연결

### 2026-03-06
- ✅ **투자지표 기능 완료** ([04-investment.md](docs/features/04-investment.md))
  - 지표 목록/상세 화면, 스파크라인 미니 차트, 시계열 라인 차트 (fl_chart)
  - 즐겨찾기 등록/해제/드래그 순서 변경 (낙관적 업데이트)
  - 차트 드래그 범위 선택 → 기간 등락률 요약 바
  - 금 현물 이격률 차트 (국제 환산가 대비 프리미엄/디스카운트)
  - 대시보드 즐겨찾기 위젯 연동, 관리자 과거 데이터 초기화

- ✅ **메모 기능 완료** ([09-memo.md](docs/features/09-memo.md))
  - 체크리스트 타입 메모 생성 (type=CHECKLIST), 드래그 정렬 지원
  - 체크리스트 항목 추가/수정/삭제/토글/전체 초기화
  - 메모 상세 화면 체크리스트 뷰 (진행률 표시, 낙관적 업데이트)
  - 메모 작성/수정 화면 체크리스트 에디터 (ReorderableListView)
  - ChecklistNotifier Provider, Repository API 전체 연동
  - 메모 카드 체크리스트 진행률 LinearProgressIndicator

- 🟨 **대시보드 위젯 실제 데이터 연동** ([02-dashboard.md](docs/features/02-dashboard.md))
  - 대시보드 전용 독립 provider 신규 생성 (`dashboard_provider.dart`) — 탭 간 상태 오염 해결
  - 오늘의 일정: `dashboardTodayTasksProvider`로 오늘 날짜 범위 직접 조회
  - 할일 요약: `dashboardTodoTasksProvider`로 할일 탭 UI 상태와 완전 독립
  - 자산 현황: `dashboardAssetStatisticsProvider`로 자산 탭 그룹 상태 독립, `byType` 실제 분포 차트
- 🟨 **메모 핀 기능 및 대시보드 위젯 추가** ([09-memo.md](docs/features/09-memo.md))
  - `MemoModel`에 `isPinned` 필드 추가
  - `GET /memos/pinned`, `POST /memos/:id/pin` API 연동
  - `pinnedMemosProvider`, `MemoPinNotifier` 추가
  - 메모 상세 화면 AppBar 핀 토글 버튼 추가
  - 대시보드 고정 메모 위젯(`MemoSummaryWidget`) 신규 추가
  - 위젯 설정 화면에 메모 요약 항목 추가 (기본값 비활성화)

### 2026-02-12
- 🟨 **ToDoList 기능 진행 중** ([07-todo.md](docs/features/07-todo.md))
  - TaskStatus 6가지 상태 백엔드 동기화 (PENDING, IN_PROGRESS, COMPLETED, HOLD, DROP, FAILED)
  - 체크박스를 상태 드롭다운(PopupMenuButton)으로 교체
  - 모바일 환경 칸반 보드 제거 (리스트 뷰 전용)
  - 모아 보기(Overview) 기능 추가 - 날짜 섹션별 그룹핑 (지난 할일/오늘/내일/이번 주/다음 주/그 이후/기한 없음)
  - [날짜별 보기] / [모아 보기] SegmentedButton 뷰 모드 전환
  - 날짜별 보기: 주간 바 + 날짜 선택 기능
  - 완료 포함 체크박스 필터
  - 다국어 지원 (한/영/일)

### 2026-01-28
- 🟨 **일정 관리 기능 진행 중** ([06-schedule.md](docs/features/06-schedule.md))
  - 참가자 선택 기능 추가 (그룹 일정에서 멤버 선택)
  - 참가자 모델 추가 (TaskParticipantModel, ParticipantUserModel)
  - 일정 유형 선택 (단순 일정/할일 연동)
  - 그룹별 일정/카테고리 관리 (개인/그룹 선택)
  - 마감일 설정 (시작일과 별도로 설정 가능)

### 2026-01-22
- ✅ **Q&A (문의하기) 기능 완료** ([16-qna.md](docs/features/16-qna.md))
  - 공개 Q&A 목록/상세 화면 구현
  - 내 질문 목록/상세/작성/수정 화면 구현
  - 카테고리별 필터 (버그, 기능 제안, 사용법, 계정, 결제, 기타)
  - 상태별 탭 필터 (전체/대기중/답변완료/해결완료)
  - 리치 텍스트 에디터 (flutter-quill) 적용 및 이미지 업로드
  - HTML 렌더링 (RichTextViewer) 및 XSS 방어
  - 질문 해결 완료 버튼 (ANSWERED → RESOLVED)
  - **관리자 답변 기능 완료**: 작성, 수정, 삭제
  - 다국어 지원 (한/영/일)

### 2026-01-21
- 🟨 **알림 시스템 기능 추가** ([14-notification.md](docs/features/14-notification.md))
  - 전체 알림 읽음 처리 기능 (PUT /notifications/read-all API 연동)
  - 개별 알림 읽음만 처리 버튼 (화면 이동 없음)
  - 알림 팝업 카드 헤더 레이아웃 개선 (타이틀/버튼 분리)
  - NotificationNavigationService로 라우팅 통합
  - 홈 화면 알림 뱃지 숫자 동기화 버그 수정

### 2026-01-09
- ✅ **공지사항 시스템 완료** ([15-announcements.md](docs/features/15-announcements.md))
  - 공지사항 CRUD 기능 완료 (ADMIN 전용)
  - 목록/상세 화면 구현 (고정 공지, 읽음 표시)
  - 카테고리 필터 기능 (전체/공지사항/이벤트/업데이트)
  - 마크다운 지원 (작성 및 렌더링)
  - 무한 스크롤 및 Pull-to-refresh
  - 백엔드 API 완전 연동
  - 대소문자 호환 JsonConverter 구현

### 2025-12-27
- ✅ **알림 시스템 프론트엔드 구현 완료** ([14-notification.md](docs/features/14-notification.md))
  - Firebase Cloud Messaging 통합 완료
  - 로컬 알림 서비스 구현
  - 알림 권한 관리 및 설정 UI 완료
  - FCM 토큰 관리 Provider 구현
  - 환경 변수 관리 개선 (.env 파일로 전환)
  - GitHub Actions에서 환경 변수 동적 생성 설정
  - 백엔드 API 연동 대기 중

### 2025-12-24
- ✅ **그룹 관리 기능 완료** ([12-groups.md](docs/features/12-groups.md))
  - 그룹 CRUD, 초대 시스템, 멤버 관리, 역할 체계 완료
  - 공통 역할 관리 시스템 (운영자 전용) 구현

- ✅ **설정 메뉴 주요 기능 완료** ([12-settings.md](docs/features/12-settings.md))
  - 프로필 설정 (이미지 업로드 포함) 완료
  - 테마 설정, 홈 위젯 설정 완료
  - 권한 관리 화면 (운영자 전용) 완료

### 진행 중인 작업
- 🟨 **회원 가입 및 로그인** (~90% 완료)
  - 남은 작업: 애플 로그인, 소셜 로그인 백엔드 완성

- 🟨 **메인화면 (대시보드)** (~80% 완료)
  - 완료: 모든 위젯 실제 데이터 연동, 대시보드 전용 독립 provider, 메모 위젯 추가
  - 남은 작업: 대시보드 전체 새로고침 연동, 이번 달 지출/육아포인트 위젯

- 🟨 **다국어 지원** (~75% 완료)
  - 남은 작업: 대시보드 및 그룹 관리 화면 다국어 적용

- 🟨 **알림 시스템** (~95% 프론트엔드 완료)
  - 완료: Firebase 설정, 서비스 레이어, Provider, 설정 UI, 메시지 처리
  - 완료: 알림 히스토리 화면, 전체 읽음 처리, 개별 읽음 처리, 알림 클릭 시 화면 라우팅
  - 남은 작업: 프로덕션 환경 FCM 테스트

- 🟨 **ToDoList** (~80% 완료)
  - 완료: 할일 CRUD, 칸반/리스트 뷰, 상태 드롭다운(6가지), 날짜별 보기, 모아 보기, 주간 바
  - 남은 작업: 필터링/정렬 UI, 완료 아카이브

---

## 🔮 향후 추가 예정 기능

이 섹션에는 나중에 추가될 수 있는 기능들을 기록합니다.

### 고려 중인 기능
- ⬜ 가족 사진 앨범
- ⬜ 가족 채팅
- ⬜ 가족 위치 공유
- ⬜ 건강 기록 (키, 몸무게 등)
- ⬜ 가족 목표 설정 및 추적
- ⬜ 데이터 백업/복원
- ⬜ 데이터 내보내기 (CSV, PDF)

---

## 📚 Related Documentation

- [CLAUDE.md](CLAUDE.md) - 개발 가이드 (개발 시 필독)
- [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) - 프로젝트 구조 및 아키�ecture
- [UI_ARCHITECTURE.md](UI_ARCHITECTURE.md) - UI/UX 디자인 시스템
- [docs/features/](docs/features/) - 기능별 상세 문서
- [docs/api/](docs/api/) - 백엔드 API 문서 (자동 생성)

---

**Priority Levels:**
- **P0**: Critical (MVP 필수)
- **P1**: High (MVP 권장)
- **P2**: Medium (후속 버전)
- **P3**: Low (나중에)
