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
  RoutineStatus status = RoutineStatus.active,
  RoutineRecordType recordType = RoutineRecordType.boolean_,
  String? routineGroupId,
}) {
  final now = _fixedDate();
  return Routine(
    id: id,
    title: '아침 스트레칭',
    importance: RoutineImportance.medium,
    recordType: recordType,
    status: status,
    frequencyType: RoutineFrequencyType.weekly,
    weeklyMode: RoutineWeeklyMode.countOnly,
    targetCount: 3,
    startDate: now,
    sortOrder: 0,
    checkedToday: checkedToday,
    routineGroupId: routineGroupId,
    createdAt: now,
    updatedAt: now,
  );
}

RoutineCategory _buildCategory({
  String id = 'category-1',
  String title = '규칙적인 삶',
}) {
  final now = _fixedDate();
  return RoutineCategory(
    id: id,
    title: title,
    sortOrder: 0,
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
    thisWeekProgress: const RoutinePeriodProgress(checked: 0, target: 3),
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
      criteriaType: BadgeCriteriaType.goalStreakDays,
      criteriaValue: 7,
    ),
    earnedAt: _fixedDate(),
  );
}

/// 테스트용 가짜 Repository — 실제 HTTP 호출 없이 동작을 흉내낸다.
RoutineChallenge _buildChallenge({
  required String id,
  required RoutineChallengeStatus status,
  required DateTime endDate,
  String? groupId,
  String? groupName,
  bool joined = false,
}) {
  final now = _fixedDate();
  return RoutineChallenge(
    id: id,
    title: '물 마시기',
    startDate: now,
    endDate: endDate,
    targetCount: 21,
    status: status,
    participantCount: 3,
    joined: joined,
    myCheckedCount: joined ? 12 : null,
    myAchieved: false,
    createdBy: 'user-1',
    isMine: false,
    groupId: groupId,
    groupName: groupName,
  );
}

class _FakeRoutineRepository extends RoutineRepository {
  _FakeRoutineRepository({
    List<Routine>? routines,
    this.groups = const [],
    this.categories = const [],
    this.checkShouldThrow = false,
    this.newlyEarnedBadgesOnCheck = const [],
    this.streakAfterCheck,
    this.streakBeforeCheck,
    this.myChallenges = const [],
  }) : _routines = routines ?? [_buildRoutine()];

  final List<Routine> _routines;
  final List<RoutineGroup> groups;
  final List<RoutineCategory> categories;
  final bool checkShouldThrow;
  final List<UserRoutineBadge> newlyEarnedBadgesOnCheck;
  final RoutineStreak? streakAfterCheck;
  final RoutineStreak? streakBeforeCheck;
  final List<RoutineChallenge> myChallenges;

  int checkCallCount = 0;
  int uncheckCallCount = 0;
  int getStreakCallCount = 0;
  int deleteRoutineGroupCallCount = 0;
  int pauseCallCount = 0;
  int resumeCallCount = 0;
  int deleteRoutineCategoryCallCount = 0;
  CheckRoutineDto? lastCheckDto;
  RoutineChallengeStatus? lastMyChallengesStatus;
  int getMyChallengesCallCount = 0;

  @override
  Future<List<RoutineChallenge>> getMyChallenges({
    RoutineChallengeStatus? status,
  }) async {
    getMyChallengesCallCount += 1;
    lastMyChallengesStatus = status;
    if (status == null) return myChallenges;
    return myChallenges.where((c) => c.status == status).toList();
  }

  @override
  Future<List<Routine>> getRoutines({
    RoutineStatus? status,
    String? routineGroupId,
    String? categoryId,
    String? date,
  }) async => _routines;

  @override
  Future<Routine> getRoutine(String id) async =>
      _routines.firstWhere((r) => r.id == id);

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
  Future<List<RoutineCategory>> getRoutineCategories() async => categories;

  /// 체크 시 routineDailyStreakProvider가 무효화되면서 호출된다. 스텁을
  /// 두지 않으면 실제 네트워크(ApiClient)를 타서 테스트가 깨진다.
  @override
  Future<RoutineDailyStreak> getDailyStreak() async => const RoutineDailyStreak(
    currentStreakDays: 0,
    longestStreakDays: 0,
    totalAchievedDays: 0,
    perfectWeeksCount: 0,
    todayAchieved: false,
    todayCheckedCount: 0,
    todayTargetCount: 0,
    recent14Days: RoutineRecent14Days(
      achievedDays: 0,
      exceededDays: 0,
      totalDays: 0,
      averageCheckedCount: 0,
    ),
  );

