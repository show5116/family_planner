# 18. 투표 (Votes)

## 상태
🟨 진행 중

---

## 핵심 개념
가족 구성원들이 의사결정을 함께 하기 위한 투표 시스템입니다.
"이번 주말 뭐 먹을까?", "여행지 어디로 갈까?" 같은 일상적인 가족 결정에 활용합니다.

### 주요 특징
- **그룹 기반**: 그룹 단위로 투표 생성/참여
- **단일/복수 선택**: `isMultiple` 옵션으로 복수 선택 허용 가능
- **익명 투표**: `isAnonymous` 옵션으로 투표자 이름 숨김
- **마감 시간**: `endsAt` 설정으로 자동 마감 (미설정 시 수동 종료)
- **실시간 결과**: 투표 후 즉시 결과(득표 수, 투표자 목록) 표시
- **투표 취소**: 진행 중인 투표는 취소 가능 (재투표 가능)

---

## UI 구현

### 투표 목록 화면 (`VoteListScreen`)
- ✅ 그룹 선택 드롭다운 (그룹 미선택 시 안내)
- ✅ 상태 필터 탭 (전체 / 진행중 / 종료됨)
- ✅ 투표 카드 (제목, 작성자, 진행중/종료 뱃지, 참여자 수, 내 참여 여부, 마감 시각)
- ⬜ 무한 스크롤 (페이지네이션)
- ✅ Pull-to-refresh
- ✅ 빈 상태 화면
- ✅ FAB — 새 투표 만들기

### 투표 상세 화면 (`VoteDetailScreen`)
- ✅ 제목, 설명, 작성자 표시
- ✅ 마감 시각 표시 (없으면 미표시)
- ✅ 익명/복수 선택 여부 메타칩
- ✅ 선택지 목록
  - 진행중: 선택 가능한 버튼 형태
  - 투표 후 / 종료됨: 결과 바 (득표수/비율) 형태
  - 내가 선택한 항목 강조
- ✅ 투표하기 버튼 (미참여 시) / 투표 취소 버튼 (참여 후)
- ✅ 투표자 목록 (익명 투표 시 미표시)
- ✅ 작성자/관리자 전용: 투표 삭제

### 투표 생성 화면 (`VoteCreateScreen`)
- ✅ 제목 입력 (필수)
- ✅ 설명 입력 (선택)
- ✅ 선택지 입력 (최소 2개, 동적 추가/삭제)
- ✅ 복수 선택 허용 토글
- ✅ 익명 투표 토글
- ✅ 마감 시각 설정 (DateTimePicker, 선택)
- ✅ 생성 버튼

---

## 데이터 모델

### VoteModel
- id (String)
- groupId (String)
- title (String)
- description (String?)
- isMultiple (bool)
- isAnonymous (bool)
- endsAt (DateTime?)
- isOngoing (bool)
- totalVoters (int)
- hasVoted (bool)
- creatorName (String)
- createdAt (DateTime)
- options (List\<VoteOptionModel\>)

### VoteOptionModel
- id (String)
- label (String)
- count (int)
- isSelected (bool)
- voters (List\<String\>) — 익명 투표 시 빈 배열

### CreateVoteDto
- title (String)
- description (String?)
- isMultiple (bool?)
- isAnonymous (bool?)
- endsAt (String?) — ISO 8601
- options (List\<String\>) — 최소 2개

---

## 기능 구현

### 투표 조회
- ✅ 투표 목록 (GET /votes/:groupId)
  - 상태 필터 (status: VoteStatusFilter)
  - 페이지네이션 (page, limit)
- ✅ 투표 상세 (GET /votes/:groupId/:voteId)

### 투표 관리
- ✅ 투표 생성 (POST /votes/:groupId)
- ✅ 투표 삭제 (DELETE /votes/:groupId/:voteId) — 작성자/관리자

### 투표 참여
- ✅ 투표하기 (POST /votes/:groupId/:voteId/ballots)
  - optionIds 배열 (단일: 1개, 복수: 여러 개)
- ✅ 투표 취소 (DELETE /votes/:groupId/:voteId/ballots)

---

## 구현 위치

- **화면**: `lib/features/votes/presentation/screens/`
  - `vote_list_screen.dart`
  - `vote_detail_screen.dart`
  - `vote_create_screen.dart`
- **Provider**: `lib/features/votes/providers/`
  - `vote_list_provider.dart`
  - `vote_detail_provider.dart`
- **Repository**: `lib/features/votes/data/repositories/vote_repository.dart`
- **Model**: `lib/features/votes/data/models/vote_model.dart`
- **라우트**: `lib/core/routes/app_routes.dart` + `main_routes.dart`
- **진입점**: `lib/features/settings/common/presentation/screens/more_tab.dart`

---

## API 문서
[docs/api/votes.md](../api/votes.md)
