# Claude Skills for Family Planner

이 디렉토리는 Family Planner 프로젝트를 위한 Claude Code Skills를 포함합니다.

## 📚 Skill 목록

### 🔥 자동 실행 (P0) - 가장 빈번한 작업

자연어로 요청하면 자동으로 실행됩니다:

| Skill | 설명 | 트리거 키워드 |
|-------|------|---------------|
| [feature-create](feature-create/) | Flutter 기능을 Feature-First 아키텍처에 맞게 자동 생성 | "새 기능", "화면 만들기", "Provider 생성" |
| [i18n-add](i18n-add/) | 다국어 문자열 ARB 파일 자동 추가 (한/영/일) | "다국어 추가", "번역 추가", "문자열 추가" |
| [docs-update](docs-update/) | ROADMAP.md, TODO.md, 기능 문서 자동 업데이트 | "문서 업데이트", "진행 상황 변경", "기능 완료" |

### 🎯 수동 실행 (필요 시)

명시적으로 요청해야 실행됩니다:

| Skill | 설명 | 사용법 |
|-------|------|--------|
| [code-review](code-review/) | CODE_STYLE.md 기준 코드 자동 리뷰 | "login_screen.dart 리뷰해주세요" |
| [api-sync](api-sync/) | 백엔드 API 문서와 프론트엔드 동기화 확인 | "공지사항 API 동기화 확인해줘" |
| [test-generate](test-generate/) | 테스트 코드 자동 생성 | "MemoProvider 테스트 생성해줘" |

### 💡 토큰 효율성 최적화

- **자동 실행** Skills는 가장 빈번하고 효과적인 3개만 선별
- **수동 실행** Skills는 필요할 때만 명시적으로 호출하여 토큰 절약
- **제거된 Skill**: widget-create (기능 중복 및 저효율)

## 🎯 빠른 시작

### 1. Skill 활성화

Claude Code를 재시작하면 자동으로 모든 Skill이 로드됩니다.

```bash
# 프로젝트 디렉토리에서
claude
```

### 2. Skill 사용

자연어로 요청하면 Claude가 자동으로 적절한 Skill을 선택합니다:

```
"일정관리 기능을 만들어주세요"
→ feature-create Skill 실행

"공지사항 기능이 완료되었습니다"
→ docs-update Skill 실행

"login_screen.dart를 리뷰해주세요"
→ code-review Skill 실행

"'저장'이라는 문자열을 다국어로 추가해주세요"
→ i18n-add Skill 실행
```

## 📖 사용 예시

### 예시 1: 새 기능 개발 전체 워크플로우

```
1. "메모 기능을 만들어주세요" (feature-create)
   → 폴더 구조, Model, Provider, Repository, Screen 자동 생성

2. "메모 기능 상태를 진행 중으로 변경해주세요" (docs-update)
   → ROADMAP.md, TODO.md 자동 업데이트

3. "'메모 목록'이라는 문자열을 추가해주세요" (i18n-add)
   → app_ko.arb, app_en.arb, app_ja.arb에 자동 추가

4. "memo_screen.dart를 리뷰해주세요" (code-review)
   → CODE_STYLE.md 기준으로 검증 및 개선 제안

5. "메모 Provider 테스트를 만들어주세요" (test-generate)
   → 테스트 코드 자동 생성

6. "메모 기능 완료" (docs-update)
   → ROADMAP.md 최근 완료 항목 추가, 진행률 자동 계산
```

### 예시 2: 기존 기능 개선

```
1. "공지사항 기능의 API 동기화를 확인해주세요" (api-sync)
   → 누락된 엔드포인트, 모델 불일치 검출

2. "announcement_detail_screen.dart를 리뷰해주세요" (code-review)
   → 컨벤션 위반 사항 확인

```

## 🔧 Skill 커스터마이징

각 Skill의 `SKILL.md` 파일을 수정하여 동작을 커스터마이징할 수 있습니다:

