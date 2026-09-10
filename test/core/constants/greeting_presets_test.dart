import 'package:flutter_test/flutter_test.dart';

import 'package:family_planner/core/constants/greeting_presets.dart';
import 'package:family_planner/core/models/greeting_settings.dart';

void main() {
  final pool = List.generate(16, (i) => 'M$i');

  group('GreetingPresets.pickMessage', () {
    test('후보가 없으면 null (시간대 인사말로 폴백)', () {
      expect(
        GreetingPresets.pickMessage(const [], date: DateTime(2026, 9, 10)),
        isNull,
      );
    });

    test('같은 날짜면 시각이 달라도 같은 문구', () {
      final morning = GreetingPresets.pickMessage(
        pool,
        date: DateTime(2026, 9, 10, 0, 1),
      );
      final night = GreetingPresets.pickMessage(
        pool,
        date: DateTime(2026, 9, 10, 23, 59),
      );
      expect(morning, night);
    });

    test('날짜가 바뀌면 문구도 바뀔 수 있다', () {
      final picks = List.generate(
        14,
        (i) => GreetingPresets.pickMessage(
          pool,
          date: DateTime(2026, 9, 10).add(Duration(days: i)),
        ),
      );
      // 14일 동안 최소 절반 이상은 서로 다른 문구가 나와야 한다
      expect(picks.toSet().length, greaterThan(pool.length ~/ 4));
    });

    test('rotation을 올리면 다른 문구로 넘어간다', () {
      final first = GreetingPresets.pickMessage(pool, date: DateTime(2026, 9, 10));
      final rotated = List.generate(
        4,
        (i) => GreetingPresets.pickMessage(
          pool,
          date: DateTime(2026, 9, 10),
          rotation: i + 1,
        ),
      );
      expect(rotated.contains(first) && rotated.toSet().length == 1, isFalse);
    });

    test('문구가 1개뿐이면 항상 그 문구', () {
      expect(
        GreetingPresets.pickMessage(
          const ['하나뿐'],
          date: DateTime(2026, 9, 10),
          rotation: 7,
        ),
        '하나뿐',
      );
    });
  });

  group('기본 제공 문구 팩', () {
    test('모든 팩이 4개 국어 모두에서 같은 개수를 가진다', () {
      for (final packId in GreetingPackIds.all) {
        final ko = GreetingPresets.messages('ko', packId);
        expect(ko.length, greaterThanOrEqualTo(20), reason: packId);
        for (final lang in ['en', 'ja', 'zh']) {
          expect(
            GreetingPresets.messages(lang, packId).length,
            ko.length,
            reason: '$packId / $lang',
          );
        }
      }
    });

    test('빈 문구나 중복 문구가 없다', () {
      for (final lang in ['ko', 'en', 'ja', 'zh']) {
        for (final packId in GreetingPackIds.all) {
          final messages = GreetingPresets.messages(lang, packId);
          expect(messages.any((m) => m.trim().isEmpty), isFalse,
              reason: '$packId / $lang');
          expect(messages.toSet().length, messages.length,
              reason: '$packId / $lang');
        }
      }
    });

    test('지원하지 않는 언어는 한국어로 폴백한다', () {
      expect(
        GreetingPresets.messages('fr', GreetingPackIds.quote),
        GreetingPresets.messages('ko', GreetingPackIds.quote),
      );
    });

    test('꺼진 상태에서는 후보가 비어 있다', () {
      const settings = GreetingSettings(enabled: false);
      expect(GreetingPresets.buildPool('ko', settings), isEmpty);
    });

    test('활성 팩 문구와 내 문구가 모두 후보에 들어간다', () {
      const settings = GreetingSettings(
        enabledPacks: [GreetingPackIds.quote],
        customMessages: ['내가 쓴 문구'],
      );
      final pool = GreetingPresets.buildPool('ko', settings);

      expect(pool, contains('내가 쓴 문구'));
      expect(
        pool.length,
        GreetingPresets.messages('ko', GreetingPackIds.quote).length + 1,
      );
    });
  });

  group('GreetingSettings 직렬화', () {
    test('저장한 값이 그대로 복원된다', () {
      const settings = GreetingSettings(
        enabled: false,
        enabledPacks: [GreetingPackIds.teen],
        customMessages: ['오늘도 화이팅'],
      );
      final restored = GreetingSettings.fromJson(settings.toJson());

      expect(restored.enabled, isFalse);
      expect(restored.enabledPacks, [GreetingPackIds.teen]);
      expect(restored.customMessages, ['오늘도 화이팅']);
    });

    test('알 수 없는 팩 ID는 걸러낸다', () {
      final restored = GreetingSettings.fromJson({
        'enabled': true,
        'enabledPacks': ['quote', 'unknownPack'],
        'customMessages': <String>[],
      });

      expect(restored.enabledPacks, [GreetingPackIds.quote]);
    });

    test('비어 있는 저장값도 안전하게 읽는다', () {
      final restored = GreetingSettings.fromJson(const {});

      expect(restored.enabled, isTrue);
      expect(restored.enabledPacks, isEmpty);
      expect(restored.customMessages, isEmpty);
    });
  });
}
