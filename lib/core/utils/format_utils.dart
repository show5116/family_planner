/// 투자 지표 가격 포맷 유틸
///
/// - 1,000 미만        → 소수점 2자리  (예: 1,234.56)
/// - 1,000 ~ 1,000만  → 정수 + 콤마   (예: 1,234)
/// - 1,000만 이상      → 만 단위 절삭  (예: 13,045만)
String formatIndicatorPrice(double value) {
  const tenMillion = 10000000.0; // 1,000만
  const thousand = 1000.0;

  if (value >= tenMillion) {
    final man = (value / 10000).round();
    final formatted = man.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
    return '$formatted만';
  }

  if (value >= thousand) {
    final rounded = value.round();
    return rounded.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
  }

  return value.toStringAsFixed(2);
}

/// 변동폭 포맷 (가격과 동일한 기준 적용, 절대값 사용)
String formatIndicatorChange(double change) {
  return formatIndicatorPrice(change.abs());
}
