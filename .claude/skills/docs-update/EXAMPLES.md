# Docs Update Skill - 상세 예시

## 예시 1: 새 기능 시작 (⬜ → 🟨)

**사용자 요청:**
```
"메모 기능을 시작합니다."
```

### Step 1: 기능 문서 업데이트

**Before** (`docs/features/09-memo.md`):
```markdown
# 09. 메모 ⬜

## 진행 상황: ⬜ 시작 안함 (0%)
```

**After**:
```markdown
# 09. 메모 🟨

## 진행 상황: 🟨 진행 중 (10%)

### 진행 중인 작업
- [ ] 메모 데이터 모델 설계
- [ ] 메모 리스트 화면 구현
- [ ] 메모 작성/수정 화면 구현
```

### Step 2: TODO.md 업데이트

**Before**:
```markdown
| ⬜ | 메모 | [09-memo.md](docs/features/09-memo.md) |
```

**After**:
```markdown
| 🟨 | 메모 | [09-memo.md](docs/features/09-memo.md) |
```

### Step 3: ROADMAP.md Feature Roadmap 업데이트

**Before**:
```markdown
| 메모 | ⬜ 시작 안함 | [09-memo.md](docs/features/09-memo.md) | P2 |
```

**After**:
```markdown
| 메모 | 🟨 진행 중 | [09-memo.md](docs/features/09-memo.md) | P2 |
```

### Step 4: ROADMAP.md Progress Overview 업데이트

**Before**:
```markdown
## 📊 Progress Overview

- **완료**: 3/15 기능 (20%)
- **진행 중**: 4/15 기능 (27%)
- **미시작**: 8/15 기능 (53%)

**마지막 업데이트**: 2025-12-27
```

**After**:
```markdown
## 📊 Progress Overview

- **완료**: 3/15 기능 (20%)
- **진행 중**: 5/15 기능 (33%)
- **미시작**: 7/15 기능 (47%)

**마지막 업데이트**: 2025-12-30
```

---

## 예시 2: 기능 완료 (🟨 → ✅)

**사용자 요청:**
```
"일정관리 기능이 완료되었습니다. 다음 항목들이 구현되었습니다:
- 일정 CRUD 기능
- 캘린더 뷰 및 리스트 뷰
- 반복 일정 설정
- 알림 연동
- 다국어 지원"
```

### Step 1: 기능 문서 업데이트

**Before** (`docs/features/06-schedule.md`):
```markdown
# 06. 일정관리 🟨

## 진행 상황: 🟨 진행 중 (85%)

### 완료된 작업
- [x] 일정 데이터 모델
- [x] 일정 리스트 화면
- [x] 일정 작성/수정 화면
- [x] 캘린더 뷰 구현

### 남은 작업
- [ ] 알림 연동 테스트
- [ ] 다국어 최종 확인
```

**After**:
```markdown
# 06. 일정관리 ✅

## 진행 상황: ✅ 완료 (100%)

### 완료된 기능
- [x] 일정 CRUD 기능
- [x] 캘린더 뷰 및 리스트 뷰
- [x] 반복 일정 설정
- [x] 알림 연동
- [x] 다국어 지원
```

### Step 2: TODO.md 업데이트

**Before**:
```markdown
| 🟨 | 일정관리 | [06-schedule.md](docs/features/06-schedule.md) |
```

**After**:
```markdown
| ✅ | 일정관리 | [06-schedule.md](docs/features/06-schedule.md) |
```

### Step 3: ROADMAP.md Feature Roadmap 업데이트

**Before**:
```markdown
| 일정 관리 | 🟨 진행 중 | [06-schedule.md](docs/features/06-schedule.md) | P1 |
```

**After**:
```markdown
| 일정 관리 | ✅ 완료 | [06-schedule.md](docs/features/06-schedule.md) | P1 |
```

### Step 4: ROADMAP.md 최근 완료 항목 추가

**Before**:
```markdown
## 📈 최근 완료된 기능

### 2025-12-27
- ✅ **알림 시스템 프론트엔드 구현 완료** ([14-notification.md](docs/features/14-notification.md))
  - Firebase Cloud Messaging 통합 완료
  - 로컬 알림 서비스 구현
```

**After**:
```markdown
## 📈 최근 완료된 기능

### 2025-12-30
- ✅ **일정관리 기능 완료** ([06-schedule.md](docs/features/06-schedule.md))
  - 일정 CRUD 기능
  - 캘린더 뷰 및 리스트 뷰
  - 반복 일정 설정
  - 알림 연동
  - 다국어 지원

### 2025-12-27
- ✅ **알림 시스템 프론트엔드 구현 완료** ([14-notification.md](docs/features/14-notification.md))
  - Firebase Cloud Messaging 통합 완료
  - 로컬 알림 서비스 구현
```

### Step 5: ROADMAP.md Progress Overview 업데이트

**Before**:
```markdown
## 📊 Progress Overview

- **완료**: 3/15 기능 (20%)
- **진행 중**: 5/15 기능 (33%)
- **미시작**: 7/15 기능 (47%)

**마지막 업데이트**: 2025-12-30
```

**After**:
```markdown
## 📊 Progress Overview

- **완료**: 4/15 기능 (27%)
- **진행 중**: 4/15 기능 (27%)
- **미시작**: 7/15 기능 (46%)

**마지막 업데이트**: 2025-12-30
```

### Step 6: ROADMAP.md "진행 중인 작업" 섹션 업데이트

