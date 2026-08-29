# 💳 결제 시스템 작업 현황 (임시 문서)

> **이 문서는 결제 오픈 작업이 끝나면 삭제한다.**
> 확정된 내용은 그때 `docs/features/subscription.md`에 정리해 옮긴다.

**마지막 업데이트**: 2026-08-30
**목표**: 결제까지 완성한 뒤 **v1.2.0에 루틴·홈위젯과 함께 일괄 출시**

---

## 📍 지금 어디까지 왔나

```
Phase 0  계약·정산       ✅ 애플·구글 모두 완료
Phase 1  상품 설계       ✅ 확정
Phase 2  코드 보완       ✅ 커밋 848897e
Phase 3  콘솔 등록       🟨 구글 상품 등록 완료 / 애플 가격·테스터 남음
Phase 4  서버 키·웹훅    ✅ 백엔드 구현 완료 (프로덕션 env만 확인)
Phase 5  샌드박스 테스트 ⬜  ← 지금 여기
Phase 6  v1.2.0 릴리즈   ⬜
```

**바로 다음 할 일**: 실제 결제 테스트. Android는 라이선스 테스터 등록 후
바로 가능하고, iOS는 Mac에서 `pod install`이 선행되어야 한다.

---

## 왜 v1.2.0에 같이 내기로 했나

결제가 미완성인 채로 먼저 내면 구독 화면이 "준비 중" 빈 화면이 되어
**App Store Guideline 2.1(미완성 기능) 리젝 위험**이 있다. 실사용자가 적어
먼저 낼 이유가 없고, 심사를 한 번만 받는 편이 안전하다.

→ v1.2.0 릴리즈 준비를 한 번 했다가 revert함 (`af5f2e4`).
   결제가 끝나면 그 커밋을 참고해 다시 진행하면 된다.

---

## 상품 설계 (확정)

| 상품 ID | Tier | 가격 | 상태 |
|---------|------|------|------|
| `family_planner_ad_free_monthly` | `adFree` | **월 ₩1,900** | 🤖 등록 완료 / 🍎 진행 중 |
| `family_planner_premium_monthly` | `premium` | 미정 | **보류** |

- **판매 국가**: 대한민국만 → 현지화도 **한국어만** 넣으면 된다
- **연간 상품**: 2027년 도입 예정
- **무료 체험 2주**: **서버가 신규 가입자에게 부여**하는 방식(`isTrial`)이며
  스토어 Introductory Offer가 **아니다**. 결제수단 없이 체험할 수 있고
  스토어 표기 의무가 늘지 않아 심사에 유리하므로 이대로 유지한다.

### premium을 보류한 이유
전용 기능(AI 어시스턴트, 다이어리 미디어 첨부)이 아직 없어 adFree와 실질
차이가 없다. 구매 불가능한 상품을 노출하면 Guideline 2.1 위반이라
"출시 예정" 고지보다 **숨기는 편이 안전**하다.

→ `IapProductIds.all`에서 제외만 해둔 상태. 기능이 준비되면 콘솔에 등록하고
**`all`에 한 줄 추가**하면 켜진다. `tierForProductId` 매핑은 서버가 premium을
내려줄 수 있어 유지했다.

---

## ✅ Phase 0 — 계약·정산 (완료)

- 🍎 유료 앱 계약 **활성화됨** (2026-06-26 ~ 2027-06-16)
  - 계약이 활성이면 은행 계좌·세금 정보가 이미 검증을 통과한 것
- 🤖 결제 프로필 + 한국 세금 정보 완료
  - 구글은 Google Korea가 판매자(Merchant of Record)라 **미국 세금 정보
    (W-8BEN) 불필요**. 애플은 필수인데 계약 활성화로 이미 처리됨

**나중에 한 번 확인할 것**: 애플 원천징수율이 0%로 잡혔는지
(비즈니스 → 세금 → 미국 세금 양식). 첫 정산 전까지만 보면 된다.

---

## ✅ Phase 2 — 코드 보완 (완료, 커밋 `848897e`)

