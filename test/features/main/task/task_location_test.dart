import 'package:flutter_test/flutter_test.dart';

import 'package:family_planner/features/main/task/data/models/task_model.dart';

/// 서버 스키마에서 장소는 name만 필수이고 address·lat·lng는 선택입니다.
/// 예전에는 셋을 필수로 읽어서, 장소명만 있는 일정이 하나라도 섞이면
/// 목록 응답 전체 파싱이 실패했습니다. 화면에는 에러가 아니라
/// "오늘 일정이 없습니다"로 보여 원인을 찾기 어려웠습니다.
void main() {
  Map<String, dynamic> taskJson(Map<String, dynamic>? location) => {
        'id': 'task-1',
        'userId': 'user-1',
        'groupId': 'group-1',
        'title': '어린이집 학부모 상담',
        'type': 'CALENDAR_ONLY',
        'status': 'PENDING',
        'priority': 'MEDIUM',
        'allDay': false,
        'scheduledAt': '2026-08-31T01:30:00.000Z',
        'createdAt': '2026-08-31T00:00:00.000Z',
        'updatedAt': '2026-08-31T00:00:00.000Z',
        if (location != null) 'location': location,
      };

  group('TaskLocation.fromJson', () {
    test('네 값이 모두 있으면 그대로 읽는다', () {
      final location = TaskLocation.fromJson({
        'name': '햇살 어린이집',
        'address': '서울 마포구 월드컵북로 120',
        'lat': 37.5665,
        'lng': 126.978,
      });

      expect(location.name, '햇살 어린이집');
      expect(location.address, '서울 마포구 월드컵북로 120');
      expect(location.lat, 37.5665);
      expect(location.lng, 126.978);
      expect(location.hasCoordinates, isTrue);
    });

    test('장소명만 있어도 파싱된다', () {
      final location = TaskLocation.fromJson({'name': '동네 삼겹살집'});

      expect(location.name, '동네 삼겹살집');
      expect(location.address, isNull);
      expect(location.lat, isNull);
      expect(location.lng, isNull);
      expect(location.hasCoordinates, isFalse);
    });

    test('좌표 한쪽만 있으면 지도에 찍을 수 없다', () {
      final location = TaskLocation.fromJson({'name': '어딘가', 'lat': 37.5});

      expect(location.hasCoordinates, isFalse);
    });

    test('toJson은 비어 있는 값을 빼고 보낸다', () {
      expect(
        const TaskLocation(name: '동네 삼겹살집').toJson(),
        {'name': '동네 삼겹살집'},
      );
      expect(
        const TaskLocation(
          name: '햇살 어린이집',
          address: '서울 마포구 월드컵북로 120',
          lat: 37.5665,
          lng: 126.978,
        ).toJson(),
        {
          'name': '햇살 어린이집',
          'address': '서울 마포구 월드컵북로 120',
          'lat': 37.5665,
          'lng': 126.978,
        },
      );
    });
  });

  group('TaskModel 목록 파싱', () {
    test('장소명만 있는 일정이 섞여도 목록 전체가 파싱된다', () {
      final response = TaskListResponse.fromJson({
        'data': [
          taskJson({
            'name': '햇살 어린이집',
            'address': '서울 마포구 월드컵북로 120',
            'lat': 37.5665,
            'lng': 126.978,
          }),
          taskJson({'name': '동네 삼겹살집'}),
          taskJson(null),
        ],
        'meta': {'page': 1, 'limit': 50, 'total': 3, 'totalPages': 1},
      });

      expect(response.data, hasLength(3));
      expect(response.data[1].location?.name, '동네 삼겹살집');
      expect(response.data[1].location?.hasCoordinates, isFalse);
      expect(response.data[2].location, isNull);
    });
  });
}
