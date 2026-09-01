# 5. 가계 관리 메뉴 ✅

## 상태
✅ 완료 (영수증 첨부 제외)

---

## UI 구현
- ✅ 가계관리 메인 화면 (main route에서 접근: `/household`)
- ✅ 그룹 선택 + 월 이동 바
- ✅ 월간 지출 요약 뷰 (총 지출 / 총 예산)
- ✅ 지출 상세 목록 (카테고리 아이콘, 금액, 날짜)
- ✅ 지출 추가/수정 폼 (금액, 카테고리, 결제수단, 날짜, 내용, 고정지출)
- ✅ 통계 화면 (월간: 카테고리별 + 예산 비율 / 연간: 월별 막대 차트)
- ✅ 고정비용 관리 화면 (별도 화면, `/household/recurring`) + 통계 카드(월 합계, 항목 수, 카테고리별 분포)
- ✅ 카테고리별 원형 차트
- ✅ 소비처 관리 화면 (`/household/merchants`) — 목록/추가/수정/삭제
- ✅ 지출 폼에서 소비처 선택/등록
- ✅ 지출 상세 화면 (ExpenseDetailScreen) — 환불 연결 내역 표시
- ✅ 고정 지출 상세 화면 (RecurringExpenseDetailScreen)
- ✅ 고정 지출 추가/수정 폼 (RecurringExpenseFormScreen) — 가변 금액(isVariable) 지원
- ✅ 카테고리별 지출 목록 화면 (HouseholdCategoryExpensesScreen) — 통계에서 진입
- ✅ 가계부 설정 화면 (HouseholdSettingsScreen) — 예산 설정, 카테고리 관리, 결제 알림 자동 등록
- ✅ 목록/달력 보기 전환 (HouseholdViewMode)
- ✅ 환불 제외 · 이월 제외 필터 (보기 방식만 변경, 데이터는 유지)
- ✅ 예산 설정 바텀시트 (BudgetSettingSheet)
- ✅ 첫 진입 코치마크 (_household_onboarding)

## 데이터 모델
- ✅ 지출 모델 (ExpenseModel) + CreateExpenseDto, UpdateExpenseDto — `merchant` 객체 · `merchantId` 반영
- ✅ 고정 지출 모델 (RecurringExpenseModel) — 가변 금액(isVariable), 결제일(dayOfMonth)
- ✅ 자동 등록 설정 모델 (HouseholdAutoSettingsModel) — pushAutoRegisterEnabled, defaultGroupId
- ✅ 예산 모델 (BudgetModel) + SetBudgetDto
- ✅ 통계 모델 (MonthlyStatisticsModel, YearlyStatisticsModel, CategoryStatModel)
- ✅ ExpenseCategory enum (식비/교통비/여가비/생활비/의료비/교육비/용돈/경조사/자산이동/육아/통신/기타)
- ✅ PaymentMethod enum (현금/카드/이체)
- ✅ MerchantModel (id, groupId, userId, name, createdAt, updatedAt)

## 기능 구현
- ✅ 일일 지출 내역 입력
- ✅ 카테고리별 분류
- ✅ 고정비용 등록 (isRecurring 플래그)
- ✅ 카테고리별 지출 통계
- ✅ 월별/연별 비교 분석
- ✅ 예산 대비 지출 비율 표시 (LinearProgressIndicator)
- ✅ 소비처 CRUD (등록/수정/삭제/목록)
- ✅ 지출 등록·수정 시 소비처 연결 (merchantId)
- ✅ 소비처별 지출 필터 (merchantId query param)
- ✅ 카테고리 커스텀 추가/수정/삭제
- ✅ 예산 초과 알림
- ✅ 환불 처리 — 원본 지출에 연결(refundedExpenseId), 합산에서 제외 가능
- ✅ 잔금 이월 — 월말 ASSET_TRANSFER 지출 + 익월 1일 INCOME 입금 자동 생성
- ✅ 결제 알림 자동 등록 (Android 전용) — 카드사·은행 푸시를 파싱해 지출 자동 입력
  - 금액·소비처·카테고리 추론, 중복 알림 제거(금액+날짜 키, 시간 창 내 재입력 무시)
  - 삼성페이처럼 페이 앱 알림과 카드사 알림이 동시에 오는 경우 대응

