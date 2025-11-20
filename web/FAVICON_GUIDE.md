# 파비콘(Favicon) 및 웹 아이콘 가이드

## 📍 파비콘 파일 위치

Flutter 웹 앱의 파비콘과 아이콘은 `web/` 디렉토리에 위치합니다.

```
web/
├── favicon.png           # 브라우저 탭에 표시되는 기본 파비콘 (32x32 ~ 196x196)
├── icons/
│   ├── Icon-192.png     # PWA 아이콘 (192x192)
│   ├── Icon-512.png     # PWA 아이콘 (512x512)
│   ├── Icon-maskable-192.png  # Android 적응형 아이콘 (192x192)
│   └── Icon-maskable-512.png  # Android 적응형 아이콘 (512x512)
├── index.html           # 파비콘 참조
└── manifest.json        # PWA 설정 및 아이콘 정의
```

## 🎨 필요한 파비콘/아이콘 파일

### 1. 기본 파비콘
**위치**: `web/favicon.png`
- **크기**: 32×32px 또는 192×192px (더 큰 크기 권장)
- **형식**: PNG
- **용도**: 브라우저 탭, 북마크

### 2. ICO 파일 (선택사항, 권장)
**위치**: `web/favicon.ico`
- **크기**: 16×16, 32×32, 48×48 (멀티 사이즈)
- **형식**: ICO
- **용도**: 구형 브라우저 호환성

### 3. Apple Touch Icon
**위치**: `web/icons/Icon-192.png`
- **크기**: 180×180px 또는 192×192px
- **형식**: PNG
- **용도**: iOS 홈 화면에 추가 시

### 4. PWA 아이콘
**위치**: `web/icons/Icon-192.png`, `web/icons/Icon-512.png`
- **크기**: 192×192px, 512×512px
- **형식**: PNG
- **용도**: Progressive Web App 설치 시

### 5. Maskable 아이콘 (Android 적응형)
**위치**: `web/icons/Icon-maskable-192.png`, `web/icons/Icon-maskable-512.png`
- **크기**: 192×192px, 512×512px
- **형식**: PNG
- **용도**: Android 적응형 아이콘
- **Safe Zone**: 중앙 80% 영역에 중요한 내용 배치

## 📝 파비콘 교체 방법

### 1단계: 기존 파일 백업 (선택사항)
```bash
# 백업 디렉토리 생성
mkdir web/icons_backup

# 기존 파일 백업
cp web/favicon.png web/icons_backup/
cp web/icons/*.png web/icons_backup/
```

### 2단계: 새 파비콘 파일 준비

아이콘 생성 도구를 사용하여 여러 크기의 아이콘을 생성하세요:

