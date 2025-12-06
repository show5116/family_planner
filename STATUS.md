# Family Planner - Development Status

> 현재 개발 진행 상황 상세 정보
>
> **Last Updated**: 2025-12-02

---

## 📊 Overall Progress

```
전체 진행률: 35% (5/14 기능 완료 또는 진행 중)

✅ 완료: 1개 (7%)
🟨 진행 중: 4개 (29%)
⬜ 미시작: 9개 (64%)
```

---

## ✅ Completed Features

### 0. 프로젝트 초기 설정 및 기반 구조
**완료일**: 2025-11-30
**문서**: [00-setup.md](docs/features/00-setup.md)

- Feature-First 아키텍처
- Riverpod 상태 관리
- GoRouter 라우팅
- Material Design 3 디자인 시스템
- 반응형 레이아웃
- CI/CD 파이프라인

---

## 🟨 In Progress Features

### 1. 회원 가입 및 로그인
**문서**: [01-auth.md](docs/features/01-auth.md)
**진행률**: ~90%

#### 완료된 작업
- ✅ UI 화면 구현 (로그인, 회원가입, 이메일 인증, 비밀번호 찾기)
- ✅ 이메일/비밀번호 인증 로직
- ✅ RTR 토큰 관리
- ✅ 소셜 로그인 SDK 연동 (구글, 카카오)
- ✅ Auth Provider 구현 (AuthNotifier + AuthState)
- ✅ 로그인 상태 전역 관리 (isAuthenticated, user)
- ✅ OAuth 콜백 처리 (웹)

#### 남은 작업
- ⬜ 애플 로그인 SDK 연동
- ⬜ 소셜 로그인 백엔드 API 완성 (백엔드 작업 필요)

---

### 2. 메인화면 (대시보드)
**문서**: [02-dashboard.md](docs/features/02-dashboard.md)
**진행률**: ~50%

#### 완료된 작업
- ✅ Bottom Navigation 구조
- ✅ 대시보드 레이아웃
- ✅ 위젯 시스템 구조
- ✅ 4개 대시보드 위젯 UI 껍데기

#### 남은 작업
- ⬜ 위젯 데이터 연동 (일정, 투자지표, 할일, 자산)
- ⬜ 위젯 새로고침 기능
- ⬜ 위젯 순서 변경 (드래그 앤 드롭)
- ⬜ 추가 위젯 구현 (지출, 육아포인트 등)

---

### 11. 다국어 지원
**문서**: [11-i18n.md](docs/features/11-i18n.md)
**진행률**: ~75%

#### 완료된 작업
- ✅ 다국어 시스템 구축
- ✅ 한국어/영어/일본어 ARB 파일 작성
- ✅ 언어 변경 UI 및 로직
- ✅ 인증 화면 다국어 적용
- ✅ 설정 화면 다국어 적용 (프로필, 권한 관리 포함)

#### 남은 작업
- ⬜ 메인 화면 (대시보드) 다국어 적용
- ⬜ 그룹 관리 화면 다국어 적용
- ⬜ 날짜/시간/숫자 포맷 지역화
- ⬜ 번역 누락 검증 시스템

---

### 12-A. 설정 메뉴
**문서**: [12-settings.md](docs/features/12-settings.md)
**진행률**: ~80%

#### 완료된 작업
- ✅ 설정 메인 화면
- ✅ 테마 설정 (라이트/다크/시스템)
- ✅ 홈 위젯 설정
- ✅ 프로필 설정 화면 및 정보 수정
- ✅ 프로필 조회/수정 API 연동
- ✅ 비밀번호 변경 기능
- ✅ 전화번호 자동 포맷팅
- ✅ 운영자 전용 권한 관리 화면
- ✅ 운영자 전용 공통 역할 관리 화면

#### 남은 작업
- ⬜ 프로필 이미지 파일 업로드 (현재는 URL만 가능)
- ⬜ 알림 설정 화면
- ⬜ 알림 설정 API 연동

---

### 12-B. 그룹 관리
**문서**: [12-groups.md](docs/features/12-groups.md)
**진행률**: ~90%

#### 완료된 작업
- ✅ 그룹 CRUD UI 및 API 연동
- ✅ 초대 코드 시스템
- ✅ 멤버 관리 기능
- ✅ 역할 체계 (OWNER, ADMIN, MEMBER)
- ✅ 그룹 색상 시스템 (기본 색상 + 개인 커스텀 색상)
- ✅ **공통 역할 관리 시스템 (운영자 전용)**
  - ✅ CommonRole 모델 및 API 서비스
  - ✅ 공통 역할 목록 화면 (CRUD)
  - ✅ 역할 권한 관리 화면 (Permission 연동)
  - ✅ 생성/수정 다이얼로그
  - ✅ 설정 메뉴 통합

