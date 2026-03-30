class MarketBriefingItem {
  final String title;
  final String content;
  final DateTime updatedAt;

  const MarketBriefingItem({
    required this.title,
    required this.content,
    required this.updatedAt,
  });

  factory MarketBriefingItem.fromJson(Map<String, dynamic> json) {
    return MarketBriefingItem(
      title: json['title'] as String,
      content: json['content'] as String,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

class MarketBriefingModel {
  final MarketBriefingItem? macro;
  final MarketBriefingItem? domesticMarket;
  final MarketBriefingItem? globalMarket;

  const MarketBriefingModel({
    this.macro,
    this.domesticMarket,
    this.globalMarket,
  });

  factory MarketBriefingModel.fromJson(Map<String, dynamic> json) {
    return MarketBriefingModel(
      macro: json['macro'] != null
          ? MarketBriefingItem.fromJson(json['macro'] as Map<String, dynamic>)
          : null,
      domesticMarket: json['domestic_market'] != null
          ? MarketBriefingItem.fromJson(json['domestic_market'] as Map<String, dynamic>)
          : null,
      globalMarket: json['global_market'] != null
          ? MarketBriefingItem.fromJson(json['global_market'] as Map<String, dynamic>)
          : null,
    );
  }
}
