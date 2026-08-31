# 10. 미니게임 메뉴 ✅

## 상태
✅ 완료

---

## UI 구현
- ✅ 미니게임 메인 화면 (MiniGamesScreen) — 더보기 탭에서 접근
  - 그룹 선택 (선택 시 결과가 서버에 저장되고 그룹원 누구나 이력 확인 가능)
  - 게임 이력 섹션 (같은 화면 내 인라인) — 종류별 필터
  - 첫 진입 코치마크 (게임 선택 · 이력 섹션 안내)
- ✅ 사다리타기 화면 (LadderGameScreen) + 코치마크
- ✅ 룰렛 화면 (RouletteGameScreen) + 코치마크

## 사다리타기
- ✅ 참여 인원 설정 UI
- ✅ 결과 항목 설정 UI
- ✅ 사다리 자동 생성 알고리즘
- ✅ 사다리 애니메이션 효과
- ✅ 결과 표시 (LadderAssignment — 참여자 ↔ 결과 매칭)

## 룰렛 돌리기
- ✅ 항목 추가/삭제 UI
- ✅ 룰렛 회전 애니메이션
- ✅ 결과 표시 애니메이션
- ✅ 항목별 색상 설정

## 데이터 모델
- ✅ `MinigameType` enum — 사다리타기 / 룰렛
- ✅ `LadderAssignment` — 참여자별 결과 매칭
- ✅ `MinigameResult` — 게임 결과 (종류, 참여자, 결과, 생성 시각)
- ✅ `MinigameResultsResponse` — 목록 응답

## 기능 구현
- ✅ 게임 결과 저장 (그룹 선택 시 서버 저장)
- ✅ 게임 이력 조회 (그룹별, 게임 종류별 필터)
- ✅ 게임 이력 삭제

## API 연동
- ✅ `POST /minigames/results` — 게임 결과 저장
- ✅ `GET /minigames/results` — 게임 이력 조회 (그룹·종류 필터)
- ✅ `DELETE /minigames/results/:id` — 이력 삭제

## 상태 관리
- ✅ `minigameSelectedGroupIdProvider` — 선택된 그룹
- ✅ `minigameTypeFilterProvider` — 게임 종류 필터
- ✅ `MinigameResults` (@riverpod) — 이력 목록
- ✅ `MinigameManagementNotifier` — 저장·삭제 액션

---

## 관련 파일
```
lib/features/minigame/
├── data/
│   ├── models/minigame_model.dart
│   └── repositories/minigame_repository.dart
├── providers/minigame_provider.dart
└── presentation/screens/
    ├── mini_games_screen.dart      ← 메인 + 이력 섹션
    ├── ladder_game_screen.dart
    ├── roulette_game_screen.dart
    └── _ladder_onboarding.dart, _roulette_onboarding.dart
```

## API 문서
[docs/api/minigames.md](../api/minigames.md)

## 노트
- 게임 진행(사다리 생성·룰렛 회전)은 클라이언트에서 처리하고,
  **결과만 서버에 저장**해 그룹원이 함께 이력을 볼 수 있게 합니다.
- 그룹을 선택하지 않으면 결과가 저장되지 않고 그 자리에서만 확인합니다.
