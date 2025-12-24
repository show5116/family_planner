# 12. 그룹 관리

## 상태
✅ 완료

---

## 핵심 개념
- 1명의 사용자는 여러 그룹에 소속 가능 (가족, 회사, 친구, 연인 등)
- 그룹별 색상 시스템: Default Color (그룹장 설정) + Custom Color (개인 설정)
- 전체 UI에서 그룹별 필터 기능 제공

## UI 구현
- ✅ 그룹 목록 화면
- ✅ 그룹 생성 화면
- ✅ 그룹 상세 화면
- ✅ 그룹 설정 화면 (정보 수정, 삭제)
- ✅ 멤버 목록 화면
- ✅ 멤버 역할 관리 화면 (역할 변경 다이얼로그)
- ✅ 역할 관리 화면 (그룹 역할 목록 조회)
- ✅ 초대 코드 표시 UI
- ✅ 초대 코드 입력 화면
- ✅ 이메일 초대 화면
- ✅ 가입 요청 관리 UI (대기 중 탭)
- ✅ 그룹 색상 설정 UI (기본 색상, 개인 커스텀 색상)

## 데이터 모델
- ✅ Group 모델 (id, name, description, inviteCode, defaultColor)
- ✅ GroupMember 모델 (id, groupId, userId, roleId, customColor, joinedAt)
- ✅ Role 모델 (id, name, groupId, is_default_role, permissions)
- ✅ JoinRequest 모델 (id, groupId, type, email, status, createdAt, updatedAt)

## 그룹 생성 및 관리 기능
- ✅ 그룹 생성 (POST /groups)
  - 그룹명, 설명, 기본 색상 입력
  - 8자리 랜덤 초대 코드 자동 생성 (영문 대소문자 + 숫자)
  - 생성자에게 OWNER 역할 자동 부여
- ✅ 내가 속한 그룹 목록 조회 (GET /groups)
  - 개인 커스텀 색상 포함
- ✅ 그룹 상세 조회 (GET /groups/:id)
  - 멤버 목록 포함
  - 멤버만 조회 가능
- ✅ 그룹 정보 수정 (PATCH /groups/:id)
  - OWNER, ADMIN만 가능
  - 기본 색상 변경 가능
- ✅ 그룹 삭제 (DELETE /groups/:id)
  - OWNER만 가능
- ✅ 그룹장 양도 (POST /groups/:id/transfer-ownership)
  - 현재 OWNER만 가능
  - 다른 멤버에게 OWNER 역할 이전
  - 양도 후 이전 OWNER는 기본 역할(is_default_role=true)로 변경
  - 확인 다이얼로그로 주의사항 안내 후 실행

## 초대 시스템

### 초대 코드 방식
- ✅ 초대 코드로 그룹 가입 (POST /groups/join)
  - 8자리 영문(대소문자 구분) + 숫자 조합 코드
  - 중복 가입 방지
  - 가입 시 is_default_role=true인 역할 자동 부여
- ✅ 초대 코드 재생성 (POST /groups/:id/regenerate-code)
  - 초대 권한이 있는 역할만 가능 (OWNER, ADMIN)
  - 백엔드에서 중복 검사 후 고유 코드 생성

### 이메일 초대 방식
- ✅ 이메일로 초대 (POST /groups/:id/invite-by-email)
  - 초대 권한(INVITE_MEMBER)이 있는 역할만 가능
  - 초대할 사용자 이메일 입력
  - 해당 이메일로 가입된 사용자에게 초대 메일 자동 발송
  - 초대 코드와 가입 요청 ID 포함
  - 초대받은 사용자가 초대 코드로 가입하면 자동 승인됨

### 가입 요청 관리
- ✅ 가입 요청 목록 조회 (GET /groups/:id/join-requests)
  - INVITE_MEMBER 권한 필요
  - status 쿼리 파라미터로 필터링 (PENDING, ACCEPTED, REJECTED)
  - 멤버 탭의 "대기중" 탭에서 확인 가능
- ✅ 가입 요청 승인 (POST /groups/:id/join-requests/:requestId/accept)
  - INVITE_MEMBER 권한 필요
  - PENDING 상태의 요청을 승인하고 멤버로 추가
- ✅ 가입 요청 거부 (POST /groups/:id/join-requests/:requestId/reject)
  - INVITE_MEMBER 권한 필요
  - PENDING 상태의 요청을 거부
