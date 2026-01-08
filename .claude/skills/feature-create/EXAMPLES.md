# Feature Create Skill - 사용 예시

## 예시 1: 전체 기능 생성

**사용자 요청:**
```
"일정 관리 기능을 만들어주세요. Schedule이라는 이름으로 리스트와 상세 화면이 필요해요."
```

**Skill 실행:**
1. 기능명 확인: `schedule`
2. 디렉토리 생성:
   ```bash
   mkdir -p lib/features/schedule/data/models
   mkdir -p lib/features/schedule/data/dto
   mkdir -p lib/features/schedule/data/repositories
   mkdir -p lib/features/schedule/providers
   mkdir -p lib/features/schedule/presentation/screens
   mkdir -p lib/features/schedule/presentation/widgets
   ```
3. 파일 생성:
   - `schedule_model.dart`
   - `schedule_dto.dart`
   - `schedule_repository.dart`
   - `schedule_provider.dart`
   - `schedule_list_screen.dart`
   - `schedule_detail_screen.dart`
4. 코드 생성 실행:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

## 예시 2: Provider만 생성

**사용자 요청:**
```
"대시보드 통계를 가져오는 Provider를 만들어주세요. dashboard_stats라는 이름으로요."
```

**Skill 실행:**
1. Provider 타입 확인 (단순 조회용)
2. 파일 생성: `lib/features/dashboard/providers/dashboard_stats_provider.dart`
3. 코드 생성 실행

**생성된 Provider:**
```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/dashboard/data/models/dashboard_stats_model.dart';
import 'package:family_planner/features/dashboard/data/repositories/dashboard_repository.dart';

part 'dashboard_stats_provider.g.dart';

/// 대시보드 통계 Provider
@riverpod
Future<DashboardStatsModel> dashboardStats(DashboardStatsRef ref) async {
  final repository = ref.watch(dashboardRepositoryProvider);
  return await repository.getStats();
}
```

## 예시 3: Model만 생성

**사용자 요청:**
```
"메모 기능을 위한 Memo 모델을 만들어주세요. 제목, 내용, 작성일이 필요해요."
```

**Skill 실행:**
1. 모델 정보 확인
2. 파일 생성: `lib/features/memo/data/models/memo_model.dart`

**생성된 Model:**
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'memo_model.freezed.dart';
part 'memo_model.g.dart';

/// 메모 모델
@freezed
class MemoModel with _$MemoModel {
  const factory MemoModel({
    required String id,
    required String title,
    required String content,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MemoModel;

  factory MemoModel.fromJson(Map<String, dynamic> json) =>
      _$MemoModelFromJson(json);
}

/// 메모 목록 응답 모델
@freezed
class MemoListResponse with _$MemoListResponse {
  const factory MemoListResponse({
    @Default([]) List<MemoModel> items,
    @Default(0) int total,
    @Default(1) int page,
    @Default(20) int limit,
  }) = _MemoListResponse;

  factory MemoListResponse.fromJson(Map<String, dynamic> json) =>
      _$MemoListResponseFromJson(json);
}
```

## 예시 4: 화면만 생성 (기존 기능에 추가)

**사용자 요청:**
```
"공지사항 생성 화면을 추가해주세요. announcement_create_screen이라는 이름으로요."
```

**Skill 실행:**
1. 기존 기능 확인: `lib/features/announcements/`
2. 화면 파일 생성: `lib/features/announcements/presentation/screens/announcement_create_screen.dart`

**생성된 Screen:**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/announcements/providers/announcement_provider.dart';
import 'package:family_planner/features/announcements/data/dto/announcement_dto.dart';

/// 공지사항 생성 화면
class AnnouncementCreateScreen extends ConsumerStatefulWidget {
  const AnnouncementCreateScreen({super.key});

  @override
  ConsumerState<AnnouncementCreateScreen> createState() =>
      _AnnouncementCreateScreenState();
}

class _AnnouncementCreateScreenState
    extends ConsumerState<AnnouncementCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final dto = CreateAnnouncementDto(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
      );

      await ref.read(announcementListProvider.notifier).create(dto);

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('공지사항이 생성되었습니다')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('생성 실패: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('공지사항 작성'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '제목',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '제목을 입력하세요';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSizes.spaceM),
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: '내용',
                border: OutlineInputBorder(),
              ),
              maxLines: 10,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '내용을 입력하세요';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSizes.spaceL),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleSubmit,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('작성'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 예시 5: 재사용 위젯 생성

**사용자 요청:**
```
"리스트 아이템 카드를 재사용 가능한 위젯으로 만들어주세요."
```

**Skill 실행:**
1. 위젯 타입 확인 (StatelessWidget)
2. 파일 생성: `lib/features/{feature}/presentation/widgets/item_card.dart`

**생성된 Widget:**
```dart
import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';

/// 리스트 아이템 카드 위젯
class ItemCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const ItemCard({
    super.key,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: AppSizes.spaceXS,
        horizontal: AppSizes.spaceM,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppSizes.spaceXS),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
```

## 주의사항

1. **기능명 규칙**
   - snake_case 사용
   - 명확하고 설명적인 이름
   - 기존 기능과 중복되지 않도록 확인

2. **코드 생성 필수**
   - Freezed 모델 생성 시 반드시 `build_runner` 실행
   - Riverpod Provider 생성 시 반드시 `build_runner` 실행

3. **Import 정리**
   - 모든 import는 절대 경로 사용
   - 불필요한 import 제거
   - 순서 준수 (dart → flutter → 외부 → family_planner → part)

4. **문서화**
   - 모든 클래스에 `///` 문서 주석 추가
   - 복잡한 로직은 인라인 주석으로 설명

5. **테스트**
   - 생성 후 `flutter analyze` 실행하여 오류 확인
   - Hot reload로 앱 실행 테스트
