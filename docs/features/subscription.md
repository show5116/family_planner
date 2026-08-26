# 구독 & 광고 시스템

**상태**: 🟨 진행 중 — 코드 구현 완료 / 스토어 콘솔 등록 진행 중

**목표**: 결제까지 완성한 뒤 **v1.2.0에 루틴·홈위젯과 함께 일괄 출시**.
실사용자가 적어 먼저 낼 이유가 없고, 심사를 한 번만 받는 편이 안전하다는 판단.

**마지막 업데이트**: 2026-08-27

---

## 상품 설계 (확정)

| 상품 ID | Tier | 가격 | 상태 |
|---------|------|------|------|
| `family_planner_ad_free_monthly` | `adFree` | **월 ₩1,900** | 등록 진행 중 |
| `family_planner_premium_monthly` | `premium` | 미정 | **보류** |

- **판매 국가**: 대한민국만
- **연간 상품**: 2027년 도입 예정
- **무료 체험**: 2주. **서버가 신규 가입자에게 부여**하는 방식(`isTrial`)이며
  스토어 Introductory Offer가 **아니다**. 결제수단 등록 없이 체험할 수 있고
  스토어 표기 의무가 늘지 않아 심사에 유리하므로 이 방식을 유지한다.

### premium을 보류한 이유
전용 기능(AI 어시스턴트, 다이어리 미디어 첨부)이 아직 없어 adFree와 실질
차이가 없다. 구매할 수 없는 상품을 화면에 노출하면 App Store Guideline
2.1(미완성 기능) 위반이라 "출시 예정" 고지보다 **숨기는 편이 안전**하다.

→ `IapProductIds.all`에서 제외만 해둔 상태. 기능이 준비되면 콘솔에 상품을
등록하고 `all`에 한 줄 추가하면 바로 켜진다. `tierForProductId` 매핑은
서버가 premium을 내려줄 수 있어 그대로 유지.

---

## ✅ 완료된 작업

### 광고 (google_mobile_ads)
- `AdService` — 배너/전면/보상형 래퍼 (`lib/core/services/ad_service.dart`)
- `BannerAdWidget` — 대시보드 2번째 위젯 뒤 삽입
- `InterstitialAdMixin` — 생성 화면 저장 완료 후 전면 광고
- `requirePremiumOrAd()` — 프리미엄 기능 진입 시 보상형 광고 게이트
- **실제 AdMob Unit ID 적용 완료** — 환경에 따라 테스트/실 ID 자동 전환
  (`_AdUnitIds.banner(useTest)` 등). 별도 교체 작업 불필요.

### 구독 API 연동
- `SubscriptionModel`, `SubscriptionRepository`
  — GET `/subscription`, POST `/subscription/verify`, POST `/subscription/restore`
- `subscriptionProvider` (AsyncNotifier), `showAdsProvider`

### 인앱결제 (in_app_purchase ^3.3.0)
- `InAppPurchaseService` — 초기화/구매/복원/`completePurchase`
- 서버 검증 실패(422) 시 `completePurchase`를 **호출하지 않아** 재시도 여지를 남김
  (호출해버리면 Android가 일정 기간 후 자동 환불)
- `SubscriptionScreen` — 현재 플랜, 상품 목록, 복원
- 더보기 탭에 "구독 관리" 진입점

### App Store Guideline 3.1.2 필수 고지 (커밋 `848897e`)
- 가격 옆 **구독 기간** 병기 (`₩1,900 / 월간 구독`)
- **자동 갱신 고지문** — 갱신 조건·해지 기한·결제 시점
- **이용약관 / 개인정보 처리방침 링크** — 기존 `AppRoutes.termsOfService`,
  `AppRoutes.privacyPolicy` 재사용
- **구독 관리·해지 버튼** — 스토어 구독 설정으로 이동
- 4개 언어(한/영/일/중) l10n 8종

---

## 🟨 진행 중 — 스토어 콘솔 (Phase 3)

### 계약·정산 (Phase 0) — ✅ 완료
- 🍎 유료 앱 계약 **활성화됨** (2026-06-26~2027-06-16)
- 🤖 결제 프로필 등록 완료, 한국 세금 정보 입력 완료
  - 구글은 Google Korea가 판매자(Merchant of Record)라 **미국 세금 정보
    (W-8BEN) 불필요**. 애플은 필수이며 계약 활성화로 이미 처리된 상태.

