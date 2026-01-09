# Family Planner - Project Roadmap

> 전체 프로젝트 진행 상황 및 로드맵
>
> 상태 아이콘: ⬜ 시작 안함 | 🟨 진행 중 | ✅ 완료 | ⏸️ 보류 | ❌ 취소

---

## 📊 Progress Overview

- **완료**: 4/16 기능 (25%)
- **진행 중**: 4/16 기능 (25%)
- **미시작**: 8/16 기능 (50%)

**마지막 업데이트**: 2026-01-09

---

## 🗺️ Feature Roadmap

### Phase 1: 기반 구조 및 인증 (Foundation & Auth)

| 기능 | 상태 | 문서 | 우선순위 |
|------|------|------|----------|
| 프로젝트 초기 설정 | ✅ 완료 | [00-setup.md](docs/features/00-setup.md) | P0 |
| 회원 가입 및 로그인 | 🟨 진행 중 | [01-auth.md](docs/features/01-auth.md) | P0 |
| 그룹 관리 | ✅ 완료 | [12-groups.md](docs/features/12-groups.md) | P0 |

### Phase 2: 핵심 기능 (Core Features)

| 기능 | 상태 | 문서 | 우선순위 |
|------|------|------|----------|
| 메인화면 (대시보드) | 🟨 진행 중 | [02-dashboard.md](docs/features/02-dashboard.md) | P1 |
| 일정 관리 | ⬜ 시작 안함 | [06-schedule.md](docs/features/06-schedule.md) | P1 |
| ToDoList | ⬜ 시작 안함 | [07-todo.md](docs/features/07-todo.md) | P1 |
| 메모 | ⬜ 시작 안함 | [09-memo.md](docs/features/09-memo.md) | P2 |

### Phase 3: 자산 및 금융 (Finance & Assets)

| 기능 | 상태 | 문서 | 우선순위 |
|------|------|------|----------|
| 자산관리 | ⬜ 시작 안함 | [03-assets.md](docs/features/03-assets.md) | P2 |
| 투자지표 | ⬜ 시작 안함 | [04-investment.md](docs/features/04-investment.md) | P2 |
| 가계관리 | ⬜ 시작 안함 | [05-household.md](docs/features/05-household.md) | P2 |

### Phase 4: 가족 기능 (Family Features)

| 기능 | 상태 | 문서 | 우선순위 |
|------|------|------|----------|
| 육아 포인트 | ⬜ 시작 안함 | [08-childcare.md](docs/features/08-childcare.md) | P3 |
| 미니게임 | ⬜ 시작 안함 | [10-minigame.md](docs/features/10-minigame.md) | P3 |

### Phase 5: 개선 및 확장 (Enhancement & Expansion)

| 기능 | 상태 | 문서 | 우선순위 |
|------|------|------|----------|
| 다국어 지원 | 🟨 진행 중 | [11-i18n.md](docs/features/11-i18n.md) | P1 |
| 설정 메뉴 | ✅ 완료 | [12-settings.md](docs/features/12-settings.md) | P1 |
| 알림 시스템 | 🟨 진행 중 | [14-notification.md](docs/features/14-notification.md) | P1 |
| 공지사항 | ✅ 완료 | [15-announcements.md](docs/features/15-announcements.md) | P1 |
| 공통 기능 | ⬜ 시작 안함 | [13-common.md](docs/features/13-common.md) | P2 |

**참고**: 설정 메뉴는 프로필 설정, 테마 설정, 홈 위젯 설정을 포함하며, 그룹 관리([12-groups.md](docs/features/12-groups.md))와 권한 관리는 별도 관리됩니다.

---

## 🎯 Milestone Plan

### Milestone 1: MVP Launch (목표: Phase 1-2 완료)
- [x] 프로젝트 기반 구조
- [ ] 회원 인증 시스템 완성
- [x] 그룹 관리 완성
- [ ] 대시보드 데이터 연동
- [ ] 일정 관리 기본 기능
- [ ] ToDoList 기본 기능

### Milestone 2: Finance Features (목표: Phase 3 완료)
- [ ] 자산관리 시스템
- [ ] 투자지표 대시보드
- [ ] 가계부 기능

