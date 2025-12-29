# 15. 공지사항 (Announcements)

## 상태
⬜ 시작 안함

---

## 핵심 개념
시스템 운영자(ADMIN)가 전체 회원에게 중요한 소식을 전달하기 위한 공지사항 시스템입니다. 버전 업그레이드, 신기능 안내, 비즈니스 모델 변경 등 플랫폼 전체에 영향을 미치는 내용을 공지합니다.

### 주요 특징
- **운영자 전용 작성**: ADMIN 역할만 작성/수정/삭제 가능
- **전체 회원 대상**: 그룹 구분 없이 모든 회원에게 노출
- **고정 기능**: 중요한 공지를 상단에 고정 (pinned)
- **파일 첨부**: 이미지/문서 첨부 지원
- **알림 연동**: 새 공지 등록 시 전체 회원에게 푸시 알림 발송
- **읽음 확인**: 회원별 읽음 여부 추적

---

## UI 구현

### 공지사항 목록 화면
- [ ] 공지사항 목록 화면 (전체 화면)
- [ ] 고정 공지 상단 배치 (핀 아이콘 표시)
- [ ] 읽음/안 읽음 표시 (읽지 않은 공지 강조)
- [ ] 페이지네이션 (무한 스크롤)
- [ ] Pull-to-refresh
- [ ] 빈 상태 화면 (공지사항 없을 때)

### 공지사항 상세 화면
- [ ] 제목, 작성일, 내용 표시
- [ ] 첨부파일 다운로드/미리보기
- [ ] 마크다운 렌더링 지원
- [ ] 자동 읽음 처리 (화면 진입 시)
- [ ] 읽은 사람 수 표시

### 관리자 전용 화면 (ADMIN만 접근)
- [ ] 공지사항 작성 화면
  - [ ] 제목, 내용 입력 (마크다운 에디터)
  - [ ] 고정 여부 토글
  - [ ] 첨부파일 업로드
  - [ ] 미리보기 기능
- [ ] 공지사항 수정 화면
- [ ] 공지사항 삭제 확인 다이얼로그
- [ ] 고정/해제 토글 버튼

### 홈 화면 연동
- [ ] 새 공지 알림 뱃지 (읽지 않은 공지 개수)
- [ ] 고정 공지 미리보기 카드 (옵션)

---

## 데이터 모델

### AnnouncementModel
- [ ] id (String)
- [ ] authorId (String)
- [ ] authorName (String) - 작성자 이름
- [ ] title (String)
- [ ] content (String) - 마크다운 지원
- [ ] isPinned (bool)
- [ ] attachments (List<Attachment>?)
- [ ] isRead (bool) - 내가 읽었는지 여부
- [ ] readCount (int) - 읽은 사람 수
- [ ] createdAt (DateTime)
- [ ] updatedAt (DateTime)

### Attachment
- [ ] url (String)
- [ ] name (String)
- [ ] size (int)

---

## Provider 구현

### 공지사항 목록
- [ ] AnnouncementListProvider (AsyncNotifier)
  - 공지사항 목록 조회 (고정 우선 정렬)
  - 페이지네이션 지원
  - 고정 공지만 조회 옵션

### 공지사항 상세
- [ ] AnnouncementDetailProvider (FutureProvider)
  - 공지사항 상세 조회
  - 자동 읽음 처리

### 읽지 않은 공지 개수
- [ ] UnreadAnnouncementCountProvider (FutureProvider)
  - 읽지 않은 공지 개수 조회

---

## Repository 구현
- [ ] AnnouncementRepository
  - [ ] 공지사항 목록 조회 (GET /announcements)
  - [ ] 공지사항 상세 조회 (GET /announcements/:id)
  - [ ] 공지사항 작성 (POST /announcements) - ADMIN
  - [ ] 공지사항 수정 (PUT /announcements/:id) - ADMIN
  - [ ] 공지사항 삭제 (DELETE /announcements/:id) - ADMIN
  - [ ] 공지사항 고정/해제 (PATCH /announcements/:id/pin) - ADMIN

---

## 라우팅
- [ ] `/announcements` - 공지사항 목록
- [ ] `/announcements/:id` - 공지사항 상세
- [ ] `/admin/announcements/create` - 공지사항 작성 (ADMIN)
- [ ] `/admin/announcements/:id/edit` - 공지사항 수정 (ADMIN)

---

## API 연동 (백엔드 완료)
- ✅ 공지사항 목록 조회 (GET /announcements)
  - 페이지네이션 (page, limit)
  - 고정 공지만 조회 (pinnedOnly)
  - 고정 공지 우선 정렬
  - 읽음 여부 포함 (isRead)
  - 읽은 사람 수 포함 (readCount)

- ✅ 공지사항 상세 조회 (GET /announcements/:id)
  - 조회 시 자동 읽음 처리

- ✅ 공지사항 작성 (POST /announcements) - ADMIN
  - 제목, 내용, 고정 여부, 첨부파일
  - 작성 후 전체 회원에게 알림 발송

- ✅ 공지사항 수정 (PUT /announcements/:id) - ADMIN

- ✅ 공지사항 삭제 (DELETE /announcements/:id) - ADMIN
  - Soft Delete

- ✅ 공지사항 고정/해제 (PATCH /announcements/:id/pin) - ADMIN

---

## 주요 기능 구현 순서

### Phase 1: 기본 조회
1. AnnouncementModel 정의
2. AnnouncementRepository 구현 (조회 API)
3. AnnouncementListProvider 구현
4. 공지사항 목록 화면 UI
5. 공지사항 상세 화면 UI

### Phase 2: 읽음 처리
1. 상세 조회 시 자동 읽음 처리 연동
2. 읽음/안 읽음 UI 표시
3. 읽지 않은 공지 개수 Provider
4. 홈 화면 뱃지 연동

### Phase 3: 관리자 기능
1. ADMIN 권한 확인 로직
2. 공지사항 작성 화면
3. 마크다운 에디터 통합
4. 첨부파일 업로드
5. 공지사항 수정/삭제 기능
6. 고정/해제 토글

---

## UI/UX 가이드라인

### 디자인
- 고정 공지: 배경색 강조 + 핀 아이콘
- 읽지 않은 공지: 제목 볼드 + 점 표시
- 읽은 공지: 일반 스타일

### 색상
- 고정 공지 배경: `AppColors.primary.withOpacity(0.05)`
- 읽지 않은 공지 점: `AppColors.error`
- 핀 아이콘: `AppColors.primary`

### 아이콘
- 고정: `Icons.push_pin` 또는 `Icons.star`
- 공지사항: `Icons.campaign` 또는 `Icons.announcement`
- 첨부파일: `Icons.attach_file`

---

## 참고 문서
- [백엔드 API 문서](../api/announcements.md)
- [마크다운 렌더링 라이브러리](https://pub.dev/packages/flutter_markdown)
- [파일 업로드 가이드](../guides/file-upload.md)

---

## 향후 개선 사항
- [ ] 공지사항 카테고리 추가 (공지, 이벤트, 점검, 업데이트)
- [ ] 공지사항 예약 발행
- [ ] 공지사항 검색 기능
- [ ] 이메일로도 공지 발송 (중요 공지)
- [ ] 공지사항 댓글 기능
- [ ] 공지사항 좋아요 기능
