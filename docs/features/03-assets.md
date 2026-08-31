# 3. 자산관리 메뉴 ✅

## 상태
✅ 완료 (구성원별 자산 필터 UI 제외)

---

## UI 구현

### 메인·통계
- ✅ 자산 탭 (AssetsTab) / 자산 메인 화면 (AssetScreen) — 계좌 목록 + 연동 저금통 + 요약 카드
- ✅ 자산 통계 화면 (AssetStatisticsScreen) — 유형별 현황 + 저금통 합계
- ✅ 요약 카드 (AssetSummaryCard, AssetStatSummaryCard, AssetTypeStatCard)
- ✅ 계좌 필터 시트 (AssetAccountFilterSheet) — 볼 계좌 선택
- ✅ 첫 진입 코치마크 (_asset_onboarding)

### 차트 (fl_chart)
- ✅ 자산 추이 차트 (AssetTrendChart)
- ✅ 자산 비교 차트 (AssetComparisonChart)
- ✅ 자산 구성 원형 차트 (AssetPieChart)
- ✅ 보유 종목 기록 비교 (HoldingRecordsComparison)

### 계좌
- ✅ 계좌 추가/수정 폼 (AccountFormScreen)
- ✅ 계좌 상세 화면 (AccountDetailScreen)
- ✅ 계좌 정보 카드 (AccountInfoCard), 목록 아이템 (AccountListItem)
- ✅ 계좌 순서 변경 (드래그)

### 자산 기록·출금
- ✅ 기록 추가 바텀시트 (AddAssetRecordSheet)
- ✅ 기록 목록 아이템 (AssetRecordListItem)
- ✅ 출금 추가 바텀시트 (AddWithdrawalSheet)
- ✅ 출금 목록 아이템 (WithdrawalListItem)

### 보유 종목 (Holding)
- ✅ 보유 종목 섹션 (HoldingsSection) — 계좌별 종목 구성 비율
- ✅ 보유 종목 등록/수정 시트 (HoldingFormSheet)
- ✅ 보유 종목 기록 섹션 (HoldingRecordsSection)
- ✅ 보유 종목 기록 등록/수정 시트 (HoldingRecordFormSheet)
- ✅ 보유 종목 순서 변경

### 미구현
- ⬜ 가족 구성원별 자산 뷰 (userId 필터 UI) — Provider(`assetSelectedUserIdProvider`)는 준비됨

---

## 데이터 모델
- ✅ 계좌 모델 (AccountModel)
- ✅ 자산 기록 모델 (AssetRecordModel)
- ✅ 자산 통계 모델 (AssetStatisticsModel)
  - `savingsTotal`: 자산 연동 저금통 합계
  - `savingsGoals`: 연동 저금통 목록 (SavingsGoalSummaryModel)
- ✅ 자산 추이 모델 (AssetTrendModel)
- ✅ 보유 종목 모델 (HoldingModel) — name, ticker, ratio(%), sortOrder
- ✅ 보유 종목 기록 모델 (HoldingRecordModel)
- ✅ 출금 모델 (WithdrawalModel) + CreateWithdrawalDto — withdrawalDate, amount, type, note

---

## 기능 구현
- ✅ 계좌 추가/수정/삭제/순서 변경
- ✅ 자산 기록 추가·삭제 (잔액/원금/수익금/날짜/메모)
- ✅ 출금 등록·삭제 (유형별 WithdrawalType)
- ✅ 계좌별 최신 잔액 및 수익률 표시
- ✅ 전체 원금/수익금/수익률 통계 요약
- ✅ 유형별 자산 현황
- ✅ 자산 추이 차트 — 전체/계좌별
- ✅ 보유 종목 관리 — 계좌별 종목 등록, 비율(ratio) 관리, 순서 변경
- ✅ 보유 종목 기록 — 시점별 기록 등록·수정·삭제, 기록 간 비교
- ✅ 그룹 내 보유 종목명 자동완성 (그룹에서 쓰인 종목명 조회)
- ✅ 금 시세 조회 (실시간 현재가)
- ✅ 저금통 연동 (includeInAssets=true 목표를 계좌 목록 하단에 표시, 탭으로 이동)
- ⬜ 가족 구성원별 자산 현황 필터

