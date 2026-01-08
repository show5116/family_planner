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

## Claude Skills 🤖

프로젝트에는 반복 작업을 자동화하는 **6개의 Claude Skills**가 설정되어 있습니다.

### 자동 실행 Skills (P0 - 최우선)

자연어로 요청하면 자동으로 실행됩니다:

- 🏗️ **feature-create**: 새 기능 자동 생성 (Screen, Provider, Model, Repository)
  - 예: "일정관리 기능을 만들어주세요"
- 🌐 **i18n-add**: 다국어 문자열 자동 추가 (한/영/일)
  - 예: "로그인 버튼 텍스트 추가해줘"
- 📝 **docs-update**: 문서 자동 업데이트 (ROADMAP.md, TODO.md)
  - 예: "공지사항 기능 완료"

### 수동 실행 Skills (필요 시)

명시적으로 요청해야 실행됩니다:

- 🔍 **code-review**: CODE_STYLE.md 기준 코드 리뷰
  - 사용: "login_screen.dart 리뷰해주세요"
- 🔄 **api-sync**: API 문서와 프론트엔드 동기화 확인
  - 사용: "공지사항 API 동기화 확인해줘"
- 🧪 **test-generate**: 테스트 코드 자동 생성
  - 사용: "AnnouncementListScreen 테스트 생성해줘"

### 토큰 효율성 최적화

자동 실행 Skills는 가장 빈번하고 효과적인 3개만 선별하여 토큰 사용량을 최소화했습니다.

📚 **상세 가이드**: [.claude/skills/README.md](.claude/skills/README.md)

---

## 포트 설정

- **프론트엔드**: `localhost:3001` (웹 개발 서버)
- **백엔드 개발**: `http://localhost:3000`
- **백엔드 프로덕션**: `https://familyplannerbackend-production.up.railway.app`

## API 문서 참조 방법

- **사용할 문서**: `docs/api/` 디렉토리 내부의 문서들
- 이 문서들은 백엔드 코드 기반으로 자동 생성되어 항상 최신 상태로 동기화됩니다
- API 엔드포인트, 요청/응답 스키마, 예제 등 모든 정보가 포함되어 있습니다

## 문서 구조

- **[ROADMAP.md](ROADMAP.md)**: 프로젝트 로드맵 및 진행 상황
- **[CODE_STYLE.md](CODE_STYLE.md)**: 코드 컨벤션 (필수 준수)
- **[docs/features/](docs/features/)**: 기능별 상세 문서 (15개)
- **[docs/api/](docs/api/)**: 백엔드 API 문서 (자동 생성)

**⚠️ 중요 - 토큰 효율성:**
- **작업 중인 기능 문서만** 읽어야 합니다
- 다른 기능 문서는 읽지 마세요 (불필요한 토큰 낭비)
- 예: 공지사항 작업 시 → `docs/features/15-announcements.md`만 읽기

**기능 문서 작성 가이드:**
- **✅ 완료**: UI 구현 체크리스트 + 데이터 모델 + 기능 구현 + 구현 위치 (100-150줄)
- **🟨 진행중**: 상세 체크리스트 유지
- **⬜ 미시작**: 핵심 기능 개요만 (30-50줄)

## 개발 워크플로우

1. **작업 전**: [ROADMAP.md](ROADMAP.md) 및 해당 기능 문서 확인
2. **작업 중**: [CODE_STYLE.md](CODE_STYLE.md) 준수, 상태를 🟨로 변경
3. **완료 후**: 상태를 ✅로 변경, ROADMAP.md 업데이트

**상태 아이콘**: ⬜ 시작 안함 | 🟨 진행 중 | ✅ 완료 | ⏸️ 보류 | ❌ 취소

## 코드 스타일

**필수: [CODE_STYLE.md](CODE_STYLE.md) 엄격히 준수**

- **Import**: 절대 경로 (`package:family_planner/...`)
- **상수**: `AppColors.*`, `AppSizes.*`, `Theme.of(context)`
- **명명**: snake_case 파일, PascalCase 클래스, camelCase 변수
- **위젯**: const 생성자, build 메서드 분해
- **Riverpod**: `@riverpod` 어노테이션 + `when()` 패턴

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
