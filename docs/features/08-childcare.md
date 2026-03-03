# 8. 육아 포인트 메뉴

## 상태
🟨 진행 중

---

## UI 구현
- ✅ 육아포인트 메인 화면 (더보기 탭에서 접근)
- ✅ 포인트 탭/보상 탭/규칙 탭/히스토리 탭
- ✅ 자녀별 포인트 카드 (AccountSummaryCard)
- ✅ 포인트 지급/차감 폼 (TransactionFormScreen)
- ✅ 보상 항목 관리 화면 (인라인 다이얼로그)
- ✅ 규칙 관리 화면 (인라인 다이얼로그)
- ✅ 히스토리 화면 (월별 거래 내역)
- ⬜ 계정 생성 화면 개선 (자녀 ID 조회 연동)

## 데이터 모델
- ✅ 포인트 계정 모델 (ChildcareAccount)
- ✅ 포인트 거래 모델 (ChildcareTransaction) + ChildcareTransactionType
- ✅ 보상 항목 모델 (ChildcareReward)
- ✅ 규칙 모델 (ChildcareRule)

## 기능 구현
- ✅ 포인트 지급/차감 (EARN, SPEND, PENALTY, MONTHLY_ALLOWANCE)
- ✅ 포인트 적립/사용 항목 등록/편집
- ✅ 포인트 규칙 등록/편집
- ✅ 규칙 위반 시 포인트 차감 (규칙 탭에서 직접 적용)
- ✅ 포인트 적립/사용 내역 조회
- ✅ 날짜별(월) 필터링
- ✅ 적금 입금 기능
- ✅ 적금 출금 기능 (부모만)
- ⬜ 매달 정해진 금액 포인트 자동 지급 (백엔드 스케줄러)
- ⬜ 적금 이자 계산 및 지급 (백엔드 스케줄러)

## API 연동
- ✅ 육아 계정 생성 API (`POST /childcare/accounts`)
- ✅ 육아 계정 목록 조회 API (`GET /childcare/accounts?groupId=`)
- ✅ 육아 계정 상세 조회 API (`GET /childcare/accounts/:id`)
- ✅ 포인트 거래 추가 API (`POST /childcare/accounts/:id/transactions`)
- ✅ 거래 내역 조회 API (`GET /childcare/accounts/:id/transactions`)
- ✅ 보상 항목 CRUD API
- ✅ 규칙 CRUD API
- ✅ 적금 입금 API (`POST /childcare/accounts/:id/savings/deposit`)
- ✅ 적금 출금 API (`POST /childcare/accounts/:id/savings/withdraw`)

## 상태 관리
- ✅ childcareSelectedGroupIdProvider (StateProvider)
- ✅ childcareSelectedAccountIdProvider (StateProvider)
- ✅ childcareSelectedMonthProvider (StateProvider)
- ✅ ChildcareAccounts Provider (@riverpod)
- ✅ childcareAccountDetailProvider (@riverpod)
- ✅ ChildcareTransactions Provider (@riverpod)
- ✅ ChildcareRewards Provider (@riverpod)
- ✅ ChildcareRules Provider (@riverpod)
- ✅ ChildcareManagementNotifier (StateNotifier)

---

## 관련 파일
- 모델: `lib/features/main/child_points/data/models/childcare_model.dart`
- 레포지터리+DTO: `lib/features/main/child_points/data/repositories/childcare_repository.dart`
- 프로바이더: `lib/features/main/child_points/providers/childcare_provider.dart`
- 메인 화면: `lib/features/main/child_points/presentation/screens/child_points_screen.dart`
- 계정 생성: `lib/features/main/child_points/presentation/screens/childcare_account_form_screen.dart`
- 거래 폼: `lib/features/main/child_points/presentation/screens/transaction_form_screen.dart`
- 위젯: `lib/features/main/child_points/presentation/widgets/`

## 노트
- 포인트 적금 이자 계산 로직은 백엔드 스케줄러에서 처리 (월별 자동 지급도 동일)
- 자녀 계정 생성 시 자녀 userId를 직접 입력하는 방식 → 추후 멤버 목록에서 선택 방식으로 개선 가능
