---
name: test-generate
description: Flutter 위젯 테스트, 유닛 테스트, Provider 테스트 코드를 자동 생성합니다. 새로운 기능 구현 후 테스트 작성 시 사용하세요.
allowed-tools: Read, Write, Bash(mkdir:*), Bash(flutter:test)
---

# Test Generate Skill

Flutter 테스트 코드를 자동 생성합니다.

## 테스트 유형

1. **Widget Test** - 화면 및 위젯
2. **Provider Test** - Riverpod Provider
3. **Repository Test** - API 호출 및 데이터 레이어
4. **Unit Test** - 로직 및 유틸리티

## 워크플로우

1. **대상 파일 분석**: 테스트할 코드 읽기
2. **템플릿 선택**: 테스트 유형별
3. **테스트 생성**: `test/` 디렉토리에 생성
4. **검증**: `flutter test` 실행

## 핵심 템플릿

### Widget Test

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('{Name} Widget Tests', () {
    testWidgets('should display title', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            {provider}.overrideWith((ref) => AsyncValue.data(mockData)),
          ],
          child: const MaterialApp(home: {Name}()),
        ),
      );

      // Assert
      expect(find.text('Title'), findsOneWidget);
    });
  });
}
```

### Provider Test

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class Mock{Repository} extends Mock implements {Repository} {}

void main() {
  group('{Name}Provider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [{repositoryProvider}.overrideWithValue(mockRepository)],
      );
    });

    tearDown(() => container.dispose());

    test('should load data', () async {
      // Arrange
      when(() => mockRepository.getData()).thenAnswer((_) async => mockData);

      // Act
      final state = await container.read({provider}.future);

      // Assert
      expect(state, mockData);
    });
  });
}
```

### Repository Test

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';

class MockHttpService extends Mock implements HttpService {}

void main() {
  group('{Name}Repository Tests', () {
    test('should fetch data successfully', () async {
      // Arrange
      when(() => mockHttp.get(any())).thenAnswer(
        (_) async => Response(
          data: {'data': []},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // Act
      final result = await repository.getData();

      // Assert
      expect(result, isA<List<Model>>());
    });
  });
}
```

## AAA 패턴

```dart
test('should do something', () {
  // Arrange: 준비 (Mock, 데이터)
  // Act: 실행 (테스트할 동작)
  // Assert: 검증 (결과 확인)
});
```

## 필수 패키지

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.0
```

상세 예시: [EXAMPLES.md](EXAMPLES.md)