## API 연동
- ✅ 지출 목록 조회 (`GET /household/expenses`) — 월·그룹·소비처(merchantId) 필터
- ✅ 고정지출 목록 조회 (`GET /household/expenses/recurring`)
- ✅ 지출 추가 (`POST /household/expenses`)
- ✅ 지출 수정 (`PATCH /household/expenses/:id`)
- ✅ 지출 삭제 (`DELETE /household/expenses/:id`)
- ✅ 월간 통계 조회 (`GET /household/statistics`)
- ✅ 연간 통계 조회 (`GET /household/statistics/yearly`)
- ✅ 예산 조회 (`GET /household/budgets`)
  - 저장은 단건이 아니라 **일괄(`/bulk`)** 로만 합니다
- ✅ 예산 일괄 설정 (`POST /household/budgets/bulk`)
- ✅ 예산 템플릿 조회 (`GET /household/budget-templates`)
- ✅ 예산 템플릿 일괄 설정 (`POST /household/budget-templates/bulk`)
- ✅ 예산 템플릿 삭제 (`DELETE /household/budget-templates/:category`)
- ✅ 전체 예산 조회 (`GET /household/group-budgets`)
- ✅ 전체 예산 설정 (`POST /household/group-budgets/bulk`)
- ✅ 전체 예산 템플릿 조회 (`GET /household/group-budget-templates`)
- ✅ 전체 예산 템플릿 설정 (`POST /household/group-budget-templates`)
- ✅ 전체 예산 템플릿 삭제 (`DELETE /household/group-budget-templates`)
- ✅ 소비처 등록 (`POST /household/merchants`)
- ✅ 소비처 목록 조회 (`GET /household/merchants`)
- ✅ 소비처 수정 (`PATCH /household/merchants/:id`)
- ✅ 소비처 삭제 (`DELETE /household/merchants/:id`)
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
- ✅ MerchantsProvider (소비처 목록, 그룹별)
- ✅ householdAutoSettingsProvider (결제 알림 자동 등록 설정)
- ✅ 환불/이월 제외 필터 Provider

---

## 관련 파일

### 화면
- `presentation/screens/household_screen.dart` — 메인 (목록/달력)
- `presentation/screens/expense_form_screen.dart` — 지출·수입 등록/수정
- `presentation/screens/expense_detail_screen.dart` — 지출 상세
- `presentation/screens/household_statistics_screen.dart` — 통계
- `presentation/screens/household_category_expenses_screen.dart` — 카테고리별 지출
- `presentation/screens/recurring_expenses_screen.dart` — 고정 내역 목록
- `presentation/screens/recurring_expense_form_screen.dart` / `recurring_expense_detail_screen.dart`
- `presentation/screens/merchants_screen.dart` — 소비처 관리
- `presentation/screens/household_settings_screen.dart` — 예산·카테고리·자동 등록 설정
- `presentation/widgets/budget_setting_sheet.dart`, `expense_list_item.dart`

### 데이터·상태
- `data/models/` — expense, budget, statistics, merchant, recurring_expense, household_auto_settings
- `data/repositories/household_repository.dart`
- `data/services/push_expense_listener_service.dart` — 결제 알림 파싱 (Android)
- `providers/` — household, merchant, household_auto_settings

## 라우트
- `/household` → HouseholdScreen (메인)
- `/household/add` → ExpenseFormScreen (추가, extra: `{'groupId': String}`)
- `/household/detail` → ExpenseDetailScreen / ExpenseFormScreen (수정)
- `/household/statistics` → HouseholdStatisticsScreen
- `/household/recurring` → RecurringExpensesScreen
- `/household/merchants` → MerchantsScreen (소비처 관리)
- `/household/settings` → HouseholdSettingsScreen (예산·카테고리·자동 등록)

## 노트
- 소비처(Merchant): 지출 등록 시 `merchantId`로 연결, 응답에는 `merchant` 객체로 반환. null 전달 시 연결 해제
- 소비처는 그룹 단위로 관리 (groupId 생략 시 개인)
- 영수증 업로드는 **미구현**입니다. 서버는 Presigned URL 방식을 제공합니다 (`GET /household/expenses/:id/receipts/upload-url` → PUT 업로드 → `POST confirm`)
