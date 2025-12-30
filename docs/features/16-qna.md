# 16. Q&A (문의하기)

## 상태
✅ 완료 (Phase 1: 사용자 기능 완료, 관리자 기능 미구현)

---

## 핵심 개념
사용자가 운영자(ADMIN)에게 직접 질문하고 답변을 받을 수 있는 1:1 지원 시스템입니다. 버그 신고, 개선 제안, 사용법 문의, 계정 문제 등에 활용되며, 공개/비공개 설정을 통해 다른 사용자와 정보를 공유할 수 있습니다.

### 주요 특징
- **사용자 → ADMIN**: 일반 사용자가 질문 작성, ADMIN만 답변 가능
- **공개/비공개 선택**: 질문 작성 시 공개 여부 설정
  - 공개: 모든 사용자가 조회 가능 (FAQ 역할)
  - 비공개: 작성자와 ADMIN만 조회 가능
- **상태 관리**: 대기 중(PENDING) → 답변 완료(ANSWERED) → 해결 완료(RESOLVED)
- **카테고리**: 버그, 기능 제안, 사용법, 계정, 결제, 기타
- **첨부 파일**: 스크린샷, 로그 파일 등 첨부 가능
- **알림 연동**: 새 질문, 답변 등록 시 알림

---

## UI 구현

### 공개 Q&A 화면 (모든 사용자)
- ✅ 공개 질문 목록 화면
  - ✅ 카테고리별 필터 (팝업 메뉴)
  - ✅ 상태별 필터 (탭: 전체/대기중/답변완료/해결)
  - ✅ 검색 기능 (제목/내용)
  - ✅ 질문 카드 (제목, 카테고리, 상태, 작성자, 작성일, 답변 개수)
  - ✅ 페이지네이션 (무한 스크롤)
  - ✅ Pull-to-refresh
  - ✅ 빈 상태 화면
- ✅ 공개 질문 상세 화면
  - ✅ 질문 내용 (제목, 카테고리, 작성자, 작성일, 내용, 첨부파일)
  - ✅ 답변 목록 (관리자 답변, 작성일, 내용, 첨부파일)
  - ✅ 공개 질문임을 표시하는 뱃지
  - ✅ 마크다운 렌더링

### 내 질문 화면
- ✅ 내 질문 목록 화면
  - ✅ 공개/비공개 모두 표시
  - ✅ 상태별 필터 (탭: 전체/대기중/답변완료/해결)
  - ✅ 카테고리별 필터 (팝업 메뉴)
  - ✅ 질문 카드 (공개/비공개 아이콘 표시)
  - ✅ 페이지네이션 (무한 스크롤)
  - ✅ Pull-to-refresh
  - ✅ 빈 상태 화면
  - ✅ FAB: 질문 작성 버튼
- ✅ 내 질문 상세 화면
  - ✅ 질문 정보 (제목, 카테고리, 상태, 공개여부)
  - ✅ 질문 내용 및 첨부파일 (UI 완료, 다운로드 기능 추후 구현)
  - ✅ 답변 목록
  - ✅ 수정 버튼 (PENDING 상태만)
  - ✅ 삭제 버튼
  - ✅ 해결 완료 버튼 (ANSWERED 상태만)
  - ✅ 마크다운 렌더링

### 질문 작성/수정 화면
- ✅ 카테고리 선택 (버그/기능제안/사용법/계정/결제/기타) - ChoiceChip
- ✅ 제목 입력 (1~200자)
- ✅ 내용 입력 (10~5000자, 마크다운 지원) - MarkdownEditor 사용
- ✅ 공개/비공개 선택 (라디오 버튼)
  - 공개 설명: "다른 사용자도 볼 수 있습니다 (FAQ로 활용)"
  - 비공개 설명: "나와 관리자만 볼 수 있습니다"
- ⬜ 첨부파일 업로드 (이미지, 문서) - 추후 구현
- ✅ 작성 완료 시 알림 표시: "질문이 등록되었습니다. 답변은 알림으로 안내드립니다."
- ✅ PENDING 상태에서만 수정 가능
- ✅ 답변 완료 후에는 수정 불가 안내
- ✅ 안내 메시지 카드

### 관리자 전용 화면 (ADMIN)
- [ ] 모든 질문 관리 화면
  - [ ] 공개/비공개 모든 질문 조회
  - [ ] 상태별 필터 (PENDING 우선 정렬)
  - [ ] 카테고리별 필터
  - [ ] 검색 (제목/내용/사용자명)
  - [ ] PENDING 상태 강조 표시
- [ ] 답변 작성 화면
  - [ ] 원본 질문 표시
  - [ ] 답변 내용 입력
  - [ ] 첨부파일 업로드
  - [ ] 답변 작성 시 자동 상태 변경 (PENDING → ANSWERED)
