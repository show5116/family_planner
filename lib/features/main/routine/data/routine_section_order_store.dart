import 'package:shared_preferences/shared_preferences.dart';

/// 루틴 목록 화면의 "섹션" 순서. 섹션은 루틴 그룹 각각(카드) 또는 독립
/// 습관 각각(카드 없는 표 행 하나)이며, 이 배열 순서대로 화면에 섞여
/// 렌더링된다. 서버는 그룹끼리의 순서(sortOrder)만 알고 독립 습관이 그
/// 사이 어디에 오는지는 개념이 없으므로 기기 로컬에 순서 배열 전체를
/// 저장한다.
class RoutineSectionOrderStore {
  RoutineSectionOrderStore._();

  static const String _key = 'routine_section_order';
  static const String _standalonePrefix = 'routine:';

  /// 독립 습관 [routineId]를 섹션 순서 배열에 담을 항목 문자열로 인코딩.
  static String encodeStandalone(String routineId) =>
      '$_standalonePrefix$routineId';

  /// [encodeStandalone]으로 인코딩된 항목이면 원래 routine id를,
  /// 그룹 id(또는 알 수 없는 값)면 null을 반환.
  static String? decodeStandaloneRoutineId(String item) =>
      item.startsWith(_standalonePrefix)
      ? item.substring(_standalonePrefix.length)
      : null;

  /// 저장된 섹션 순서(그룹 id 또는 [encodeStandalone] 결과의 배열)를
  /// 불러온다. 저장된 값이 없으면 빈 리스트를 반환한다.
  static Future<List<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? const [];
  }

  static Future<void> save(List<String> sectionOrder) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, sectionOrder);
  }
}
