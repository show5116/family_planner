import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// String 확장 메서드
extension StringExtensions on String {
  /// 문자열이 비어있는지 확인 (null-safe)
  bool get isEmptyOrNull => isEmpty;

  /// 첫 글자를 대문자로 변환
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// 이메일 형식 검증
  bool get isValidEmail {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(this);
  }

  /// 전화번호 형식 검증 (한국)
  bool get isValidPhoneNumber {
    return RegExp(
      r'^01[0-9]-?[0-9]{3,4}-?[0-9]{4}$',
    ).hasMatch(this);
  }
}

/// DateTime 확장 메서드
extension DateTimeExtensions on DateTime {
  /// 날짜를 'yyyy-MM-dd' 형식으로 포맷
  String toDateString() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  /// 날짜를 'yyyy년 MM월 dd일' 형식으로 포맷
  String toKoreanDateString() {
    return DateFormat('yyyy년 MM월 dd일').format(this);
  }

  /// 시간을 'HH:mm' 형식으로 포맷
  String toTimeString() {
    return DateFormat('HH:mm').format(this);
  }

  /// 날짜와 시간을 'yyyy-MM-dd HH:mm' 형식으로 포맷
  String toDateTimeString() {
    return DateFormat('yyyy-MM-dd HH:mm').format(this);
  }

  /// 오늘인지 확인
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// 어제인지 확인
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// 내일인지 확인
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// 이번 주인지 확인
  bool get isThisWeek {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    return isAfter(weekStart.subtract(const Duration(days: 1))) &&
        isBefore(weekEnd.add(const Duration(days: 1)));
  }
}

/// int 확장 메서드 (금액 관련)
extension IntExtensions on int {
  /// 숫자를 금액 형식으로 포맷 (예: 1000000 -> "1,000,000원")
  String toCurrency() {
    final formatter = NumberFormat('#,###');
    return '${formatter.format(this)}원';
  }

  /// 퍼센트 형식으로 포맷 (예: 5 -> "5%")
  String toPercent() {
    return '$this%';
  }
}

/// double 확장 메서드
extension DoubleExtensions on double {
  /// 숫자를 금액 형식으로 포맷 (예: 1000000.5 -> "1,000,000.5원")
  String toCurrency() {
    final formatter = NumberFormat('#,###.##');
    return '${formatter.format(this)}원';
  }

  /// 퍼센트 형식으로 포맷 (예: 5.2 -> "5.2%")
  String toPercent({int decimalDigits = 1}) {
    return '${toStringAsFixed(decimalDigits)}%';
  }

  /// 수익률에 따라 색상 반환
  Color get profitColor {
    if (this > 0) return Colors.red; // 수익 (한국 주식 시장 컬러)
    if (this < 0) return Colors.blue; // 손실
    return Colors.grey; // 변동 없음
  }
}

/// BuildContext 확장 메서드
extension BuildContextExtensions on BuildContext {
  /// MediaQuery 접근 간소화
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  /// Theme 접근 간소화
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  /// 스낵바 표시
  void showSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 2),
      ),
    );
  }

  /// 에러 스낵바 표시
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colorScheme.error,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// 성공 스낵바 표시
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// 화면이 모바일인지 확인
  bool get isMobile => screenWidth < 600;

  /// 화면이 태블릿인지 확인
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;

  /// 화면이 데스크톱인지 확인
  bool get isDesktop => screenWidth >= 1024;
}