- [ ] 통계 대시보드
  - [ ] 전체 질문 수
  - [ ] 상태별 개수 (차트)
  - [ ] 카테고리별 개수 (차트)
  - [ ] 최근 질문 목록

---

## 데이터 모델

### QuestionModel
- ✅ id (String)
- ✅ userId (String)
- ✅ userName (String) - 작성자 이름
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
- ✅ updatedAt (DateTime)

### Enums
```dart
enum QuestionCategory {
  bug,        // 버그 신고
  feature,    // 기능 제안/개선
  usage,      // 사용법 문의
  account,    // 계정 문제
  payment,    // 결제/요금제
  etc,        // 기타
}

enum QuestionStatus {
  pending,    // 대기 중 (답변 대기)
  answered,   // 답변 완료
  resolved,   // 해결 완료 (사용자 확인)
}

enum QuestionVisibility {
  public,     // 공개
  private,    // 비공개
}
```

---

## Provider 구현

### 공개 질문
- ✅ PublicQuestionsProvider (AsyncNotifier)
  - 공개 질문 목록 조회
  - 카테고리/상태 필터
  - 검색 기능
  - 페이지네이션
  - 무한 스크롤

### 내 질문
- ✅ MyQuestionsProvider (AsyncNotifier)
  - 내 질문 목록 조회
  - 상태/카테고리 필터
  - 새로고침
  - 페이지네이션
  - 무한 스크롤

### 질문 상세
- ✅ QuestionDetailProvider (FutureProvider)
  - 질문 상세 조회 (답변 포함)
  - 공개/비공개 권한 확인

### 질문 관리
- ✅ QuestionManagementProvider (AsyncNotifier)
  - 질문 작성
  - 질문 수정
  - 질문 삭제
  - 질문 해결 완료
  - 답변 작성 (ADMIN)

### 관리자 (ADMIN)
- ⬜ AdminQuestionsProvider (AsyncNotifier) - 추후 구현
  - 모든 질문 조회
  - PENDING 우선 정렬
  - 검색/필터
- ⬜ QnaStatisticsProvider (FutureProvider) - 추후 구현
  - 통계 데이터 조회

---

## Repository 구현
- ✅ QnaRepository
  - ✅ 공개 질문 목록 조회 (GET /qna/public-questions)
  - ✅ 내 질문 목록 조회 (GET /qna/my-questions)
  - ✅ 질문 상세 조회 (GET /qna/questions/:id)
  - ✅ 질문 작성 (POST /qna/questions)
  - ✅ 질문 수정 (PUT /qna/questions/:id)
  - ✅ 질문 삭제 (DELETE /qna/questions/:id)
  - ✅ 질문 해결 완료 (PATCH /qna/questions/:id/resolve)
  - ⬜ 모든 질문 조회 (GET /qna/admin/questions) - ADMIN (추후 구현)
  - ✅ 답변 작성 (POST /qna/questions/:questionId/answers) - ADMIN
  - ⬜ 답변 수정 (PUT /qna/questions/:questionId/answers/:id) - ADMIN (추후 구현)
  - ⬜ 답변 삭제 (DELETE /qna/questions/:questionId/answers/:id) - ADMIN (추후 구현)
  - ⬜ 통계 조회 (GET /qna/admin/statistics) - ADMIN (추후 구현)

---

## 라우팅
- ✅ `/qna/public` - 공개 Q&A 목록
- ✅ `/qna/public/:id` - 공개 질문 상세
- ✅ `/qna/my-questions` - 내 질문 목록
- ✅ `/qna/my-questions/:id` - 내 질문 상세
- ✅ `/qna/create` - 질문 작성
- ✅ `/qna/:id/edit` - 질문 수정
- ⬜ `/admin/qna` - 관리자 질문 관리 (ADMIN) - 추후 구현
- ⬜ `/admin/qna/statistics` - 통계 (ADMIN) - 추후 구현

---

## API 연동 (백엔드 완료)

### 사용자 API
- ✅ 공개 질문 목록 조회 (GET /qna/public-questions)
  - 페이지네이션, 카테고리/상태 필터, 검색
  - 내용 100자 미리보기

- ✅ 내 질문 목록 조회 (GET /qna/my-questions)
  - 공개/비공개 모두 포함
  - 페이지네이션, 필터

- ✅ 질문 상세 조회 (GET /qna/questions/:id)
  - 공개: 모든 사용자 조회 가능
  - 비공개: 본인 또는 ADMIN만 조회 가능
  - QuestionVisibilityGuard 적용

- ✅ 질문 작성 (POST /qna/questions)
  - 작성 후 ADMIN에게 알림 발송

