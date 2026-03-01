# 3. 자산관리 메뉴

## 상태
✅ 완료 (차트 제외)

---

## UI 구현
- ✅ 자산 메인 화면 (AssetScreen) - 계좌 목록 + 요약 카드
- ✅ 계좌 추가/수정 폼 (AccountFormScreen)
- ✅ 계좌 상세 화면 (AccountDetailScreen) + 기록 추가 바텀시트
- ✅ 자산 통계 화면 (AssetStatisticsScreen) - 유형별 현황
- ⬜ 차트 시각화 (fl_chart)
- ⬜ 가족 구성원별 자산 뷰 (userId 필터 UI)

## 데이터 모델
- ✅ 계좌 모델 (AccountModel) - `lib/features/main/assets/data/models/account_model.dart`
- ✅ 자산 기록 모델 (AssetRecordModel) - `lib/features/main/assets/data/models/asset_record_model.dart`
- ✅ 자산 통계 모델 (AssetStatisticsModel) - `lib/features/main/assets/data/models/asset_statistics_model.dart`

## 기능 구현
- ✅ 계좌 추가/수정/삭제
- ✅ 자산 기록 추가 (잔액/원금/수익금/날짜/메모)
- ✅ 계좌별 최신 잔액 및 수익률 표시
- ✅ 전체 원금/수익금/수익률 통계 요약
- ✅ 유형별 자산 현황
- ⬜ 자산 내역 히스토리 차트 (fl_chart)
- ⬜ 가족 구성원별 자산 현황 필터

## API 연동
- ✅ 계좌 목록 조회 `GET /assets/accounts`
- ✅ 계좌 생성 `POST /assets/accounts`
- ✅ 계좌 수정 `PATCH /assets/accounts/:id`
- ✅ 계좌 삭제 `DELETE /assets/accounts/:id`
- ✅ 자산 기록 목록 `GET /assets/accounts/:id/records`
- ✅ 자산 기록 추가 `POST /assets/accounts/:id/records`
- ✅ 자산 통계 조회 `GET /assets/statistics`

## 상태 관리
- ✅ AssetAccounts Provider (계좌 목록, AutoDisposeAsyncNotifier)
- ✅ AssetRecords Provider (계좌별 기록, Family)
- ✅ AssetStatistics Provider (그룹 통계)
- ✅ AssetManagement Notifier (CRUD 액션)

---

## 구현 위치
```
lib/features/main/assets/
├── data/
│   ├── models/
│   │   ├── account_model.dart
│   │   ├── asset_record_model.dart
│   │   └── asset_statistics_model.dart
│   └── repositories/
│       └── asset_repository.dart
├── providers/
│   ├── asset_provider.dart
│   └── asset_provider.g.dart
└── presentation/
    └── screens/
        ├── asset_screen.dart
        ├── account_form_screen.dart
        ├── account_detail_screen.dart
        └── asset_statistics_screen.dart
```

## 노트
- fl_chart 패키지를 사용한 차트 시각화는 추후 구현
- 가족 구성원별 필터(`assetSelectedUserIdProvider`)는 Provider에 준비되어 있음, UI 연결 필요
