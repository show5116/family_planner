---
name: api-sync
description: 백엔드 API 문서와 프론트엔드 코드의 동기화를 확인합니다. API 변경 감지, 엔드포인트 누락 확인, 모델 일치 검증 시 사용하세요.
allowed-tools: Read, Grep, Glob
---

# API Sync Skill

백엔드 API 문서(`docs/api/*.md`)와 프론트엔드 코드 동기화 확인합니다.

## 검증 항목

1. **엔드포인트 일치**: API 문서 ↔ Repository 메서드
2. **모델 일치**: API 응답 스키마 ↔ Model 필드
3. **DTO 일치**: API 요청 스키마 ↔ DTO 필드
4. **파라미터 전달**: Query/Path 파라미터
5. **권한 확인**: 인증/권한 요구사항

## 워크플로우

1. **API 문서 파싱**: `docs/api/{feature}.md` 읽기
2. **프론트엔드 분석**: Repository, Model, DTO 확인
3. **비교 검증**: 각 항목별 일치 여부
4. **리포트 생성**: ✅/⚠️/❌ 결과

## 리포트 형식

```markdown
# API Sync Report

**기능**: 공지사항
**동기화 상태**: ⚠️ 부분 동기화 (3/5)

## 엔드포인트 일치: ⚠️ 3/5

### ✅ 구현됨
- GET `/announcements` → `getAnnouncements()`
- GET `/announcements/:id` → `getAnnouncement(id)`
- POST `/announcements` → `createAnnouncement(dto)`

### ❌ 누락됨
- PATCH `/announcements/:id` → 권장: `updateAnnouncement(id, dto)`
- DELETE `/announcements/:id` → 권장: `deleteAnnouncement(id)`

## 모델 일치: ✅ 완전 일치

## 요약
- ✅ 통과: 4/5
- ⚠️ 개선: 1/5
```

## 타입 매핑

| API | Flutter |
|-----|---------|
| string | String |
| number | int/double |
| boolean | bool |
| Date | DateTime |
| array | List<T> |
| enum | enum |

상세 예시: [EXAMPLES.md](EXAMPLES.md)
