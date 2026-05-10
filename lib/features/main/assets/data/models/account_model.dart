/// 계좌 유형
enum AccountType {
  savings,
  deposit,
  stock,
  fund,
  realEstate,
  gold,
  other,
}

/// AccountType → API 문자열 변환
String accountTypeToString(AccountType type) {
  switch (type) {
    case AccountType.savings:
      return 'SAVINGS';
    case AccountType.deposit:
      return 'DEPOSIT';
    case AccountType.stock:
      return 'STOCK';
    case AccountType.fund:
      return 'FUND';
    case AccountType.realEstate:
      return 'REAL_ESTATE';
    case AccountType.gold:
      return 'GOLD';
    case AccountType.other:
      return 'OTHER';
  }
}

/// API 문자열 → AccountType 변환
AccountType? parseAccountType(String? value) {
  if (value == null) return null;
  switch (value) {
    case 'SAVINGS':
      return AccountType.savings;
    case 'DEPOSIT':
      return AccountType.deposit;
    case 'STOCK':
      return AccountType.stock;
    case 'FUND':
      return AccountType.fund;
    case 'REAL_ESTATE':
      return AccountType.realEstate;
    case 'GOLD':
      return AccountType.gold;
    default:
      return AccountType.other;
  }
}

/// 계좌 모델
class AccountModel {
  final String id;
  final String groupId;
  final String userId;
  final String name;
  final String? accountNumber;
  final String? institution;
  final AccountType? type;
  final double? gramWeight;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double? latestBalance;
  final double? profitRate;

  const AccountModel({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.name,
    this.accountNumber,
    this.institution,
    this.type,
    this.gramWeight,
    required this.createdAt,
    required this.updatedAt,
    this.latestBalance,
    this.profitRate,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      accountNumber: json['accountNumber'] as String?,
      institution: json['institution'] as String?,
      type: parseAccountType(json['type'] as String?),
      gramWeight: json['gramWeight'] != null
          ? double.tryParse(json['gramWeight'].toString())
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
      latestBalance: json['latestBalance'] != null
          ? double.tryParse(json['latestBalance'].toString())
          : null,
      profitRate: json['profitRate'] != null
          ? double.tryParse(json['profitRate'].toString())
          : null,
    );
  }

  AccountModel copyWith({
    String? id,
    String? groupId,
    String? userId,
    String? name,
    String? accountNumber,
    String? institution,
    AccountType? type,
    double? gramWeight,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? latestBalance,
    double? profitRate,
  }) {
    return AccountModel(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      accountNumber: accountNumber ?? this.accountNumber,
      institution: institution ?? this.institution,
      type: type ?? this.type,
      gramWeight: gramWeight ?? this.gramWeight,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      latestBalance: latestBalance ?? this.latestBalance,
      profitRate: profitRate ?? this.profitRate,
    );
  }
}

/// 계좌 생성 DTO
class CreateAccountDto {
  final String groupId;
  final String name;
  final String? accountNumber;
  final String? institution;
  final AccountType? type;
  final double? gramWeight;

  const CreateAccountDto({
    required this.groupId,
    required this.name,
    this.accountNumber,
    this.institution,
    this.type,
    this.gramWeight,
  });

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'name': name,
      if (accountNumber != null) 'accountNumber': accountNumber,
      if (institution != null) 'institution': institution,
      if (type != null) 'type': accountTypeToString(type!),
      if (gramWeight != null) 'gramWeight': gramWeight,
    };
  }
}

/// 계좌 수정 DTO
class UpdateAccountDto {
  final String? name;
  final String? accountNumber;
  final String? institution;
  final AccountType? type;
  final double? gramWeight;

  const UpdateAccountDto({
    this.name,
    this.accountNumber,
    this.institution,
    this.type,
    this.gramWeight,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (accountNumber != null) 'accountNumber': accountNumber,
      if (institution != null) 'institution': institution,
      if (type != null) 'type': accountTypeToString(type!),
      if (gramWeight != null) 'gramWeight': gramWeight,
    };
  }
}
