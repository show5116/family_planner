# 코드 스타일 가이드

Family Planner 프로젝트의 필수 코드 컨벤션

---

## 1. Import 규칙

```dart
// 순서: dart → flutter → 외부패키지 → family_planner → part
// 그룹 간 빈 줄 추가, 각 그룹 내 alphabetical 정렬

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/announcements/providers/announcement_provider.dart';

part 'provider.g.dart';
```

**필수:**
- ✅ 절대 경로만 사용: `package:family_planner/...`
- ❌ 상대 경로 금지: `../../...`

---

## 2. 명명 규칙

| 타입 | 규칙 | 예시 |
|------|------|------|
| 파일 | `snake_case` | `announcement_list_screen.dart` |
| 클래스 | `PascalCase` | `AnnouncementListScreen` |
| 변수/함수 | `camelCase` | `isAdmin`, `handleSubmit()` |
| Private | `_camelCase` | `_isLoading`, `_buildContent()` |
| 상수 | `camelCase` | `AppSizes.spaceM` |

---

## 3. 문서화

```dart
/// 클래스 문서 (///)
class MarkdownEditor extends StatefulWidget {}

/// 메서드 문서 (///)
/// [page]: 페이지 번호
Future<void> loadPage({required int page}) async {}

// 인라인 주석
// TODO: 구현 필요

// 로그
debugPrint('🔵 [Repository] 시작');
debugPrint('✅ [Repository] 성공');
debugPrint('❌ [Repository] 실패: $error');
```

---

## 4. 위젯 구조

```dart
// 파일 구조 순서
class MyScreen extends ConsumerStatefulWidget {
  const MyScreen({super.key});  // ✅ const 생성자

  @override
  ConsumerState<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends ConsumerState<MyScreen> {
  // 1. 멤버 변수
  final _controller = ScrollController();
  bool _isLoading = false;

  // 2. Lifecycle
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 3. Private 메서드
  void _onScroll() {}
  Widget _buildContent() {}

  // 4. build (마지막)
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(dataProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('제목')),
      body: data.when(
        data: _buildContent,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => _buildError(e),
      ),
    );
  }
}

// 5. Private 하위 위젯 (파일 하단)
class _ItemCard extends StatelessWidget {}
```

**핵심:**
- const 생성자 적극 활용
- build 메서드 분해 (`_buildXxx()`)
- 재사용 위젯은 private 클래스로 분리

---

## 5. 상태 관리 (Riverpod)

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'provider.g.dart';

// 간단한 조회
@riverpod
Future<List<Model>> items(ItemsRef ref) async {
  final repo = ref.watch(repositoryProvider);
  return await repo.getItems();
}

// 상태 관리 클래스
@riverpod
class ItemList extends _$ItemList {
  int _page = 1;
  bool _hasMore = true;

  @override
  Future<List<Model>> build() async {
    return _fetch();
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetch(page: ++_page));
  }

  bool get hasMore => _hasMore;
}

// UI 사용
final itemsAsync = ref.watch(itemListProvider);
itemsAsync.when(
  data: (items) => ListView(...),
  loading: () => const CircularProgressIndicator(),
  error: (e, st) => Text('Error: $e'),
)
```

---

## 6. 폴더 구조 (Feature-First)

```
lib/
├── core/              # 앱 전역
│   ├── constants/     # AppColors, AppSizes
│   ├── routes/
│   └── theme/
├── features/          # Feature별
│   └── feature_name/
│       ├── data/
│       │   ├── models/
│       │   ├── dto/
│       │   └── repositories/
│       ├── providers/
│       └── presentation/
│           ├── screens/
│           └── widgets/
└── shared/            # 공유 위젯
    └── widgets/
```

**파일명:**
- 화면: `*_screen.dart`
- Provider: `*_provider.dart`
- Model: `*_model.dart`
- DTO: `*_dto.dart`

---

## 7. 상수 및 테마

```dart
// ✅ 좋은 예
color: AppColors.primary
padding: const EdgeInsets.all(AppSizes.spaceM)
style: Theme.of(context).textTheme.titleMedium
Icon(Icons.add, size: AppSizes.iconMedium)

// ❌ 나쁜 예 (하드코딩 금지)
color: Color(0xFF2196F3)
padding: const EdgeInsets.all(16.0)
style: const TextStyle(fontSize: 16)
Icon(Icons.add, size: 24.0)
```

**투명도:**
```dart
// ✅ 새로운 방식
color: AppColors.info.withValues(alpha: 0.05)

// ⚠️ 구버전 (deprecated)
color: AppColors.info.withOpacity(0.05)
```

---

## 8. 에러 처리

```dart
try {
  debugPrint('🔵 [Repository] 작업 시작');
  final result = await repository.doSomething();
  debugPrint('✅ [Repository] 성공');
  return result;
} on DioException catch (e) {
  debugPrint('❌ [Repository] DioException: ${e.message}');
  if (e.response?.statusCode == 404) {
    throw Exception('리소스를 찾을 수 없습니다');
  }
  throw Exception('작업 실패: ${e.message}');
} catch (e, st) {
  debugPrint('❌ [Repository] Error: $e');
  debugPrint('StackTrace: $st');
  rethrow;
}
```

---

## 체크리스트

새 코드 작성 시:

- [ ] Import 순서 (dart → flutter → 외부 → family_planner → part)
- [ ] 절대 경로 사용 (`package:family_planner/...`)
- [ ] 파일명 snake_case, 클래스명 PascalCase
- [ ] const 생성자 사용
- [ ] AppColors, AppSizes 상수 활용
- [ ] Theme.of(context) 활용
- [ ] 문서 주석 (`///`) 작성
- [ ] Provider when() 패턴
- [ ] debugPrint() 로깅

---

**마지막 업데이트**: 2025-12-30
