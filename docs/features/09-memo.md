# 9. 메모 메뉴 ✅

## 상태
✅ 완료

---

## 구현 위치
- 모델: `lib/features/memo/data/models/memo_model.dart`, `link_preview_model.dart`
- DTO: `lib/features/memo/data/dto/memo_dto.dart`
- 변환 유틸: `lib/features/memo/data/utils/memo_editor_converter.dart` (Delta ↔ 표시용)
- Repository: `lib/features/memo/data/repositories/memo_repository.dart`, `link_preview_repository.dart`
- Provider: `lib/features/memo/providers/memo_provider.dart`
- 목록 화면: `lib/features/memo/presentation/screens/memo_list_screen.dart`
- 상세 화면: `lib/features/memo/presentation/screens/memo_detail_screen.dart`
- 작성/수정 화면: `lib/features/memo/presentation/screens/memo_form_screen.dart`
- 위젯: `memo_card.dart`, `memo_tag_chips.dart`, `memo_editor_toolbar.dart`,
  `memo_delete_dialog.dart`, `link_preview_embed.dart`
- 공용 에디터: `lib/shared/widgets/editor/rich_text_editor.dart` (flutter_quill)
- 대시보드 위젯: `lib/features/home/presentation/widgets/memo_summary_widget.dart`

---

## UI 구현
- ✅ 메모 목록 화면 (하단 네비게이션 탭 또는 더보기 탭에서 접근)
- ✅ 메모 상세 화면 (제목, 작성자, 수정일, 태그, 내용)
- ✅ 메모 작성/수정 화면 (제목, 태그, 리치텍스트 에디터)
- ✅ 메모 카드 위젯 (체크리스트 진행률 표시 포함)
- ✅ 태그 칩 위젯 (MemoTagChips)
- ✅ 메모 삭제 다이얼로그
- ✅ 메모 상세 AppBar 핀 토글 버튼 (push_pin / push_pin_outlined)
- ✅ 리치텍스트 에디터 툴바 (MemoEditorToolbar)
- ✅ 링크 미리보기 임베드 (LinkPreviewEmbed)
- ✅ 대시보드 메모 위젯 (MemoSummaryWidget)
- ✅ 첫 진입 코치마크 (_memo_list_onboarding)

## 데이터 모델
- ✅ MemoModel (id, title, content, format, visibility, isPinned, groupId, user,
  tags, attachments, checklistMeta, createdAt, updatedAt)
- ✅ MemoAuthor, MemoTag, MemoAttachment
- ✅ ChecklistMeta (total, checked) — 체크리스트 진행률 카운트
- ✅ MemoFormat enum — **PLAIN, MARKDOWN, HTML, DELTA** (서버 스키마와 동일)
- ✅ MemoVisibility enum — **PRIVATE, GROUP**
- ✅ LinkPreviewModel — 링크 미리보기 메타데이터

## 기능 구현
- ✅ 메모 목록 조회 (무한 스크롤, 페이지네이션)
- ✅ 메모 검색 (제목/내용)
- ✅ 태그 필터
- ✅ 메모 생성/수정/삭제
- ✅ 리치텍스트 편집 (flutter_quill, DELTA 포맷으로 저장)
- ✅ 체크리스트 — Quill의 체크리스트 블록으로 작성하고,
  진행률(checked/total)을 `checklistMeta`로 서버에 함께 전송
- ✅ 체크리스트 전체 선택 / 전체 해제
- ✅ 태그 추가/관리
- ✅ 메모 핀 고정/해제 토글 (대시보드 위젯 연동)
- ✅ 링크 붙여넣기 시 미리보기 카드 자동 생성
- ✅ 이미지 임베드 (ImageEmbedBuilder)
- ✅ 동시 편집 잠금 — 편집 진입 시 잠금 획득, 30초 주기 heartbeat, 이탈 시 해제

## API 연동
- ✅ `GET /memos` — 메모 목록 조회 (검색·태그·그룹 필터, 페이지네이션)
- ✅ `GET /memos/tags` — 태그 목록 조회
- ✅ `GET /memos/pinned` — 핀된 메모 목록 (대시보드 위젯용)
- ✅ `GET /memos/:id` — 메모 상세 조회
- ✅ `POST /memos` — 메모 생성
- ✅ `PATCH /memos/:id` — 메모 수정
- ✅ `DELETE /memos/:id` — 메모 삭제
- ✅ `POST /memos/:id/pin` — 메모 핀 토글
- ✅ `POST /memos/:id/lock` — 편집 잠금 획득
- ✅ `DELETE /memos/:id/lock` — 편집 잠금 해제
- ✅ `POST /memos/:id/lock/heartbeat` — 잠금 유지 (편집 중 30초 주기)
- ✅ 링크 미리보기 조회 ([docs/api/link-preview.md](../api/link-preview.md))

## 상태 관리
- ✅ MemoList Provider (무한 스크롤, 검색, 태그 필터, afterCreate/Update/Delete)
- ✅ MemoDetail Provider
- ✅ MemoManagementNotifier (생성/수정/삭제)
- ✅ pinnedMemosProvider (핀된 메모 목록)
- ✅ MemoPinNotifier / memoPinProvider (핀 토글, 목록/상세 자동 갱신)

---

## API 문서
[docs/api/memos.md](../api/memos.md)

## 패키지
- `flutter_quill` — 리치텍스트 에디터 (DELTA JSON 저장)

## 노트
- 본문은 Quill **DELTA JSON 문자열**로 저장합니다. `format` 필드가 DELTA면
  에디터로 렌더링하고, 그 외(PLAIN 등)는 평문으로 표시합니다.
- 체크리스트는 별도 API가 아니라 Delta 문서 안의 체크리스트 블록입니다.
  진행률만 `checklistMeta`로 따로 보내 목록·카드에서 카운트를 보여줍니다.
- 편집 잠금은 같은 메모를 두 사람이 동시에 고치는 것을 막기 위한 것으로,
  heartbeat가 끊기면 서버에서 잠금이 만료됩니다.
