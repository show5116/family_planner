import 'dart:math';

import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/greeting_presets/greeting_preset_en.dart';
import 'package:family_planner/core/constants/greeting_presets/greeting_preset_ja.dart';
import 'package:family_planner/core/constants/greeting_presets/greeting_preset_ko.dart';
import 'package:family_planner/core/constants/greeting_presets/greeting_preset_zh.dart';
import 'package:family_planner/core/models/greeting_settings.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 대시보드 인사말 기본 제공 문구와 선택 로직
///
/// 문구 본문은 UI 라벨이 아니라 콘텐츠라서 ARB가 아니라 언어별 상수 파일에 둔다
/// (172개 × 4개 국어라 ARB에 넣으면 생성 코드가 과도하게 커진다).
class GreetingPresets {
  const GreetingPresets._();

  static const Map<String, Map<String, List<String>>> _byLanguage = {
    'ko': kGreetingPresetsKo,
    'en': kGreetingPresetsEn,
    'ja': kGreetingPresetsJa,
    'zh': kGreetingPresetsZh,
  };

  /// 팩 이름 (설정 화면 표시용)
  static String packLabel(AppLocalizations l10n, String packId) {
    switch (packId) {
      case GreetingPackIds.infant:
        return l10n.greeting_packInfant;
      case GreetingPackIds.toddler:
        return l10n.greeting_packToddler;
      case GreetingPackIds.preschool:
        return l10n.greeting_packPreschool;
      case GreetingPackIds.school:
        return l10n.greeting_packSchool;
      case GreetingPackIds.teen:
        return l10n.greeting_packTeen;
      case GreetingPackIds.parenting:
        return l10n.greeting_packParenting;
      case GreetingPackIds.quote:
        return l10n.greeting_packQuote;
      case GreetingPackIds.cheer:
        return l10n.greeting_packCheer;
      case GreetingPackIds.choreKitchen:
        return l10n.greeting_packChoreKitchen;
      case GreetingPackIds.choreLaundry:
        return l10n.greeting_packChoreLaundry;
      case GreetingPackIds.choreCleaning:
        return l10n.greeting_packChoreCleaning;
      case GreetingPackIds.englishDaily:
        return l10n.greeting_packEnglishDaily;
      case GreetingPackIds.englishTravel:
        return l10n.greeting_packEnglishTravel;
      case GreetingPackIds.englishWork:
        return l10n.greeting_packEnglishWork;
      default:
        return packId;
    }
  }

  /// 팩 묶음 이름 (설정 화면 소제목)
  ///
  /// [groupIndex]는 [GreetingPackIds.groups]의 순서와 같다.
  static String groupLabel(AppLocalizations l10n, int groupIndex) {
    switch (groupIndex) {
      case 0:
        return l10n.greeting_groupChild;
      case 1:
        return l10n.greeting_groupMind;
      case 2:
        return l10n.greeting_groupChore;
      default:
        return l10n.greeting_groupEnglish;
    }
  }

  /// 팩 아이콘
  static IconData packIcon(String packId) {
    switch (packId) {
      case GreetingPackIds.infant:
        return Icons.child_friendly_outlined;
      case GreetingPackIds.toddler:
        return Icons.child_care_outlined;
      case GreetingPackIds.preschool:
        return Icons.toys_outlined;
      case GreetingPackIds.school:
        return Icons.backpack_outlined;
      case GreetingPackIds.teen:
        return Icons.school_outlined;
      case GreetingPackIds.parenting:
        return Icons.favorite_outline;
      case GreetingPackIds.quote:
        return Icons.format_quote_outlined;
      case GreetingPackIds.cheer:
        return Icons.emoji_emotions_outlined;
      case GreetingPackIds.choreKitchen:
        return Icons.kitchen_outlined;
      case GreetingPackIds.choreLaundry:
        return Icons.local_laundry_service_outlined;
      case GreetingPackIds.choreCleaning:
        return Icons.cleaning_services_outlined;
      case GreetingPackIds.englishDaily:
        return Icons.chat_outlined;
      case GreetingPackIds.englishTravel:
        return Icons.flight_takeoff_outlined;
      case GreetingPackIds.englishWork:
        return Icons.mail_outlined;
      default:
        return Icons.chat_bubble_outline;
    }
  }

  /// 팩에 포함된 문구 목록
  ///
  /// 지원하지 않는 언어는 한국어로 폴백한다.
  static List<String> messages(String languageCode, String packId) {
    final packs = _byLanguage[languageCode] ?? kGreetingPresetsKo;
    return packs[packId] ?? const [];
  }

  /// 활성화된 팩 문구 + 사용자 문구를 합친 후보 목록
  static List<String> buildPool(
    String languageCode,
    GreetingSettings settings,
  ) {
    if (!settings.enabled) return const [];
    return [
      for (final packId in settings.enabledPacks)
        ...messages(languageCode, packId),
      ...settings.customMessages,
    ];
  }

  /// 오늘 보여줄 문구를 고른다 (후보가 없으면 null)
  ///
  /// 같은 날에는 항상 같은 문구가 나오도록 날짜를 시드로 쓴다.
  /// [rotation]은 사용자가 수동으로 다음 문구를 요청한 횟수다.
  static String? pickMessage(
    List<String> pool, {
    required DateTime date,
    int rotation = 0,
  }) {
    if (pool.isEmpty) return null;
    final daySeed = DateTime(date.year, date.month, date.day)
        .millisecondsSinceEpoch
        .hashCode;
    return pool[Random(daySeed + rotation).nextInt(pool.length)];
  }
}
