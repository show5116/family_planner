# 구독 & 광고 시스템

**상태**: 🟨 진행 중 (광고 SDK 연동 완료 / 인앱결제 미연동)

---

## 구독 단계

| Tier | 광고 | 프리미엄 기능 |
|------|------|--------------|
| `free` | 배너 + 전면 + 보상형 | 보상형 광고 시청 후 일시 허용 |
| `adFree` | 없음 | X |
| `premium` | 없음 | O |

---

## ✅ 완료된 작업

### 광고 (google_mobile_ads)
- `AdService` — 배너/전면/보상형 광고 래퍼 (`lib/core/services/ad_service.dart`)
- `BannerAdWidget` — 대시보드 2번째 위젯 뒤 삽입 (`lib/shared/widgets/banner_ad_widget.dart`)
- `InterstitialAdMixin` — 생성 화면에서 저장 완료 후 전면 광고 (`lib/core/mixins/interstitial_ad_mixin.dart`)
- `requirePremiumOrAd()` — 프리미엄 기능 진입 시 보상형 광고 게이트 (`lib/core/utils/premium_gate.dart`)

### 전면 광고 적용 화면
- 일정 생성/수정: `task_form_screen.dart`
- 자산 계좌 생성/수정: `account_form_screen.dart`
- 가계 지출 생성/수정: `expense_form_screen.dart`
- 저금통 생성/수정: `savings_form_screen.dart`
- 메모 생성/수정: `memo_form_screen.dart`

### 구독 API 연동
- `SubscriptionModel` (`lib/features/subscription/data/models/subscription_model.dart`)
- `SubscriptionRepository` — GET `/subscription`, POST `/subscription/verify`, POST `/subscription/restore` (`lib/features/subscription/data/repositories/subscription_repository.dart`)
- `subscriptionProvider` (AsyncNotifier) — 앱 시작 시 서버에서 구독 상태 조회 (`lib/core/providers/subscription_provider.dart`)
- `showAdsProvider` — 광고 표시 여부 편의 Provider

---

## ⬜ 나중에 할 작업

### 1. AdMob 실제 ID 교체 (스토어 배포 직전)
현재 Google 공식 테스트 ID 사용 중. 실제 배포 시 교체 필요.

| 파일 | 교체 위치 |
|------|----------|
| `lib/core/services/ad_service.dart` | `_androidBanner`, `_androidInterstitial`, `_androidRewarded`, `_iosBanner`, `_iosInterstitial`, `_iosRewarded` |
| `android/app/src/main/AndroidManifest.xml` | `com.google.android.gms.ads.APPLICATION_ID` value |
| `ios/Runner/Info.plist` | `GADApplicationIdentifier` value |

AdMob 콘솔: https://admob.google.com → 앱 추가 → 광고 단위 생성

---

### 2. 인앱결제 연동 (`in_app_purchase` 패키지)

**패키지 추가 필요:**
```yaml
in_app_purchase: ^3.2.0
```

**구현 순서:**
1. Google Play Console / App Store Connect에서 구독 상품 등록
   - 상품 ID 예시: `family_planner_ad_free_monthly`, `family_planner_premium_monthly`
2. `InAppPurchaseService` 작성
   - `initialize()` — 결제 스트림 구독
   - `purchaseSubscription(productId)` — 결제 시작
   - `restorePurchases()` — 구독 복원
3. 결제 완료 콜백에서 `subscriptionProvider.notifier.verify()` 호출
   - `purchaseToken` (Google) 또는 Apple receipt 서버에 전달
4. 구독 관리 화면 (`SubscriptionScreen`) 구현
   - 현재 tier 표시
   - 상품 목록 및 구매 버튼
   - 구독 복원 버튼

**플로우:**
```
유저 결제 → in_app_purchase → purchaseToken 획득
→ POST /subscription/verify (tier + token)
→ 서버에서 스토어 영수증 검증 (추후 백엔드 작업)
→ subscriptionProvider 갱신 → 광고 숨김
```

---

### 3. 구독 관리 UI
- [ ] `lib/features/subscription/presentation/screens/subscription_screen.dart` 생성
- [ ] 더보기 탭(`more_tab.dart`)에 구독 관리 메뉴 추가
- [ ] 설정 화면에 현재 구독 상태 배지 표시

---

### 4. 백엔드 영수증 검증 (백엔드 작업)
- Google Play: `AndroidPublisher` API로 `purchaseToken` 검증
- App Store: `verifyReceipt` 또는 `App Store Server API` 검증
- 만료일 자동 갱신 처리 (Webhook 또는 주기적 확인)