### Milestone 3: Family Features (목표: Phase 4 완료)
- [ ] 육아 포인트 시스템
- [ ] 미니게임 기능

### Milestone 4: Polish & Scale (목표: Phase 5 완료)
- [ ] 다국어 완전 지원
- [ ] 푸시 알림 시스템
- [ ] 오프라인 지원
- [ ] 성능 최적화

---

## 📈 최근 완료된 기능

### 2026-01-09
- ✅ **공지사항 시스템 완료** ([15-announcements.md](docs/features/15-announcements.md))
  - 공지사항 CRUD 기능 완료 (ADMIN 전용)
  - 목록/상세 화면 구현 (고정 공지, 읽음 표시)
  - 카테고리 필터 기능 (전체/공지사항/이벤트/업데이트)
  - 마크다운 지원 (작성 및 렌더링)
  - 무한 스크롤 및 Pull-to-refresh
  - 백엔드 API 완전 연동
  - 대소문자 호환 JsonConverter 구현

### 2025-12-27
- ✅ **알림 시스템 프론트엔드 구현 완료** ([14-notification.md](docs/features/14-notification.md))
  - Firebase Cloud Messaging 통합 완료
  - 로컬 알림 서비스 구현
  - 알림 권한 관리 및 설정 UI 완료
  - FCM 토큰 관리 Provider 구현
  - 환경 변수 관리 개선 (.env 파일로 전환)
  - GitHub Actions에서 환경 변수 동적 생성 설정
  - 백엔드 API 연동 대기 중

### 2025-12-24
- ✅ **그룹 관리 기능 완료** ([12-groups.md](docs/features/12-groups.md))
  - 그룹 CRUD, 초대 시스템, 멤버 관리, 역할 체계 완료
  - 공통 역할 관리 시스템 (운영자 전용) 구현

- ✅ **설정 메뉴 주요 기능 완료** ([12-settings.md](docs/features/12-settings.md))
  - 프로필 설정 (이미지 업로드 포함) 완료
  - 테마 설정, 홈 위젯 설정 완료
  - 권한 관리 화면 (운영자 전용) 완료

### 진행 중인 작업
- 🟨 **회원 가입 및 로그인** (~90% 완료)
  - 남은 작업: 애플 로그인, 소셜 로그인 백엔드 완성

- 🟨 **메인화면 (대시보드)** (~50% 완료)
  - 남은 작업: 위젯 데이터 연동, 새로고침, 순서 변경

- 🟨 **다국어 지원** (~75% 완료)
  - 남은 작업: 대시보드 및 그룹 관리 화면 다국어 적용

- 🟨 **알림 시스템** (~85% 프론트엔드 완료, 백엔드 대기)
  - 완료: Firebase 설정, 서비스 레이어, Provider, 설정 UI, 메시지 처리
  - 남은 작업: 백엔드 API 연동, 알림 히스토리 화면 완성

---

## 🔮 향후 추가 예정 기능

이 섹션에는 나중에 추가될 수 있는 기능들을 기록합니다.

### 고려 중인 기능
- ⬜ 가족 사진 앨범
- ⬜ 가족 채팅
- ⬜ 가족 위치 공유
- ⬜ 건강 기록 (키, 몸무게 등)
- ⬜ 가족 목표 설정 및 추적
- ⬜ 데이터 백업/복원
- ⬜ 데이터 내보내기 (CSV, PDF)

---

## 📚 Related Documentation

- [CLAUDE.md](CLAUDE.md) - 개발 가이드 (개발 시 필독)
- [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) - 프로젝트 구조 및 아키�ecture
- [UI_ARCHITECTURE.md](UI_ARCHITECTURE.md) - UI/UX 디자인 시스템
- [docs/features/](docs/features/) - 기능별 상세 문서
- [docs/api/](docs/api/) - 백엔드 API 문서 (자동 생성)

---

**Priority Levels:**
- **P0**: Critical (MVP 필수)
- **P1**: High (MVP 권장)
- **P2**: Medium (후속 버전)
- **P3**: Low (나중에)
