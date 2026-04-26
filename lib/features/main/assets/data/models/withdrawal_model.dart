class WithdrawalModel {
  final String id;
  final String accountId;
  final DateTime withdrawalDate;
  final double amount;
  final String? note;
  final DateTime createdAt;

  const WithdrawalModel({
    required this.id,
    required this.accountId,
    required this.withdrawalDate,
    required this.amount,
    this.note,
    required this.createdAt,
  });

  factory WithdrawalModel.fromJson(Map<String, dynamic> json) {
    return WithdrawalModel(
      id: json['id'] as String,
      accountId: json['accountId'] as String,
      withdrawalDate: DateTime.parse(json['withdrawalDate'] as String).toLocal(),
      amount: double.parse(json['amount'].toString()),
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
    );
  }
}

class CreateWithdrawalDto {
  final String withdrawalDate; // YYYY-MM-DD
  final double amount;
  final String? note;

  const CreateWithdrawalDto({
    required this.withdrawalDate,
    required this.amount,
    this.note,
  });

  Map<String, dynamic> toJson() => {
        'withdrawalDate': withdrawalDate,
        'amount': amount,
        if (note != null) 'note': note,
      };
}
