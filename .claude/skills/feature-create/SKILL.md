---
name: feature-create
description: Flutter 기능을 Feature-First 아키텍처에 맞게 자동 생성합니다. 새로운 화면, Provider, Model, Repository 추가 시 사용하세요.
allowed-tools: Read, Write, Bash(mkdir:*), Bash(flutter:*)
---

# Feature Create Skill

Flutter 프로젝트에 새로운 기능을 생성합니다.

## 생성 유형

1. **Full Feature**: Screen + Provider + Model + Repository + DTO
2. **Screen**: 단일 화면
3. **Provider**: Riverpod Provider
4. **Model**: Freezed Model
5. **Widget**: 재사용 위젯

## 워크플로우

1. **정보 수집**: 기능 이름, 유형, 설명
2. **디렉토리 생성**: `lib/features/{feature_name}/`
3. **파일 생성**: 템플릿 기반
4. **코드 생성**: `flutter pub run build_runner build --delete-conflicting-outputs`
5. **검증**: `flutter analyze`

## 폴더 구조

```
lib/features/{feature_name}/
├── data/
│   ├── models/{feature_name}_model.dart
│   ├── dto/{feature_name}_dto.dart
│   └── repositories/{feature_name}_repository.dart
├── providers/{feature_name}_provider.dart
└── presentation/
    ├── screens/{feature_name}_screen.dart
    └── widgets/
```

## 핵심 템플릿

### Screen (ConsumerStatefulWidget)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/constants/app_sizes.dart';

/// {설명}
class {Name}Screen extends ConsumerStatefulWidget {
  const {Name}Screen({super.key});

  @override
  ConsumerState<{Name}Screen> createState() => _{Name}ScreenState();
}

class _{Name}ScreenState extends ConsumerState<{Name}Screen> {
  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch({provider});

    return Scaffold(
      appBar: AppBar(title: const Text('Title')),
      body: dataAsync.when(
        data: (data) => _buildContent(data),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildContent(dynamic data) {
    return ListView(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      children: [],
    );
  }
}
```

### Provider (List with Pagination)

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:family_planner/features/{feature}/data/models/{model}.dart';
import 'package:family_planner/features/{feature}/data/repositories/{repository}.dart';

part '{provider}.g.dart';

@riverpod
class {Name}List extends _${Name}List {
  int _page = 1;
  bool _hasMore = true;
  List<{Model}> _items = [];

  @override
  Future<List<{Model}>> build() async => await _load();

  Future<List<{Model}>> _load({int page = 1}) async {
    final repo = ref.read({repositoryProvider});
    final response = await repo.getItems(page: page, limit: 20);

    _hasMore = response.items.length >= 20;
    _page = page;
    _items = page == 1 ? response.items : [..._items, ...response.items];

    return _items;
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    state = await AsyncValue.guard(() => _load(page: _page + 1));
  }

  Future<void> refresh() async {
    _page = 1;
    _hasMore = true;
    _items = [];
    state = await AsyncValue.guard(() => _load());
  }

  bool get hasMore => _hasMore;
}
```

### Model (Freezed)

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part '{model}.freezed.dart';
part '{model}.g.dart';

@freezed
class {Name}Model with _${Name}Model {
  const factory {Name}Model({
    required String id,
    required String title,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _{Name}Model;

  factory {Name}Model.fromJson(Map<String, dynamic> json) =>
      _${Name}ModelFromJson(json);
}

@freezed
class {Name}ListResponse with _${Name}ListResponse {
  const factory {Name}ListResponse({
    @Default([]) List<{Name}Model> items,
    @Default(0) int total,
  }) = _{Name}ListResponse;

  factory {Name}ListResponse.fromJson(Map<String, dynamic> json) =>
      _${Name}ListResponseFromJson(json);
}
```

### Repository

```dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/config/environment.dart';
import 'package:family_planner/core/services/http_service.dart';

final {repository}Provider = Provider<{Name}Repository>((ref) {
  return {Name}Repository(ref.watch(httpServiceProvider));
});

class {Name}Repository {
  final HttpService _http;
  {Name}Repository(this._http);

  Future<{Name}ListResponse> getItems({int page = 1, int limit = 20}) async {
    try {
      debugPrint('🔵 [{Name}Repository] getItems(page: $page)');

      final response = await _http.get(
        '${Environment.apiUrl}/{path}',
        queryParameters: {'page': page, 'limit': limit},
      );

      debugPrint('✅ [{Name}Repository] Success');
      return {Name}ListResponse.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('❌ [{Name}Repository] DioException: ${e.message}');
      throw Exception('Failed: ${e.message}');
    } catch (e, st) {
      debugPrint('❌ [{Name}Repository] Error: $e\n$st');
      rethrow;
    }
  }
}
```

## CODE_STYLE.md 준수사항

- ✅ Import: 절대 경로 (`package:family_planner/...`)
- ✅ 명명: snake_case 파일, PascalCase 클래스
- ✅ 상수: `AppColors.primary`, `AppSizes.spaceM`
- ✅ const 생성자 적극 활용
- ✅ 문서 주석 (`///`) 필수
- ✅ `debugPrint()` 사용 (print 금지)

상세 예시: [EXAMPLES.md](EXAMPLES.md)
