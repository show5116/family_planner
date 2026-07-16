import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/data/repositories/routine_repository.dart';
import 'package:family_planner/features/main/routine/providers/routine_provider.dart';

DateTime _fixedDate() => DateTime(2026, 7, 1);

Routine _buildRoutine({
  String id = 'routine-1',
  bool checkedToday = false,
}) {
  final now = _fixedDate();
  return Routine(
    id: id,
    title: '아침 스트레칭',
    frequencyType: RoutineFrequencyType.weeklyCount,
    targetCount: 3,
    startDate: now,
    isActive: true,
    sortOrder: 0,
    checkedToday: checkedToday,
    createdAt: now,
    updatedAt: now,
  );
}

RoutineStreak _buildStreak({
  String routineId = 'routine-1',
  int currentStreakDays = 0,
}) {
  return RoutineStreak(
    routineId: routineId,
    currentStreakWeeks: 0,
    longestStreakWeeks: 0,
    currentStreakDays: currentStreakDays,
    longestStreakDays: currentStreakDays,
    thisWeekProgress: const ThisWeekProgress(checked: 0, target: 3),
  );
}

RoutineGroup _buildGroup({
  String id = 'group-1',
  String title = '아침 루틴',
  int checked = 0,
  int total = 0,
}) {
  final now = _fixedDate();
  return RoutineGroup(
    id: id,
    title: title,
    sortOrder: 0,
    todayProgress: RoutineGroupProgress(checked: checked, total: total),
    createdAt: now,
    updatedAt: now,
  );
}

UserRoutineBadge _buildBadge(String code) {
  return UserRoutineBadge(
    id: 'badge-record-$code',
    badgeId: 'badge-$code',
    badge: RoutineBadge(
      id: 'badge-$code',
      code: code,
      title: code,
      criteriaType: BadgeCriteriaType.streakDays,
      criteriaValue: 7,
    ),
    earnedAt: _fixedDate(),
  );
}

/// 테스트용 가짜 Repository — 실제 HTTP 호출 없이 동작을 흉내낸다.
class _FakeRoutineRepository extends RoutineRepository {
  _FakeRoutineRepository({
    List<Routine>? routines,
    this.groups = const [],
    this.checkShouldThrow = false,
    this.newlyEarnedBadgesOnCheck = const [],
    this.streakAfterCheck,
    this.streakBeforeCheck,
  }) : _routines = routines ?? [_buildRoutine()];

  final List<Routine> _routines;
  final List<RoutineGroup> groups;
  final bool checkShouldThrow;
  final List<UserRoutineBadge> newlyEarnedBadgesOnCheck;
  final RoutineStreak? streakAfterCheck;
  final RoutineStreak? streakBeforeCheck;

  int checkCallCount = 0;
  int uncheckCallCount = 0;
  int getStreakCallCount = 0;
  int deleteRoutineGroupCallCount = 0;

  @override
  Future<List<Routine>> getRoutines({bool? isActive}) async => _routines;

  @override
  Future<List<RoutineGroup>> getRoutineGroups() async => groups;

  @override
  Future<RoutineGroup> createRoutineGroup(CreateRoutineGroupDto dto) async {
    return RoutineGroup(
      id: 'group-new',
      title: dto.title,
      emoji: dto.emoji,
      color: dto.color,
      sortOrder: groups.length,
      todayProgress: const RoutineGroupProgress(checked: 0, total: 0),
      createdAt: _fixedDate(),
      updatedAt: _fixedDate(),
    );
  }

  @override
  Future<void> deleteRoutineGroup(String id) async {
    deleteRoutineGroupCallCount++;
  }

  @override
  Future<RoutineLog> checkRoutine(String id, CheckRoutineDto dto) async {
    checkCallCount++;
    if (checkShouldThrow) {
      throw Exception('네트워크 오류');
    }
    return RoutineLog(
      id: 'log-1',
      routineId: id,
      checkedDate: _fixedDate(),
      createdAt: _fixedDate(),
      newlyEarnedBadges: newlyEarnedBadgesOnCheck,
    );
  }

  @override
  Future<void> uncheckRoutine(String id, {String? date}) async {
    uncheckCallCount++;
  }

  @override
  Future<RoutineStreak> getStreak(String id) async {
    getStreakCallCount++;
    // 첫 호출(체크 전 캐싱)은 streakBeforeCheck, 이후 호출(체크 후 재조회)은
    // streakAfterCheck를 반환해 "체크로 스트릭이 갱신됨"을 흉내낸다.
    if (getStreakCallCount == 1 && streakBeforeCheck != null) {
      return streakBeforeCheck!;
    }
    return streakAfterCheck ?? _buildStreak(routineId: id);
  }

  @override
  Future<List<RoutineSummaryItem>> getSummary() async => [];

  @override
  Future<List<UserRoutineBadge>> getMyBadges() async => [];

  @override
  Future<List<UserRoutineBadge>> getRoutineBadges(String id) async => [];
}

