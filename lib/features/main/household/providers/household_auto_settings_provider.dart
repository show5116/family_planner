// TODO: 결제 알림 자동 등록 기능 — 앱 심사 통과 후 아래 주석 해제
// household_auto_settings_model.dart, push_expense_listener_service.dart 주석도 함께 해제 필요

/*
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:family_planner/features/main/household/data/models/household_auto_settings_model.dart';
import 'package:family_planner/features/main/household/data/models/expense_model.dart';
import 'package:family_planner/features/main/household/data/repositories/household_repository.dart';
import 'package:family_planner/features/main/household/data/services/push_expense_listener_service.dart';
import 'package:family_planner/features/main/household/providers/household_provider.dart';
import 'package:family_planner/features/notification/data/services/local_notification_service.dart';

const _kPushEnabledKey = 'household_push_auto_register_enabled';
const _kDefaultGroupIdKey = 'household_push_default_group_id';

/// 가계부 자동 등록 설정 Provider
class HouseholdAutoSettingsNotifier
    extends StateNotifier<HouseholdAutoSettingsModel> {
  final Ref _ref;

  HouseholdAutoSettingsNotifier(this._ref)
      : super(const HouseholdAutoSettingsModel());

  /// SharedPreferences에서 설정 로드
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(_kPushEnabledKey) ?? false;
    final groupId = prefs.getString(_kDefaultGroupIdKey);
    state = HouseholdAutoSettingsModel(
      pushAutoRegisterEnabled: enabled,
      defaultGroupId: groupId,
    );
    if (enabled) {
      await _startListener();
    }
  }

  /// 자동 등록 on/off 전환
  Future<void> setPushAutoRegister({required bool enabled}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kPushEnabledKey, enabled);
    state = state.copyWith(pushAutoRegisterEnabled: enabled);

    if (enabled) {
      await _startListener();
    } else {
      await PushExpenseListenerService.stop();
    }
  }

  /// 자동 등록에 사용할 그룹 변경
  Future<void> setDefaultGroupId(String? groupId) async {
    final prefs = await SharedPreferences.getInstance();
    if (groupId == null) {
      await prefs.remove(_kDefaultGroupIdKey);
    } else {
      await prefs.setString(_kDefaultGroupIdKey, groupId);
    }
    state = state.copyWith(defaultGroupId: groupId);
  }

  Future<void> _startListener() async {
    final granted = await PushExpenseListenerService.isPermissionGranted();
    if (!granted) return;

    await PushExpenseListenerService.start(_onParsed);
  }

  Future<void> _onParsed(ParsedExpense parsed) async {
    try {
      final groupId = state.defaultGroupId;
      final now = DateTime.now();
      final dateStr =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      final dto = CreateExpenseDto(
        groupId: groupId,
        type: TransactionType.expense,
        amount: parsed.amount,
        category: parsed.category,
        date: dateStr,
        description: parsed.description,
        paymentMethod: parsed.paymentMethod,
      );

      final repository = _ref.read(householdRepositoryProvider);
      final expense = await repository.createExpense(dto);

      // 가계부 목록 갱신
      _ref.read(householdExpensesProvider.notifier).addExpense(expense);
      _ref.invalidate(householdMonthlyStatisticsProvider);

      // 등록 완료 로컬 알림
      final amountStr = _formatAmount(parsed.amount);
      await LocalNotificationService.show(
        id: expense.hashCode,
        title: '가계부 자동 등록 완료',
        body: '$amountStr원이 가계부에 등록되었습니다.',
      );

      debugPrint('[PushAutoRegister] 등록 완료: ${parsed.amount}원 (${parsed.sourcePkg})');
    } catch (e) {
      debugPrint('[PushAutoRegister] 등록 실패: $e');
    }
  }

  String _formatAmount(double amount) {
    final str = amount.toInt().toString();
    final buf = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write(',');
      buf.write(str[i]);
    }
    return buf.toString();
  }
}

final householdAutoSettingsProvider = StateNotifierProvider<
    HouseholdAutoSettingsNotifier, HouseholdAutoSettingsModel>((ref) {
  return HouseholdAutoSettingsNotifier(ref);
});
*/
