# 17. 날씨 기능 (Weather)

## 상태
⬜ 시작 안함

---

## 개요

GPS 위치 기반 현재 날씨 및 3일 단기예보를 대시보드 위젯과 상세 화면으로 제공합니다.

---

## API 연동

- `GET /weather?lat={lat}&lon={lon}` — 현재 날씨 (초단기실황)
- `GET /weather/forecast?lat={lat}&lon={lon}` — 단기예보 (3일 시간별)

상세 스펙: [docs/api/weather.md](../api/weather.md)

---

## 데이터 모델

```dart
// lib/features/weather/models/weather_model.dart
class WeatherModel {
  final int temperature;       // 기온 (°C)
  final int humidity;          // 습도 (%)
  final double windSpeed;      // 풍속 (m/s)
  final double precipitation;  // 강수량 (mm)
  final int sky;               // 하늘상태 (1=맑음, 3=구름많음, 4=흐림)
  final int precipitationType; // 강수형태 (0=없음, 1=비, 2=진눈깨비, 3=눈, 4=소나기)
  final String weatherDescription;
  final String baseDate;       // YYYYMMDD
  final String baseTime;       // HHmm
}

class ForecastItemModel {
  final String fcstDate;       // YYYYMMDD
  final String fcstTime;       // HHmm
  final int temperature;
  final int? minTemperature;
  final int? maxTemperature;
  final int precipitationProbability; // (%)
  final double precipitation;
  final int humidity;
  final double windSpeed;
  final int sky;
  final int precipitationType;
  final String weatherDescription;
}

class WeatherForecastModel {
  final String baseDate;
  final String baseTime;
  final List<ForecastItemModel> forecasts;
}
```

---

## 구현 계획

### Phase 1: 데이터 레이어

- [ ] `WeatherModel`, `ForecastItemModel`, `WeatherForecastModel` 모델 작성
- [ ] `WeatherRepository` — `/weather`, `/weather/forecast` API 호출
- [ ] `weatherProvider` (FutureProvider) — 현재 날씨
- [ ] `weatherForecastProvider` (FutureProvider) — 단기예보
- [ ] 위치 권한 처리 (`geolocator` 패키지)
- [ ] `locationProvider` — GPS 좌표 제공 (캐시 포함)

### Phase 2: 대시보드 위젯

- [ ] `WeatherWidget` — 콤팩트 날씨 카드
  - 날씨 아이콘 + 기온 + 날씨 설명
  - 습도 / 풍속 보조 정보
  - 탭 시 상세 화면 이동
  - 로딩/에러 상태 처리
- [ ] `DashboardWidgetSettings`에 `showWeather` 추가 (기본값: `true`)
- [ ] 위젯 설정 화면에 날씨 항목 추가
- [ ] `dashboard_tab.dart`에 `WeatherWidget` 등록

### Phase 3: 날씨 상세 화면

- [ ] `WeatherDetailScreen` (`/weather` 라우트)
  - 현재 날씨 섹션 (대형 아이콘 + 상세 정보)
  - 시간별 예보 수평 스크롤 리스트
  - 날짜별 일기예보 카드 (최저/최고 기온, 강수확률)
  - 위치 새로고침 버튼
- [ ] 라우트 등록 (`app_routes.dart`, `main_routes.dart`)

### Phase 4: UI 디테일

- [ ] 날씨 아이콘 헬퍼 (`sky` + `precipitationType` → 아이콘/색상)
- [ ] 날씨 배경색 — 맑음/흐림/비/눈 테마색 적용
- [ ] 다국어 지원 (한/영/일) — `weather_` prefix

---

## 파일 구조

```
lib/features/weather/
  models/
    weather_model.dart
  repositories/
    weather_repository.dart
  providers/
    weather_provider.dart       # @riverpod 어노테이션 → .g.dart 자동 생성
    location_provider.dart
  presentation/
    screens/
      weather_detail_screen.dart
    widgets/
      weather_widget.dart       # 대시보드용 콤팩트 위젯
      forecast_hour_item.dart   # 시간별 예보 아이템
      forecast_day_card.dart    # 날짜별 예보 카드
```

---

## 위젯 설정 연동

```dart
// DashboardWidgetSettings 추가 필드
final bool showWeather;  // 기본값: true
// widgetOrder에 'weather' 추가
```

---

## 의존성

- `geolocator: ^13.x` — GPS 위치 조회 (이미 사용 중인지 확인 필요)
- `permission_handler: ^11.x` — 위치 권한 처리 (이미 사용 중인지 확인 필요)

---

## 관련 파일 (수정 대상)

- `lib/core/models/dashboard_widget_settings.dart` — `showWeather` 필드 추가
- `lib/core/routes/app_routes.dart` — `/weather` 라우트 상수
- `lib/core/routes/main_routes.dart` — 라우트 등록
- `lib/features/home/presentation/screens/dashboard_tab.dart` — 위젯 등록
- `lib/features/settings/common/presentation/screens/home_widget_settings_screen.dart` — 설정 항목
- `lib/l10n/app_ko.arb`, `app_en.arb`, `app_ja.arb` — 다국어 키
