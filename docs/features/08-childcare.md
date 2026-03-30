# 8. 육아 포인트 메뉴 ✅

## 상태
✅ 완료

---

## UI 구현
- ✅ 육아포인트 메인 화면 (더보기 탭에서 접근)
- ✅ 포인트 탭/보상 탭/규칙 탭/히스토리 탭
- ✅ 자녀별 포인트 카드 (AccountSummaryCard)
- ✅ 포인트 지급/차감 폼 (TransactionFormScreen)
- ✅ 보상 항목 관리 화면 (인라인 다이얼로그)
- ✅ 규칙 관리 화면 (_RuleSection 타입별 섹션, 접기/펼치기, 드래그 순서 변경)
- ✅ 히스토리 화면 (월별/연도별 토글, 잔액 라인 차트, 도넛 차트, 연간 막대 차트)
- ✅ 적금 플랜 화면 (_SavingsPlanSection - 포인트 탭 내 인라인)
- ✅ 용돈 플랜 화면 (child_allowance_plan_screen.dart)
- ⬜ 계정 생성 화면 개선 (자녀 ID 조회 연동)

## 데이터 모델
- ✅ 포인트 계정 모델 (ChildcareAccount)
- ✅ 포인트 거래 모델 (ChildcareTransaction) + ChildcareTransactionType
- ✅ 보상 항목 모델 (ChildcareShopItem)
- ✅ 규칙 모델 (ChildcareRule)
- ✅ 적금 플랜 모델 (ChildcareSavingsPlan + SavingsInterestType + SavingsPlanStatus)
- ✅ 거래 결과 래퍼 (TransactionResult - transactions + closingBalance)

## 기능 구현
- ✅ 포인트 지급/차감 (EARN, SPEND, PENALTY, MONTHLY_ALLOWANCE)
- ✅ 포인트 적립/사용 항목 등록/편집/삭제/순서 변경
- ✅ 포인트 규칙 등록/편집/삭제/순서 변경 (타입별 섹션)
- ✅ 규칙 위반 시 포인트 차감 (규칙 탭에서 직접 적용)
- ✅ 포인트 적립/사용 내역 조회 (월별 / 연도별)
- ✅ 히스토리 시각화 (잔액 추이 라인 차트, 유형별 도넛 차트, 월별 수입/지출 막대 차트)
- ✅ 적금 플랜 생성 (단리/복리 선택, 국고채 3년물 금리 참고)
- ✅ 적금 플랜 중도 해지
- ✅ 이자 미리보기 (로컬 계산 - 단리: Σ monthly×(months-i+1)/12×rate, 복리: Σ monthly×(1+r/12)^(months-i+1))
- ✅ 용돈 플랜 설정 (협상일 X버튼 suffixIcon 방식)
- ⬜ 매달 정해진 금액 포인트 자동 지급 (백엔드 스케줄러)
- ⬜ 적금 이자 계산 및 지급 (백엔드 스케줄러)

## API 연동
- ✅ 육아 계정 생성 API (`POST /childcare/accounts`)
- ✅ 육아 계정 목록 조회 API (`GET /childcare/accounts?groupId=`)
- ✅ 포인트 거래 추가 API (`POST /childcare/accounts/:id/transactions`)
- ✅ 거래 내역 조회 API (`GET /childcare/accounts/:id/transactions?month=&year=`) — closingBalance 포함
- ✅ 보상 항목 CRUD API
- ✅ 규칙 CRUD API
- ✅ 적금 플랜 생성 API (`POST /childcare/accounts/:id/savings`)
- ✅ 적금 플랜 조회 API (`GET /childcare/accounts/:id/savings`)
- ✅ 적금 플랜 해지 API (`DELETE /childcare/accounts/:id/savings`)
- ✅ 국고채 3년물 금리 조회 API (`GET /childcare/accounts/:id/savings/kr3y-rate`)

## 상태 관리
- ✅ childcareSelectedGroupIdProvider (StateProvider)
- ✅ childcareSelectedChildIdProvider (StateProvider)
- ✅ childcareSelectedMonthProvider (StateProvider)
- ✅ childcareSelectedYearProvider (StateProvider)
- ✅ childcareHistoryViewModeProvider (StateProvider - monthly/yearly)
- ✅ ChildcareAccounts Provider (@riverpod)
- ✅ ChildcareTransactions Provider (@riverpod) — TransactionResult 반환
- ✅ ChildcareShopItems Provider (@riverpod)
- ✅ ChildcareRules Provider (@riverpod)
- ✅ childcareSavingsPlanProvider (FutureProvider.family<ChildcareSavingsPlan?, String>)
- ✅ ChildcareManagementNotifier (StateNotifier)

---

## 관련 파일
- 모델: `lib/features/main/child_points/data/models/childcare_model.dart`
- 레포지터리+DTO: `lib/features/main/child_points/data/repositories/childcare_repository.dart`
- 프로바이더: `lib/features/main/child_points/providers/childcare_provider.dart`
- 메인 화면: `lib/features/main/child_points/presentation/screens/child_points_screen.dart`
- 포인트 탭: `lib/features/main/child_points/presentation/screens/points_tab.dart`
- 히스토리 탭: `lib/features/main/child_points/presentation/screens/history_tab.dart`
- 규칙 탭: `lib/features/main/child_points/presentation/screens/rules_tab.dart`
- 상점 탭: `lib/features/main/child_points/presentation/screens/shop_tab.dart`
- 용돈 플랜: `lib/features/main/child_points/presentation/screens/child_allowance_plan_screen.dart`
- 위젯: `lib/features/main/child_points/presentation/widgets/`

## 노트
- 포인트 자동 지급 및 적금 이자 지급은 백엔드 스케줄러에서 처리
- 자녀 계정 생성 시 자녀 userId를 직접 입력하는 방식 → 추후 멤버 목록에서 선택 방식으로 개선 가능
- 이자 미리보기는 로컬 계산 (API 호출 없음), 백엔드 계산식과 동일하게 맞춤
- 국고채 3년물 금리는 기본 이자율 참고용 helperText로 표시
