# 13. 공통 기능

## 상태
🟨 진행 중

> 푸시 알림은 완료되어 [14-notification.md](14-notification.md)에서 관리합니다.
> 공유는 그룹(groupId) 기반 구조로 대체되어 별도 공유 UI를 두지 않습니다.
> 남은 작업은 통합 검색과 오프라인 지원입니다.

---

## 푸시 알림 → [14-notification.md](14-notification.md)로 이관
- ✅ Firebase Cloud Messaging 설정 (네이티브)
- ✅ 푸시 알림 수신
- ✅ 알림 클릭 시 해당 화면 이동 (데이터 기반 라우팅)
- ✅ 백그라운드 알림 처리
- ⬜ 웹 푸시 (`web/firebase-messaging-sw.js` 미작성)

## 공유 기능 — 그룹 기반 구조로 대체됨
- ✅ 일정 공유 (groupId로 그룹 구성원에게 자동 공유)
- ✅ 할일 공유 (groupId)
- ✅ 메모 공유 (visibility=GROUP)
- ❌ 별도 공유 대상 선택 UI — 그룹 선택으로 갈음하여 취소

## 검색 기능
- 🟨 화면별 검색은 구현 (캘린더 검색 바), 통합 검색은 미착수
- ⬜ 전체 검색 (일정, 할일, 메모 통합 검색)
- ⬜ 검색 히스토리
- ⬜ 최근 검색어

## 오프라인 지원
- ⬜ 로컬 데이터베이스 (Hive 또는 SQLite)
- ⬜ 오프라인 데이터 캐싱
- ⬜ 온라인 복귀 시 동기화

---

## 관련 파일
- `lib/core/services/notification_service.dart` (예정)
- `lib/core/services/offline_service.dart` (예정)

## 노트
- Firebase 프로젝트 설정 및 구성 파일 추가 필요
- 오프라인 우선 설계 고려
