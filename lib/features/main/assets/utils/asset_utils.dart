import 'package:flutter/material.dart';
import 'package:family_planner/features/main/assets/data/models/account_model.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 금액을 콤마 포맷 문자열로 변환
String formatAssetAmount(double amount) {
  final intAmount = amount.toInt();
  final str = intAmount.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < str.length; i++) {
    if (i > 0 && (str.length - i) % 3 == 0) buffer.write(',');
    buffer.write(str[i]);
  }
  return intAmount < 0 ? '-${buffer.toString()}' : buffer.toString();
}

/// 수익률/수익금에 따른 색상 반환
Color profitColor(BuildContext context, double value) {
  if (value >= 0) return Colors.green.shade700;
  return Theme.of(context).colorScheme.error;
}

/// AccountType → 아이콘
IconData accountTypeIcon(AccountType? type) {
  switch (type) {
    case AccountType.bank:
      return Icons.account_balance;
    case AccountType.stock:
      return Icons.trending_up;
    case AccountType.fund:
      return Icons.bar_chart;
    case AccountType.insurance:
      return Icons.health_and_safety;
    case AccountType.realEstate:
      return Icons.home;
    case AccountType.cash:
      return Icons.payments;
    default:
      return Icons.savings;
  }
}

/// AccountType → 다국어 레이블
String accountTypeLabel(AppLocalizations l10n, AccountType? type) {
  switch (type) {
    case AccountType.bank:
      return l10n.asset_type_bank;
    case AccountType.stock:
      return l10n.asset_type_stock;
    case AccountType.fund:
      return l10n.asset_type_fund;
    case AccountType.insurance:
      return l10n.asset_type_insurance;
    case AccountType.realEstate:
      return l10n.asset_type_real_estate;
    case AccountType.cash:
      return l10n.asset_type_cash;
    default:
      return l10n.asset_type_other;
  }
}
