# 4. 투자지표 메뉴

## 상태
✅ 완료

---

## 구현 위치
- 모델: `lib/features/main/investment/data/models/indicator_model.dart`
- Repository: `lib/features/main/investment/data/repositories/indicator_repository.dart`
- Provider: `lib/features/main/investment/providers/indicator_provider.dart`
- 목록 화면: `lib/features/main/investment/presentation/screens/investment_indicators_screen.dart`
- 상세 화면: `lib/features/main/investment/presentation/screens/indicator_detail_screen.dart`
- 대시보드 위젯: `lib/features/home/presentation/widgets/investment_summary_widget.dart`

---

## UI 구현
- ✅ 투자지표 목록 화면 (즐겨찾기/전체 섹션 분리)
- ✅ 지표 타일 위젯 (이름, 심볼, 변동률, 스파크라인, 가격, 즐겨찾기 버튼)
- ✅ 스파크라인 미니 차트 (당일 히스토리 기반)
- ✅ 지표 상세 화면 (시세 요약 카드 + 시계열 라인 차트)
- ✅ 즐겨찾기 드래그 정렬 (ReorderableListView, 길게 눌러 순서 변경)
- ✅ 대시보드 즐겨찾기 위젯 (InvestmentSummaryWidget)
- ✅ 관리자 전용 과거 데이터 초기화 다이얼로그

## 제공 지표
- ✅ 백엔드에서 지표 목록 동적 제공 (KOSPI, NASDAQ, 금, 환율, VIX, 버핏지수 등)
- ✅ 금 현물 (GOLD_KRW_SPOT) — 이격률(국제 환산가 대비 프리미엄/디스카운트) 전용 지원

## 기능 구현
- ✅ 즐겨찾기 등록/해제 (낙관적 업데이트)
- ✅ 즐겨찾기 순서 변경 (드래그 앤 드롭, 서버 저장)
- ✅ 시세 시계열 차트 (7일/30일/90일/180일/1년, fl_chart)
- ✅ 차트 드래그 범위 선택 → 기간 등락률 요약 바
- ✅ 상승/하락 색상 표시 (초록/빨강)
- ✅ 금 현물 이격률 차트 (별도 섹션, 0% 기준선)
- ✅ Pull-to-refresh 새로고침

## API 연동
- ✅ `GET /indicators` — 전체 지표 목록 + 최신 시세
- ✅ `GET /indicators/bookmarks` — 즐겨찾기 목록
- ✅ `GET /indicators/:symbol` — 지표 상세
- ✅ `GET /indicators/:symbol/history` — 시세 히스토리 (days 파라미터)
- ✅ `POST /indicators/:symbol/bookmark` — 즐겨찾기 등록
- ✅ `DELETE /indicators/:symbol/bookmark` — 즐겨찾기 해제
- ✅ `PATCH /indicators/bookmarks/reorder` — 즐겨찾기 순서 변경
- ✅ `POST /indicators/admin/init-history` — 과거 데이터 일괄 초기화 (어드민)

## 상태 관리
- ✅ `IndicatorsNotifier` (`indicatorsProvider`) — 전체 목록, 즐겨찾기 토글, 순서 변경
- ✅ `BookmarkedIndicatorsNotifier` (`bookmarkedIndicatorsProvider`) — 대시보드 위젯용
- ✅ `indicatorHistoryProvider` — 시계열 히스토리 (symbol + days 패밀리)
- ✅ `indicatorSparklineProvider` — 스파크라인용 당일 데이터
- ✅ `initIndicatorHistoryProvider` — 어드민 과거 데이터 초기화