App Store Guideline 3.1.2가 구독 화면에 요구하는 항목을 채웠다.

- 가격 옆 **구독 기간** 병기 (`₩1,900 / 월간 구독`)
- **자동 갱신 고지문** — 갱신 조건·해지 기한·결제 시점
- **이용약관 / 개인정보 처리방침 링크** — 기존 라우트 재사용
- **구독 관리·해지 버튼** — 스토어 구독 설정으로 이동
- 광고 제거 혜택 설명
- 4개 언어 l10n 8종
- 덤: `Colors.red/green` 하드코딩 → `AppColors`, `fontSize: 11` → `textTheme`
  (DESIGN.md 위반이었음)

### 접근성·UI 개선 (커밋 `047116b`)
구독 상태를 보여주는 곳이 3군데인데 어디서도 구독 화면으로 갈 수 없어
진입로가 더보기 탭 하나뿐이었다.

- 설정 화면 구독 카드, 대시보드 체험 배너를 탭 가능하게
- 더보기 탭 구독 메뉴를 상단으로 이동 + 현재 tier 배지 노출
- 상품 하나만 있어 "왜 결제해야 하는지"가 안 보이던 문제를
  무료 vs 광고 제거 **플랜 비교 카드**로 해결 (혜택을 ✓/✗로 대비)

### 구독 상태 로컬 캐시 (커밋 `c82a04a`)
서버 조회 실패 시 무조건 free로 떨어져 **오프라인에서 구독자에게도 광고가
노출**되던 문제를 해결했다. `subscription_cache_service.dart` 참고.

조작 방어: 만료된 캐시는 읽는 즉시 폐기, 만료일 없는 유료 등급은 거부,
free는 미저장, 서버 응답이 오면 항상 덮어씀. 계정 간 누수를 막기 위해
로그아웃과 `_invalidateGroupProviders()` 양쪽에서 캐시를 지운다.

---

## 🟨 Phase 3 — 콘솔 등록 (진행 중)

### 🍎 App Store Connect
- [x] 구독 그룹 생성
- [x] 그룹/상품 현지화 (한국어)
  - 표시 이름 `광고 제거`
  - 설명 `앱 내 모든 광고가 표시되지 않습니다.`
- [ ] 가격 ₩1,900
- [ ] **심사용 스크린샷** (640x920 이상)
  - 상품이 실제로 뜨는 화면을 찍어야 하므로 **Phase 5에서 촬영**
  - 지금은 비워두고 저장해도 된다 (심사 제출 전까지만 채우면 됨)
- [ ] Sandbox 테스터 — **실제로 안 쓰는 이메일**로 만들 것
      (한번 Sandbox로 쓰면 그 계정은 정식 Apple ID로 못 쓴다)

### 🤖 Play Console
- [x] **AAB 내부 테스트 업로드** (`1.1.3+7`)
- [x] 구독 `family_planner_ad_free_monthly` / 이름 `광고 제거`
- [x] **기본 요금제** `monthly-autorenew` / 자동갱신 / 1개월 / ₩1,900 / 대한민국
- [x] 혜택 이름·설명 (애플과 동일 문구)
- [x] **기본 요금제 활성화 + 구독 활성화**
- [ ] 라이선스 테스터 등록 (일반 Gmail 가능)

**유예 기간·계정 보류는 기본값(켜둠)으로 두었다.** 결제 일시 실패로
사용자를 바로 잃지 않게 해주는 장치라 그대로 두는 편이 낫다. 다만
백엔드가 웹훅으로 이 상태를 처리해야 한다 → Phase 4 참고.

---

## ✅ Phase 4 — 서버 키·웹훅 (백엔드 구현 완료)

백엔드 저장소: `../family_planner_back_end`
관련 커밋: `76d406e` (검증·웹훅 구현), `aa85182` (자격증명 점검 스크립트),
`5050993` (구글 웹훅 공유 시크릿 검증)

**요청한 6개 항목이 모두 반영되었고 테스트 44개가 통과한다** (2026-08-29 확인).