- ✅ 초대 취소 (DELETE /groups/:id/invites/:requestId)
  - INVITE_MEMBER 권한 필요
  - INVITE 타입의 PENDING 상태 초대를 취소
- ✅ 초대 재전송 (POST /groups/:id/invites/:requestId/resend)
  - INVITE_MEMBER 권한 필요
  - INVITE 타입의 PENDING 상태 초대 이메일을 재전송

## 멤버 관리
- ✅ 그룹 멤버 목록 조회 (GET /groups/:id/members)
  - 멤버별 역할 정보 포함
- ✅ 개인 그룹 색상 설정 (PATCH /groups/:id/my-color)
  - 개인이 설정한 색상이 그룹 기본 색상보다 우선
  - 미설정 시 그룹 기본 색상 사용
- ✅ 멤버 역할 변경 (PATCH /groups/:id/members/:userId/role)
  - OWNER만 가능
  - 자신의 역할은 변경 불가
  - OWNER 역할은 양도만 가능
- ✅ 멤버 삭제 (DELETE /groups/:id/members/:userId)
  - OWNER, ADMIN만 가능
  - 자신은 삭제 불가 (나가기 사용)
  - OWNER는 삭제 불가
- ✅ 그룹 나가기 (POST /groups/:id/leave)
  - OWNER는 나갈 수 없음 (권한 양도 또는 그룹 삭제 필요)

## 역할(Role) 체계

### 공통 역할 (group_id = null)
- ✅ OWNER: 그룹장, 모든 권한 (삭제 불가, 양도만 가능)
- ✅ ADMIN: 관리자, 초대 권한 포함
- ✅ MEMBER: 일반 멤버, 조회만 가능
- ✅ 역할 목록 조회 (GET /groups/:id/roles)
- ✅ **공통 역할 관리 시스템 (운영자 전용)**
  - ✅ 공통 역할 목록 조회 (GET /roles)
  - ✅ 공통 역할 상세 조회 (GET /roles/:id)
  - ✅ 공통 역할 생성 (POST /roles)
  - ✅ 공통 역할 수정 (PATCH /roles/:id)
  - ✅ 공통 역할 삭제 (DELETE /roles/:id)
  - ✅ 공통 역할 권한 관리 (PATCH /roles/:id with permissions 배열)
  - ✅ 공통 역할 관리 UI (관리자 설정 메뉴)

### 그룹별 커스텀 역할 (group_id 지정)
- ✅ 그룹별 고유 역할 생성 기능 (POST /groups/:groupId/roles)
  - MANAGE_ROLE 권한 필요
  - 역할명, 권한 배열, 색상, 정렬 순서 설정 가능
- ✅ is_default_role 플래그로 초대 시 자동 부여 역할 지정
  - 백엔드에서 is_default_role=true인 역할을 자동 부여
- ✅ 역할별 세부 권한 정의
  - 권한 배열로 세부 권한 관리 (VIEW, CREATE, UPDATE, DELETE, INVITE_MEMBER 등)
  - 역할 생성 및 수정 시 permissions 배열 지정 가능
- ✅ MANAGE_ROLE 권한이 있는 사용자의 역할 생성 및 권한 편집 기능
  - 역할 생성, 수정, 삭제 UI 구현 완료
  - 역할별 정렬 순서 관리 (드래그 앤 드롭)

## API 연동
- ✅ 그룹 생성 API (POST /groups)
- ✅ 그룹 목록 조회 API (GET /groups)
- ✅ 그룹 상세 조회 API (GET /groups/:id)
- ✅ 그룹 정보 수정 API (PATCH /groups/:id)
- ✅ 그룹 삭제 API (DELETE /groups/:id)
- ✅ 그룹장 양도 API (POST /groups/:id/transfer-ownership)
- ✅ 초대 코드로 가입 API (POST /groups/join)
- ✅ 초대 코드 재생성 API (POST /groups/:id/regenerate-code)
- ✅ 이메일 초대 API (POST /groups/:id/invite-by-email)
- ✅ 가입 요청 목록 조회 API (GET /groups/:id/join-requests)
- ✅ 가입 요청 승인 API (POST /groups/:id/join-requests/:requestId/accept)
- ✅ 가입 요청 거부 API (POST /groups/:id/join-requests/:requestId/reject)
- ✅ 초대 취소 API (DELETE /groups/:id/invites/:requestId)
- ✅ 초대 재전송 API (POST /groups/:id/invites/:requestId/resend)
- ✅ 멤버 목록 조회 API (GET /groups/:id/members)
- ✅ 개인 색상 설정 API (PATCH /groups/:id/my-color)
- ✅ 멤버 역할 변경 API (PATCH /groups/:id/members/:userId/role)
- ✅ 멤버 삭제 API (DELETE /groups/:id/members/:userId)
- ✅ 그룹 나가기 API (POST /groups/:id/leave)
- ✅ 역할 목록 조회 API (GET /groups/:id/roles)

