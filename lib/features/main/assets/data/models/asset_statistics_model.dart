import 'package:family_planner/features/main/assets/data/models/account_model.dart';

/// 유형별 통계
class AccountTypeStatModel {
  final AccountType? type;
  final double balance;
  final int count;

  const AccountTypeStatModel({
    this.type,
    required this.balance,
    required this.count,
  });

  factory AccountTypeStatModel.fromJson(Map<String, dynamic> json) {
    return AccountTypeStatModel(
      type: parseAccountType(json['type'] as String?),
      balance: double.parse(json['balance'].toString()),
      count: json['count'] as int,
    );
  }
}

/// 자산 연동 저금통 요약
class SavingsGoalSummaryModel {
  final String id;
  final String name;
  final double currentAmount;

  const SavingsGoalSummaryModel({
    required this.id,
    required this.name,
    required this.currentAmount,
  });

  factory SavingsGoalSummaryModel.fromJson(Map<String, dynamic> json) {
    return SavingsGoalSummaryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      currentAmount: double.parse(json['currentAmount'].toString()),
    );
  }
}

/// 자산 통계 모델
class AssetStatisticsModel {
  final double totalBalance;
  final double totalPrincipal;
  final double totalProfit;
  final double profitRate;
  final int accountCount;
  final List<AccountTypeStatModel> byType;
  final double savingsTotal;
  final List<SavingsGoalSummaryModel> savingsGoals;

  const AssetStatisticsModel({
    required this.totalBalance,
    required this.totalPrincipal,
    required this.totalProfit,
    required this.profitRate,
    required this.accountCount,
    required this.byType,
    this.savingsTotal = 0,
    this.savingsGoals = const [],
  });

  factory AssetStatisticsModel.fromJson(Map<String, dynamic> json) {
    final byTypeData = json['byType'] as List<dynamic>? ?? [];
    final savingsGoalsData = json['savingsGoals'] as List<dynamic>? ?? [];
    return AssetStatisticsModel(
      totalBalance: double.parse(json['totalBalance'].toString()),
      totalPrincipal: double.parse(json['totalPrincipal'].toString()),
      totalProfit: double.parse(json['totalProfit'].toString()),
      profitRate: double.parse(json['profitRate'].toString()),
      accountCount: json['accountCount'] as int,
      byType: byTypeData
          .map((e) => AccountTypeStatModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      savingsTotal: json['savingsTotal'] != null
          ? double.parse(json['savingsTotal'].toString())
          : 0,
      savingsGoals: savingsGoalsData
          .map(
            (e) =>
                SavingsGoalSummaryModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  factory AssetStatisticsModel.empty() {
    return const AssetStatisticsModel(
      totalBalance: 0,
      totalPrincipal: 0,
      totalProfit: 0,
      profitRate: 0,
      accountCount: 0,
      byType: [],
    );
  }
}