| 요청 | 구현 |
|------|------|
| 스토어 검증 | Google Play Developer API + App Store Server Library |
| 웹훅 | RTDN / Apple Server Notifications V2 |
| 유예 기간·계정 보류 구분 | `ENTITLED_STATUSES` 로 처리 (아래) |
| tier 문자열 스펙 | `ad_free` 전송 — 프론트 파서와 호환 확인 |
| 422 / 5xx 구분 | 전용 예외 클래스로 분리 |
| 무료 체험 유지 | `isTrial` 현행 유지 |

요청하지 않았지만 함께 들어온 것: 웹훅 공유 시크릿 검증(타이밍 공격 방어),
Apple 루트 인증서 번들, 자격증명 점검 스크립트, 구독 재조정 스케줄러.

### tier 문자열 호환 (검증 완료)
백엔드는 Prisma enum을 그대로 내려 **`"ad_free"`** 를 보낸다.
프론트 파서(`subscription_model.dart`)가 언더스코어를 제거하고 소문자로
비교하므로 `ad_free` → `adfree` = `adFree` 로 정상 매칭된다.

### 유예 기간·계정 보류 (요청대로 구현됨)
`subscription.service.ts`의 `ENTITLED_STATUSES`:

- **혜택 유지**: `active`, `grace_period`, `canceled`
  (취소는 만료일까지 유지)
- **즉시 회수**: 환불·보류 → `expireSubscription()` 으로 free 하향

웹훅은 알림 내용을 그대로 믿지 않고 **스토어에 재조회해 검증**한 뒤
상태를 반영한다.

### 422 / 5xx 구분 (요청대로 구현됨)
`verifiers/verification-error.ts`에 두 예외를 분리:

- `PurchaseVerificationFailedException` → **422** (영수증 무효·중복 사용)
- `PurchaseVerificationUnavailableException` → **503** (스토어 장애·설정 누락)

---

## ⚠️ 릴리즈 전 반드시 확인할 프로덕션 환경변수

로컬 `.env` 기준으로 점검한 결과다. **Railway 프로덕션 환경변수는 따로
확인해야 한다.**

### 1. `GOOGLE_WEBHOOK_SECRET` — 비어 있음 🚨
미설정이면 토큰 검증을 **건너뛰고 경고만** 남긴다
(`webhook.controller.ts`의 `verifyGoogleWebhookToken`).
개발에는 지장이 없지만 **프로덕션에 없으면 누구나 웹훅을 호출해 구독
상태를 조작할 수 있다.** Pub/Sub 구독 URL의 `?token=` 값과 일치시켜야 한다.

### 2. `APPLE_IAP_ENVIRONMENT` — 현재 `Sandbox`
테스트 중에는 맞다. **릴리즈 전 `Production`으로 바꿔야 한다.**
안 바꾸면 실제 구매 검증이 전부 실패한다.

### 그 외 자격증명 (로컬은 설정됨)
`GOOGLE_PLAY_SERVICE_ACCOUNT_EMAIL` / `..._PRIVATE_KEY`,
`APPLE_IAP_ISSUER_ID` / `APPLE_IAP_KEY_ID` / `APPLE_IAP_PRIVATE_KEY`,
`APPLE_APP_APPLE_ID`

→ 백엔드에 `scripts/check-iap-credentials.ts` 점검 스크립트가 있으니
프로덕션에서 실행해 확인할 것.

### 프론트 확인 결과 (2026-08-27)
Phase 4는 **순수 백엔드 작업**이며 프론트에 추가 구현은 없다.
verify/restore/getStatus 연동, 422 처리, Analytics, 광고 게이팅 모두 완료.

---

## ⬜ Phase 5 — 테스트

실결제 없이 가능 (Android 라이선스 테스터 / iOS Sandbox).