---

## API 연동

### 계좌
- ✅ 계좌 목록 조회 `GET /assets/accounts`
- ✅ 계좌 상세 조회 `GET /assets/accounts/:id`
- ✅ 계좌 생성 `POST /assets/accounts`
- ✅ 계좌 수정 `PATCH /assets/accounts/:id`
- ✅ 계좌 순서 변경 `PATCH /assets/accounts/reorder`
- ✅ 계좌 삭제 `DELETE /assets/accounts/:id`

### 자산 기록·출금
- ✅ 기록 목록 `GET /assets/accounts/:id/records`
- ✅ 기록 추가 `POST /assets/accounts/:id/records`
- ✅ 기록 삭제 `DELETE /assets/accounts/:id/records/:recordId`
- ✅ 출금 목록 `GET /assets/accounts/:id/withdrawals`
- ✅ 출금 추가 `POST /assets/accounts/:id/withdrawals`
- ✅ 출금 삭제 `DELETE /assets/accounts/:id/withdrawals/:withdrawalId`

### 통계·추이
- ✅ 자산 통계 조회 `GET /assets/statistics`
- ✅ 전체 자산 추이 `GET /assets/statistics/trend`
- ✅ 계좌별 자산 추이 `GET /assets/accounts/:id/statistics/trend`

### 보유 종목
- ✅ 종목 목록 `GET /assets/accounts/:id/holdings`
- ✅ 종목 등록 `POST /assets/accounts/:id/holdings`
- ✅ 종목 수정 `PATCH /assets/accounts/:id/holdings/:holdingId`
- ✅ 종목 삭제 `DELETE /assets/accounts/:id/holdings/:holdingId`
- ✅ 종목 순서 변경 `PATCH /assets/accounts/:id/holdings/reorder`
- ✅ 그룹 내 종목명 목록 `GET /assets/groups/:groupId/holding-records/names`
- ✅ 종목 기록 조회·등록 `GET|POST /assets/accounts/:id/holding-records`
- ✅ 종목 기록 수정·삭제 `PATCH|DELETE /assets/accounts/:id/holding-records/:recordId`

### 시세
- ✅ 금 현재가 조회 `GET /assets/gold/current-price`

---

## 상태 관리
- ✅ AssetAccounts Provider (계좌 목록, AutoDisposeAsyncNotifier)
- ✅ AssetRecords Provider (계좌별 기록, Family)
- ✅ AssetStatistics Provider (그룹 통계)
- ✅ AssetTrend Provider (전체/계좌별 추이)
- ✅ Holdings / HoldingRecords Provider
- ✅ Withdrawals Provider
- ✅ AssetManagement Notifier (CRUD 액션)

---

## 구현 위치
```
lib/features/main/assets/
├── data/
│   ├── models/          account, asset_record, asset_statistics, asset_trend,
│   │                    holding, holding_record, withdrawal
│   └── repositories/    asset_repository.dart
├── providers/           asset_provider.dart
├── utils/               asset_utils.dart
└── presentation/
    ├── screens/         assets_tab, asset_screen, account_form_screen,
    │                    account_detail_screen, asset_statistics_screen
    └── widgets/         요약 카드 · 차트 3종 · 계좌/기록/출금 아이템 ·
                         보유 종목 섹션과 폼 시트
```

## API 문서
[docs/api/assets.md](../api/assets.md)

## 패키지
- `fl_chart` — 추이·비교·원형 차트

## 노트
- 가족 구성원별 필터(`assetSelectedUserIdProvider`)는 Provider에 준비되어 있고 UI 연결만 남았습니다.
- 보유 종목의 `ratio`는 계좌 내 비중(%)이며, 종목 기록(HoldingRecord)은 시점별 스냅샷입니다.
- 저금통(19-savings) 중 `includeInAssets=true`인 목표가 자산 화면과 통계에 함께 집계됩니다.
