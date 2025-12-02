# 0. 프로젝트 초기 설정 및 기반 구조

## 상태
✅ 완료

---

## 아키텍처 및 설정
- ✅ Feature-First 폴더 구조 설계
- ✅ Riverpod 상태 관리 설정 (flutter_riverpod 2.6.1)
- ✅ GoRouter 라우팅 설정 (go_router 14.6.2)
- ✅ 환경 설정 시스템 (개발/프로덕션)
- ✅ API 클라이언트 기반 구조 (Dio, HTTP)

## 디자인 시스템
- ✅ 색상 팔레트 정의 (Primary, Secondary, Semantic, Functional)
- ✅ 간격 시스템 (4px ~ 48px)
- ✅ 타이포그래피 시스템 (Material Design 3)
- ✅ 라이트/다크 테마 지원
- ✅ 반응형 디자인 시스템 (Mobile/Tablet/Desktop)

## 공통 컴포넌트
- ✅ 앱 로고 위젯 (AppLogo)
- ✅ 대시보드 카드 위젯 (DashboardCard)
- ✅ 반응형 네비게이션 (ResponsiveNavigation)
- ✅ Bottom Navigation (5개 탭: 홈, 자산, 일정, 할일, 더보기)

## 배포 및 CI/CD
- ✅ Netlify 웹 배포 설정
- ✅ GitHub Actions 워크플로우 설정
- ✅ 웹 개발 포트 3001 고정 설정
- ✅ flutter analyze 및 빌드 검증 자동화

---

## 관련 파일
- `lib/core/config/environment.dart`
- `lib/core/routes/app_routes.dart`
- `lib/core/theme/app_theme.dart`
- `lib/core/constants/app_sizes.dart`
- `lib/core/constants/app_colors.dart`