검증할 시나리오:
- [ ] 구매 → 서버 검증 → tier 반영 → 광고 사라짐
- [ ] 구독 복원
- [ ] 결제 취소
- [ ] 검증 실패(422) — `completePurchase` 안 하고 재시도 가능한지
- [ ] 만료 후 free 다운그레이드
- [ ] 네트워크 끊김 중 구매
- [ ] 구독 취소·환불 시 웹훅으로 tier 하향
- [ ] **심사용 스크린샷 촬영** (애플 제출용)

---

## ⬜ Phase 6 — v1.2.0 릴리즈

- [ ] 🚨 **프로덕션 `APPLE_IAP_ENVIRONMENT`를 `Production`으로 변경**
      (Sandbox로 두면 실제 구매 검증이 전부 실패한다)
- [ ] 🚨 **프로덕션 `GOOGLE_WEBHOOK_SECRET` 설정 확인**
- [ ] `pubspec.yaml` → `1.2.0+8`
- [ ] `docs/release/v1.2.0.md` 패치노트 (revert된 `572e06d` 참고)
- [ ] ROADMAP.md 루틴 ✅ 전환, 최근 완료 항목 추가
- [ ] `docs/features/23-routine.md` 상태 ✅
- [ ] **이 문서(`IAP_WORK_IN_PROGRESS.md`) 삭제**, 내용은
      `docs/features/subscription.md`로 정리해 이관

---

## ⬜ 후속 과제 — 프리미엄 플랜 추가 시 함께 정리

프리미엄 전용 기능(AI 어시스턴트, 다이어리 미디어 첨부)이 준비되면
tier 전환 로직(ad_free ↔ premium 업/다운그레이드)을 손봐야 하는데,
아래 항목들이 같은 영역이라 그때 한번에 정리하는 편이 효율적이다.

**지금 당장 급하지 않은 이유**: 운영자 부여는 사람이 신중히 하는 작업이고
아직 결제 사용자가 없다. 다만 결제가 열리고 사용자가 늘면 터진다.

### 1. 🚨 운영자 부여가 결제 구독을 덮어쓴다 (백엔드)
`subscription-admin.service.ts`의 `updateUserSubscription()`은 `user`
테이블만 수정하고 `subscription` 테이블은 건드리지 않는다.

결제 중인 사용자에게 운영자가 실수로 `free`를 주면:
```
user.subscriptionTier = free      ← 운영자가 덮어씀
subscription.status   = active    ← 결제 기록은 살아있음
```
사용자는 **돈을 내면서 혜택을 잃는다.** 스토어 청구는 계속된다.
복구도 자동이 아니라 다음 웹훅(`RENEWED`)이나 재검증 스케줄러를
기다려야 해서 **최대 한 달**이 걸릴 수 있다.

→ 결제 구독이 살아있는 사용자를 낮출 때 경고·차단하거나 최소한 로그를 남길 것

### 2. 🚨 만료일 없이 부여하면 무기한 구독이 된다 (백엔드)
`subscription.service.ts`의 `checkActive()`:
```ts
if (!expiresAt) return true;   // 만료일 없으면 무조건 활성
```
운영자가 `expiresAt`을 비운 채 부여하면 **영구 구독**이 된다. 의도된
동작일 수도 있으나(평생 이용권·직원 계정) 실수로 비워도 조용히 영구
부여된다는 게 위험하다.

→ 확인 단계를 두거나 기본 만료일을 강제할 것

참고: 프론트 캐시(`subscription_cache_service.dart`)는 이 케이스를
신뢰하지 않는다. 만료일 없는 유료 등급은 캐시에 남기지 않으므로 서버가
주면 화면에는 보이되 오프라인 폴백으로는 쓰이지 않는다.

### 3. ⚠️ 수동 부여가 "체험 중"으로 표시된다 (백엔드, 사소함)
```ts
isTrial: tier === ad_free && !inAppPurchaseToken
```
결제 이력 없는 `ad_free`를 전부 체험으로 간주한다. 운영자가 보상으로
`ad_free`를 주면 앱에 "2주 무료 체험 중 / N일 후 전환됩니다"로 뜬다.
동작에는 문제없고 문구만 어색하다.

