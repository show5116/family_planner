# 15. 공지사항 (Announcements)

## 상태
✅ 완료

---

## 핵심 개념
시스템 운영자(ADMIN)가 전체 회원에게 중요한 소식을 전달하기 위한 공지사항 시스템입니다.

### 주요 특징
- **ADMIN 전용 작성**: 작성/수정/삭제 권한
- **전체 회원 대상**: 그룹 구분 없이 모든 회원에게 노출
- **고정 기능**: 중요 공지 상단 고정 (pinned)
- **읽음 추적**: 회원별 읽음 여부 및 읽은 사람 수
- **마크다운 지원**: 내용 작성 및 렌더링
- **알림 연동**: 새 공지 시 전체 회원에게 푸시 알림

---

## UI 구현

### 공지사항 목록 화면
- ✅ 공지사항 목록 화면 (전체 화면)
- ✅ 카테고리 필터 칩 (전체/공지사항/이벤트/업데이트)
- ✅ 고정 공지 상단 배치 (핀 아이콘 표시)
- ✅ 읽음/안 읽음 표시 (읽지 않은 공지 강조)
- ✅ 페이지네이션 (무한 스크롤)
- ✅ Pull-to-refresh
- ✅ 빈 상태 화면

### 공지사항 상세 화면
- ✅ 제목, 작성일, 내용 표시
- ✅ 마크다운 렌더링 (flutter_markdown)
- ✅ 자동 읽음 처리 (화면 진입 시)
- ✅ 읽은 사람 수 표시
- ✅ 첨부파일 다운로드/미리보기 (UI 완료, 다운로드 기능 추후 구현)

### 관리자 전용 화면 (ADMIN)
- ✅ 공지사항 작성 화면
  - 제목, 내용 입력 (마크다운)
  - 카테고리 선택 (공지사항/이벤트/업데이트)
  - 고정 여부 토글
  - 미리보기 기능
- ✅ 공지사항 수정 화면
- ✅ 공지사항 삭제 확인 다이얼로그
- ✅ 고정/해제 토글 버튼

### 미구현
- ⬜ 첨부파일 업로드
- ⬜ 홈 화면 뱃지 (읽지 않은 공지 개수)

---

## 데이터 모델

### AnnouncementModel
- ✅ id (String)
- ✅ authorId (String)
- ✅ authorName (String)
- ✅ title (String)
- ✅ content (String) - 마크다운
- ✅ category (AnnouncementCategory?) - announcement/event/update
- ✅ isPinned (bool)
- ✅ attachments (List<Attachment>?)
- ✅ isRead (bool)
- ✅ readCount (int)
- ✅ createdAt (DateTime)
- ✅ updatedAt (DateTime)

---

## 기능 구현

### 공지사항 조회
- ✅ 공지사항 목록 조회 (GET /announcements)
  - 페이지네이션 (page, limit)
  - 카테고리 필터 (category)
  - 고정 공지 우선 정렬
  - 읽음 여부 포함 (isRead)
- ✅ 공지사항 상세 조회 (GET /announcements/:id)
  - 조회 시 자동 읽음 처리
- ✅ 읽지 않은 공지 개수 조회

### 관리자 기능 (ADMIN)
- ✅ 공지사항 작성 (POST /announcements)
  - 작성 후 전체 회원에게 알림 발송
- ✅ 공지사항 수정 (PUT /announcements/:id)
- ✅ 공지사항 삭제 (DELETE /announcements/:id) - Soft Delete
- ✅ 공지사항 고정/해제 (PATCH /announcements/:id/pin)

---

## 구현 위치

- **화면**: `lib/features/announcements/presentation/screens/`
- **Provider**: `lib/features/announcements/providers/`
  - `announcement_list_provider.dart`
  - `announcement_detail_provider.dart`
  - `unread_announcement_count_provider.dart`
- **Repository**: `announcement_repository.dart`
- **Model**: `announcement_model.dart`

---

## API 문서
[docs/api/announcements.md](../api/announcements.md)

---

## 향후 개선
- [ ] 예약 발행
- [ ] 검색 기능
- [ ] 댓글 기능
- [ ] Q&A 연동 (공지사항에서 질문으로 이동)

## 최근 업데이트

### 2026-01-09
- ✅ 카테고리 필터 기능 추가 (전체/공지사항/이벤트/업데이트)
- ✅ AnnouncementCategory enum 추가 및 JsonConverter 구현
- ✅ 대소문자 호환 처리 (백엔드 대문자 요구사항 대응)
- ✅ FilterChip UI로 카테고리 선택
- ✅ 반응형 디자인 (좁은 화면에서 스크롤 가능)
- ✅ 다국어 지원 (한/영/일)
