/// 육아 포인트 거래 유형
enum ChildcareTransactionType {
  earn,
  spend,
  savingsDeposit,
  savingsWithdraw,
  monthlyAllowance,
  interestPayment,
  penalty,
}

/// 육아 포인트 계정 모델
class ChildcareAccount {
  final String id;
  final String groupId;
  final String childUserId;
  final String parentUserId;
  final double balance;
  final double monthlyAllowance;
  final double savingsBalance;
  final String savingsInterestRate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ChildcareAccount({
    required this.id,
    required this.groupId,
    required this.childUserId,
    required this.parentUserId,
    required this.balance,
    required this.monthlyAllowance,
    required this.savingsBalance,
    required this.savingsInterestRate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChildcareAccount.fromJson(Map<String, dynamic> json) {
    return ChildcareAccount(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      childUserId: json['childUserId'] as String,
      parentUserId: json['parentUserId'] as String,
      balance: double.parse(json['balance'].toString()),
      monthlyAllowance: double.parse(json['monthlyAllowance'].toString()),
      savingsBalance: double.parse(json['savingsBalance'].toString()),
      savingsInterestRate: json['savingsInterestRate'].toString(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  ChildcareAccount copyWith({
    String? id,
    String? groupId,
    String? childUserId,
    String? parentUserId,
    double? balance,
    double? monthlyAllowance,
    double? savingsBalance,
    String? savingsInterestRate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChildcareAccount(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      childUserId: childUserId ?? this.childUserId,
      parentUserId: parentUserId ?? this.parentUserId,
      balance: balance ?? this.balance,
      monthlyAllowance: monthlyAllowance ?? this.monthlyAllowance,
      savingsBalance: savingsBalance ?? this.savingsBalance,
      savingsInterestRate: savingsInterestRate ?? this.savingsInterestRate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// 포인트 거래 내역 모델
class ChildcareTransaction {
  final String id;
  final String accountId;
  final ChildcareTransactionType? type;
  final double amount;
  final String description;
  final String createdBy;
  final DateTime createdAt;

  const ChildcareTransaction({
    required this.id,
    required this.accountId,
    this.type,
    required this.amount,
    required this.description,
    required this.createdBy,
    required this.createdAt,
  });

  factory ChildcareTransaction.fromJson(Map<String, dynamic> json) {
    return ChildcareTransaction(
      id: json['id'] as String,
      accountId: json['accountId'] as String,
      type: json['type'] != null
          ? _parseTransactionType(json['type'] as String)
          : null,
      amount: double.parse(json['amount'].toString()),
      description: json['description'] as String? ?? '',
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  static ChildcareTransactionType? _parseTransactionType(String value) {
    switch (value.toUpperCase()) {
      case 'EARN':
        return ChildcareTransactionType.earn;
      case 'SPEND':
        return ChildcareTransactionType.spend;
      case 'SAVINGS_DEPOSIT':
        return ChildcareTransactionType.savingsDeposit;
      case 'SAVINGS_WITHDRAW':
        return ChildcareTransactionType.savingsWithdraw;
      case 'MONTHLY_ALLOWANCE':
        return ChildcareTransactionType.monthlyAllowance;
      case 'INTEREST_PAYMENT':
        return ChildcareTransactionType.interestPayment;
      case 'PENALTY':
        return ChildcareTransactionType.penalty;
      default:
        return null;
    }
  }
}

/// 보상 항목 모델
class ChildcareReward {
  final String id;
  final String accountId;
  final String name;
  final String? description;
  final double points;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ChildcareReward({
    required this.id,
    required this.accountId,
    required this.name,
    this.description,
    required this.points,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChildcareReward.fromJson(Map<String, dynamic> json) {
    return ChildcareReward(
      id: json['id'] as String,
      accountId: json['accountId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      points: double.parse(json['points'].toString()),
      isActive: (json['isActive'] as bool?) ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  ChildcareReward copyWith({
    String? id,
    String? accountId,
    String? name,
    String? description,
    double? points,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChildcareReward(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      name: name ?? this.name,
      description: description ?? this.description,
      points: points ?? this.points,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// 규칙 모델
class ChildcareRule {
  final String id;
  final String accountId;
  final String name;
  final String? description;
  final double penalty;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ChildcareRule({
    required this.id,
    required this.accountId,
    required this.name,
    this.description,
    required this.penalty,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChildcareRule.fromJson(Map<String, dynamic> json) {
    return ChildcareRule(
      id: json['id'] as String,
      accountId: json['accountId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      penalty: double.parse(json['penalty'].toString()),
      isActive: (json['isActive'] as bool?) ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  ChildcareRule copyWith({
    String? id,
    String? accountId,
    String? name,
    String? description,
    double? penalty,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChildcareRule(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      name: name ?? this.name,
      description: description ?? this.description,
      penalty: penalty ?? this.penalty,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// ChildcareTransactionType → API 문자열 변환
String childcareTransactionTypeToString(ChildcareTransactionType type) {
  switch (type) {
    case ChildcareTransactionType.earn:
      return 'EARN';
    case ChildcareTransactionType.spend:
      return 'SPEND';
    case ChildcareTransactionType.savingsDeposit:
      return 'SAVINGS_DEPOSIT';
    case ChildcareTransactionType.savingsWithdraw:
      return 'SAVINGS_WITHDRAW';
    case ChildcareTransactionType.monthlyAllowance:
      return 'MONTHLY_ALLOWANCE';
    case ChildcareTransactionType.interestPayment:
      return 'INTEREST_PAYMENT';
    case ChildcareTransactionType.penalty:
      return 'PENALTY';
  }
}