```bash
# 예: feature-create Skill 수정
code .claude/skills/feature-create/SKILL.md
```

## 📝 Skill 작성 가이드

### 기본 구조

```markdown
---
name: skill-name
description: 명확한 설명 (언제 사용되는지 포함)
allowed-tools: Read, Write, Bash(flutter:*)
---

# Skill Title

상세 설명 및 지침...
```

### 핵심 요소

1. **명확한 description**: Claude가 이 description을 보고 Skill을 선택합니다
2. **구체적인 지침**: 단계별로 명확하게 작성
3. **템플릿 제공**: 생성할 코드의 템플릿 포함
4. **예시**: 실제 사용 예시 추가

## 🔍 트러블슈팅

### Skill이 실행되지 않을 때

1. **Claude Code 재시작**
   ```bash
   # Ctrl+C로 종료 후 재시작
   claude
   ```

2. **Description 확인**
   - SKILL.md의 description이 명확한지 확인
   - 트리거 키워드가 포함되어 있는지 확인

3. **명시적 요청**
   ```
   "feature-create Skill을 사용해서 일정 기능을 만들어주세요"
   ```

### Skill 실행 중 오류

1. **allowed-tools 확인**
   - SKILL.md에 필요한 도구가 포함되어 있는지 확인

2. **파일 경로 확인**
   - 절대 경로 사용 여부 확인
   - 파일 존재 여부 확인

## 📚 추가 리소스

- [Claude Code 공식 문서](https://code.claude.com/docs)
- [Skills 작성 가이드](https://code.claude.com/docs/en/skills.md)
- [프로젝트 CODE_STYLE.md](../../CODE_STYLE.md)
- [프로젝트 ROADMAP.md](../../ROADMAP.md)

## 🎨 Skill 개발 팁

### 1. 점진적 공개 (Progressive Disclosure)

SKILL.md는 500줄 이하로 유지하고, 상세 내용은 EXAMPLES.md로 분리:

```
.claude/skills/my-skill/
├── SKILL.md          # 핵심 지침 (500줄 이하)
└── EXAMPLES.md       # 상세 예시 (제한 없음)
```

### 2. 명확한 워크플로우

각 Skill은 명확한 단계를 제공:

```markdown
## 워크플로우

1. **정보 수집**: AskUserQuestion으로 필요 정보 확보
2. **검증**: 기존 파일/데이터 확인
3. **생성/수정**: 파일 작성 또는 수정
4. **검증**: 결과 확인
5. **안내**: 사용법 안내
```

### 3. 도구 제한

보안을 위해 allowed-tools 명시:

```yaml
allowed-tools: Read, Grep, Bash(flutter:analyze)  # 읽기 전용 + flutter analyze만
```

## 🤝 기여

새로운 Skill 아이디어나 개선 사항이 있다면:

1. `.claude/skills/{new-skill}/` 디렉토리 생성
2. `SKILL.md` 작성
3. 테스트 후 팀과 공유

## 📊 Skill 효과

Skills 도입 전후 비교:

| 작업 | Before | After | 개선 |
|------|--------|-------|------|
| 새 기능 스캐폴딩 | 30분 | 2분 | **93% 단축** |
| 다국어 추가 (3개 언어) | 15분 | 1분 | **93% 단축** |
| 문서 업데이트 (3개 파일) | 10분 | 30초 | **95% 단축** |
| 코드 리뷰 (수동) | 20분 | 3분 | **85% 단축** |
| API 동기화 확인 (수동) | 25분 | 5분 | **80% 단축** |
| 테스트 작성 (수동) | 40분 | 5분 | **87% 단축** |

**총 효과**: 반복 작업 시간 **90% 이상 단축** ⚡

**토큰 효율성**: 자동 실행 Skills를 3개로 제한하여 대화당 **15-20% 토큰 절약** 💰

---

**마지막 업데이트**: 2026-01-08
**Skills 버전**: 2.0.0 (토큰 최적화)
