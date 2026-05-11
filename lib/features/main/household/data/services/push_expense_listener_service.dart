import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_notification_listener/flutter_notification_listener.dart';

import 'package:family_planner/features/main/household/data/models/expense_model.dart';

/// 카드사·은행 결제 알림을 파싱해 지출 정보를 추출한 결과
class ParsedExpense {
  final double amount;
  final ExpenseCategory? category;
  final PaymentMethod paymentMethod;
  final String? description;
  final String sourcePkg;

  const ParsedExpense({
    required this.amount,
    this.category,
    required this.paymentMethod,
    this.description,
    required this.sourcePkg,
  });
}

/// 파싱된 결제 알림을 전달할 싱글턴 콜백 저장소
class _PushCallbackHolder {
  _PushCallbackHolder._();
  static Function(ParsedExpense)? onParsed;
}

/// 중복 결제 알림 제거용 캐시
///
/// 삼성페이처럼 페이 앱 알림 + 카드사 알림이 동시에 오는 경우를 막기 위해
/// (금액, 날짜) 키로 마지막 등록 시각을 기록하고 [_dedupeWindow] 이내 재입력을 무시합니다.
class _DedupeCache {
  _DedupeCache._();

  static const _dedupeWindow = Duration(seconds: 10);
  static final _cache = <String, DateTime>{};

  /// 해당 금액이 중복인지 확인 — 중복이면 true (등록 스킵)
  static bool isDuplicate(double amount, DateTime date) {
    final key = '${amount.toInt()}_${date.year}${date.month}${date.day}';
    final last = _cache[key];
    if (last != null && date.difference(last).abs() < _dedupeWindow) {
      return true;
    }
    _cache[key] = date;
    _cleanOldEntries();
    return false;
  }

  static void _cleanOldEntries() {
    final cutoff = DateTime.now().subtract(const Duration(minutes: 5));
    _cache.removeWhere((_, v) => v.isBefore(cutoff));
  }
}

/// top-level 콜백 — NotificationsListener 요구사항
@pragma('vm:entry-point')
void onNotificationEvent(NotificationEvent event) {
  final pkg = event.packageName ?? '';
  final title = event.title ?? '';
  final text = event.text ?? '';
  final full = '$title $text';

  if (!PushExpenseListenerService.isCardOrBankPackage(pkg) &&
      !PushExpenseListenerService.containsPaymentKeyword(full)) {
    return;
  }

  final amount = PushExpenseListenerService.parseAmount(full);
  if (amount == null || amount <= 0) {
    return;
  }

  // 중복 제거: 동일 금액이 10초 이내에 다시 들어오면 무시
  if (_DedupeCache.isDuplicate(amount, DateTime.now())) {
    debugPrint('[PushExpenseListener] 중복 알림 무시: ${amount.toInt()}원 ($pkg)');
    return;
  }


  final parsed = ParsedExpense(
    amount: amount,
    category: PushExpenseListenerService.inferCategory(full),
    paymentMethod: PushExpenseListenerService.inferPaymentMethod(full, pkg),
    description: PushExpenseListenerService.buildDescription(title, text),
    sourcePkg: pkg,
  );

  _PushCallbackHolder.onParsed?.call(parsed);
}

/// 결제 알림 자동 파싱 서비스 (Android 전용)
///
/// 앱이 포그라운드 또는 백그라운드에 살아있는 동안만 동작합니다.
/// 앱을 완전히 종료하면 동작하지 않습니다.
class PushExpenseListenerService {
  PushExpenseListenerService._();

  static bool _started = false;

  static Future<void> start(Function(ParsedExpense) onParsed) async {
    if (!_isSupported()) return;
    if (_started) {
      _PushCallbackHolder.onParsed = onParsed;
      return;
    }

    _PushCallbackHolder.onParsed = onParsed;

    await NotificationsListener.initialize(callbackHandle: onNotificationEvent);
    await NotificationsListener.startService(
      foreground: false,
      title: '가계부 자동 등록',
      description: '결제 알림을 감지해 가계부에 자동 등록합니다',
    );
    _started = true;
    debugPrint('[PushExpenseListener] 서비스 시작');
  }

  static Future<void> stop() async {
    if (!_isSupported() || !_started) return;
    await NotificationsListener.stopService();
    _started = false;
    _PushCallbackHolder.onParsed = null;
    debugPrint('[PushExpenseListener] 서비스 중지');
  }

  static Future<bool> isPermissionGranted() async {
    if (!_isSupported()) return false;
    return await NotificationsListener.hasPermission ?? false;
  }

  static Future<void> openPermissionSettings() async {
    if (!_isSupported()) return;
    await NotificationsListener.openPermissionSettings();
  }

  static bool _isSupported() => !kIsWeb && Platform.isAndroid;

  // ── 패키지 목록 ─────────────────────────────────────────────────────────────

