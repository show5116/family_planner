/// 출금 유형
/// PRINCIPAL: 원금 인출 → 원금에서 차감
/// PROFIT: 수익 실현 → 수익에서 차감
enum WithdrawalType { principal, profit }

WithdrawalType? parseWithdrawalType(String? s) {
  if (s == 'PRINCIPAL') return WithdrawalType.principal;
  if (s == 'PROFIT') return WithdrawalType.profit;
  return null;
}

String withdrawalTypeToString(WithdrawalType type) {
  switch (type) {
    case WithdrawalType.principal: return 'PRINCIPAL';
    case WithdrawalType.profit:    return 'PROFIT';
  }
}

String withdrawalTypeLabel(WithdrawalType? type) {
  switch (type) {
    case WithdrawalType.principal: return '원금 인출';
    case WithdrawalType.profit:    return '수익 실현';
    case null:                     return '미지정';
  }
}

class WithdrawalModel {
  final String id;
  final String accountId;
  final DateTime withdrawalDate;
  final double amount;
  final WithdrawalType type;
  final String? note;
  final DateTime createdAt;

  const WithdrawalModel({
    required this.id,
    required this.accountId,
    required this.withdrawalDate,
    required this.amount,
    required this.type,
    this.note,
    required this.createdAt,
  });

  factory WithdrawalModel.fromJson(Map<String, dynamic> json) {
    return WithdrawalModel(
      id: json['id'] as String,
      accountId: json['accountId'] as String,
      withdrawalDate: DateTime.parse(json['withdrawalDate'] as String).toLocal(),
      amount: double.parse(json['amount'].toString()),
      type: parseWithdrawalType(json['type'] as String?) ?? WithdrawalType.principal,
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
    );
  }
}

class CreateWithdrawalDto {
  final String withdrawalDate; // YYYY-MM-DD
  final double amount;
  final WithdrawalType type;
  final String? note;

  const CreateWithdrawalDto({
    required this.withdrawalDate,
    required this.amount,
    required this.type,
    this.note,
  });

  Map<String, dynamic> toJson() => {
        'withdrawalDate': withdrawalDate,
        'amount': amount,
        'type': withdrawalTypeToString(type),
        if (note != null) 'note': note,
      };
}
