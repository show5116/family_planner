import 'package:family_planner/features/main/assets/data/models/withdrawal_model.dart';

enum AssetRecordEntryType { snapshot, withdrawal }

/// 자산 기록 통합 모델 (SNAPSHOT + WITHDRAWAL)
class AssetRecordModel {
  final AssetRecordEntryType entryType;
  /// 정렬용 공통 날짜 (SNAPSHOT: recordDate, WITHDRAWAL: withdrawalDate)
  final DateTime date;

  // ── SNAPSHOT 전용 ──
  final String id;
  final String accountId;
  final DateTime recordDate;
  final double balance;
  final double principal;
  final double profit;
  final double? profitRate;
  final double? gramWeight;
  final String? note;
  final DateTime createdAt;

  // ── WITHDRAWAL 전용 ──
  final double? amount;
  final WithdrawalType? withdrawalType;

  const AssetRecordModel({
    required this.entryType,
    required this.date,
    required this.id,
    required this.accountId,
    required this.recordDate,
    required this.balance,
    required this.principal,
    required this.profit,
    this.profitRate,
    this.gramWeight,
    this.note,
    required this.createdAt,
    this.amount,
    this.withdrawalType,
  });

  bool get isSnapshot => entryType == AssetRecordEntryType.snapshot;
  bool get isWithdrawal => entryType == AssetRecordEntryType.withdrawal;

  factory AssetRecordModel.fromJson(Map<String, dynamic> json) {
    final typeStr = json['entryType'] as String? ?? 'SNAPSHOT';
    final entryType = typeStr == 'WITHDRAWAL'
        ? AssetRecordEntryType.withdrawal
        : AssetRecordEntryType.snapshot;

    final date = DateTime.parse(
      (json['date'] ?? json['recordDate'] ?? json['withdrawalDate']) as String,
    ).toLocal();

    return AssetRecordModel(
      entryType: entryType,
      date: date,
      id: json['id'] as String,
      accountId: json['accountId'] as String,
      recordDate: DateTime.parse(
        (json['recordDate'] ?? json['withdrawalDate'] ?? json['date']) as String,
      ).toLocal(),
      balance: double.tryParse(json['balance']?.toString() ?? '') ?? 0,
      principal: double.tryParse(json['principal']?.toString() ?? '') ?? 0,
      profit: double.tryParse(json['profit']?.toString() ?? '') ?? 0,
      profitRate: json['profitRate'] != null
          ? double.tryParse(json['profitRate'].toString())
          : null,
      gramWeight: json['gramWeight'] != null
          ? double.tryParse(json['gramWeight'].toString())
          : null,
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      amount: json['amount'] != null
          ? double.tryParse(json['amount'].toString())
          : null,
      withdrawalType: parseWithdrawalType(json['type'] as String?),
    );
  }
}

/// 자산 기록 입력 방식
enum RecordInputMode { manual, auto }

/// 자산 기록 생성 DTO
class CreateAssetRecordDto {
  final String recordDate; // YYYY-MM-DD
  final RecordInputMode inputMode;
  // manual 필드
  final double? balance;
  final double? principal;
  final double? profit;
  // auto 필드
  final double? currentBalance;
  final double? additionalPrincipal;
  final String? note;

  const CreateAssetRecordDto({
    required this.recordDate,
    required this.inputMode,
    this.balance,
    this.principal,
    this.profit,
    this.currentBalance,
    this.additionalPrincipal,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'recordDate': recordDate,
      'inputMode': inputMode.name,
      if (balance != null) 'balance': balance,
      if (principal != null) 'principal': principal,
      if (profit != null) 'profit': profit,
      if (currentBalance != null) 'currentBalance': currentBalance,
      if (additionalPrincipal != null) 'additionalPrincipal': additionalPrincipal,
      if (note != null) 'note': note,
    };
  }
}