→ 수동 부여 여부를 구분하는 필드를 두면 해결된다

### 4. 프리미엄 상품 활성화 (프론트)
- `IapProductIds.all`에 `premiumMonthly` 추가 (한 줄)
- 스토어 콘솔에 상품 등록 — **애플은 기존 구독 그룹 안에** 넣어야
  업/다운그레이드가 정상 동작한다
- 플랜 비교 카드가 3열이 되므로 레이아웃 재검토 필요
  (가로 배치 → 세로 스택 전환 등)

---

## ⚠️ 함정 모음 (다시 만나면 시간 날리는 것들)

### 상품 ID는 등록 후 변경·삭제 불가
`family_planner_ad_free_monthly` — 코드
(`lib/core/constants/iap_product_ids.dart`)와 **한 글자라도 다르면**
`notFoundIDs`에 들어가 화면에 "구독 상품을 준비 중입니다"만 뜬다.
애플·구글 양쪽 **동일하게** 등록할 것.

### 애플 구독 그룹은 반드시 하나로
같은 그룹 안의 상품끼리만 업/다운그레이드가 가능하다. premium·연간 상품도
**같은 그룹**에 넣어야 한다. 나누면 사용자가 두 구독을 동시 결제하게 된다.

### 애플 표시 이름에 기간·가격 넣지 말 것
애플이 자동으로 붙여 표기하므로 중복되어 반려된다.
`광고 제거` ⭕ / `광고 제거 월간`, `광고 제거 (₩1,900/월)` ❌
(`광고 제거 월간`은 내부용 **참조 이름**에만 사용)

### 구글은 "활성화"가 수동, 그것도 2단계
**상품**과 **기본 요금제** 둘 다 활성화해야 조회된다.
앱에 상품이 안 뜨면 십중팔구 이것.

### 콘솔 반영 지연
등록 직후엔 조회 안 될 수 있다. 구글 최대 수 시간, 애플 수십 분.
바로 안 된다고 상품 ID를 의심하지 말 것.

### Android 빌드는 flavor 지정 필요
```bash
flutter build appbundle --release --flavor prod
# → build/app/outputs/bundle/prodRelease/app-prod-release.aab
```
flavor 없이 빌드하면 Gradle은 **성공하는데** Flutter가 기본 경로를 찾다가
`Gradle build failed to produce an .aab file` 에러를 낸다. **빌드 실패가 아니다.**
`find build -name "*.aab"`로 확인할 것.

`app-dev-release.aab`는 applicationId가 `.dev`로 끝나 별개 앱이므로
**업로드하면 안 된다**.

### 버전 코드 충돌
Play Console은 이미 올라간 버전 코드를 거부한다.
`1.1.3+6`이 거부되어 **`1.1.3+7`로 올렸다** (내부 테스트용).
v1.2.0 릴리즈 때는 **`1.2.0+8`** 이 된다.

### iOS는 pod install이 필요하다
`in_app_purchase` 추가 후 `ios/Podfile.lock`이 갱신되지 않았다.
**Mac에서** `cd ios && pod install` 실행해야 iOS 빌드가 된다.
Windows에서는 불가.

### Android BILLING 권한은 신경 안 써도 된다
`AndroidManifest.xml`에 수동 선언이 없지만 Play Billing Library 6+가
자동 병합하므로 문제되지 않는다.

---

## 관련 파일

| 역할 | 경로 |
|------|------|
| 상품 ID | `lib/core/constants/iap_product_ids.dart` |
| 결제 서비스 | `lib/core/services/in_app_purchase_service.dart` |
| 구독 화면 | `lib/features/subscription/presentation/screens/subscription_screen.dart` |
| Repository | `lib/features/subscription/data/repositories/subscription_repository.dart` |
| Provider | `lib/core/providers/subscription_provider.dart` |
| Tier 정의 | `lib/core/models/subscription_tier.dart` |
| API 문서 | `docs/api/subscription.md`, `docs/api/webhook.md` |
