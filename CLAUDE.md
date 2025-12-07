# CLAUDE.md

이 파일은 Claude Code가 코드 작업 시 참고하는 핵심 가이드입니다.

## 프로젝트 개요

Flutter 기반 가족 플래너 애플리케이션 (Flutter 3.18+, Dart 3.10+)
- 다중 플랫폼 지원: Web, Android, iOS, Windows, Linux, macOS
- 상태 관리: Riverpod
- 아키텍처: Feature-First

## 주요 명령어

```bash
# 실행
flutter run -d chrome --web-port=3001  # 웹 (포트 3001 고정)
flutter run -d windows                 # Windows

# 개발
flutter analyze                        # 코드 분석
flutter test                           # 테스트 실행
flutter clean && flutter pub get       # 클린 빌드
```

## 포트 설정

- **프론트엔드**: `localhost:3001` (웹 개발 서버)
- **백엔드 개발**: `http://localhost:3000`
- **백엔드 프로덕션**: `https://familyplannerbackend-production.up.railway.app`
- **API 문서 (Swagger)**:
  - 개발: `http://localhost:3000/api-json`
  - 프로덕션: `https://familyplannerbackend-production.up.railway.app/api-json`
  - **중요**: Swagger 문서 확인 시 WebFetch가 아닌 `curl` 명령어 사용 필수
    ```bash
    # 개발 환경
    curl http://localhost:3000/api-json

    # 프로덕션 환경
    curl https://familyplannerbackend-production.up.railway.app/api-json
    ```

## 문서 구조

### 📋 프로젝트 관리 문서
- **[ROADMAP.md](ROADMAP.md)**: 전체 프로젝트 로드맵 및 기능 목록
- **[STATUS.md](STATUS.md)**: 현재 개발 진행 상황 상세
- **[TODO.md](TODO.md)**: ⚠️ 아카이브됨 (기능별 문서로 분할됨)

### 🏗️ 아키텍처 문서
- **[PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)**: 코드베이스 구조 및 개발 가이드
- **[UI_ARCHITECTURE.md](UI_ARCHITECTURE.md)**: UI/UX 디자인 시스템 및 화면 구조

### 📚 기능별 상세 문서 (docs/features/)
각 기능의 요구사항, 진행 상황, API 연동 등을 독립적으로 관리:
- [00-setup.md](docs/features/00-setup.md) - 프로젝트 초기 설정 ✅
- [01-auth.md](docs/features/01-auth.md) - 회원 가입 및 로그인 🟨
- [02-dashboard.md](docs/features/02-dashboard.md) - 메인화면 (대시보드) 🟨
- [03-assets.md](docs/features/03-assets.md) - 자산관리 ⬜
- [04-investment.md](docs/features/04-investment.md) - 투자지표 ⬜
- [05-household.md](docs/features/05-household.md) - 가계관리 ⬜
- [06-schedule.md](docs/features/06-schedule.md) - 일정관리 ⬜
- [07-todo.md](docs/features/07-todo.md) - ToDoList ⬜
- [08-childcare.md](docs/features/08-childcare.md) - 육아포인트 ⬜
- [09-memo.md](docs/features/09-memo.md) - 메모 ⬜
- [10-minigame.md](docs/features/10-minigame.md) - 미니게임 ⬜
- [11-i18n.md](docs/features/11-i18n.md) - 다국어 🟨
- [12-settings.md](docs/features/12-settings.md) - 설정 🟨
- [12-groups.md](docs/features/12-groups.md) - 그룹관리 🟨
- [13-common.md](docs/features/13-common.md) - 공통 기능 ⬜

### 🔧 기타 문서 (docs/)
- **[docs/API.md](docs/API.md)**: 백엔드 API 엔드포인트 상세 명세
- **[docs/SOCIAL_LOGIN_SETUP.md](docs/SOCIAL_LOGIN_SETUP.md)**: 소셜 로그인 설정 및 트러블슈팅

## 개발 워크플로우

### 작업 시작 전
1. **[ROADMAP.md](ROADMAP.md)** 또는 **[STATUS.md](STATUS.md)**에서 전체 진행 상황 확인
2. 작업할 기능의 **[docs/features/](docs/features/)** 문서에서 상세 요구사항 확인
3. UI 작업 시 **[UI_ARCHITECTURE.md](UI_ARCHITECTURE.md)**의 디자인 시스템 참조
4. API 연동 시 **[docs/API.md](docs/API.md)** 참조

### 작업 중
1. 기능 개발 시작: 해당 기능 문서의 상태를 🟨 (진행 중)으로 변경
2. UI 개발 시 디자인 시스템 준수 (색상, 간격, 타이포그래피)
3. 코드 스타일: `flutter_lints` 규칙 준수

### 작업 완료 후
1. 해당 기능 문서의 상태를 ✅ (완료)로 변경
2. **[STATUS.md](STATUS.md)**의 전체 진행 상황 업데이트
3. UI/UX 변경 시 **[UI_ARCHITECTURE.md](UI_ARCHITECTURE.md)** 업데이트
4. 새로운 세부 작업 발견 시 해당 기능 문서에 추가

## 작업 상태 관리

상태 아이콘:
- ⬜ 시작 안함
- 🟨 진행 중
- ✅ 완료
- ⏸️ 보류
- ❌ 취소

## 코드 스타일 가이드

- `const` 생성자 적극 활용
- 위젯은 작고 집중적으로 유지
- 상속보다 컴포지션 선호
- `print()` 대신 `debugPrint()` 사용
- Feature-First 구조 준수 (상세: PROJECT_STRUCTURE.md)

## 자주 참조하는 파일

- 환경 설정: `lib/core/config/environment.dart`
- 라우팅: `lib/core/routes/app_routes.dart`
- 테마: `lib/core/theme/app_theme.dart`
- 디자인 상수: `lib/core/constants/app_sizes.dart`, `app_colors.dart`

## 참고 사항

- Hot Reload: UI 변경 시 `r` 키
- Hot Restart: 상태/초기화 코드 변경 시 `R` 키
- Material Design 3 사용
- `.metadata` 파일은 수동 편집 금지
