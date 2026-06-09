import 'package:family_planner/features/main/household/data/models/expense_model.dart';

/// 고정지출 규칙 모델 (별도 스키마)
class RecurringExpenseModel {
  final String id;
  final String? groupId;
  final String userId;
  final TransactionType type;
  final double amount; // 고정이면 실제 금액, 가변이면 기준(예상) 금액
  final bool isVariable; // true = 가변 (자동 생성 시 isConfirmed=false)
  final ExpenseCategory? category;
  final IncomeCategory? incomeCategory;
  final PaymentMethod? paymentMethod;
  final String? merchantId;
  final String? description;
  final int dayOfMonth; // 매달 발생 일 (1~31)
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RecurringExpenseModel({
    required this.id,
    this.groupId,
    required this.userId,
    this.type = TransactionType.expense,
    required this.amount,
    this.isVariable = false,
    this.category,
    this.incomeCategory,
    this.paymentMethod,
    this.merchantId,
    this.description,
    required this.dayOfMonth,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RecurringExpenseModel.fromJson(Map<String, dynamic> json) {
    return RecurringExpenseModel(
      id: json['id'] as String,
      groupId: json['groupId'] as String?,
      userId: json['userId'] as String,
      type: json['type'] == 'INCOME' ? TransactionType.income : TransactionType.expense,
      amount: double.parse(json['amount'].toString()),
      isVariable: (json['isVariable'] as bool?) ?? false,
      category: json['category'] != null
          ? ExpenseModel.parseCategory(json['category'] as String)
          : null,
      incomeCategory: json['incomeCategory'] != null
          ? _parseIncomeCategory(json['incomeCategory'] as String)
          : null,
      paymentMethod: json['paymentMethod'] != null
          ? _parsePaymentMethod(json['paymentMethod'] as String)
          : null,
      merchantId: json['merchantId'] as String?,
      description: json['description'] as String?,
      dayOfMonth: json['dayOfMonth'] as int,
      isActive: (json['isActive'] as bool?) ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
    );
  }

  RecurringExpenseModel copyWith({
    String? id,
    String? groupId,
    String? userId,
    TransactionType? type,
    double? amount,
    bool? isVariable,
    ExpenseCategory? category,
    Object? incomeCategory = _sentinel,
    Object? paymentMethod = _sentinel,
    Object? merchantId = _sentinel,
    Object? description = _sentinel,
    int? dayOfMonth,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RecurringExpenseModel(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      isVariable: isVariable ?? this.isVariable,
      category: category ?? this.category,
      incomeCategory: incomeCategory == _sentinel
          ? this.incomeCategory
          : incomeCategory as IncomeCategory?,
      paymentMethod: paymentMethod == _sentinel
          ? this.paymentMethod
          : paymentMethod as PaymentMethod?,
      merchantId: merchantId == _sentinel
          ? this.merchantId
          : merchantId as String?,
      description: description == _sentinel
          ? this.description
          : description as String?,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
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

  static IncomeCategory? _parseIncomeCategory(String value) {
    switch (value) {
      case 'SALARY':
        return IncomeCategory.salary;
      case 'ALLOWANCE':
        return IncomeCategory.allowance;
      case 'CARRYOVER':
        return IncomeCategory.carryover;
      case 'BONUS':
        return IncomeCategory.bonus;
      case 'INTEREST':
        return IncomeCategory.interest;
      case 'RENTAL':
        return IncomeCategory.rental;
      case 'SIDE_INCOME':
        return IncomeCategory.sideIncome;
      case 'TRANSFER_IN':
        return IncomeCategory.transferIn;
      case 'OTHER_INCOME':
        return IncomeCategory.otherIncome;
      default:
        return null;
    }
  }
}

const _sentinel = Object();

/// 고정지출 생성 DTO
class CreateRecurringExpenseDto {
  final String? groupId;
  final TransactionType type;
  final double amount;
  final bool isVariable;
  final ExpenseCategory? category;
  final IncomeCategory? incomeCategory;
  final PaymentMethod? paymentMethod;
  final String? merchantId;
  final String? description;
  final int dayOfMonth;

  const CreateRecurringExpenseDto({
    this.groupId,
    this.type = TransactionType.expense,
    required this.amount,
    this.isVariable = false,
    this.category,
    this.incomeCategory,
    this.paymentMethod,
    this.merchantId,
    this.description,
    required this.dayOfMonth,
  });

  Map<String, dynamic> toJson() {
    return {
      if (groupId != null) 'groupId': groupId,
      'type': _transactionTypeToString(type),
      'amount': amount,
      'isVariable': isVariable,
      if (category != null) 'category': _categoryToString(category!),
      if (incomeCategory != null) 'incomeCategory': _incomeCategoryToString(incomeCategory!),
      if (paymentMethod != null) 'paymentMethod': _paymentMethodToString(paymentMethod!),
      if (merchantId != null) 'merchantId': merchantId,
      if (description != null) 'description': description,
      'dayOfMonth': dayOfMonth,
    };
  }
}

/// 고정지출 수정 DTO
class UpdateRecurringExpenseDto {
  final double? amount;
  final bool? isVariable;
  final ExpenseCategory? category;
  final Object? incomeCategory; // IncomeCategory | null
  final Object? paymentMethod; // PaymentMethod | null
  final Object? merchantId; // String | null
  final Object? description; // String | null
  final int? dayOfMonth;
  final bool? isActive;

  const UpdateRecurringExpenseDto({
    this.amount,
    this.isVariable,
    this.category,
    this.incomeCategory = _sentinel,
    this.paymentMethod = _sentinel,
    this.merchantId = _sentinel,
    this.description = _sentinel,
    this.dayOfMonth,
    this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      if (amount != null) 'amount': amount,
      if (isVariable != null) 'isVariable': isVariable,
      if (category != null) 'category': _categoryToString(category!),
      if (incomeCategory != _sentinel)
        'incomeCategory': incomeCategory != null
            ? _incomeCategoryToString(incomeCategory as IncomeCategory)
            : null,
      if (paymentMethod != _sentinel)
        'paymentMethod': paymentMethod != null
            ? _paymentMethodToString(paymentMethod as PaymentMethod)
            : null,
      if (merchantId != _sentinel) 'merchantId': merchantId as String?,
      if (description != _sentinel) 'description': description as String?,
      if (dayOfMonth != null) 'dayOfMonth': dayOfMonth,
      if (isActive != null) 'isActive': isActive,
    };
  }
}

String _transactionTypeToString(TransactionType type) {
  switch (type) {
    case TransactionType.income:
      return 'INCOME';
    case TransactionType.expense:
      return 'EXPENSE';
  }
}

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
    case ExpenseCategory.carryover:
      return 'CARRYOVER';
    case ExpenseCategory.other:
      return 'OTHER';
  }
}

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

String _incomeCategoryToString(IncomeCategory category) {
  switch (category) {
    case IncomeCategory.salary:
      return 'SALARY';
    case IncomeCategory.allowance:
      return 'ALLOWANCE';
    case IncomeCategory.carryover:
      return 'CARRYOVER';
    case IncomeCategory.bonus:
      return 'BONUS';
    case IncomeCategory.interest:
      return 'INTEREST';
    case IncomeCategory.rental:
      return 'RENTAL';
    case IncomeCategory.sideIncome:
      return 'SIDE_INCOME';
    case IncomeCategory.transferIn:
      return 'TRANSFER_IN';
    case IncomeCategory.otherIncome:
      return 'OTHER_INCOME';
  }
}
