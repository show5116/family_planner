# 12. 그룹 관리

## 상태
✅ 완료

---

## 핵심 개념
- 1명의 사용자는 여러 그룹에 소속 가능 (가족, 회사, 친구, 연인 등)
- 그룹별 색상 시스템: Default Color (그룹장 설정) + Custom Color (개인 설정)
- 역할 기반 권한 관리 (OWNER, ADMIN, MEMBER)
- 초대 시스템: 초대 코드, 이메일 초대, 가입 요청

---

## UI 구현

### 그룹 관리
- ✅ 그룹 목록 화면
- ✅ 그룹 생성 화면
- ✅ 그룹 상세 화면
- ✅ 그룹 설정 화면 (정보 수정, 삭제)
- ✅ 그룹 색상 설정 UI (기본 색상, 개인 커스텀 색상)

### 멤버 관리
- ✅ 멤버 목록 화면
- ✅ 멤버 역할 관리 화면 (역할 변경 다이얼로그)
- ✅ 역할 관리 화면 (그룹 역할 목록 조회)

### 초대 시스템
- ✅ 초대 코드 표시 UI
- ✅ 초대 코드 입력 화면
- ✅ 이메일 초대 화면
- ✅ 가입 요청 관리 UI (대기 중 탭)

---

## 데이터 모델
- ✅ Group 모델 (id, name, description, inviteCode, defaultColor)
- ✅ GroupMember 모델 (id, groupId, userId, roleId, customColor, joinedAt)
- ✅ Role 모델 (id, name, groupId, is_default_role, permissions)
- ✅ JoinRequest 모델 (id, groupId, type, email, status, createdAt, updatedAt)

---

## 기능 구현

### 그룹 생성 및 관리
- ✅ 그룹 생성 (POST /groups)
  - 그룹명, 설명, 기본 색상 입력
  - 8자리 랜덤 초대 코드 자동 생성 (영문 대소문자 + 숫자)
  - 생성자에게 OWNER 역할 자동 부여
- ✅ 내가 속한 그룹 목록 조회 (GET /groups)
- ✅ 그룹 상세 조회 (GET /groups/:id)
- ✅ 그룹 정보 수정 (PATCH /groups/:id) - OWNER, ADMIN만
- ✅ 그룹 삭제 (DELETE /groups/:id) - OWNER만
- ✅ 그룹장 양도 (POST /groups/:id/transfer-ownership) - OWNER만

### 멤버 관리
- ✅ 초대 코드로 가입 (POST /groups/join-by-code)
- ✅ 이메일로 초대 (POST /groups/:id/invite-email)
- ✅ 가입 요청 (POST /groups/:id/request-join)
- ✅ 가입 요청 승인/거절
- ✅ 멤버 추방 (DELETE /groups/:id/members/:memberId) - OWNER, ADMIN만
- ✅ 멤버 역할 변경 - OWNER만

### 역할 및 권한
- ✅ 역할 목록 조회 (GET /groups/:id/roles)
- ✅ 역할 생성 (POST /groups/:id/roles) - OWNER만
- ✅ 역할 수정 (PATCH /groups/:id/roles/:roleId) - OWNER만
- ✅ 역할 삭제 (DELETE /groups/:id/roles/:roleId) - OWNER만

### 색상 설정
- ✅ 그룹 기본 색상 설정 (OWNER, ADMIN)
- ✅ 개인 커스텀 색상 설정 (모든 멤버)

---

## 구현 위치

- **화면**: `lib/features/groups/presentation/screens/`
- **Provider**: `lib/features/groups/providers/`
  - `group_list_provider.dart`
  - `group_detail_provider.dart`
  - `group_member_provider.dart`
  - `group_role_provider.dart`
  - `join_request_provider.dart`
- **Repository**: `group_repository.dart`
- **Model**: `group_model.dart`, `group_member_model.dart`, `role_model.dart`

---

## API 문서
[docs/api/groups.md](../api/groups.md)

---

## 향후 개선
- [ ] 그룹 프로필 이미지
- [ ] 그룹 공지사항
- [ ] 그룹별 통계
- [ ] 활동 로그