#### 남은 작업
- ⬜ 이메일 초대 기능 (백엔드 API 필요)
- ⬜ 그룹장 양도 기능 (백엔드 API 필요)
- ⬜ 그룹별 필터 UI (각 기능 개발 시 통합)
- ⬜ 그룹별 커스텀 역할 생성 기능

---

## ⬜ Not Started Features

### Phase 2: 핵심 기능
- **일정 관리** - [06-schedule.md](docs/features/06-schedule.md)
- **ToDoList** - [07-todo.md](docs/features/07-todo.md)
- **메모** - [09-memo.md](docs/features/09-memo.md)

### Phase 3: 자산 및 금융
- **자산관리** - [03-assets.md](docs/features/03-assets.md)
- **투자지표** - [04-investment.md](docs/features/04-investment.md)
- **가계관리** - [05-household.md](docs/features/05-household.md)

### Phase 4: 가족 기능
- **육아 포인트** - [08-childcare.md](docs/features/08-childcare.md)
- **미니게임** - [10-minigame.md](docs/features/10-minigame.md)

### Phase 5: 개선 및 확장
- **공통 기능** (푸시 알림, 검색, 오프라인) - [13-common.md](docs/features/13-common.md)

---

## 🚧 Known Issues & Blockers

### 백엔드 의존성
1. **소셜 로그인 API** ([01-auth.md](docs/features/01-auth.md))
   - 현재: 웹 리다이렉트 방식 (불완전)
   - 필요: POST /auth/google/token, POST /auth/kakao/token

2. **그룹 관리 API** ([12-groups.md](docs/features/12-groups.md))
   - 그룹장 양도: POST /groups/:id/transfer-ownership
   - 이메일 초대: POST /groups/:id/invite-by-email

3. **설정 메뉴 API** ([12-settings.md](docs/features/12-settings.md))
   - 프로필 이미지 파일 업로드 API (현재는 URL만 가능)
   - 알림 설정 조회/수정 API

### 프론트엔드 작업
1. **대시보드 위젯 데이터 연동** ([02-dashboard.md](docs/features/02-dashboard.md))
   - 각 기능(일정, 자산, 할일, 투자지표) 구현 후 연동 필요

2. **다국어 적용** ([11-i18n.md](docs/features/11-i18n.md))
   - 메인 화면 (대시보드) 다국어 적용 필요
   - 그룹 관리 화면 다국어 적용 필요
   - 날짜/시간/숫자 포맷 지역화

---

## 📅 Recent Updates

### 2025-12-06
- ✅ **공통 역할 관리 시스템 구현 완료** (운영자 전용)
  - CommonRole 모델, API 서비스, Provider 구현
  - 공통 역할 목록 화면 (CRUD)
  - 역할 권한 관리 화면 (Permission 시스템 연동)
  - 생성/수정 다이얼로그 구현
  - 설정 메뉴에 통합
- 📝 12-groups.md 문서 업데이트 (공통 역할 관리 내용 추가)

### 2025-12-03
- 📝 문서 정리: 12-settings.md와 12-groups.md 분리 명확화
- ✅ 프로필 설정 화면 구현 완료 (API 연동 포함)
- ✅ 권한 관리 화면 구현 완료
- ✅ 일본어 ARB 파일 생성
- ✅ 인증 화면 및 설정 화면 다국어 적용 완료

### 2025-12-02
- 📂 문서 구조 개편: TODO.md를 기능별로 분할
- 📄 ROADMAP.md 및 STATUS.md 생성
- 📝 CLAUDE.md 업데이트

### 2025-11-30
- ✅ 그룹 관리 기능 대부분 완료
- ✅ 모바일 UI 개선
- 📱 모바일 웹뷰 화면 깨짐 수정

---

## 🎯 Next Steps

### 단기 목표 (1-2주)
1. 회원 가입/로그인 기능 완료
2. 대시보드 위젯 데이터 연동 준비
3. 그룹 관리 남은 기능 완료

### 중기 목표 (1개월)
1. 일정 관리 기능 구현
2. ToDoList 기능 구현
3. 대시보드 위젯 실제 데이터 연동

### 장기 목표 (3개월)
1. Phase 2-3 완료 (핵심 기능 + 자산/금융)
2. MVP 출시 준비
3. 사용자 피드백 수집 및 개선

---

## 📚 Documentation Links

- [ROADMAP.md](ROADMAP.md) - 전체 로드맵
- [CLAUDE.md](CLAUDE.md) - 개발 가이드
- [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) - 프로젝트 구조
- [UI_ARCHITECTURE.md](UI_ARCHITECTURE.md) - UI/UX 디자인
- [docs/API.md](docs/API.md) - API 문서
