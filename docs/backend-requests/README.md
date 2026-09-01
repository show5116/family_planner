# 백엔드 요청서

프론트엔드에서 발견한 백엔드 수정 요청을 모아둡니다.

## 작성 규칙

- 파일명: `YYYY-MM-DD-주제.md`
- 반드시 포함할 것
  - **현상** — 사용자에게 어떻게 보이는지
  - **원인** — 백엔드 코드의 어느 부분인지 (파일·줄 번호)
  - **요청** — 기대 동작과 검증 케이스
  - **앱 쪽 대응** — 앱에서 보정할지 말지, 배포 순서

## 목록

| 날짜 | 주제 | 상태 |
|---|---|---|
| 2026-09-01 | [할일 D-Day(`daysUntilDue`) 계산 수정](2026-09-01-task-dday.md) | 요청 |

## 참고 — API 정합성 감사

앱이 호출하는 엔드포인트와 백엔드 컨트롤러 라우트를 대조한 기록입니다.

| 날짜 | 앱 호출 | 백엔드 라우트 | 불일치 |
|---|---|---|---|
| 2026-09-01 | 231 | 338 | **0건** |

2026-09-01 감사에서 발견해 앱에서 제거한 호출:

- `/assets/accounts/:id/holdings` 5개 — 백엔드에 라우트 없음, 앱에서도 미사용
  (실제 포트폴리오는 `holding-records`로 동작)
- `POST /household/budgets`, `budget-templates`, `group-budgets`,
  `group-budget-templates` — 백엔드는 `/bulk` 버전만 제공, UI도 bulk만 사용

감사 방법: 백엔드 `*.controller.ts`의 `@Controller` + `@Get/@Post/...` 조합과
앱의 `_dio.<method>('<path>')` 호출을 경로 파라미터 정규화 후 대조.
한 파일에 `@Controller`가 여럿인 경우(예: `qna.controller.ts`의 `public/qna`와 `qna`)
블록별로 나눠 처리해야 오탐이 없습니다.
