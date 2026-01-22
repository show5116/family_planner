# 16. Q&A (문의하기)

## 상태
✅ 완료 (사용자 기능 + 관리자 답변 기능 완료)

---

## 핵심 개념
사용자가 운영자(ADMIN)에게 직접 질문하고 답변을 받을 수 있는 1:1 지원 시스템입니다.

### 주요 특징
- **사용자 → ADMIN**: 일반 사용자가 질문 작성, ADMIN만 답변 가능
- **공개/비공개 선택**: 공개 질문은 모든 사용자 조회 가능 (FAQ 역할)
- **상태 관리**: PENDING → ANSWERED → RESOLVED
- **카테고리**: 버그, 기능 제안, 사용법, 계정, 결제, 기타
- **리치 텍스트 에디터**: WYSIWYG 방식의 일반 사용자 친화적 에디터 (XSS 방어)

---

## UI 구현

### 공개 Q&A 화면 (모든 사용자)
- ✅ 공개 질문 목록 화면
  - 카테고리별 필터 (팝업 메뉴)
  - 상태별 필터 (탭: 전체/대기중/답변완료/해결)
  - 검색 기능 (제목/내용)
  - 페이지네이션 (무한 스크롤)
  - Pull-to-refresh
- ✅ 공개 질문 상세 화면
  - 질문 내용 및 답변 목록
  - HTML 렌더링 (RichTextViewer, XSS 방어)
  - 공개 질문 뱃지 표시

### 내 질문 화면
- ✅ 내 질문 목록 화면
  - 공개/비공개 모두 표시
  - 상태별 필터 (탭)
  - 카테고리별 필터
  - FAB: 질문 작성 버튼
- ✅ 내 질문 상세 화면
  - 질문 정보 및 답변 목록
  - 수정 버튼 (PENDING 상태만)
  - 삭제 버튼
  - 해결 완료 버튼 (ANSWERED 상태만)

### 질문 작성/수정 화면
- ✅ 카테고리 선택 (ChoiceChip)
- ✅ 제목 입력 (1~200자)
- ✅ 내용 입력 (10~5000자, 리치 텍스트 에디터)
- ✅ 공개/비공개 선택 (라디오 버튼)
- ✅ PENDING 상태에서만 수정 가능
- ✅ 이미지 업로드 (RichTextEditor 내 이미지 삽입)

### 관리자 전용 기능 (질문 상세 화면 내)
- ✅ 답변 작성 (리치 텍스트 에디터, 이미지 업로드)
- ✅ 답변 수정 (다이얼로그)
- ✅ 답변 삭제
- ⬜ 모든 질문 관리 화면 (별도 화면, 추후 구현)
- ⬜ 통계 대시보드 (추후 구현)

---

## 데이터 모델

### QuestionModel
- ✅ id (String)
- ✅ userId (String)
- ✅ userName (String)
- ✅ title (String)
- ✅ content (String)
- ✅ category (QuestionCategory enum)
- ✅ status (QuestionStatus enum)
- ✅ visibility (QuestionVisibility enum)
- ✅ attachments (List<Attachment>?)
- ✅ answers (List<AnswerModel>)
- ✅ createdAt (DateTime)
- ✅ updatedAt (DateTime)

### AnswerModel
- ✅ id (String)
- ✅ questionId (String)
- ✅ adminId (String)
- ✅ adminName (String)
- ✅ content (String)
- ✅ attachments (List<Attachment>?)
- ✅ createdAt (DateTime)

### Enums
```dart
enum QuestionCategory {
  bug,        // 버그 신고
  feature,    // 기능 제안
  usage,      // 사용법
  account,    // 계정
  payment,    // 결제
  etc,        // 기타
}

enum QuestionStatus {
  pending,    // 대기 중
  answered,   // 답변 완료
  resolved,   // 해결 완료
}

enum QuestionVisibility {
  public,     // 공개
  private,    // 비공개
}
```

---

## 기능 구현

### 사용자 기능 (✅ 완료)
- ✅ 공개 질문 목록/상세 조회
- ✅ 내 질문 목록/상세 조회
- ✅ 질문 작성 (POST /qna/questions)
- ✅ 질문 수정 (PUT /qna/questions/:id) - PENDING만
- ✅ 질문 삭제 (DELETE /qna/questions/:id)
- ✅ 질문 해결 완료 (PATCH /qna/questions/:id/resolve)
- ✅ 카테고리/상태별 필터
- ✅ 검색 기능

### 관리자 기능 (✅ 답변 관리 완료)
- ✅ 답변 작성 (POST /qna/admin/questions/:id/answers)
- ✅ 답변 수정 (PUT /qna/admin/questions/:id/answers/:answerId)
- ✅ 답변 삭제 (DELETE /qna/admin/questions/:id/answers/:answerId)
- ⬜ 모든 질문 조회 (GET /qna/admin/questions) - 추후 구현
- ⬜ 통계 조회 (GET /qna/admin/statistics) - 추후 구현

---

## 구현 위치

- **화면**: `lib/features/qna/presentation/screens/`
- **Provider**: `lib/features/qna/providers/`
  - `public_questions_provider.dart`
  - `my_questions_provider.dart`
  - `question_detail_provider.dart`
  - `question_management_provider.dart`
- **Repository**: `qna_repository.dart`
- **Model**: `question_model.dart`, `answer_model.dart`

---

## API 문서
[docs/api/qna.md](../api/qna.md)

---

## 향후 개선
- [ ] 관리자 전용 질문 관리 화면 (모든 질문 조회)
- [ ] 관리자 통계 대시보드
- [ ] 첨부파일 다운로드 기능
- [ ] 질문 검색 고도화
- [ ] 답변 만족도 평가
- [ ] FAQ 자동 추출
- [ ] 실시간 채팅 연동