void main() {
  // RoutineRepository()가 내부적으로 ApiClient.instance를 초기화하며
  // EnvironmentConfig가 dotenv.get(...)을 호출하므로, 실제 .env 파일 없이도
  // fallback 값으로 동작하도록 빈 환경을 미리 로드해둔다.
  setUpAll(() {
    dotenv.testLoad(fileInput: '');
  });

  group('RoutineManagementNotifier.toggleCheck', () {
    test('체크 성공 시 목록의 checkedToday가 true로 낙관적 반영된다', () async {
      final repository = _FakeRoutineRepository(
        routines: [_buildRoutine(checkedToday: false)],
        streakAfterCheck: _buildStreak(currentStreakDays: 1),
      );
      final container = ProviderContainer(
        overrides: [
          routineRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      // 목록을 먼저 로드해 초기 상태를 만든다
      await container.read(routineListProvider.future);

      final result = await container
          .read(routineManagementProvider.notifier)
          .toggleCheck('routine-1', false);

      expect(result.success, isTrue);
      final routines = container.read(routineListProvider).value!;
      expect(routines.single.checkedToday, isTrue);
      expect(repository.checkCallCount, 1);
      expect(repository.uncheckCallCount, 0);
    });

    test('체크 실패 시 낙관적으로 반영했던 상태가 롤백된다', () async {
      final repository = _FakeRoutineRepository(
        routines: [_buildRoutine(checkedToday: false)],
        checkShouldThrow: true,
      );
      final container = ProviderContainer(
        overrides: [
          routineRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(routineListProvider.future);

      final result = await container
          .read(routineManagementProvider.notifier)
          .toggleCheck('routine-1', false);

      expect(result.success, isFalse);
      final routines = container.read(routineListProvider).value!;
      expect(routines.single.checkedToday, isFalse,
          reason: '체크 API 실패 시 낙관적 업데이트가 롤백되어야 한다');
    });

    test('체크 취소 시 uncheckRoutine이 호출되고 checkedToday가 false로 반영된다', () async {
      final repository = _FakeRoutineRepository(
        routines: [_buildRoutine(checkedToday: true)],
      );
      final container = ProviderContainer(
        overrides: [
          routineRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(routineListProvider.future);

      final result = await container
          .read(routineManagementProvider.notifier)
          .toggleCheck('routine-1', true);

      expect(result.success, isTrue);
      expect(repository.uncheckCallCount, 1);
      expect(repository.checkCallCount, 0);
      final routines = container.read(routineListProvider).value!;
      expect(routines.single.checkedToday, isFalse);
    });

    test('스트릭이 이전보다 증가하면 streakIncreased가 true를 반환한다', () async {
      final repository = _FakeRoutineRepository(
        routines: [_buildRoutine(checkedToday: false)],
        streakBeforeCheck: _buildStreak(currentStreakDays: 4),
        streakAfterCheck: _buildStreak(currentStreakDays: 5),
      );
      final container = ProviderContainer(
        overrides: [
          routineRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(routineListProvider.future);
      // 체크 전 스트릭을 미리 4일로 캐싱
      await container.read(routineStreakProvider('routine-1').future);

      final result = await container
          .read(routineManagementProvider.notifier)
          .toggleCheck('routine-1', false);

      expect(result.streakIncreased, isTrue);
      expect(result.currentStreakDays, 5);
    });

    test('체크 응답의 newlyEarnedBadges를 그대로 결과에 전달한다', () async {
      final badge = _buildBadge('STREAK_DAYS_7');
      final repository = _FakeRoutineRepository(
        routines: [_buildRoutine(checkedToday: false)],
        newlyEarnedBadgesOnCheck: [badge],
        streakAfterCheck: _buildStreak(currentStreakDays: 7),
      );
      final container = ProviderContainer(
        overrides: [
          routineRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(routineListProvider.future);

      final result = await container
          .read(routineManagementProvider.notifier)
          .toggleCheck('routine-1', false);

      expect(result.newlyEarnedBadges, [badge]);
    });
  });

  group('RoutineGroupList / RoutineGroupManagementNotifier', () {
    test('그룹 목록을 로드하면 오늘 진행률을 포함한 RoutineGroup 목록을 반환한다', () async {
      final repository = _FakeRoutineRepository(
        groups: [_buildGroup(checked: 1, total: 3)],
      );
      final container = ProviderContainer(
        overrides: [
          routineRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      final groups = await container.read(routineGroupListProvider.future);

      expect(groups.single.id, 'group-1');
      expect(groups.single.todayProgress.checked, 1);
      expect(groups.single.todayProgress.total, 3);
    });

    test('그룹 생성 성공 시 목록에 새 그룹이 추가된다', () async {
      final repository = _FakeRoutineRepository(groups: const []);
      final container = ProviderContainer(
        overrides: [
          routineRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(routineGroupListProvider.future);

      final created = await container
          .read(routineGroupManagementProvider.notifier)
          .createRoutineGroup(const CreateRoutineGroupDto(title: '저녁 루틴'));

      expect(created, isNotNull);
      final groups = container.read(routineGroupListProvider).value!;
      expect(groups.single.title, '저녁 루틴');
    });

    test('그룹 삭제 성공 시 목록에서 제거되고 습관 목록도 refresh된다', () async {
      final repository = _FakeRoutineRepository(
        routines: [_buildRoutine()],
        groups: [_buildGroup()],
      );
      final container = ProviderContainer(
        overrides: [
          routineRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(routineGroupListProvider.future);
      await container.read(routineListProvider.future);

      final success = await container
          .read(routineGroupManagementProvider.notifier)
          .deleteRoutineGroup('group-1');

      expect(success, isTrue);
      expect(repository.deleteRoutineGroupCallCount, 1);
      final groups = container.read(routineGroupListProvider).value!;
      expect(groups, isEmpty);
    });
  });
}
