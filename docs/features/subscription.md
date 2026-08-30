# 구독 & 광고 시스템 ✅

## 상태
✅ 완료 (광고 SDK 연동 + 인앱결제(IAP) 연동 — v1.2.0)

---

## 구독 단계

| Tier | 광고 | 프리미엄 기능 |
|------|------|--------------|
| `free` | 배너 + 전면 + 보상형 | 보상형 광고 시청 후 일시 허용 |
| `adFree` | 없음 | X |
| `premium` | 없음 | O (보류 — 전용 기능 없어 아직 판매 안 함) |

- 판매 상품은 `family_planner_ad_free_monthly` (월 ₩1,900, 대한민국만) 하나
- 무료 체험 2주는 스토어 Introductory Offer가 아니라 **서버가 신규 가입자에게 부여**하는 방식(`isTrial`)
- `premium`은 `IapProductIds.all`에서 제외된 상태로 코드는 유지 (전용 기능 준비되면 한 줄 추가로 활성화)

---

## UI 구현
- [x] 구독 관리 화면(`SubscriptionScreen`) — 현재 tier 카드, 무료 vs 광고 제거 **플랜 비교 카드**(혜택 ✓/✗ 대비), 구매/복원/스토어 구독 관리 버튼
- [x] 진입점 3곳 — 더보기 탭 상단 메뉴(tier 배지), 설정 화면 구독 카드, 대시보드 체험 배너 (모두 탭하면 구독 화면으로 이동)
- [x] App Store Guideline 3.1.2 필수 고지 — 가격+기간 병기, 자동 갱신 조건, 해지 방법, 이용약관/개인정보 처리방침 링크
- [x] 4개 언어(한/영/일/중) l10n 적용

## 데이터 모델
- `SubscriptionModel` — tier, isActive, expiresAt, isTrial
- `SubscriptionTier` — free / adFree / premium
- `IapProductIds` — 상품 ID ↔ tier 매핑

## 기능 구현

### 광고 게이팅
- `AdService` — 배너/전면/보상형 광고 래퍼
- `InterstitialAdMixin` — 생성 화면 저장 완료 후 전면 광고 (일정/계좌/가계지출/저금통/메모 생성·수정)
- `requirePremiumOrAd()` — 프리미엄 기능 진입 시 보상형 광고 게이트

### 인앱결제(IAP)
- `InAppPurchaseService` — 상품 조회, 구매, 복원
- 앱 시작 시 `startBackgroundSync()`로 전역 리스너 하나를 추가로 등록해, **구독 화면을 열지 않아도** 미완료 거래(예: 구매 직후 앱 종료)를 다음 실행 때 자동으로 재검증·완료 처리. 화면이 열려 있을 때는 화면 쪽 리스너와 이벤트가 겹칠 수 있으나, 서버 verify가 멱등해서 안전
- 구매/복원 성공 → `subscriptionProvider.verify()` → 서버 영수증 검증 → tier 반영
- 서버 검증 실패(422)는 `completePurchase` 보류, 재시도 가능한 상태로 유지
- `restored` 이벤트(스토어가 과거 거래를 자동 재전달)는 조용히 재검증만 하고 "구매 완료" 알림은 띄우지 않음 (사용자가 방금 구매한 게 아니므로)

### 오프라인 대비 로컬 캐시
- `subscription_cache_service.dart` — 서버 조회 실패 시 마지막 상태로 폴백, 오프라인에서 구독자에게 광고가 잘못 노출되는 것 방지
- 조작 방어: 만료된 캐시는 읽는 즉시 폐기 / 만료일 없는 유료 등급은 저장 안 함 / free는 저장 안 함 / 서버 응답이 오면 항상 덮어씀 / 로그아웃·계정전환 시 캐시 삭제

### 백엔드 검증·웹훅 (`family_planner_back_end`)
- Google Play Developer API / App Store Server Library로 영수증 재검증 (클라이언트 신고를 그대로 믿지 않음)
- RTDN(Google) / Apple Server Notifications V2 웹훅으로 상태 동기화
- `ENTITLED_STATUSES`: 취소(자동갱신 끔)는 **만료일까지 혜택 유지**, 환불·계정보류는 **즉시 회수**
- 422(영수증 무효·중복)/503(스토어 장애) 구분 처리
- 매일 03:00 재조정 스케줄러로 웹훅 유실 보완 (단, DB에 아직 없는 최초 구매는 스케줄러도 못 잡음 → 위 백그라운드 동기화가 그 구멍을 메움)

## 구현 위치

