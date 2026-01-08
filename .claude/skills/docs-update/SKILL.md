---
name: docs-update
description: ROADMAP.md, TODO.md, 기능별 문서를 자동으로 업데이트합니다. 기능 상태 변경, 진행률 업데이트, 최근 완료 항목 추가 시 사용하세요.
allowed-tools: Read, Edit, Bash(date:*)
---

# Docs Update Skill

프로젝트 문서를 자동으로 업데이트합니다.

## 업데이트 대상

1. **기능 문서** (`docs/features/*.md`) - 상태 아이콘
2. **TODO.md** - 기능 테이블
3. **ROADMAP.md** - Feature Roadmap, Progress Overview, 최근 완료

## 상태 아이콘

- ⬜ 시작 안함
- 🟨 진행 중
- ✅ 완료
- ⏸️ 보류
- ❌ 취소

## 워크플로우: 기능 완료 시

1. **기능 문서**: `# 15. 공지사항 ✅` + 진행 상황 100%
2. **TODO.md**: `| ✅ | 공지사항 | ... |`
3. **ROADMAP.md Feature Roadmap**: `| 공지사항 | ✅ 완료 | ... |`
4. **ROADMAP.md 최근 완료**: 오늘 날짜로 항목 추가
5. **ROADMAP.md Progress Overview**: 진행률 재계산 + 날짜 갱신

## 핵심 업데이트 패턴

### Progress Overview 형식

```markdown
## 📊 Progress Overview

- **완료**: X/15 기능 (XX%)
- **진행 중**: X/15 기능 (XX%)
- **미시작**: X/15 기능 (XX%)

**마지막 업데이트**: YYYY-MM-DD
```

### 최근 완료 항목 형식

```markdown
## 📈 최근 완료된 기능

### YYYY-MM-DD
- ✅ **기능명** ([문서.md](docs/features/문서.md))
  - 완료 사항 1
  - 완료 사항 2
```

## 주의사항

1. **동기화**: TODO.md, ROADMAP.md, 기능 문서 상태 일치
2. **날짜**: `YYYY-MM-DD` 형식 사용
3. **최신 순**: 최근 완료 항목은 최상단
4. **Read 먼저**: 수정 전 반드시 파일 읽기

상세 예시: [EXAMPLES.md](EXAMPLES.md)