  static const _knownPackages = {
    // 페이 서비스
    'com.samsung.android.samsungpay',
    'com.nhn.android.naverpay',
    'com.kakaopay.app',
    'com.nhnent.payapp',           // 페이코
    'com.ssg.serviceapp.android.egiftcard', // SSG페이

    // 카드사 앱
    'com.kbcard.kbkookmincard',    // KB국민카드
    'com.samsung.android.scard',   // 삼성카드
    'com.shinhancard.smartshinhan', // 신한카드
    'com.hyundaicard.cardapp',     // 현대카드
    'com.lottecardapp',            // 롯데카드
    'com.citibank.card.kr',        // 씨티카드
    'com.wooricard.wcard',         // 우리카드
    'com.hanacard.happlication',   // 하나카드
    'com.nhcard',                  // NH농협카드
    'com.bccard.bcmobilecardapp',  // BC카드

    // 은행 앱
    'com.kbstar.kbbank',           // KB국민은행
    'com.shinhan.sbanking',        // 신한은행
    'com.hanabank.ebk.channel.android.hanabank', // 하나은행
    'com.wooribank.smart.woori',   // 우리은행
    'com.ibk.android.smartbank',   // IBK기업은행
    'com.nonghyup.nhallonebank',   // NH농협은행
    'com.kakaobank.channel',       // 카카오뱅크
    'com.kftc.toss',               // 토스
    'viva.republica.toss',         // 토스(구패키지)
    'com.kbankofkorea.kbank',      // 케이뱅크
    'com.sc.danb.scbankingapp',    // SC제일은행
    'com.imbank.banking',          // iM뱅크(대구은행)
    'com.busanbank.bsbankapp',     // 부산은행
    'com.kwangju.bank',            // 광주은행
  };

  static bool isCardOrBankPackage(String pkg) => _knownPackages.contains(pkg);

  static bool containsPaymentKeyword(String text) {
    return text.contains('승인') ||
        text.contains('결제') ||
        text.contains('출금') ||
        text.contains('이체') ||
        text.contains('원 사용') ||
        text.contains('원 결제') ||
        text.contains('원 승인');
  }

  // ── 파싱 로직 ────────────────────────────────────────────────────────────────

  /// 금액 추출 — '12,345원', '₩12,345' 형식 지원
  static double? parseAmount(String text) {
    final krwPattern = RegExp(r'₩\s*([\d,]+)');
    final wonPattern = RegExp(r'([\d,]+)\s*원');

    RegExpMatch? match = krwPattern.firstMatch(text);
    match ??= wonPattern.firstMatch(text);
    if (match == null) return null;

    final raw = match.group(1)!.replaceAll(',', '');
    return double.tryParse(raw);
  }

  static ExpenseCategory? inferCategory(String text) {
    if (_matchAny(text, ['카페', '커피', '음식', '식당', '배달', '맥도날드', '스타벅스', 'gs25', 'cu', '편의점', '마트', '이마트', '홈플러스', '롯데마트'])) {
      return ExpenseCategory.food;
    }
    if (_matchAny(text, ['지하철', '버스', '택시', '주유', '카카오t', '우버'])) {
      return ExpenseCategory.transportation;
    }
    if (_matchAny(text, ['병원', '약국', '의원', '치과', '한의원'])) {
      return ExpenseCategory.medical;
    }
    if (_matchAny(text, ['학원', '교육', '서점', '도서'])) {
      return ExpenseCategory.education;
    }
    if (_matchAny(text, ['넷플릭스', '유튜브', '왓챠', '스포티파이', '게임', '영화', '공연', '놀이'])) {
      return ExpenseCategory.leisure;
    }
    if (_matchAny(text, ['통신', 'kt ', 'skt', 'lg u+', '이동통신'])) {
      return ExpenseCategory.communication;
    }
    if (_matchAny(text, ['올리브영', '다이소', '생활', '인테리어', '리빙'])) {
      return ExpenseCategory.living;
    }
    return null;
  }

  static bool _matchAny(String text, List<String> keywords) {
    final lower = text.toLowerCase();
    return keywords.any((k) => lower.contains(k));
  }

  static PaymentMethod inferPaymentMethod(String text, String pkg) {
    final lower = text.toLowerCase();
    if (lower.contains('이체') || lower.contains('출금') || lower.contains('계좌')) {
      return PaymentMethod.transfer;
    }
    if (lower.contains('현금')) {
      return PaymentMethod.cash;
    }
    return PaymentMethod.card;
  }

  static String? buildDescription(String title, String text) {
    final parts = [title.trim(), text.trim()].where((s) => s.isNotEmpty).toList();
    if (parts.isEmpty) return null;
    final joined = parts.join(' ');
    return joined.length > 80 ? '${joined.substring(0, 77)}...' : joined;
  }
}
