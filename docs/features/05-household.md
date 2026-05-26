# 5. 가계 관리 메뉴

## 상태
🟨 진행 중

---

## UI 구현
- ✅ 가계관리 메인 화면 (main route에서 접근: `/household`)
- ✅ 그룹 선택 + 월 이동 바
- ✅ 월간 지출 요약 뷰 (총 지출 / 총 예산)
- ✅ 지출 상세 목록 (카테고리 아이콘, 금액, 날짜)
- ✅ 지출 추가/수정 폼 (금액, 카테고리, 결제수단, 날짜, 내용, 고정지출)
- ✅ 통계 화면 (월간: 카테고리별 + 예산 비율 / 연간: 월별 막대 차트)
- ✅ 고정비용 관리 화면 (별도 화면, `/household/recurring`) + 통계 카드(월 합계, 항목 수, 카테고리별 분포)
- ⬜ 카테고리별 원형 차트
- ⬜ 소비처 관리 화면 (`/household/merchants`) — 목록/추가/수정/삭제
- ⬜ 지출 폼에서 소비처 선택/등록

## 데이터 모델
- ✅ 지출 모델 (ExpenseModel) + CreateExpenseDto, UpdateExpenseDto
  - `merchant` 필드 미반영 (MerchantModel 추가 필요)
  - `merchantId` 요청 파라미터 미반영
- ✅ 예산 모델 (BudgetModel) + SetBudgetDto
- ✅ 통계 모델 (MonthlyStatisticsModel, YearlyStatisticsModel, CategoryStatModel)
- ✅ ExpenseCategory enum (식비/교통비/여가비/생활비/의료비/교육비/용돈/경조사/자산이동/육아/통신/기타)
- ✅ PaymentMethod enum (현금/카드/이체)
- ⬜ MerchantModel (id, groupId, userId, name, createdAt, updatedAt)

## 기능 구현
- ✅ 일일 지출 내역 입력
- ✅ 카테고리별 분류
- ✅ 고정비용 등록 (isRecurring 플래그)
- ✅ 카테고리별 지출 통계
- ✅ 월별/연별 비교 분석
- ✅ 예산 대비 지출 비율 표시 (LinearProgressIndicator)
- ⬜ 소비처 CRUD (등록/수정/삭제/목록)
- ⬜ 지출 등록·수정 시 소비처 연결 (merchantId)
- ⬜ 소비처별 지출 필터 (merchantId query param)
- ⬜ 카테고리 커스텀 추가/수정/삭제
- ⬜ 예산 초과 알림

## API 연동
- ✅ 지출 목록 조회 (`GET /household/expenses`) — merchantId 필터 파라미터 미반영
- ✅ 고정지출 목록 조회 (`GET /household/expenses/recurring`)
- ✅ 지출 추가 (`POST /household/expenses`) — merchantId 미반영
- ✅ 지출 수정 (`PATCH /household/expenses/:id`) — merchantId 미반영
- ✅ 지출 삭제 (`DELETE /household/expenses/:id`)
- ✅ 월간 통계 조회 (`GET /household/statistics`)
- ✅ 연간 통계 조회 (`GET /household/statistics/yearly`)
- ✅ 예산 조회 (`GET /household/budgets`)
- ✅ 예산 일괄 설정 (`POST /household/budgets/bulk`)
- ✅ 예산 템플릿 조회 (`GET /household/budget-templates`)
- ✅ 예산 템플릿 일괄 설정 (`POST /household/budget-templates/bulk`)
- ✅ 예산 템플릿 삭제 (`DELETE /household/budget-templates/:category`)
- ✅ 전체 예산 조회 (`GET /household/group-budgets`)
- ✅ 전체 예산 설정 (`POST /household/group-budgets`)
- ✅ 전체 예산 템플릿 조회 (`GET /household/group-budget-templates`)
- ✅ 전체 예산 템플릿 설정 (`POST /household/group-budget-templates`)
- ✅ 전체 예산 템플릿 삭제 (`DELETE /household/group-budget-templates`)
- ⬜ 소비처 등록 (`POST /household/merchants`)
- ⬜ 소비처 목록 조회 (`GET /household/merchants`)
- ⬜ 소비처 수정 (`PATCH /household/merchants/:id`)
- ⬜ 소비처 삭제 (`DELETE /household/merchants/:id`)
- ⬜ 영수증 업로드 URL 발급 (`GET /household/expenses/:id/receipts/upload-url`)
- ⬜ 영수증 등록 (`POST /household/expenses/:id/receipts/confirm`)
- ⬜ 영수증 삭제 (`DELETE /household/expenses/:id/receipts/:receiptId`)

## 상태 관리
- ✅ HouseholdExpenses (지출 목록, 월/그룹 필터, 로컬 CRUD)
- ✅ HouseholdRecurringExpenses (고정지출 목록, refresh/add/remove)
- ✅ HouseholdMonthlyStatistics Provider
- ✅ HouseholdYearlyStatistics Provider
- ✅ HouseholdBudgets Provider
- ✅ HouseholdManagement Notifier (생성/수정/삭제)
- ✅ householdSelectedGroupIdProvider
- ✅ householdSelectedMonthProvider
- ⬜ MerchantsProvider (소비처 목록, 그룹별)

---

## 관련 파일
- `lib/features/main/household/data/models/expense_model.dart`
- `lib/features/main/household/data/models/budget_model.dart`
- `lib/features/main/household/data/models/statistics_model.dart`
- `lib/features/main/household/data/repositories/household_repository.dart`
- `lib/features/main/household/providers/household_provider.dart`
- `lib/features/main/household/presentation/screens/household_screen.dart`
- `lib/features/main/household/presentation/screens/expense_form_screen.dart`
- `lib/features/main/household/presentation/screens/household_statistics_screen.dart`
- `lib/features/main/household/presentation/screens/recurring_expenses_screen.dart`
- `lib/features/main/household/presentation/widgets/expense_list_item.dart`

## 라우트
- `/household` → HouseholdScreen (메인)
- `/household/add` → ExpenseFormScreen (추가, extra: `{'groupId': String}`)
- `/household/detail` → ExpenseFormScreen (수정, extra: ExpenseModel 또는 `{'expense': ExpenseModel}`)
- `/household/statistics` → HouseholdStatisticsScreen
- `/household/recurring` → RecurringExpensesScreen
- ⬜ `/household/merchants` → MerchantsScreen (소비처 관리)

## 노트
- 소비처(Merchant): 지출 등록 시 `merchantId`로 연결, 응답에는 `merchant` 객체로 반환. null 전달 시 연결 해제
- 소비처는 그룹 단위로 관리 (groupId 생략 시 개인)
- 영수증 업로드는 Presigned URL 방식 (`GET /household/expenses/:id/receipts/upload-url` → PUT 업로드 → `POST confirm`)
