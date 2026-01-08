# Code Review Skill - 상세 예시

## 예시 1: Import 규칙 위반

### 검토 대상 코드

```dart
// ❌ 나쁜 예
import 'package:flutter/material.dart';
import '../../providers/auth_provider.dart';  // 상대 경로
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:dio/dio.dart';  // 순서 잘못됨
import 'package:family_planner/features/auth/data/models/user_model.dart';
```

### 리뷰 결과

```markdown
## Import 규칙: ❌ 수정 필요

**문제점:**
- Line 2: 상대 경로 사용 (`../../`)
- Line 4: Import 순서 잘못됨 (외부 패키지가 family_planner 앞에 와야 함)

**수정 필요:**
```dart
// ✅ 올바른 예
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/auth/data/models/user_model.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
```

**순서**: dart → flutter → 외부패키지 → family_planner → part
```

---

## 예시 2: 상수 활용 위반

### 검토 대상 코드

```dart
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),  // ❌ 하드코딩
      color: Color(0xFF2196F3),  // ❌ 하드코딩
      child: Text(
        'Welcome',
        style: TextStyle(  // ❌ Theme 미사용
          fontSize: 24,
          color: Colors.white,
        ),
      ),
    );
  }
}
```

### 리뷰 결과

```markdown
## 상수 활용: ❌ 수정 필요

**문제점:**
- Line 4: 하드코딩된 padding 값 (16.0)
- Line 5: 하드코딩된 색상 값
- Line 8-11: Theme을 사용하지 않음

**수정 필요:**
```dart
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceM),  // ✅
      color: AppColors.primary,  // ✅
      child: Text(
        'Welcome',
        style: Theme.of(context).textTheme.headlineSmall,  // ✅
      ),
    );
  }
}
```
```

---

## 예시 3: 위젯 구조 개선 필요

### 검토 대상 코드

```dart
class AnnouncementListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcements = ref.watch(announcementListProvider);

    return Scaffold(
      appBar: AppBar(title: Text('공지사항')),
      body: announcements.when(
        data: (items) => ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(  // 120줄의 복잡한 위젯 트리
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(item.isPinned ? Icons.push_pin : Icons.article),
                      SizedBox(width: 8),
                      Expanded(child: Text(item.title)),
                      if (item.category != null)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(item.category),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _getCategoryLabel(item.category),
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                  // ... 100줄 이상 계속됨
                ],
              ),
            );
          },
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
```

### 리뷰 결과

```markdown
## 위젯 구조: ⚠️ 개선 필요

**문제점:**
- Line 9-40: itemBuilder 내부가 너무 복잡 (120줄)
- 재사용 가능한 부분을 별도 위젯으로 분리 권장

**개선 제안:**
```dart
class AnnouncementListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcements = ref.watch(announcementListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('공지사항')),
      body: announcements.when(
        data: (items) => _buildList(items),  // ✅ 분리
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => _buildError(e),  // ✅ 분리
      ),
    );
  }

  Widget _buildList(List<Announcement> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => _AnnouncementCard(  // ✅ 별도 위젯
        announcement: items[index],
      ),
    );
  }

  Widget _buildError(Object error) {
    return Center(child: Text('Error: $error'));
  }
}

// ✅ 재사용 가능한 private 위젯
class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({required this.announcement});

  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          // 복잡한 UI 로직
        ],
      ),
    );
  }
}
```
```

---

## 예시 4: 에러 처리 미흡

### 검토 대상 코드

```dart
class AnnouncementRepository {
  Future<List<Announcement>> getAnnouncements() async {
    try {
      print('Fetching announcements');  // ❌ print 사용
      final response = await _http.get('/announcements');
      print('Success');  // ❌
      return (response.data as List)
          .map((json) => Announcement.fromJson(json))
          .toList();
    } catch (e) {  // ❌ DioException 구분 안함
      print('Error: $e');  // ❌
      rethrow;
    }
  }
}
```

### 리뷰 결과

```markdown
## 에러 처리: ⚠️ 개선 필요

**문제점:**
- Line 4, 6, 11: `print()` 사용 (`debugPrint()` 권장)
- Line 10: DioException 별도 처리 없음
- Line 11: StackTrace 로깅 누락

**개선 제안:**
```dart
class AnnouncementRepository {
  Future<List<Announcement>> getAnnouncements() async {
    try {
      debugPrint('🔵 [AnnouncementRepository] getAnnouncements 시작');  // ✅

      final response = await _http.get('/announcements');

      debugPrint('✅ [AnnouncementRepository] 성공');  // ✅
      return (response.data as List)
          .map((json) => Announcement.fromJson(json))
          .toList();
    } on DioException catch (e) {  // ✅ DioException 별도 처리
      debugPrint('❌ [AnnouncementRepository] DioException: ${e.message}');
      if (e.response?.statusCode == 404) {
        throw Exception('공지사항을 찾을 수 없습니다');
      }
      throw Exception('공지사항 조회 실패: ${e.message}');
    } catch (e, st) {  // ✅ StackTrace 추가
      debugPrint('❌ [AnnouncementRepository] Error: $e');
      debugPrint('StackTrace: $st');  // ✅
      rethrow;
    }
  }
}
```
```

