/// 날짜별 종목 기록 모델 (holding-records API)
class HoldingRecordModel {
  final String id;
  final String accountId;
  final DateTime recordDate;
  final String name;
  final String? ticker;
  final double amount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const HoldingRecordModel({
    required this.id,
    required this.accountId,
    required this.recordDate,
    required this.name,
    this.ticker,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HoldingRecordModel.fromJson(Map<String, dynamic> json) {
    return HoldingRecordModel(
      id: json['id'] as String,
      accountId: json['accountId'] as String,
      recordDate: DateTime.parse(json['recordDate'] as String).toLocal(),
      name: json['name'] as String,
      ticker: json['ticker'] as String?,
      amount: double.parse(json['amount'].toString()),
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
    );
  }
}

/// 종목 기록 추가 DTO
class CreateHoldingRecordDto {
  final String recordDate; // YYYY-MM-DD
  final String name;
  final String? ticker;
  final double amount;

  const CreateHoldingRecordDto({
    required this.recordDate,
    required this.name,
    this.ticker,
    required this.amount,
  });

  Map<String, dynamic> toJson() => {
        'recordDate': recordDate,
        'name': name,
        if (ticker != null && ticker!.isNotEmpty) 'ticker': ticker,
        'amount': amount.toInt(),
      };
}

/// 종목 기록 수정 DTO
class UpdateHoldingRecordDto {
  final String? name;
  final String? ticker;
  final double? amount;

  const UpdateHoldingRecordDto({this.name, this.ticker, this.amount});

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (ticker != null) 'ticker': ticker,
        if (amount != null) 'amount': amount!.toInt(),
      };
}