**Before**:
```markdown
### 진행 중인 작업
- 🟨 **회원 가입 및 로그인** (~90% 완료)
  - 남은 작업: 애플 로그인, 소셜 로그인 백엔드 완성

- 🟨 **일정관리** (~85% 완료)
  - 남은 작업: 알림 연동, 다국어
```

**After**:
```markdown
### 진행 중인 작업
- 🟨 **회원 가입 및 로그인** (~90% 완료)
  - 남은 작업: 애플 로그인, 소셜 로그인 백엔드 완성
```

---

## 예시 3: 진행률만 업데이트

**사용자 요청:**
```
"다국어 기능이 90%까지 완료되었습니다. 대시보드와 그룹 관리 화면만 남았어요."
```

### 기능 문서 업데이트

**Before** (`docs/features/11-i18n.md`):
```markdown
# 11. 다국어 🟨

## 진행 상황: 🟨 진행 중 (75%)

### 완료된 작업
- [x] intl 패키지 설정
- [x] 인증 화면 다국어
- [x] 설정 화면 다국어

### 남은 작업
- [ ] 대시보드 다국어
- [ ] 그룹 관리 화면 다국어
- [ ] 공지사항 다국어
- [ ] Q&A 다국어
```

**After**:
```markdown
# 11. 다국어 🟨

## 진행 상황: 🟨 진행 중 (90%)

### 완료된 작업
- [x] intl 패키지 설정
- [x] 인증 화면 다국어
- [x] 설정 화면 다국어
- [x] 공지사항 다국어
- [x] Q&A 다국어

### 남은 작업
- [ ] 대시보드 다국어
- [ ] 그룹 관리 화면 다국어
```

---

## 예시 4: 특정 작업 항목 완료

**사용자 요청:**
```
"대시보드 위젯 데이터 연동을 완료했습니다."
```

### 기능 문서 업데이트

**Before** (`docs/features/02-dashboard.md`):
```markdown
## 진행 상황: 🟨 진행 중 (50%)

### 완료된 작업
- [x] 대시보드 레이아웃 설계
- [x] 위젯 시스템 구현

### 진행 중인 작업
- [ ] 위젯 데이터 연동 (50%)
- [ ] 새로고침 기능 (20%)

### 남은 작업
- [ ] 위젯 순서 변경
- [ ] 위젯 추가/제거 설정
```

**After**:
```markdown
## 진행 상황: 🟨 진행 중 (65%)

### 완료된 작업
- [x] 대시보드 레이아웃 설계
- [x] 위젯 시스템 구현
- [x] 위젯 데이터 연동

### 진행 중인 작업
- [ ] 새로고침 기능 (20%)

### 남은 작업
- [ ] 위젯 순서 변경
- [ ] 위젯 추가/제거 설정
```

---

## 예시 5: 기능 보류 (🟨 → ⏸️)

**사용자 요청:**
```
"투자지표 기능은 백엔드 API가 준비될 때까지 보류합니다."
```

### Step 1: 기능 문서 업데이트

**Before** (`docs/features/04-investment.md`):
```markdown
# 04. 투자지표 🟨

## 진행 상황: 🟨 진행 중 (20%)
```

**After**:
```markdown
# 04. 투자지표 ⏸️

## 진행 상황: ⏸️ 보류 (20%)

**보류 사유**: 백엔드 API 개발 대기 중
```

### Step 2: TODO.md 업데이트

**Before**:
```markdown
| 🟨 | 투자지표 | [04-investment.md](docs/features/04-investment.md) |
```

**After**:
```markdown
| ⏸️ | 투자지표 | [04-investment.md](docs/features/04-investment.md) |
```

### Step 3: ROADMAP.md 업데이트

**Before**:
```markdown
| 투자지표 | 🟨 진행 중 | [04-investment.md](docs/features/04-investment.md) | P2 |
```

**After**:
```markdown
| 투자지표 | ⏸️ 보류 | [04-investment.md](docs/features/04-investment.md) | P2 |
```

### Step 4: Progress Overview 재계산

**Before**:
```markdown
- **완료**: 4/15 기능 (27%)
- **진행 중**: 4/15 기능 (27%)
- **미시작**: 7/15 기능 (46%)
```

**After**:
```markdown
- **완료**: 4/15 기능 (27%)
- **진행 중**: 3/15 기능 (20%)
- **보류**: 1/15 기능 (7%)
- **미시작**: 7/15 기능 (46%)
```

---

## 진행률 자동 계산 공식

```
총 기능 수 = TODO.md 테이블 행 수 (헤더 제외)

완료율 = (✅ 개수 / 총 기능 수) × 100
진행 중율 = (🟨 개수 / 총 기능 수) × 100
미시작율 = (⬜ 개수 / 총 기능 수) × 100
보류율 = (⏸️ 개수 / 총 기능 수) × 100
취소율 = (❌ 개수 / 총 기능 수) × 100
```

반올림은 소수점 첫째 자리까지 (예: 26.7%)

---

## 날짜 가져오기 명령어

### Windows (PowerShell)
```powershell
Get-Date -Format "yyyy-MM-dd"
```

### Linux/Mac
```bash
date +%Y-%m-%d
```

---

## 체크리스트

문서 업데이트 시 확인사항:

- [ ] 기능 문서 상태 아이콘 변경
- [ ] TODO.md 테이블 상태 아이콘 동기화
- [ ] ROADMAP.md Feature Roadmap 테이블 업데이트
- [ ] (완료 시) ROADMAP.md 최근 완료 항목 추가
- [ ] ROADMAP.md Progress Overview 재계산
- [ ] 마지막 업데이트 날짜 갱신
- [ ] 마크다운 문법 오류 없는지 확인
- [ ] 링크가 올바르게 작동하는지 확인
