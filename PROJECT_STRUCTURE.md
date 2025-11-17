# Family Planner - 프로젝트 구조

> 작성일: 2025-11-17
> Flutter Feature-First 아키텍처

---

## 폴더 구조

```
lib/
├── main.dart                           # 앱 진입점
│
├── core/                               # 핵심 기능 및 공통 설정
│   ├── constants/                      # 상수 정의
│   │   ├── app_colors.dart            # 색상 상수
│   │   ├── app_sizes.dart             # 크기/간격 상수
│   │   └── app_text_styles.dart       # 텍스트 스타일 상수
│   │
│   ├── theme/                          # 테마 설정
│   │   └── app_theme.dart             # Light/Dark 테마
│   │
│   ├── routes/                         # 라우팅 설정
│   │   ├── app_routes.dart            # 라우트 경로 상수
│   │   └── app_router.dart            # GoRouter 설정
│   │
│   └── utils/                          # 유틸리티
│       ├── extensions.dart            # 확장 메서드
│       └── validators.dart            # Form 검증 함수
│
├── features/                           # 기능별 모듈 (Feature-First)
│   ├── auth/                          # 인증 기능
│   │   ├── screens/                   # 화면
│   │   ├── widgets/                   # 위젯
│   │   └── providers/                 # 상태 관리 (Riverpod)
│   │
│   ├── home/                          # 메인 홈 (대시보드)
│   │   ├── screens/
│   │   │   └── home_screen.dart      # 메인 화면 (Bottom Nav 포함)
│   │   ├── widgets/
│   │   └── providers/
│   │
│   ├── assets/                        # 자산 관리
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── providers/
│   │
│   ├── calendar/                      # 일정 관리
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── providers/
│   │
│   ├── todo/                          # ToDoList
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── providers/
│   │
│   ├── household/                     # 가계 관리
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── providers/
│   │
│   ├── child_points/                  # 육아 포인트
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── providers/
│   │
│   ├── memo/                          # 메모
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── providers/
│   │
│   ├── mini_games/                    # 미니 게임
│   │   ├── screens/
│   │   └── widgets/
│   │
│   └── settings/                      # 설정
│       ├── screens/
│       └── widgets/
│
└── shared/                            # 공유 리소스
    ├── models/                        # 공통 데이터 모델
    ├── widgets/                       # 공통 위젯
    ├── services/                      # API, 외부 서비스
    └── repositories/                  # 데이터 접근 계층
```

---

## 아키텍처 패턴

### Feature-First 구조
- 기능(Feature)별로 폴더를 분리
- 각 기능은 독립적으로 개발 및 테스트 가능
- screens, widgets, providers로 계층 분리

### 상태 관리: Riverpod
- `flutter_riverpod` 2.6.1 사용
- Provider 기반 상태 관리
- 코드 생성 지원 (`riverpod_generator`)

### 라우팅: GoRouter
- `go_router` 14.6.2 사용
- 선언적 라우팅
- Deep Linking 지원

---

## 주요 패키지

### State Management
- `flutter_riverpod`: ^2.6.1
- `riverpod_annotation`: ^2.6.1

### Routing
- `go_router`: ^14.6.2

### Local Storage
- `shared_preferences`: ^2.3.3

### HTTP & API
- `http`: ^1.2.2
- `dio`: ^5.7.0

### Charts
- `fl_chart`: ^0.69.2

### Date & Time
- `intl`: ^0.19.0
- `table_calendar`: ^3.1.2

### UI Components
- `shimmer`: ^3.0.0
- `flutter_slidable`: ^3.1.1

### Utilities
- `equatable`: ^2.0.7
- `freezed_annotation`: ^2.4.4
- `json_annotation`: ^4.9.0

### Dev Dependencies
- `build_runner`: ^2.4.13
- `riverpod_generator`: ^2.6.2
- `freezed`: ^2.5.7
- `json_serializable`: ^6.8.0
- `flutter_lints`: ^6.0.0

---

## 디자인 시스템

