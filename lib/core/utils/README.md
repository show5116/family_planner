# Core Utils

공통 유틸리티 함수 및 Provider 모음

## user_utils.dart

사용자 관련 유틸리티 함수

### isAdminProvider

현재 로그인한 사용자가 관리자(ADMIN)인지 확인하는 Provider

**사용 예시:**
```dart
import 'package:family_planner/core/utils/user_utils.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(isAdminProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('화면 제목'),
        actions: [
          // ADMIN만 표시되는 버튼
          if (isAdmin)
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                // 관리자 전용 기능
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // 모두에게 표시되는 내용
          Text('일반 사용자용 콘텐츠'),

          // ADMIN만 표시되는 섹션
          if (isAdmin) ...[
            Divider(),
            Text('관리자 전용 섹션'),
            ElevatedButton(
              onPressed: () {},
              child: Text('관리자 기능'),
            ),
          ],
        ],
      ),
    );
  }
}
```

### isUserAdmin()

사용자 객체를 받아서 관리자인지 확인하는 헬퍼 함수

**사용 예시:**
```dart
import 'package:family_planner/core/utils/user_utils.dart';

void checkUserPermission() {
  final authState = ref.read(authProvider);
  final user = authState.user;

  if (isUserAdmin(user)) {
    print('관리자입니다');
  } else {
    print('일반 사용자입니다');
  }
}
```

## 권장 사항

- **UI 표시 제어**: `isAdminProvider`를 사용하여 위젯 트리에서 실시간으로 관리자 여부를 확인
- **로직 체크**: `isUserAdmin()` 함수를 사용하여 한 번만 확인하면 되는 경우
- **일관성 유지**: 프로젝트 전체에서 이 유틸리티를 사용하여 코드 스타일 통일

## 주의사항

- `user['isAdmin']`을 직접 확인하지 말고, 반드시 이 유틸리티를 사용할 것
- 백엔드 API 호출 시 서버에서도 권한을 검증하므로, 이는 UI 표시용임을 명심
- 보안이 중요한 작업은 서버 측 검증이 필수
