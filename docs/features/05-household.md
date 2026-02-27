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
- ⬜ 카테고리별 원형 차트
- ⬜ 고정비용 관리 화면 (별도 화면)

## 데이터 모델
- ✅ 지출 모델 (ExpenseModel) + CreateExpenseDto, UpdateExpenseDto
- ✅ 예산 모델 (BudgetModel) + SetBudgetDto
- ✅ 통계 모델 (MonthlyStatisticsModel, YearlyStatisticsModel, CategoryStatModel)
- ✅ ExpenseCategory enum (식비/교통비/여가비/생활비/의료비/교육비/의류비/기타)
- ✅ PaymentMethod enum (현금/카드/이체/기타)

## 기능 구현
- ✅ 일일 지출 내역 입력
- ✅ 카테고리별 분류 (8종)
- ✅ 고정비용 등록 (isRecurring 플래그)
- ✅ 카테고리별 지출 통계
- ✅ 월별/연별 비교 분석
- ✅ 예산 대비 지출 비율 표시 (LinearProgressIndicator)
- ⬜ 카테고리 커스텀 추가/수정/삭제
- ⬜ 예산 초과 알림

## API 연동
- ✅ 지출 목록 조회 (`GET /household/expenses`)
- ✅ 지출 추가 (`POST /household/expenses`)
- ✅ 지출 수정 (`PATCH /household/expenses/:id`)
- ✅ 지출 삭제 (`DELETE /household/expenses/:id`)
- ✅ 월간 통계 조회 (`GET /household/statistics`)
- ✅ 연간 통계 조회 (`GET /household/statistics/yearly`)
- ✅ 예산 조회 (`GET /household/budgets`)
- ✅ 예산 설정 (`POST /household/budgets`)
- ⬜ 고정비용 다음 달 복사 (`POST /household/expenses/recurring/copy`)
- ⬜ 영수증 업로드

## 상태 관리
- ✅ HouseholdExpenses (지출 목록, 월/그룹 필터, 로컬 CRUD)
- ✅ HouseholdMonthlyStatistics Provider
- ✅ HouseholdYearlyStatistics Provider
- ✅ HouseholdBudgets Provider
- ✅ HouseholdManagement Notifier (생성/수정/삭제)
- ✅ householdSelectedGroupIdProvider
- ✅ householdSelectedMonthProvider

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
- `lib/features/main/household/presentation/widgets/expense_list_item.dart`

## 라우트
- `/household` → HouseholdScreen (메인)
- `/household/add` → ExpenseFormScreen (추가, extra: `{'groupId': String}`)
- `/household/detail` → ExpenseFormScreen (수정, extra: ExpenseModel 또는 `{'expense': ExpenseModel}`)
- `/household/statistics` → HouseholdStatisticsScreen

## 노트
- 고정비용 자동 반영은 백엔드 `POST /household/expenses/recurring/copy` API 활용 예정
- 영수증 업로드는 Presigned URL 방식 (`GET /household/expenses/:id/receipts/upload-url`)
