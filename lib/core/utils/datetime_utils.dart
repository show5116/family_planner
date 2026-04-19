extension DateTimeLocalX on DateTime {
  /// API 응답(UTC)을 로컬로 변환
  DateTime get local => toLocal();

  /// 로컬 시간을 API 전송용 UTC ISO 문자열로 변환
  String toApiString() => toUtc().toIso8601String();
}

extension DateTimeNullableLocalX on DateTime? {
  /// null-safe 로컬 변환
  DateTime? get local => this?.toLocal();
}
