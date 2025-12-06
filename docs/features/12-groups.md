# 12. 그룹 관리

## 상태
🟨 진행 중

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
- ⬜ 이메일 초대 화면 (백엔드 API 필요)
- ✅ 그룹 색상 설정 UI (기본 색상, 개인 커스텀 색상)
- ⬜ 그룹 필터 UI (일정, ToDo, 메모, 가계부 등)

## 데이터 모델
- ✅ Group 모델 (id, name, description, inviteCode, defaultColor)
- ✅ GroupMember 모델 (id, groupId, userId, roleId, customColor, joinedAt)
- ✅ Role 모델 (id, name, groupId, is_default_role, permissions)

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
- ⬜ 그룹장 양도 (POST /groups/:id/transfer-ownership)
  - 현재 OWNER만 가능
  - 다른 멤버에게 OWNER 역할 이전 (백엔드 API 필요)

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
- ⬜ 이메일로 초대 (POST /groups/:id/invite-by-email)
  - 초대 권한이 있는 역할만 가능
  - 초대할 사용자 이메일 입력
  - 시스템에서 초대 이메일 자동 발송 (초대 코드 포함)
  - **백엔드 API 필요**

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
- ⬜ 그룹별 고유 역할 생성 기능 (추후 구현)
- ⬜ is_default_role 플래그로 초대 시 자동 부여 역할 지정
- ⬜ 역할별 세부 권한 정의 (조회, 생성, 수정, 삭제, 초대 등)
- ⬜ 그룹장(OWNER)의 역할 생성 및 권한 편집 기능

## API 연동
- ✅ 그룹 생성 API (POST /groups)
- ✅ 그룹 목록 조회 API (GET /groups)
- ✅ 그룹 상세 조회 API (GET /groups/:id)
- ✅ 그룹 정보 수정 API (PATCH /groups/:id)
- ✅ 그룹 삭제 API (DELETE /groups/:id)
- ⬜ 그룹장 양도 API (POST /groups/:id/transfer-ownership) - 백엔드 필요
- ✅ 초대 코드로 가입 API (POST /groups/join)
- ✅ 초대 코드 재생성 API (POST /groups/:id/regenerate-code)
- ⬜ 이메일 초대 API (POST /groups/:id/invite-by-email) - 백엔드 필요
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
- ✅ Common Roles Provider 구현 (CommonRoleNotifier) - 운영자 전용

---

## 관련 파일

### 그룹 관리
- `lib/features/groups/` - 그룹 관련 모든 파일
- `lib/features/groups/models/group.dart` - 그룹 모델
- `lib/features/groups/models/group_member.dart` - 그룹 멤버 및 Role 모델
- `lib/features/groups/services/group_service.dart` - 그룹 API 서비스
- `lib/features/groups/providers/group_provider.dart` - 그룹 상태 관리
- `lib/features/groups/screens/` - 그룹 관련 화면들

### 공통 역할 관리 (운영자 전용)
- `lib/features/roles/` - 공통 역할 관리 파일
- `lib/features/roles/models/common_role.dart` - CommonRole 모델
- `lib/features/roles/services/common_role_service.dart` - 공통 역할 API 서비스
- `lib/features/roles/providers/common_role_provider.dart` - 공통 역할 상태 관리
- `lib/features/roles/screens/common_role_list_screen.dart` - 공통 역할 목록 화면
- `lib/features/roles/screens/common_role_permissions_screen.dart` - 역할 권한 관리 화면
- `lib/features/roles/widgets/common_role_dialogs.dart` - 생성/수정 다이얼로그

### 라우팅
- `lib/core/routes/app_routes.dart` - 라우트 경로 상수
- `lib/core/routes/admin_routes.dart` - 관리자 전용 라우트

## 노트
- 그룹별 필터 기능은 각 기능(일정, ToDo 등) 개발 시 통합 필요
- 역할별 권한 시스템은 추후 확장 가능하도록 설계됨
- 공통 역할 관리는 운영자(isAdmin: true)만 접근 가능
- 공통 역할은 모든 그룹에서 기본으로 사용 가능한 역할 (OWNER, ADMIN, MEMBER 등)
