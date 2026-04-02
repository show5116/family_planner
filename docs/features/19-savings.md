# 19. 적립금 관리 (Savings Management) ✅

## 상태
✅ 완료

---

## UI 구현
- ✅ 적립 목표 목록 화면 (SavingsListScreen) - 그룹 선택, 목표 카드, 달성률 프로그레스 바
- ✅ 적립 목표 상세 화면 (SavingsDetailScreen) - 입출금, 최근 내역, 일시중지/재개
- ✅ 적립 목표 생성/수정 폼 (SavingsFormScreen) - 자동 적립 토글, 자산 연동 토글
- ✅ 전체 내역 화면 (SavingsTransactionsScreen) - 타입/월 필터, 무한 스크롤
- ✅ 자산 탭 연동 - includeInAssets=true 목표를 자산 대시보드 계좌 목록 하단에 표시

## 데이터 모델
- ✅ SavingsGoalModel - `lib/features/main/savings/data/models/savings_model.dart`
- ✅ SavingsTransactionModel
- ✅ SavingsGoalStatus (active, paused)
- ✅ SavingsType (deposit, withdraw, autoDeposit)
- ✅ SavingsTransactionListResult (페이지네이션)

## 기능 구현
- ✅ 목표 목록/상세 조회
- ✅ 목표 생성/수정/삭제
- ✅ 수동 입금 / 출금
- ✅ 자동 적립 일시 중지 / 재개
- ✅ 거래 내역 조회 (타입/월 필터, 페이지네이션)
- ✅ includeInAssets 설정 → 자산 통계 연동 (savingsTotal, savingsGoals)
- ✅ 자산 대시보드에서 연동 저금통 목록 표시 및 상세 이동

## API 연동
- ✅ `GET /savings` - 목표 목록
- ✅ `GET /savings/:id` - 목표 상세 (최근 내역 10건 포함)
- ✅ `POST /savings` - 목표 생성
- ✅ `PATCH /savings/:id` - 목표 수정
- ✅ `DELETE /savings/:id` - 목표 삭제
- ✅ `POST /savings/:id/deposit` - 수동 입금
- ✅ `POST /savings/:id/withdraw` - 출금
- ✅ `POST /savings/:id/pause` - 자동 적립 일시 중지
- ✅ `POST /savings/:id/resume` - 자동 적립 재개
- ✅ `GET /savings/:id/transactions` - 거래 내역 (페이지네이션)

## 구현 위치
```
lib/features/main/savings/
├── data/
│   ├── models/savings_model.dart
│   └── repositories/savings_repository.dart
├── providers/savings_provider.dart
└── presentation/screens/
    ├── savings_list_screen.dart
    ├── savings_detail_screen.dart
    ├── savings_form_screen.dart
    └── savings_transactions_screen.dart
```
