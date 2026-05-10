/// 계좌 종목(포트폴리오 비중) 모델
class HoldingModel {
  final String id;
  final String accountId;
  final String name;
  final String? ticker;
  final double ratio; // %
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  const HoldingModel({
    required this.id,
    required this.accountId,
    required this.name,
    this.ticker,
    required this.ratio,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HoldingModel.fromJson(Map<String, dynamic> json) {
    return HoldingModel(
      id: json['id'] as String,
      accountId: json['accountId'] as String,
      name: json['name'] as String,
      ticker: json['ticker'] as String?,
      ratio: double.parse(json['ratio'].toString()),
      sortOrder: json['sortOrder'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
    );
  }
}

/// 종목 추가 DTO
class CreateHoldingDto {
  final String name;
  final String? ticker;
  final double ratio;

  const CreateHoldingDto({
    required this.name,
    this.ticker,
    required this.ratio,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        if (ticker != null && ticker!.isNotEmpty) 'ticker': ticker,
        'ratio': ratio,
      };
}

/// 종목 수정 DTO
class UpdateHoldingDto {
  final String? name;
  final String? ticker;
  final double? ratio;

  const UpdateHoldingDto({this.name, this.ticker, this.ratio});

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (ticker != null) 'ticker': ticker,
        if (ratio != null) 'ratio': ratio,
      };
}
