import 'package:intl/intl.dart';

/// 다이어리 하루 경계 시각 (기기 로컬 기준 시)
///
/// 자정 기준이면 새벽 1시에 남긴 기록이 "내일 일기"가 되어 체감과 어긋난다.
/// 서버(`diaryDateInKst`)와 같은 값을 써야 한다.
const int kDiaryDayBoundaryHour = 4;

final DateFormat _ymd = DateFormat('yyyy-MM-dd');
final DateFormat _hm = DateFormat('HH:mm');

/// 다이어리의 "오늘" 날짜 ('YYYY-MM-DD')
///
/// 하루 경계가 새벽 4시이므로, 새벽 3시 59분까지는 전날 날짜를 돌려준다.
///
/// 기준은 **기기 로컬 시각**이다. 서버는 KST로 판정하지만, 해외에서 쓰는
/// 사용자에게는 자기 시간대의 "오늘"이 맞다. 그래서 클라이언트가 계산한
/// 날짜를 문자열로 명시해 보낸다(서버 기본값에 맡기지 않는다).
String diaryToday([DateTime? now]) {
  final base = (now ?? DateTime.now()).subtract(
    const Duration(hours: kDiaryDayBoundaryHour),
  );
  return _ymd.format(base);
}

/// DateTime을 'YYYY-MM-DD'로 변환 (시각 성분 제거)
String toDiaryDate(DateTime date) => _ymd.format(date);

/// 'YYYY-MM-DD'를 로컬 DateTime(자정)으로 파싱
///
/// `DateTime.parse`는 타임존 해석이 끼어들 수 있으므로 직접 분해한다.
DateTime parseDiaryDate(String date) {
  final parts = date.split('-');
  return DateTime(
    int.parse(parts[0]),
    int.parse(parts[1]),
    int.parse(parts[2]),
  );
}

/// 빠른 기록의 조각 시각 마커 ('HH:mm')
String diaryCapturedAt([DateTime? now]) => _hm.format(now ?? DateTime.now());

/// 미래 날짜인지 확인 (하루 경계 반영)
bool isFutureDiaryDate(String date) =>
    date.compareTo(diaryToday()) > 0;

/// 오늘 날짜인지 확인 (하루 경계 반영)
bool isDiaryToday(String date) => date == diaryToday();
