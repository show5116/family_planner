/// 적립 목표 상태
enum SavingsGoalStatus {
  active,
  paused,
  completed;

  static SavingsGoalStatus fromJson(String? value) {
    switch (value?.toUpperCase()) {
      case 'PAUSED':
        return SavingsGoalStatus.paused;
      case 'COMPLETED':
        return SavingsGoalStatus.completed;
      default:
        return SavingsGoalStatus.active;
    }
  }

  String toDisplayString() {
    switch (this) {
      case SavingsGoalStatus.active:
        return '진행 중';
      case SavingsGoalStatus.paused:
        return '일시 중지';
      case SavingsGoalStatus.completed:
        return '완료';
    }
  }
}

/// 적립 거래 유형
enum SavingsType {
  deposit,
  withdraw,
  autoDeposit;

  static SavingsType fromJson(String? value) {
    switch (value?.toUpperCase()) {
      case 'WITHDRAW':
        return SavingsType.withdraw;
      case 'AUTO_DEPOSIT':
        return SavingsType.autoDeposit;
      default:
        return SavingsType.deposit;
    }
  }

  String toApiString() {
    switch (this) {
      case SavingsType.deposit:
        return 'DEPOSIT';
      case SavingsType.withdraw:
        return 'WITHDRAW';
      case SavingsType.autoDeposit:
        return 'AUTO_DEPOSIT';
    }
  }

  String toDisplayString() {
    switch (this) {
      case SavingsType.deposit:
        return '입금';
      case SavingsType.withdraw:
        return '출금';
      case SavingsType.autoDeposit:
        return '자동 적립';
    }
  }
}

/// 적립 목표 모델
class SavingsGoalModel {
  final String id;
  final String groupId;
  final String name;
  final String? description;
  final double? targetAmount;
  final double currentAmount;
  final bool autoDeposit;
  final double? monthlyAmount;
  final SavingsGoalStatus status;
  final double achievementRate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SavingsGoalModel({
    required this.id,
    required this.groupId,
    required this.name,
    this.description,
    this.targetAmount,
    required this.currentAmount,
    required this.autoDeposit,
    this.monthlyAmount,
    required this.status,
    required this.achievementRate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SavingsGoalModel.fromJson(Map<String, dynamic> json) {
    return SavingsGoalModel(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      targetAmount: json['targetAmount'] != null
          ? double.parse(json['targetAmount'].toString())
          : null,
      currentAmount: double.parse((json['currentAmount'] ?? 0).toString()),
      autoDeposit: (json['autoDeposit'] as bool?) ?? false,
      monthlyAmount: json['monthlyAmount'] != null
          ? double.parse(json['monthlyAmount'].toString())
          : null,
      status: SavingsGoalStatus.fromJson(json['status'] as String?),
      achievementRate: double.parse((json['achievementRate'] ?? 0).toString()),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  SavingsGoalModel copyWith({
    String? id,
    String? groupId,
    String? name,
    String? description,
    double? targetAmount,
    double? currentAmount,
    bool? autoDeposit,
    double? monthlyAmount,
    SavingsGoalStatus? status,
    double? achievementRate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SavingsGoalModel(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      description: description ?? this.description,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      autoDeposit: autoDeposit ?? this.autoDeposit,
      monthlyAmount: monthlyAmount ?? this.monthlyAmount,
      status: status ?? this.status,
      achievementRate: achievementRate ?? this.achievementRate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// 적립 거래 내역 모델
class SavingsTransactionModel {
  final String id;
  final String goalId;
  final SavingsType type;
  final double amount;
  final String? description;
  final DateTime createdAt;

  const SavingsTransactionModel({
    required this.id,
    required this.goalId,
    required this.type,
    required this.amount,
    this.description,
    required this.createdAt,
  });

  factory SavingsTransactionModel.fromJson(Map<String, dynamic> json) {
    return SavingsTransactionModel(
      id: json['id'] as String,
      goalId: json['goalId'] as String,
      type: SavingsType.fromJson(json['type'] as String?),
      amount: double.parse((json['amount'] ?? 0).toString()),
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

/// 적립 거래 내역 목록 조회 결과 (페이지네이션)
class SavingsTransactionListResult {
  final List<SavingsTransactionModel> items;
  final int total;
  final int page;
  final int limit;

  const SavingsTransactionListResult({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory SavingsTransactionListResult.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    return SavingsTransactionListResult(
      items: rawItems
          .map((e) =>
              SavingsTransactionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
    );
  }

  bool get hasMore => (page * limit) < total;
}
