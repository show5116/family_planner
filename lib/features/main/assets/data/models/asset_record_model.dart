/// 자산 기록 모델
class AssetRecordModel {
  final String id;
  final String accountId;
  final DateTime recordDate;
  final double balance;
  final double principal;
  final double profit;
  final String? note;
  final DateTime createdAt;

  const AssetRecordModel({
    required this.id,
    required this.accountId,
    required this.recordDate,
    required this.balance,
    required this.principal,
    required this.profit,
    this.note,
    required this.createdAt,
  });

  factory AssetRecordModel.fromJson(Map<String, dynamic> json) {
    return AssetRecordModel(
      id: json['id'] as String,
      accountId: json['accountId'] as String,
      recordDate: DateTime.parse(json['recordDate'] as String).toLocal(),
      balance: double.parse(json['balance'].toString()),
      principal: double.parse(json['principal'].toString()),
      profit: double.parse(json['profit'].toString()),
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
    );
  }
}

/// 자산 기록 입력 방식
enum RecordInputMode { manual, auto }

/// 자산 기록 생성 DTO
class CreateAssetRecordDto {
  final String recordDate; // YYYY-MM-DD
  final RecordInputMode inputMode;
  // manual 필드
  final double? balance;
  final double? principal;
  final double? profit;
  // auto 필드
  final double? currentBalance;
  final double? additionalPrincipal;
  final String? note;

  const CreateAssetRecordDto({
    required this.recordDate,
    required this.inputMode,
    this.balance,
    this.principal,
    this.profit,
    this.currentBalance,
    this.additionalPrincipal,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'recordDate': recordDate,
      'inputMode': inputMode.name,
      if (balance != null) 'balance': balance,
      if (principal != null) 'principal': principal,
      if (profit != null) 'profit': profit,
      if (currentBalance != null) 'currentBalance': currentBalance,
      if (additionalPrincipal != null) 'additionalPrincipal': additionalPrincipal,
      if (note != null) 'note': note,
    };
  }
}
