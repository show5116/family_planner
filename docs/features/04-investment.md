# 4. 투자지표 메뉴

## 상태
✅ 완료

---

## 구현 위치
- 모델: `lib/features/main/investment/data/models/indicator_model.dart`
- 브리핑 모델: `lib/features/main/investment/data/models/market_briefing_model.dart`
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
- ✅ AI 마켓 브리핑 카드 — 거시경제 / 국내 증시 / 해외 증시 요약
  - 카드를 탭하면 펼쳐져 본문과 갱신 시각이 나옵니다
  - 세 값이 모두 null이면 섹션을 그리지 않습니다.
    **프로덕션은 정상 동작**하고, 개발 서버만 전부 null이라 스크린샷에 안 잡힙니다
- ⚠️ **매크로 브리핑 본문이 오류 메시지로 저장돼 있습니다** (2026-09-09 프로덕션 확인)
  - `GET /ai/market-briefing`의 `macro.content`가
    `죄송합니다. 요청을 처리하는 중에 문제가 발생했습니다.` 입니다
  - 국내 시장·글로벌 시장은 정상입니다. 생성에 실패한 응답이 그대로 저장돼
    사용자에게 노출되는 상태로, 생성 실패 시 저장하지 않도록 막는 편이 좋습니다
- ✅ 첫 진입 코치마크 (_investment_indicators_onboarding)

## 제공 지표
- ✅ 백엔드에서 지표 목록 동적 제공 (KOSPI, NASDAQ, 금, 환율, VIX, 버핏지수 등) — 24종
- ⚠️ 프로덕션에서 수집이 멈췄던 지표 3종 (2026-09-08 확인 · 백엔드 수정함, 미배포)
  - 러셀 2000(RUSSELL2000) 약 183일, 천연가스(NAT_GAS)·밀(WHEAT) 약 154일째 미수집이었습니다
  - 원인: 세 심볼이 마이그레이션(`20260305000000_add_russell_natgas_wheat`)으로 DB에는 들어갔고
    `YAHOO_SYMBOLS`에도 있어 시세는 정상 수집되지만, `investment.service.ts`의
    **`INDICATORS` 상수에 빠져 있었습니다.** `onModuleInit`이 이 상수로만
    `indicatorIdCache`를 채우고, `savePrice`가 캐시 미스면 **조용히 return** 해서
    저장 단계에서 전부 버려졌습니다
  - 과거 데이터가 있었던 건 `init-history`(백필)가 캐시 대신 DB에서 id를 직접 찾기 때문입니다.
    백필은 **30일 초과 구간만** 저장하므로 최신 값은 영영 안 들어옵니다
  - 조치: 세 심볼을 `INDICATORS`에 추가 + 캐시 미스 시 warn 로그 추가
  - 배포 후 최근 30일은 실시간 수집으로 채워지고, 그 이전 공백은 `init-history` 실행이 필요합니다
- ✅ 금 현물 (GOLD_KRW_SPOT) — 이격률(국제 환산가 대비 프리미엄/디스카운트) 전용 지원

## 기능 구현
- ✅ 즐겨찾기 등록/해제 (낙관적 업데이트)
- ✅ 즐겨찾기 순서 변경 (드래그 앤 드롭, 서버 저장)
- ✅ 시세 시계열 차트 (1일/7일/30일/90일/180일/1년, fl_chart · 기본 30일)
- ✅ 차트 드래그 범위 선택 → 기간 등락률 요약 바
- ✅ 상승/하락 색상 표시 (초록/빨강)
- ⚠️ 금 현물 이격률 차트 (별도 섹션, 0% 기준선) — 앱 구현은 정상이나 **서버가 데이터를 안 줍니다.**
  프로덕션 실측(2026-09-08, test-owner 조회 전용):
  | 기간 | history | spreadHistory |
  |---|---|---|
  | 1일 | 32 | 0건 |
  | 7일 | 160 | 32건 |
  | 30일 | 41 | 39건 |
  | 90·180·365일 | 62·133·256 | **키 없음** |
  - 원인 ①: `findHistory`가 `days > 30`이면 `findHistoryFromYahoo`로 곧장 빠지는데 그 경로에 이격률 계산이 없습니다
  - 원인 ②: `days <= 7`은 현물이 분 단위·국제금/환율이 시간 단위 버킷이라 정각 수집분만 매칭됩니다
  - 백엔드 `investment.service.ts`에 두 건 모두 수정해 두었습니다 (미배포). 이격률 **배지**는 정상
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
- ✅ `GET /ai/market-briefing` — AI 마켓 브리핑 (거시/국내/해외)

## 상태 관리
- ✅ `IndicatorsNotifier` (`indicatorsProvider`) — 전체 목록, 즐겨찾기 토글, 순서 변경
- ✅ `BookmarkedIndicatorsNotifier` (`bookmarkedIndicatorsProvider`) — 대시보드 위젯용
- ✅ `indicatorHistoryProvider` — 시계열 히스토리 (symbol + days 패밀리)
- ✅ `indicatorSparklineProvider` — 스파크라인용 당일 데이터
- ✅ `initIndicatorHistoryProvider` — 어드민 과거 데이터 초기화
- ✅ `marketBriefingProvider` — AI 마켓 브리핑