## 상태 관리
- ✅ Groups Provider 구현 (GroupNotifier)
- ✅ Group Members Provider 구현 (groupMembersProvider)
- ✅ Roles Provider 구현 (groupRolesProvider)
- ✅ Join Requests Provider 구현 (groupJoinRequestsProvider)
- ✅ Common Roles Provider 구현 (CommonRoleNotifier) - 운영자 전용

---

## 관련 파일

### 그룹 관리
- `lib/features/settings/groups/` - 그룹 관련 모든 파일
- `lib/features/settings/groups/models/group.dart` - 그룹 모델
- `lib/features/settings/groups/models/group_member.dart` - 그룹 멤버 및 Role 모델
- `lib/features/settings/groups/models/join_request.dart` - 가입 요청 모델
- `lib/features/settings/groups/services/group_service.dart` - 그룹 API 서비스
- `lib/features/settings/groups/providers/group_provider.dart` - 그룹 상태 관리
- `lib/features/settings/groups/screens/` - 그룹 관련 화면들
- `lib/features/settings/groups/widgets/tabs/members/` - 멤버 탭 위젯 (참여중/대기중 토글)

### 공통 역할 관리 (운영자 전용)
- `lib/features/settings/roles/` - 공통 역할 관리 파일
- `lib/features/settings/roles/models/common_role.dart` - CommonRole 모델
- `lib/features/settings/roles/services/common_role_service.dart` - 공통 역할 API 서비스
- `lib/features/settings/roles/providers/common_role_provider.dart` - 공통 역할 상태 관리
- `lib/features/settings/roles/screens/common_role_list_screen.dart` - 공통 역할 목록 화면
- `lib/features/settings/roles/screens/common_role_permissions_screen.dart` - 역할 권한 관리 화면
- `lib/features/settings/roles/widgets/common_role_dialogs.dart` - 생성/수정 다이얼로그

### 권한 관리 (운영자 전용)
- `lib/features/settings/permissions/` - 권한 관리 파일
- `lib/features/settings/permissions/models/permission.dart` - Permission 모델
- `lib/features/settings/permissions/services/permission_service.dart` - 권한 API 서비스
- `lib/features/settings/permissions/providers/permission_management_provider.dart` - 권한 상태 관리
- `lib/features/settings/permissions/screens/permission_management_screen.dart` - 권한 관리 화면
- `lib/features/settings/permissions/widgets/` - 권한 관련 위젯

### 일반 설정
- `lib/features/settings/common/` - 일반 설정 화면 및 Provider
- `lib/features/settings/common/screens/settings_screen.dart` - 설정 메인 화면
- `lib/features/settings/common/screens/more_tab.dart` - 더보기 탭
- `lib/features/settings/common/providers/` - 일반 설정 관련 Provider

### 라우팅
- `lib/core/routes/app_routes.dart` - 라우트 경로 상수
- `lib/core/routes/admin_routes.dart` - 관리자 전용 라우트

## 노트
- 역할별 권한 시스템은 추후 확장 가능하도록 설계됨
- 공통 역할 관리는 운영자(isAdmin: true)만 접근 가능
- 공통 역할은 모든 그룹에서 기본으로 사용 가능한 역할 (OWNER, ADMIN, MEMBER 등)
- 이메일 초대는 해당 이메일로 가입된 사용자가 있어야 함
- 초대받은 사용자는 이메일 초대 시 자동으로 승인되고, 일반 가입 요청은 관리자 승인 필요
- INVITE_MEMBER 권한이 있는 사용자만 대기 중인 가입 요청을 확인하고 승인/거부 가능