### 색상 (AppColors)
```dart
Primary: #2196F3 (Blue)
Secondary: #FF9800 (Orange)
Success: #4CAF50 (Green)
Error: #F44336 (Red)
```
- Light/Dark 테마 지원
- 기능별 색상 (수익/지출, 자산, 투자 등)

### 간격 (AppSizes)
```dart
Space XS: 4px
Space S: 8px
Space M: 16px
Space L: 24px
Space XL: 32px
Space XXL: 48px
```

### 타이포그래피 (AppTextStyles)
- Material Design 3 기반
- Display, Headline, Title, Body, Label 스타일 제공

---

## 네비게이션 구조

### Bottom Navigation (5개)
1. 홈 - 메인 대시보드
2. 자산 - 자산관리 + 투자지표
3. 일정 - 캘린더
4. 할일 - ToDoList
5. 더보기 - 나머지 메뉴 + 설정

### 추가 기능 (더보기 메뉴)
- 가계관리
- 육아포인트
- 메모
- 미니게임
- 설정 (가족 관리, 알림, 테마)

---

## 코딩 규칙

### 파일 네이밍
- 소문자 + 언더스코어 (snake_case)
- 예: `home_screen.dart`, `user_profile_widget.dart`

### 클래스 네이밍
- PascalCase
- 예: `HomeScreen`, `UserProfileWidget`

### 상수 네이밍
- camelCase
- 예: `primaryColor`, `spaceM`

### Private 멤버
- 언더스코어로 시작 (`_`)
- 예: `_selectedIndex`, `_incrementCounter()`

### Import 순서
1. Dart SDK
2. Flutter SDK
3. 외부 패키지
4. 프로젝트 내부 파일

```dart
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:riverpod/riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/theme/app_theme.dart';
```

### 위젯 분리
- 200줄 이상의 위젯은 분리 고려
- Private 위젯은 같은 파일에 작성 가능
- Public 위젯은 별도 파일로 분리

---

## 개발 워크플로우

### 1. 기능 개발 시작
```bash
# TODO.md에서 해당 기능 상태를 🟨로 변경
# UI_ARCHITECTURE.md에서 화면 레이아웃 확인
# 필요한 폴더 구조 생성
```

### 2. 모델 정의
```bash
# shared/models/ 또는 features/*/models/ 에 모델 생성
# Freezed 사용 시 코드 생성
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. UI 구현
```bash
# screens/ 에 화면 작성
# widgets/ 에 재사용 위젯 작성
# core/theme/ 의 테마 시스템 활용
```

### 4. 상태 관리
```bash
# providers/ 에 Riverpod Provider 작성
# 필요시 코드 생성
flutter pub run build_runner watch
```

### 5. 라우팅 연결
```bash
# core/routes/app_routes.dart 에 경로 추가
# core/routes/app_router.dart 에 라우트 설정
```

### 6. 테스트
```bash
# 화면 동작 확인
flutter run

# 코드 분석
flutter analyze

# 포맷팅
flutter format lib/
```

### 7. 완료
```bash
# TODO.md에서 해당 기능 상태를 ✅로 변경
```

---

## 유용한 명령어

### 의존성 설치
```bash
flutter pub get
```

### 코드 생성 (1회)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 코드 생성 (Watch 모드)
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### 앱 실행
```bash
flutter run
```

### 코드 분석
```bash
flutter analyze
```

### 코드 포맷팅
```bash
flutter format lib/
```

### 테스트 실행
```bash
flutter test
```

---

## 다음 단계

1. ✅ 프로젝트 구조 설정 완료
2. ⬜ 인증 기능 구현
3. ⬜ 메인 대시보드 구현
4. ⬜ 자산 관리 기능 구현
5. ⬜ 일정 관리 기능 구현
6. ⬜ ToDoList 기능 구현
7. ⬜ 가계 관리 기능 구현
8. ⬜ 육아 포인트 기능 구현
9. ⬜ 메모 기능 구현
10. ⬜ 미니게임 기능 구현

---

**문서 버전**: 1.0
**최종 수정일**: 2025-11-17
**작성자**: Claude Code
