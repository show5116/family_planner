import 'package:klc/klc.dart';

/// 양력 ↔ 음력 변환 유틸리티 (klc 패키지 기반, 한국 음력 기준)
class LunarService {
  LunarService._();

  /// 양력 날짜 → 음력 날짜 변환
  /// 변환 실패 시 null 반환
  static ({int year, int month, int day, bool isLeap})? solarToLunar(DateTime solar) {
    try {
      final ok = setSolarDate(solar.year, solar.month, solar.day);
      if (!ok) return null;

      return (
        year: getLunarYear(),
        month: getLunarMonth(),
        day: getLunarDay(),
        isLeap: isIntercalation,
      );
    } catch (_) {
      return null;
    }
  }

  /// 음력 날짜 → 양력 날짜 변환
  /// 변환 실패 시 null 반환
  static DateTime? lunarToSolar(
    int lunarYear,
    int lunarMonth,
    int lunarDay, {
    bool isLeap = false,
  }) {
    try {
      final ok = setLunarDate(lunarYear, lunarMonth, lunarDay, isLeap);
      if (!ok) return null;

      final isoStr = getSolarIsoFormat(); // "YYYY-MM-DD"
      return DateTime.tryParse(isoStr);
    } catch (_) {
      return null;
    }
  }

  /// 양력 날짜의 음력 표시 문자열 반환
  /// 예: "3/15", 윤달이면 "윤3/15"
  static String? lunarLabel(DateTime solar) {
    final lunar = solarToLunar(solar);
    if (lunar == null) return null;
    final prefix = lunar.isLeap ? '윤' : '';
    return '$prefix${lunar.month}/${lunar.day}';
  }
}