  @override
  Future<RoutineCategory> createRoutineCategory(
    CreateRoutineCategoryDto dto,
  ) async {
    return RoutineCategory(
      id: 'category-new',
      title: dto.title,
      emoji: dto.emoji,
      color: dto.color,
      sortOrder: categories.length,
      createdAt: _fixedDate(),
      updatedAt: _fixedDate(),
    );
  }

  @override
  Future<void> deleteRoutineCategory(String id) async {
    deleteRoutineCategoryCallCount++;
  }

  @override
  Future<Routine> pauseRoutine(String id) async {
    pauseCallCount++;
    final routine = _routines.firstWhere((r) => r.id == id);
    return routine.copyWith(status: RoutineStatus.paused);
  }

  @override
  Future<Routine> resumeRoutine(String id) async {
    resumeCallCount++;
    final routine = _routines.firstWhere((r) => r.id == id);
    return routine.copyWith(status: RoutineStatus.active);
  }

  @override
  Future<RoutineLog> checkRoutine(String id, CheckRoutineDto dto) async {
    checkCallCount++;
    lastCheckDto = dto;
    if (checkShouldThrow) {
      throw Exception('네트워크 오류');
    }
    return RoutineLog(
      id: 'log-1',
      routineId: id,
      checkedDate: _fixedDate(),
      textValue: dto.textValue,
      numericValue: dto.numericValue,
      timeValue: dto.timeValue,
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
        overrides: [routineRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      // 목록을 먼저 로드해 초기 상태를 만든다
      await container.read(routineListProvider(null).future);

      final result = await container
          .read(routineManagementProvider.notifier)
          .toggleCheck('routine-1', false);

      expect(result.success, isTrue);
      final routines = container.read(routineListProvider(null)).value!;
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
        overrides: [routineRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container.read(routineListProvider(null).future);

      final result = await container
          .read(routineManagementProvider.notifier)
          .toggleCheck('routine-1', false);

      expect(result.success, isFalse);
      final routines = container.read(routineListProvider(null)).value!;
      expect(
        routines.single.checkedToday,
        isFalse,
        reason: '체크 API 실패 시 낙관적 업데이트가 롤백되어야 한다',
      );
    });

    test('체크 취소 시 uncheckRoutine이 호출되고 checkedToday가 false로 반영된다', () async {
      final repository = _FakeRoutineRepository(
        routines: [_buildRoutine(checkedToday: true)],
      );
      final container = ProviderContainer(
        overrides: [routineRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container.read(routineListProvider(null).future);

      final result = await container
          .read(routineManagementProvider.notifier)
          .toggleCheck('routine-1', true);

      expect(result.success, isTrue);
      expect(repository.uncheckCallCount, 1);
      expect(repository.checkCallCount, 0);
      final routines = container.read(routineListProvider(null)).value!;
      expect(routines.single.checkedToday, isFalse);
    });

    test('스트릭이 이전보다 증가하면 streakIncreased가 true를 반환한다', () async {
      final repository = _FakeRoutineRepository(
        routines: [_buildRoutine(checkedToday: false)],
        streakBeforeCheck: _buildStreak(currentStreakDays: 4),
        streakAfterCheck: _buildStreak(currentStreakDays: 5),
      );
      final container = ProviderContainer(
        overrides: [routineRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container.read(routineListProvider(null).future);
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
        overrides: [routineRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container.read(routineListProvider(null).future);

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
        overrides: [routineRepositoryProvider.overrideWithValue(repository)],
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
        overrides: [routineRepositoryProvider.overrideWithValue(repository)],
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
        overrides: [routineRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container.read(routineGroupListProvider.future);
      await container.read(routineListProvider(null).future);

      final success = await container
          .read(routineGroupManagementProvider.notifier)
          .deleteRoutineGroup('group-1');

      expect(success, isTrue);
      expect(repository.deleteRoutineGroupCallCount, 1);
      final groups = container.read(routineGroupListProvider).value!;
      expect(groups, isEmpty);
    });
  });

  group('RoutineList.build', () {
    test('status 파라미터 없이 조회한다 (ACTIVE+PAUSED 모두 노출, ENDED는 서버가 제외)', () async {
      final repository = _FakeRoutineRepository(
        routines: [
          _buildRoutine(id: 'r1', status: RoutineStatus.active),
          _buildRoutine(id: 'r2', status: RoutineStatus.paused),
        ],
      );
      final container = ProviderContainer(
        overrides: [routineRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      final routines = await container.read(routineListProvider(null).future);

      expect(routines.length, 2);
      expect(
        routines.map((r) => r.status),
        containsAll([RoutineStatus.active, RoutineStatus.paused]),
      );
    });
  });

  group('RoutineManagementNotifier.toggleCheck (recordType별 값 전달)', () {
    test('TEXT 습관 체크 시 textValue가 DTO에 담겨 전달된다', () async {
      final repository = _FakeRoutineRepository(
        routines: [
          _buildRoutine(
            checkedToday: false,
            recordType: RoutineRecordType.text,
          ),
        ],
      );
      final container = ProviderContainer(
        overrides: [routineRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container.read(routineListProvider(null).future);

      await container
          .read(routineManagementProvider.notifier)
          .toggleCheck('routine-1', false, textValue: '컨디션 좋음');

      expect(repository.lastCheckDto?.textValue, '컨디션 좋음');
      expect(repository.lastCheckDto?.numericValue, isNull);
      expect(repository.lastCheckDto?.timeValue, isNull);
    });

    test('NUMERIC 습관 체크 시 numericValue가 DTO에 담겨 전달된다', () async {
      final repository = _FakeRoutineRepository(
        routines: [
          _buildRoutine(
            checkedToday: false,
            recordType: RoutineRecordType.numeric,
          ),
        ],
      );
      final container = ProviderContainer(
        overrides: [routineRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container.read(routineListProvider(null).future);

      await container
          .read(routineManagementProvider.notifier)
          .toggleCheck('routine-1', false, numericValue: 12);

      expect(repository.lastCheckDto?.numericValue, 12);
    });

    test('TIME 습관 체크 시 timeValue가 DTO에 담겨 전달된다', () async {
      final repository = _FakeRoutineRepository(
        routines: [
          _buildRoutine(
            checkedToday: false,
            recordType: RoutineRecordType.time,
          ),
        ],
      );
      final container = ProviderContainer(
        overrides: [routineRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container.read(routineListProvider(null).future);

      await container
          .read(routineManagementProvider.notifier)
          .toggleCheck('routine-1', false, timeValue: '07:30');

      expect(repository.lastCheckDto?.timeValue, '07:30');
    });
  });

  group('RoutineManagementNotifier.pauseRoutine / resumeRoutine', () {
    test('일시정지 성공 시 목록 항목의 status가 paused로 갱신된다', () async {
      final repository = _FakeRoutineRepository(
        routines: [_buildRoutine(status: RoutineStatus.active)],
      );
      final container = ProviderContainer(
        overrides: [routineRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container.read(routineListProvider(null).future);

      final result = await container
          .read(routineManagementProvider.notifier)
          .pauseRoutine('routine-1');

      expect(result?.status, RoutineStatus.paused);
      expect(repository.pauseCallCount, 1);
      final routines = container.read(routineListProvider(null)).value!;
      expect(routines.single.status, RoutineStatus.paused);
    });

    test('재개 성공 시 목록 항목의 status가 active로 갱신된다', () async {
      final repository = _FakeRoutineRepository(
        routines: [_buildRoutine(status: RoutineStatus.paused)],
      );
      final container = ProviderContainer(
        overrides: [routineRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container.read(routineListProvider(null).future);

      final result = await container
          .read(routineManagementProvider.notifier)
          .resumeRoutine('routine-1');

      expect(result?.status, RoutineStatus.active);
      expect(repository.resumeCallCount, 1);
      final routines = container.read(routineListProvider(null)).value!;
      expect(routines.single.status, RoutineStatus.active);
    });
  });

  group('RoutineCategoryList / RoutineCategoryManagementNotifier', () {
    test('카테고리 목록을 로드한다', () async {
      final repository = _FakeRoutineRepository(
        categories: [_buildCategory(title: '규칙적인 삶')],
      );
      final container = ProviderContainer(
        overrides: [routineRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      final categories = await container.read(
        routineCategoryListProvider.future,
      );

      expect(categories.single.title, '규칙적인 삶');
    });

    test('카테고리 생성 성공 시 목록에 추가된다', () async {
      final repository = _FakeRoutineRepository(categories: const []);
      final container = ProviderContainer(
        overrides: [routineRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container.read(routineCategoryListProvider.future);

      final created = await container
          .read(routineCategoryManagementProvider.notifier)
          .createRoutineCategory(const CreateRoutineCategoryDto(title: '건강'));

      expect(created, isNotNull);
      final categories = container.read(routineCategoryListProvider).value!;
      expect(categories.single.title, '건강');
    });

    test('카테고리 삭제 성공 시 목록에서 제거되고 습관 목록도 refresh된다', () async {
      final repository = _FakeRoutineRepository(
        routines: [_buildRoutine()],
        categories: [_buildCategory()],
      );
      final container = ProviderContainer(
        overrides: [routineRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container.read(routineCategoryListProvider.future);
      await container.read(routineListProvider(null).future);

      final success = await container
          .read(routineCategoryManagementProvider.notifier)
          .deleteRoutineCategory('category-1');

      expect(success, isTrue);
      expect(repository.deleteRoutineCategoryCallCount, 1);
      final categories = container.read(routineCategoryListProvider).value!;
      expect(categories, isEmpty);
    });
  });

  group('routineMyChallenges (전체 그룹 챌린지)', () {
    test('소속 그룹 전체의 챌린지를 groupId/groupName과 함께 반환한다', () async {
      final repository = _FakeRoutineRepository(
        myChallenges: [
          _buildChallenge(
            id: 'challenge-1',
            status: RoutineChallengeStatus.ongoing,
            endDate: DateTime(2026, 7, 5),
            groupId: 'group-2',
            groupName: '러닝 크루',
          ),
        ],
      );
      final container = ProviderContainer(
        overrides: [routineRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      final challenges = await container.read(
        routineMyChallengesProvider.future,
      );

      expect(repository.getMyChallengesCallCount, 1);
      // 상태 필터 없이 호출한다 (서버가 ENDED를 항상 제외한다)
      expect(repository.lastMyChallengesStatus, isNull);
      expect(challenges, hasLength(1));
      expect(challenges.first.groupId, 'group-2');
      expect(challenges.first.groupName, '러닝 크루');
    });

    test('그룹별 조회 응답에는 groupId/groupName이 없어 null로 파싱된다', () {
      final challenge = RoutineChallenge.fromJson({
        'id': 'challenge-1',
        'title': '물 마시기',
        'startDate': '2026-07-01T00:00:00Z',
        'endDate': '2026-07-21T00:00:00Z',
        'targetCount': 21,
        'status': 'ONGOING',
        'participantCount': 3,
        'joined': true,
        'myCheckedCount': 12,
        'myAchieved': false,
        'createdBy': 'user-1',
        'isMine': false,
      });

      expect(challenge.groupId, isNull);
      expect(challenge.groupName, isNull);
      expect(challenge.myCheckedCount, 12);
    });
  });

  group('RoutineDailyStreak (배지 판정 기준 3종)', () {
    test('배지 기준 3종의 현재값을 모두 파싱한다', () {
      final streak = RoutineDailyStreak.fromJson({
        'currentStreakDays': 5,
        'longestStreakDays': 12,
        'totalAchievedDays': 40,
        'perfectWeeksCount': 3,
        'todayAchieved': true,
        'todayCheckedCount': 2,
        'todayTargetCount': 2,
        'recent14Days': {
          'achievedDays': 10,
          'exceededDays': 2,
          'totalDays': 14,
          'averageCheckedCount': 2.5,
        },
      });

      expect(streak.totalAchievedDays, 40);
      expect(streak.perfectWeeksCount, 3);
    });

    test('신규 필드가 없는 응답도 0으로 파싱해 하위호환을 유지한다', () {
      final streak = RoutineDailyStreak.fromJson({
        'currentStreakDays': 5,
        'longestStreakDays': 12,
        'todayAchieved': false,
        'todayCheckedCount': 1,
        'todayTargetCount': 2,
        'recent14Days': <String, dynamic>{},
      });

      expect(streak.totalAchievedDays, 0);
      expect(streak.perfectWeeksCount, 0);
    });
  });

  group('RoutineSummaryItem (위젯 정렬/체크 분기 필드)', () {
    test('timeFilter와 recordType을 파싱한다', () {
      final item = RoutineSummaryItem.fromJson({
        'routineId': 'routine-1',
        'title': '물 마시기',
        'timeFilter': 'EVENING',
        'recordType': 'NUMERIC',
        'checkedToday': false,
        'currentStreakDays': 3,
      });

      expect(item.timeFilter, RoutineTimeFilter.evening);
      expect(item.recordType, RoutineRecordType.numeric);
    });

    test('두 필드가 없으면 timeFilter는 null, recordType은 BOOLEAN으로 떨어진다', () {
      final item = RoutineSummaryItem.fromJson({
        'routineId': 'routine-1',
        'title': '물 마시기',
        'checkedToday': true,
        'currentStreakDays': 0,
      });

      expect(item.timeFilter, isNull);
      expect(item.recordType, RoutineRecordType.boolean_);
    });
  });
}