---

## 예시 5: 문서화 누락

### 검토 대상 코드

```dart
// ❌ 문서 주석 없음
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // ❌ 문서 주석 없음
  Future<void> handleLogin() async {
    // 로그인 로직
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ...
    );
  }
}
```

### 리뷰 결과

```markdown
## 문서화: ❌ 수정 필요

**문제점:**
- Line 1: 클래스에 문서 주석 없음
- Line 14: Public 메서드에 문서 주석 없음

**수정 필요:**
```dart
/// 로그인 화면
///
/// 이메일과 비밀번호를 입력받아 사용자 인증을 수행합니다.
class LoginScreen extends ConsumerStatefulWidget {  // ✅
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  /// 로그인 처리
  ///
  /// 이메일과 비밀번호 유효성 검증 후 authProvider를 통해 로그인합니다.
  Future<void> handleLogin() async {  // ✅
    // 로그인 로직
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ...
    );
  }
}
```
```

---

## 예시 6: Provider 패턴 위반

### 검토 대상 코드

```dart
class AnnouncementListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcements = ref.watch(announcementListProvider);

    // ❌ when() 패턴 미사용
    if (announcements is AsyncLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (announcements is AsyncError) {
      return Center(child: Text('Error'));
    }

    final items = announcements.value ?? [];

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => Text(items[index].title),
    );
  }
}
```

### 리뷰 결과

```markdown
## 상태 관리: ⚠️ 개선 필요

**문제점:**
- Line 7-15: `when()` 패턴을 사용하지 않음
- 타입 체크(`is AsyncLoading`) 대신 `when()` 권장

**개선 제안:**
```dart
class AnnouncementListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementsAsync = ref.watch(announcementListProvider);

    return announcementsAsync.when(  // ✅
      data: (items) => ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => Text(items[index].title),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}
```

**장점:**
- 모든 상태(data/loading/error) 명시적 처리
- 더 간결하고 읽기 쉬움
- 타입 안정성 보장
```

---

## 전체 리뷰 리포트 예시

```markdown
# Code Review Report

**파일**: `lib/features/announcements/presentation/screens/announcement_list_screen.dart`
**리뷰 날짜**: 2025-12-30
**전체 평가**: ⚠️ 개선 필요

---

## 1. Import 규칙: ✅ 통과

모든 import가 절대 경로를 사용하고 올바른 순서를 따릅니다.

---

## 2. 명명 규칙: ✅ 통과

파일명, 클래스명, 변수명 모두 컨벤션을 준수합니다.

---

## 3. 위젯 구조: ⚠️ 개선 필요

**문제점:**
- Line 45: build 메서드가 120줄로 너무 깁니다
- `_buildContent()`, `_buildHeader()` 등으로 분해 권장

**제안:**
작은 private 메서드로 분해하여 가독성 향상

---

## 4. 상수 활용: ❌ 수정 필요

**문제점:**
- Line 67: `Color(0xFF2196F3)` → `AppColors.primary` 사용
- Line 89: `16.0` → `AppSizes.spaceM` 사용

**즉시 수정 필요**

---

## 5. 상태 관리: ✅ 통과

Riverpod `when()` 패턴을 올바르게 사용합니다.

---

## 6. 에러 처리: ⚠️ 개선 필요

**문제점:**
- Line 134: `print()` 대신 `debugPrint()` 사용 권장
- Line 142: StackTrace 로깅 추가 권장

---

## 7. 문서화: ❌ 수정 필요

**문제점:**
- 클래스에 `///` 문서 주석 없음
- Public 메서드 `loadMore()`에 문서 주석 없음

**수정 필요**

---

## 8. 폴더 구조: ✅ 통과

Feature-First 구조를 올바르게 따릅니다.

---

## 요약

### ✅ 통과 (4/8)
- Import 규칙
- 명명 규칙
- 상태 관리
- 폴더 구조

### ⚠️ 개선 필요 (2/8)
- 위젯 구조: build 메서드 분해
- 에러 처리: debugPrint 및 StackTrace 개선

### ❌ 수정 필요 (2/8)
- 상수 활용: 하드코딩 제거 (Line 67, 89)
- 문서화: 클래스 및 메서드 주석 추가

---

## 권장 사항

1. **즉시 수정**: 상수 활용, 문서화
2. **점진적 개선**: 위젯 구조 분해, 에러 처리
3. **다음 단계**: `flutter analyze` 실행하여 추가 이슈 확인

---

**flutter analyze 결과:**
```
No issues found!
```
```

---

## 체크리스트

코드 리뷰 시 확인할 항목:

- [ ] **Import**: 절대 경로 + dart → flutter → 외부 → family_planner → part 순서
- [ ] **명명**: snake_case(파일), PascalCase(클래스), camelCase(변수/함수)
- [ ] **const**: 생성자에 const 키워드
- [ ] **상수**: AppColors, AppSizes, Theme.of(context) 사용
- [ ] **위젯**: build 메서드 분해, private 위젯 클래스 분리
- [ ] **Provider**: when() 패턴 사용
- [ ] **에러**: debugPrint + StackTrace, DioException 별도 처리
- [ ] **문서**: /// 주석 (클래스, public 메서드)
