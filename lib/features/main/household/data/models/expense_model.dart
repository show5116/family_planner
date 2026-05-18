/// 거래 유형
enum TransactionType {
  income,
  expense,
}

/// 지출 카테고리
enum ExpenseCategory {
  transportation,
  food,
  groceries,
  leisure,
  living,
  medical,
  education,
  allowance,
  celebration,
  assetTransfer,
  childcare,
  communication,
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
  final TransactionType type;
  final double amount;
  final ExpenseCategory? category;
  final DateTime date;
  final String? description;
  final PaymentMethod? paymentMethod;
  final bool isRecurring;
  final String? shoppingHistoryId; // 장보기 완료 시 자동 생성된 지출에만 존재
  final DateTime createdAt;
  final DateTime updatedAt;

  const ExpenseModel({
    required this.id,
    this.groupId,
    required this.userId,
    this.type = TransactionType.expense,
    required this.amount,
    this.category,
    required this.date,
    this.description,
    this.paymentMethod,
    required this.isRecurring,
    this.shoppingHistoryId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String,
      groupId: json['groupId'] as String?,
      userId: json['userId'] as String,
      type: json['type'] == 'INCOME' ? TransactionType.income : TransactionType.expense,
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
      shoppingHistoryId: json['shoppingHistoryId'] as String?,
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
      case 'GROCERIES':
        return ExpenseCategory.groceries;
      case 'LEISURE':
        return ExpenseCategory.leisure;
      case 'LIVING':
        return ExpenseCategory.living;
      case 'MEDICAL':
        return ExpenseCategory.medical;
      case 'EDUCATION':
        return ExpenseCategory.education;
      case 'ALLOWANCE':
        return ExpenseCategory.allowance;
      case 'CELEBRATION':
        return ExpenseCategory.celebration;
      case 'ASSET_TRANSFER':
        return ExpenseCategory.assetTransfer;
      case 'CHILDCARE':
        return ExpenseCategory.childcare;
      case 'COMMUNICATION':
        return ExpenseCategory.communication;
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
    TransactionType? type,
    double? amount,
    ExpenseCategory? category,
    DateTime? date,
    String? description,
    PaymentMethod? paymentMethod,
    bool? isRecurring,
    String? shoppingHistoryId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      description: description ?? this.description,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isRecurring: isRecurring ?? this.isRecurring,
      shoppingHistoryId: shoppingHistoryId ?? this.shoppingHistoryId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// 지출 생성 DTO
class CreateExpenseDto {
  final String? groupId; // null이면 개인 모드
  final TransactionType type;
  final double amount;
  final ExpenseCategory? category;
  final String date; // YYYY-MM-DD
  final String? description;
  final PaymentMethod? paymentMethod;
  final bool? isRecurring;

  const CreateExpenseDto({
    this.groupId,
    this.type = TransactionType.expense,
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
      'type': _transactionTypeToString(type),
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
  final TransactionType? type;
  final double? amount;
  final ExpenseCategory? category;
  final String? date;
  final String? description;
  final PaymentMethod? paymentMethod;
  final bool? isRecurring;

  const UpdateExpenseDto({
    this.type,
    this.amount,
    this.category,
    this.date,
    this.description,
    this.paymentMethod,
    this.isRecurring,
  });

  Map<String, dynamic> toJson() {
    return {
      if (type != null) 'type': _transactionTypeToString(type!),
      if (amount != null) 'amount': amount,
      if (category != null) 'category': _categoryToString(category!),
      if (date != null) 'date': date,
      if (description != null) 'description': description,
      if (paymentMethod != null) 'paymentMethod': _paymentMethodToString(paymentMethod!),
      if (isRecurring != null) 'isRecurring': isRecurring,
    };
  }
}

/// TransactionType → API 문자열 변환
String _transactionTypeToString(TransactionType type) {
  switch (type) {
    case TransactionType.income:
      return 'INCOME';
    case TransactionType.expense:
      return 'EXPENSE';
  }
}

/// ExpenseCategory → API 문자열 변환
String _categoryToString(ExpenseCategory category) {
  switch (category) {
    case ExpenseCategory.transportation:
      return 'TRANSPORTATION';
    case ExpenseCategory.food:
      return 'FOOD';
    case ExpenseCategory.groceries:
      return 'GROCERIES';
    case ExpenseCategory.leisure:
      return 'LEISURE';
    case ExpenseCategory.living:
      return 'LIVING';
    case ExpenseCategory.medical:
      return 'MEDICAL';
    case ExpenseCategory.education:
      return 'EDUCATION';
    case ExpenseCategory.allowance:
      return 'ALLOWANCE';
    case ExpenseCategory.celebration:
      return 'CELEBRATION';
    case ExpenseCategory.assetTransfer:
      return 'ASSET_TRANSFER';
    case ExpenseCategory.childcare:
      return 'CHILDCARE';
    case ExpenseCategory.communication:
      return 'COMMUNICATION';
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