#### 온라인 도구 (권장)
- [Favicon.io](https://favicon.io/) - 텍스트/이미지로 파비콘 생성
- [RealFaviconGenerator](https://realfavicongenerator.net/) - 모든 플랫폼용 아이콘 생성
- [Maskable.app](https://maskable.app/) - Maskable 아이콘 생성 및 테스트

#### 명령줄 도구
```bash
# ImageMagick을 사용한 리사이징
convert logo.png -resize 32x32 favicon.png
convert logo.png -resize 192x192 Icon-192.png
convert logo.png -resize 512x512 Icon-512.png

# ICO 파일 생성 (여러 크기 포함)
convert logo.png -define icon:auto-resize=16,32,48 favicon.ico
```

### 3단계: 파일 교체

새로 생성한 아이콘 파일을 다음 위치에 배치:

```
web/
├── favicon.png          # 32x32 또는 192x192
├── favicon.ico          # (선택사항) 16x16, 32x32, 48x48
└── icons/
    ├── Icon-192.png     # 192x192
    ├── Icon-512.png     # 512x512
    ├── Icon-maskable-192.png  # 192x192 (Safe Zone 고려)
    └── Icon-maskable-512.png  # 512x512 (Safe Zone 고려)
```

### 4단계: index.html 업데이트

`web/index.html` 파일을 열어 다음 부분을 확인/수정:

```html
<head>
  <!-- 기본 파비콘 -->
  <link rel="icon" type="image/png" href="favicon.png"/>

  <!-- ICO 파일 추가 시 (선택사항) -->
  <link rel="icon" type="image/x-icon" href="favicon.ico"/>

  <!-- Apple Touch Icon -->
  <link rel="apple-touch-icon" href="icons/Icon-192.png">

  <!-- 앱 제목 -->
  <title>Family Planner</title>

  <!-- 앱 설명 -->
  <meta name="description" content="가족과 함께하는 일상 관리 플래너">

  <!-- Apple 앱 제목 -->
  <meta name="apple-mobile-web-app-title" content="Family Planner">
</head>
```

### 5단계: manifest.json 업데이트

`web/manifest.json` 파일을 열어 앱 정보와 아이콘 설정을 업데이트:

```json
{
    "name": "Family Planner",
    "short_name": "FamPlan",
    "start_url": ".",
    "display": "standalone",
    "background_color": "#6366F1",
    "theme_color": "#6366F1",
    "description": "가족과 함께하는 일상 관리 플래너",
    "orientation": "portrait-primary",
    "prefer_related_applications": false,
    "icons": [
        {
            "src": "icons/Icon-192.png",
            "sizes": "192x192",
            "type": "image/png"
        },
        {
            "src": "icons/Icon-512.png",
            "sizes": "512x512",
            "type": "image/png"
        },
        {
            "src": "icons/Icon-maskable-192.png",
            "sizes": "192x192",
            "type": "image/png",
            "purpose": "maskable"
        },
        {
            "src": "icons/Icon-maskable-512.png",
            "sizes": "512x512",
            "type": "image/png",
            "purpose": "maskable"
        }
    ]
}
```

**주요 설정 값:**
- `name`: 전체 앱 이름
- `short_name`: 짧은 앱 이름 (12자 이하 권장)
- `background_color`: 스플래시 화면 배경색
- `theme_color`: 브라우저 UI 테마 색상 (일반적으로 Primary Color)

## 🎯 아이콘 디자인 가이드

### 기본 파비콘 (favicon.png)
- 간단하고 명확한 디자인
- 작은 크기에서도 알아볼 수 있어야 함
- 배경 투명 또는 단색

### Maskable 아이콘
- **Safe Zone**: 아이콘의 중요한 내용을 중앙 80% 영역에 배치
- 가장자리 20%는 다양한 모양으로 잘릴 수 있음
- [Maskable.app](https://maskable.app/)에서 미리보기 테스트

```
┌─────────────────────┐
│ ┌─────────────────┐ │  ← 10% 여백
│ │                 │ │
│ │   [Safe Zone]   │ │  ← 80% 안전 영역
│ │     80% 영역     │ │     (중요한 내용)
│ │                 │ │
│ └─────────────────┘ │
└─────────────────────┘  ← 10% 여백
```

## 🔄 변경 사항 적용

파비콘을 변경한 후:

```bash
# 1. 웹 빌드 (선택사항)
flutter build web

# 2. 웹 서버 실행
flutter run -d chrome --web-port=3001

# 3. 브라우저 캐시 클리어
# Chrome: Ctrl+Shift+Delete → 캐시된 이미지 및 파일 삭제
# 또는 시크릿 모드로 테스트: Ctrl+Shift+N
```

**참고**: 브라우저가 파비콘을 캐시하므로, 변경 후 바로 보이지 않을 수 있습니다.

### 캐시 클리어 방법
1. **하드 새로고침**: `Ctrl + Shift + R` (Windows) / `Cmd + Shift + R` (Mac)
2. **시크릿 모드**: 캐시 없이 새로 로드
3. **개발자 도구**: F12 → Application → Clear Storage

## 📱 모바일/태블릿 아이콘

### iOS
- `web/icons/Icon-192.png`가 홈 화면 아이콘으로 사용됨
- 180×180px 권장 (시스템이 자동으로 둥글게 처리)

### Android
- `Icon-maskable-*.png` 파일이 사용됨
- Safe Zone을 고려한 디자인 필요

## ✅ 체크리스트

파비콘 변경 시 확인 사항:

- [ ] `web/favicon.png` 교체 (32x32 ~ 192x192)
- [ ] `web/favicon.ico` 추가 (선택사항)
- [ ] `web/icons/Icon-192.png` 교체
- [ ] `web/icons/Icon-512.png` 교체
- [ ] `web/icons/Icon-maskable-192.png` 교체 (Safe Zone 고려)
- [ ] `web/icons/Icon-maskable-512.png` 교체 (Safe Zone 고려)
- [ ] `web/manifest.json` 앱 이름/색상 업데이트
- [ ] `web/index.html` 제목/설명 업데이트
- [ ] 브라우저에서 파비콘 확인 (캐시 클리어 후)
- [ ] PWA로 설치하여 아이콘 확인

## 🔗 유용한 리소스

- [Favicon.io](https://favicon.io/) - 파비콘 생성기
- [RealFaviconGenerator](https://realfavicongenerator.net/) - 모든 플랫폼 대응
- [Maskable.app](https://maskable.app/) - Maskable 아이콘 테스트
- [Google PWA Icon Guidelines](https://web.dev/maskable-icon/)
- [MDN Favicon](https://developer.mozilla.org/en-US/docs/Learn/HTML/Introduction_to_HTML/The_head_metadata_in_HTML#adding_custom_icons_to_your_site)

## 🎨 현재 설정

현재 프로젝트의 테마 색상:
- **Primary Color**: `#6366F1` (Indigo)
- **Secondary Color**: `#F97316` (Orange)

이 색상들을 `manifest.json`의 `background_color`와 `theme_color`에 사용하는 것을 권장합니다.
