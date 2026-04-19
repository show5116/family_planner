/// 지출 카테고리
enum ExpenseCategory {
  transportation,
  food,
  leisure,
  living,
  medical,
  education,
  other,
}

/// 결제 수단
enum PaymentMethod {
  cash,
  card,
  transfer,
}

/// 지출 모델
class ExpenseModel {
  final String id;
  final String? groupId; // 개인 모드에서는 null
  final String userId;
  final double amount;
  final ExpenseCategory? category;
  final DateTime date;
  final String? description;
  final PaymentMethod? paymentMethod;
  final bool isRecurring;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ExpenseModel({
    required this.id,
    this.groupId,
    required this.userId,
    required this.amount,
    this.category,
    required this.date,
    this.description,
    this.paymentMethod,
    required this.isRecurring,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String,
      groupId: json['groupId'] as String?,
      userId: json['userId'] as String,
      amount: double.parse(json['amount'].toString()),
      category: json['category'] != null
          ? ExpenseModel.parseCategory(json['category'] as String)
          : null,
      date: DateTime.parse(json['date'] as String).toLocal(),
      description: json['description'] as String?,
      paymentMethod: json['paymentMethod'] != null
          ? _parsePaymentMethod(json['paymentMethod'] as String)
          : null,
      isRecurring: (json['isRecurring'] as bool?) ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
    );
  }

  static ExpenseCategory parseCategory(String value) {
    switch (value) {
      case 'TRANSPORTATION':
        return ExpenseCategory.transportation;
      case 'FOOD':
        return ExpenseCategory.food;
      case 'LEISURE':
        return ExpenseCategory.leisure;
      case 'LIVING':
        return ExpenseCategory.living;
      case 'MEDICAL':
        return ExpenseCategory.medical;
      case 'EDUCATION':
        return ExpenseCategory.education;
      default:
        return ExpenseCategory.other;
    }
  }

  static PaymentMethod? _parsePaymentMethod(String value) {
    switch (value) {
      case 'CASH':
        return PaymentMethod.cash;
      case 'CARD':
        return PaymentMethod.card;
      case 'TRANSFER':
        return PaymentMethod.transfer;
      default:
        return null;
    }
  }

  ExpenseModel copyWith({
    String? id,
    String? groupId,
    String? userId,
    double? amount,
    ExpenseCategory? category,
    DateTime? date,
    String? description,
    PaymentMethod? paymentMethod,
    bool? isRecurring,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      description: description ?? this.description,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isRecurring: isRecurring ?? this.isRecurring,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// 지출 생성 DTO
class CreateExpenseDto {
  final String? groupId; // null이면 개인 모드
  final double amount;
  final ExpenseCategory? category;
  final String date; // YYYY-MM-DD
  final String? description;
  final PaymentMethod? paymentMethod;
  final bool? isRecurring;

  const CreateExpenseDto({
    this.groupId,
    required this.amount,
    this.category,
    required this.date,
    this.description,
    this.paymentMethod,
    this.isRecurring,
  });

  Map<String, dynamic> toJson() {
    return {
      if (groupId != null) 'groupId': groupId,
      'amount': amount,
      if (category != null) 'category': _categoryToString(category!),
      'date': date,
      if (description != null) 'description': description,
      if (paymentMethod != null) 'paymentMethod': _paymentMethodToString(paymentMethod!),
      if (isRecurring != null) 'isRecurring': isRecurring,
    };
  }
}

/// 지출 수정 DTO
class UpdateExpenseDto {
  final double? amount;
  final ExpenseCategory? category;
  final String? date;
  final String? description;
  final PaymentMethod? paymentMethod;
  final bool? isRecurring;

  const UpdateExpenseDto({
    this.amount,
    this.category,
    this.date,
    this.description,
    this.paymentMethod,
    this.isRecurring,
  });

  Map<String, dynamic> toJson() {
    return {
      if (amount != null) 'amount': amount,
      if (category != null) 'category': _categoryToString(category!),
      if (date != null) 'date': date,
      if (description != null) 'description': description,
      if (paymentMethod != null) 'paymentMethod': _paymentMethodToString(paymentMethod!),
      if (isRecurring != null) 'isRecurring': isRecurring,
    };
  }
}

/// ExpenseCategory → API 문자열 변환
String _categoryToString(ExpenseCategory category) {
  switch (category) {
    case ExpenseCategory.transportation:
      return 'TRANSPORTATION';
    case ExpenseCategory.food:
      return 'FOOD';
    case ExpenseCategory.leisure:
      return 'LEISURE';
    case ExpenseCategory.living:
      return 'LIVING';
    case ExpenseCategory.medical:
      return 'MEDICAL';
    case ExpenseCategory.education:
      return 'EDUCATION';
    case ExpenseCategory.other:
      return 'OTHER';
  }
}

/// PaymentMethod → API 문자열 변환
String _paymentMethodToString(PaymentMethod method) {
  switch (method) {
    case PaymentMethod.cash:
      return 'CASH';
    case PaymentMethod.card:
      return 'CARD';
    case PaymentMethod.transfer:
      return 'TRANSFER';
  }
}
