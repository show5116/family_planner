# 💳 결제 시스템 작업 현황 (임시 문서)

> **이 문서는 결제 오픈 작업이 끝나면 삭제한다.**
> 확정된 내용은 그때 `docs/features/subscription.md`에 정리해 옮긴다.

**마지막 업데이트**: 2026-08-27
**목표**: 결제까지 완성한 뒤 **v1.2.0에 루틴·홈위젯과 함께 일괄 출시**

---

## 📍 지금 어디까지 왔나

```
Phase 0  계약·정산       ✅ 애플·구글 모두 완료
Phase 1  상품 설계       ✅ 확정
Phase 2  코드 보완       ✅ 커밋 848897e
Phase 3  콘솔 등록       🟨 구글 상품 등록 완료 / 애플 가격·테스터 남음  ← 지금 여기
Phase 4  서버 키·웹훅    ⬜
Phase 5  샌드박스 테스트 ⬜
Phase 6  v1.2.0 릴리즈   ⬜
```

**바로 다음 할 일**: 구글 라이선스 테스터 등록 + 애플 가격(₩1,900)·Sandbox 테스터.

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

## ⬜ Phase 4 — 서버 키·웹훅 (백엔드)

백엔드에 엔드포인트는 **이미 존재**한다 (`docs/api/webhook.md`).
연결 작업만 남았다.

| | 할 일 |
|---|---|
| 🤖 구글 | 서비스 계정 생성 → Play Console 권한 부여 → JSON 키를 백엔드 env에 |
| 🍎 애플 | In-App Purchase Key(`.p8`) 발급 → 백엔드 등록 |
| 웹훅 | 구글 RTDN → Pub/Sub → `/v1/webhook/google` |
| | 애플 Server Notifications V2 → `/v1/webhook/apple` |

⚠️ 애플 웹훅은 **Production / Sandbox 각각** 등록해야 한다.

### 유예 기간·계정 보류 처리 (구글)
Play Console에서 기본값으로 켜둔 상태다. 백엔드가 RTDN으로 받아
구분해서 처리해야 한다.

- **유예 기간**(결제 실패 후 재시도 중) → tier 유지, `isActive` 유지
- **계정 보류**(유예 기간 만료) → tier를 free로 내림
- 이후 결제 성공 시 즉시 복구

이 구분 없이 결제 실패를 바로 만료로 처리하면, 카드 한도 초과 같은
일시적 실패로도 사용자가 구독을 잃는다.

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

- [ ] `pubspec.yaml` → `1.2.0+8`
- [ ] `docs/release/v1.2.0.md` 패치노트 (revert된 `572e06d` 참고)
- [ ] ROADMAP.md 루틴 ✅ 전환, 최근 완료 항목 추가
- [ ] `docs/features/23-routine.md` 상태 ✅
- [ ] **이 문서(`IAP_WORK_IN_PROGRESS.md`) 삭제**, 내용은
      `docs/features/subscription.md`로 정리해 이관

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
