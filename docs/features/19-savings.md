# 19. 적립금 관리 (Savings Management) ⬜

## 상태
⬜ 시작 안함

---

## 핵심 개념
그룹 단위로 금액을 적립하여 특정 목표(여행, 가전 구매 등)나 비상금을 위해 모아가는 시스템입니다.
일반 예산과 달리 잔액이 이월되며, 이벤트 발생 시 적립된 금액을 한 번에 사용합니다.
하나의 그룹에서 여러 적립 목표를 동시에 운영할 수 있습니다.

### 주요 특징
- **다중 목표**: 그룹당 여러 적립 목표 동시 운영 (여름 여행, 비상금, 가전 구매 등)
- **무기한 적립**: `targetAmount` 미설정 시 비상금 용도로 무기한 적립
- **자동 적립**: `autoDeposit: true` + `monthlyAmount` 설정 시 매월 1일 자동 적립
- **목표 달성 알림**: `currentAmount >= targetAmount` 도달 시 자동 COMPLETED 전환 + FCM 알림
- **잔액 이월**: 일반 예산과 달리 잔액이 계속 누적됨

---

## UI 구현

### 적립 목표 목록 화면
- ⬜ 그룹 선택 드롭다운
- ⬜ 적립 목표 카드 목록 (이름, 현재 금액, 목표 금액, 달성률 프로그레스 바)
- ⬜ 상태 필터 칩 (전체 / 적립 중 / 일시 중지 / 완료)
- ⬜ 적립 목표 생성 버튼 (FAB)
- ⬜ Pull-to-refresh
- ⬜ 빈 상태 화면

### 적립 목표 상세 화면
- ⬜ 목표 정보 헤더 (이름, 설명, 달성률 원형 차트 또는 프로그레스 바)
- ⬜ 현재 금액 / 목표 금액 표시
- ⬜ 자동 적립 정보 표시 (월 적립금, 상태 뱃지)
- ⬜ 수동 입금 버튼
- ⬜ 출금 버튼
- ⬜ 최근 내역 10건 (상세 화면 내 인라인)
- ⬜ 전체 내역 보기 버튼 → 내역 화면 이동
- ⬜ 수정 / 삭제 버튼 (메뉴)
- ⬜ 목표 완료 / 일시 중지 / 재개 버튼

### 적립 목표 생성/수정 화면
- ⬜ 이름 입력
- ⬜ 설명 입력 (선택)
- ⬜ 목표 금액 입력 (선택, 미입력 시 무기한 적립)
- ⬜ 자동 적립 토글 (`autoDeposit`)
- ⬜ 월 적립금 입력 (autoDeposit=true 시 필수 노출)
- ⬜ 저장 버튼

### 입금 / 출금 다이얼로그
- ⬜ 금액 입력
- ⬜ 메모 입력 (출금 시 필수)
- ⬜ 잔액 부족 시 에러 표시

### 내역 화면
- ⬜ 타입 필터 (전체 / 입금 / 출금 / 자동 적립)
- ⬜ 월 선택 필터
- ⬜ 내역 목록 (타입 아이콘, 금액, 메모, 날짜)
- ⬜ 페이지네이션 (무한 스크롤)

---

## 데이터 모델

### SavingsGoalModel
- ⬜ id (String)
- ⬜ groupId (String)
- ⬜ name (String)
- ⬜ description (String?)
- ⬜ targetAmount (double?) — null 시 무기한 적립
- ⬜ currentAmount (double)
- ⬜ autoDeposit (bool)
- ⬜ monthlyAmount (double?) — autoDeposit=true 시 존재
- ⬜ status (SavingsGoalStatus) — ACTIVE / PAUSED / COMPLETED
- ⬜ achievementRate (double?) — targetAmount 없으면 null, 최대 100
- ⬜ createdAt (DateTime)
- ⬜ updatedAt (DateTime)

### SavingsTransactionModel
- ⬜ id (String)
- ⬜ goalId (String)
- ⬜ type (SavingsType) — DEPOSIT / WITHDRAW / AUTO_DEPOSIT
- ⬜ amount (double)
- ⬜ description (String?)
- ⬜ createdAt (DateTime)

### Enums
- ⬜ SavingsGoalStatus: ACTIVE, PAUSED, COMPLETED
- ⬜ SavingsType: DEPOSIT, WITHDRAW, AUTO_DEPOSIT

---

## 기능 구현

### 적립 목표 관리
- ⬜ 목표 목록 조회 (`GET /savings?groupId=`)
- ⬜ 목표 상세 조회 (`GET /savings/:id`) — 최근 내역 10건 포함
- ⬜ 목표 생성 (`POST /savings`)
- ⬜ 목표 수정 (`PATCH /savings/:id`)
- ⬜ 목표 삭제 (`DELETE /savings/:id`)
- ⬜ 목표 완료 처리 (`POST /savings/:id/complete`)
- ⬜ 자동 적립 일시 중지 (`POST /savings/:id/pause`) — autoDeposit=true 목표만
- ⬜ 자동 적립 재개 (`POST /savings/:id/resume`)

### 입출금
- ⬜ 수동 입금 (`POST /savings/:id/deposit`)
- ⬜ 출금 (`POST /savings/:id/withdraw`) — description 필수, 잔액 부족 시 400
- ⬜ 내역 조회 (`GET /savings/:id/transactions`) — type/month/year 필터, 페이지네이션

---

## 구현 위치 (예정)

- **모델**: `lib/features/main/savings/data/models/savings_model.dart`
- **레포지터리**: `lib/features/main/savings/data/repositories/savings_repository.dart`
- **프로바이더**: `lib/features/main/savings/providers/savings_provider.dart`
- **화면**: `lib/features/main/savings/presentation/screens/`
  - `savings_list_screen.dart` — 목표 목록
  - `savings_detail_screen.dart` — 목표 상세 + 최근 내역
  - `savings_form_screen.dart` — 생성/수정 폼
  - `savings_transactions_screen.dart` — 전체 내역

---

## API 문서
[docs/api/savings.md](../api/savings.md)

---

## 비즈니스 규칙 요약
- `autoDeposit: true` → `monthlyAmount` 필수 (미입력 시 400)
- `autoDeposit: false` 목표에 pause/resume 호출 시 400
- 출금 시 `currentAmount < amount` 이면 400 ("잔액이 부족합니다")
- `status = COMPLETED` 목표는 입출금 불가
- 자동 적립 스케줄러: 매월 1일 00:10, `autoDeposit=true && status=ACTIVE` 대상만
- 목표 달성 시 자동 COMPLETED 전환 + 그룹 멤버 FCM 알림
