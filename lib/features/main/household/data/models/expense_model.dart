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
  carryover,  // 이월 지출
  other,
}

/// 입금 카테고리
enum IncomeCategory {
  salary,       // 월급
  allowance,    // 용돈
  carryover,    // 이월
  bonus,        // 상여금
  interest,     // 이자 수익
  rental,       // 임대 수익
  sideIncome,   // 부업
  transferIn,   // 계좌이체 입금
  otherIncome,  // 기타 수입
}

/// 결제 수단
enum PaymentMethod {
  cash,
  card,
  transfer,
}

/// 소비처 요약 (지출 응답에 포함)
class MerchantDto {
  final String id;
  final String name;

  const MerchantDto({required this.id, required this.name});

  factory MerchantDto.fromJson(Map<String, dynamic> json) {
    return MerchantDto(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
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
  final IncomeCategory? incomeCategory; // 입금 카테고리 (type=INCOME 일 때)
  final String? recurringExpenseId; // 연결된 고정지출 규칙 ID (스케줄러로 자동 생성된 경우)
  final bool isConfirmed; // 실제 금액 확인 여부 (false = 가변 고정지출 자동 생성된 미확정 항목)
  final String? refundedExpenseId; // 환불 대상 원본 지출 ID
  final List<ExpenseModel> refunds; // 이 지출에 연결된 환불 목록
  final MerchantDto? merchant;
  final String? shoppingHistoryId; // 장보기 완료 시 자동 생성된 지출에만 존재
  final String? memberId; // 결제 주체 ID
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
    this.incomeCategory,
    this.recurringExpenseId,
    this.isConfirmed = true,
    this.refundedExpenseId,
    this.refunds = const [],
    this.merchant,
    this.shoppingHistoryId,
    this.memberId,
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
      incomeCategory: json['incomeCategory'] != null
          ? _parseIncomeCategory(json['incomeCategory'] as String)
          : null,
      recurringExpenseId: json['recurringExpenseId'] as String?,
      isConfirmed: (json['isConfirmed'] as bool?) ?? true,
      refundedExpenseId: json['refundedExpenseId'] as String?,
      refunds: (json['refunds'] as List<dynamic>?)
              ?.map((e) => ExpenseModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      merchant: json['merchant'] != null
          ? MerchantDto.fromJson(json['merchant'] as Map<String, dynamic>)
          : null,
      shoppingHistoryId: json['shoppingHistoryId'] as String?,
      memberId: json['memberId'] as String?,
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
      case 'CARRYOVER':
        return ExpenseCategory.carryover;
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
    Object? incomeCategory = _sentinel,
    Object? recurringExpenseId = _sentinel,
    bool? isConfirmed,
    Object? refundedExpenseId = _sentinel,
    List<ExpenseModel>? refunds,
    MerchantDto? merchant,
    String? shoppingHistoryId,
    Object? memberId = _sentinel,
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
      incomeCategory: incomeCategory == _sentinel
          ? this.incomeCategory
          : incomeCategory as IncomeCategory?,
      recurringExpenseId: recurringExpenseId == _sentinel
          ? this.recurringExpenseId
          : recurringExpenseId as String?,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      refundedExpenseId: refundedExpenseId == _sentinel
          ? this.refundedExpenseId
          : refundedExpenseId as String?,
      refunds: refunds ?? this.refunds,
      merchant: merchant ?? this.merchant,
      shoppingHistoryId: shoppingHistoryId ?? this.shoppingHistoryId,
      memberId: memberId == _sentinel ? this.memberId : memberId as String?,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

const _sentinel = Object();

/// 지출 생성 DTO
class CreateExpenseDto {
  final String? groupId; // null이면 개인 모드
  final TransactionType type;
  final double amount;
  final ExpenseCategory? category;
  final String date; // YYYY-MM-DD
  final String? description;
  final PaymentMethod? paymentMethod;
  final String? merchantId;
  final IncomeCategory? incomeCategory; // 입금 카테고리 (type=INCOME 일 때)
  final String? refundedExpenseId; // 환불 대상 원본 지출 ID
  final String? memberId; // 결제 주체 ID

  const CreateExpenseDto({
    this.groupId,
    this.type = TransactionType.expense,
    required this.amount,
    this.category,
    required this.date,
    this.description,
    this.paymentMethod,
    this.merchantId,
    this.incomeCategory,
    this.refundedExpenseId,
    this.memberId,
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
      if (merchantId != null) 'merchantId': merchantId,
      if (incomeCategory != null) 'incomeCategory': _incomeCategoryToString(incomeCategory!),
      if (refundedExpenseId != null) 'refundedExpenseId': refundedExpenseId,
      if (memberId != null) 'memberId': memberId,
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
  final String? merchantId; // null 전달 시 소비처 연결 해제
  final bool? merchantIdExplicitNull; // true면 merchantId: null 을 명시적으로 전송
  final Object? incomeCategory; // IncomeCategory | null (null 전달 시 해제) — _sentinel 사용
  final Object? refundedExpenseId; // String | null (null 전달 시 연결 해제) — _sentinel 사용
  final bool? isConfirmed; // 실제 금액 확인 여부
  final Object? memberId; // String | null (null 전달 시 해제) — _sentinel 사용

  const UpdateExpenseDto({
    this.type,
    this.amount,
    this.category,
    this.date,
    this.description,
    this.paymentMethod,
    this.merchantId,
    this.merchantIdExplicitNull = false,
    this.incomeCategory = _sentinel,
    this.refundedExpenseId = _sentinel,
    this.isConfirmed,
    this.memberId = _sentinel,
  });

  Map<String, dynamic> toJson() {
    return {
      if (type != null) 'type': _transactionTypeToString(type!),
      if (amount != null) 'amount': amount,
      if (category != null) 'category': _categoryToString(category!),
      if (date != null) 'date': date,
      if (description != null) 'description': description,
      if (paymentMethod != null) 'paymentMethod': _paymentMethodToString(paymentMethod!),
      if (merchantIdExplicitNull == true) 'merchantId': null
      else if (merchantId != null) 'merchantId': merchantId,
      if (incomeCategory != _sentinel)
        'incomeCategory': incomeCategory != null
            ? _incomeCategoryToString(incomeCategory as IncomeCategory)
            : null,
      if (refundedExpenseId != _sentinel)
        'refundedExpenseId': refundedExpenseId as String?,
      if (isConfirmed != null) 'isConfirmed': isConfirmed,
      if (memberId != _sentinel) 'memberId': memberId as String?,
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
    case ExpenseCategory.carryover:
      return 'CARRYOVER';
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

/// IncomeCategory → API 문자열 변환
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
