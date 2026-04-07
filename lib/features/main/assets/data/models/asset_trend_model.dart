/// 추이 조회 기간 단위
enum TrendPeriod { monthly, yearly }

/// 자산 추이 데이터 포인트
class AssetTrendPoint {
  final String period; // monthly: YYYY-MM, yearly: YYYY
  final double balance;
  final double principal;
  final double profit;
  final double profitRate;

  const AssetTrendPoint({
    required this.period,
    required this.balance,
    required this.principal,
    required this.profit,
    required this.profitRate,
  });

  factory AssetTrendPoint.fromJson(Map<String, dynamic> json) {
    return AssetTrendPoint(
      period: json['period'] as String,
      balance: double.parse(json['balance'].toString()),
      principal: double.parse(json['principal'].toString()),
      profit: double.parse(json['profit'].toString()),
      profitRate: double.parse(json['profitRate'].toString()),
    );
  }
}
