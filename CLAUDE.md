# CLAUDE.md

이 파일은 Claude Code (claude.ai/code)가 이 저장소의 코드 작업을 할 때 참고하는 가이드를 제공합니다.

## 프로젝트 개요

Flutter 기반의 가족 플래너 애플리케이션으로, 현재 초기/템플릿 단계에 있습니다. 이 프로젝트는 Flutter SDK 3.18+ 및 Dart 3.10+를 사용하며, 다중 플랫폼을 지원합니다 (Android, iOS, Web, Windows, Linux, macOS).

## 개발 명령어

### 설정 및 의존성
```bash
# 의존성 설치/업데이트
flutter pub get

# 의존성을 최신 버전으로 업데이트
flutter pub upgrade
```

### 애플리케이션 실행
```bash
# 기본 디바이스에서 실행
flutter run

# 특정 디바이스에서 실행
flutter devices              # 사용 가능한 디바이스 목록 표시
flutter run -d <device-id>   # 특정 디바이스에서 실행
flutter run -d chrome        # Chrome(웹)에서 실행
flutter run -d windows       # Windows에서 실행

# 핫 리로드 활성화 상태로 실행 (기본값)
# 'r'을 눌러 핫 리로드, 'R'을 눌러 핫 재시작
```

### 테스트
```bash
# 모든 테스트 실행
flutter test

# 특정 테스트 파일 실행
flutter test test/widget_test.dart

# 커버리지와 함께 테스트 실행
flutter test --coverage

# 감시 모드에서 테스트 실행 (내장 기능 아님, entr 등 필요)
# 변경 사항 감시: find test -name "*_test.dart" | entr -r flutter test
```

### 코드 품질 및 분석
```bash
# 코드 이슈 분석 (analysis_options.yaml 사용)
flutter analyze

# 코드 포맷팅
flutter format lib/ test/

# 파일 수정 없이 포맷 확인
flutter format --set-exit-if-changed lib/ test/
```

### 빌드
```bash
# Android용 빌드
flutter build apk              # APK 빌드
flutter build appbundle        # Play Store용 App Bundle 빌드

# iOS용 빌드 (macOS 필요)
flutter build ios

# 웹용 빌드
flutter build web

# Windows용 빌드 (Windows 필요)
flutter build windows

# Linux용 빌드 (Linux 필요)
flutter build linux

# macOS용 빌드 (macOS 필요)
flutter build macos
```

### 클린
```bash
# 빌드 산출물 정리
flutter clean

# 정리 및 의존성 재설치
flutter clean && flutter pub get
```

## 코드 아키텍처

### 현재 상태
프로젝트는 현재 템플릿/스타터 단계로 최소한의 구조를 가지고 있습니다:
- 단일 진입점: `lib/main.dart`
- 기본 위젯 구조: MyApp (루트) → MyHomePage (stateful 카운터 데모)
- 아키텍처 계층이 아직 구축되지 않음
- 상태 관리 프레임워크가 구현되지 않음
- 데이터 모델, 서비스, 리포지토리가 없음

### 예상되는 향후 아키텍처
이 가족 플래너 앱을 개발할 때 다음과 같이 코드를 구성하는 것을 고려하세요:

```
lib/
├── main.dart                    # 진입점
├── models/                      # 데이터 모델 (가족 구성원, 이벤트, 작업 등)
├── screens/                     # 전체 페이지 위젯
├── widgets/                     # 재사용 가능한 UI 컴포넌트
├── services/                    # API 클라이언트, 외부 통합
├── repositories/                # 데이터 액세스 계층
├── providers/ or blocs/         # 상태 관리 (구현 시)
├── utils/                       # 헬퍼 함수, 상수
└── theme/                       # 테마 설정
```

### 상태 관리
현재 StatefulWidget에서 기본 `setState()`를 사용하고 있습니다. 단순한 데모를 넘어서 확장할 때 다음을 구현하는 것을 고려하세요:
- **Provider** (초보자에게 권장, Flutter 팀 공식)
- **Riverpod** (타입 안전, 테스트 가능한 Provider의 진화형)
- **BLoC** (비즈니스 로직 컴포넌트 패턴, 복잡한 앱에 적합)
- **GetX** (상태, 라우팅, 의존성 주입을 포함한 올인원 솔루션)

### 테스트 전략
- UI 컴포넌트에 대한 위젯 테스트 (현재: `test/widget_test.dart`)
- 비즈니스 로직에 대한 단위 테스트 (모델, 서비스, 유틸)
- 사용자 흐름에 대한 통합 테스트 (앱이 성장할 때 고려)
- `flutter_test` 패키지 사용 (이미 설정됨)
- 의존성 모킹을 위해 `mockito` 또는 `mocktail` 고려