- ✅ 질문 수정 (PUT /qna/questions/:id)
  - 본인만, PENDING 상태만 수정 가능

- ✅ 질문 삭제 (DELETE /qna/questions/:id)
  - Soft Delete

- ✅ 질문 해결 완료 (PATCH /qna/questions/:id/resolve)
  - ANSWERED → RESOLVED

### 관리자 API (ADMIN)
- ✅ 모든 질문 조회 (GET /qna/admin/questions)
  - PENDING 우선 정렬
  - 검색 (제목/내용/사용자명)

- ✅ 답변 작성 (POST /qna/questions/:questionId/answers)
  - 자동 상태 변경 (PENDING → ANSWERED)
  - 사용자에게 알림 발송

- ✅ 답변 수정 (PUT /qna/questions/:questionId/answers/:id)

- ✅ 답변 삭제 (DELETE /qna/questions/:questionId/answers/:id)

- ✅ 통계 조회 (GET /qna/admin/statistics)
  - 전체/상태별/카테고리별 개수

---

## 주요 기능 구현 순서

### Phase 1: 사용자 - 질문 작성 및 조회 ✅
1. ✅ QuestionModel, AnswerModel, Enum 정의 (기존 완료)
2. ✅ QnaRepository 구현 (사용자 API) (기존 완료)
3. ✅ QnaUtils 유틸리티 함수 (카테고리/상태/공개여부 확장 메서드)
4. ✅ Providers 구현 (PublicQuestions, MyQuestions, QuestionDetail, QuestionManagement)
5. ✅ 질문 작성/수정 화면 (QuestionFormScreen)
   - 카테고리 선택 (ChoiceChip)
   - 공개/비공개 선택 (RadioListTile)
   - 마크다운 에디터 통합 (MarkdownEditor)
6. ✅ 내 질문 목록 화면 (MyQuestionsScreen)
   - 상태별 탭 (전체/대기중/답변완료/해결완료)
   - 카테고리 필터
   - 무한 스크롤
   - Pull-to-refresh
7. ✅ 내 질문 상세 화면 (QuestionDetailScreen)
   - 질문 정보 및 내용 (마크다운 렌더링)
   - 답변 목록 (관리자 답변 표시)
   - 수정/삭제/해결완료 버튼
8. ✅ 공개 질문 목록 화면 (PublicQuestionsScreen)
   - 상태별 탭
   - 카테고리 필터
   - 검색 기능
   - 무한 스크롤
9. ✅ 라우팅 설정 (qna_routes.dart, app_router.dart, app_routes.dart)

### Phase 2: 사용자 - 질문 관리 ⬜
1. ⬜ 첨부파일 업로드/다운로드 (추후 구현)

### Phase 3: 관리자 기능 ⬜
1. ⬜ ADMIN 권한 확인 (isAdminProvider 사용)
2. ⬜ 관리자 질문 관리 화면 (AdminQuestionsScreen)
3. ⬜ 답변 작성 화면 (AnswerFormDialog or Screen)
4. ⬜ 답변 수정/삭제 기능
5. ⬜ 통계 대시보드 (QnaStatisticsScreen)

---

## UI/UX 가이드라인

### 상태별 색상
- PENDING (대기중): `AppColors.warning` (주황색)
- ANSWERED (답변완료): `AppColors.primary` (파란색)
- RESOLVED (해결완료): `AppColors.success` (녹색)

### 카테고리별 아이콘
- 버그: `Icons.bug_report`
- 기능 제안: `Icons.lightbulb`
- 사용법: `Icons.help`
- 계정: `Icons.person`
- 결제: `Icons.payment`
- 기타: `Icons.chat`

### 공개/비공개 표시
- 공개: `Icons.public` + "공개 질문" 뱃지
- 비공개: `Icons.lock` + "비공개 질문" 뱃지

### 답변 디자인
- 관리자 답변: 배경색 강조 (`AppColors.primary.withOpacity(0.05)`)
- 관리자 뱃지: "관리자" 또는 "ADMIN"
- 작성일 표시

---

## 참고 문서
- [백엔드 API 문서](../api/qna.md)
- [마크다운 렌더링](https://pub.dev/packages/flutter_markdown)
- [파일 업로드 가이드](../guides/file-upload.md)

---

## 향후 개선 사항
- [ ] 질문 우선순위 설정 (긴급, 보통, 낮음)
- [ ] 답변 만족도 평가 (별점)
- [ ] 자주 묻는 질문 (FAQ) 자동 추출
- [ ] 질문 템플릿 제공 (카테고리별)
- [ ] 답변 템플릿 (ADMIN용)
- [ ] 질문 자동 분류 (AI/ML)
- [ ] 실시간 채팅 연동
- [ ] 이메일 알림 추가 발송
