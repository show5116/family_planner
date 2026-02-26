# 9. 메모 메뉴

## 상태
🟨 진행 중

---

## 구현 위치
- 모델: `lib/features/memo/data/models/memo_model.dart`
- DTO: `lib/features/memo/data/dto/memo_dto.dart`
- Repository: `lib/features/memo/data/repositories/memo_repository.dart`
- Provider: `lib/features/memo/providers/memo_provider.dart`
- 목록 화면: `lib/features/memo/presentation/screens/memo_list_screen.dart`
- 상세 화면: `lib/features/memo/presentation/screens/memo_detail_screen.dart`
- 작성/수정 화면: `lib/features/memo/presentation/screens/memo_form_screen.dart`
- 위젯: `lib/features/memo/presentation/widgets/`

---

## UI 구현
- ✅ 메모 목록 화면 (하단 네비게이션 탭 또는 더보기 탭에서 접근)
- ✅ 메모 상세 화면 (카테고리, 제목, 작성자, 수정일, 태그, 내용 표시)
- ✅ 메모 작성/수정 화면 (제목, 카테고리, 태그, 리치텍스트 에디터)
- ✅ 메모 카드 위젯
- ✅ 태그 칩 위젯 (MemoTagChips, MemoTagInput)
- ✅ 메모 삭제 다이얼로그
- ⬜ 체크리스트 UI (메모 상세, 작성/수정 화면)

## 데이터 모델
- ✅ MemoModel (id, title, content, format, category, visibility, groupId, user, tags, attachments, createdAt, updatedAt)
- ✅ MemoAuthor, MemoTag, MemoAttachment
- ✅ MemoFormat enum (TEXT, MARKDOWN, HTML)
- ✅ MemoVisibility enum (PRIVATE, FAMILY, GROUP)
- ⬜ MemoType enum (NOTE, CHECKLIST) — API에 있으나 모델 미반영
- ⬜ ChecklistItem 모델 (id, content, isChecked, order, createdAt, updatedAt)

## 기능 구현
- ✅ 메모 목록 조회 (무한 스크롤, 페이지네이션)
- ✅ 메모 검색 (제목/내용)
- ✅ 카테고리 필터
- ✅ 메모 생성/수정/삭제
- ✅ 리치텍스트 에디터 (RichTextEditor 위젯)
- ✅ 태그 추가/관리
- ⬜ 체크리스트 타입 메모 생성 (type=CHECKLIST)
- ⬜ 체크리스트 항목 추가/수정/삭제
- ⬜ 체크리스트 항목 체크/해제 토글
- ⬜ 체크리스트 전체 초기화

## API 연동
- ✅ `GET /memos` — 메모 목록 조회
- ✅ `GET /memos/:id` — 메모 상세 조회
- ✅ `POST /memos` — 메모 생성
- ✅ `PATCH /memos/:id` — 메모 수정
- ✅ `DELETE /memos/:id` — 메모 삭제
- ⬜ `POST /memos/:id/checklist` — 체크리스트 항목 추가
- ⬜ `PATCH /memos/:id/checklist/:itemId` — 항목 내용/순서 수정
- ⬜ `DELETE /memos/:id/checklist/:itemId` — 항목 삭제
- ⬜ `POST /memos/:id/checklist/:itemId/toggle` — 항목 체크 토글
- ⬜ `POST /memos/:id/checklist/reset` — 전체 체크 해제

## 상태 관리
- ✅ MemoList Provider (무한 스크롤, 검색, 카테고리 필터, afterCreate/Update/Delete)
- ✅ MemoDetail Provider
- ✅ MemoManagementNotifier (생성/수정/삭제)
- ⬜ ChecklistNotifier (체크리스트 항목 CRUD + 토글)

---

## 체크리스트 기능 구현 계획

### 데이터 모델 변경
1. `memo_model.dart`에 `MemoType` enum 및 `ChecklistItem` 모델 추가
2. `MemoModel`에 `type`, `checklistItems` 필드 추가
3. `memo_model.freezed.dart`, `memo_model.g.dart` 재생성

### DTO 변경
- `CreateMemoDto`에 `type` 필드 추가
- `ChecklistItemDto` 추가 (content, order)

### Repository 추가
- `addChecklistItem(memoId, content, order)`
- `updateChecklistItem(memoId, itemId, content, order)`
- `deleteChecklistItem(memoId, itemId)`
- `toggleChecklistItem(memoId, itemId)`
- `resetChecklist(memoId)`

### Provider 추가
- `ChecklistNotifier` — 상세 화면에서 항목 CRUD 관리

### UI 변경
- `memo_form_screen.dart`: 메모 타입 선택 (일반 / 체크리스트), 체크리스트 타입 선택 시 에디터 대신 체크리스트 입력 UI 표시
- `memo_detail_screen.dart`: type=CHECKLIST일 때 체크리스트 뷰 표시 (항목 토글, 추가, 삭제, 전체 초기화)
- `memo_card.dart`: 체크리스트 타입 카드에 진행률 표시

### 다국어
- 체크리스트 관련 문자열 ARB 추가