### 🍎 App Store Connect
- [x] 구독 그룹 생성
- [x] 그룹/상품 현지화 (한국어만 — 대한민국 단독 판매)
  - 표시 이름 `광고 제거` / 설명 `앱 내 모든 광고가 표시되지 않습니다.`
  - ⚠️ 표시 이름에 기간·가격을 넣으면 애플이 자동 표기와 중복되어 반려
- [ ] **심사용 스크린샷** — 640x920 이상. 상품이 실제로 뜨는 화면을 캡처해야
      하므로 콘솔 반영 후 Phase 5에서 촬영. 심사 제출 전까지만 채우면 됨
- [ ] Sandbox 테스터 (실제로 안 쓰는 이메일로 생성할 것)

### 🤖 Play Console
- [ ] **AAB 내부 테스트 업로드** ← 현재 여기서 막힘
  - 구글은 빌드가 한 번이라도 업로드되어야 구독 상품 생성이 열린다
- [ ] 구독 `family_planner_ad_free_monthly`
- [ ] **기본 요금제** `monthly-autorenew` / 자동갱신 / 1개월 / ₩1,900
- [ ] **기본 요금제 활성화 + 구독 활성화** (2단계 모두)
- [ ] 라이선스 테스터 등록

---

## ⬜ 남은 작업

### Phase 4. 서버 키·웹훅 (백엔드)
- 🤖 서비스 계정 생성 → Play Console 권한 부여 → JSON 키를 백엔드 env에
- 🍎 In-App Purchase Key(`.p8`) 발급 → 백엔드 등록
- 웹훅 연결 (백엔드에 엔드포인트는 이미 존재)
  - 구글 RTDN → Pub/Sub → `/v1/webhook/google`
  - 애플 Server Notifications V2 → `/v1/webhook/apple`
  - ⚠️ 애플은 **Production/Sandbox 각각** 등록해야 한다

### Phase 5. 테스트
검증 시나리오: 구매→검증→tier 반영 / 복원 / 결제 취소 /
검증 실패(422) / 만료 후 free 다운그레이드 / 네트워크 끊김 중 구매 /
구독 취소·환불 시 웹훅으로 tier 하향

### Phase 6. v1.2.0 릴리즈
루틴·홈위젯·구독을 함께 출시

---

## ⚠️ 주의사항

### 상품 ID는 등록 후 변경·삭제 불가
`family_planner_ad_free_monthly` — 코드
(`lib/core/constants/iap_product_ids.dart`)와 **한 글자라도 다르면**
`notFoundIDs`에 들어가 화면에 "구독 상품을 준비 중입니다"만 뜬다.
애플·구글 양쪽 동일하게 등록할 것.

### 애플 구독 그룹은 반드시 하나로
같은 그룹 안의 상품끼리만 업/다운그레이드가 가능하다. premium·연간 상품을
나중에 추가할 때도 **같은 그룹**에 넣어야 한다. 그룹을 나누면 사용자가 두
구독을 동시에 결제하게 된다.

### 구글은 "활성화"를 수동으로 해야 한다
상품과 기본 요금제 **둘 다** 활성화해야 조회된다. 앱에 상품이 안 뜨면
십중팔구 이것.

### 콘솔 반영 지연
등록 직후엔 조회되지 않을 수 있다. 구글 최대 수 시간, 애플 수십 분.
바로 안 된다고 상품 ID를 의심하지 말 것.

### Android 빌드는 flavor 지정 필요
`dev`/`prod` flavor가 있어 `flutter build appbundle --release`만 실행하면
Flutter가 산출물을 못 찾고 실패한 것처럼 보인다(**실제로는 빌드 성공**).

```bash
flutter build appbundle --release --flavor prod
# → build/app/outputs/bundle/prodRelease/app-prod-release.aab
```

`app-dev-release.aab`는 applicationId가 `.dev`로 끝나 별개 앱이므로
**업로드하면 안 된다**.

### iOS는 pod install이 필요하다
`in_app_purchase` 추가 후 `ios/Podfile.lock`이 갱신되지 않았다.
**Mac에서** `cd ios && pod install` 실행해야 iOS 빌드가 된다.

### Android BILLING 권한
`AndroidManifest.xml`에 수동 선언이 없지만, Play Billing Library 6+가
권한을 자동 병합하므로 문제되지 않는다.

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
| 광고 서비스 | `lib/core/services/ad_service.dart` |
| API 문서 | `docs/api/subscription.md`, `docs/api/webhook.md` |
