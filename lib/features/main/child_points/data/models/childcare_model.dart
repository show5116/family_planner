/// 육아 포인트 거래 유형
enum ChildcareTransactionType {
  allowance,
  reward,
  bonus,
  penalty,
  purchase,
  cashout,
  savingsDeposit,
  savingsWithdraw,
  interest,
}

/// 자녀 프로필 모델
class ChildcareChild {
  final String id;
  final String groupId;
  final String parentUserId;
  final String name;
  final DateTime birthDate;
  final String? userId; // 연결된 앱 계정 ID (null 가능)
  final DateTime createdAt;
  final DateTime updatedAt;

  const ChildcareChild({
    required this.id,
    required this.groupId,
    required this.parentUserId,
    required this.name,
    required this.birthDate,
    this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChildcareChild.fromJson(Map<String, dynamic> json) {
    return ChildcareChild(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      parentUserId: json['parentUserId'] as String,
      name: json['name'] as String,
      birthDate: DateTime.parse(json['birthDate'] as String),
      userId: json['userId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

/// 육아 포인트 계정 모델 (자녀 프로필 등록 시 자동 생성)
class ChildcareAccount {
  final String id;
  final String groupId;
  final String childId;
  final String parentUserId;
  final double balance;
  final double savingsBalance;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ChildcareAccount({
    required this.id,
    required this.groupId,
    required this.childId,
    required this.parentUserId,
    required this.balance,
    required this.savingsBalance,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChildcareAccount.fromJson(Map<String, dynamic> json) {
    return ChildcareAccount(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      childId: json['childId'] as String,
      parentUserId: json['parentUserId'] as String,
      balance: double.parse(json['balance'].toString()),
      savingsBalance: double.parse(json['savingsBalance'].toString()),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  ChildcareAccount copyWith({
    String? id,
    String? groupId,
    String? childId,
    String? parentUserId,
    double? balance,
    double? savingsBalance,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChildcareAccount(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      childId: childId ?? this.childId,
      parentUserId: parentUserId ?? this.parentUserId,
      balance: balance ?? this.balance,
      savingsBalance: savingsBalance ?? this.savingsBalance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// 용돈 플랜 모델
class AllowancePlan {
  final String id;
  final String childId;
  final int monthlyPoints;
  final int payDay; // 1~31
  final int pointToMoneyRatio; // 1포인트 = N원
  final DateTime? nextNegotiationDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AllowancePlan({
    required this.id,
    required this.childId,
    required this.monthlyPoints,
    required this.payDay,
    required this.pointToMoneyRatio,
    this.nextNegotiationDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AllowancePlan.fromJson(Map<String, dynamic> json) {
    return AllowancePlan(
      id: json['id'] as String,
      childId: json['childId'] as String,
      monthlyPoints: json['monthlyPoints'] as int,
      payDay: json['payDay'] as int,
      pointToMoneyRatio: json['pointToMoneyRatio'] as int,
      nextNegotiationDate: json['nextNegotiationDate'] != null
          ? DateTime.parse(json['nextNegotiationDate'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

/// 용돈 플랜 변경 히스토리 모델
class AllowancePlanHistory {
  final String id;
  final String planId;
  final int monthlyPoints;
  final int payDay;
  final int pointToMoneyRatio;
  final DateTime? nextNegotiationDate;
  final DateTime changedAt;

  const AllowancePlanHistory({
    required this.id,
    required this.planId,
    required this.monthlyPoints,
    required this.payDay,
    required this.pointToMoneyRatio,
    this.nextNegotiationDate,
    required this.changedAt,
  });

  factory AllowancePlanHistory.fromJson(Map<String, dynamic> json) {
    return AllowancePlanHistory(
      id: json['id'] as String,
      planId: json['planId'] as String,
      monthlyPoints: json['monthlyPoints'] as int,
      payDay: json['payDay'] as int,
      pointToMoneyRatio: json['pointToMoneyRatio'] as int,
      nextNegotiationDate: json['nextNegotiationDate'] != null
          ? DateTime.parse(json['nextNegotiationDate'] as String)
          : null,
      changedAt: DateTime.parse(json['changedAt'] as String),
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
      case 'ALLOWANCE':
        return ChildcareTransactionType.allowance;
      case 'REWARD':
        return ChildcareTransactionType.reward;
      case 'BONUS':
        return ChildcareTransactionType.bonus;
      case 'PENALTY':
        return ChildcareTransactionType.penalty;
      case 'PURCHASE':
        return ChildcareTransactionType.purchase;
      case 'CASHOUT':
        return ChildcareTransactionType.cashout;
      case 'SAVINGS_DEPOSIT':
        return ChildcareTransactionType.savingsDeposit;
      case 'SAVINGS_WITHDRAW':
        return ChildcareTransactionType.savingsWithdraw;
      case 'INTEREST':
        return ChildcareTransactionType.interest;
      default:
        return null;
    }
  }
}

/// 포인트 상점 아이템 모델 (구 보상)
class ChildcareShopItem {
  final String id;
  final String accountId;
  final String name;
  final String? description;
  final int points;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ChildcareShopItem({
    required this.id,
    required this.accountId,
    required this.name,
    this.description,
    required this.points,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChildcareShopItem.fromJson(Map<String, dynamic> json) {
    return ChildcareShopItem(
      id: json['id'] as String,
      accountId: json['accountId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      points: (json['points'] as num).toInt(),
      isActive: (json['isActive'] as bool?) ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  ChildcareShopItem copyWith({
    String? id,
    String? accountId,
    String? name,
    String? description,
    int? points,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChildcareShopItem(
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

/// 규칙 유형
enum ChildcareRuleType { plus, minus, info }

ChildcareRuleType childcareRuleTypeFromString(String? value) {
  switch (value) {
    case 'PLUS': return ChildcareRuleType.plus;
    case 'MINUS': return ChildcareRuleType.minus;
    default: return ChildcareRuleType.info;
  }
}

String childcareRuleTypeToString(ChildcareRuleType type) {
  switch (type) {
    case ChildcareRuleType.plus: return 'PLUS';
    case ChildcareRuleType.minus: return 'MINUS';
    case ChildcareRuleType.info: return 'INFO';
  }
}

/// 규칙 모델
class ChildcareRule {
  final String id;
  final String accountId;
  final String name;
  final String? description;
  final ChildcareRuleType type;
  final int points;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ChildcareRule({
    required this.id,
    required this.accountId,
    required this.name,
    this.description,
    required this.type,
    required this.points,
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
      type: childcareRuleTypeFromString(json['type'] as String?),
      points: (json['points'] as num?)?.toInt() ?? 0,
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
    ChildcareRuleType? type,
    int? points,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChildcareRule(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      points: points ?? this.points,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// ChildcareTransactionType → API 문자열 변환
String childcareTransactionTypeToString(ChildcareTransactionType type) {
  switch (type) {
    case ChildcareTransactionType.allowance:
      return 'ALLOWANCE';
    case ChildcareTransactionType.reward:
      return 'REWARD';
    case ChildcareTransactionType.bonus:
      return 'BONUS';
    case ChildcareTransactionType.penalty:
      return 'PENALTY';
    case ChildcareTransactionType.purchase:
      return 'PURCHASE';
    case ChildcareTransactionType.cashout:
      return 'CASHOUT';
    case ChildcareTransactionType.savingsDeposit:
      return 'SAVINGS_DEPOSIT';
    case ChildcareTransactionType.savingsWithdraw:
      return 'SAVINGS_WITHDRAW';
    case ChildcareTransactionType.interest:
      return 'INTEREST';
  }
}
