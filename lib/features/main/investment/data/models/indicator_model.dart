/// 투자지표 모델
class IndicatorModel {
  final String symbol;
  final String name;
  final String nameKo;
  final String? category;
  final String unit;
  final double? price;
  final double? prevPrice;
  final double? change;
  final double? changeRate;
  final DateTime? recordedAt;
  final bool isBookmarked;
  // GOLD_KRW_SPOT 전용: 국제 환산가 대비 이격률 (%). 양수 = 프리미엄
  final double? spread;

  const IndicatorModel({
    required this.symbol,
    required this.name,
    required this.nameKo,
    this.category,
    required this.unit,
    this.price,
    this.prevPrice,
    this.change,
    this.changeRate,
    this.recordedAt,
    required this.isBookmarked,
    this.spread,
  });

  factory IndicatorModel.fromJson(Map<String, dynamic> json) {
    return IndicatorModel(
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      nameKo: json['nameKo'] as String,
      category: json['category'] as String?,
      unit: json['unit'] as String,
      price: json['price'] != null ? double.tryParse(json['price'].toString()) : null,
      prevPrice: json['prevPrice'] != null ? double.tryParse(json['prevPrice'].toString()) : null,
      change: json['change'] != null ? double.tryParse(json['change'].toString()) : null,
      changeRate: json['changeRate'] != null ? double.tryParse(json['changeRate'].toString()) : null,
      recordedAt: json['recordedAt'] != null ? DateTime.tryParse(json['recordedAt'] as String) : null,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      spread: json['spread'] != null ? double.tryParse(json['spread'].toString()) : null,
    );
  }

  IndicatorModel copyWith({bool? isBookmarked}) {
    return IndicatorModel(
      symbol: symbol,
      name: name,
      nameKo: nameKo,
      category: category,
      unit: unit,
      price: price,
      prevPrice: prevPrice,
      change: change,
      changeRate: changeRate,
      recordedAt: recordedAt,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      spread: spread,
    );
  }
}

/// 과거 데이터 초기화 결과 모델 (어드민 전용)
class InitHistoryResult {
  final int yahoo;
  final int crypto;
  final int bond;
  final int? goldKrw;

  const InitHistoryResult({
    required this.yahoo,
    required this.crypto,
    required this.bond,
    this.goldKrw,
  });

  factory InitHistoryResult.fromJson(Map<String, dynamic> json) {
    return InitHistoryResult(
      yahoo: json['yahoo'] as int? ?? 0,
      crypto: json['crypto'] as int? ?? 0,
      bond: json['bond'] as int? ?? 0,
      goldKrw: json['goldKrw'] as int?,
    );
  }
}

/// 지표 시세 히스토리 모델
class IndicatorHistoryModel {
  final String symbol;
  final String nameKo;
  final List<IndicatorPricePoint> history;

  const IndicatorHistoryModel({
    required this.symbol,
    required this.nameKo,
    required this.history,
  });

  factory IndicatorHistoryModel.fromJson(Map<String, dynamic> json) {
    final historyJson = json['history'] as List<dynamic>? ?? [];
    return IndicatorHistoryModel(
      symbol: json['symbol'] as String,
      nameKo: json['nameKo'] as String,
      history: historyJson
          .map((e) => IndicatorPricePoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// 시세 포인트
class IndicatorPricePoint {
  final double price;
  final DateTime recordedAt;

  const IndicatorPricePoint({
    required this.price,
    required this.recordedAt,
  });

  factory IndicatorPricePoint.fromJson(Map<String, dynamic> json) {
    return IndicatorPricePoint(
      price: double.parse(json['price'].toString()),
      recordedAt: DateTime.parse(json['recordedAt'] as String),
    );
  }
}
