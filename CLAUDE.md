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
- **API 문서**: `http://localhost:3000/api-json` (Swagger)

## 문서 구조

### 핵심 문서
- **TODO.md**: 기능 명세 및 진행 상황 관리
- **UI_ARCHITECTURE.md**: UI/UX 디자인 시스템 및 화면 구조
- **PROJECT_STRUCTURE.md**: 코드베이스 구조 및 개발 가이드

### 상세 문서 (docs/)
- **docs/API.md**: 백엔드 API 엔드포인트 상세 명세
- **docs/SOCIAL_LOGIN_SETUP.md**: 소셜 로그인 설정 및 트러블슈팅

## 개발 워크플로우

### 작업 시작 전
1. **TODO.md**에서 현재 진행 상황 확인
2. UI 작업 시 **UI_ARCHITECTURE.md**의 디자인 시스템 참조
3. API 연동 시 **docs/API.md** 참조

### 작업 중
1. 기능 개발 시작: TODO.md 상태를 🟨 (진행 중)으로 변경
2. UI 개발 시 디자인 시스템 준수 (색상, 간격, 타이포그래피)
3. 코드 스타일: `flutter_lints` 규칙 준수

### 작업 완료 후
1. TODO.md 상태를 ✅ (완료)로 변경
2. UI/UX 변경 시 UI_ARCHITECTURE.md 업데이트
3. 새 기능 발견 시 TODO.md에 추가

## TODO.md 상태 관리

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
