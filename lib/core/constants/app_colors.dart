import 'package:flutter/material.dart';

/// Family Planner 앱의 색상 상수
/// UI_ARCHITECTURE.md의 디자인 시스템을 기반으로 함
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary Colors
  static const Color primary = Color(0xFF2196F3); // Blue 500
  static const Color primaryLight = Color(0xFFBBDEFB); // Blue 100
  static const Color primaryDark = Color(0xFF1976D2); // Blue 700

  // Secondary Colors
  static const Color secondary = Color(0xFFFF9800); // Orange 500
  static const Color secondaryLight = Color(0xFFFFE0B2); // Orange 100
  static const Color secondaryDark = Color(0xFFF57C00); // Orange 700

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50); // Green 500
  static const Color warning = Color(0xFFFFC107); // Amber 500
  static const Color error = Color(0xFFF44336); // Red 500
  static const Color info = Color(0xFF2196F3); // Blue 500

  // Neutral Colors - Light Theme
  static const Color background = Color(0xFFFAFAFA); // Grey 50
  static const Color surface = Color(0xFFFFFFFF); // White
  static const Color textPrimary = Color(0xFF212121); // Grey 900
  static const Color textSecondary = Color(0xFF757575); // Grey 600
  static const Color divider = Color(0xFFBDBDBD); // Grey 400

  // Neutral Colors - Dark Theme
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color primaryLightDark = Color(0xFF90CAF9); // Blue 200
  static const Color secondaryLightDark = Color(0xFFFFCC80); // Orange 200
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);

  // Functional Colors
  static const Color income = Color(0xFF4CAF50); // Green - 수익, 수입
  static const Color expense = Color(0xFFF44336); // Red - 지출, 손실
  static const Color asset = Color(0xFF2196F3); // Blue - 자산
  static const Color investment = Color(0xFF9C27B0); // Purple - 투자
  static const Color childPoints = Color(0xFFFF9800); // Orange - 육아 포인트

  // Category Colors (for charts)
  static const List<Color> chartColors = [
    Color(0xFF2196F3), // Blue
    Color(0xFFFF9800), // Orange
    Color(0xFF4CAF50), // Green
    Color(0xFFF44336), // Red
    Color(0xFF9C27B0), // Purple
    Color(0xFFFFEB3B), // Yellow
    Color(0xFF00BCD4), // Cyan
    Color(0xFFE91E63), // Pink
    Color(0xFF3F51B5), // Indigo
    Color(0xFF009688), // Teal
  ];
}