| 역할 | 경로 |
|------|------|
| 상품 ID | `lib/core/constants/iap_product_ids.dart` |
| 결제 서비스 | `lib/core/services/in_app_purchase_service.dart` |
| 구독 화면 | `lib/features/subscription/presentation/screens/subscription_screen.dart` |
| Repository | `lib/features/subscription/data/repositories/subscription_repository.dart` |
| Provider | `lib/core/providers/subscription_provider.dart` |
| Tier 정의 | `lib/core/models/subscription_tier.dart` |
| 로컬 캐시 | `lib/core/services/subscription_cache_service.dart` |
| 앱 시작 시 백그라운드 동기화 등록 | `lib/main.dart` |
| API 문서 | `docs/api/subscription.md`, `docs/api/webhook.md` |
| 백엔드 검증/웹훅 | `family_planner_back_end` — `subscription.service.ts`, `webhook.service.ts`, `verifiers/` |

---

## 나중에 할 작업

### 1. 프리미엄 플랜 활성화
전용 기능(AI 어시스턴트, 다이어리 미디어 첨부)이 준비되면:
- `IapProductIds.all`에 `premiumMonthly` 추가
- 스토어 콘솔에 상품 등록 — **애플은 기존 구독 그룹 안에** 넣어야 업/다운그레이드가 정상 동작
- 플랜 비교 카드가 3열이 되므로 레이아웃 재검토 (가로 → 세로 스택 등)

### 2. 🚨 운영자 수동 부여가 결제 구독을 덮어쓴다 (백엔드)
`subscription-admin.service.ts`의 `updateUserSubscription()`은 `user` 테이블만 수정하고 `subscription` 테이블은 안 건드림. 결제 중인 사용자에게 운영자가 실수로 `free`를 주면 스토어 청구는 계속되는데 혜택만 사라지고, 복구도 다음 웹훅이나 재검증 스케줄러를 기다려야 해서 최대 한 달 걸릴 수 있음. → 결제 구독이 살아있는 사용자를 낮출 때 경고·차단 필요.

### 3. 🚨 만료일 없이 부여하면 무기한 구독이 된다 (백엔드)
`subscription.service.ts`의 `checkActive()`는 `expiresAt`이 없으면 무조건 활성으로 판단. 운영자가 실수로 비운 채 부여하면 조용히 영구 구독이 됨. → 확인 단계 또는 기본 만료일 강제 필요.

### 4. AdMob 실제 광고 단위 ID로 교체 (스토어 배포 직전 확인)
현재 Google 공식 테스트 ID 사용 중 — `ad_service.dart`, `AndroidManifest.xml`의 `APPLICATION_ID`, `Info.plist`의 `GADApplicationIdentifier`.

---

## 주의사항 (다시 만나면 시간 날리는 것들)

- **상품 ID는 등록 후 변경·삭제 불가** — 코드(`iap_product_ids.dart`)와 콘솔 등록 철자가 한 글자라도 다르면 `notFoundIDs`에 들어가 "구독 상품을 준비 중입니다"만 뜬다.
- **애플 구독 그룹은 반드시 하나로** — 프리미엄·연간 상품도 같은 그룹에 넣어야 한다. 나누면 사용자가 두 구독을 동시 결제할 수 있다.
- **애플 표시 이름에 기간·가격 넣지 말 것** — 애플이 자동으로 붙여 표기해서 중복되면 반려된다.
- **구글은 상품 + 기본 요금제 둘 다 수동 활성화**해야 조회된다. 앱에 상품이 안 뜨면 십중팔구 이것.
- **콘솔 반영 지연** — 등록 직후엔 조회 안 될 수 있다 (구글 최대 수 시간, 애플 수십 분). 상품 ID를 바로 의심하지 말 것.
- **Android 릴리즈 빌드는 `--flavor prod` 필요** — 안 하면 Gradle은 성공하지만 Flutter가 기본 경로에서 산출물을 못 찾아 `Gradle build failed to produce an .aab file` 에러가 난다 (빌드 실패가 아니다).
- **iOS는 `pod install` 필요** — `in_app_purchase` 등 패키지 추가 후 `ios/Podfile.lock` 갱신이 안 되면 iOS 빌드가 실패한다. Windows에서는 불가, Mac에서만 가능.
- **Sandbox 결제 관리는 웹 링크로 안 열림** — 앱의 "스토어 구독 관리" 버튼은 프로덕션 웹 URL이라 Sandbox 테스트 중엔 실제 구독 페이지로 연결된다. Sandbox 취소 테스트는 기기 설정(Settings → App Store → Sandbox Account)에서 해야 한다.
