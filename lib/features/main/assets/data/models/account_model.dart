/// 계좌 유형
enum AccountType {
  bank,
  stock,
  fund,
  insurance,
  realEstate,
  cash,
  other,
}

/// AccountType → API 문자열 변환
String accountTypeToString(AccountType type) {
  switch (type) {
    case AccountType.bank:
      return 'BANK';
    case AccountType.stock:
      return 'STOCK';
    case AccountType.fund:
      return 'FUND';
    case AccountType.insurance:
      return 'INSURANCE';
    case AccountType.realEstate:
      return 'REAL_ESTATE';
    case AccountType.cash:
      return 'CASH';
    case AccountType.other:
      return 'OTHER';
  }
}

/// API 문자열 → AccountType 변환
AccountType? parseAccountType(String? value) {
  if (value == null) return null;
  switch (value) {
    case 'BANK':
      return AccountType.bank;
    case 'STOCK':
      return AccountType.stock;
    case 'FUND':
      return AccountType.fund;
    case 'INSURANCE':
      return AccountType.insurance;
    case 'REAL_ESTATE':
      return AccountType.realEstate;
    case 'CASH':
      return AccountType.cash;
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
  final String institution;
  final AccountType? type;
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
    required this.institution,
    this.type,
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
      institution: json['institution'] as String,
      type: parseAccountType(json['type'] as String?),
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
  final String institution;
  final AccountType? type;

  const CreateAccountDto({
    required this.groupId,
    required this.name,
    this.accountNumber,
    required this.institution,
    this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'name': name,
      if (accountNumber != null) 'accountNumber': accountNumber,
      'institution': institution,
      if (type != null) 'type': accountTypeToString(type!),
    };
  }
}

/// 계좌 수정 DTO
class UpdateAccountDto {
  final String? name;
  final String? accountNumber;
  final String? institution;
  final AccountType? type;

  const UpdateAccountDto({
    this.name,
    this.accountNumber,
    this.institution,
    this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (accountNumber != null) 'accountNumber': accountNumber,
      if (institution != null) 'institution': institution,
      if (type != null) 'type': accountTypeToString(type!),
    };
  }
}
