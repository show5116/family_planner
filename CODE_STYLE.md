# 코드 스타일 가이드

Family Planner 프로젝트의 필수 코드 컨벤션

> UI/디자인 컨벤션(색상·간격·화면 구조)은 [DESIGN.md](DESIGN.md)를 참고한다.

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

**클래스 순서:**
1. 멤버 변수
2. Lifecycle (initState, dispose)
3. Private 메서드 (_buildXxx)
4. build 메서드
5. Private 하위 위젯 (파일 하단)

**핵심 패턴:**
```dart
// const 생성자
const MyScreen({super.key});

// build 분해
Widget build(BuildContext context) {
  final data = ref.watch(dataProvider);
  return data.when(
    data: _buildContent,
    loading: () => const CircularProgressIndicator(),
    error: (e, st) => Text('Error: $e'),
  );
}
```

---

## 5. 상태 관리 (Riverpod)

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'provider.g.dart';

// @riverpod 어노테이션 사용
@riverpod
Future<List<Model>> items(ItemsRef ref) async {
  return await ref.watch(repositoryProvider).getItems();
}

// UI에서 when() 패턴
final itemsAsync = ref.watch(itemsProvider);
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
├── core/              # 전역 (constants, routes, theme)
├── features/          # Feature별
│   └── feature_name/
│       ├── data/      # models, dto, repositories
│       ├── providers/
│       └── presentation/  # screens, widgets
└── shared/            # 공유 위젯
```

**파일명**: `*_screen.dart`, `*_provider.dart`, `*_model.dart`

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
  debugPrint('🔵 [Repository] 시작');
  final result = await repository.doSomething();
  debugPrint('✅ [Repository] 성공');
  return result;
} on DioException catch (e) {
  debugPrint('❌ [Repository] 실패: ${e.message}');
  throw Exception('작업 실패: ${e.message}');
} catch (e, st) {
  debugPrint('❌ [Repository] Error: $e\n$st');
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

**마지막 업데이트**: 2026-01-08 (토큰 최적화)