### 코드 스타일
- `flutter_lints` 패키지 규칙 준수 (`analysis_options.yaml`에서 활성화됨)
- 성능을 위해 가능한 한 `const` 생성자 사용
- 위젯에 대해 상속보다 컴포지션 선호
- 위젯을 작고 집중적으로 유지 (더 작은 위젯으로 추출)
- 위젯 생성자에 명명된 매개변수 사용

## 플랫폼별 참고사항

### Android
- `android/` 디렉토리에서 설정
- Gradle 기반 빌드 시스템
- Min SDK 및 target SDK는 `android/app/build.gradle`에서 설정

### iOS
- `ios/` 디렉토리에서 설정
- Xcode 기반 빌드 시스템
- 빌드 및 실행에 macOS 필요

### Web
- `web/` 디렉토리에서 설정
- Chrome이 있는 모든 플랫폼에서 실행 가능
- 빌드 출력은 `build/web/`로

### Desktop (Windows/Linux/macOS)
- 각 플랫폼별 별도 디렉토리
- Windows 빌드는 Windows 환경 필요
- Linux 빌드는 Linux 환경 필요
- macOS 빌드는 macOS 환경 필요

## 의존성

현재 최소한의 의존성:
- `cupertino_icons` - iOS 스타일 아이콘
- `flutter_lints` - 코드 품질 린팅 규칙 (dev 의존성)

패키지를 추가할 때는 `pubspec.yaml`을 업데이트하고 `flutter pub get`을 실행하세요.

## Git 워크플로우

이 프로젝트는 현재 Git 저장소로 초기화되지 않았습니다. 다음과 같이 초기화하는 것을 고려하세요:
```bash
git init
git add .
git commit -m "Initial commit"
```

## 프로젝트 문서 구조

이 프로젝트는 다음 문서들을 통해 개발을 관리합니다:

### TODO.md - 기능 명세
기능 요구사항 및 개발 진행 상황을 관리합니다.

### UI_ARCHITECTURE.md - UI/UX 설계
전체 애플리케이션의 UI/UX 아키텍처를 정의합니다:
- 네비게이션 구조 (Bottom Navigation + Drawer)
- 디자인 시스템 (색상, 타이포그래피, 간격 등)
- 화면 흐름도 및 정보 구조
- 화면별 상세 레이아웃
- 공통 컴포넌트 가이드

### PROJECT_STRUCTURE.md - 프로젝트 구조
코드베이스의 폴더 구조 및 개발 가이드:
- Feature-First 아키텍처 설명
- 폴더 구조 및 파일 조직
- 사용 중인 패키지 목록
- 코딩 규칙 및 네이밍 컨벤션
- 개발 워크플로우
- 유용한 명령어

### TODO.md 파일 구조
- 각 기능은 상태 이모지로 시작합니다
- 상태 이모지:
  - ⬜ 시작 안함
  - 🟨 진행 중
  - ✅ 완료
  - ⏸️ 보류
  - ❌ 취소

### TODO.md 관리 규칙
- 새로운 기능을 추가할 때는 ⬜ 상태로 시작
- 기능 개발을 시작하면 🟨로 변경
- 기능 개발이 완료되면 ✅로 변경
- 임시로 개발을 중단하면 ⏸️로 변경
- 기능을 구현하지 않기로 결정하면 ❌로 변경
- 각 기능은 번호와 함께 명확한 제목을 가져야 함
- 세부 기능은 하이픈(-) 리스트로 하위 항목 작성
- 필요시 상세한 설명을 추가

### Claude Code 작업 시 주의사항
- 기능 개발을 시작하기 전에 TODO.md를 확인하여 현재 진행 상황 파악
- UI 개발 시 UI_ARCHITECTURE.md의 디자인 시스템 및 레이아웃 가이드 준수
- 기능 개발 시작 시 해당 항목을 🟨로 업데이트
- 기능 개발 완료 시 해당 항목을 ✅로 업데이트
- 새로운 기능 요구사항 발견 시 TODO.md에 추가
- UI/UX 변경사항이 있을 경우 UI_ARCHITECTURE.md 업데이트

## 개발 참고사항

- 이 프로젝트는 Dart SDK ^3.10.0을 사용하며, 최신 Dart 기능(레코드, 패턴 등)을 포함합니다
- 핫 리로드는 대부분의 UI 변경에 작동하며, 상태 변경이나 초기화 코드에는 핫 재시작이 필요합니다
- 프로덕션 코드에서는 `print()` 대신 `debugPrint()`를 사용하세요 (큰 출력에 더 좋음)
- Material Design 3가 사용 가능하며, `main.dart`의 `ThemeData`를 통해 설정할 수 있습니다
- `.metadata` 파일은 Flutter 프로젝트 메타데이터를 추적하므로 수동 편집을 피하세요
