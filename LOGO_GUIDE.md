# Family Planner 로고 가이드

## 📱 로고 디자인

Family Planner 앱의 로고는 다음과 같이 디자인되었습니다:

### 디자인 컨셉
- **집 모양**: 가족과 가정을 상징
- **체크마크**: 계획과 완료를 상징
- **색상**:
  - 프라이머리 블루 (#2196F3): 신뢰감, 안정감
  - 세컨더리 오렌지 (#FF9800): 활력, 따뜻함
  - 흰색: 깔끔함, 순수함

### 로고 구성 요소
```
┌─────────────────┐
│   ◉  ← 체크마크  │
│  /\  ← 지붕     │
│ /  \ ← 집 모양  │
│ ▢  ▢ ← 창문     │
│  ▢   ← 문       │
└─────────────────┘
```

## 🎨 Flutter 위젯으로 사용하기

### 1. 전체 로고 (로그인 화면, 스플래시 화면)

```dart
import 'package:family_planner/shared/widgets/app_logo.dart';

// 기본 사용
AppLogo()

// 크기 조정
AppLogo(size: 150)

// 텍스트 없이 아이콘만
AppLogo(size: 120, showText: false)
```

### 2. 작은 아이콘 (앱바, 네비게이션)

```dart
import 'package:family_planner/shared/widgets/app_logo.dart';

// 앱바에 사용
AppBar(
  leading: AppLogoIcon(size: 32),
  title: Text('Family Planner'),
)

// 크기 조정
AppLogoIcon(size: 24)
```

## 🖼️ 실제 앱 아이콘 이미지 생성하기

Flutter 위젯 로고는 앱 내에서 사용되지만, 실제 앱 아이콘(런처 아이콘)은 이미지 파일이 필요합니다.

### 방법 1: 온라인 로고 생성 도구 사용 (추천)

다음 무료 도구들을 사용하여 로고를 디자인하세요:

1. **Canva** (https://www.canva.com)
   - "App Icon" 템플릿 검색
   - 1024x1024 크기로 제작
   - 집 + 체크마크 아이콘 조합
   - 그라디언트 배경 적용

2. **Figma** (https://www.figma.com)
   - 프로페셔널한 디자인 가능
   - 무료 플랜 제공

3. **Flaticon** (https://www.flaticon.com)
   - 집 아이콘 다운로드
   - 포토샵이나 Canva에서 편집

### 방법 2: AI 로고 생성기

1. **LogoAI** (https://www.logoai.com)
2. **Hatchful by Shopify** (https://hatchful.shopify.com)

프롬프트 예시:
```
"Modern family planner app logo with house icon and checkmark,
blue and orange gradient, minimalist design, circular shape"
```

### 방법 3: flutter_launcher_icons 패키지 사용

이미지를 만든 후 자동으로 앱 아이콘 생성:

#### 1. pubspec.yaml에 추가

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"
  min_sdk_android: 21
  web:
    generate: true
    image_path: "assets/icon/app_icon.png"
  windows:
    generate: true
    image_path: "assets/icon/app_icon.png"
  macos:
    generate: true
    image_path: "assets/icon/app_icon.png"
```

#### 2. 아이콘 이미지 준비

- `assets/icon/app_icon.png` 파일 생성
- 최소 1024x1024 크기의 PNG 파일
- 투명 배경 권장

#### 3. 아이콘 생성 명령어

```bash
# 아이콘 생성
flutter pub get
flutter pub run flutter_launcher_icons

# 또는
dart run flutter_launcher_icons
```

## 📐 아이콘 크기 가이드

| 플랫폼 | 권장 크기 |
|--------|----------|
| Android | 1024x1024 px |
| iOS | 1024x1024 px |
| Web | 512x512 px |
| Windows | 256x256 px |
| macOS | 1024x1024 px |

## 🎯 디자인 팁

### 색상 조합
```dart
// 그라디언트 배경
LinearGradient(
  colors: [
    Color(0xFF2196F3), // 프라이머리 블루
    Color(0xFF1976D2), // 프라이머리 다크
  ],
)

// 악센트 색상
Color(0xFFFF9800) // 세컨더리 오렌지
```

### 아이콘 요소
- 메인: 집 모양 🏠
- 서브: 체크마크 ✓
- 추가 가능: 캘린더 📅, 하트 ❤️

### 스타일 가이드
- **미니멀**: 간결하고 깔끔한 디자인
- **둥근 모서리**: 친근하고 부드러운 느낌
- **그라디언트**: 현대적이고 세련된 느낌
- **그림자**: 입체감 추가

## 🚀 로고 사용 예제

### 스플래시 화면
```dart
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppLogo(size: 200),
      ),
    );
  }
}
```

### 로그인 화면
```dart
// lib/features/auth/screens/login_screen.dart 참고
// 이미 로고가 포함된 로그인 화면 예제가 있습니다
```

### 앱바
```dart
AppBar(
  leading: Padding(
    padding: EdgeInsets.all(8),
    child: AppLogoIcon(),
  ),
  title: Text('Family Planner'),
)
```

## 📦 리소스 파일 구조

```
assets/
├── icon/
│   ├── app_icon.png          # 1024x1024 (앱 아이콘)
│   ├── app_icon_foreground.png  # Android adaptive icon
│   └── app_icon_background.png  # Android adaptive icon
└── logo/
    ├── logo_full.png         # 전체 로고 (텍스트 포함)
    └── logo_icon.png         # 아이콘만
```

## 🎨 추천 무료 리소스

- **아이콘**: Material Icons (Flutter 기본 제공)
- **폰트**: Pretendard (한글), Inter (영문)
- **색상 팔레트**: Material Design Color System
- **디자인 영감**: Dribbble, Behance

---

**마지막 업데이트**: 2025-11-18
**작성자**: Claude Code
