import 'package:family_planner/features/main/household/data/models/expense_model.dart';

// ─────────────────────────────────────────────
// 카테고리별 예산
// ─────────────────────────────────────────────

/// 카테고리별 예산 모델 (category 필수)
class BudgetModel {
  final String id;
  final String groupId;
  final ExpenseCategory category;
  final double amount;
  final DateTime month;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BudgetModel({
    required this.id,
    required this.groupId,
    required this.category,
    required this.amount,
    required this.month,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      category: ExpenseModel.parseCategory(json['category'] as String),
      amount: double.parse(json['amount'].toString()),
      month: DateTime.parse(json['month'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

/// 카테고리별 예산 설정 DTO
class SetBudgetDto {
  final String groupId;
  final ExpenseCategory category;
  final double amount;
  final String month; // YYYY-MM

  const SetBudgetDto({
    required this.groupId,
    required this.category,
    required this.amount,
    required this.month,
  });

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'category': categoryToString(category),
      'amount': amount,
      'month': month,
    };
  }

  static String categoryToString(ExpenseCategory category) {
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
}

// ─────────────────────────────────────────────
// 카테고리별 예산 템플릿
// ─────────────────────────────────────────────

/// 카테고리별 예산 템플릿 모델 (매월 자동 적용)
class BudgetTemplateModel {
  final String id;
  final String groupId;
  final ExpenseCategory category;
  final double amount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BudgetTemplateModel({
    required this.id,
    required this.groupId,
    required this.category,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BudgetTemplateModel.fromJson(Map<String, dynamic> json) {
    return BudgetTemplateModel(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      category: ExpenseModel.parseCategory(json['category'] as String),
      amount: double.parse(json['amount'].toString()),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

/// 카테고리별 예산 템플릿 설정 DTO
class SetBudgetTemplateDto {
  final String groupId;
  final ExpenseCategory category;
  final double amount;

  const SetBudgetTemplateDto({
    required this.groupId,
    required this.category,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'category': SetBudgetDto.categoryToString(category),
      'amount': amount,
    };
  }
}

// ─────────────────────────────────────────────
// 그룹 전체 예산
// ─────────────────────────────────────────────

/// 그룹 전체 예산 모델
class GroupBudgetModel {
  final String id;
  final String groupId;
  final double amount;
  final DateTime month;
  final DateTime createdAt;
  final DateTime updatedAt;

  const GroupBudgetModel({
    required this.id,
    required this.groupId,
    required this.amount,
    required this.month,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GroupBudgetModel.fromJson(Map<String, dynamic> json) {
    return GroupBudgetModel(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      amount: double.parse(json['amount'].toString()),
      month: DateTime.parse(json['month'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

/// 그룹 전체 예산 설정 DTO
class SetGroupBudgetDto {
  final String groupId;
  final double amount;
  final String month; // YYYY-MM

  const SetGroupBudgetDto({
    required this.groupId,
    required this.amount,
    required this.month,
  });

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'amount': amount,
      'month': month,
    };
  }
}

// ─────────────────────────────────────────────
// 그룹 전체 예산 템플릿
// ─────────────────────────────────────────────

/// 그룹 전체 예산 템플릿 모델
class GroupBudgetTemplateModel {
  final String id;
  final String groupId;
  final double amount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const GroupBudgetTemplateModel({
    required this.id,
    required this.groupId,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GroupBudgetTemplateModel.fromJson(Map<String, dynamic> json) {
    return GroupBudgetTemplateModel(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      amount: double.parse(json['amount'].toString()),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

/// 그룹 전체 예산 템플릿 설정 DTO
class SetGroupBudgetTemplateDto {
  final String groupId;
  final double amount;

  const SetGroupBudgetTemplateDto({
    required this.groupId,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'amount': amount,
    };
  }
}
